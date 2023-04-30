/* Formatted on 4/26/2023 11:27:17 AM (QP5 v5.381) */
SELECT contract,
       customer_no,
       customer_name,
       phone_number,
       order_no,
       sales_date,
       total_amount_settled,
       order_line_qty,
       line_amount,
       returned_qty,
       part_no,
       sales_return_no,
       refunded_amount
  FROM (SELECT colt.contract,
               colt.customer_no,
               ifsapp.customer_info_api.get_name (colt.customer_no)
                   customer_name,
               ifsapp.customer_info_comm_method_api.get_any_phone_no (
                   colt.customer_no)
                   phone_number,
               colt.order_no,
               colt.date_entered
                   sales_date,
                 ifsapp.customer_order_api.get_ord_gross_amount (
                     colt.order_no)
               + ifsapp.customer_order_api.get_total_base_charge__ (
                     colt.order_no)
                   total_amount_settled,
               ROUND (
                     ((hsrlt.qty_returned_inv * hsrlt.sale_unit_price))
                   + (  (hsrlt.qty_returned_inv * colt.base_sale_unit_price)
                      * (SELECT sft.fee_rate / sft.deductible
                           FROM ifsapp.statutory_fee_tab sft
                          WHERE hsrlt.fee_code = sft.fee_code)))
                   line_amount,
               ((hsrlt.qty_returned_inv * hsrlt.sale_unit_price))
                   discounted_nsp,
               (  (hsrlt.qty_returned_inv * colt.base_sale_unit_price)
                * (SELECT sft.fee_rate / sft.deductible
                     FROM ifsapp.statutory_fee_tab sft
                    WHERE hsrlt.fee_code = sft.fee_code))
                   vat_amount,
               colt.buy_qty_due
                   order_line_qty,
               colt.qty_returned
                   return_qty,
               colt.part_no,
               hsrlt.sales_return_no,
               hsrlt.qty_returned_inv
                   returned_qty,
               ifsapp.hpnret_sales_return_api.get_refund_amt (
                   hsrlt.sales_return_no)
                   refunded_amount,
               TRUNC (hsrlt.date_returned)
                   date_returned,
               hsrlt.rowstate
                   order_status,
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
               AND hsrlt.fee_code <> '0'
               AND hsrlt.rowstate = 'ReturnCompleted'
               AND NOT EXISTS
                       (SELECT 1
                          FROM ifsapp.HPNRET_SALES_RET_CHARGE_tab hsrct
                         WHERE     hsrct.sales_return_no =
                                   hsrlt.sales_return_no
                               AND SIGN (hsrct.charge_amount) = -1)
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
 WHERE     total_amount_settled > refunded_amount
       AND line_amount <> refunded_amount;