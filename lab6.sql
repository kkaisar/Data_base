create table dealer (
    id integer primary key ,
    name varchar(255),
    location varchar(255),
    charge float
);

create table client (
    id integer primary key ,
    name varchar(255),
    city varchar(255),
    priority integer,
    dealer_id integer references dealer(id)
);


create table sell (
    id integer primary key,
    amount float,
    date timestamp,
    client_id integer references client(id),
    dealer_id integer references dealer(id)
);

SELECT * FROM dealer inner JOIN client on dealer.id = client.dealer_id;

SELECT d.name, c.name, c.city, sell.id ,sell.date, sell.amount
FROM sell inner JOIN client c on c.id = sell.client_id
inner JOIN dealer d on d.id = c.dealer_id;

select   * FROM dealer d inner JOIN client c on d.id = c.dealer_id
WHERE d.location = c.city;

select s.id, c.name, c.city
from sell s inner join client c on c.id = s.client_id
WHERE s.amount >= 100 and s.amount<=500;

select distinct d.name, c.name, d.location
from dealer d
RIGHT JOIN client c
ON d.id=c.dealer_id;

SELECT c.name, c.city, d.name, d.charge
from client c JOIN dealer d on d.id = c.dealer_id;


select c.name, c.city, d.name, d.location, d.charge FROM client c JOIN dealer d on d.id = c.dealer_id
WHERE d.charge > 0.12;

select client.name, client.city, sell.id, sell.date, sell.amount, dealer.name, dealer.charge
from client left join sell on client.id = sell.client_id
            left join dealer on sell.dealer_id = dealer.id;

select client.name, client.priority, dealer.name,  sell.id, sell.amount
from dealer inner join client on dealer.id = client.dealer_id
            inner join sell on client.id = sell.client_id
where sell.amount>=2000 and client.priority is not null;



--2a
create view view1 as select sell.date, client.name, count(DISTINCT client_id), avg(amount), sum(amount)
from sell inner join client on sell.client_id = client.id
group by date, client.name;

select * from view1;

--b
create view view2 as select sell.date, count(DISTINCT sell.id), sum(amount)
from sell
group by sell.date
order by sum(amount) desc
limit 5;

select * from view2;

--c
create view view3 as select dealer.name, count(sell.dealer_id), avg(sell.amount), sum(sell.amount)
from sell inner join dealer on sell.dealer_id = dealer.id
group by dealer.name;

select * from view3;

--d
create view view4 as select dealer.name, sum(sell.amount)*dealer.charge, dealer.location
from sell inner join dealer on sell.dealer_id = dealer.id
group by dealer.name, dealer.location, dealer.charge;

--e
create view view5 as select count(sell.id), avg(sell.amount), sum(sell.amount), dealer.location
from sell inner join dealer on sell.dealer_id = dealer.id
group by dealer.location;

select * from view5;

--f
create view view6 as select count(sell.id), avg(sell.amount), sum(c.priority - sell.amount)
from sell inner join client c on sell.client_id = c.id
group by c.city;

--g
create view view7 as select client.name, client.priority, s.amount, d.location
from client inner join dealer d on d.id = client.dealer_id inner join sell s on client.id = s.client_id
where client.priority > s.amount;
select * from view7;
