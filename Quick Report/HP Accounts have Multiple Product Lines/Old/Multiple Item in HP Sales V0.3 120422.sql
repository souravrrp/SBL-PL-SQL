/* Formatted on 4/12/2022 10:32:35 AM (QP5 v5.381) */
  SELECT hhht.account_no         order_no,
         hhdt.line_no,
         hhdt.ref_rel_no,
         hhht.rowstate           order_status,
         hhht.sales_date         sales_date,
         hhht.budget_book_id     budget_book,
         hhdt.part_no,
         hhdt.quantity
    FROM ifsapp.hpnret_hp_head_tab hhht, ifsapp.hpnret_hp_dtl_tab hhdt
   WHERE     1 = 1
         AND hhht.account_no = hhdt.account_no
         AND hhdt.rowstate = 'Active'
         AND hhdt.sale_unit_price <> 0
         AND hhdt.catalog_type <> 'KOMP'
         AND EXISTS
                 (SELECT 1
                    FROM ifsapp.hpnret_hp_dtl_tab line
                   WHERE     1 = 1
                         AND line.account_no = hhdt.account_no
                         AND line.sale_unit_price <> 0
                         AND line.rowstate = 'Active'
                         AND line.catalog_type <> 'KOMP'
                  HAVING COUNT (line.line_no) > 1)
ORDER BY hhht.account_no;