
select
     last_name, first_name, points, points * 1.1 as 'increased price'
from customers;

select state
from customers;

select distinct  state
from customers;

select *
from customers
where birth_date > '1991-01-01';

select *
from customers
where birth_date > '1991-01-01' and points > 1000;

select *
from customers
where birth_date > '1991-01-01' or points > 1000;


select *
from customers
where birth_date > '1991-01-01' or
      (points > 1000 and state = 'VA');

select *
from customers
where NOT (birth_date > '1991-01-01' or points > 1000);

select *
from order_items
where order_id = 6 and unit_price * quantity> 30;


select *
from customers
where state = 'VA' or state = 'GA' or state = 'FL';

select *
from customers
where state in ('VA', 'GA', 'FL');

select *
from customers
where state not in ('VA', 'GA', 'FL');

select *
from products
where quantity_in_stock in (49, 38, 72);


select *
from customers
where points between 1000 and 3000;

select *
from customers
where birth_date between  '1991-01-01' and '2000-01-01';

-- get the customers whose addresses contains trail or avenue
select *
from customers
where address like '%trail%' or address like '%avenue%' ;

-- phone numbers end with 9
select *
from customers
where phone like '%9';

-- '_' shows the exact characters in the like operator

select *
from customers
where customers.last_name like '_____y';

-- working with regular expressions
-- caret sign (^) indicates the beginning of a string
-- dollar sign ($) indicates the end of a string
select *
from customers
where last_name like '%field%';

select *
from customers
where last_name regexp 'field';
-- caret sign in regexp
select  *
from customers
where last_name regexp '^field';
-- dollar sign ($)
select *
from customers
where last_name regexp  'field$';

-- pipe sign or vertical bar used as logical or in regexp
select *
from customers
where last_name regexp  'field|mac|rose';

select *
from customers
where last_name regexp '^field|mac|rose';

select *
from customers
where  last_name regexp  'field$|mac|rose';
select *
from customers
where last_name regexp  '[gim]e'; -- explanation is listed below :)
-- ge
-- ie
-- me
-- for avoiding verbose we use [a-h] instead of abcdefh

-- exercise
-- get the customers whose first names are ELKA or AMBUR
select *
from customers
where  first_name regexp 'elka|ambur';

-- last names ends with Ey or ON
select *
from customers
where last_name regexp 'ey$|on$';

-- last names start with MY or contains SE
select *
from customers
where last_name regexp '^my|se';

-- last names contain B followed by R or U
select *
from customers
where last_name regexp 'b[ru]';

-- finding NULL values
select *
from customers
where phone is null;

select *
from customers
where phone is not null;

-- exercise
-- get the orders that are not shipped yet
select *
from orders
where shipper_id is null;

select * from sql_store.orders; -- for seeing orders table we use this statement

-- sort customers table by their name
select *
from  customers
order by first_name;

select *
from customers
order by first_name desc;

select  *
from  customers
order by  state, first_name; -- first ordered by state and then where the states are similar they ordered by name

-- in mysql we can order any columns whether this column is in select class or not for example:
select first_name, last_name
from customers
order by birth_date;

-- sorting data by an alias
select first_name, last_name, 10 as points
from customers
order by  first_name, last_name, points;

-- we can sort data by column positions but it is recommended that we avoid doing that
select first_name, last_name, 10 as points
from customers
order by 1,2;

select * from order_items;

-- exercise
-- select items by order number 2 and select them by total price in descending order
select *,  unit_price*quantity as 'total price'
from order_items
where order_id = 2
order by `total price`  desc;

-- working with limit
select *
from customers
limit 3;

-- wanna skip 6 cells then
select *
from customers
limit 6, 3;

-- exercise
-- get the top three loyal customers (the customers that have more points than everyone else
select * from customers
order by points desc
limit 3;

-- inner joins------------------------------------------------------------------------------------------------------
select * from sql_store.orders
join customers
on customers.customer_id = orders.customer_id;

select order_id, first_name, last_name
from orders
join customers
    on customers.customer_id = orders.customer_id;
-- if we wanna have customer_id in select line for showing customer id, we get an error because sql could not
-- recognise from which table it should pick up the column, therefore, we should identify it by customer.customer_id
-- or orders.customer_id
select order_id, first_name, last_name, orders.customer_id
from orders
join customers
    on customers.customer_id = orders.customer_id;

-- in order to prevent from repetition we should use aliases after the names of column
select order_id, first_name, last_name, o.customer_id
from orders o
join customers c
    on c.customer_id = o.customer_id;

-- exercise
-- join the table orders with product table that returns order_id with the name of products beside product id
select oi.order_id, oi.product_id, oi.quantity, oi.unit_price
from order_items oi
join products p
on oi.product_id = p.product_id;

-- joining across databases---------------------
select  *
from order_items oi
join sql_inventory.products  p  -- because this is another database, we use dot for calling the table products
    on oi.product_id = p.product_id;

use sql_inventory;
select *
from sql_store.order_items oi
join products p on oi.product_id = p.product_id;

 -- self joins ---------------------------------------------
use sql_hr;
select *
from employees e
join employees m on e.reports_to = m.employee_id;

select e.employee_id, e.first_name, m.first_name as manager
from employees e
join employees m on e.reports_to = m.employee_id;

 -- joining multiple tables ----------------------------------
use sql_store;
select * from customers as c
join orders o on o.customer_id = c.customer_id
join order_statuses os on o.status = os.order_status_id;

-- lets free from confusion
select o.order_id, o.order_date, c.first_name, c.last_name, os.name as status
from orders as o
join customers c  on o.customer_id  = c.customer_id
join order_statuses os on o.status = os.order_status_id

use sql_invoicing;
select * from payments as p
join payment_methods pm on p.payment_method = pm.payment_method_id
join clients c on c.client_id = p.client_id;

select p.date, p.invoice_id, p.amount, c.name, pm.name from payments p
join payment_methods pm on p.payment_method = pm.payment_method_id
join clients c on c.client_id = p.client_id;























