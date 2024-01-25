/* 
Сумма чаевых за каждый последующий месяц 
(по умолч-ю: после Апреля 2018) для машин, набравших 
наибольшие чаевые в указанный период
По умолчанию: в Апреле 2018. 
*/ 


---- Для изменения условий:
--{% set date_of_start =  '2018-04-01 00:00:00' %}

/*
{{
    config(
        materialized='incremental'
    )
}}
*/

select 
    taxi_tips_tab.taxi_id as taxi_id, 
    DATE_TRUNC(trip_start_timestamp, MONTH) AS year_month, 
    SUM(tips) AS tips_sum
from 
    {{source('chicago_taxi_trips', 'trips')}}  as taxi_tips_tab,
    {{ ref('cars_with_biggest_tips') }} as found_cars

  /*  {% if is_incremental() %}
        where trip_start_timestamp > (select max(trip_start_timestamp) from {{ this }})
    {% endif %}
  */  
where 
    taxi_tips_tab.taxi_id = found_cars.taxi_id
    AND trip_start_timestamp >= '{{ var('date_of_start')}}'
group by 
    year_month, 
    taxi_id
order by
    year_month, 
    taxi_id, 
    tips_sum
