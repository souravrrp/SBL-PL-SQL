SELECT 
    --*
    C.ORDER_NO,
    C.LINE_NO,
    C.REL_NO,
    C.LINE_ITEM_NO,
    C.CONTRACT "SHOP_CODE",
    C.CATALOG_NO PART_NO,
    C.CATALOG_DESC PART_DESCRIPTION, 
    C.CATALOG_TYPE PART_TYPE,  
    --C.PART_NO,
    C.REAL_SHIP_DATE SALE_DATE,
    --C.BUY_QTY_DUE QUANTITY,
    --C.QTY_INVOICED,
    C.QTY_SHIPPED QUANTITY,
    C.BASE_SALE_UNIT_PRICE,
    IFSAPP.customer_order_line_api.Get_Sale_Price_Total(c.order_no, c.LINE_NO, c.REL_NO ,c.LINE_ITEM_NO) NSP,
    IFSAPP.CUSTOMER_ORDER_LINE_API.Get_Total_Discount(C.ORDER_NO, C.LINE_NO, C.REL_NO, C.LINE_ITEM_NO) Discount,   
    --C.DISCOUNT,
    IFSAPP.Customer_Order_Line_API.Get_Total_Tax_Amount(c.order_no,c.line_no,c.rel_no,c.line_item_no) VAT,
    C.ROWSTATE STATUS,
    --IFSAPP.CUSTOMER_ORDER_LINE_API.Get_Real_Ship_Date(C.ORDER_NO, C.LINE_NO, C.REL_NO, C.LINE_ITEM_NO) SALE_DATE,
    --IFSAPP.CUSTOMER_ORDER_LINE_API.Get_Catalog_Type(C.ORDER_NO, C.LINE_NO, C.REL_NO, C.LINE_ITEM_NO) Catalog_Type,
    --(SELECT L.catalog_type FROM IFSAPP.CUSTOMER_ORDER_LINE_TAB L WHERE L.order_no = C.ORDER_NO AND L.line_no = C.LINE_NO AND L.rel_no = C.REL_NO AND L.line_item_no = C.LINE_ITEM_NO) Catalog_Type,   
    ifsapp.customer_order_line_api.Get_Customer_No(C.ORDER_NO, C.LINE_NO, C.REL_NO, C.LINE_ITEM_NO) Customer_No,
    ifsapp.customer_info_api.Get_Name
      (ifsapp.customer_order_line_api.Get_Customer_No(C.ORDER_NO, C.LINE_NO, C.REL_NO, C.LINE_ITEM_NO)) customer_name,
    ifsapp.CUSTOMER_INFO_COMM_METHOD_API.Get_Any_Phone_No
      (ifsapp.customer_order_line_api.Get_Customer_No(C.ORDER_NO, C.LINE_NO, C.REL_NO, C.LINE_ITEM_NO)) phone_no,
    IFSAPP.CUSTOMER_INFO_API.Get_NIC_No
      (ifsapp.customer_order_line_api.Get_Customer_No(C.ORDER_NO, C.LINE_NO, C.REL_NO, C.LINE_ITEM_NO)) NIC_NO,
    (select a.address1 from CUSTOMER_INFO_ADDRESS a where a.customer_id = ifsapp.customer_order_line_api.Get_Customer_No(C.ORDER_NO, C.LINE_NO, C.REL_NO, C.LINE_ITEM_NO)) || ' ' ||
    (select a.address2 from CUSTOMER_INFO_ADDRESS a where a.customer_id = ifsapp.customer_order_line_api.Get_Customer_No(C.ORDER_NO, C.LINE_NO, C.REL_NO, C.LINE_ITEM_NO)) Customer_Address
FROM CUSTOMER_ORDER_LINE_TAB C
where 
  substr(c.order_no,4,2) = '-R' and
  c.real_ship_date >= to_date('2014/10/1', 'YYYY/MM/DD') and
  C.CONTRACT NOT IN ('SCOM', /*'BWHW', 'KWHW', 'RWHW', 'TWHW', 'CMWH', 'SPWH', 'SWHW', 'CTGW', 'APWH', 'SYWH', 'MYWH', 
    'BSCP', 'CSCP', 'DSCP', 'JSCP', 'RSCP', 'SSCP', 'MS1C', 'MS2C', 'BTSC',*/ 
    'WSMO', 'SWSS', 'SAOS', 'JWSS', 'SCSM', 'SAPM', 'SESM') and
  c.order_no in (select h.order_no from HPNRET_CUSTOMER_ORDER_TAB h where h.cash_conv = 'FALSE') and  
  c.catalog_type != 'KOMP' and
  c.rowstate in ('Delivered', 'Invoiced', 'PartiallyDelivered') and
  c.demand_order_ref1 is null AND
  c.contract like '&SHOP_CODE'
order by c.contract, c.order_no, c.catalog_no
