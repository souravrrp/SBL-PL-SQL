/* Formatted on 4/10/2023 10:43:06 AM (QP5 v5.381) */
SELECT a.*,
       CASE
           WHEN A.SITE IN ('JWSS',
                           'SAOS',
                           'SWSS',
                           'WSMO',
                           'WITM')
           THEN
               'WHOLESALE'
           WHEN A.SITE = 'SCSM'
           THEN
               'CORPORATE'
           WHEN A.SITE = 'SITM'
           THEN
               'IT CHANNEL'
           WHEN A.SITE = 'SSAM'
           THEN
               'SMALL APPLIANCE CHANNEL'
           WHEN A.SITE = 'SOSM'
           THEN
               'ONLINE CHANNEL'
           WHEN A.SITE IN ('SAPM',
                           'SESM',
                           'SHOM',
                           'SISM',
                           'SFSM')
           THEN
               'STAFF SCRAP AND ACQUISITION'
           WHEN A.SITE IN (SELECT t.shop_code
                             FROM ifsapp.shop_dts_info t
                            WHERE t.shop_code = A.SITE)
           THEN
               'RETAIL'
           ELSE
               'BLANK'
       END
           sales_channel,
       (SELECT H.AREA_CODE
          FROM IFSAPP.SHOP_DTS_INFO H
         WHERE H.SHOP_CODE = A.SITE)
           AREA_CODE,
       (SELECT H.DISTRICT_CODE
          FROM IFSAPP.SHOP_DTS_INFO H
         WHERE H.SHOP_CODE = A.SITE)
           DISTRICT_CODE,
       IFSAPP.INVENTORY_PRODUCT_CODE_API.Get_Description (
           ifsapp.inventory_part_api.Get_Part_Product_Code (A.SITE,
                                                            a.PRODUCT_CODE))
           brand,
       ifsapp.INVENTORY_PRODUCT_FAMILY_API.Get_Description (
           ifsapp.inventory_part_api.Get_Part_Product_Family (A.SITE,
                                                              a.PRODUCT_CODE))
           product_family,
       IFSAPP.COMMODITY_GROUP_API.Get_Description (
           IFSAPP.INVENTORY_PART_API.Get_Second_Commodity (A.SITE,
                                                           a.PRODUCT_CODE))
           commodity_group2,
       IFSAPP.SALES_GROUP_API.Get_Description (
           IFSAPP.SALES_PART_API.Get_Catalog_Group ('SCOM', a.PRODUCT_CODE))
           sales_group,
       (SELECT p.product_type
          FROM ifsapp.sbl_jr_product_dtl_info p
         WHERE a.PRODUCT_CODE = p.product_code)
           catalog_type,
       (SELECT h.cash_conv
          FROM HPNRET_CUSTOMER_ORDER_TAB h
         WHERE h.order_no = a.ORDER_NO)
           CASH_CONV,
       (SELECT h.Remarks
          FROM HPNRET_CUSTOMER_ORDER_TAB h
         WHERE h.order_no = a.ORDER_NO)
           REMARKS,
       NVL (
           CASE
               WHEN a.SALES_PRICE >= 0
               THEN
                   (SELECT d.Amt_Finance
                      FROM HPNRET_HP_DTL_TAB d
                     WHERE     d.account_no = a.ORDER_NO
                           AND d.ref_line_no = a.LINE_NO
                           AND d.ref_rel_no = a.REL_NO
                           AND d.catalog_no = a.PRODUCT_CODE)
               ELSE
                   0
           END,
           0)
           Amt_Finance,
       NVL (
           CASE
               WHEN a.SALES_PRICE >= 0
               THEN
                   (SELECT d.down_payment
                      FROM HPNRET_HP_DTL_TAB d
                     WHERE     d.account_no = a.ORDER_NO
                           AND d.ref_line_no = a.LINE_NO
                           AND d.ref_rel_no = a.REL_NO
                           AND d.catalog_no = a.PRODUCT_CODE)
               ELSE
                   0
           END,
           0)
           down_payment,
       NVL (CASE
                WHEN a.SALES_PRICE >= 0
                THEN
                    (SELECT hd.length_of_contract
                       FROM HPNRET_HP_HEAD_TAB hd
                      WHERE hd.account_no = a.ORDER_NO)
                ELSE
                    0
            END,
            0)
           length_of_contract,
       NVL (
           CASE
               WHEN a.SALES_PRICE >= 0
               THEN
                   (SELECT d.install_amt
                      FROM HPNRET_HP_DTL_TAB d
                     WHERE     d.account_no = a.ORDER_NO
                           AND d.ref_line_no = a.LINE_NO
                           AND d.ref_rel_no = a.REL_NO
                           AND d.catalog_no = a.PRODUCT_CODE)
               ELSE
                   0
           END,
           0)
           install_amt,
       NVL (
           CASE
               WHEN a.sales_price < 0 AND a.status != 'Returned'
               THEN
                   0
               ELSE
                     ifsapp.hpnret_hp_dtl_api.Get_Service_Charge (a.order_no,
                                                                  1,
                                                                  a.line_no)
                   * (a.sales_quantity / ABS (a.sales_quantity))
           END,
           0)
           service_revenue
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
                       ifsapp.GET_SBL_FREE_ISSUE_LINE_STATE (t.invoice_id,
                                                             t.item_id,
                                                             t.c1)
                   ELSE
                       ifsapp.get_sbl_account_status (t.c1,
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
                        t.n2 * (t.net_curr_amount / ABS (t.net_curr_amount))
                    ELSE
                        IFSAPP.GET_SBL_FREE_ITEM_SALES_QTN (t.invoice_id,
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
                                    FROM ifsapp.INVENT_ONLINE_COST_TAB c1
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
                                  FROM ifsapp.INVENT_ONLINE_COST_TAB c1
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
                                  FROM ifsapp.INVENT_ONLINE_COST_TAB c2
                                 WHERE     c2.year =
                                           EXTRACT (YEAR FROM i.invoice_date)
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
                               * (t.net_curr_amount / ABS (t.net_curr_amount)))
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
                          * (t.net_curr_amount / ABS (t.net_curr_amount))
                      ELSE
                          IFSAPP.GET_SBL_FREE_ITEM_SALES_QTN (t.invoice_id,
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
               IFSAPP.STATUTORY_FEE_API.Get_Fee_Rate ('SBL', t.vat_code)
                   vat_rate,
               t.vat_curr_amount
                   VAT,
               (t.net_curr_amount + t.vat_curr_amount)
                   "RSP",
               i.pay_term_id,
               i.series_id,
               i.invoice_no
          FROM ifsapp.invoice_item_tab t, ifsapp.INVOICE_TAB i
         WHERE     t.invoice_id = i.invoice_id
               AND t.creator = 'CUSTOMER_ORDER_INV_ITEM_API'
               AND t.rowstate = 'Posted'
               AND IFSAPP.SALES_PART_API.Get_Catalog_Type (T.C5) = 'INV'
               AND TRUNC (i.invoice_date) BETWEEN NVL (
                                                      :p_date_from,
                                                      TRUNC (i.invoice_date))
                                              AND NVL (
                                                      :p_date_to,
                                                      TRUNC (i.invoice_date))
               AND (t.c10 LIKE '%SP' or t.c10 LIKE '%CP')
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
                       ifsapp.GET_SBL_FREE_ISSUE_LINE_STATE (t.invoice_id,
                                                             t.item_id,
                                                             t.c1)
                   ELSE
                       ifsapp.get_sbl_account_status (t.c1,
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
               IFSAPP.STATUTORY_FEE_API.Get_Fee_Rate ('SBL', L.FEE_CODE)
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
               i.invoice_no
          FROM IFSAPP.CUSTOMER_ORDER_LINE_TAB  L
               LEFT JOIN ifsapp.invoice_item_tab t
                   ON     L.ORDER_NO = t.c1
                      AND L.LINE_NO = t.c2
                      AND L.REL_NO = t.c3
               INNER JOIN ifsapp.INVOICE_TAB i ON t.invoice_id = i.invoice_id
         WHERE     L.CATALOG_TYPE = 'KOMP'
               AND t.creator = 'CUSTOMER_ORDER_INV_ITEM_API'
               AND t.rowstate = 'Posted'
               AND IFSAPP.SALES_PART_API.Get_Catalog_Type (T.C5) = 'PKG'
               AND (t.c10 LIKE '%SP' or t.c10 LIKE '%CP')
               AND TRUNC (i.invoice_date) BETWEEN NVL (
                                                      :p_date_from,
                                                      TRUNC (i.invoice_date))
                                              AND NVL (
                                                      :p_date_to,
                                                      TRUNC (i.invoice_date)))
       a