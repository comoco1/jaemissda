 > **책 '데이터 분석을 위한 sql 레시피'를 참고했습니다.**

## <교재 7강 하나의 테이블에 대한 조작(1)>
  
    
    
    
 sql의 특징은 데이터를 집합으로 다룬다는 것이다. <br>
 
 앞선 강의 까지는 데이터 하나하나의 조작을 다루었는데
 실무에서는 수십만개, 많게는 수억개의 레코드를 다루는데 이를 하나하나 처리하는것은 말도 안되게 많은 시간이 든다. <br>
 
 따라서 대용량의 데이터를 집계하고 그 중 몇가지 지표를 사용해 데이터 전체의 특징을 파악할 수 있어야 한다. <br>
 
 3주차 7~8강 에서는 데이터의 집약 / 가공등을 배울 것이다.
 
 <br> <br>
 
#### 1. 여러 레코드를 기준으로 하나의 값을 리턴시키는 집약 함수

##### (1) 집약 함수

     select * 
         from sql-study-project-376507.sql_study_bigquery.review;
         

![11111111111111](https://user-images.githubusercontent.com/113004818/216808281-962768f0-2043-4179-9402-84d2836fd68f.PNG)

<br> 위 테이블에  자주 사용하는 집약함수를 적용해 밑과 같은 테이블을 완성했다.

     select count(user_id) as ct_id , count(*) as total_count,
             count(distinct user_id) as dtn_id , sum(score) , avg(score),max(score) -- distinct을 이용해 중복은 제거해 조회했다.
               from sql-study-project-376507.sql_study_bigquery.review;


![22222222222222](https://user-images.githubusercontent.com/113004818/216808448-64d834d0-cfe0-4cf9-905a-272a4bc84fb8.PNG)

데이터를 세부적으로 분할하고 싶다면 ``` group by ``` 구문을 사용한다.
```group by``` 구문을 사용한 컬럼에 집약 함수를 적용 시킨다면 더 작은 단위의 데이터를 알 수 있다.

     select user_id ,count(*) , count(product_id) , sum(score), avg(score), max(score), min(score)
         from sql-study-project-376507.sql_study_bigquery.review
           group by user_id; 
           
![333333333333333333](https://user-images.githubusercontent.com/113004818/216808671-d554c515-b22d-4ef3-84b2-8cebd5a85d06.PNG)

user_id를 기반으로 그룹을 묶고, user_id로 묶은 각각의 집합에 집약 함수를 적용했다.

※주의
 * ```group by``` 구문을 사용한 쿼리에서는 ```group by``` 구문에 지정된 컬럼 혹은 집계 함수만이 ```select``` 구문의 컬럼으로 지정 될  수 있다.
 * 위의 경우에는  ```group by``` 구문으로 지정한 ```user_id``` 혹은 집계함수만 ```select``` 구문의 컬럼으로 올 수 있다. (score,product_id 등등 컬럼으로 지정 불가하다.)
 * 이유 -> ```group by``` 구문을 사용한 쿼리는 ```group by``` 구문에 지정한 컬럼을 유니크 키로 한 후 새로운 테이블을 만들어 버리기 때문이다.


##### (2) 윈도 함수

* 데이터베이스를 사용한 온라인 분석 처리 용도로 사용하기 위해서 표준 SQL에 추가된 함수이다. (OLAP 함수라고도 불린다.)
* 윈도 함수를 통해 집약 전 값과 집약 함수를 적용한 값을 동시에 다루는 것도 가능하다. 
* 집약함수는 행 그룹에 대한 하나의 결과 값을 리턴하지만
  <br>윈도함수는 행 그룹의 값을 계산하고 각행마다 하나의 값을 리턴한다.

      select user_id , product_id,score,
          avg(score) over() as avg_score,                    -- over() -> 테이블 전체에 대한 집약함수를 적용 -> 그냥 집계함수와 동일
          avg(score) over(partition by user_id) as user_avg_score,  -- over(partition by 컬럼이름) -> group by와 동일한 효과
          score - avg(score) over(partition by user_id) as user_avg_score_diff
             from sql-study-project-376507.sql_study_bigquery.review;

![4444444444444444444](https://user-images.githubusercontent.com/113004818/216809354-300caa4f-e52a-46f4-9fda-5b42b3914ac2.PNG)

* sql 테이블은 딱히 순서같은 것이 정해져 있지 않다. 그래서 어떠한 기준으로 순서를 정하는 것이 쉽지 않다.
* 윈도 함수가 등장함으로 sql로 순서를 다루는 것은 굉장히 쉬워젔다.

      select * 
         from sql-study-project-376507.sql_study_bigquery.popular_products;
        
![55555555555555](https://user-images.githubusercontent.com/113004818/216809558-981fd34c-a5a7-4b6a-b5a5-51dc9188bed8.PNG)
<br> 위 데이터와 윈도 함수를 이용해 score 별 순위를 매겨보고자 한다.

* sql 테이블은 딱히 순서같은 것이 정해져 있지 않다. 그래서 어떠한 기준으로 순서를 정하는 것이 쉽지 않다.
* 윈도 함수를 이용하기 위해서는 해당 값의 위치를 명확하게 지정해야 한다. -> 순서를 먼저 원하는대로 정렬한 후 등수를 매겨야함(자동처리가 아님)
* 윈도 함수 ```over``` 안 ```order by```를 사용해 sql 테이블 안 순서를 정할 수 있다.

      select product_id, score,
        row_number() over(order by score desc) as row, -- row_number -> 유일한 순위를 매긴다 -> 점수를 내림차순하여 정리 한 후
        rank() over(order by score desc) as rank,   -- rank -> 같은 순위를 허용해서 순위를 붙힌다.
        dense_rank() over(order by score desc) as dense,  -- dense_rank -> 같은 순위를 허용한 후 그 뒷 순위를 건너 뛰고 순위를 붙힌다.
        lag(product_id) over(order by score desc) as lag1, -- 현재 행보다 앞에 있는 행의 값을 추출한다.
        lag(product_id,3)over(order by score desc) as lag2, -- 현재 행보다 3칸 앞에 있는 행의 값을 추출한다.
        lead(product_id)over(order by score desc) as lead1, -- 현재 행보다 뒤에 있는 행의 값을 추출한다.
        lead(product_id ,3)over(order by score desc) as lead2 -- 현재 행보다 3칸 뒤에 있는 행의 값을 추출한다.
          from sql-study-project-376507.sql_study_bigquery.popular_products
            order by row;  -- 윈도 함수 안 order by는 정렬해주는 것이 아니라 저 순서대로 정렬했을 경우 순서를 매기는것
                              다시 row 별 순위를 지정해주어야 깔끔하게 정리 가능하다.
                             
![666666666666666666](https://user-images.githubusercontent.com/113004818/216809886-ea063e69-53e0-48b4-bdfc-e74035251035.PNG)

* ```lead ```함수나 ```lag``` 함수를 사용했을 시 , 앞과 뒤에 행의 값이 존재하지 않을 경우 , ```NULL``` 값으로 조회된다.


**```order by``` 구문와 ```집약 함수```를 조합하면, 집약 함수의 적용 범위를 유연하게 지정할 수 있다.**
 
      select product_id , score , 
        row_number() over(order by score desc) as row,
        sum(score) over(order by score desc rows between unbounded preceding and current row) as cum_score,
        avg(score) over(order by score desc rows between 1 preceding and 1 following) as local_avg,
        first_value(product_id) over(order by score desc rows between unbounded preceding and unbounded following) as first_value,
        last_value(product_id) over(order by score desc rows between unbounded preceding and unbounded following) as last_value
          from sql-study-project-376507.sql_study_bigquery.popular_products
          order by row;
          
![7777777777777777](https://user-images.githubusercontent.com/113004818/216810079-bc978d32-da54-4095-8326-a5e1ab5f529a.PNG)


* order by 뒤에 이어지는 rows 구문은 윈도 프레임 지정 구문이다. -> 현재 레코드 위치를 기반으로 상대적인 윈도를 정의하는 구문이다.
  * rows between (start) and (end) 구문 ->  start 부터 end 까지 
  * current row -> 현재의 행 // n preceding -> n행 앞 // n following -> n행 뒤 
  * unbounded preceding -> 이전 행 전부 // unbounded following -> 이후 행 전부
  * first_value() -> 첫번째 값을 리턴하는 함수 // last_value() - > 마지막 값을 리턴하는 함수

**```partition by``` 구문과 ```order by``` 구문을 조합해 그룹 별 순위를 매길 수도 있다.**

     select category, product_id, score,
       row_number() over(partition by category order by score desc) as row,
       rank() over(partition by category order by score desc) as rank,
       dense_rank() over(partition by category order by score desc) as dese_rank
          from sql-study-project-376507.sql_study_bigquery.popular_products
            order by category , row;

![888888888888888](https://user-images.githubusercontent.com/113004818/216810347-69403a17-29a2-4178-8092-2375f71281f7.PNG)

* 모든 순위가 아닌 상위 n개의 값을 출력하고 싶다면, 순위를 조회한 구문에 앨리어스를 이용해 추출할 수있다.
ex) ``` where row <= 2 ``` -- row의 값이 2 이하인 값 조회 (1등,2등)

* 상/하위 n개가 아닌 1개의 값은 이전에 사용한 ```first_value``` / ```last_value``` 를 사용해 구할 수 있다. 
* but) 윈도 구문인 만큼 ```over```구문은 필수적으로 쓰인다.




