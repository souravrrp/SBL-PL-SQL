SELECT i.vendor_no
             warehouse,
         i.part_no,
         SUM (i.qty_onhand)
             qty_onhand,
         ifsapp.sbl_pending_po_qty (i.part_no, i.vendor_no)
             pending_delivered_qty,
         ifsapp.sbl_pending_planned_qty (i.part_no, i.vendor_no)
             pending_planned_qty
    FROM ifsapp.inventory_part_in_stock_tab i
   WHERE     1 = 1
         AND i.qty_onhand > 0
         AND $X{IN, i.vendor_no, WAREHOUSE}
         AND $X{IN, i.part_no, PART_NO}
         AND EXISTS
                 (SELECT 1
                    FROM ifsapp.ware_house_info w
                   WHERE     w.ware_house_name LIKE '%WW'
                         AND w.ware_house_name = i.vendor_no)
GROUP BY i.vendor_no, i.part_no