--Productwise in transit details Palash
select IFSAPP.Inv_Transit_Tracking_API.Get_Demand_Order_Ref1(m.ORDER_NO,
                                                             m.LINE_NO,
                                                             m.REL_NO,
                                                             m.LINE_ITEM_NO) as PO_NO,
       m.contract as Request_Site,
       IFSAPP.Site_Api.Get_Description(m.contract) request_site_description,
       m.order_no,
       m.part_no,
       IFSAPP.Inventory_Part_API.Get_Description(m.contract, m.part_no) part_des,
       m.qty,
       to_char((IFSAPP.INVENTORY_PART_UNIT_COST_API.Get_Inventory_Value_By_Method(m.contract,
                                                                                  m.part_no,
                                                                                  '',
                                                                                  '',
                                                                                  '')),
               999999999.99) cost_pr,
       to_char(m.trns_date, 'dd/mm/yyyy') as Trn_Date,
       m.delivering_contract as Delivery_Site,
       IFSAPP.Site_Api.Get_Description(m.delivering_contract) as delivery_site
  FROM ifsapp.inv_transit_tracking m, product_category_info p
 WHERE p.PRODUCT_CODE = m.PART_NO
   and m.qty > 0
   AND M.CONTRACT IN (SELECT SHOP_CODE FROM SHOP_DTS_INFO)
   and p.group_no = '$group_no'
   AND NVL(ifsapp.inventory_part_api.Get_Acc_Group(m.delivering_contract,
                                                   m.part_no),
           'X') <> 'BOOKS'
 ORDER BY M.CONTRACT;
 
--Product Group wise On Transit Inventory Jasper
select IFSAPP.Inv_Transit_Tracking_API.Get_Demand_Order_Ref1(m.ORDER_NO,
                                                             m.LINE_NO,
                                                             m.REL_NO,
                                                             m.LINE_ITEM_NO) as PO_NO,
       m.contract as Request_Site,
       IFSAPP.Site_Api.Get_Description(m.contract) request_site_description,
       m.order_no,
       m.part_no,
       IFSAPP.Inventory_Part_API.Get_Description(m.contract, m.part_no) part_des,
       m.qty,
       to_char(m.trns_date, 'dd/mm/yyyy') as Trn_Date,
       m.delivering_contract as Delivery_Site
  FROM ifsapp.inv_transit_tracking m, SBL_JR_PRODUCT_DTL_INFO DI/*, SHOP_DTS_INFO S*/
 where DI.PRODUCT_CODE = m.part_no
   /*AND M.contract = S.SHOP_CODE*/
   AND m.qty > 0
   AND NVL(ifsapp.inventory_part_api.Get_Acc_Group(m.delivering_contract,
                                                   m.part_no),
           'X') <> 'BOOKS'
  /* AND DI.PRODUCT_FAMILY = 'REFRIGERATOR-DIRECT-COOL'*/ --$P{PRODUCT_GROUP}
 ORDER BY M.CONTRACT;
