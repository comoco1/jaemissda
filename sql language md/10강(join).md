> 책 '혼자 공부하는 sql'을 참고하였습니다.

## 조인

실 업무중 다루는 데이터는 무수히 많으며, 하나의 db의 데이터로는 모든 정보를 알지 못한다.
테이블끼리 결합시 더 많은 정보를 파악할 수 있으며 sql에서는 join으로 결합을 실행한다.

  * join -> 테이블 끼리 결합하는 것
  * 조인 시 테이블끼리는 일대다 관계로 맺어져 있어야함
  
#### 1. 내부조인 (inner join)
  * 가장 많이 사용하는 join 방법으로, 대부분 join이라 하면 내부 조인을 일컫음
  * select (조회하려는 열이름) from (테이블1) inner join (테이블2) on (조건) ;
  * ``` select * from member as a inner join buy as b on a.mem_id = b.mem_id where a.mem_id = 'GRL'; ```
  <br>
  
![1111111111111111111](https://user-images.githubusercontent.com/113004818/215309003-f1167fe6-d993-4710-bec1-14f8b5e826b4.PNG)
  
 member 테이블과 buy 테이블이 같은 mem_id 조건으로 결합 되어있는 것을 알 수 있다.

 ``` select mem_id , mem_name , addr , concat(phone1,phone2) as 연락처 from member as a inner join buy as b on a.mem_id = b.mem_id; ```
  * 이렇게 쿼리문을 작성 시, select 절 바로 뒤 mem_id는 member 테이블, buy 테이블 둘 다 존재하기 때문에 오류가 발생한다.
  * 이러한 이유로 어디 테이블에서 가져올 것인지 붙혀줘야한다.
 
 ``` select a.mem_id , mem_name ,addr , concat(phone1,phone2) as 연락처 from member as a inner join buy as b on a.mem_id = b.mem_id; ```
 <br>
![2222222222222222222222](https://user-images.githubusercontent.com/113004818/215309348-af02bbae-5123-45d8-8dcb-5ab122ad30b2.PNG)
<br>
정상적으로 작동하는 모습이다.


  * 내부조인의 문제점은 market.db를 예시로(member테이블, buy테이블) buy테이블에 있는 데이터만(구매한 멤버) 조인되기 때문에 구매를 하지 않은 member는 조회되지 않는다.

#### 2. 외부조인 (outer join)
  * 한쪽의 모든 데이터를 조인하고 싶을때 사용
  * left outer join / right outer join / full outer join 존재
  * outer는 생략해도 가능 -> left join / right join / full join

''' select * from member as a left join buy as b on a.mem_id = b.mem.id order by a.mem_id; ```
<br>
![4444444444444](https://user-images.githubusercontent.com/113004818/215309869-c25e741e-7e87-46ad-86fe-e124beaa15d9.PNG)

<br>
내부조인 때와 다르게 구매하지 않은 member 테이블도 같이 join으로 표시


``` select * from buy as b right join member as a on b.mem_id = a.mem_id order by b.mem_id; ```
right 조인을 사용하여 위와 같이 표현

  * 상호조인 (croos join)
  * 대용량의 데이터를 생성할때 내용과 관련없이 모두 결합
 
 
    





