select 
    od.order_id, od.product_id, od.unit_price, od.quantity, --p.product_name, p.supplier_id, p.category_id,
    round((od.unit_price * quantity), 2) as total,
    round(((p.unit_price * quantity) - total), 2) as real_discount
from {{source('sources', 'order_details')}} as od
left join {{source('sources', 'products')}} as p on od.product_id = p.product_id