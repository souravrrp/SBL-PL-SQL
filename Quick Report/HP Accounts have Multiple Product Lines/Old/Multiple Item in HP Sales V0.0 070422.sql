/* Formatted on 4/6/2022 3:11:25 PM (QP5 v5.381) */
  SELECT cot.order_no,
         cot.date_entered           sales_date,
         hhht.budget_book_id        budget_book,
         colt.part_no,
         SUM (colt.desired_qty)     qty
    --,cot.*
    --,colt.*
    FROM ifsapp.customer_order_tab     cot,
         ifsapp.customer_order_line_tab colt,
         ifsapp.hpnret_hp_head_tab     hhht
   WHERE     1 = 1
         AND cot.order_no = colt.order_no
         AND cot.order_no = hhht.account_no
         --AND cot.order_no IN ('KTA-H8296', 'KTA-H8297')
         --AND to_date (cot.date_entered,'YYYY-MM-DD HH24:MI:SS') BETWEEN NVL (TO_DATE ( :p_date_from), to_date (cot.date_entered,'YYYY-MM-DD HH24:MI:SS')) AND NVL (TO_DATE ( :p_date_to), to_date (cot.date_entered,'YYYY-MM-DD HH24:MI:SS'))
         AND EXISTS
                 (SELECT 1
                    FROM ifsapp.customer_order_line_tab line
                   WHERE 1 = 1 AND line.order_no = colt.order_no
                  HAVING COUNT (colt.line_no) > 1)
GROUP BY cot.order_no,
         cot.date_entered,
         hhht.budget_book_id,
         colt.part_no;