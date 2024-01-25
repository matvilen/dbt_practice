/*
Три машины, получившие наибольшее количество чаевых 
По умолчанию: в апреле 2018 года 
*/

-- Для изменения условий:
--{% set numb_of_cars = 3 %}
--{% set dates_period =  ['2018-04-01 00:00:00', '2018-04-30 23:59:59'] %}


select 
    taxi_id
from 
    {{source('chicago_taxi_trips', 'trips')}} 
where 
    trip_start_timestamp between "{{ var('dates_period')[0]}}" and "{{ var('dates_period')[1]}}"
group BY
    taxi_id
order BY 
    SUM(tips) desc
limit {{ var('numb_of_cars') }}
