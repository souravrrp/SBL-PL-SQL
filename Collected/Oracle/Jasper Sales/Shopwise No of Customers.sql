--*****Shopwise No of Customers
select a.YEAR, /*a.SITE,*/ count(a.Customer_No) "NO OF CUSTOMERS" from (
--*****INV Sales
SELECT extract (year from i.sales_date)"YEAR", /*I.SITE,*/ I.Customer_No
  FROM ifsapp.SBL_JR_SALES_DTL_INV I
 WHERE i.sales_date between to_date('&from_date', 'YYYY/MM/DD') and
       to_date('&to_date', 'YYYY/MM/DD')
   and i.status in ('HireSale', 'CashSale')
   and i.site not in ('BSCP', --Service Sites
                      'BLSP',
                      'CLSP',
                      'CSCP',
                      'CXSP',
                      'DSCP',
                      'FSCP', --New Service Center
                      'JSCP',
                      'KSCP',
                      'MSCP',
                      'NSCP',
                      'RPSP',
                      'RSCP',
                      'SSCP',
                      'MS1C',
                      'MS2C',
                      'BTSC'/*,
                      'JWSS', --Wholesale Sites
                      'SAOS',
                      'SWSS',
                      'WSMO',
                      'SAPM', --Corporate, Employee, & Scrap Sites
                      'SCSM',
                      'SESM',
                      'SHOM',
                      'SISM',
                      'SFSM',
                      'SOSM'*/)
 group by extract (year from i.sales_date), /*i.site,*/ i.customer_no

union

--*****PKG Sales
select extract (year from P.sales_date)"YEAR", /*p.site,*/ p.customer_no
  from ifsapp.SBL_JR_SALES_DTL_PKG p
 where p.sales_date between to_date('&from_date', 'YYYY/MM/DD') and
       to_date('&to_date', 'YYYY/MM/DD')
   and p.status in ('HireSale', 'CashSale')
   and p.site not in ('BSCP', --Service Sites
                      'BLSP',
                      'CLSP',
                      'CSCP',
                      'CXSP',
                      'DSCP',
                      'FSCP', --New Service Center
                      'JSCP',
                      'KSCP',
                      'MSCP',
                      'NSCP',
                      'RPSP',
                      'RSCP',
                      'SSCP',
                      'MS1C',
                      'MS2C',
                      'BTSC'/*,
                      'JWSS', --Wholesale Sites
                      'SAOS',
                      'SWSS',
                      'WSMO',
                      'SAPM', --Corporate, Employee, & Scrap Sites
                      'SCSM',
                      'SESM',
                      'SHOM',
                      'SISM',
                      'SFSM',
                      'SOSM'*/)
 group by extract (year from P.sales_date), /*p.site,*/ p.customer_no) a
 group by a.YEAR/*, a.SITE*/
 order by 1,2