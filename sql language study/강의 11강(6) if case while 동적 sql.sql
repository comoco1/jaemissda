-- 스토어드 프로시저를 사용해 동적 sql을 작성
-- 기본 구문 (아래)

delimiter $$ 
create procedure 스토어드_프로지서_이름()
begin
	-- 여기에 구문이 들어감
end $$
delimiter ;
call 스토어드_프로시저_이름();

-- 스토어드 프로시저 내부의 sql문은 일반 sql문이라 세미콜론으로 문장을 끝 맺어야하는데
-- 작성이 완료되지 않았음에도 sql 실행되는 위험을 막기 위해 다른 구분자로(위의 경우는%%) 바꾸어 사용(delimiter)
-- create procedure를 통해 프로시저를 생성하고
-- begin end 사이 프로시저를 작성
-- call로 프로시저를 실행

----------------------------------

-- if문
drop procedure if exists ifend;
delimiter $$ 
create procedure ifend()
begin
	if 100 = 200 then
		select '100과 100은 같습니다.';
	end if;
end $$
delimiter ;
call ifend();

-- ifelse문

drop procedure if exists ifend1;
delimiter $$ 
create procedure ifend1()
begin
	declare mynum int;	--  set @mymun int 와 동일 (프로시저 안에서는 set 대신 declare 사용)
    set mynum = 200; -- 프로시저 안 set은 @ 사용 안함
	if mynum = 200 then
		select '200입니다';
	else
		select '200이 아닙니다.';
	end if;
end $$
delimiter ;
call ifend1();

-- ifelse 응용문

delimiter $$ 
create procedure ifend2()
begin
	declare debutdate date;
    declare curdate date;
    declare days int;
    
    select debut_date into debutdate -- debut-date 결과를 debutdate에 대입하라.
		from member where mem_id = 'APN';
        
	set curdate = current_date(); -- current_date() -> 현재 날짜
    set days = datediff(curdate,debutdate); -- 날짜의 뺄셈을 일 단위로 표시
    
    if (days/365) >= 5 then -- days는 일단위, 365로 나누면 년도가 됨
		select concat('데뷔한지',days,'일이나 지났네요 좀 오래 되셨네용');
	else
		select concat('데뷔한지', days,'밖에 안지났어요. 파이팅!');
	end if;
end $$
delimiter ;
call ifend2();

-----------------------------------

-- case문 (조건이 많은때 사용)

drop procedure if exists case1;
delimiter $$ 
create procedure case1()
begin
	declare credit char(1);
    declare height smallint;
    set height = 163;
	case
    when height >= 168 then
		set credit = 'A';
	when height >= 166 then
		set credit = 'B';
	when height >= 164 then
		set credit = 'C';
	else
		set credit = 'D';
	end case;
    select credit;
end $$
delimiter ;
call case1();

select mem_id , sum(price * amount) as "총구매액"
	from buy
    group by mem_id
    order by 총구매액 desc;

select m.mem_id , m.mem_name ,sum(price*amount) as 총구매액,
		case 
			when (sum(price*amount) >= 1500) then '최우수고객' -- 왜 sum(price*amount)에 총구매액을 쓰면 오류가 뜰까?
			when (sum(price*amount) >= 1000) then '우수고객'
			when (sum(price*amount) >= 1) then '일반고객'
			else '유령고객'
		end '회원등급'
	from buy as b
	right join member as m
		on m.mem_id = b.mem_id
	group by m.mem_id
	order by 총구매액 desc;

----------------------------------

-- while 반복문

-- 1에서 100까지
drop procedure if exists while1
delimiter $$
create procedure while1()
begin
	declare i int;
    declare hap int;
    set i = 1;
    set hap = 0;
    
    while(i<=100) DO
		set hap = hap + i;
        set i = i + 1;
	end while;
    
    select hap;
end$$
delimiter ;
call while1();

drop procedure if exists while2
delimiter $$
create procedure while2()
begin
	declare i int;
    declare hap int;
    set i = 1;
    set hap = 0;
    
    while(i<=100) DO
		set hap = hap + i;
        set i = i + 1; 
	end while;
    
    select hap;
end$$
delimiter ;
call while2();

drop procedure if exists while3
delimiter $$
create procedure while3()
begin
	declare i int;
    declare hap int;
    set i = 1;
    set hap = 0;
    mywhile:    -- mywhile이라는 이름을 생성 :
    while(i<=100) DO
		if (i%4 = 0) then
			set i = i + 1;
            iterate mywhile; -- mywhile로 돌아가라
		end if;
        set hap = hap + i;
        if (hap >1000) then
			leave mywhile; -- mywhile 밖으로 end 해라
		end if;
        set i = i + 1;
	end while;
    select hap;
end$$
delimiter ;
call while3();




