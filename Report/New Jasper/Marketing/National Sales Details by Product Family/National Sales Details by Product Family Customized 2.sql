/* Formatted on 4/11/2023 2:44:59 PM (QP5 v5.381) */
WITH
    prod_list
    AS
        (SELECT *
           FROM (SELECT prod.*,
                        (SELECT pg_pf_map.product_group_code
                           FROM ifsapp.sbl_jr_rst_pg_pf_map pg_pf_map
                          WHERE     pg_pf_map.year =
                                    EXTRACT (YEAR FROM SYSDATE)
                                AND pg_pf_map.product_family_code =
                                    prod.product_family_code)    product_group
                   FROM ifsapp.sbl_jr_product_dtl_info prod) prod_dtl)
  SELECT sales_dtl.*, c.DISCOUNT_TYPE
    FROM (SELECT s.site,
                 CASE
                     WHEN s.site = 'SCSM'
                     THEN
                         'CORPORATE'
                     WHEN s.site IN ('JWSS',
                                     'SAOS',
                                     'SWSS',
                                     'WSMO',
                                     'WITM')
                     THEN
                         'WHOLESALE'
                     WHEN s.site = 'SITM'
                     THEN
                         'IT CHANNEL'
                     WHEN s.site = 'SSAM'
                     THEN
                         'SMALL APPLIANCE CHANNEL'
                     WHEN s.site = 'SOSM'
                     THEN
                         'ONLINE CHANNEL'
                     WHEN s.site IN ('SAPM',
                                     'SESM',
                                     'SHOM',
                                     'SISM',
                                     'SFSM')
                     THEN
                         'STAFF SCRAP AND ACQUISITION'
                     WHEN s.site IN (SELECT t.shop_code
                                       FROM ifsapp.shop_dts_info t
                                      WHERE t.shop_code = s.site)
                     THEN
                         'RETAIL'
                     ELSE
                         'BLANK'
                 END
                     sales_channel,
                 (SELECT h.area_code
                    FROM ifsapp.shop_dts_info h
                   WHERE h.shop_code = s.site)
                     area_code,
                 (SELECT h.district_code
                    FROM ifsapp.shop_dts_info h
                   WHERE h.shop_code = s.site)
                     district_code,
                 s.order_no,
                 s.line_no,
                 s.rel_no,
                 s.comp_no
                     line_item_no,
                 --s.status,
                 --s.sales_date,
                 --DISCOUNT_TYPE,
                 --                 ifsapp.CUST_ORDER_LINE_DISCOUNT_api.Get_Discount_Type (
                 --                     c.order_no,
                 --                     s.line_no,
                 --                     s.rel_no,
                 --                     s.comp_no,
                 --                     s.discount_no)
                 --                     Discount_Type,
                 s.product_code,
                 prod_list.brand,
                 prod_list.product_family,
                 s.sales_quantity,
                 s.unit_nsp,
                 s.discount
                     discount_pct,
                 --DISCOUNT_AMOUNT,
                 (s.sales_quantity * s.unit_nsp)
                     NSP,
                 --TOTAL_DISCOUNT_AMOUNT,
                 s.sales_price,
                 s.vat,
                 --REMARKS,
                 --s.amount_rsp,
                 --s.pay_term_id,
                 s.INVOICE_ID,
                 s.ITEM_ID,
                 s.SALES_DATE
                     INVOICE_DATE,
                 s.customer_no,
                 ifsapp.customer_info_api.get_name (s.customer_no)
                     customer_name,
                 ifsapp.customer_info_comm_method_api.get_any_phone_no (
                     s.customer_no)
                     phone_no
            --ifsapp.customer_info_address_api.get_address1 ( s.customer_no, 1) || ' ' || ifsapp.customer_info_address_api.get_address2 ( s.customer_no, 1) customer_address
            FROM (SELECT *
                    FROM ifsapp.sbl_jr_sales_dtl_inv i
                  UNION ALL
                  SELECT *
                    FROM ifsapp.sbl_jr_sales_dtl_pkg_comp c) s
                 INNER JOIN prod_list
                     ON s.product_code = prod_list.product_code
           WHERE     s.sales_price != 0
                 AND TRUNC (s.sales_date) BETWEEN NVL ( :p_date_from,
                                                       TRUNC (s.sales_date))
                                              AND NVL ( :p_date_to,
                                                       TRUNC (s.sales_date))
                 AND (   :P_PRODUCT_FAMILY IS NULL
                      OR (UPPER (prod_list.product_family) =
                          UPPER ( :P_PRODUCT_FAMILY)))
                 AND (s.status NOT IN ('CashConverted',
                                       'PositiveCashConv',
                                       'TransferAccount',
                                       'PositiveTransferAccount'))) sales_dtl,
         ifsapp.CUST_INVOICE_ITEM_DISCOUNT c
   WHERE c.invoice_id = sales_dtl.invoice_id AND c.item_id = sales_dtl.item_id
ORDER BY TO_NUMBER (district_code),
         sales_channel,
         order_no,
         line_no