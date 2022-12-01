create table Warehouses(
    code integer,
    location character varying(255),
    capacity integer
);
create table Boxes(
    code character(4),
    contents character varying(255),
    value real,
    warehouses integer
);

drop table Boxes;
select * from  Warehouses;
    select * from  Boxes;
select * from  Boxes
where value>150;

select distinct on(contents) * from Boxes;
select Boxes.code, Boxes.warehouses from Boxes;

select code, warehouses from Boxes
where warehouses > 2;

INSERT INTO warehouses (location, capacity)
VALUES ('New-York',3);

INSERT INTO Boxes (code, contents, value, warehouses)
VALUES ('H5RT', 'Papers', 200, 2);

update boxes
set value = 0.85*value
where value in (select value from Boxes
group by value
order by value desc
limit 1 offset 2);

delete from boxes where value<150;

select * from boxes
    where warehouses = (
        (select code from warehouses
                    where location = 'New-York')
        );
delete from boxes where warehouses=(
                (select code from warehouses
                            where location = 'New-York'));