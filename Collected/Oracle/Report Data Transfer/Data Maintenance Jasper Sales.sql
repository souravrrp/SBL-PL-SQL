--***
select *
  from ifsapp.SBL_JR_SALES_DTL_INV i
 where i.sales_date between to_date('&from_date', 'YYYY/MM/DD') and
       to_date('&to_date', 'YYYY/MM/DD');


/*
delete from ifsapp.SBL_JR_SALES_DTL_INV i
 where i.sales_date between to_date('&from_date', 'YYYY/MM/DD') and
       to_date('&to_date', 'YYYY/MM/DD');
commit;
*/


--***
select *
  from ifsapp.SBL_JR_SALES_DTL_PKG p
 where p.sales_date between to_date('&from_date', 'YYYY/MM/DD') and
       to_date('&to_date', 'YYYY/MM/DD');


/*
delete from ifsapp.SBL_JR_SALES_DTL_PKG p
 where p.sales_date between to_date('&from_date', 'YYYY/MM/DD') and
       to_date('&to_date', 'YYYY/MM/DD');
commit;
*/


--***
select *
  from ifsapp.SBL_JR_SALES_DTL_PKG_COMP c
 where c.sales_date between to_date('&from_date', 'YYYY/MM/DD') and
       to_date('&to_date', 'YYYY/MM/DD');


/*
delete from ifsapp.SBL_JR_SALES_DTL_PKG_COMP c
 where c.sales_date between to_date('&from_date', 'YYYY/MM/DD') and
       to_date('&to_date', 'YYYY/MM/DD');
commit;
*/
