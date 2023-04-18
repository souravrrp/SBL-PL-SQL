/* Formatted on 4/3/2023 2:04:47 PM (QP5 v5.381) */
SELECT hsrt.sales_return_no,
       hsrt.date_requested
           rt_req_date,
       hsrt.return_approver_id
           ret_aprv_id,
       hsrt.customer_no
           customer_number,
       hsrt.rowstate
           status,
       rmlt.order_no,
       rmlt.contract,
       TRUNC (rmlt.date_returned)
           date_returned,
       (hsrlt.base_sale_unit_price * hsrlt.qty_to_return)
           return_value,
       ifsapp.hpnret_sales_return_api.get_total_value (hsrt.sales_return_no)
           total_value,
       ifsapp.hpnret_sales_return_api.get_refund_amt (hsrt.sales_return_no)
           refund_amt,
       ifsapp.hpnret_sales_return_api.get_refund_status (
           hsrt.sales_return_no)
           refund_status,
       ifsapp.hpnret_sales_return_api.Get_Total_Invoice_Value (
           hsrt.sales_return_no)
           Total_Invoice_Value
  --,hsrt.*
  --,hsrlt.*
  --,rmlt.*
  FROM ifsapp.hpnret_sales_return_tab    hsrt,
       ifsapp.hpnret_sales_ret_line_tab  hsrlt,
       ifsapp.return_material_line_tab   rmlt
 WHERE     1 = 1
       AND hsrt.sales_return_no = hsrlt.sales_return_no(+)
       AND hsrt.sales_return_no = rmlt.rma_no(+)
       AND ( :p_customer_no IS NULL OR (hsrt.customer_no = :p_customer_no))
       --and hsrt.sales_return_no in ('1864304','1741953')
       AND (   :p_order_no IS NULL
            OR (UPPER (hsrlt.order_no) = UPPER ( :p_order_no)))
       AND (   :p_return_no IS NULL
            OR (UPPER (hsrt.sales_return_no) = UPPER ( :p_return_no)));

--------------------------------sales return------------------------------------

SELECT *
  FROM ifsapp.hpnret_sales_return_tab hsrt
 WHERE     1 = 1
       --and hsrt.refun_stmt_id is null
       AND (   :p_return_no IS NULL
            OR (UPPER (hsrt.sales_return_no) = UPPER ( :p_return_no)));

SELECT *
  FROM ifsapp.hpnret_sales_ret_line_tab hsrlt
 WHERE     1 = 1
       AND (   :p_return_no IS NULL
            OR (UPPER (hsrlt.sales_return_no) = UPPER ( :p_return_no)))
       AND (   :p_order_no IS NULL
            OR (UPPER (hsrlt.order_no) = UPPER ( :p_order_no)))
       AND ( :p_serial_no IS NULL OR (hsrlt.serial_no = :p_serial_no));


SELECT *
  --,rmlt.*
  FROM ifsapp.return_material_line_tab rmlt
 WHERE     1 = 1
       --and hsrt.sales_return_no in ('1864304','1741953')
       --and rmlt.order_no='1864304'
       AND (   :p_order_no IS NULL
            OR (UPPER (rmlt.order_no) = UPPER ( :p_order_no)))
       AND (   :p_rma_no_no IS NULL
            OR (UPPER (rmlt.rma_no) = UPPER ( :p_rma_no_no)));
            
--------------------------------------------------------------------------------

--ifsapp.hpnret_sales_return_api
--ifsapp.hpnret_sales_ret_line_api
--ifsapp.return_material_line_api