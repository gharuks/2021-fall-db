--1
--a)
select * from client cross join dealer;
--b)
select dealer.id, dealer.name, location, charge, client.name, city, priority, sell.id, date, amount
from ((dealer right join client on dealer.id=client.dealer_id)
right join sell on sell.dealer_id=dealer.id and sell.client_id=client.id);
--c)
select dealer.id, dealer.name, client.id, client.name, city
from client inner join dealer
on dealer.location=client.city;
--d)
select sell.id, amount, client.name, city
from sell inner join client
on sell.client_id=client.id and amount>=100 and amount<=500;
--e)
select dealer.id, dealer.name, location, charge, client.id
from dealer left join client
on dealer.id=client.dealer_id;
--f)
select client.name, city, dealer.name, charge
from dealer inner join client
on dealer.id=client.dealer_id;
--g)
select client.name, city, dealer.name, charge
from dealer inner join client
on dealer.id=client.dealer_id and charge>0.12;
--h)
select client.name, city, sell.id as sell_id, date, amount, dealer.name, charge
from client left join sell on client.id=sell.client_id
left join dealer on dealer.id=client.dealer_id;
--i)
select client.name, client.priority, dealer.name, sell.id as sell_id, amount
from client right join dealer on dealer.id = client.dealer_id
left join sell on client.id = sell.client_id
where amount>2000 and priority is not null;

--2
--a)
create view vista as
select date, count(distinct client_id) as unique_clients, avg(amount) as average_amount, sum(amount) as total_amount from sell
group by date;
-- drop view vista;
select * from vista;
--b)
create view top5date as
select date, total_amount from vista
order by total_amount desc
limit 5;
drop view top5date;
select * from top5date;
--c)
create view sales as
select dealer_id, count(distinct sell.id) as num_of_sales, avg(amount) as average_amount, sum(amount) as total_amount
from sell
group by dealer_id;
-- drop view sales;
select * from sales;
--d)
create view earn as
select dealer.id, dealer.name, location, sum(amount)*charge as gain
from dealer inner join sell
on dealer.id=sell.dealer_id
group by dealer.id;
-- drop view earn;
select * from earn;
--e)
create view vista1 as
select location, count(distinct sell.id), avg(amount), sum(amount)
from sell inner join dealer
on sell.dealer_id = dealer.id
group by location;
drop view vista1;
select * from vista1;
--f)
create view vista2 as
select city, count(sell.id) as num_of_sales, avg(amount) as avg_amount, sum(amount) as total_amount
from sell inner join client
on sell.client_id = client.id
group by city;
-- drop view vista2;
select * from vista2;
--g)
create view vista3 as
select location, city, vista1.sum, total_amount from vista2 inner join vista1
on vista1.location=vista2.city and vista1.sum<vista2.total_amount;
select * from vista3;
drop view vista3;
