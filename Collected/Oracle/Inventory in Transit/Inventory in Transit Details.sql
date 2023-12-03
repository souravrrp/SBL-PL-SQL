--***** Inventory in Transit Details
select t.*,
       IFSAPP.Inv_Transit_Tracking_API.Get_Demand_Order_Ref1(t.ORDER_NO,
                                                             t.LINE_NO,
                                                             t.REL_NO,
                                                             t.LINE_ITEM_NO) as PO_NO
  from INV_TRANSIT_TRACKING t
 where t.qty > 0
