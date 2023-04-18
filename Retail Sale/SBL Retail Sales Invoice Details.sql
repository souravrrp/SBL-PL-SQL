/* Formatted on 3/20/2023 2:27:07 PM (QP5 v5.381) */
  SELECT SHOP_CODE,
         AREA_CODE,
         DISTRICT_CODE,
         ORDER_NO,
         SALES_DATE,
         STATUS,
         PRODUCT_CODE,
         PRODUCT_FAMILY,
         SALES_QUANTITY,
         SALES_PRICE,
         DISCOUNT_PCT,
         VAT,
         RSP
    FROM (SELECT t.c10
                     shop_code,
                 (SELECT h.area_code
                    FROM ifsapp.shop_dts_info h
                   WHERE h.shop_code = t.c10)
                     area_code,
                 TO_NUMBER ((SELECT h.district_code
                               FROM ifsapp.shop_dts_info h
                              WHERE h.shop_code = t.c10))
                     district_code,
                 t.c1
                     order_no,
                 i.invoice_date
                     sales_date,
                 ifsapp.get_sbl_account_status (t.c1,
                                                t.c2,
                                                t.c3,
                                                t.c5,
                                                t.net_curr_amount,
                                                i.invoice_date)
                     status,
                 t.c5
                     product_code,
                 ifsapp.inventory_product_family_api.get_description (
                     ifsapp.inventory_part_api.get_part_product_family (t.c10,
                                                                        t.c5))
                     product_family,
                 CASE
                     WHEN t.net_curr_amount != 0
                     THEN
                         (t.n2 * (t.net_curr_amount / ABS (t.net_curr_amount)))
                     ELSE
                         t.n2
                 END
                     sales_quantity,
                 t.net_curr_amount
                     sales_price,
                 t.n5
                     discount_pct,
                 t.vat_curr_amount
                     vat,
                 t.net_curr_amount + t.vat_curr_amount
                     rsp
            FROM ifsapp.invoice_item_tab t
                 INNER JOIN ifsapp.invoice_tab i ON t.invoice_id = i.invoice_id
           WHERE     t.net_curr_amount != 0
                 AND t.creator = 'CUSTOMER_ORDER_INV_ITEM_API'
                 AND t.rowstate = 'Posted'
                 AND ifsapp.sales_part_api.get_catalog_type (t.c5) = 'INV'
                 AND (    t.c10 NOT LIKE '%P'
                      AND t.c10 NOT LIKE '%C'
                      AND t.c10 NOT LIKE '%S'
                      AND t.c10 NOT LIKE 'S%M'
                      AND t.c10 NOT LIKE 'W%M'
                      AND t.c10 != 'WSMO')
                 --AND i.invoice_date = TRUNC (SYSDATE)
                 AND TRUNC (i.invoice_date) BETWEEN NVL (
                                                        :p_date_from,
                                                        TRUNC (i.invoice_date))
                                                AND NVL (
                                                        :p_date_to,
                                                        TRUNC (i.invoice_date))
                 AND ifsapp.get_sbl_account_status (t.c1,
                                                    t.c2,
                                                    t.c3,
                                                    t.c5,
                                                    t.net_curr_amount,
                                                    i.invoice_date) NOT IN
                         ('CashConverted',
                          'PositiveCashConv',
                          'TransferAccount',
                          'PositiveTransferAccount')
          UNION ALL
          SELECT t.c10
                     shop_code,
                 (SELECT h.area_code
                    FROM ifsapp.shop_dts_info h
                   WHERE h.shop_code = t.c10)
                     area_code,
                 TO_NUMBER ((SELECT h.district_code
                               FROM ifsapp.shop_dts_info h
                              WHERE h.shop_code = t.c10))
                     district_code,
                 l.order_no,
                 i.invoice_date
                     sales_date,
                 ifsapp.get_sbl_account_status (t.c1,
                                                t.c2,
                                                t.c3,
                                                t.c5,
                                                t.net_curr_amount,
                                                i.invoice_date)
                     status,
                 l.catalog_no
                     product_code,
                 ifsapp.inventory_product_family_api.get_description (
                     ifsapp.inventory_part_api.get_part_product_family (
                         t.c10,
                         l.catalog_no))
                     product_family,
                 l.qty_invoiced
                     sales_quantity,
                 ifsapp.customer_order_line_api.get_sale_price_total (
                     t.c1,
                     t.c2,
                     t.c3,
                     l.line_item_no)
                     sales_price,
                 t.n5
                     discount_pct,
                 ROUND (
                       (l.cost * t.vat_curr_amount)
                     / (SELECT l2.cost
                          FROM ifsapp.customer_order_line_tab l2
                         WHERE     l2.order_no = t.c1
                               AND l2.line_no = t.c2
                               AND l2.rel_no = t.c3
                               AND l2.catalog_type = 'PKG'),
                     2)
                     vat,
                   ifsapp.customer_order_line_api.get_sale_price_total (
                       t.c1,
                       t.c2,
                       t.c3,
                       l.line_item_no)
                 + ROUND (
                         (l.cost * t.vat_curr_amount)
                       / (SELECT l2.cost
                            FROM ifsapp.customer_order_line_tab l2
                           WHERE     l2.order_no = t.c1
                                 AND l2.line_no = t.c2
                                 AND l2.rel_no = t.c3
                                 AND l2.catalog_type = 'PKG'),
                       2)
                     rsp
            FROM ifsapp.customer_order_line_tab l
                 LEFT JOIN ifsapp.invoice_item_tab t
                     ON     l.order_no = t.c1
                        AND l.line_no = t.c2
                        AND l.rel_no = t.c3
                 INNER JOIN ifsapp.invoice_tab i ON t.invoice_id = i.invoice_id
           WHERE     l.catalog_type = 'KOMP'
                 AND t.net_curr_amount != 0
                 AND t.creator = 'CUSTOMER_ORDER_INV_ITEM_API'
                 AND t.rowstate = 'Posted'
                 AND ifsapp.sales_part_api.get_catalog_type (t.c5) = 'PKG'
                 AND (    t.c10 NOT LIKE '%P'
                      AND t.c10 NOT LIKE '%C'
                      AND t.c10 NOT LIKE '%S'
                      AND t.c10 NOT LIKE 'S%M'
                      AND t.c10 NOT LIKE 'W%M'
                      AND t.c10 != 'WSMO')
                 --AND i.invoice_date = TRUNC (SYSDATE)
                 AND TRUNC (i.invoice_date) BETWEEN NVL (
                                                        :p_date_from,
                                                        TRUNC (i.invoice_date))
                                                AND NVL (
                                                        :p_date_to,
                                                        TRUNC (i.invoice_date))
                 AND ifsapp.get_sbl_account_status (t.c1,
                                                    t.c2,
                                                    t.c3,
                                                    t.c5,
                                                    t.net_curr_amount,
                                                    i.invoice_date) NOT IN
                         ('CashConverted',
                          'PositiveCashConv',
                          'TransferAccount',
                          'PositiveTransferAccount')) v
   WHERE 1 = 1
ORDER BY 3, 4, 7