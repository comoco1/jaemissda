> **책 '데이터 분석을 위한 sql 레시피'를 참고했습니다.**

## <교재 6강 여러 개의 값에 대한 조작>

데이터를 분석할 때에는 하나의 값 뿐 만 아닌 여러개의 값을 집약해 하나의 값으로 만들거나,비교하는 여러개의 데이터에 대한 조작 할 상황이 많다.
이번파트에서는 전 파트와 달리 여러개의 값을 같이 가공하는 쿼리문에 대해 배워 볼 것이다.

### 1. 문자열 연결하기
  * 리포트를 작성할 때는 용도에 맞게 여러 데이터를 연결하여 다루기 쉬운 형식으로 많이 바꾼다.
  
        select * 
            from sql-study-project-376507.sql_study_bigquery.mst_user_location;
            
 ![111111111111](https://user-images.githubusercontent.com/113004818/216060637-578b3db3-368e-40dd-bfc8-83149fc02423.PNG)
 <br> 위 데이터의 최종 주소를 만들기 위해 문자열을 연결해 보겠습니다.
        
        select user_id,
           concat(pref_name,' ',city_name) as pref_city       -- concat(결합할 문자열1,2,3,4~~) 함수를 이용해 문자열을 결합
              from sql-study-project-376507.sql_study_bigquery.mst_user_location;

![222222222](https://user-images.githubusercontent.com/113004818/216061514-6c0e10a1-d668-4f1d-b772-a6bd892e87d0.PNG)


### 2. 두개 이상의 값 비교하기
        select * 
            from sql-study-project-376507.sql_study_bigquery.quarterly_sales;
            
![33333](https://user-images.githubusercontent.com/113004818/216063184-ac613834-363a-45fa-9e3b-5a060fdafe08.PNG)
<br> 위 데이터는 년도별 4분기 매출을 나타냅니다. 먼저 분기당 매출액이 상승 / 하락했는지 구별하기 위한 식을 만들겠습니다.

        select year,q1,q2,
          case
            when q1 > q2 then "-"
            when q1 < q2 then '+'
            else ''
        end as judge_q2_q2,
            sign(q2-q1) as sign_q2_q1
              from sql-study-project-376507.sql_study_bigquery.quarterly_sales
                order by year;    -- year 기준 오름차순 정렬해라
         
         -- case 구문을 사용하여 2분기 매출이 1분기보다 크면 + , 작으면 - , 0이면 ''
         -- sign() 구문을 사용하여 값이 양수이면 1 음수이면 -1 0이면 0
         
![44444444444444](https://user-images.githubusercontent.com/113004818/216064441-42895024-9e6d-4dae-8852-a642bd1e3137.PNG)
<br> 똑같은 방식으로 q2,q3,q4등도 비교할 수 있습니다. but 2개의 컬럼을 사용할 땐 괜찮지만 3개 이상의 컬럼을 사용하면 복잡해집니다.
  
   * **3개 이상의 경우 대소비교는 greatest , least 함수를 사용합니다.**

          select year , 
              greatest(q1,q2,coalesce(q3,q2),coalesce(q4,q2)) as greatest_sales ,
              least(q1,q2,coalesce(q3,q2),coalesce(q4,q2)) as least_sales
                  from sql-study-project-376507.sql_study_bigquery.quarterly_sales
                    order by year;

![44444444444444](https://user-images.githubusercontent.com/113004818/216069801-84e36f38-98e1-4a65-8cee-88e5aaf52fb6.PNG)
<br> greatest를 통해 최댓값 , least를 통해 최솟값을 구할 수 있습니다.
 * **주의 : 최댓값 최솟값도 null값이 존재하면 null값을 결과로 호출한다. null 값을 잘 치환 해줘야합니다.**
 
 null값 치환은 비교구문 뿐만 아닌 사칙연산( ex) 매출)에서 자주 나옵니다.
 
          select year , (q1+q2+q3+q4) / 4 as average
              from sql-study-project-376507.sql_study_bigquery.quarterly_sales
                  order by year;

![666666666666](https://user-images.githubusercontent.com/113004818/216070728-8fd87ff5-8504-44ba-842f-1ccc032eb064.PNG)
<br> 이러한 경우 null 값을 5강때처럼 coalesce 함수를 통해 0으로 치환 합니다.

           select year , (coalesce(q1,0)+coalesce(q2,0)+coalesce(q3,0)+coalesce(q4,0)) / 4 as average
              from sql-study-project-376507.sql_study_bigquery.quarterly_sales
                  order by year;
                  
![11111111111111](https://user-images.githubusercontent.com/113004818/216071462-b30699c3-cb7b-4a07-a1d5-bd408bc83dcc.PNG)
<br> 하지만 0이 들어가 컬럼의 수는 늘어났고 평균값이 극단적으로 낮게 표시됩니다. 

**이러한 경우 sign 함수를 이용해 null값을 0으로 치환 하더라도 분모가 늘어나지 않게 조절합니다.**

            select year , (coalesce(q1,0)+coalesce(q2,0)+coalesce(q3,0)+coalesce(q4,0)) / 
                (sign(coalesce(q1,0)) + sign(coalesce(q2,0)) + sign(coalesce(q3,0))+sign(coalesce(q4,0))) as average - 양수면 1 0이면 0
                    from sql-study-project-376507.sql_study_bigquery.quarterly_sales
                      order by year;   
                      
 ![22222222222222](https://user-images.githubusercontent.com/113004818/216072429-6a00451e-0af4-46cf-97e7-d32058892e6e.PNG)
                    
 **비율을 구할때는 coalesce 함수를 사용해 0으로 치환한다면 자칫 분모가 0이 될 수도 있습니다.   **
 
           select * 
              from sql-study-project-376507.sql_study_bigquery.advertising_stats;

![33333333333](https://user-images.githubusercontent.com/113004818/216075183-b12d7345-d9ff-4823-83a4-441a76491e06.PNG)
<br> 위 식을 이용해 4월2일 클릭수 / 노출수 -> 각 광고의 ctr을 구한다면, 분모가 0이 되는 경우의 수가 발생합니다.

**이러한 경우 case 식을 이용해 impressions가 0인 경우를 찾는 방법으로 해결 가능합니다. **

          select dt, ad_id,
            case
                when impressions > 0 then clicks / impressions * 100.0
                end as ctr_as_percent_by_case,
                clicks / nullif(impressions,0) as ctr_as_percent_by_nullif
                    from sql-study-project-376507.sql_study_bigquery.advertising_stats;
                
                -- 분모가 0인경우를 막기위해 0이면 null값으로 치환하는 nullif 식을 사용할 수도 있다.
             
![4444444444444444](https://user-images.githubusercontent.com/113004818/216076796-7ac38f18-a266-4167-aecc-6f27abd3f60c.PNG)



