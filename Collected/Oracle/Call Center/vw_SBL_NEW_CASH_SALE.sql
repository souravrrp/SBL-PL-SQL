create or replace view SBL_NEW_CASH_SALE as
  SELECT C.ORDER_NO,
         C.LINE_NO,
         C.REL_NO,
         C.LINE_ITEM_NO,
         C.CONTRACT "SITE",
         C.CATALOG_NO PART_NO,
         C.CATALOG_DESC PART_DESCRIPTION,
         C.CATALOG_TYPE PART_TYPE,
         TO_CHAR(C.REAL_SHIP_DATE, 'YYYY/MM/DD') SALE_DATE,
         C.BASE_SALE_UNIT_PRICE,
         IFSAPP.customer_order_line_api.Get_Sale_Price_Total(c.order_no,
                                                             c.LINE_NO,
                                                             c.REL_NO,
                                                             c.LINE_ITEM_NO) NSP,
         IFSAPP.CUSTOMER_ORDER_LINE_API.Get_Total_Discount(C.ORDER_NO,
                                                           C.LINE_NO,
                                                           C.REL_NO,
                                                           C.LINE_ITEM_NO) Discount,
         IFSAPP.Customer_Order_Line_API.Get_Total_Tax_Amount(c.order_no,
                                                             c.line_no,
                                                             c.rel_no,
                                                             c.line_item_no) VAT,
         C.QTY_SHIPPED QUANTITY,
         C.ROWSTATE STATUS,
         ifsapp.customer_order_line_api.Get_Customer_No(C.ORDER_NO,
                                                        C.LINE_NO,
                                                        C.REL_NO,
                                                        C.LINE_ITEM_NO) Customer_No,
         ifsapp.customer_info_api.Get_Name(ifsapp.customer_order_line_api.Get_Customer_No(C.ORDER_NO,
                                                                                          C.LINE_NO,
                                                                                          C.REL_NO,
                                                                                          C.LINE_ITEM_NO)) customer_name,
         ifsapp.CUSTOMER_INFO_COMM_METHOD_API.Get_Any_Phone_No(ifsapp.customer_order_line_api.Get_Customer_No(C.ORDER_NO,
                                                                                                              C.LINE_NO,
                                                                                                              C.REL_NO,
                                                                                                              C.LINE_ITEM_NO)) phone_no,
         (select a.address1
            from CUSTOMER_INFO_ADDRESS a
           where a.customer_id =
                 ifsapp.customer_order_line_api.Get_Customer_No(C.ORDER_NO,
                                                                C.LINE_NO,
                                                                C.REL_NO,
                                                                C.LINE_ITEM_NO)) || ' ' ||
         (select a.address2
            from CUSTOMER_INFO_ADDRESS a
           where a.customer_id =
                 ifsapp.customer_order_line_api.Get_Customer_No(C.ORDER_NO,
                                                                C.LINE_NO,
                                                                C.REL_NO,
                                                                C.LINE_ITEM_NO)) Customer_Address
    FROM CUSTOMER_ORDER_LINE_TAB C
   where substr(c.order_no, 4, 2) = '-R'
     and C.CONTRACT NOT IN ('SCOM',
                            'BWHW',
                            'KWHW',
                            'RWHW',
                            'TWHW',
                            'CMWH',
                            'SPWH',
                            'SWHW',
                            'CTGW',
                            'APWH',
                            'SYWH',
                            'MYWH',
                            'BSCP',
                            'BLSP',
                            'CSCP',
                            'CLSP',
                            'DSCP',
                            'JSCP',
                            'RSCP',
                            'SSCP',
                            'MS1C',
                            'MS2C',
                            'BTSC',
                            'JWSS',
                            'SAOS',
                            'SWSS',
                            'WSMO',
                            'SAPM',
                            'SCSM',
                            'SESM',
                            'SHOM',
                            'SISM',
                            'SFSM')
     and c.order_no in (select h.order_no
                          from HPNRET_CUSTOMER_ORDER_TAB h
                         where h.cash_conv = 'FALSE')
     and c.catalog_type != 'KOMP'
     and c.rowstate in ('Delivered', 'Invoiced', 'PartiallyDelivered')
     and c.demand_order_ref1 is null
