SELECT s.site,
       (select area_code from shop_dts_info where shop_code = s.site) AREA_CODE,
       (select district_code from shop_dts_info where shop_code = s.site) DISTRICT_CODE,
       s.ORDER_NO,
       s.LINE_NO,
       s.REL_NO,
       s.COMP_NO,
       s.STATUS,
       s.SALES_DATE,
       s.PRODUCT_CODE,
       p.PRODUCT_FAMILY,
       p.BRAND,
       cst.serial_no,
       s.SALES_QUANTITY,
       s.unit_nsp,
       s.discount,
       s.SALES_PRICE,
       s.vat,
       s.AMOUNT_RSP,
       S.Bb_No,
       IFSAPP.SERIAL_OEM_CONN_API.Get_Oem_No(s.product_code, cst.serial_no) oem_no,
       ifsapp.customer_info_api.Get_Name(s.customer_no) customer_name,
       ifsapp.CUSTOMER_INFO_COMM_METHOD_API.Get_Any_Phone_No(s.customer_no) phone_no,
       IFSAPP.CUSTOMER_INFO_ADDRESS_API.Get_Address1(s.customer_no, 1) || ' ' ||
       IFSAPP.CUSTOMER_INFO_ADDRESS_API.Get_Address2(s.customer_no, 1) customer_address

  FROM (SELECT *
          FROM ifsapp.sbl_jr_sales_dtl_inv i
        UNION ALL
        SELECT * FROM ifsapp.sbl_jr_sales_dtl_pkg_comp c) s
 INNER JOIN ifsapp.sbl_jr_product_dtl_info p
    ON s.product_code = p.product_code
 LEFT JOIN customer_order_res_serial_lov cst
    ON s.order_no = cst.order_no
   AND s.line_no = cst.line_no
   AND s.rel_no = cst.rel_no
   AND s.comp_no = cst.line_item_no
   AND s.product_code=cst.part_no
   
 WHERE s.sales_date BETWEEN TO_DATE('&FROM_DATE', 'YYYY/MM/DD') AND
       TO_DATE('&TO_DATE', 'YYYY/MM/DD')
   AND s.status not in ('CashConverted',
                        'PositiveCashConv',
                        'TransferAccount',
                        'PositiveTransferAccount')
   AND p.product_family = '&Product_Family'
   AND p.brand = '&Brand'

 ORDER BY to_number(DISTRICT_CODE), s.order_no, s.line_no
