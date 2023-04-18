/* Formatted on 3/21/2023 9:10:08 AM (QP5 v5.381) */
SELECT contract,
       customer_number,
       customer_name,
       status,
       order_no,
       order_amount,
       refund_amt,
       sales_return_no,
       date_returned,
       refund_status
  FROM (SELECT hsrlt.contract,
               hsrt.customer_no
                   customer_number,
               ifsapp.customer_info_api.get_name (hsrt.customer_no)
                   customer_name,
               hsrt.rowstate
                   status,
               hsrlt.order_no,
               ROUND (
                   ifsapp.customer_order_api.get_ord_gross_amount (
                       hsrlt.order_no))
                   order_amount,
               ifsapp.hpnret_sales_return_api.get_refund_amt (
                   hsrt.sales_return_no)
                   refund_amt,
               hsrt.sales_return_no,
               TRUNC (hsrlt.date_returned)
                   date_returned,
               ifsapp.hpnret_sales_return_api.get_refund_status (
                   hsrt.sales_return_no)
                   refund_status
          --,hsrt.*
          --,hsrlt.*
          --,rmlt.*
          FROM ifsapp.hpnret_sales_return_tab    hsrt,
               ifsapp.hpnret_sales_ret_line_tab  hsrlt
         WHERE     1 = 1
               AND hsrt.sales_return_no = hsrlt.sales_return_no(+)
               AND (   :p_customer_no IS NULL
                    OR (hsrt.customer_no = :p_customer_no))
               --and hsrt.sales_return_no in ('1864304','1741953')
               AND (   :p_order_no IS NULL
                    OR (UPPER (hsrlt.order_no) = UPPER ( :p_order_no)))
               AND (   :p_return_no IS NULL
                    OR (UPPER (hsrt.sales_return_no) = UPPER ( :p_return_no)))
               AND TRUNC (hsrlt.date_returned) BETWEEN NVL (
                                                           :p_date_from,
                                                           TRUNC (
                                                               hsrlt.date_returned))
                                                   AND NVL (
                                                           :p_date_to,
                                                           TRUNC (
                                                               hsrlt.date_returned)))
 WHERE order_amount > refund_amt;