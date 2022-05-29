/* Formatted on 5/29/2022 2:54:53 PM (QP5 v5.381) */
SELECT b.c10                                        "SITE",
       d.order_no,
       d.line_no,
       d.rel_no,
       d.line_item_no,
       d.discount_type,
       b.c5                                         product_code,
       b.sales_quantity,
       d.calculation_basis                          unit_nsp,
       d.discount_amount,
       (b.sales_quantity * d.calculation_basis)     total_nsp,
       (b.sales_quantity * d.discount_amount)       total_discount_amount,
       b.net_curr_amount                            sales_price,
       b.vat_curr_amount                            vat,
       d.remarks,
       b.invoice_id,
       b.item_id,
       b.invoice_date,
       b.customer_no,
       b.customer_name,
       b.phone_no
  FROM ifsapp.cust_order_line_discount_tab  d
       INNER JOIN
       (SELECT c.*,
               t.c1,
               t.c2,
               t.c3,
               t.c5,
               t.c10,
               CASE
                   WHEN t.net_curr_amount != 0
                   THEN
                       t.n2 * (t.net_curr_amount / ABS (t.net_curr_amount))
                   ELSE
                       ifsapp.get_sbl_free_item_sales_qtn (t.invoice_id,
                                                           t.item_id,
                                                           t.n2)
               END
                   sales_quantity,
               t.net_curr_amount,
               t.vat_curr_amount,
               i.invoice_date,
               t.identity
                   customer_no,
               ifsapp.customer_info_api.get_name (t.identity)
                   customer_name,
               ifsapp.CUSTOMER_INFO_COMM_METHOD_API.Get_Any_Phone_No (
                   t.identity)
                   phone_no
          FROM ifsapp.cust_invoice_item_discount  c
               INNER JOIN ifsapp.invoice_item t
                   ON c.invoice_id = t.invoice_id AND c.item_id = t.item_id
               INNER JOIN ifsapp.invoice_tab i ON t.invoice_id = i.invoice_id
         WHERE     t.creator = 'CUSTOMER_ORDER_INV_ITEM_API'
               AND t.state = 'Posted'
               AND ifsapp.sales_part_api.get_catalog_type (t.c5) IN
                       ('INV', 'PKG')) b
           ON     d.order_no = b.c1
              AND d.line_no = b.c2
              AND d.rel_no = b.c3
              AND d.discount_line_no = b.discount_line_no
              AND d.discount_type LIKE 'TD%'
 WHERE     b.invoice_date BETWEEN TO_DATE ('&FROM_DATE', 'yyyy/mm/dd')
                              AND TO_DATE ('&To_date', 'yyyy/mm/dd')
       AND b.c10 LIKE UPPER ('&Site')
       AND d.order_no NOT IN
               (SELECT r.order_no
                  FROM ifsapp.hpnret_customer_order_tab r
                 WHERE r.order_no = d.order_no AND r.cash_conv = 'TRUE')