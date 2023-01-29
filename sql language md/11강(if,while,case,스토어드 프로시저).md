> 책 '혼자 공부하는 sql'을 참고하였습니다.

## 조건식 , 스토어드 프로시저

#### 1. 스토어드 프로시저
  * mysql에서 제공하는 기능
  * 어떠한 동작을 일괄 처리하기 위해서 사용

ex) ``` delimiter $$
   create procedure 스토어드_프로시저_이름()
   begin
      구분삽입
   end $$
   delimiter ;
   call 스토어드_프로시저_이름(); ```
   

  * delimiter $$ ~ end $$ -> 작성이 완료되지 않았음에도 sql이 실행되는 위험을 막기 위해 다른 구분자로(위의 경우는 $$) 바꾸어 사용
  * 구분자는 $$ 이외 %% , $ 등등 사용가능
  * begin과 end 사이 실행할 구문을 삽입 -> call로 프로시저를 실행
  * 프로시저를 만들땐 괄호가 붙지만 삭제시 붙지않음
  ex) create procedure ifend();  -> drop procedue ifend;

#### 2. if문
  * 조건식이 참일 경우 참에 들어간 구문을 실행, 거짓일 경우 거짓에 들어간 구문을 실행
  
    ``` 
    if (조건식) then 
              (참일 경우 실행할 구문) ; 
    else
              (거짓일 경우 실행할 구문);
    end if; ```
   
``` if 100 = 200 then select '100과 100은 같습니다.'; end if; ```
100 = 200 이 참일 시 , '100과 100은 같습니다.'를 조회, 아닐 경우 end if로 if구문 빠져나오기 -> 실행 시 아무 값도 조회되지 않음


* 스토어드 프로시저 안 지역변수 지정은 set @이 아닌 declare를 사용
	
ex) delimter $$ create procedure ~ begin declare mynum int; 
	

##### ifelse 와 스토어드 프로시저의 활용
	
 	delimiter $$ 
	create procedure ifend();
	begin
		declare mynum int;
		set mynum = 200; -- 프로시저 안 set은 @ 사용안함
		if mynum = 200 then
			select '200입니다.';
		else -- 위의 if식이 거짓일 경우
			select '200이 아닙니다.';
		end if;
	end $$
	delimiter ;
	call ifend(); 
	
   
 ##### member 테이블을 이용해 member의 연차 파악하기
 	delimiter $$
	create procedure year()
	begin
		declare debutdate date; -- debutdate 변수 생성 (타입은 date)
		declare curdate date; 
		declare days int;
	
		select debut_date into debutdate -- debut_date 결과를 debutdate에 대입하라
			from member where mem_id 'APN';
		set @curdate = current_date(); -- current_date - 현재날짜
		set @days = datediff(curdate,debutdate); -- datediff 날짜의 뺄셈을 일 단위로 표시

		if (days/365) >= then
			select concat('데뷔한지',days,'일이나 지났네요. 좀 오래 하셨군요');
		else
			select concat('데뷔한지',days,'일이 지났네요.조금 더 파이팅합니다.');
		end if;

	end $$
	delimiter ;
	call ifelse();
	
![9999999999999999999](https://user-images.githubusercontent.com/113004818/215314833-b1a1e6ff-6242-4aa6-a1e0-0c01663b547b.PNG) mem_id 가 'APN'인 그룹의 데뷔일차는 다음과 같다.

	
#### 3. case문
위의 if문만 보더라도 조건이 하나 밖에 존재하지 않는다. <br>
if문에서 조건이 많을 경우 다음과 같다.

	if 조건1 then 실행구문 else if ~ then ~~~ 

else if를 줄이기 위해 case 구문을 사용한다.

	case
		when height >= 168;
			select '1';
		when height >= 164 then
			select '2';
		else
			select '3'
		end case;
		



##### case문을 이용한 고객 등급 나누기

	select mem_id , sum(price * amount) as "총구매액"
		from buy
	    group by mem_id
	    order by 총구매액 desc;

	select m.mem_id , m.mem_name ,sum(price*amount) as 총구매액,
			case 
				when (sum(price*amount) >= 1500) then '최우수고객' 
				when (sum(price*amount) >= 1000) then '우수고객'
				when (sum(price*amount) >= 1) then '일반고객'
				else '유령고객'
			end '회원등급'
		from buy as b
		right join member as m
			on m.mem_id = b.mem_id
		group by m.mem_id
		order by 총구매액 desc;

![78787686](https://user-images.githubusercontent.com/113004818/215315296-cf468854-c677-4826-b6f0-053a76de596d.PNG)
유령고객 = price 혹은 amount 가 null인 경우 -> 일반 내부조인으로는 유령고객을 join할 수 없다. 그러므로 member 테이블을 기준으로 한 외부조인을 사용



#### 4. while 반복문
	

##### 1에서 100까지

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
		
##### 4의 배수를 제외하고 1 부터 100까지의 합 (조건 -> 합계가 100이 넘어가면 종료)

	    select hap;
	end$$
	delimiter ;
	call while1();

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





