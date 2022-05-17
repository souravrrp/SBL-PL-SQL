/* Formatted on 4/5/2022 11:17:20 AM (QP5 v5.381) */
SELECT hsr.sales_return_no,
       hsr.contract,
       hsr.return_approver_id,
       hsr.customer_no,
       hsr.state,
       hsrl.sale_unit_price,
       hsrl.base_sale_unit_price,
       hsrl.date_returned,
       hsrl.catalog_no,
       hsrl.fee_code
  --,hsr.*
  --,hsrl.*
  FROM ifsapp.hpnret_sales_return hsr, ifsapp.hpnret_sales_ret_line hsrl
 WHERE     1 = 1
       AND hsr.sales_return_no = hsrl.sales_return_no
       --AND hsr.sales_return_no in ('1864304','1741953')
       AND (   :p_return_no IS NULL
            OR (UPPER (hsr.sales_return_no) = UPPER ( :p_return_no)));