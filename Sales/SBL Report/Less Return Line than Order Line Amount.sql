/* Formatted on 4/4/2023 10:00:31 AM (QP5 v5.381) */
SELECT CONTRACT,
       STATUS,
       CUSTOMER_NO,
       ORDER_NO,
       ORDER_AMOUNT,
       ORDER_LINE_QTY,
       LINE_AMOUNT,
       RETURN_QTY,
       PART_NO,
       SALES_RETURN_NO,
       ORDER_RETURN_VALUE,
       RETURNED_QTY,
       LINE_RETURN_VALUE,
       VAT_AMOUNT,
       ORIGINAL_ORDER_REFUNDED_AMT,
       DATE_RETURNED,
       REFUND_STATUS
  FROM (SELECT hsrlt.contract,
               hsrlt.rowstate
                   status,
               colt.customer_no,
               hsrlt.order_no,
               ROUND (
                   ifsapp.customer_order_api.get_ord_gross_amount (
                       hsrlt.order_no))
                   order_amount,
               ifsapp.customer_order_line_api.Get_Buy_Qty_Due (
                   hsrlt.order_no,
                   hsrlt.line_no,
                   hsrlt.rel_no,
                   hsrlt.line_item_no)
                   order_line_qty,
                 ifsapp.customer_order_line_api.get_sale_price_total (
                     hsrlt.order_no,
                     hsrlt.line_no,
                     hsrlt.rel_no,
                     hsrlt.line_item_no)
               + ifsapp.customer_order_line_api.Get_Total_Tax_Amount (
                     hsrlt.order_no,
                     hsrlt.line_no,
                     hsrlt.rel_no,
                     hsrlt.line_item_no)
                   line_amount,
               colt.qty_returned
                   return_qty,
               colt.part_no,
               hsrlt.sales_return_no,
               ifsapp.hpnret_sales_return_api.Get_Total_Value (
                   hsrlt.sales_return_no)
                   order_return_value,
               hsrlt.qty_returned_inv
                   returned_qty,
               hsrlt.qty_returned_inv * hsrlt.sale_unit_price
                   line_return_value,
               ifsapp.customer_order_line_api.Get_Total_Tax_Amount (
                   hsrlt.order_no,
                   hsrlt.line_no,
                   hsrlt.rel_no,
                   hsrlt.line_item_no)
                   vat_amount,
               ifsapp.hpnret_sales_return_api.get_refund_amt (
                   hsrlt.sales_return_no)
                   original_order_refunded_amt,
               TRUNC (hsrlt.date_returned)
                   date_returned,
               ifsapp.hpnret_sales_return_api.get_refund_status (
                   hsrlt.sales_return_no)
                   refund_status
          FROM ifsapp.customer_order_line_tab    colt,
               ifsapp.hpnret_sales_ret_line_tab  hsrlt
         WHERE     1 = 1
               AND colt.order_no = hsrlt.order_no
               AND colt.line_no = hsrlt.line_no
               AND colt.rel_no = hsrlt.rel_no
               AND colt.line_item_no = hsrlt.line_item_no
               AND (   :p_shop_code IS NULL
                    OR (UPPER (hsrlt.contract) = UPPER ( :p_shop_code)))
               AND (   :p_order_no IS NULL
                    OR (UPPER (hsrlt.order_no) = UPPER ( :p_order_no)))
               AND TRUNC (hsrlt.date_returned) BETWEEN NVL (
                                                           :p_date_from,
                                                           TRUNC (
                                                               hsrlt.date_returned))
                                                   AND NVL (
                                                           :p_date_to,
                                                           TRUNC (
                                                               hsrlt.date_returned)))
 WHERE line_return_value > ORIGINAL_ORDER_REFUNDED_AMT;

--------------------------------------------------------------------------------
--hpnret_sales_return_api
--hpnret_sales_ret_line_api
--customer_order_line_api
--customer_order_api
