/* Formatted on 4/12/2022 10:51:09 AM (QP5 v5.381) */
  SELECT hhht.contract                               shop_code,
         sdi.area_code,
         sdi.district_code,
         hhht.account_no                             order_no,
         hhdt.line_no,
         hhdt.ref_rel_no,
         hhht.rowstate                               order_status,
         TO_CHAR (hhht.sales_date, 'YYYY/MM/DD')     sales_date,
         hhht.budget_book_id                         budget_book,
         hhdt.part_no,
         hhdt.quantity
    FROM ifsapp.hpnret_hp_head_tab hhht,
         ifsapp.hpnret_hp_dtl_tab hhdt,
         ifsapp.shop_dts_info     sdi
   WHERE     hhht.account_no = hhdt.account_no
         AND hhht.contract = sdi.shop_code
         AND sdi.shop_code LIKE '&SHOP_CODE'
         AND hhdt.rowstate = 'Active'
         AND hhdt.sale_unit_price <> 0
         AND hhdt.catalog_type <> 'KOMP'
         AND EXISTS
                 (SELECT 1
                    FROM ifsapp.hpnret_hp_dtl_tab line
                   WHERE     line.account_no = hhdt.account_no
                         AND line.sale_unit_price <> 0
                         AND line.rowstate = 'Active'
                         AND line.catalog_type <> 'KOMP'
                  HAVING COUNT (line.line_no) > 1)
ORDER BY hhht.contract, hhht.account_no, hhdt.line_no