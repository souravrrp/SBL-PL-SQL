/* Formatted on 4/9/2023 1:51:30 PM (QP5 v5.381) */
  SELECT CUSTOMER_NO,
         CUSTOMER_NAME,
         ORDER_NO,
         SUM (QUANTIY)
             QTY,
         SUM (NSP)
             NSP,
         SUM (DISCOUNTED_NSP)
             DISCOUNTED_NSP,
         ROUND (SUM (DEALER_INCENTIVE), 2)
             DEALER_INCENTIVE,
         ROUND (SUM (NET_SALES_AFTER_INCENTIVE), 2)
             NET_SALES_AFTER_INCENTIVE,
         SUM (TOTAL_COST)
             TOTAL_COST,
         ROUND (SUM (GM_AMOUNT))
             GP_AMOUNT,
         --ROUND (AVG (GM_PERCENT), 2) GP_PERCENT,
         ROUND (
               (ROUND (SUM (NET_SALES_AFTER_INCENTIVE), 2) - SUM (TOTAL_COST))
             / ROUND (SUM (NET_SALES_AFTER_INCENTIVE), 2),
             2)
             GP_PERCENT,
         ROUND (SUM (OPERATION_COST))
             OP_AMOUNT,
         --ROUND (AVG (OP_PERCENT), 2) OP_PERCENT,
         ROUND (
               (ROUND (SUM (GM_AMOUNT), 2) - SUM (OPEX_AMOUNT))
             / ROUND (SUM (NET_SALES_AFTER_INCENTIVE), 2),
             2)
             OP_PERCENT,
         (CASE
              WHEN ROUND (SUM (OPERATION_COST)) <= 0 THEN 'Non-Profitable'
              ELSE 'Profitable'
          END)
             profitability
    FROM (SELECT CUSTOMER_NO,
                 CUSTOMER_NAME,
                 ORDER_NO,
                 QUANTIY,
                 DISCOUNTED_RSP,
                 UNIT_NSP,
                 NSP,
                 VAT,
                 DISCOUNT_PERCENT,
                 DISCOUNT_AMT,
                 DISCOUNTED_NSP,
                 DEALER_INCENTIVE,
                 (DISCOUNTED_NSP - DEALER_INCENTIVE)
                     NET_SALES_AFTER_INCENTIVE,
                 UNIT_COST,
                 (QUANTIY * UNIT_COST)
                     TOTAL_COST,
                 ((DISCOUNTED_NSP - DEALER_INCENTIVE) * 15) / 100
                     OPEX_AMOUNT,
                 ((DISCOUNTED_NSP - DEALER_INCENTIVE) - (QUANTIY * UNIT_COST))
                     GM_AMOUNT,
                 (  (  (DISCOUNTED_NSP - DEALER_INCENTIVE)
                     - (QUANTIY * UNIT_COST))
                  - (((DISCOUNTED_NSP - DEALER_INCENTIVE) * 15) / 100))
                     OPERATION_COST
            FROM (SELECT l.order_no,
                         L.line_no,
                         L.vendor_no
                             "SITE",
                         L.customer_no,
                         IFSAPP.CUSTOMER_INFO_API.Get_Name (l.customer_no)
                             customer_name,
                         L.catalog_no,
                         L.catalog_desc,
                         TRUNC (l.date_entered)
                             order_date,
                         L.buy_qty_due
                             quantiy,
                         (  ifsapp.customer_order_line_api.get_sale_price_total (
                                l.order_no,
                                l.line_no,
                                l.rel_no,
                                l.line_item_no)
                          + ifsapp.customer_order_line_api.get_total_tax_amount (
                                l.order_no,
                                l.line_no,
                                l.rel_no,
                                l.line_item_no))
                             discounted_rsp,
                         L.base_sale_unit_price
                             unit_nsp,
                         L.base_sale_unit_price * l.buy_qty_due
                             nsp,
                         ifsapp.customer_order_line_api.get_total_tax_amount (
                             l.order_no,
                             l.line_no,
                             l.rel_no,
                             l.line_item_no)
                             vat,
                         ifsapp.customer_order_line_api.get_total_discount (
                             L.order_no,
                             L.line_no,
                             L.rel_no,
                             L.line_item_no)
                             discount_percent,
                           (l.base_sale_unit_price * l.buy_qty_due)
                         * (  ifsapp.customer_order_line_api.get_total_discount (
                                  l.order_no,
                                  l.line_no,
                                  l.rel_no,
                                  l.line_item_no)
                            / 100)
                             discount_amt,
                         ifsapp.customer_order_line_api.get_sale_price_total (
                             l.order_no,
                             l.line_no,
                             l.rel_no,
                             l.line_item_no)
                             discounted_nsp,
                         (CASE
                              WHEN l.customer_no LIKE 'IT0%'
                              THEN
                                    (l.base_sale_unit_price * l.buy_qty_due)
                                  * 0.01
                              ELSE
                                    (l.base_sale_unit_price * l.buy_qty_due)
                                  * 0.032
                          END)
                             dealer_incentive,
                         ROUND (l.cost, 2)
                             unit_cost,
                         ifsapp.customer_order_api.get_pay_term_id (l.order_no)
                             pay_term_id,
                         ifsapp.customer_order_api.get_state (l.order_no)
                             state
                    FROM ifsapp.customer_order_line l
                   WHERE     1 = 1
                         --AND l.vendor_no IS NOT NULL
                         --AND ifsapp.customer_order_api.get_state (l.order_no) IN ('Partially Delivered', 'Delivered', 'Invoiced/Closed')
                         --AND l.customer_no = 'I0000500-1'
                         --AND l.customer_no = 'W0002408-2'
                         AND ( :p_order_no IS NULL OR (l.order_no = :p_order_no))
                         AND TRUNC (l.date_entered) BETWEEN NVL (
                                                                :p_date_from,
                                                                TRUNC (
                                                                    l.date_entered))
                                                        AND NVL (
                                                                :p_date_to,
                                                                TRUNC (
                                                                    l.date_entered))))
GROUP BY CUSTOMER_NO, CUSTOMER_NAME, ORDER_NO