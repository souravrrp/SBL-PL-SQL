--*****Start INV Sales Data Maintenance Yearly
select * from SBL_JR_SALES_DTL_INV t;

select min(t.sales_date) from SBL_JR_SALES_DTL_INV t
where extract (year from t.sales_date) = '2017';

select max(t.sales_date) from SBL_JR_SALES_DTL_INV t
where extract (year from t.sales_date) = '2017';

select count(*) from SBL_JR_SALES_DTL_INV t
where extract (year from t.sales_date) = '2017';
/*t.sales_date between to_date('2015/01/01', 'YYYY/MM/DD') and to_date('2015/12/31', 'YYYY/MM/DD');*/

/*
delete from SBL_JR_SALES_DTL_INV t
where extract (year from t.sales_date) = '2017';
commit;
*/
--*****End INV Sales Data Maintenance Yearly


--*****Start PKG Sales Data Maintenance Yearly
select * from SBL_JR_SALES_DTL_PKG t;

select min(t.sales_date) from SBL_JR_SALES_DTL_PKG t
where extract (year from t.sales_date) = '2017';

select max(t.sales_date) from SBL_JR_SALES_DTL_PKG t
where extract (year from t.sales_date) = '2017';

select count(*) from SBL_JR_SALES_DTL_PKG t
where extract (year from t.sales_date) = '2017';

/*
delete from SBL_JR_SALES_DTL_PKG t
where extract (year from t.sales_date) = '2017';
commit;
*/
--*****End PKG Sales Data Maintenance Yearly


--*****Start COMP Sales Data Maintenance Yearly
select * from SBL_JR_SALES_DTL_PKG_COMP t;

select min(t.sales_date) from SBL_JR_SALES_DTL_PKG_COMP t
where extract (year from t.sales_date) = '2017';

select max(t.sales_date) from SBL_JR_SALES_DTL_PKG_COMP t
where extract (year from t.sales_date) = '2017';

select count(*) from SBL_JR_SALES_DTL_PKG_COMP t
where extract (year from t.sales_date) = '2017';

/*
delete from SBL_JR_SALES_DTL_PKG_COMP t
where extract (year from t.sales_date) = '2017';
commit;
*/
--*****End COMP Sales Data Maintenance Yearly


--*****Start Sales Data Maintenance Daily
select SUM(t.sales_quantity), sum(t.sales_price) from SBL_JR_SALES_DTL_INV t
where t.sales_date = to_date('2017/12/20', 'YYYY/MM/DD');

select sum(t.sales_quantity), sum(t.sales_price) from SBL_JR_SALES_DTL_PKG t
where t.sales_date = to_date('2017/12/20', 'YYYY/MM/DD');

select sum(t.sales_quantity), sum(t.sales_price) from SBL_JR_SALES_DTL_PKG_COMP t
where t.sales_date = to_date('2017/12/20', 'YYYY/MM/DD');

/*delete from SBL_JR_SALES_DTL_INV t
where t.sales_date = to_date('2017/12/20', 'YYYY/MM/DD');
commit;*/

/*delete from SBL_JR_SALES_DTL_PKG t
where t.sales_date = to_date('2017/12/20', 'YYYY/MM/DD');
commit;*/

/*delete from SBL_JR_SALES_DTL_PKG_COMP t
where t.sales_date = to_date('2017/12/20', 'YYYY/MM/DD');
commit;*/
--*****End Sales Data Maintenance Daily
