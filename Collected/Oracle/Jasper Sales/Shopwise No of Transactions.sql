--*****Shopwise No of Transactions
select a.YEAR, a.SITE, count(a.ORDER_NO) "NO OF TRANSACTIONS" from (
--*****INV Sales
SELECT extract (year from i.sales_date)"YEAR", I.SITE, I.ORDER_NO
  FROM ifsapp.SBL_JR_SALES_DTL_INV I
 WHERE i.sales_date between to_date('&from_date', 'YYYY/MM/DD') and
       to_date('&to_date', 'YYYY/MM/DD')
   and i.status in ('HireSale', 'CashSale')
   and i.site not in ('BSCP', --Service Sites
                      'BLSP',
                      'CLSP',
                      'CSCP',
                      'CXSP', --New Service Center
                      'DSCP',
                      'JSCP',
                      'MSCP',
                      'RPSP', --New Service Center
                      'RSCP',
                      'SSCP',
                      'MS1C',
                      'MS2C',
                      'BTSC',
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
                      'SOSM')
 group by extract (year from i.sales_date), i.site, i.order_no

union

--*****PKG Sales
select extract (year from P.sales_date)"YEAR", p.site, p.order_no
  from ifsapp.SBL_JR_SALES_DTL_PKG p
 where p.sales_date between to_date('&from_date', 'YYYY/MM/DD') and
       to_date('&to_date', 'YYYY/MM/DD')
   and p.status in ('HireSale', 'CashSale')
   and p.site not in ('BSCP', --Service Sites
                      'BLSP',
                      'CLSP',
                      'CSCP',
                      'CXSP', --New Service Center
                      'DSCP',
                      'JSCP',
                      'MSCP',
                      'RPSP', --New Service Center
                      'RSCP',
                      'SSCP',
                      'MS1C',
                      'MS2C',
                      'BTSC',
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
                      'SOSM')
 group by extract (year from P.sales_date), p.site, p.order_no) a
 group by a.YEAR, a.SITE
 order by 1,2
