use market_db;

create table aa (toy_id int, toy_name char(4), age int);
create table aaa (toy_id int auto_increment primary key, toy_name char(4), age int);
alter table aaa auto_increment=100;
set @@auto_increment_increment=3;    -- set => 사용자 변수 생성

insert into aa values(1,"우디",25);
insert into aa(toy_id, age) values(2,30);

insert into aaa values(NULL,"우디",25);
insert into aaa values(NULL,"우디디",30);
insert into member values('APM','에이핑크',6,'경기',031,77777777,164,'2011-02-10');

select last_insert_id();
select * from aa;
select * from aaa;
select * from member;
desc member;

create table member2(mem_id char(4), mem_name char(4), addr char(2));
insert into member2 
	select mem_id,mem_name,addr from member;
select * from member2;

update member  -- update 구문이 안될땐 edit preferences 에서 safe update 끄기
	set mem_name = '에이핑크크'
    where mem_name = '에이핑크'; -- where 절 없이 잘 사용 안함

delete from member
	where mem_number = 6;