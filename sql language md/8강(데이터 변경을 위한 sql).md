> 책 '혼자 공부하는 sql'을 참고하였습니다.

## 데이터 변경을 위한 sql

#### 1. insert문
  * 테이블 또는 뷰에 한 개 이상의 행을 추가하는 sql질의어
  * insert into (테이블명) values(삽입하고자 하는 내용)

    ex) ``` create table aa(toy_id int auto_increment primary key, toy_name char(4), age int); ```  <br>
            ``` insert into aa values(1,"우디",25); ``` * auto_increment -> 자동으로 1씩 증가시켜주는 속성
  * 모든열 뿐만 아니라 특정한 열의 값만 삽입하고 싶을 경우도 가능
  
    ex) ``` insert into aa(toy_id,age) values(2,30); ```
    
    **응용) 다른 테이블 값을 조회해 벨류로 삽입하기**
    ``` create table member2(mem_id char(4) , addr char(2)); ```
    ``` insert into member2 select mem_id, addr from member; ``` -> member 테이블의 mem_id, addr을 조회하여 그 값을 member2 테이블에 insert 하는 방식

#### 2. update문
   * 테이블에 저장된 튜플의 값을 변경하는 sql질의어
   * update (테이블명) set (바꾸고자 하는 속성);
    
     ex) `` update member set mem_name = "메롱" where mem_name = "바보"; ```

#### 3. delete문
   * 테이블에 저장된 데이터를 삭제하기 위한 sql질의어
   * delete from (테이블명) where 조건식;
   
    ex) ``` delete from member where mem_number = 6; ```
   * 삭제하고자 하는 행 데이터가 pk인 경우 삭제불가
    
    
