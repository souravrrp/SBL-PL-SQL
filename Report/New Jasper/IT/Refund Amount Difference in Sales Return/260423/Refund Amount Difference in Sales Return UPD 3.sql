/* Formatted on 4/27/2023 12:19:57 PM (QP5 v5.381) */
  SELECT contract,
         customer_no,
         customer_name,
         phone_number,
         order_no,
         MAX (sales_date)          sales_date,
         total_amount_settled,
         SUM (refunded_amount)     refunded_amount,
         note
    FROM (  SELECT colt.contract,
                   colt.customer_no,
                   ifsapp.customer_info_api.get_name (colt.customer_no)
                       customer_name,
                   ifsapp.customer_info_comm_method_api.get_any_phone_no (
                       colt.customer_no)
                       phone_number,
                   colt.order_no,
                   MAX (colt.date_entered)
                       sales_date,
                   (CASE
                        WHEN (SELECT ROUND (SUM (hprt.amount))
                                FROM ifsapp.hpnret_pay_receipt_head_tab hprht,
                                     ifsapp.hpnret_pay_receipt_tab   hprt
                               WHERE     1 = 1
                                     AND hprht.receipt_no = hprt.receipt_no
                                     AND hprt.ROWSTATE = 'Approved'
                                     AND hprht.account_no = colt.order_no) <>
                             0
                        THEN
                            (SELECT ROUND (SUM (hprt.amount))
                               FROM ifsapp.hpnret_pay_receipt_head_tab hprht,
                                    ifsapp.hpnret_pay_receipt_tab   hprt
                              WHERE     1 = 1
                                    AND hprht.receipt_no = hprt.receipt_no
                                    AND hprt.ROWSTATE = 'Approved'
                                    AND hprht.account_no = colt.order_no)
                        ELSE
                            ROUND (
                                  (SUM (
                                         hsrlt.qty_returned_inv
                                       * hsrlt.sale_unit_price))
                                + (  SUM (
                                           hsrlt.qty_returned_inv
                                         * colt.base_sale_unit_price)
                                   * (SELECT (sft.fee_rate / sft.deductible)
                                        FROM ifsapp.statutory_fee_tab sft
                                       WHERE hsrlt.fee_code = sft.fee_code)))
                    END)
                       total_amount_settled,
                   ifsapp.hpnret_sales_return_api.get_refund_amt (
                       hsrlt.sales_return_no)
                       refunded_amount,
                   hsrlt.rowstate
                       order_status,
                   ifsapp.hpnret_sales_return_api.get_refund_status (
                       hsrlt.sales_return_no)
                       refund_status,
                   (SELECT hcot.REMARKS
                      FROM ifsapp.hpnret_customer_order_tab hcot
                     WHERE hcot.order_no = colt.order_no)
                       note
              FROM ifsapp.customer_order_line_tab colt,
                   ifsapp.hpnret_sales_ret_line_tab hsrlt
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
                                                                   hsrlt.date_returned))
          GROUP BY colt.contract,
                   colt.order_no,
                   colt.customer_no,
                   hsrlt.sales_return_no,
                   hsrlt.fee_code,
                   hsrlt.rowstate)
GROUP BY contract,
         customer_no,
         customer_name,
         phone_number,
         order_no,
         total_amount_settled,
         note
  HAVING total_amount_settled - SUM (refunded_amount) > 1;