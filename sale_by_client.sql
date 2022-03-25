create or replace view sale_by_client as
select client_id,
       name,
       sum(invoice_total) as total
from clients c
join invoices using(client_id)
group by  client_id, name;