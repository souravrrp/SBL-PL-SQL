SELECT v.site,
       v.PRODUCT_CATEGORY,
       v.catalog_no,
       v.qty_onhand,
       v.qty_in_transit,
       v.qty_saleable,
       v.qty_co_return,
       v.qty_revert,
       v.qty_ber,
       v.qty_under_service,
       v.qty_defective qty_major_defect,
       v.qty_sold,
       v.qty_sent,
       v.qty_received,
       v.qty_short_over,
       v.remarks,
       v.settlement_deadline,
       v.approver_comment
  FROM IFSAPP.SBL_PHYSICAL_INVENTORY_STATUS v
 WHERE v.site LIKE '&Shop_Code'
   and v.PRODUCT_CATEGORY like '&Product_Category'
   and v.site in (SELECT a.shop_code
                    FROM IFSAPP.SBL_SHOP_ARRPOVE_TBL a
                   where a.approve_status = 1)
/*v.qty_onhand is null or
v.qty_saleable is null or
v.qty_revert is null or
v.qty_ber is null or
v.qty_sold is null or
v.qty_sent is null or
v.qty_received is null or
v.qty_short_over is null*/
