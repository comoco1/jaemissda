> **책 '데이터 분석을 위한 sql 레시피'를 참고했습니다.**

## <교재 5강 하나의 값 조작하기>

수집한 데이터의 일부(업무 데이터와 같은 것)들은 원래 분석용도의 데이터가 아니라 분석 활용에 어려운 경우가 종종 있다. <br>
 -> 이러한 데이터를 분석에 적합하게 가공하는 법 설명 (하나의 값만)


##### 1. 코드값을 의미있는 값으로 변경하기
  * 업무 데이터에는 데이터베이스에 코드값으로 저장하여 이런 코드값의 의미는 다른 테이블에서 관리하는 경우가 있다. 
  * 만약 이러한 데이터를 가지고 리포트를 작성 할 경우 코드값이 무엇을 의미하는지 정확히 알 수 없게 된다.

``` select * from mst_users; ```
<br> ![5-1](https://user-images.githubusercontent.com/113004818/215972143-d0aed428-1324-48eb-805b-4aeb2fb4b860.PNG)
  * 코드값을 1 -> 데스크톱 2-> 스마트폰 3-> 애플리케이션 으로 변경하고 싶다.  ==특정 조건을 기반으로 값을 결정하는 경우 -> case식을 사용


        select user_id,register_date ,
          case        
            when register_device = 1 then '데스크톱'
            when register_device = 2 then '스마트폰'
                else '애플리케이션'
          end as register_device
        from mst_users;
![5-1 결과](https://user-images.githubusercontent.com/113004818/215972618-a2c37be0-6fda-44e3-bd28-a5d7a8e35586.PNG)


###### 2. url에서 요소 추출하기
# 여기서 부터는 mysql workbench가 아닌 구글 bigquery로 진행 합니다.
     select * from sql-study-project-376507.sql_study_bigquery.access_log;
![5-2 답](https://user-images.githubusercontent.com/113004818/215992211-0c6eb81c-ae6f-4cb5-ac5e-a4201b958461.PNG)

  * 리퍼러는 누가 어떤 사이트를 타고 특정 사이트에 접속 했는지 알 수 있는 요소이다. 
  * 하지만 이처럼 페이지 단위로 집계시 복잡해짐으로 호스트 단위로 집계하는 것이 일반적이다.

-> host 단위로 집계법

          select stamp , net.host(referrer) as referrer     --net.host(~)
            from access_log;
            
 ![123123](https://user-images.githubusercontent.com/113004818/215995265-8c75b6ed-ad8c-4635-a3df-515685dfa638.PNG)


##### 3. 문자열 분해하기
 * 빅데이터 분석에서 가장많이 사용하는 자료형은 문자열이다.
 * 문자열 자료형은 범용적인 자료형이므로 더 세부적으로 분해해서 사용해야 하는 경우가 많다.
 
 -> 문자열을 슬래시로 분할해 계층을 추출하는 쿼리
 
         select stamp,url,
          split(regexp_extract(url,'//[^/]+([^?#]+)'),'/')[safe_ordinal(2)] as paht1,   
          split(regexp_extract(url,'//[^/]+([^?#]+)'),'/')[safe_ordinal(3)] as paht2                
           from sql-study-project-376507.sql_study_bigquery.access_log;               
          -- split(나눌 값, 나누는 기준(여기선 슬래시))
          -- regexp_extract(주소,표현기호) -> url을 표현기호'//[^/]+([^?#]+)' , 슬래시로 나눔
          -- safe_ordinal()은 배열의 인덱스를 1부터 0부터는 safe_offset

![333333333333](https://user-images.githubusercontent.com/113004818/216042449-3ea619b2-b1a6-4bc3-ba57-d99d50b6c2ff.PNG)

##### 4. 날짜데이터 추출하기
 * 문자열 뿐 아니라 날짜 데이터인 경우도 특정 년도,월 등 분할해 추출하는 경우가 많다.
 
 -> 현재날짜와 타임스탬프를 추출하기
 
     select current_date() as dt, current_timestamp() as stamp 
      from sql-study-project-376507.sql_study_bigquery.access_log;
 
![444444444444](https://user-images.githubusercontent.com/113004818/216044241-73d950a3-2054-4eea-a5f0-ca49ac1113c5.PNG)
<br> 현재날짜 뿐 만 아닌 지정한 날의 날짜와 타임스탬프도 조회할 수 있다. ex) date('2000-07-11') as dt , timestamp('2000-07-11 05:30:00') as ts

  -> 특정 필드 추출하기
    * 날짜 데이터인 경우에는 년 / 월 / 일 / 시간 딱딱 정해져 있어 특정 필드의 값을 추출할 수 있다.
   
      select stamp 
       ,extract(YEAR from cast(stamp as timestamp)) as year   -- 실수로 첫 쿼리 생성시 타임스탬프를 string 형식으로 저장해 cast함수를 이용해 변환
       ,extract(MONTH from cast(stamp as timestamp)) as month
       ,extract(DAY from cast(stamp as timestamp)) as day
       ,extract(HOUR from cast(stamp as timestamp)) as year
         from sql-study-project-376507.sql_study_bigquery.access_log;
     
![55555555555](https://user-images.githubusercontent.com/113004818/216047213-b6fdb1ed-5532-408a-a137-5a69a4184f9c.PNG)


##### 5. 결손값 대치하기
 * null과 사칙연산을 한 숫자형 데이터는 null값으로 표기
 * 할인이 없는 상태에서 정가와 할인가를 db에서 빼기 실행시 null값으로 표현
 * 이러한 경우를 막기위해 널 값일 경우 0으로 가공해 실행
 
 -> colaesce 함수를 사용해 결손값 대치
    
    select purchase_id,amount,coupon, 
     amount-cast(coupon as int64) as discount_amount1,
     amount-coalesce(cast(coupon as int64),0) as discount_amount2
       from sql-study-project-376507.sql_study_bigquery.pruchase_log_with_coupon;

![77777777777](https://user-images.githubusercontent.com/113004818/216050054-c94e5b74-6a86-4229-bdd0-77e1f4152d5d.PNG)

        
