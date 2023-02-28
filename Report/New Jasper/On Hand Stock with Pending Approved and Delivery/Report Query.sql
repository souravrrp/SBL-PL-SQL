/* Formatted on 2/13/2023 8:49:46 AM (QP5 v5.381) */
  SELECT i.vendor_no
             warehouse,
         i.part_no,
         SUM (i.qty_onhand)
             qty_onhand,
         ifsapp.sbl_pending_delivery_qty (i.part_no, i.vendor_no)
             pending_delivered_qty,
         ifsapp.sbl_pending_planned_qty (i.part_no, i.vendor_no)
             pending_planned_qty
    FROM ifsapp.inventory_part_in_stock_tab i
   WHERE     1 = 1
         AND i.qty_onhand > 0
         AND i.part_no = :p_sku
         --and i.vendor_no = :p_warehouse
         AND EXISTS
                 (SELECT 1
                    FROM ifsapp.ware_house_info w
                   WHERE     w.ware_house_name LIKE '%WW'
                         AND w.ware_house_name = i.vendor_no)
GROUP BY i.vendor_no, i.part_no;