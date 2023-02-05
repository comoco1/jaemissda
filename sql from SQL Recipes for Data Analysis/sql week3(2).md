 > **책 '데이터 분석을 위한 sql 레시피'를 참고했습니다.**

## <교재 7강 하나의 테이블에 대한 조작(2)>

7강(1) 부분에서는 데이터를 조건에 맞게 추출하는 내용에 대해 알아보았다.

이번 내용은 데이터를 사용하기 좋게 변환하는 방법을 알아볼 것 이다.

#### 데이터 기반 변환하기
<br>

##### (1) 행을 열로 변환
  * sql에서는 행 단위 기반(세로기반 데이터) 으로 처리하는 것이 기본이다.
  * 하지만 최종 출력때는 열로 전개해야 가독성이 높은 경우가 많다.

sql에서 열은 고정적이어야 한다. <br>
따라서 열로 전개할 데이터의 종류 또는 수를 명확하게 미리 아는 경우 다음과 같은 방법을 사용할 수 있다.

          select * 
              from sql-study-project-376507.sql_study_bigquery.daily_kpi;

![999999999999999999999](https://user-images.githubusercontent.com/113004818/216810803-f479bbcb-281c-49e3-934a-4a1bda7eda12.PNG)
<br> 위 데이터는 날짜별 노출 수, 세션 수, 사용자 수 까지 3개의 지표를 고정적으로 가진다.

          select dt , max(case when indicator = 'impressions' then val end) as impressions 
                    , max(case when indicator = 'sessions' then val end) as sessions
                    , max(case when indicator = 'users' then val end) as users
                      from sql-study-project-376507.sql_study_bigquery.daily_kpi
                      group by dt 
                        order by dt;
 
![000000000000000](https://user-images.githubusercontent.com/113004818/216810916-dc53bc04-a89e-480e-91e3-1aa641b9bce7.PNG)
<br> 열의 수가 고정적인 것을 이용해 행 데이터를 열 데이터로 변환 해 보았다.
<br><br>

하지만 앞서 언급한 것 처럼 위와 같은 방법은 열의 종류와 수를 알고 있을 떄만 사용할 수 있다.

예를 들어 상품 구매로그 경우 한번의 주문으로 많은 상품을 주문 햇을때, 아이디별로 집약하고 싶어도 상품을 몇 개 주문했는지 알 수 없어
위와 같은 방법으로는 불가능하다.
<br><br><br><br>

미리 열의 수를 정할 수없는 경우는 쉼표 등으로 데이터를 구분한 문자열로 변환하는 방법을 쓸 수 있다.

          select purchase_id ,
            string_agg(product_id,',') as product_ids, -- string_agg(결합할 행,구분자) purchase_id로 그룹화한 product_id를 쉼표 단위로 결합한다.
            sum(price) as amount 
            from sql-study-project-376507.sql_study_bigquery.purchase_detail_log
              group by purchase_id
                order by purchase_id;

![11111111111111111](https://user-images.githubusercontent.com/113004818/216811192-ccb8ab11-9c94-474e-9902-d9075d0977f0.PNG)

위와 같이 purchase_id로 그룹화 한 후, ```string_agg```구문으로 그룹화 한 product_id를 그룹별 쉼표 단위로 결합했다.



<br><br><br><br>
##### (2) 열을 행으로 변환

행으로 저장된 데이터를 열으로 변환하는 것은 비교적 간단하지만, 반대인 경우는 복잡하다.<br>
하지만 어쩔 수 없이 이미 열로 저장된 데이터를 행으로 바꿔야 하는 경우가 꽤 많다고 한다.

![2222222222222222222222](https://user-images.githubusercontent.com/113004818/216811409-91c1ff07-eff0-4d02-b2a6-f4ac07ae64ad.PNG)

열로 표현된 데이터의 특징은, 데이터의 수가 고정되었다는 것이다. <br>
위의 데이터를 예시로 q1부터 q4까지 모두 4개의 데이터로 구성 되어있다. <br>
데이터의 수가 고정되어 있다면, 같은 일련 번호를 가진 테이블을 만들고 ```cross join```을 하면 된다.

          select q.year,
            case
              when p.idx = 1 then 'q1'
              when p.idx = 2 then 'q2'
              when p.idx = 3 then 'q3'
              when p.idx = 4 then 'q4'
            end as quarter,
            case
              when p.idx = 1 then q.q1
              when p.idx = 2 then q.q2
              when p.idx = 3 then q.q3
              when p.idx = 4 then q.q4
            end as sales,p
          from  sql-study-project-376507.sql_study_bigquery.quarterly_sales as q
            cross join
              ( select 1 as idx
                union all select 2 as idx
                union all select 3 as idx
                union all select 4 as idx) as p
                  order by year, quarter;

![3333333333333333333333](https://user-images.githubusercontent.com/113004818/216811655-f27daa99-f44f-4c33-8e55-58e6dfe9c34e.PNG)


위의 경우도 고정길이의 데이터를 전개하는 방법이었다. <br>
하지만, 데이터의 길이가 확정되지 않은 경우는 조금 복잡하다.

![444444444444](https://user-images.githubusercontent.com/113004818/216811739-4c06baa3-8c59-4033-87c2-48fb48707d55.PNG)

위와 같은 테이블은 데이터의 수가 고정되어 있지 않다.
<br> 하지만 bigquery의 경우, 테이블 함수를 구현하고 있는 미들웨어이기 떄문에 쉽게 전개할 수 있다.

          select purchase_id,product_id from
            sql-study-project-376507.sql_study_bigquery.purchase_log as p
              cross join unnest(split(product_ids,',')) as product_id; -- 반점을 분할해서 준것
              
              -- unnest 함수를 사용해 테이블을 분할, split 함수를 이용해 쉼표를 기준으로 데이터를 분할

![image](https://user-images.githubusercontent.com/113004818/216811988-1f9c3851-8b90-43da-bc1f-0aa6f3997563.png)


