

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

select * from sql_store.orders; -- for seeing orders in sql_store table we use this statement

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

-- in mysql we can order any columns whether this column is in select clause or not for example:
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
order by 'total price'  desc;

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

-- compound join conditions used especially for composite keys; composite keys are those that two columns are responsible for showing uniqueness--------
use sql_store;
select * from order_items oi
join order_item_notes oin on oi.order_id = oin.order_Id
and oi.product_id = oin.product_id;

-- implicit join syntax--------------------------------------
select *
from customers c
join orders o on c.customer_id = o.customer_id; -- explicit join syntax

-- if we want to write implicit syntax instead of above explicit syntax we can rewrite it as  follows:
select *
from customers c, orders o
where o.customer_id = c.customer_id;
-- it is important to know that it is better to use explicit syntax because when we forget "where" we can
-- have thousands of cells that are connected incorrectly

-- outer join--------------------------------------------------------------------------------
-- an example of normal inner join
select
    c.customer_id,
    c.first_name,
    o.order_id
from customers c
join orders o on c.customer_id = o.customer_id
order by c.customer_id;

-- we only see the customers that have order in our system, we want to see the customers weather
-- they have order or not
select
    c.customer_id,
    c.first_name,
    o.order_id
from customers c
left join orders o on c.customer_id = o.customer_id -- all the records from left table
-- (customers) either the condition is true or not are listed
order by c.customer_id;

-- code bellow shows that all the records in the right side will be showed when the condition is true
select
    c.customer_id,
    c.first_name,
    o.order_id
from customers c
right join orders o on c.customer_id = o.customer_id -- all the records from left table
-- (customers) either the condition is true or not are listed
order by c.customer_id;

-- exercise ---
select p.product_id,
       p.name,
       oi.quantity
from products p
    left join order_items oi on p.product_id = oi.product_id;

-- outer joins between multiple tables---------------------------------------
select
    c.customer_id,
    c.first_name,
    o.order_id,
    sh.name as shipper
from customers c
left join orders o on c.customer_id = o.customer_id -- all the records from left table
left join shippers sh on sh.shipper_id = o.shipper_id
-- (customers) either the condition is true or not are listed
order by c.customer_id;

-- exercise
select o.order_date,
       o.order_id,
       c.first_name,
       sh.name as shipper,
       os.name as status
from customers c
join orders o on o.customer_id = c.customer_id
left join shippers sh on o.shipper_id = sh.shipper_id
join order_statuses os
    on o.status = os.order_status_id;

-- self outer join--------------------------------------------
use sql_hr;
select * from employees;
select e.employee_id, e.first_name, m.first_name as manager
from employees e
left join employees m on e.reports_to = m.employee_id;

-- the using clause-------------------------------------
-- if we have two columns with the same name we use using instead of join on clause
-- and also when we have composite primary key instead of primary keys we can use it
-- two columns with same name in two different tables
use sql_store;
select o.order_id, c.first_name, sh.name as shipper
from customers c
join orders o on c.customer_id = o.customer_id
left join shippers sh on o.shipper_id = sh.shipper_id;
-- this query is as same as above
select o.order_id, c.first_name, sh.name as shipper
from customers c
join orders o using(customer_id)
left join shippers sh using(shipper_id);

-- using "using clause" in composite primary key example
select *
from order_items oi
join order_item_notes oin on oi.order_id = oin.order_Id
and oi.product_id = oin.product_id;
-- instead we can use
select *
from order_items oi
join order_item_notes oin using(product_id, order_id);

-- exercise
-- using payment table we create a table with data/client/amount/name on columns
use sql_invoicing;
select p.date, cl.name as client, p.amount, pm.name
from clients as cl
join payments p using(client_id)
join payment_methods pm on p.payment_method = pm.payment_method_id;

-- natural joins------------------ let system join common columns by itself--------------------------
use sql_store;
select c.first_name, o.order_id
from customers c
natural join orders o;

-- cross join-----------------------------------------------------------------------
-- joining every record from first table with every record with second table-- this is an explicit syntax for cross join
select c.first_name as customer, p.name as product
from customers c
cross join products p
order by first_name;

-- implicit syntax for cross join
select c.first_name as customer, p.name as product
from customers c, products p
order by  first_name;

-- unions --------------------- we use for combining rows--------------------
 select o.order_id, o.order_date,  'Active' as status
from orders o where order_date >= '2019-01-30'
union
select o.order_id, o.order_date,  'Archived' as status
from orders o where order_date < '2019-01-30';

-- exercise
select customer_id, first_name, points, 'Bronze' as type
from customers
where points<2000
union
select customer_id, first_name, points, 'Silver' as type
from customers
where 2000<points<3000
union
select customer_id, first_name, points, 'Gold' as type
from customers
where points>2000
order by  first_name;
-- inserting a single row------------------------------------------------------------
-- first way
insert into  customers
values(default, 'John', 'Smith', '1990-01-01', null, 'address', 'City', 'CA', default);
-- second way
insert into  customers(first_name, last_name, birth_date, address, city, state)
values('John', 'Smith', '1990-01-01','address', 'City', 'CA');

-- inserting multiple rows---------------------------------------------------------------------
insert into shippers(name)
values ('shipper1'),
       ('shipper2'),
       ('shipper3');
-- exercise ---- insert 3 rows in product table
insert into  products
values(default, 'Water', 10, 1), (default, 'Milk', 30, 2.5), (default, 'rice', 40, 55);

-- inserting hierarchical rows  ---------------------------------------------------------------
-- it is used when we have parent and children relation between tables for example we add a new row in a parent table
-- then we need to update children row as well
insert into  orders(customer_id, order_date, status)
values (1, '2019-01-01', 1);

insert into order_items
values (last_insert_id(), 1,1,2.95),
       (last_insert_id(), 2, 1, 3.95);
-- creating a copy of a table ----------------------------------------------------------
create table  archived_orders as
    select * from orders;

insert into archived_orders
-- sub-query in an insert statement
select * from orders
where order_date < '2019-01-01';
-- temp
-- alter  view vw_HighLoyaltyChicagoCustomers as
-- select c.*, o.order_date from customers c
-- join orders o on  c.customer_id = o.customer_id
-- where c.city = 'Chicago' and points > 3000;

-- select * from vw_HighLoyaltyChicagoCustomers
-- exercise -----------------
use sql_invoicing;
create  table  archived_invoices as
select c.client_id, c.name as client_name, inv.payment_total, inv.payment_date
from invoices as inv
join clients c using(client_id)
where payment_date is not NULL;

-- updating a single row----------------------------------------------------------------
update invoices
set payment_total = 10, payment_date = '2019-03-01'
where invoice_id = 1;

update invoices
set payment_total = 0, payment_date = null
where invoice_id = 1;

update invoices
set payment_total = invoice_total * 0.5, payment_date = due_date
where invoice_id = 3;

-- updating multiple rows -------------------------------------------------
update invoices
set payment_total = invoice_total * 0.5, payment_date = due_date
where client_id = 3;

update invoices
set payment_total = invoice_total * 0.5, payment_date = due_date
where client_id in (3,4);

-- exercise ---------------------------------------
-- write a SQL statement to
-- give any customers born before 1990
-- 50 extra points

use sql_store;
update customers
set points = points+50
where birth_date < '1990-01-01';

-- using sub-queries in an update statement --------------------------------------------------------
use sql_invoicing;
update invoices
set
    payment_date = invoice_total * 0.5,
    payment_date = due_date
where client_id = 3; -- we wanna chane this using select as a sub-query ------>

-- start
-- consider we have only the name of clients in an application therefore we should find client id that are related to the client name and then update it
select client_id
from clients
where name = 'Myworks'; -- we can use this select statement as a sub query from update ------->


update invoices
set
    payment_date = invoice_total * 0.5,
    payment_date = due_date
where client_id =
            (select client_id
            from clients
            where name = 'Myworks'); -- when we have more than one client ----------> for example ------->

update invoices
set
    payment_date = invoice_total * 0.5,
    payment_date = due_date
where client_id =
            (select client_id
            from clients
            where state in ('CA', 'NY')); -- because this sub-query returns multiple records, we can delete "=" -------->

update invoices
set
    payment_date = invoice_total * 0.5,
    payment_date = due_date
where client_id in
            (select client_id
            from clients
            where state in ('CA', 'NY'));

-- exercise --
-- update comments of customers as a gold customer where they points are greater than 3000
use sql_store;

update orders
set comments = 'Gold customer'
where customer_id in
      (select customer_id
      from customers
      where points > 3000)

-- deleting data in SQL--------------------------
use sql_invoicing;
delete from invoices
where client_id = (
    select client_id
    from clients
    where name = 'Myworks'
);

-- working with  functions  (aggregate functions) ------------------------------------------
use  sql_invoicing;
select max(invoice_total)
from invoices;
-- we can expand it as:
select max(invoice_total) as highest,
       min(invoice_total) as lowest,
       avg(invoice_total) as average,
       sum(invoice_total) as total,
       count(invoice_total) 'as number of invoices', -- returns non-null values
       count(payment_date) as count_of_payments,
       count(*) as total_records
from invoices;
-- we can use them for date
select max(payment_date) as highest
from invoices;

-- we can have expressions in parantheses
select sum(invoice_total * 1.1) as wheighted
from invoices;
-- we can have where clauses too
select min(invoice_total)
from invoices
where invoice_date> '2017-01-01';

select  count(client_id) -- does not care about duplication
from invoices;
-- for considering unique values:
select count(distinct client_id)
from invoices;

-- exercise---

select 'first half of 2019' as date_range,
       sum(invoice_total) as total_sales,
       sum(payment_total) as total_payments,
       sum(invoice_total)-sum(payment_total) as what_we_expect
from invoices where invoice_date <= '2019-06-30'

union

select 'second half of 2019' as date_range,
       sum(invoice_total) as total_sales,
       sum(payment_total) as total_payments,
       sum(invoice_total-payment_total) as what_we_expect
from invoices where invoice_date > '2019-06-30'

union

select 'Total' as date_range,
       sum(invoice_total) as total_sales,
       sum(payment_total) as total_payments,
       sum(invoice_total-payment_total) as what_we_expect
from invoices;

-- group by functions---------------------------------------

select sum(invoice_total)
from invoices
group by client_id;

select client_id,
       sum(invoice_total) as total_sales
from invoices
where invoice_date > '2019-07-01' -- where clause is before than group by always
group by client_id;

select state, city, sum(invoice_total)
from invoices  inv
join clients c using(client_id)
group by state, city;

-- exercise--
select date, name, sum(amount) as total_payments
from payment_methods pm
join payments p on pm.payment_method_id = p.payment_method
group by  date, payment_method
order by date asc ;

-- having clause----------------- we use "having clause" for filtering data after our rows are grouped, but we use "where clause" before our rows are grouped
-- it is like where clause but with two differences: first: it is used after creating a group, second: it knows only the columns that we called in
-- select clause

select client_id, sum(invoice_total) as total_payments
from invoices
-- where total_payments > 300 -- that is wrong, because where cannot detect new column
group by client_id
having total_payments > 500;

select client_id, sum(invoice_total) as total_payments,
       count(*) as number_of_invoices
from invoices
group by client_id
having total_payments > 500 and number_of_invoices > 5;

-- exercise--
-- get the customers
-- located in virginia
-- who have spent more than 100$

select  customer_id, first_name,last_name,state, sum(invoice_total) as total from sql_store.customers c
join sql_invoicing.invoices si on c.customer_id = si.client_id
where state = 'VA'
group by customer_id
having total>100;

-- roll up function ------------------ it is only available in mysql-------------------------------------------------------------
-- we use it for summarizing
use sql_invoicing;
select  client_id, sum(invoice_total) as total
from invoices
group by client_id with rollup;


select  state,
        city,
        sum(invoice_total) as total
from invoices i
join clients c using(client_id)
group by state, city with rollup;

select name as payment_method, sum(amount) as total from payments p
join payment_methods pm on p.payment_method = pm.payment_method_id
group by payment_method with rollup ;

-- writing complex queries----------------------------------------------------------
-- find products that are more expensive than Lettuce
use sql_store;
select * from products
where unit_price > (
    select unit_price from products
    where  product_id = 3
);

-- we can write sub-queries in the select clause and in the from clause too
-- exercise --
-- in sql_store find the employees whose earn more than average
use sql_hr;
select * from employees
where salary > (
          select avg(salary)
          from employees
      );
use sql_store;
select name, sum(quantity) as sum_products from  order_items o
right join products p using(product_id)
group by name
order by sum_products asc;

-- the in operator------------------------------------------------------
-- select items that are not ordered at all
select distinct product_id from order_items;

select * from products
where product_id not in (
    select distinct product_id
    from order_items
    );

-- exercise---
-- find clients without invoices
use sql_invoicing;

select * from clients
where client_id not in(
    select distinct client_id from invoices
);

-- sub-queries vs join----------------------------------------------------------
-- sub-queries can make queries complex, then it is better to use join
-- the above example can be written as:
select * from clients -- this a readable solution--
left join invoices using(client_id)
where invoice_id is null;

-- exercise--
-- find customers who have ordered Lettuce (id =3)
use sql_store;
select  customer_id, first_name, last_name, name from  order_items
join products using(product_id)
join orders using (order_id)
join customers using (customer_id)
where product_id = 3;

-- exercise--
-- find customers who have ordered Lettuce (id =3) -- using sub-query
select * from customers
where customer_id in (
    select o.customer_id from order_items oi
    join orders o using(order_id)
    where product_id = 3
    );
-- the ALL keyword----------------------------------------------------------------------
-- it chooses the largest number by comparing them
-- select invoices larger than all invoices of client 3
use sql_invoicing;
-- common method
select * from invoices
where invoice_total > (
    select max(invoice_total)
    from invoices
    where client_id = 3
);
-- using all
select * from invoices
where invoice_total > all (
    select invoice_total
    from invoices
    where client_id = 3
    group by client_id
); -- both of methods are good;

-- any or some keywords (they are equivalent)---------------------------------------------------------
-- select clients with at least two invoices
-- common method--
select  * from clients
where client_id in (
    select client_id
    from invoices
    group by client_id
    having count(client_id) >= 2
);
-- using any
-- =any = in

select  * from clients
where client_id = any (
    select client_id
    from invoices
    group by client_id
    having count(client_id) >= 2
);

-- correlated sub-queries----------------------------------------------------------------------------
-- select employees whose salary is above the average in their office
use sql_hr;
-- below does not work because we get more than one row in where clause
select *
from employees
where salary > (
    select avg(salary)
    from employees
    group by office_id
);
-- instead we use correlated sub-queries
select *
from employees e
where salary > (
    select avg(salary)
    from employees
    where office_id = e.office_id
);

-- exercise--
-- get invoices that are larger than the clients average invoice amount
use sql_invoicing;
select * from invoices i
where invoice_total > (
    select avg(invoice_total)
    from invoices
    where invoices.client_id = i.client_id
);

-- the exists operator ------------------------------------------------------------------------------------------------

-- select clients that have invoices
-- when we use the in operator, the sub-query in the where clause is run at first
-- if we have a large amount of data the sub-query will return a very large list that will have a negative impact on the performance,
-- then in situation like this we use exists operator (the sub-query does not return a result after query, it only finds matches on search condition
-- THEN BY FACING WITH LARGE DATA SET WE SHOULD USE EXISTS CLAUSE INSTEAD OF WHERE SUB-QUERY
-- first way
select * from clients
where client_id in (
      select distinct client_id
      from invoices
);

-- second way
select distinct client_id, name, address, city, state,phone from  clients
join invoices using (client_id)
;

-- third way -- using exists operator
-- in the where clause we are not referencing a column
-- instead we use exists, by doing so we want to see if there is a row in the invoices table that matches the criteria or not
select * from clients c
where  exists (
    select client_id
    from invoices
    where client_id = c.client_id
);
-- exercise--
-- find the products that have never been ordered;
use sql_Store;
-- using sub-query
select * from products
where product_id not in (
    select product_id from order_items
    );
-- using the exists operator
select *
from products p
where not exists (
    select product_id from order_items oi
    where product_id = p.product_id
);

-- sub-queries in the select statement ---------------------------------------------------------------------------------
use sql_invoicing;
select invoice_id, invoice_total,
       (select avg(invoice_total)  from invoices)  as avg_total,
       invoice_total- (select avg_total) as differnce
from invoices;

-- exercise--
use sql_invoicing;

select client_id,
       name,
       (select sum(invoice_total)
           from invoices
           where client_id = c.client_id) as total_sale,
       (select avg(invoice_total) from invoices) as average,
       (select total_sale-average ) as diference
from clients c;

-- sub-queries in "from clause"--------------------------------------------------------------------
-- it is used for simple sub-queries, it is another better way (view). later we will learn views
-- example of from
select *
from (
    select client_id,
           name,
           (select sum(invoice_total)
               from invoices
               where client_id = c.client_id) as total_sale,
           (select avg(invoice_total) from invoices) as average,
           (select total_sale-average ) as diference
    from clients c
) as summary
where total_sale is not null;

-- numeric functions ---------------------------------------------------------------------
select round(5.73); -- result: 6
-- determining precision for number:
select round(5.75, 1);
select truncate(5.7345, 2);
select  ceiling(5.2);
select floor(5.2);
select abs(5.2);
select rand(); -- random values between zero and one

-- string functions -------------------------------------------------------------------
select length('sky');
select upper('sky');
select lower('Sky');
select ltrim('   Sky'); -- left trim
select rtrim('sky    '); -- right trim
select trim('  sky    '); -- trim
select left('kindergarten', 4);  -- getting 4 characters from the left
select right('kindergarten', 4);  -- opposite of left function
select substring('kindergarten',3,5 ); -- getting any character from the string, first argument is the start position and second one is the length
select locate('n', 'kindergarten'); -- find the position of a character
select locate('q', 'kindergarten');
select locate('garten', 'kindergarten');
select replace('kindergarten', 't','d');
select concat('first', 'last');
use sql_store;
select *, concat(first_name, ' ', last_name) as full_name
from  customers;

-- date functions--------------------------------------------------------------------------
select now(), curdate(), curtime();
select year(now());
select month(now());
select hour(now());
select minute(now());
select second(now());
select dayname(now());
select monthname(now());
-- if we aim to port our code to other database management system, it is better to use extract
-- because it is a part of standard sql language
select extract( month from now());
select extract(day from now());
select extract(second from now());

-- exercise--
-- modify the code bellow to reliably return orders placed after this year
select *
from orders
where order_date >= '2019-01-01';

select *
from orders
where year(order_date) = year(now()); -- there is no output because the 4 years passed from recording this video :)

-- formatting dates and times  -----------------------------------------------------------------------------------

select date_format(now(), '%Y %M');
select time_format(now(), '%H:%p');

-- calculating date and times---------------------------------------------------------------------------------------

select date_add(now(), interval 1 day);
select date_add(now(), interval 1 year);
-- we wanna go back in time--
select date_add(now(), interval -1 year);
select date_sub(now(), interval 2 year);
select datediff('2022-04-5', '2022-04-1') as differnce; -- this function only returns differences between days not the hours or minutes even
-- included time
select datediff('2022-04-5','2022-04-1 12:58') as diff;
select datediff('2022-04-5 03:03','2022-04-1 12:58') as diff;
 -- calculate differences between two times
select timediff('2022-04-5 03:03','2022-04-1 12:58');
select time_to_sec('03:00'); -- calculate time in seconds from the midnight
select time_to_sec('03:00') - time_to_sec('03:02') as diff;

-- ifnull and coalesce functions---------------------------------------------------------------------------------------
-- we want to replace null values in shipper_id column with a string
use sql_store;
select shipper_id, ifnull(shipper_id, 'Not assigned') as shipper
from orders;

-- if the shipper id is null we wanna return values in comments column and if comments is also null we wanna return not assigned
select shipper_id, coalesce(shipper_id, comments, 'Not assigned') as shipper
from orders;

-- exercise--
select concat(first_name, ' ', last_name) as customer, ifnull(phone, 'Unknown') as phone
from customers;

-- the if function --------------------------------------------------------------------------------------------
select order_id,
       order_date,
       if(year(order_date) = year(now()), 'active', 'archived') as status -- if it is true return first statement, if not return the second one
from orders;

-- exercise--
select product_id,
       name,
       count(name) as orders,
       if(count(name) > 1, 'Many times', 'once') as ferquency
from order_items
join products using(product_id)
group by name;

-- case clause---------------------------------------------------------------------------------------------------------
-- it is for the times that we have more than 2 condition, on the other hand we have multiple test expressions
select
       order_id,
       case
           when year(order_date) = year(now()) then 'active'
           when year(order_date) = year(now()) - 1 then 'last year'
           when year(order_date) < year(now()) -1  then 'archived'
           else 'future'
       end as category
    from orders;

-- exercise--
-- return customer names in the first column, their points in the second column and the category as gold, silver, bronze in the last column
select concat(first_name, ' ', last_name) as name,
       case
           when points > 3000 then 'Gold'
           when  points >= 2000 then 'Silver'
           else 'Bronze'

       end as category
from customers
order by category;

-- creating views----------------------------------------------------------------------------------------------------
-- views are virtual tables
use sql_invoicing;
create  view sale_by_client as
select client_id,
       name,
       sum(invoice_total) as total
from clients c
join invoices using(client_id)
group by  client_id, name;
-- we can select the view:
select * from sql_invoicing.sale_by_client;
-- we can treat it as a table:
select * from sale_by_client
order by total desc;

-- exercise--
-- create a view to see the balance
-- for each client
-- client balance, client_id, name
-- balance = invoice_total- payment_total
create view  client_balance as
select client_id,
       name,
       sum(invoice_total - payment_total) as balance
from clients
join invoices using(client_id)
group by client_id;

-- altering or dropping views------------------------------------------------------------------------------------
drop view sale_by_client;
--
create or replace view sale_by_client as
select client_id,
       name,
       sum(invoice_total) as total
from clients c
join invoices using(client_id)
group by  client_id, name;
-- editing views
-- it is different than workbench
-- right click on virtual table in view
-- go to ddl and change the query

-- updatable view-------------------------------------------------------------------------
-- if we don't have these stuffs in our views, we can update them
-- distinct
-- aggregate functions min, max, sum, count and avg
-- group by/ having
-- union
-- we can update our view
create or replace view invoices_with_balance as
    select
           invoice_id,
           number,
           client_id,
           invoice_total,
           payment_total,
           invoice_total - payment_total as balance,
           invoice_date,
           due_date,
           payment_date
from invoices
where (invoice_total - payment_total) > 0;
-- we can modify it
delete from invoices_with_balance
where invoice_id = 1;

update invoices_with_balance
set due_date = adddate(due_date, interval 2 day )
where invoice_id = 2;

-- with check option -------------------------------------------------------------
-- sometimes we do some changes in our views that cause deleted columns
-- for example in where clause of above view, we have set "where" condition > 0
-- then when we put invoice_total = payment total
-- the balance become zero, therefore where condition cannot accept it
-- the balance disappear
-- to prevent from this we use "with check option". At this time when we are faced with a value in the start of the deletion
-- we get an error, the "with check option" do this.
update invoices_with_balance
set invoice_total = payment_total
where invoice_id = 2;

-- for preventing we write
create or replace view invoices_with_balance as
    select
           invoice_id,
           number,
           client_id,
           invoice_total,
           payment_total,
           invoice_total - payment_total as balance,
           invoice_date,
           due_date,
           payment_date
from invoices
where (invoice_total - payment_total) > 0
with check option;

-- then
update invoices_with_balance
set invoice_total = payment_total
where invoice_id = 3;

-- creating a store procedure-----------------------------------------------------------------------------------

create procedure get_clients()
begin
    select * from clients;
end;
-- for calling it
call get_clients();

-- exercise----
-- create a stored procedure called
-- get_invoices_with_balance
-- to return all the invoices with a balance > 0
create procedure get_invoices_with_balance()
begin
select
           invoice_id,
           number,
           client_id,
           invoice_total,
           payment_total,
           invoice_total - payment_total as balance,
           invoice_date,
           due_date,
           payment_date
from invoices
where (invoice_total - payment_total) > 0;
end;

call get_invoices_with_balance();

-- we can do this with view
create procedure get_invoices_with_balance_view()
begin
select * from invoices_with_balance
where balance > 0;
end;

call  get_invoices_with_balance_view();

-- dropping stored procedures---------------------------------------------------
-- it is better to write
drop procedure if exists get_invoices_with_balance_view;

-- parameters ---------------------------------------------------------------------------------
create procedure get_clients_with_state(
    p_state char(2)
)
begin
    select * from clients
        where state = p_state;
end;

call get_clients_with_state('CA');

-- exercise
-- write a stored procedure to return invoices
-- for a given client
-- get_invoices_by_client
create procedure get_invoices_by_client(
p_client_id int
)
begin
select *
from invoices
    where client_id = p_client_id;
end;

call get_invoices_by_client(5);

-- parameters with default value--------------------------------------------------------------------------
-- assign a default value to a parameter
-- we want to return all clients if the input parameter is null
create procedure get_clients_with_state(
p_state char(2)
)
begin
    if p_state is null then
        set p_state = 'CA';
        end if;
    select * from clients
        where state = p_state;
end;

call get_clients_with_state(null);

-- we want to return all clients instead of clients in California
-- this approach is a little bit verbose and not professional;

create procedure get_clients_with_state(
p_state char(2)
)
begin
    if p_state is null then
        select * from clients;
        else
        select * from clients
        where state = p_state;
        end if;
end;

call get_clients_with_state('CA');

-- writing the above function more professionally
create procedure get_clients_with_state(
p_state char(2)
)
begin
        select * from clients
        where state = ifnull(p_state, state); -- if p_sate is not true return second condition
end;

call get_clients_with_state(null);

-- exercise
-- write a stored procedure called get payments with two parameters
-- client_id ==> int
-- payment_method id ==>tinyint

create procedure  get_payments(
p_client_id int,
p_payment_method tinyint
)
begin
     select *
     from payments
     where client_id = ifnull(p_client_id, client_id) and
           payment_method = ifnull(p_payment_method, payment_method);
end;

call get_payments(1,1);


























































