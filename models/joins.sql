with etapa1 as (
    select
        p.product_id, p.product_name, p.unit_price, s.company_name as supplier, c.category_name 
    from {{source('sources', 'products')}} as p
    left join {{source('sources', 'categories')}} as c on p.category_id = c.category_id 
    left join {{source('sources', 'suppliers')}} as s on p.supplier_id = s.supplier_id
), etapa2 as (
    select od.order_id, od.quantity, od.real_discount, e1.*
    from {{ref('orderdetails')}} as od
    left join etapa1 as e1 on od.product_id = e1.product_id
), etapa3 as ( -- Junção de orders + customers + shippers = Modelo 3
    select
        ord.order_date, ord.order_id, cs.company_name as customer, em.name as employee, em.age, em.length_service 
    from {{source('sources', 'orders')}} as ord
    left join {{ref('customers')}} as cs on ord.customer_id = cs.customer_id
    left join {{ref('employees')}} as em on ord.employee_id = em.employee_id
    left join {{source('sources', 'shippers')}} as sh on ord.ship_via = sh.shipper_id
), finaljoin as (
    select e2.*, e3.order_date, e3.customer, e3.employee, e3.age, e3.length_service
    from etapa2 as e2
    inner join etapa3 as e3 on e2.order_id = e3.order_id  
)
select * from finaljoin