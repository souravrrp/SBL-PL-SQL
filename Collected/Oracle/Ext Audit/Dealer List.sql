--Dealer List
SELECT W.CUSTOMER_NO,
       W.CUSTOMER_NAME,
       IFSAPP.CUSTOMER_INFO_ADDRESS_API.Get_Address1(W.CUSTOMER_NO, 1) ||
       IFSAPP.CUSTOMER_INFO_ADDRESS_API.Get_Address2(W.CUSTOMER_NO, 1) Address,
       IFSAPP.CUSTOMER_INFO_ADDRESS_API.Get_Address(w.CUSTOMER_NO, 1) addr,
       IFSAPP.CUSTOMER_INFO_ADDRESS_API.Get_Full_Address(w.CUSTOMER_NO, 1) full_add
  FROM ifsapp.sbl_vw_wholesale_sales W
 WHERE W.SALES_DATE between to_date('&FROM_DATE', 'yyyy/mm/dd') and
       to_date('&TO_DATE', 'yyyy/mm/dd')
   and W.SITE in ('JWSS', 'SAOS', 'SWSS', 'WSMO')
 group by W.CUSTOMER_NO, W.CUSTOMER_NAME

union all

SELECT W.CUSTOMER_NO,
       W.CUSTOMER_NAME,
       IFSAPP.CUSTOMER_INFO_ADDRESS_API.Get_Address1(W.CUSTOMER_NO, '01') ||
       IFSAPP.CUSTOMER_INFO_ADDRESS_API.Get_Address2(W.CUSTOMER_NO, '01') Address,
       IFSAPP.CUSTOMER_INFO_ADDRESS_API.Get_Address(w.CUSTOMER_NO, '01') addr,
       IFSAPP.CUSTOMER_INFO_ADDRESS_API.Get_Full_Address(w.CUSTOMER_NO, 1) full_add
  FROM ifsapp.sbl_vw_wholesale_sales W
 WHERE W.SALES_DATE between to_date('&FROM_DATE', 'yyyy/mm/dd') and
       to_date('&TO_DATE', 'yyyy/mm/dd')
   and W.SITE = 'SCSM'
 group by W.CUSTOMER_NO, W.CUSTOMER_NAME
 order by 1
