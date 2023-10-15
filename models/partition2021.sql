-- Partition 2021
select * from {{ref('joins')}}
where date_part(year, order_date) = 2021