/* Formatted on 10/18/2023 4:51:01 PM (QP5 v5.381) */
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
                   FROM ifsapp.sbl_jr_product_dtl_info prod) prod_dtl),
    prod_serial
    AS
        (SELECT cort.order_no,
                cort.line_no,
                cort.rel_no,
                cort.line_item_no,
                cort.serial_no,
                ifsapp.serial_oem_conn_api.get_oem_no (cort.part_no,
                                                       cort.serial_no)    oem_no
           FROM customer_order_reservation_tab cort)
  SELECT *
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
                 s.sales_date,
                 s.product_code,
                 prod_list.product_family,
                 prod_list.brand,
                 --ifsapp.serial_oem_conn_api.get_oem_no (s.product_code, l.serial_no) oem_no,
                 prod_serial.serial_no,
                 prod_serial.oem_no,
                 (SELECT warranty_description
                    FROM ifsapp.cust_warranty_type_tab wt,
                         ifsapp.inventory_part        i
                   WHERE     i.cust_warranty_id = wt.warranty_id
                         AND i.CONTRACT = 'SCOM'
                         AND i.part_no = s.product_code)
                     warranty,
                 s.sales_quantity,
                 --s.unit_nsp,
                 --s.discount discount_pct,
                 --s.sales_price,
                 --s.vat,
                 s.amount_rsp,
                 --s.pay_term_id,
                 (SELECT invoice_no
                    FROM ifsapp.invoice_tab it
                   WHERE 1 = 1 AND it.invoice_id = s.invoice_id)
                     invoice_no,
                 s.customer_no,
                 ifsapp.customer_info_api.get_name (s.customer_no)
                     customer_name,
                 ifsapp.customer_info_comm_method_api.get_any_phone_no (
                     s.customer_no)
                     phone_no,
                    ifsapp.customer_info_address_api.get_address1 (
                        s.customer_no,
                        1)
                 || ' '
                 || ifsapp.customer_info_address_api.get_address2 (
                        s.customer_no,
                        1)
                     customer_address
            FROM (SELECT *
                    FROM ifsapp.sbl_jr_sales_dtl_inv i
                  UNION ALL
                  SELECT *
                    FROM ifsapp.sbl_jr_sales_dtl_pkg_comp c) s,
                 prod_list,
                 prod_serial
           WHERE     s.sales_price != 0
                 AND s.product_code = prod_list.product_code
                 AND s.order_no = prod_serial.order_no(+)
                 AND s.line_no = prod_serial.line_no(+)
                 AND s.rel_no = prod_serial.rel_no(+)
                 AND s.comp_no = prod_serial.line_item_no(+)
                 --AND (s.status NOT IN ('CashConverted', 'PositiveCashConv', 'TransferAccount','PositiveTransferAccount'))
                 AND s.status IN ('HireSale', 'CashSale')
                 AND TRUNC (s.sales_date) BETWEEN NVL ( :p_date_from,
                                                       TRUNC (s.sales_date))
                                              AND NVL ( :p_date_to,
                                                       TRUNC (s.sales_date)))
         sales_dtl
ORDER BY TO_NUMBER (district_code),
         sales_channel,
         order_no,
         line_no