create table customers(
    customer_id integer primary key,
    customer_name varchar(50),
    customer_email varchar(50),
    city varchar(25),
    street varchar(25),
    zip varchar(6),
    phone_number varchar(15)
);
drop table customers cascade ;
insert into customers(customer_id, customer_name, customer_email, city, street, zip, phone_number)
values (1, 'Adem Madi', 'adem01@mail.com', 'Almaty', 'Almatinskaya', '050063', '+77077771234'),
       (2, 'Tomiris Serik', 'tomiris01@mail.com', 'Almaty', 'Abay', '050062', '+77077773456'),
       (3, 'Arsen Otelbay', 'arsen01@mail.com', 'Nur-Sultan', 'Mukanova', '000010', '+77077775678'),
       (4, 'Musa Marat', 'marat_m@mail.com', 'Taraz', 'Aqbulaq', '000020', '+77077777890'),
       (5, 'Ayaulym Saya', 'ayasaya01@mail.com', 'Atyrau', 'Satbayev', '000030', '+77077776785');
create table purchase(
    purchase_id integer primary key,
    customer_id integer,
    purchase_type varchar(25),
    store_id integer,
    date date,
    product_id integer,
    total_cost integer,
    foreign key (customer_id) references customers(customer_id),
    foreign key (product_id) references products,
    foreign key (store_id) references store
);
insert into purchase(purchase_id, customer_id, purchase_type, store_id, date, product_id, total_cost)
values (1, 1, 'online', null, '2021-03-05', 1, 100),
       (2, 1, 'online', null,'2021-03-05', 2, 240),
       (3, 3, 'in store', 2, '2021-06-06', 5, 450),
       (4, 1, 'in store', 1,'2021-06-11', 1, 500),
       (5, 5, 'online', null, '2021-07-05', 3, 150),
       (6, 4, 'in store', 1, '2021-08-05', 4, 220),
       (7, 4, 'online', null, '2021-09-08', 3, 150),
       (8, 2, 'in store', 1, '2021-09-13', 3, 300);
create table products(
    product_id integer primary key,
    product_name varchar(50),
    manufacturer varchar(50),
    price numeric,
    product_quantity integer
);
insert into products(product_id, product_name, manufacturer, price, product_quantity)
values (1, 'Laptop', 'Acer', 100, 10),
       (2, 'Laptop', 'Lenova', 120, 10),
       (3, 'Smartphone', 'Apple', 150, 10),
       (4, 'Smartphone', 'Samsung', 110, 10),
       (5, 'Monitor', 'Dell', 90, 10);

drop table purchase;
create table order_details(
    purchase_id integer primary key,
    customer_id integer,
    product_id integer,
    discount numeric,
    purchase_date date,
    payment bool,
    foreign key (product_id) references products,
    foreign key (purchase_id) references purchase,
    foreign key (customer_id) references customers
);
insert into order_details(purchase_id, customer_id, product_id, discount, purchase_date, payment)
values (1, 1, 1, 0, '2021-04-05', false),
       (2, 1, 2, 0, '2021-04-05', true),
       (5, 5, 3, 0, '2021-07-05', true),
       (7, 4, 3, 0, '2021-09-08',true);

drop table order_details;
create table accounts(
    customer_id integer primary key,
    account_code integer,
    foreign key (customer_id) references customers
);

insert into accounts(customer_id, account_code)
values (2, 86707),
       (4, 84309);

create table suppliers(
    supplier_id integer primary key,
    name varchar(50),
    city varchar(50),
    contact_number varchar(50),
    product_id integer,
    foreign key (product_id) references products
);
insert into suppliers(supplier_id, name, city, contact_number, product_id)
values (1, 'Acer', 'Almaty', '+77071234567', 1),
       (2, 'Apple', 'Almaty', '+77073456789', 3),
       (3, 'Samsung', 'Almaty', '+77072345678', 4),
       (4, 'Dell', 'Almaty', '+7075673456', 5),
       (5, 'Lenovo', 'Almaty', '+77073451234', 2);
create table delivery(
    delivery_id integer primary key,
    purchase_id integer,
    customer_id integer,
    tracking_number integer,
    delivery_date date,
    shipping_type varchar(50),
    order_status varchar(50),
    foreign key (purchase_id) references purchase,
    foreign key (customer_id) references customers
);
insert into delivery(delivery_id, purchase_id, customer_id, tracking_number, delivery_date, shipping_type, order_status)
values (1, 1, 1, '123456', '2021-04-05', 'car delivery', 'destroyed'),
       (2, 1, 2, '232465', '2021-04-05', 'car delivery', 'completed'),
       (5, 5, 3, '354678', '2021-07-05', 'rail transportation', 'completed'),
       (7, 4, 3, '354636', '2021-09-08', 'car delivery', 'in progress');
create table store(
    store_id integer primary key,
    store_name varchar(50),
    city varchar(25),
    region varchar(25),
    street varchar(25)
);
insert into store(store_id, store_name, city, region, street)
values (1, 'Store1', 'Almaty', 'Almaty', 'Kunaeva'),
       (2, 'Store2', 'Taraz', 'Zhambyl', 'Mukataeva'),
       (3, 'Store3', 'Nur-sultan', 'Nur-sultan', 'Abay');
create table sales(
    sales_id integer primary key,
    product_id integer,
    product_quantity integer,
    total_cost integer,
    time_period date,
    season varchar(15),
    region varchar(25),
    foreign key (product_id) references products
);
insert into sales(sales_id, product_id, total_cost, time_period, season, region)
values (1, 1, 340,'2021-05-31', 'Spring', 'Almaty'),
       (2, 2, 1320,'2021-08-30', 'Summer', 'Almaty'),
       (3, 3, 450, '2021-12-04', 'Autumn', 'Taraz'),
       (4, 4, 0, '2022-09-29', 'Winter', 'Nur-sultan');
drop table store;


select * from customers inner join
delivery on customers.customer_id = delivery.customer_id
where tracking_number='123456' and order_status='destroyed';

update delivery
set delivery_date=date_pli(delivery_date, 2), order_status='reordered'
where order_status='destroyed';
select * from delivery;

select customer_id, sum(total_cost) as most_cost from purchase
group by customer_id
order by most_cost desc
limit 1;

select product_id, total_cost from sales
where time_period>'2021-01-01' and time_period<'2021-12-31'
order by total_cost desc
limit 2;

select * from delivery
inner join order_details od on delivery.customer_id = od.customer_id
where delivery_date!=purchase_date;

select * from purchase
where date<='2021-03-30' and date>='2021-03-01'
group by purchase_id
order by sum(total_cost);
