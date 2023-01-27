> 책 '혼자 공부하는 sql'을 참고하였습니다.

## select 기초(select활용,연산자 및 논리 연산자)

### 1. select
  * DB안 테이블을 조회한 후 결과를 보여준다.(추출한다.)
  * 읽기만 가능! 변경은 xx
  * pk 기준으로 정렬된다.<br>
  * 조건 작성 시 조건에 부합하는게 없을경우 조회가 되지 않는다.(오류는 아니다.)
  ex)  ```select  * from market_db.member 
where height <= 160; ``` - from -> ~어디로 부터 - 어디로 부터는 테이블을 뜻하며 어떤 테이블로부터 데이터를 가져 올 것인지 from 뒤에 기술한다. 

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
 
 #### 4. 연산자
   * 크게 논리 연산자, 산술 연산자, 부정 연산자, 비교 연산자로 나누어 진다.
   
     1) 산술 연산자 (+,-,*,/,%,DIV)  
        * 기본적인 산술을 위한 연산자로, select문에서는 from절을 제외한 구문에 사용할 수 있다.
        *  ``` select height-2+3/2  from member; ```
     
     2) 논리 연산자(and, or , between, in , like 등등)
        * 두 피연산자를 비교에 결과값이 참이면 결과값이 참, 거짓이면 결과 값이 거짓이 되는 연산자이다.
        * 조건식에 많이 사용된다.
        *  ex) select * from member where height between 160 and 165; -> ~사이에 - and 연산자 양 옆 피연산자 값 안 범위에 위치하면 참
        *  select * from member where addr in('경기','전남'); -> 피연산자가 목록 중 하나라도 같은 것이 존재할 경우 참
        *  ~~ member where mem_name like "우%"; -> like 연산자 - 비슷하거나 조건에 맞을 경우 참
        *  ~~ member where mem_name like "__핑크";   -> %는 범위가 무한하나 _(언더바)는 갯수에 맞게 일치 해야함
            
