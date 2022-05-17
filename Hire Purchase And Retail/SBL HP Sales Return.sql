/* Formatted on 4/13/2022 11:24:48 AM (QP5 v5.381) */
SELECT hsrt.sales_return_no,
       hsrt.date_requested         rt_req_date,
       hsrt.return_approver_id     ret_aprv_id,
       hsrt.customer_no            customer_number,
       hsrt.rowstate               status
  --,hsrt.*
  --,hsrlt.*
  FROM ifsapp.hpnret_sales_return_tab    hsrt,
       ifsapp.hpnret_sales_ret_line_tab  hsrlt
 WHERE     1 = 1
       AND hsrt.sales_return_no = hsrlt.sales_return_no(+)
       --AND hsrt.sales_return_no in ('1864304','1741953')
       AND (   :p_return_no IS NULL
            OR (UPPER (hsrt.sales_return_no) = UPPER ( :p_return_no)));

--------------------------------------------------------------------------------

SELECT hsrt.sales_return_no,
       hsrt.date_requested         rt_req_date,
       hsrt.return_approver_id     ret_aprv_id,
       hsrt.customer_no            customer_number,
       hsrt.rowstate               status,
       hsrt.*
  FROM ifsapp.hpnret_sales_return_tab hsrt
 WHERE     1 = 1
       --AND hsrt.sales_return_no in ('1864304','1741953')
       AND (   :p_return_no IS NULL
            OR (UPPER (hsrt.sales_return_no) = UPPER ( :p_return_no)));

SELECT *
  FROM hpnret_sales_ret_line_tab hsrlt
 WHERE     1 = 1
       --AND hsr.sales_return_no in ('1864304','1741953')
       AND (   :p_return_no IS NULL
            OR (UPPER (hsr.sales_return_no) = UPPER ( :p_return_no)));


SELECT rmlt.order_no,
       rmlt.contract,
       TRUNC (rmlt.date_returned)     date_returned,
       rmlt.*
  FROM ifsapp.return_material_line_tab rmlt
 WHERE     1 = 1
       --AND rmlt.RMA_NO in ('1864304','1741953')
       AND (   :p_return_no IS NULL
            OR (UPPER (rmlt.RMA_NO) = UPPER ( :p_return_no)));

--------------------------------------------------------------------------------

SELECT *
  FROM ifsapp.hpnret_sales_return hsr
 WHERE     1 = 1
       --AND hsr.sales_return_no in ('1864304','1741953')
       AND (   :p_return_no IS NULL
            OR (UPPER (hsr.sales_return_no) = UPPER ( :p_return_no)));

SELECT *
  FROM ifsapp.hpnret_sales_ret_line hsrl
 WHERE     1 = 1
       --AND hsr.sales_return_no in ('1864304','1741953')
       AND (   :p_return_no IS NULL
            OR (UPPER (hsrl.sales_return_no) = UPPER ( :p_return_no)));

--------------------------------VIEW--------------------------------------------

SELECT *
  FROM ifsapp.sbl_return_info sri;