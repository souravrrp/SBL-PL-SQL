/* Formatted on 3/29/2023 9:22:58 AM (QP5 v5.381) */
SELECT W.INVOICE_ID,
       W.SITE,
       W.ORDER_NO,
       W.LINE_NO,
       W.REL_NO,
       W.Comp_No,
       ''
           RMA_NO,
       W.SALES_DATE,
       W.CUSTOMER_NO,
       ifsapp.customer_info_api.Get_Name (W.CUSTOMER_NO)
           CUSTOMER_NAME,
       ifsapp.CUSTOMER_INFO_COMM_METHOD_API.Get_Any_Phone_No (W.CUSTOMER_NO)
           phone_no,
          IFSAPP.CUSTOMER_INFO_ADDRESS_API.Get_Address1 (W.CUSTOMER_NO, 1)
       || ' '
       || IFSAPP.CUSTOMER_INFO_ADDRESS_API.Get_Address2 (W.CUSTOMER_NO, 1)
           dealer_address,
       ''
           creator,
       ifsapp.cust_ord_customer_api.get_cust_grp (W.CUSTOMER_NO)
           CUSTOMER_GROUP,
       W.DELIVERY_SITE,
       W.PRODUCT_CODE,
       DI.PRODUCT_DESC,
       DI.PRODUCT_FAMILY,
       DI.BRAND,
       IFSAPP.SALES_PART_API.Get_Catalog_Type (W.PRODUCT_CODE)
           CATALOG_TYPE,
       W.SALES_QUANTITY,
       W.SALES_PRICE,
       W.DISCOUNT,
       W.VAT,
       W.UNIT_NSP,
       W.AMOUNT_RSP
           RSP,
       ''
           SERIES_ID,
       ''
           INVOICE_NO,
       W.PAY_TERM_ID
  FROM IFSAPP.SBL_JR_SALES_DTL_INV W, IFSAPP.SBL_JR_PRODUCT_DTL_INFO DI
 WHERE     W.PRODUCT_CODE = DI.PRODUCT_CODE
       AND ( :p_site IS NULL OR (UPPER (W.SITE) = UPPER ( :p_site)))
       AND (   :p_delivery_site IS NULL
            OR (UPPER (W.DELIVERY_SITE) = UPPER ( :p_delivery_site)))
       AND TRUNC (W.SALES_DATE) BETWEEN NVL ( :p_date_from,
                                             TRUNC (W.SALES_DATE))
                                    AND NVL ( :p_date_to,
                                             TRUNC (W.SALES_DATE))
       AND (   :p_order_no IS NULL
            OR (UPPER (W.ORDER_NO) = UPPER ( :p_order_no)))
       AND W.SITE = 'SCSM';