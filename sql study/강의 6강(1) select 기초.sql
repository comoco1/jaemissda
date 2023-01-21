use market_db;
select * from market_db.member 
where height <= 160;


select addr 지역,debut_date "데뷔 일자" 
from market_db.member 
where mem_name = "블랙핑크";

select * from market_db.member 
where height >= 160 and mem_number >6;
 
select * from market_db.member 
where height >= 160 or mem_name = "에이핑크";

select * from market_db.member 
where height between 160 and 165 ;

select * from market_db.member 
where mem_name in("레드벨벳","우주소녀","오마이걸");

select * from market_db.member 
where mem_id like "O%";

select * from market_db.member 
where mem_id like "__Y";


