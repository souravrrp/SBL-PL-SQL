/*select '01'||'/'||to_char(extract(month from TO_DATE('&DATE','YYYY/MM/DD')))||'/'||to_char(extract(year from TO_DATE('&DATE','YYYY/MM/DD')))as FIRSTDAYOFMONTH from dual

select '01'||'/'||to_char(extract(month from TO_DATE('&DATE','YYYY/MM/DD')))||'/'||to_char(extract(year from TO_DATE('&DATE','YYYY/MM/DD')))as FIRSTDAYOFMONTH from dual

'&PERIOD'
'&YEAR'
'01'
'/'*/

SELECT TO_CHAR(TO_DATE('&YEAR'||'/'||'&PERIOD'||'/01','YYYY/MM/DD'),'YYYY/MM/DD') AS FIRSTDAY FROM DUAL 

/*
select concat ('Humaira','Islam')as FullName from dual;*/

/*SELECT LAST_DAY(TO_DATE('05/10/2021','DD/MM/YYYY'))FROM DUAL;*/


/*SELECT
  LAST_DAY(ADD_MONTHS(SYSDATE,-1 )) LAST_DAY_LAST_MONTH,
  LAST_DAY(ADD_MONTHS(SYSDATE,1 )) LAST_DAY_NEXT_MONTH
FROM
  dual;*/

SELECT *
  FROM hpnret_form249_arrears_tab t
 WHERE to_number(case
         when length(CONCAT(to_char(t.year), to_char(t.period))) = 5 then
          to_char(t.year) || '0' || to_char(t.period)
         when length(CONCAT(to_char(t.year), to_char(t.period))) = 6 then
          CONCAT(to_char(t.year), to_char(t.period)) 
       end) between to_number(case
         when length(concat('&start_year', '&start_period')) = 5 then
          '&start_year' || '0' || '&start_period'
         when length(concat('&start_year', '&start_period')) = 6 then
          concat('&start_year', '&start_period')
       end) and to_number(case
         when (concat('&end_year', '&end_period')) = 5 then
          '&end_year' || '0' || '&end_period'
         when length(concat('&end_year', '&end_period')) = 6 then
          concat('&end_year', '&end_period')
       end)
























