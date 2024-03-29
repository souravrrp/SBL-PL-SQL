--*****Cancelled Sales Retail
--*****Cancelled Cash Sales
SELECT C.ORDER_NO,
       C.LINE_NO,
       C.REL_NO,
       C.LINE_ITEM_NO,
       C.CONTRACT "SITE",
       C.CATALOG_NO PART_NO,
       /*C.CATALOG_DESC PART_DESCRIPTION,*/
       C.CATALOG_TYPE PART_TYPE,
       TO_CHAR(C.REAL_SHIP_DATE, 'YYYY/MM/DD') SALE_DATE,
       C.QTY_SHIPPED QUANTITY,
       C.BASE_SALE_UNIT_PRICE UNIT_NSP,
       IFSAPP.CUSTOMER_ORDER_LINE_API.Get_Total_Discount(C.ORDER_NO,
                                                         C.LINE_NO,
                                                         C.REL_NO,
                                                         C.LINE_ITEM_NO) Discount,
       IFSAPP.customer_order_line_api.Get_Sale_Price_Total(c.order_no,
                                                           c.LINE_NO,
                                                           c.REL_NO,
                                                           c.LINE_ITEM_NO) sales_price,
       IFSAPP.Customer_Order_Line_API.Get_Total_Tax_Amount(c.order_no,
                                                           c.line_no,
                                                           c.rel_no,
                                                           c.line_item_no) VAT,
       C.ROWSTATE STATUS
  FROM CUSTOMER_ORDER_LINE_TAB C
 where substr(c.order_no, 4, 2) = '-R'
   and C.CONTRACT NOT IN ('SCOM',
                          'APWH',
                          'BBWH',
                          'BWHW',
                          'CMWH',
                          'CTGW',
                          'KWHW',
                          'MYWH',
                          'RWHW',
                          'SPWH',
                          'SWHW',
                          'SYWH',
                          'TWHW',
                          'ABWW', --Wholesale Warehouse
                          'BAWW',
                          'BGWW',
                          'CLWW',
                          'CTWW',
                          'KHWW',
                          'MHWW',
                          'RHWW',
                          'SDWW',
                          'SVWW',
                          'SLWW',
                          'TUWW',
                          'BSCP',
                          'BLSP',
                          'CLSP',
                          'CSCP',
                          'CXSP', --New Service Center
                          'DSCP',
                          'JSCP',
                          'MSCP',
                          'RPSP', --New Service Center
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
                          'SFSM',
                          'SOSM')
   and c.order_no in (select h.order_no
                        from HPNRET_CUSTOMER_ORDER_TAB h
                       where h.cash_conv = 'FALSE')
   and c.catalog_type != 'KOMP'
   and c.rowstate = 'Cancelled'
   and c.demand_order_ref1 is null
   and c.real_ship_date between to_date('&from_date', 'YYYY/MM/DD') and
       to_date('&to_date', 'YYYY/MM/DD')

UNION ALL

--*****Cancelled HP Sales
select h.account_no,
       h.ref_line_no LINE_NO,
       h.ref_rel_no REL_NO,
       h.ref_line_item_no LINE_ITEM_NO,
       h.contract,
       h.catalog_no PART_NO,
       /*IFSAPP.customer_order_line_api.Get_Catalog_Desc(h.account_no,
                                                       h.ref_line_no,
                                                       h.ref_rel_no,
                                                       h.ref_line_item_no) PART_DESCRIPTION,*/
       h.catalog_type PART_TYPE,
       to_char(t.sales_date, 'YYYY/MM/DD') sales_date,
       h.quantity,
       h.sale_unit_price UNIT_NSP,
       round(h.discount, 2) discount,
       IFSAPP.customer_order_line_api.Get_Sale_Price_Total(h.account_no,
                                                           h.ref_line_no,
                                                           h.ref_rel_no,
                                                           h.ref_line_item_no) SALES_PRICE,
       IFSAPP.Customer_Order_Line_API.Get_Total_Tax_Amount(h.account_no,
                                                           h.ref_line_no,
                                                           h.ref_rel_no,
                                                           h.ref_line_item_no) VAT,
       h.rowstate STATUS
  from ifsapp.hpnret_hp_dtl_tab h, IFSAPP.HPNRET_HP_HEAD_TAB T
 where H.ACCOUNT_NO = T.ACCOUNT_NO
   AND H.CONTRACT = T.CONTRACT
   AND h.catalog_type != 'KOMP'
   and h.cash_price != 0
   and h.contract not in ('SCOM',
                          'APWH',
                          'BBWH',
                          'BWHW',
                          'CMWH',
                          'CTGW',
                          'KWHW',
                          'MYWH',
                          'RWHW',
                          'SPWH',
                          'SWHW',
                          'SYWH',
                          'TWHW',
                          'ABWW', --Wholesale Warehouse
                          'BAWW',
                          'BGWW',
                          'CLWW',
                          'CTWW',
                          'KHWW',
                          'MHWW',
                          'RHWW',
                          'SDWW',
                          'SVWW',
                          'SLWW',
                          'TUWW',
                          'BSCP',
                          'BLSP',
                          'CLSP',
                          'CSCP',
                          'CXSP', --New Service Center
                          'DSCP',
                          'JSCP',
                          'MSCP',
                          'RPSP', --New Service Center
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
                          'SFSM',
                          'SOSM')
   and h.rowstate = 'Cancelled'
   and trunc(t.sales_date) between to_date('&from_date', 'YYYY/MM/DD') and
       to_date('&to_date', 'YYYY/MM/DD')
 order by 1, 2, 3
