--Inactive Wholesale Dealer List
select ci.customer_id, ci.name
  from ifsapp.customer_info ci, ifsapp.cust_ord_customer_tab coct
 where ci.customer_id = coct.customer_no
   and coct.cust_grp = '003'
   and (ci.customer_id like 'W000%' or ci.customer_id like 'S000%' or
       ci.customer_id like 'WIT0%')

MINUS

SELECT W.CUSTOMER_NO, W.CUSTOMER_NAME
  FROM ifsapp.sbl_vw_wholesale_sales_new W
 WHERE W.SALES_DATE between to_date('&FROM_DATE', 'yyyy/mm/dd') and
       to_date('&TO_DATE', 'yyyy/mm/dd')
   and W.SITE in ('JWSS', 'SAOS', 'SWSS', 'WSMO', 'SITM', 'WITM', 'SSAM')
 order by 1
