> 책 '혼자 공부하는 sql'을 참고하였습니다.

## sql 데이터 형식

#### 1. 숫자형 자료
   1) 정수형
      * 소숫점이 없는 숫자형 ex) 1,101,23515
      * int(+-21억) / smallint(+-32000) / tinyint(+-128)
   
   2) 실수형
      * 소숫점이 존재하는 숫자형
      * float(소숫점 7자리) / double(소숫점 15자리)
      * 대부분 소숫점 15자리까지 쓰는 경우가 없어 float 사용
      
      
#### 2. 문자형 자료
   1) 고정길이 문자형(char)
      * char(10) -> 최대 10글자, 10글자를 다 쓰지 않아도 db상에 10글자로 잡음
      * 낭비가 심하지만 가변길이 문자형과 비교해 약간 빠르다
    
   2) 가변길이 문자형(varchar)
   	* varchar(10) -> 최대 10글자, 3글자만 넣었다 가정했을때 3글자의 공간만 확보
   	* 낭비가 없지만 고정길이 문자형과 비교해 약간 느리다
  * char은 내용의 글자수가 항상 동일할때 사용 / varchar는 글자의 개수가 급격하게 변동되는 경우가 많을때 사용
  * 성능적인 측면에서 길이를 변화하지 않는 char사용이 조금 더 유리
  * 맨 앞 숫자를 0으로 사용하고 싶은 경우 숫자형이 아닌 문자형으로 잡아야한다. -> 숫자형 032 = 32 / 문자형 032 = '032' 


#### 3. 대용량 데이터
* text의 대용량 데이터는 longtext(약 42억) / blob형식의 대용량 데이터는 longblob(약 42억)
* blob -> 글자가 아닌 영상이나 사진 데이터

#### 4. 날짜형 자료
* date(yyyy-mm-dd) 날짜를 표시 / time(hh-mm-ss) 시간을 표시 / datetime(yyyy-mm-dd hh-mm-ss) 날짜와 시간 둘다 표시


### 데이터 형식 활용

	``` create table a1 (
		tinyint_col tinyint unsigned not null primary key, -- unsigned (+- 범위를 0부터 시작)
    	smallint_col smallint,
    	int_col int not null,
    	bigint_col bigint,
    	char_col char(243),
    	varchar_col varchar(16222),
    	longtext_col longtext,
    	longblob_col longblob); ```
    
``` insert into a1 values(277,32000,211234143,12312412555); ```  -> 이경우 오류! tinyint usigned는 1 부터 256까지 <br> 
``` select * from a1; ```
