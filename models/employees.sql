-- Modelo 2
select
    *,
    datediff(year, birth_date, current_date) as age,
    datediff(year, hire_date, current_date) as length_service,
    first_name || ' ' || last_name as name
from {{source('sources', 'employees')}}