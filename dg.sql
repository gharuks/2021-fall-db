create table students (
    id VARCHAR(10),
    name VARCHAR(225),
    faculty VARCHAR(225),
    gpa NUMERIC
);

create table customers (
    id integer,
    full_name varchar(50) NOT NULL,
    timestamp timestamp NOT NULL,
    delivery_address text NOT NULL,
    primary key (id)
);
create table products (
    id varchar NOT NULL,
    name varchar NOT NULL,
    description text,
    price double precision NOT NULL check(price>0),
    primary key (id)
);
create table orders (
    code integer NOT NULL,
    customer_id integer,
    total_sum double precision NOT NULL check(total_sum>0),
    is_paid boolean NOT NULL,
    primary key (code),
    foreign key (customer_id) references customers
);
create table order_items (
    order_code integer NOT NULL,
    product_id varchar NOT NULL,
    quantity integer NOT NULL check(quantity>0),
    primary key (order_code, product_id),
    foreign key (order_code) references orders,
    foreign key (product_id) references products
);

insert into students(id, name, faculty, gpa)
VALUES('20BD030327', 'student 1', 'FIT', 3.9);
insert into students(id, name, faculty, gpa) VALUES
    ('20BD030303', 'student 2', 'FIT', 3.8),
    ('20BD030927', 'student 3', 'FIT', 3.6);

SELECT id, name, faculty FROM students;

update students
set gpa='3.3'
where name='student 1';

insert into customers(id, full_name, timestamp, delivery_address)
values ('1', 'customer 1', current_timestamp, 'Novaya, 7');

insert into orders(code, customer_id, total_sum, is_paid)
values ('1', '1', 09129158355, TRUE);

insert into products(id, name, description, price)
values('01', 'umbrella', 'standart black colored', 30);

insert into order_items ( order_code, product_id, quantity)
values ('1', '01', '10');

update customers
set full_name='customer 2'
where id=1;

SELECT * FROM students;

alter table students drop gpa;
alter table students add gpa numeric;
truncate table students;

select name from students
where faculty='FIT';

drop table products;

DELETE FROM order_items
WHERE product_id='01';

create table students2(
    full_name varchar(50),
    age integer,
    birth_date date,
    gender varchar,
    av_grade numeric,
    about_yourself text,
    need_dorm boolean,
    add_inf text
);
insert into students2(full_name) values ('asbfaf,sdfsd.afkea,faf')
