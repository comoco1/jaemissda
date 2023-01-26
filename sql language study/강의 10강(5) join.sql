use market_db;
 -- join => 두 테이블을 묶는 것을 말한다.
 -- 조인 시는 일대다 관계로 맺어져 있어야한다. ex) member와 buy는 일대다 (buy fk에 member의 pk가 존재)
 -- buy의 아이디는 pk가 되버리면 그 아이디의 사람은 구매를 1개 초과로 못한다.
 
---------------------------------------------
 
 -- 내부조인 -> 가장 많이 사용하는 조인, 웬만한 조인은 내부조인
 -- 내부조인 기본구문 select ~ from ~ inner join ~ on(이너조인의 조건) ~ {where ~};
 select * from member inner join buy on member.mem_id = buy.mem_id 
	where member.mem_id = 'GRL';
    
---------------------------------------------
 
SELECT mem_id, mem_name, addr, CONCAT(phone1, phone2) AS '연락처'
	FROM member INNER JOIN 
	buy ON member.mem_id = buy.mem_id; -- 이렇게 할시 맨 앞 select mem_id는 buy,member 둘다 가지고
										-- 있기 때문에 어디서 가져올 껀지 붙혀줘야함(밑에처럼)

SELECT member.mem_id, mem_name, addr, CONCAT(phone1, phone2) AS '연락처'
	FROM member INNER JOIN 
	buy ON member.mem_id = buy.mem_id;
-- 이너조인의 문제점은 member,buy 기준 buy를 했던 member만 조인되기 때문에
-- 한쪽에 경우도 조인 하고싶으면 외부조인 사용

---------------------------------------------

-- 외부조인 (left (outer) join / right (outer) join / full (outer) join)
-- 조인시 앨리어스를 자주 사용

select * from member as M 
	left join buy as B
    on m.mem_id = B.mem_id
    order by m.mem_id; -- 구매하지 않은 애들도 buy에는 null값으로 다 조회된다.

select * from buy as B
	right join member as M
    on m.mem_id = B.mem_id
    order by m.mem_id; -- 밑에와 테이블 순서를 빼고 값은 같이나옴

---------------------------------------------

-- 상호 조인 cross join (대용량의 데이터를 생성할때 내용은 상관없지만 사용)
-- 조건없이 다 결합하는 것

create table bigdata
	select *
		from member.mem_name
		cross join buy.amount;
select * from bigdata;
select * from member;

---------------------------------------------

-- 자체 조인 (self join) (자기자신 끼리 조인하는 경우)
-- 기본 구문 select ~ from(as 다르게 부여{같은 테이블이기 때문에}) ~ inner join ~ on ~

select a.emp as 직원 , b.emp as 직속상관 , b.phone 직속상관연락처
	from emp_table a
		inner join emp_table b
			on a.manager = b.emp
		where a.emp = '경리부장';

