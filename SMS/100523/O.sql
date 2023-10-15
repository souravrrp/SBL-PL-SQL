/* Formatted on 5/9/2023 4:53:14 PM (QP5 v5.381) */
SELECT t.site,
       t.order_no,
       t.product_code,
       ifsapp.inventory_part_api.Get_Prime_Commodity (t.site, t.product_code)
           PROD_GROUP,
       TO_CHAR (TRUNC (t.sales_date), 'YYYY-MM-DD')
           Sale_Date,
       t.status,
       t.customer_no,
       IFSAPP.CUSTOMER_INFO_API.Get_Name (t.customer_no)
           CUSTOMER_NAME,
       r.VALUE
           MOBILE_NO
  FROM IFSAPP.SBL_JR_SALES_DTL_INV t, IFSAPP.CUSTOMER_INFO_COMM_METHOD r
 WHERE     t.customer_no = r.customer_id
       AND t.status = 'HireSale'
       --AND t.site = :P_SITE
       AND IFSAPP.HPNRET_HP_HEAD_API.GET_OBJSTATE (t.order_no, 1) = 'Active'
       AND ifsapp.inventory_product_family_api.get_description (
               ifsapp.inventory_part_api.get_part_product_family (
                   'SCOM',
                   t.product_code)) NOT IN
               ('OVEN-MICROWAVE', 'OVEN-ELECTRICWAVE', 'OVEN-GAS')
UNION ALL
SELECT p.site,
       p.order_no,
       p.product_code,
       ifsapp.inventory_part_api.Get_Prime_Commodity (p.site, p.product_code)
           PROD_GROUP,
       TO_CHAR (TRUNC (p.sales_date), 'YYYY-MM-DD')
           Sale_Date,
       p.status,
       p.customer_no,
       ifsapp.customer_info_api.Get_Name (p.customer_no),
       r.VALUE
           MOBILE_NO
  FROM IFSAPP.SBL_JR_SALES_DTL_PKG_COMP p, IFSAPP.CUSTOMER_INFO_COMM_METHOD r
 WHERE     p.customer_no = r.customer_id
       AND p.status = 'HireSale'
       --AND p.site = :P_SITE
       AND IFSAPP.HPNRET_HP_HEAD_API.GET_OBJSTATE (p.order_no, 1) = 'Active'
       AND ifsapp.inventory_product_family_api.get_description (
               ifsapp.sales_part_api.get_part_product_family ('SCOM',
                                                              p.product_code)) NOT IN
               ('OVEN-MICROWAVE', 'OVEN-ELECTRICWAVE', 'OVEN-GAS')