# Test-Task-2
Marketing Funnel Analysis (Python, SQL, Tableau), SQL Tasks
# Tasks
## Part 1 - Main

Deliverables:
* The achieved result must be presented in form of a report/dashboard with any suitable
BI tool;
* Calculations are done in SQL or Python;
* The results of the analysis and the logic of the calculations should be presented to the
product team informatively and to be understandable to the entire team, which
includes technical and non-technical specialists.

Dataset Description:
__event_date__ - Timestamp of the event
__session__ - Session ID
__user__ - User ID
__page_type__ - Type of the page
__event_type__ - Type of the event
__product__ - Product ID

### Solution Details

Files:
* __sql_solution_python.ipynb__ - a jupyter notebook that was used to explore the data in the very beginning of the task completion. Also, it's needed to create a table and export the data from the file into the newly created Postgres table;
* * __Test Task 2.pdf__ - that's a little presentation containing a very high-level summary about the first page's influence mainly.
Also, here is a [Tableau Public Dashboard](https://public.tableau.com/app/profile/kseniiakaranda/viz/FunnelAnalysis_16711702027440/FunnelAnalysis).

## Part 2 - SQL

1. Write an SQL request that will return a number of clients by day (certain conditions...);
2. Write a request that will return any abnormal (to our view) user behavior.

### Solution Details

Files:
* __sql_solution_1_sql.sql__ - this file contain one query that answers all of the three questions mentioned in the first point of the second part of the task;
* __sql_solution_2_sql.sql__ - this file contains the query that should search for anomalies. The anomalies are described in the comments. They need to be monitored because there seems to be some data inconcictency & other (more details can be found below);
* __sql_solution_python.ipynb__ - already described this file.

Point 2 of Part 2 of the Test Task 2 :)
_ground_condition_ - data consistency check;
_first_condiditon_ - "one-day user with many pages viewed but no add_to_cart or order events" - it's interesting to track those who seem to have trouble with finding what exactly they need or with using the product;
_second_condition_ - "returning user who visits the website more regularly than the others but doesn't buy anything" - might be useful to keep track of those who overall share the previous pattern but they still "stick" with the product;
_third_condition_ - "one-day user who places a lot of orders (more than 99% of other one-day users) during their first day" - even if there is no possibility to benefit from the fraudulent schemes for the new users, they still need checking on to make sure they placed the right orders for the right pieces of items and everything else looks OK.
