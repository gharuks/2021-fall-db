--1---------a)
CREATE FUNCTION inc(value numeric) RETURNS integer AS $$
    BEGIN
        RETURN value+1;
    END;$$
LANGUAGE plpgsql;
select inc(2);
----------b)
CREATE FUNCTION sum(value1 numeric, value2 numeric) RETURNS integer AS $$
    BEGIN
        RETURN value1+value2;
    END;$$
LANGUAGE plpgsql;
select sum(1,3);
----------c)
CREATE OR REPLACE FUNCTION even(value integer) RETURNS boolean AS $$
    BEGIN
        return (value%2=0);
    END;$$
LANGUAGE plpgsql;
select even(94);
----------d)
CREATE OR REPLACE FUNCTION check_password(password varchar(20)) RETURNS boolean AS $$
    BEGIN
        if(length(password)<8 or length(password)>12) then return false;
        else return true;
        end if;
    END;$$
LANGUAGE plpgsql;
select check_password('asadff');
----------e)
CREATE OR REPLACE FUNCTION two_output(name varchar, out a varchar, out b varchar) RETURNS record AS $$
    BEGIN
        a:=split_part(name, ' ', 1);
        b:=split_part(name, ' ', 2);
    END;$$
LANGUAGE plpgsql;
select two_output('Aru Zhan');
--2-----------a)
CREATE TABLE person
(
    id               integer,
    first_name        varchar(50) NOT NULL,
    last_name        varchar(50) NOT NULL
);
drop table person;
DELETE FROM person
WHERE id=005;
DELETE FROM person;
INSERT INTO person (id, first_name, last_name) VALUES
    ('001', 'Asan', 'Usen'),
    ('002', 'Amy', 'Madison');
INSERT INTO person (id, first_name, last_name) VALUES
    ('005', 'Jain', 'Ostin'),
    ('006', 'Drake', 'Who');

CREATE TABLE changes (
    operation char NOT NULL,
    person_id INT NOT NULL,
    first_name VARCHAR NOT NULL,
    last_name VARCHAR NOT NULL,
    changed_on TIMESTAMP NOT NULL
);
select * from changes;
delete from changes;
CREATE OR REPLACE FUNCTION timestmp_func() RETURNS trigger AS
$timestmp$
BEGIN
    IF (TG_OP = 'DELETE') THEN
        INSERT INTO changes SELECT 'D', OLD.*, now();
    ELSIF (TG_OP = 'UPDATE') THEN
        INSERT INTO changes SELECT 'U', NEW.*, now();
    ELSIF (TG_OP = 'INSERT') THEN
        INSERT INTO changes SELECT 'I', NEW.*, now();
    END IF;
    RETURN NULL;
END;
$timestmp$
LANGUAGE plpgsql;

CREATE TRIGGER timestmp AFTER INSERT OR UPDATE OR DELETE ON person
    FOR EACH ROW EXECUTE PROCEDURE timestmp_func();
---------b)
CREATE TABLE list(
    id integer primary key,
    name varchar,
    birth_date date,
    age int
);
select * from list;
INSERT INTO list (id, name, birth_date)
VALUES (2, 'Aru', '2003-05-05');
INSERT INTO list (id, name, birth_date)
VALUES (4, 'Adam', '1999-06-05');

CREATE OR REPLACE FUNCTION age_from_birthday()
RETURNS trigger AS
    $$
        BEGIN
            update list
            set age=round((current_date-new.birth_date)/365.25)
            where id = new.id;
            return new;
        END;
    $$
LANGUAGE 'plpgsql';
CREATE TRIGGER age_from_bday AFTER INSERT ON list
    FOR EACH ROW EXECUTE PROCEDURE age_from_birthday();
-----------c)
CREATE TABLE orders(
    id integer primary key ,
    order_name varchar(50),
    price numeric
);
drop table orders;
INSERT INTO orders(id, order_name, price)
VALUES (1, 'order3', 100);
select * from orders;

CREATE OR REPLACE FUNCTION tax_price() RETURNS trigger AS $$
    BEGIN
        UPDATE orders
        SET price=price*1.12
        WHERE id=new.id;
        RETURN new;
    END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER price_ch AFTER INSERT ON orders
    FOR EACH ROW EXECUTE FUNCTION tax_price();
----------d)
delete from orders;
CREATE OR REPLACE FUNCTION prevent_del() RETURNS trigger AS $$
    BEGIN
        RAISE EXCEPTION 'do not delete data';
    END;
    $$ LANGUAGE plpgsql;

CREATE TRIGGER prev_del BEFORE DELETE ON orders
    FOR EACH ROW EXECUTE FUNCTION prevent_del();

DELETE FROM orders;
-----------e)
CREATE TABLE account(
    id integer primary key ,
    user_name varchar,
    password varchar
);
drop table account;
delete from account;
select * from account;
INSERT INTO account(id, user_name, password) VALUES (2, 'Aru Zhan', 'qwerty34');

CREATE OR REPLACE FUNCTION function_de() RETURNS trigger AS $$
    BEGIN
        if check_password(NEW.password)=true then
            update account
            set user_name=two_output(user_name)
            where id=NEW.id;
        else raise exception 'password is invalid';
        end if;
        RETURN NEW;
    END;
    $$ LANGUAGE plpgsql;

CREATE TRIGGER de BEFORE INSERT OR UPDATE ON account
    FOR EACH ROW EXECUTE FUNCTION function_de();
--4----------a)
CREATE TABLE workers(
    id integer primary key,
    name varchar,
    date_of_birth date,
    age integer,
    salary integer,
    workexperience integer,
    discount integer
);

delete from workers;
drop table workers;
INSERT INTO workers(id, name, date_of_birth, age, salary, workexperience, discount)
VALUES (1, 'David', '1993-06-07', 28, 100, 10, 0);

select * from workers;

CREATE OR REPLACE PROCEDURE procedure_a() AS $$
    BEGIN
        update workers
        set salary=salary*1.1*workexperience/2, discount=discount+10;
        update workers
        set discount=(discount*1.01)*workexperience/5;
        commit;
    END;$$ LANGUAGE plpgsql;
CALL procedure_a();
---------b)
INSERT INTO workers(id, name, date_of_birth, age, salary, workexperience, discount)
VALUES (3, 'Carla', '1970-06-07', 40, 100, 10, 0);

CREATE OR REPLACE PROCEDURE procedure_b() AS $$
    BEGIN
        update workers
        set salary=salary*1.15 where age>=40;
        update workers
        set salary=salary*1.15*workers.workexperience/8, discount=discount+20 where workexperience>=8;
        commit;
    END;$$ LANGUAGE plpgsql;
CALL procedure_b();
-------------5
CREATE TABLE members(
    memid integer,
    surname varchar(200),
    firstname varchar(200),
    address varchar(300),
    zipcode integer,
    telephone varchar(20),
    recommendedby integer,
    joindate timestamp
);
CREATE TABLE bookings(
    facid integer,
    memid integer,
    starttime timestamp,
    slots  integer
);
CREATE TABLE facilities(
    facid integer,
    name varchar(100),
    membercost numeric,
    questcost numeric,
    initialoutlay numeric,
    monthlymaintenance numeric
);

WITH RECURSIVE rec_recommendedby(recommender, member) as(
    select recommendedby, memid from members
    union all
    select members.recommendedby, rec.member from rec_recommendedby rec
    inner join members on members.memid=rec.recommender
)
SELECT rec.member, rec.recommender, members.firstname, members.surname
FROM rec_recommendedby rec
inner join members ON rec.recommender=members.memid
WHERE rec.member=12 or rec.member=22
ORDER BY rec.member asc, rec.recommender desc

