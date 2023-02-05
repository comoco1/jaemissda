 > **책 '데이터 분석을 위한 sql 레시피'를 참고했습니다.**

## <교재 8강 여러 개의 테이블 조작하기(2)>

### (3) 조건 플래그를 0과 1로 표현하기

![6666666666666](https://user-images.githubusercontent.com/113004818/216820863-47322703-a8dc-418e-b95a-0d63fab65ec6.PNG)![7777777777777777](https://user-images.githubusercontent.com/113004818/216820864-74a6802f-adac-4dea-a1d4-c96386a18029.PNG)

위 테이블을 결합해 사용자의 '신용카드 번호 등록 여부' , '구매 이력 여부' 두 가지 조건을 0과 1로 표현해보자 한다.

첫 번째는 ```case```를 이용해 0과 1로 나타 내는것 <br>
두 번째는 ```sign```을 이용하는 방법이 있다.

          select m.user_id , m.card_number , 
            count(p.user_id) as purchase_id ,
            case 
              when m.card_number IS NOT NULL THEN 1 ELSE 0 END AS has_card, -- 카드 넘버가 있을 시 1, 아니면 0
            sign(count(p.user_id)) as has_purchased -- 구매이력이 양수일 시 1 , 0일 시 0
            from sql-study-project-376507.sql_study_bigquery.mst_users_with_card_number as m
              left join
            sql-study-project-376507.sql_study_bigquery.purchase_log as p
            on m.user_id = p.user_id
              group by m.user_id, m.card_number;
              
![111111111111111](https://user-images.githubusercontent.com/113004818/216821210-d1a88094-a5b8-43cd-9800-ab497a262628.PNG)
              
<br><br><br>

### (4) 계산한 테이블에 이름 붙여 재사용하기

복잡한 sql 쿼리문을 작성할 때는 ```서브 쿼리의 중첩```이 많아진다.
<br> ```비슷한 처리를 여러번``` 하는 경우도 있는데 이럴경우 ```쿼리의 가독성```이 굉장히 낮아진다.
<br> 이 경우 SQL99에 도입된 공통 테이블식 **CTE**를 사용해 ```일시적인 테이블```에 ```이름을 붙여`` 재사용 할 수 있다.

![2222222222222222](https://user-images.githubusercontent.com/113004818/216821429-0b28017a-97fe-4d1b-99f8-e0c7dc74c886.PNG)

위 데이터를 이번회차 까지 배운 것을 기반으로 ```가로 정렬 후``` 카테고리의 ```상품 매출 순위```를 한번에 보고자 한다.
<br> 또한 ```WITH```구문을 사용해 반복적으로 처리하는 쿼리에 일시적으로 테이블을 만들이 이름을 부여하고자 한다.

with    -- with <테이블 이름> as (select~~~) 형태로 사용
  product_sale_ranking as (
    select
        category_name,product_id,sales,
          row_number() over(partition by category_name order by sales desc) as rank
      from sql-study-project-376507.sql_study_bigquery.product_sales 
  )
  select * 
    from product_sale_ranking;

![33333333333333](https://user-images.githubusercontent.com/113004818/216821842-f504f77c-d28c-45a9-bd1f-83d4d2842772.PNG)
