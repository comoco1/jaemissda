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
select * from access_log;
  * 리퍼러는 누가 어떤 사이트를 타고 특정 사이트에 접속 했는지 알 수 있는 요소이다. 
  * 하지만 이처럼 페이지 단위로 집계시 복잡해짐으로 호스트 단위로 집계하는 것이 일반적이다.

-> host 단위로 집계법

          select stamp , host(referrer,'HOST') as referrer
            from access_log;
        
