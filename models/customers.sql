-- Customer model
with janela as (
    select *,
    first_value(customer_id)
    over(partition by company_name, contact_name
    order by company_name 
    rows between unbounded preceding and unbounded following 
    ) as resultado
    from {{source('sources', 'customers')}}
), distintos as (
    select distinct resultado
    from janela
), final as (
    select * from {{source('sources', 'customers')}}
    where customer_id in (select resultado from distintos)
)

select * from final