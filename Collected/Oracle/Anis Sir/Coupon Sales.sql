--Cash Sale with Remarks (Coupon)
select o.order_no,
       o.contract,
       l.catalog_no,
       IFSAPP.INVENTORY_PRODUCT_CODE_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Code('SCOM',
                                                                                                         l.catalog_no)) brand,
       ifsapp.INVENTORY_PRODUCT_FAMILY_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Family('SCOM',
                                                                                                             l.catalog_no)) product_family,
       IFSAPP.COMMODITY_GROUP_API.Get_Description(IFSAPP.INVENTORY_PART_API.Get_Second_Commodity('SCOM',
                                                                                                 l.catalog_no)) commodity_group2,
       IFSAPP.SALES_GROUP_API.Get_Description(IFSAPP.SALES_PART_API.Get_Catalog_Group('SCOM',
                                                                                      l.catalog_no)) sales_group,
       l.real_ship_date sales_date,
       l.qty_shipped quantity,
       o.remarks,
       ifsapp.Customer_Order_Api.Get_Customer_No(o.order_no) customer_no,
       ifsapp.customer_info_api.Get_Name(ifsapp.Customer_Order_Api.Get_Customer_No(o.order_no)) Customer_Name,
       IFSAPP.CUSTOMER_INFO_COMM_METHOD_API.Get_Value(ifsapp.Customer_Order_Api.Get_Customer_No(o.order_no),
                                                      1) Phone_No
--l.rowstate
  from ifsapp.hpnret_customer_order_tab o, ifsapp.CUSTOMER_ORDER_LINE_TAB l
 where o.order_no = l.order_no
   and o.contract = l.contract
   and substr(l.order_no, 4, 2) = '-R'
   and
      --l.catalog_no like '%TV%' and
       l.catalog_type != 'KOMP'
   and o.contract like '&Shop_Code'
   and o.contract not in ('BLSP',
                          'BSCP',
                          'CLSP',
                          'CSCP',
                          'DSCP',
                          'JSCP',
                          'RSCP',
                          'SSCP',
                          'MS1C',
                          'MS2C',
                          'BTSC')
   and
      --trunc(o.date_entered) between to_date('&from_date', 'YYYY/MM/DD') and to_date('&to_date', 'YYYY/MM/DD') and
       l.real_ship_date between to_date('&from_date', 'YYYY/MM/DD') and
       to_date('&to_date', 'YYYY/MM/DD')
   and o.cash_conv = 'FALSE'
   and l.rowstate in ('Delivered', 'Invoiced', 'PartiallyDelivered')
   and l.demand_order_ref1 is null
   and IFSAPP.INVENTORY_PRODUCT_CODE_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Code('SCOM',
                                                                                                         l.catalog_no)) =
       'Beko'
--order by o.contract, o.order_no

union

--*****Hire Sale with Remarks (Coupon)
select h.account_no order_no,
       h.contract,
       h.catalog_no,
       IFSAPP.INVENTORY_PRODUCT_CODE_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Code('SCOM',
                                                                                                         h.catalog_no)) brand,
       ifsapp.INVENTORY_PRODUCT_FAMILY_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Family('SCOM',
                                                                                                             h.catalog_no)) product_family,
       IFSAPP.COMMODITY_GROUP_API.Get_Description(IFSAPP.INVENTORY_PART_API.Get_Second_Commodity('SCOM',
                                                                                                 h.catalog_no)) commodity_group2,
       IFSAPP.SALES_GROUP_API.Get_Description(IFSAPP.SALES_PART_API.Get_Catalog_Group('SCOM',
                                                                                      h.catalog_no)) sales_group,
       trunc(h.sales_date) sales_date,
       h.quantity,
       t.remarks,
       ifsapp.Customer_Order_Api.Get_Customer_No(h.account_no) customer_no,
       ifsapp.customer_info_api.Get_Name(ifsapp.Customer_Order_Api.Get_Customer_No(h.account_no)) Customer_Name,
       IFSAPP.CUSTOMER_INFO_COMM_METHOD_API.Get_Value(ifsapp.Customer_Order_Api.Get_Customer_No(h.account_no),
                                                      1) Phone_No
--h.ROWSTATE
  from ifsapp.hpnret_hp_dtl_tab h, IFSAPP.HPNRET_HP_HEAD_TAB T
 where H.ACCOUNT_NO = T.ACCOUNT_NO
   AND H.CONTRACT = T.CONTRACT
   AND
      --h.catalog_no like '%TV%' and
       h.catalog_type != 'KOMP'
   and h.contract like '&Shop_Code'
   and h.contract not in ('BLSP',
                          'BSCP',
                          'CLSP, ''CSCP',
                          'DSCP',
                          'JSCP',
                          'RSCP',
                          'SSCP',
                          'MS1C',
                          'MS2C',
                          'BTSC')
   and trunc(T.sales_date) between to_date('&from_date', 'YYYY/MM/DD') and
       to_date('&to_date', 'YYYY/MM/DD')
   and h.rowstate not in ('AssumeClosed',
                          'Cancelled',
                          'CashConverted',
                          'Closed',
                          'DiscountClosed',
                          'ExchangedIn',
                          'Planned',
                          'Released',
                          'Returned',
                          'RevertReversed',
                          'Reverted',
                          'TermChanged',
                          'ToBeReverted',
                          'TransferAccount')
   and IFSAPP.INVENTORY_PRODUCT_CODE_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Code('SCOM',
                                                                                                         h.catalog_no)) =
       'Beko'
--order by h.contract, h.account_no
