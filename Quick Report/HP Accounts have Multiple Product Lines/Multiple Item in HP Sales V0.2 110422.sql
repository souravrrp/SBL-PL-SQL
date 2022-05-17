/* Formatted on 4/11/2022 2:46:20 PM (QP5 v5.381) */
  SELECT hhht.account_no         order_no,
         hhht.rowstate           order_status,
         hhht.sales_date         sales_date,
         hhht.budget_book_id     budget_book,
         hhdt.part_no,
         SUM (hhdt.quantity)     qty
    FROM ifsapp.hpnret_hp_head_tab hhht, ifsapp.hpnret_hp_dtl_tab hhdt
   WHERE     1 = 1
         AND hhht.account_no = hhdt.account_no
         AND hhht.rowstate = 'Active'
         AND hhdt.SALE_UNIT_PRICE <> 0
         AND EXISTS
                 (SELECT 1
                    FROM ifsapp.hpnret_hp_dtl_tab line
                   WHERE 1 = 1 AND line.account_no = hhht.account_no
                  HAVING COUNT (line.line_no) > 1)
GROUP BY hhht.account_no,
         hhht.rowstate,
         hhht.sales_date,
         hhht.budget_book_id,
         hhdt.part_no
ORDER BY hhht.account_no;