/* Formatted on 3/30/2023 12:25:00 PM (QP5 v5.381) */
SELECT CUSTOMER_NO,
       CUSTOMER_NAME,
       QTY,
       NSP,
       DISCOUNTED_NSP,
       DEALER_INCENTIVE,
       NET_SALES_AFTER_INCENTIVE,
       TOTAL_COST,
       (NET_SALES_AFTER_INCENTIVE * 0.15)          OPEX_AMOUNT,
       (NET_SALES_AFTER_INCENTIVE - TOTAL_COST)    GP_AMOUNT,
       (CASE
            WHEN (NET_SALES_AFTER_INCENTIVE - TOTAL_COST) < 0
            THEN
                (  (NET_SALES_AFTER_INCENTIVE - TOTAL_COST)
                 + (NET_SALES_AFTER_INCENTIVE * 0.15))
            ELSE
                (  (NET_SALES_AFTER_INCENTIVE - TOTAL_COST)
                 - (NET_SALES_AFTER_INCENTIVE * 0.15))
        END)                                       OP_AMOUNT
  FROM (  SELECT CUSTOMER_NO,
                 CUSTOMER_NAME,
                 SUM (a.SALES_QUANTITY)
                     qty,
                 SUM (NSP)
                     nsp,
                 SUM (discounted_nsp)
                     DISCOUNTED_NSP,
                 SUM (dealer_incentive)
                     dealer_incentive,
                 (SUM (discounted_nsp) - SUM (dealer_incentive))
                     NET_SALES_AFTER_INCENTIVE,
                 SUM (total_cost)
                     total_cost
            FROM (SELECT t.invoice_id,
                         t.item_id,
                         t.c10
                             "SITE",
                         t.c1
                             ORDER_NO,
                         t.c2
                             LINE_NO,
                         t.c3
                             REL_NO,
                         t.n1
                             LINE_ITEM_NO,
                         CASE
                             WHEN t.net_curr_amount = 0
                             THEN
                                 ifsapp.GET_SBL_FREE_ISSUE_LINE_STATE (
                                     t.invoice_id,
                                     t.item_id,
                                     t.c1)
                             ELSE
                                 ifsapp.get_sbl_account_status (
                                     t.c1,
                                     t.c2,
                                     t.c3,
                                     t.c5,
                                     t.net_curr_amount,
                                     i.invoice_date)
                         END
                             status,
                         TO_CHAR (i.invoice_date, 'YYYY/MM/DD')
                             SALES_DATE,
                         t.identity
                             CUSTOMER_NO,
                         ifsapp.customer_info_api.Get_Name (t.identity)
                             CUSTOMER_NAME,
                         (SELECT c.vendor_no
                            FROM ifsapp.CUSTOMER_ORDER_LINE c
                           WHERE     c.order_no = t.c1
                                 AND c.line_no = t.c2
                                 AND c.rel_no = t.c3
                                 AND c.line_item_no = t.n1)
                             DELIVERY_SITE,
                         t.c5
                             PRODUCT_CODE,
                         (CASE
                              WHEN t.net_curr_amount != 0
                              THEN
                                    t.n2
                                  * (  t.net_curr_amount
                                     / ABS (t.net_curr_amount))
                              ELSE
                                  IFSAPP.GET_SBL_FREE_ITEM_SALES_QTN (
                                      t.invoice_id,
                                      t.item_id,
                                      T.N2)
                          END)
                             SALES_QUANTITY,
                         CASE
                             WHEN t.net_curr_amount >= 0
                             THEN
                                 (SELECT c.cost
                                    FROM ifsapp.CUSTOMER_ORDER_LINE c
                                   WHERE     c.order_no = t.c1
                                         AND c.line_no = t.c2
                                         AND c.rel_no = t.c3
                                         AND c.line_item_no = t.n1)
                             ELSE
                                 CASE
                                     WHEN ((SELECT COUNT (c1.part_no)
                                              FROM ifsapp.INVENT_ONLINE_COST_TAB
                                                   c1
                                             WHERE     c1.year =
                                                       EXTRACT (
                                                           YEAR FROM (  TRUNC (
                                                                            i.invoice_date,
                                                                            'MM')
                                                                      - 1))
                                                   AND c1.period =
                                                       EXTRACT (
                                                           MONTH FROM (  TRUNC (
                                                                             i.invoice_date,
                                                                             'MM')
                                                                       - 1))
                                                   AND c1.contract = t.c10
                                                   AND c1.part_no = t.c5) !=
                                           0)
                                     THEN
                                         (SELECT c1.cost
                                            FROM ifsapp.INVENT_ONLINE_COST_TAB
                                                 c1
                                           WHERE     c1.year =
                                                     EXTRACT (
                                                         YEAR FROM (  TRUNC (
                                                                          i.invoice_date,
                                                                          'MM')
                                                                    - 1))
                                                 AND c1.period =
                                                     EXTRACT (
                                                         MONTH FROM (  TRUNC (
                                                                           i.invoice_date,
                                                                           'MM')
                                                                     - 1))
                                                 AND c1.contract = t.c10
                                                 AND c1.part_no = t.c5)
                                     ELSE
                                         (SELECT c2.cost
                                            FROM ifsapp.INVENT_ONLINE_COST_TAB
                                                 c2
                                           WHERE     c2.year =
                                                     EXTRACT (
                                                         YEAR FROM i.invoice_date)
                                                 AND c2.period =
                                                     EXTRACT (
                                                         MONTH FROM i.invoice_date)
                                                 AND c2.contract = t.c10
                                                 AND c2.part_no = t.c5)
                                 END
                         END
                             unit_cost,
                         ROUND (
                               (CASE
                                    WHEN t.net_curr_amount != 0
                                    THEN
                                        (  t.n2
                                         * (  t.net_curr_amount
                                            / ABS (t.net_curr_amount)))
                                    ELSE
                                        IFSAPP.GET_SBL_FREE_ITEM_SALES_QTN (
                                            t.invoice_id,
                                            t.item_id,
                                            T.N2)
                                END)
                             * (CASE
                                    WHEN t.net_curr_amount >= 0
                                    THEN
                                        (SELECT c.cost
                                           FROM ifsapp.CUSTOMER_ORDER_LINE c
                                          WHERE     c.order_no = t.c1
                                                AND c.line_no = t.c2
                                                AND c.rel_no = t.c3
                                                AND c.line_item_no = t.n1)
                                    ELSE
                                        CASE
                                            WHEN ((SELECT COUNT (c1.part_no)
                                                     FROM ifsapp.INVENT_ONLINE_COST_TAB
                                                          c1
                                                    WHERE     c1.year =
                                                              EXTRACT (
                                                                  YEAR FROM (  TRUNC (
                                                                                   i.invoice_date,
                                                                                   'MM')
                                                                             - 1))
                                                          AND c1.period =
                                                              EXTRACT (
                                                                  MONTH FROM (  TRUNC (
                                                                                    i.invoice_date,
                                                                                    'MM')
                                                                              - 1))
                                                          AND c1.contract =
                                                              t.c10
                                                          AND c1.part_no = t.c5) !=
                                                  0)
                                            THEN
                                                (SELECT c1.cost
                                                   FROM ifsapp.INVENT_ONLINE_COST_TAB
                                                        c1
                                                  WHERE     c1.year =
                                                            EXTRACT (
                                                                YEAR FROM (  TRUNC (
                                                                                 i.invoice_date,
                                                                                 'MM')
                                                                           - 1))
                                                        AND c1.period =
                                                            EXTRACT (
                                                                MONTH FROM (  TRUNC (
                                                                                  i.invoice_date,
                                                                                  'MM')
                                                                            - 1))
                                                        AND c1.contract = t.c10
                                                        AND c1.part_no = t.c5)
                                            ELSE
                                                (SELECT c2.cost
                                                   FROM ifsapp.INVENT_ONLINE_COST_TAB
                                                        c2
                                                  WHERE     c2.year =
                                                            EXTRACT (
                                                                YEAR FROM i.invoice_date)
                                                        AND c2.period =
                                                            EXTRACT (
                                                                MONTH FROM i.invoice_date)
                                                        AND c2.contract = t.c10
                                                        AND c2.part_no = t.c5)
                                        END
                                END),
                             2)
                             total_cost,
                         CASE
                             WHEN t.net_curr_amount < 0 AND t.n1 = 0
                             THEN
                                   (SELECT l.base_sale_unit_price
                                      FROM IFSAPP.CUSTOMER_ORDER_LINE l
                                     WHERE     l.order_no = t.c1
                                           AND l.line_no = t.c2
                                           AND l.rel_no = t.c3
                                           AND l.line_item_no = t.n1)
                                 * (t.net_curr_amount / ABS (t.net_curr_amount))
                             WHEN t.net_curr_amount < 0 AND t.n1 > 0
                             THEN
                                   (SELECT l.part_price
                                      FROM IFSAPP.CUSTOMER_ORDER_LINE l
                                     WHERE     l.order_no = t.c1
                                           AND l.line_no = t.c2
                                           AND l.rel_no = t.c3
                                           AND l.line_item_no = t.n1)
                                 * (t.net_curr_amount / ABS (t.net_curr_amount))
                             ELSE
                                 (SELECT l.base_sale_unit_price
                                    FROM IFSAPP.CUSTOMER_ORDER_LINE l
                                   WHERE     l.order_no = t.c1
                                         AND l.line_no = t.c2
                                         AND l.rel_no = t.c3
                                         AND l.line_item_no = t.n1)
                         END
                             UNIT_NSP,
                           (CASE
                                WHEN t.net_curr_amount != 0
                                THEN
                                      t.n2
                                    * (  t.net_curr_amount
                                       / ABS (t.net_curr_amount))
                                ELSE
                                    IFSAPP.GET_SBL_FREE_ITEM_SALES_QTN (
                                        t.invoice_id,
                                        t.item_id,
                                        T.N2)
                            END)
                         * (CASE
                                WHEN t.net_curr_amount < 0 AND t.n1 = 0
                                THEN
                                    (SELECT l.base_sale_unit_price
                                       FROM IFSAPP.CUSTOMER_ORDER_LINE l
                                      WHERE     l.order_no = t.c1
                                            AND l.line_no = t.c2
                                            AND l.rel_no = t.c3
                                            AND l.line_item_no = t.n1)
                                WHEN t.net_curr_amount < 0 AND t.n1 > 0
                                THEN
                                    (SELECT l.part_price
                                       FROM IFSAPP.CUSTOMER_ORDER_LINE l
                                      WHERE     l.order_no = t.c1
                                            AND l.line_no = t.c2
                                            AND l.rel_no = t.c3
                                            AND l.line_item_no = t.n1)
                                ELSE
                                    (SELECT l.base_sale_unit_price
                                       FROM IFSAPP.CUSTOMER_ORDER_LINE l
                                      WHERE     l.order_no = t.c1
                                            AND l.line_no = t.c2
                                            AND l.rel_no = t.c3
                                            AND l.line_item_no = t.n1)
                            END)
                             NSP,
                         t.n5
                             DISCOUNT,
                         t.net_curr_amount
                             SALES_PRICE,
                         t.vat_code,
                         IFSAPP.STATUTORY_FEE_API.Get_Fee_Rate ('SBL',
                                                                t.vat_code)
                             vat_rate,
                         t.vat_curr_amount
                             VAT,
                         (t.net_curr_amount + t.vat_curr_amount)
                             "RSP",
                         i.pay_term_id,
                         i.series_id,
                         i.invoice_no,
                         t.net_curr_amount
                             discounted_nsp,
                         (CASE
                              WHEN t.identity LIKE 'IT0%'
                              THEN
                                  t.net_curr_amount * 0.01
                              ELSE
                                  t.net_curr_amount * 0.032
                          END)
                             dealer_incentive
                    FROM ifsapp.invoice_item_tab t, ifsapp.INVOICE_TAB i
                   WHERE     t.invoice_id = i.invoice_id
                         AND t.creator = 'CUSTOMER_ORDER_INV_ITEM_API'
                         AND t.rowstate = 'Posted'
                         AND IFSAPP.SALES_PART_API.Get_Catalog_Type (T.C5) =
                             'INV'
                         AND (t.c10 NOT LIKE '%P' AND t.c10 NOT LIKE '%C')
                         AND t.identity LIKE 'W0001899-2%'
                         --AND t.identity = 'W0002789-2'
                         AND TRUNC (i.invoice_date) BETWEEN NVL (
                                                                :p_date_from,
                                                                TRUNC (
                                                                    i.invoice_date))
                                                        AND NVL (
                                                                :p_date_to,
                                                                TRUNC (
                                                                    i.invoice_date))
                  UNION ALL
                  SELECT t.invoice_id,
                         t.item_id,
                         t.c10
                             "SITE",
                         L.ORDER_NO,
                         L.LINE_NO,
                         L.REL_NO,
                         L.LINE_ITEM_NO,
                         CASE
                             WHEN t.net_curr_amount = 0
                             THEN
                                 ifsapp.GET_SBL_FREE_ISSUE_LINE_STATE (
                                     t.invoice_id,
                                     t.item_id,
                                     t.c1)
                             ELSE
                                 ifsapp.get_sbl_account_status (
                                     t.c1,
                                     t.c2,
                                     t.c3,
                                     t.c5,
                                     t.net_curr_amount,
                                     i.invoice_date)
                         END
                             status,
                         TO_CHAR (i.invoice_date, 'YYYY/MM/DD')
                             SALES_DATE,
                         t.identity
                             CUSTOMER_NO,
                         ifsapp.customer_info_api.Get_Name (t.identity)
                             CUSTOMER_NAME,
                         (SELECT c.vendor_no
                            FROM ifsapp.CUSTOMER_ORDER_LINE c
                           WHERE     c.order_no = L.ORDER_NO
                                 AND c.line_no = L.LINE_NO
                                 AND c.rel_no = L.REL_NO
                                 AND c.line_item_no = L.LINE_ITEM_NO)
                             DELIVERY_SITE,
                         L.CATALOG_NO
                             PRODUCT_CODE,
                         L.QTY_INVOICED
                             SALES_QUANTITY,
                         ROUND (L.COST, 2)
                             unit_cost,
                         ROUND ((L.COST * L.QTY_INVOICED), 2)
                             total_cost,
                         ROUND (L.PART_PRICE, 2)
                             UNIT_NSP,
                         ROUND ((L.PART_PRICE * L.QTY_INVOICED), 2)
                             NSP,
                         t.n5
                             DISCOUNT,
                         IFSAPP.CUSTOMER_ORDER_LINE_API.Get_Sale_Price_Total (
                             t.c1,
                             t.c2,
                             t.c3,
                             L.LINE_ITEM_NO)
                             SALES_PRICE,
                         L.FEE_CODE
                             vat_code,
                         IFSAPP.STATUTORY_FEE_API.Get_Fee_Rate ('SBL',
                                                                L.FEE_CODE)
                             vat_rate,
                         ROUND (
                               (L.COST * t.vat_curr_amount)
                             / (SELECT L2.COST
                                  FROM IFSAPP.CUSTOMER_ORDER_LINE_TAB L2
                                 WHERE     L2.ORDER_NO = t.c1
                                       AND L2.LINE_NO = t.c2
                                       AND L2.REL_NO = t.c3
                                       AND L2.CATALOG_TYPE = 'PKG'),
                             2)
                             VAT,
                           IFSAPP.CUSTOMER_ORDER_LINE_API.Get_Sale_Price_Total (
                               t.c1,
                               t.c2,
                               t.c3,
                               L.LINE_ITEM_NO)
                         + ROUND (
                                 (L.COST * t.vat_curr_amount)
                               / (SELECT L2.COST
                                    FROM IFSAPP.CUSTOMER_ORDER_LINE_TAB L2
                                   WHERE     L2.ORDER_NO = t.c1
                                         AND L2.LINE_NO = t.c2
                                         AND L2.REL_NO = t.c3
                                         AND L2.CATALOG_TYPE = 'PKG'),
                               2)
                             AMOUNT_RSP,
                         i.pay_term_id,
                         i.series_id,
                         i.invoice_no,
                         t.net_curr_amount
                             discounted_nsp,
                         (CASE
                              WHEN t.identity LIKE 'IT0%'
                              THEN
                                  t.net_curr_amount * 0.01
                              ELSE
                                  t.net_curr_amount * 0.032
                          END)
                             dealer_incentive
                    FROM IFSAPP.CUSTOMER_ORDER_LINE_TAB L
                         LEFT JOIN ifsapp.invoice_item_tab t
                             ON     L.ORDER_NO = t.c1
                                AND L.LINE_NO = t.c2
                                AND L.REL_NO = t.c3
                         INNER JOIN ifsapp.INVOICE_TAB i
                             ON t.invoice_id = i.invoice_id
                   WHERE     L.CATALOG_TYPE = 'KOMP'
                         AND t.creator = 'CUSTOMER_ORDER_INV_ITEM_API'
                         AND t.rowstate = 'Posted'
                         AND IFSAPP.SALES_PART_API.Get_Catalog_Type (T.C5) =
                             'PKG'
                         AND (t.c10 NOT LIKE '%P' AND t.c10 NOT LIKE '%C')
                         AND t.identity LIKE 'W0001899-2%'
                         --AND t.identity = 'W0002789-2'
                         AND TRUNC (i.invoice_date) BETWEEN NVL (
                                                                :p_date_from,
                                                                TRUNC (
                                                                    i.invoice_date))
                                                        AND NVL (
                                                                :p_date_to,
                                                                TRUNC (
                                                                    i.invoice_date)))
                 a
        GROUP BY CUSTOMER_NO, CUSTOMER_NAME)