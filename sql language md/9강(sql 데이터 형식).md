> 책 '혼자 공부하는 sql'을 참고하였습니다.

## sql 데이터 형식

#### 1. 숫자형 자료
   1) 정수형
      * 소숫점이 없는 숫자형 ex) 1,101,23515
      * int(+-21억) / smallint(+-32000) / tinyint(+-128)
   
   2) 실수형
      * 소숫점이 존재하는 숫자형
      * float(소숫점 7자리) / double(소숫점 15자리)
      * 대부분 소숫점 15자리까지 쓰는 경우가 없어 float 사용
      
#### 2. 문자형 자료
    1) 고정길이 문자형(char)
      * char(10) -> 최대 10글자, 10글자를 다 쓰지 않아도 db상에 10글자로 잡음
      * 낭비가 심하지만 가변길이 문자형과 비교해 약간 빠르다


-- 문자형 => char는 255까지 varchar는 16383까지
-- (char(10) -> 최대 10글자, 다 안써도 10자로 잡음(낭비) / 
-- varchar(10) -> 최대 10글자, 안쓰면 3글자 공간만 확보(낭비x , 속도 조금 더 느림))
-- 가변적일때는 varchar로 잡고 아니면 char로 잡는다 
-- 숫자 앞이 0일때, 0을 쓰고 싶으면 문자형으로 해야함 ex) 전화번호 032,055
-- 연산이 가능한 경우만 혹은 크다 작다 순서가 있을때 숫자형 처리함 ex) 전화번호 이런거는 관련 x char

-- 대용량 데이터 => longtext(겁나 긴 글자) / longblob(겁나 긴 파일)

-- 날짜형 => date / time / datetime
-- date는 날짜만(yyyy-mm-dd) / time는 시간만(hh-mm-ss) / datetime(둘다 표시)

create table a1 (
	tinyint_col tinyint unsigned not null primary key, -- unsigned (+- 범위를 0부터 시작)
    smallint_col smallint,
    int_col int not null,
    bigint_col bigint,
    char_col char(243),
    varchar_col varchar(16222),
    longtext_col longtext,
    longblob_col longblob);

insert into a1 values(127,32000,211234143,12312412555);
select * from a1;

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
