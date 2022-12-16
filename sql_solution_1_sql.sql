with base1 as -- finding first_date and first_order_date for each user_id
(select 
user_id,
min(date(event_date)) first_date,
min(case when event_type = 'order' then date(event_date) else null end) first_order_date
from events
group by 1),
base2 as -- finding products_added_to_cart, page_types, event_types for each event_date, user_id
(select 
date(event_date) as event_date,
user_id,
count(distinct case when event_type = 'add_to_cart' then product else null end) products_added_to_cart,
string_agg(distinct page_type, ',' order by page_type) page_types,
string_agg(distinct event_type, ',' order by event_type) event_types
from events 
group by 1, 2),
final_results as -- joining the results for further querying
(select 
b2.event_date,
b2.user_id,
first_date,
first_order_date,
products_added_to_cart,
page_types,
event_types
from base2 b2
left join base1 b1 on b2.user_id = b1.user_id)
select -- calculating the requested metrics
event_date,
count(distinct case when event_date = first_date 
and page_types = 'product_page' 
and event_types = 'page_view' 
then user_id else null end) only_viewed_products_in_their_first_session,
count(distinct case when products_added_to_cart = 1
then user_id else null end) added_only_one_product_to_the_basket,
count(distinct case when event_date = first_order_date
and date_part('day', first_order_date::timestamp - first_date::timestamp) = 2
then user_id else null end) placed_an_order_within_two_days_time_after_the_first_session
from final_results
group by 1
order by 1