> 책 '혼자 공부하는 sql'을 참고하였습니다.

## sql 데이터 형식


set @myvar1 =5;  -- set은 영구저장이 아니다. db에 영구저장되지 않음 워크벤치를 닫았다 열면 없어짐
set @myvar2 =4.25; -- @myvar는 내가 지어준 그냥 변수이름
select @myvar1 + @myvar2;

set @txt = '가수 이름 ->';
set @height =166;
select @txt as 이름 , mem_name as 키 from member where height >@height; -- set으로 활용가능

-- prepare / execute 구문 (prepare로 준비하고 execute로 준비된 것을 실행하다.)
-- limit @count 같은게 안먹혀서 사용함

set @count = 3;
prepare idol from 'select mem_name,height from member order by height limit ?' ;
execute idol using @count;

-- 데이터 형식 변환 
select avg(price) as "평균 가격" from buy; -- 소숫점 자리 나는 필요없다! 밑에거로 하면댐
select cast(avg(price) as signed) as "평균 가격" from buy; -- cast(~~ as signed) 부호가 있는 정수형으로 변환하라
select convert(avg(price) , signed) as "평균 가격" from buy; -- 위랑 같음
select cast('2022/1/19' as date) as '날짜';
select num, concat(cast(price as char), 'X' , cast(amount as char), '=')  -- concat => 결합
	as "가격*수량", price*amount as '수량' from buy;
    
 -- 암시적 변환
 select '100' + '200'; -- sql에서 암시적으로 숫자 처리를 해 100+200인 300을 출력
 select concat('100','200'); -- 문자로 처리
 select concat(100,200); -- sql에서 암시적으로 문자 처리를 해 100과 200의 결합인 100200으로 출력
