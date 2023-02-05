 > **책 '데이터 분석을 위한 sql 레시피'를 참고했습니다.**

## <교재 8강 여러 개의 테이블 조작하기(1)>

4강에서 언급했듯이 DB의 데이터들은 크게 업무 데이터, 로그데이터로 나누어 진다.

**업무 데이터 사용 시**
 * 업무데이터는 RDB를 사용해 관리하는 경우가 많다. 
 * RDB는 일반적으로 데이터를 정규화 하고, 여러 테이블로 나누어 데이터를 관리해 여러 테이블들을 결합하여 원하는 정보를 추출 한다.
 * ex) SNS 사이트를 생각하면 댓글,좋아요,팔로우 데이터 라는 각각의 테이블에 저장된 정보를 기반으로 어떠한 행동을 사용자가 하는지 분석하려면 이러한 것들을 하나로 합쳐 다룬다.

**로그 데이터 사용 시**
 * 다양한 행동 하나하나를 기록하는 거대한 데이터이다.
 * 이와같은 경우도 여러 처리를 실행하려면 여러개의 select나 셀프조인을 통해 비교해야한다.
 * 테이블이 하나라도 여러 테이블을 다루는 것 처럼 처리해야 하는 경우도 있다.

이와 같이 데이터 분석 시 대용량의 ```데이터를 합치는 능력```, 서로 다른 유형의 테이블을 합해 사용할 줄 알아야 한다.
<br><br><br>
### (1) 여러 테이블을 세로로 결합하기

![11111111111111](https://user-images.githubusercontent.com/113004818/216819026-5a1b494f-511a-49c5-884a-63e61eb806fd.PNG)
![2222222222222222222222](https://user-images.githubusercontent.com/113004818/216819028-261d527e-de30-43b7-8db2-3877eff7e9a1.PNG)

<br> 위 두 테이블은 비슷한 형태를 띄고있다.
 * 비슷한 구조를 가진 테이블을 세로 결합하고 싶다면 ```union all``` 구문을 사용한다.
 * 결합할때는 테이블의 컬럼이 ```완전히``` 일치 해야한다. 
 * 한쪽 테이블에 존재하는 컬럼은 ```제외```하거나, ```디폴트값```을 줘야한다.

       select 'app1' as app_name, user_id,name,email 
             from sql-study-project-376507.sql_study_bigquery.app1_mst_users
           union all
       select 'app2' as app_name, user_id,name,
        null as email  -- 완전히 테이블 컬럼이 일치해야해 이메일 앨리어스를 썼지만 존재하지 않기 때문에 null값을 부여한 모습
             from sql-study-project-376507.sql_study_bigquery.app2_mst_users;

![3333333333333](https://user-images.githubusercontent.com/113004818/216819170-f0468aaf-72c8-4d7e-9793-498e6bb7ad04.PNG)

<br><br><br>

### (2) 여러 테이블을 가로로 정렬하기

     select m.category_id , m.name , s.sales , r.product_id
       from sql-study-project-376507.sql_study_bigquery.mst_categories as m
         inner join
           sql-study-project-376507.sql_study_bigquery.category_sales as s
           on m.category_id = s.category_id
         inner join
       sql-study-project-376507.sql_study_bigquery.product_sale_ranking as r
           on m.category_id = r.category_id;

![444444444444444](https://user-images.githubusercontent.com/113004818/216819509-ebf1fa34-ade3-4d72-b2fa-b0d6e5b8eb92.PNG)
<br> 여러개의 테이블을 가로 정렬할 때 가장 일반적인 방법은 JOIN, 그 중 대표적인 ```내부조인(INNER JOIN)```을 사용하는 것이다.
다만 내부조인을 이용해 데이터를 정렬 할 경우, ```결합하지 못한 데이터```가 사라지거나 ```중복 된 데이터```가 발생할 수 있다. <br>
ex) 위 데이터와 같은 경우 보이지는 않지만 category_id가 3인 경우는 결합되지 못해 ```처음부터 없는 것 처럼``` 보인다.

**이와 같은 경우, 외부조인(OUTER JOIN)을 이용해 결합하지 못하는 레코드를 유지하고 조건을 세워 중복된 데이터가 없도록 만든다.**

     select m.category_id , m.name , s.sales , r.product_id
       from sql-study-project-376507.sql_study_bigquery.mst_categories as m
         left join
           sql-study-project-376507.sql_study_bigquery.category_sales as s
           on m.category_id = s.category_id
         left join
       sql-study-project-376507.sql_study_bigquery.product_sale_ranking as r
           on m.category_id = r.category_id
           and r.rank=1
             order by category_id;
             
![5555555555555](https://user-images.githubusercontent.com/113004818/216819747-73023c8e-6c34-4a95-bbeb-6f8935abec28.PNG)

* BigQuery는 상관 서브 쿼리를 사용할 수 있는 미들웨어이다.
* 스칼라 서브쿼리를 이용해 조인을 이용하지 않고 데이터를 정렬할 수 있다.

      select m.category_id , m.name,
        (select s.sales from sql-study-project-376507.sql_study_bigquery.category_sales as s 
          where m.category_id = s.category_id) as sales,
        (select r.product_id from sql-study-project-376507.sql_study_bigquery.product_sale_ranking as r
          where m.category_id = r.category_id
            order by sales desc
              limit 1) as top_sale_product
          from sql-study-project-376507.sql_study_bigquery.mst_categories as m;
          --위와 동일한 결과 출력


