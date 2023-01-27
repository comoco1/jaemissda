> 책 '혼자 공부하는 sql'을 참고하였습니다.

## select 째끔 응용
  
  #### 1. order by 절
   * 테이블 안 db의 순서를 변경하고 싶을때 사용(순서만 바뀌지 결과에 영향을 크게 미치지 않는다.)
   * ``` select ~ from ~ where ~ order by  ~ ; ```
   * ``` select * from member order by debut_date; ``` -> 디폴트 값은 오름차순(asc)
   * ``` select * from member order by debut_date desc; ``` -> 내림차순(desc)
   * ``` select * from member order by height desc limit 3; ``` -> limit 3; -> top(3)와 동일 - 위에서 3개
   * ``` select * from member order by height desc limit 3,2; ``` -> 3등부터 2개만 -> 3번째,4번째
  
  #### 2. distinct -> 중복제거
  ``` select distinct addr from member; ``` -> addr 열의 중복을 제거후 member 테이블에서 조회
  
  
  #### 3. group by 절
   * 집계함수와 자주 사용 (sum,avg,max,min,count) - 집계함수 -> 여러 행으로부터 하나의 결괏값을 반환하는 함수
   * ``` select mem_id , sum(amount) from buy group by mem_id; ``` <br>
 ![11111111111111](https://user-images.githubusercontent.com/113004818/215028036-113ae997-48ac-4e51-9f9d-1b64946a9a5f.PNG)
 -> 출력 시 행 이름이 그대로 출력 -> 보기좋게 앨리어스 부여
   *  ``` select mem_id , sum(amount) as "총 구매 횟수" from buy group by mem_id; ``` <br>
   ![22222222222222222](https://user-images.githubusercontent.com/113004818/215028717-b0168bd1-e65a-454e-ae10-c860934977c1.PNG)
   
   


