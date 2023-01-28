> 책 '혼자 공부하는 sql'을 참고하였습니다.

## set 사용자 변수 / 형식 변환

#### 1. 사용자 변수 set
* set @변수이름 = 대입값; <br>
ex) ``` set @myvars1 = 5; ```
* set 사용자 변수는 db에 영구저장되지 않음.

	사용자 변수를 사용해 사칙연산도 가능 
	
	ex) ``` set @myvars1 = 5; 
	set @myvars2 = 4.25; 
	select @myvars1 + @myvars2; ```
	<br>
	![3333333333333333](https://user-images.githubusercontent.com/113004818/215254168-15197043-a219-4031-b108-af56716b0cfc.PNG)

	set을 활용해 조건식에 조건을 부여가능
	
	ex) ``` set @txt = '가수 이름 ->';
	set @height = 166;
	select @txt as 이름 , mem_name as 키 from memeber where height > @height; ``` 
	<br>
	![1111111111111111](https://user-images.githubusercontent.com/113004818/215254435-9563785a-2947-48c8-9669-3e3749459d0f.PNG)
	<br><br><br>

#### 2. 동적 sql문
* 쿼리문을 실행시키지 않고 기다렸다가 실행 시키고 싶을때 실행 하는 방법
* prepare (변수) from (쿼리문); -> prepare를 사용해 쿼리문을 변수에 담아서 대기 / execute (변수); -> execute를 사용해 변수를 실행
	
ex) ``` set @count = 3;
prepare idol from 'select mem_name,height from member order by height limit ?';
execute idol using @count; ```
<br>
![444444444444444](https://user-images.githubusercontent.com/113004818/215254716-83faaa7b-bb50-4280-925e-372ec20db1e2.PNG)
<br><br><br>

#### 3. 데이터 형식 변환
``` select avg(price) as "평균 가격" from buy; ```
<br>
![555555555555555](https://user-images.githubusercontent.com/113004818/215254853-41900630-3432-41f7-b67a-07e2b8ffbf83.PNG)
<br> 
실행시 소숫점 까지 표기 (실수형)
 	* cast( 컬럼명 as 변경 타입) 을 사용하면 데이터 형식 변환이 가능
 	ex) ``` select cast(avg(price) as signed) as "평균 가격" from buyl -- cast(~~ as signed) - 부호가 있는 정수형으로 변환하라 ```
 	<br>
	![6666666666666666](https://user-images.githubusercontent.com/113004818/215255004-90f4816f-91dc-4795-9219-d325d92640c4.PNG)
	
	



	
-- 데이터 형식 변환 

select convert(avg(price) , signed) as "평균 가격" from buy; -- 위랑 같음
select cast('2022/1/19' as date) as '날짜';
select num, concat(cast(price as char), 'X' , cast(amount as char), '=')  -- concat => 결합
	as "가격*수량", price*amount as '수량' from buy;
    
 -- 암시적 변환
 select '100' + '200'; -- sql에서 암시적으로 숫자 처리를 해 100+200인 300을 출력
 select concat('100','200'); -- 문자로 처리
 select concat(100,200); -- sql에서 암시적으로 문자 처리를 해 100과 200의 결합인 100200으로 출력
