create or replace view SBL_VW_WHOLESALE_SALES_NEW AS
select W.INVOICE_ID,
       W.SITE,
       W.ORDER_NO,
       W.LINE_NO,
       W.REL_NO,
       W.Comp_No,
       '' RMA_NO,
       W.SALES_DATE,
       W.CUSTOMER_NO,
       ifsapp.customer_info_api.Get_Name(W.CUSTOMER_NO) CUSTOMER_NAME,
       ifsapp.CUSTOMER_INFO_COMM_METHOD_API.Get_Any_Phone_No(W.CUSTOMER_NO) phone_no,
       IFSAPP.CUSTOMER_INFO_ADDRESS_API.Get_Address1(W.CUSTOMER_NO, 1) || ' ' ||
       IFSAPP.CUSTOMER_INFO_ADDRESS_API.Get_Address2(W.CUSTOMER_NO, 1) dealer_address,
       '' creator,
       ifsapp.cust_ord_customer_api.get_cust_grp(W.CUSTOMER_NO) CUSTOMER_GROUP,
       W.DELIVERY_SITE,
       W.PRODUCT_CODE,
       DI.PRODUCT_DESC,
       DI.PRODUCT_FAMILY,
       DI.BRAND,
       IFSAPP.SALES_PART_API.Get_Catalog_Type(W.PRODUCT_CODE) CATALOG_TYPE,
       W.SALES_QUANTITY,
       W.SALES_PRICE,
       W.DISCOUNT,
       W.VAT,
       W.UNIT_NSP,
       W.AMOUNT_RSP RSP,
       '' SERIES_ID,
       '' INVOICE_NO,
       W.PAY_TERM_ID
  from IFSAPP.SBL_JR_SALES_DTL_INV W, IFSAPP.SBL_JR_PRODUCT_DTL_INFO DI
 WHERE W.PRODUCT_CODE = DI.PRODUCT_CODE
   AND W.SITE IN ('JWSS', 'SAOS', 'SWSS', 'WSMO', 'SCSM', 'WITM', 'SITM', 'SSAM', 'SOSM')
