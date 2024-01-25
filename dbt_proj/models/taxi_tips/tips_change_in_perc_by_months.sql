/*
изменение суммы чаевых в процентах в последующие месяцы 
(после апреля 2018) по сравнению с каждым предыдущим в 
таблице для трех машин, получивших наибольшее количество 
чаевых в апреле 2018 года
*/
/*
{{
    config(
        materialized ='incremental'
    )
}}
*/

{{
    config(
        materialized = 'view'
    )
}}


select 
    taxi_id, 
    CAST(year_month AS DATE) as year_month, 
    tips_sum, 
    (COALESCE(
        tips_sum / NULLIF(
                        LAG(tips_sum) 
                        OVER(
                            PARTITION BY taxi_id 
                            ORDER BY year_month),0), 
        NULL) - 1) * 100 AS tips_change
from
    {{ref("tips_by_months")}}
    
 /* 
    {% if is_incremental() %}
        where year_month > (select max(year_month) from {{ this }})
    {% endif %}
*/

order by
    year_month, 
    taxi_id
