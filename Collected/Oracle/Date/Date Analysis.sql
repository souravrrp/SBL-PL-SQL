to_char(add_months(to_date(concat('01',substr(to_date('&START_DATE', 'DD/MM/YYYY'),3,10)),'dd/mm/yy')-1,0),'mm')*1

--first date of the month
select to_date(concat('01',substr(to_date('&START_DATE', 'MM/DD/YYYY'),3,7))) date_i from dual
select trunc(to_date('&START_DATE', 'MM/DD/YYYY'), 'mm') date_i from dual;

--first date from year and month
select trunc(to_date('&year'||'/'||'&month'||'/1', 'YYYY/MM/DD'), 'MM') date_i from dual;

--last date of the month
select last_day(to_date('&START_DATE', 'MM/DD/YYYY')) date_i from dual

--last date from year and month
select last_day(to_date('&year'||'/'||'&month'||'/1', 'YYYY/MM/DD')) date_i from dual


--extract year or month from a date
select extract(year from to_date('&START_DATE', 'MM/DD/YYYY')) date_i from dual
select extract(month  from (to_date('&START_DATE', 'MM/DD/YYYY') - 1)) date_i from dual
select extract(day  from to_date('&START_DATE', 'MM/DD/YYYY')) date_i from dual

--months between two dates
select trunc(months_between(to_date('&END_DATE', 'MM/DD/YYYY'), to_date('&START_DATE', 'MM/DD/YYYY'))) "No of Months" from dual

--Add or Subtract months from a date
select add_months(to_date('&START_DATE', 'YYYY/MM/DD'), -1) from dual
select add_months(to_date('&START_DATE', 'YYYY/MM/DD'), 1) from dual
