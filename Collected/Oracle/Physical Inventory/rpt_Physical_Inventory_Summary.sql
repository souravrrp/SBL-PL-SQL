SELECT 
    --v.site,
    v.PRODUCT_CATEGORY,
    v.catalog_no,
    sum(v.qty_onhand) total_qty_onhand,
    sum(v.qty_in_transit) total_qty_in_transit,
    sum(v.qty_saleable) total_qty_saleable,
    sum(v.qty_co_return) total_qty_co_return,
    sum(v.qty_revert) total_qty_revert,
    sum(v.qty_ber) total_qty_ber,
    sum(v.qty_under_service) total_qty_under_service,
    sum(v.qty_defective) total_qty_major_defect,
    sum(v.qty_sold) total_qty_sold,
    sum(v.qty_sent) total_qty_sent,
    sum(v.qty_received) total_qty_received,
    sum(v.qty_short_over) total_qty_short_over
FROM SBL_PHYSICAL_INVENTORY_STATUS v
WHERE 
  --v.site LIKE '&Shop_Code' and
  v.PRODUCT_CATEGORY like '&Product_Category'
GROUP BY v.PRODUCT_CATEGORY, v.catalog_no
ORDER BY v.PRODUCT_CATEGORY, v.catalog_no
