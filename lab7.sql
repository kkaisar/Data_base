
  ---1a
    create function increment(a int)
        returns int AS $$
        begin
            return a+1;
        end;
        $$ LANGUAGE PLPGSQL;
     SELECT increment(20);
---1b
    create function sum(a int, b int)
        returns int AS $$
        begin
            return a+b;
        end ;
        $$ LANGUAGE PLPGSQL;
    select sum(20,30);
---1c
    create function even(a int)
        returns bool AS $$
        begin

            return a%2=0;
        end;
        $$ LANGUAGE PLPGSQL;
    select even(20);
---1d
    create function password(s text)
        returns bool AS $$
        begin
            return (char_length(s)>=8)and((strpos(s,'!')>0)or(strpos(s,'@')>0)or(strpos(s,'#')>0)or(strpos(s,'$')>0)or(strpos(s,'%')>0));
        end ;
        $$ LANGUAGE PLPGSQL;
    select password('tobirama@');
---1e
    create function twoOut(s TEXT, OUT len int, OUT symb boolean)
        AS $$
        begin
            len:=char_length(s);
            symb=(strpos(s,'!')>0)or(strpos(s,'@')>0)or(strpos(s,'#')>0)or(strpos(s,'$')>0)or(strpos(s,'%')>0);

        end;
        $$ LANGUAGE plpgsql;
        select twoOut('ab!');



---2a
    create TABLE table1(id int, tekst text);
    create TABLE output( id int generated always as identity , time timestamp(6));
    CREATE FUNCTION timeStampp()
        returns trigger AS $$
        begin
            insert into output(time) VALUES (now());
            return new;
        end;
    $$ LANGUAGE  plpgsql;
    create trigger changes
        BEFORE INSERT
        ON table1
        FOR EACH STATEMENT
        EXECUTE PROCEDURE timestampp();
SELECT * FROM out;
INSERT INTO table1(tekst) VALUES ('ABCCD');

---2b
    CREATE TABLE table2 (id int generated always as identity , birthdate timestamp);
    CREATE TABLE output2( id int generated always as identity,  years int);
    CREATE FUNCTION getage()
        RETURNS TRIGGER
        AS $$
        BEGIN
            INSERT INTO output2(years) VALUES (extract(year from now())-extract(year from new.birthdate));
            return new;
        end;
    $$ LANGUAGE plpgsql;

    create trigger yearst
        BEFORE INSERT
        ON table2
        FOR EACH ROW
        EXECUTE PROCEDURE getage();
    SELECT * FROM output2;
    insert into table2(birthdate) VALUES (now());


---2c
    CREATE TABLE table3 (id int generated always as identity , price int);
    CREATE TABLE output3( id int generated always as identity,  price int);
    CREATE FUNCTION increase()
        RETURNS TRIGGER
        AS $$
        BEGIN
            new.price:=new.price*1.12;
            return new;
        end;
    $$ LANGUAGE plpgsql;
drop  function increase();
    create trigger incprice
        BEFORE INSERT
        ON table3
        FOR EACH ROW
        EXECUTE PROCEDURE increase();
drop trigger incprice on table3;
    SELECT * FROM table3;
    insert into table3(price) VALUES (100);

---2d
    CREATE FUNCTION prevent()
        returns trigger
        AS $$
        begin
            raise exception using message = 'a 1', detail = 'b 2', hint = 'c 3 ', errcode = 'd4444';

        end;
    $$ LANGUAGE plpgsql;
drop function prevent;
    CREATE TRIGGER dontdel
        BEFORE delete
        ON table3
        FOR EACH ROW
        EXECUTE PROCEDURE prevent();
    SELECT * FROM table3;



---3

CREATE TABLE procedure (id int primary key ,name varchar(20), date_of_birth date, age int, salary int,workexperience int , discount int );
insert into procedure values (4,'a','2004-04-04',20,99999, 2, 1234);
insert into procedure values (3,'b','2004-04-04',49,88888, 23, 1234);
insert into procedure values (5,'c','2004-04-04',18,7777, 4, 1234);
insert into procedure values (1,'d','2004-04-04',57,66666, 15, 4321);
insert into procedure values (2,'e','2004-04-04',17,55555, 6, 1233);

SELECT *FROM procedure;
BEGIN;
    UPDATE procedure SET salary=salary*1.1*(workexperience/2);
    UPDATE procedure SET discount=discount*1.01 WHERE workexperience>5;
end;

begin;
    UPDATE procedure SET salary=salary*1.15 WHERE age>=40;
    UPDATE procedure SET salary=salary*1.15 WHERE workexperience>=8;
    UPDATE procedure SET discount=discount*1.2 WHERE workexperience>=8;
end;
