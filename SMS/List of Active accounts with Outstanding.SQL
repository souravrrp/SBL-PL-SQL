/* Formatted on 2/14/2023 12:03:24 PM (QP5 v5.381) */
  SELECT t.site,
         t.order_no,
         t.customer_no,
         IFSAPP.CUSTOMER_INFO_API.Get_Name (t.customer_no)              CUSTOMER_NAME,
         r.VALUE                                                        MOBILE_NO,
         ifsapp.HPNRET_HP_HEAD_API.Get_Total_Out_Bal (t.order_no, 1)    outstanding_balance
    FROM IFSAPP.SBL_JR_SALES_DTL_INV t, IFSAPP.CUSTOMER_INFO_COMM_METHOD r
   WHERE     t.customer_no = r.customer_id
         AND t.status = 'HireSale'
         AND IFSAPP.HPNRET_HP_HEAD_API.GET_OBJSTATE (t.order_no, 1) in ( 'Active', 'PartiallyActive')
         AND R.COMM_ID=1
         AND t.site = :P_SITE
         --AND t.order_no = :p_order_no
GROUP BY t.site,
         t.order_no,
         t.customer_no,
         r.VALUE
UNION ALL
  SELECT p.site,
         p.order_no,
         p.customer_no,
         ifsapp.customer_info_api.Get_Name (p.customer_no),
         r.VALUE                                                        MOBILE_NO,
         ifsapp.HPNRET_HP_HEAD_API.Get_Total_Out_Bal (p.order_no, 1)    outstanding_balance
    FROM IFSAPP.SBL_JR_SALES_DTL_PKG_COMP p, IFSAPP.CUSTOMER_INFO_COMM_METHOD r
   WHERE     p.customer_no = r.customer_id
         AND p.status = 'HireSale'
         AND IFSAPP.HPNRET_HP_HEAD_API.GET_OBJSTATE (p.order_no, 1) in ( 'Active', 'PartiallyActive')
         AND p.site = :P_SITE
         --AND p.order_no = :p_order_no
         AND NOT EXISTS(SELECT  1 FROM IFSAPP.SBL_JR_SALES_DTL_INV t2 where t2.order_no=p.order_no)
GROUP BY p.site,
         p.order_no,
         p.customer_no,
         r.VALUE;