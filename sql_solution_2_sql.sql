with base as
(select 
user_id,
min(date(event_date)) first_date,
max(date(event_date)) max_date,
count(distinct date(event_date)) days,
min(case when event_type = 'order' then date(event_date) else null end) first_order_date,
count(case when event_type = 'page_view' then 1 else null end) page_view_events,
count(case when event_type = 'add_to_cart' then 1 else null end) add_to_cart_events,
count(case when event_type = 'order' then 1 else null end) order_events
from events
group by 1),
processed_base as 
(select 
user_id,
first_date, 
max_date,
case when first_date = max_date then 'one-day user' else 'returning user' end user_type,
days,
first_order_date,
page_view_events,
case when add_to_cart_events = 0 then null else add_to_cart_events end add_to_cart_events,
case when order_events = 0 then null else order_events end order_events
from base),
outliers as
(select 
user_type,
percentile_cont(0.90) within group (order by days) p_90_days,
percentile_cont(0.90) within group (order by page_view_events) p_90_page_view_events,
percentile_cont(0.99) within group (order by order_events) p_99_order_events
from processed_base
group by 1),
final_results as
(select 
pb.*,
case when coalesce(page_view_events, 0) = 0
or (coalesce(add_to_cart_events, 0) < order_events) then true else false end ground_condition, --data quality check
case when pb.user_type = 'one-day user' 
and page_view_events >= p_90_page_view_events 
and add_to_cart_events = 0 
and order_events = 0
then true else false end first_condiditon, --one-day user with many pages viewed but no add_to_cart or order events
case when pb.user_type = 'returning user' 
and days >= p_90_days
and page_view_events >= p_90_page_view_events
and order_events = 0
then true else false end second_condition, --returning user who visits the website more regularly than the others but doesn't buy anything
case when pb.user_type = 'one-day user'
and order_events >= p_99_order_events
then true else false end third_condition --one-day user who places a lot of orders (more than 99% of other one-day users) during their first day
from processed_base pb
join outliers o on pb.user_type = o.user_type)
select *
from final_results 
where ground_condition or first_condiditon or second_condition or third_condition