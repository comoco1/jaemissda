> 책 '혼자 공부하는 sql'을 참고

## select 기초(select활용,연산자 및 논리 연산자)

### 1. select
  * DB안 테이블을 조회한 후 결과를 보여준다.(추출한다.)
  * 읽기만 가능! 변경은 xx
  * pk 기준으로 정렬된다.<br>
  * 조건 작성 시 조건에 부합하는게 없을경우 조회가 되지 않는다.(오류는 아니다.)
  ex)  ```select  * from market_db.member 
where height <= 160; ``` 

###  select 활용구문
#### 1. use
   * DBMS 안 지정한 DB를 사용할것인지 정해라
  ex) ```use market_db;```
   * 대/소문자 구별 xx
   * sql 작성시 가장 첫 문장에 사용해야 한다.
   * use 작성시 사용해야 할 db를 지정하지 않으면 오류가 뜬다.

#### 2. 열 지정
   * '*' -> 모든 열
   * 특정 열만 지정해서 조회 할 경우 열 이름을 쓰면 된다. <br>
   ex) ``` select addr,debut_date  
from market_db.member 
where mem_name = "블랙핑크"; ```
   
#### 3. 앨리어스(alias)
 * 테이블 또는 테이블 열의 이름에 임시로 이름을 붙히기 위해 사용(as) 
 * 앨리어스 사용은 sql 코드의 단순화, 좀 더 이해하기 쉬운 결과값을 불러올 수 있다.
 * 호환성의 문제로 영어로 작성하는것이 일반적이다.
 * 띄어쓰기가 존재할 경우 quotation marks(',")를 사용 해야함.
 ex) ``` select addr as 주소, debut_date as "데뷔 일자" from member where mem_name = "블랙핑크"; ```
  
