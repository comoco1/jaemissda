use market_db;
select * from member;
select * from member
	order by debut_date asc;  -- asc 생략가능

select * from member
	order by height desc;

select * from member
	order by height desc , debut_date
	limit 3;

select * from member
	order by height desc , debut_date
	limit 3,2;
    
select distinct addr from member;

select mem_id , sum(amount) as 총구매갯수 from buy group by mem_id;  

select mem_id , sum(amount*price) as 총구매액 from buy group by mem_id; 

select count(phone1) from member;

select count(distinct addr) from member;

select mem_id , sum(price*amount) as 총구매액
	from buy
    group by mem_id 
    having 총구매액 > 1000;


