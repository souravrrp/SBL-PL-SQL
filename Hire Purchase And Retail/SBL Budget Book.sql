/* Formatted on 3/2/2023 3:01:40 PM (QP5 v5.381) */
SELECT hbmht.budget_book_id, hbmht.description
  --,hbmht.*
  --,hbmdt.*
  FROM ifsapp.hpnret_bb_main_head_tab    hbmht,
       ifsapp.hpnret_bb_main_detail_tab  hbmdt
 WHERE     1 = 1
       AND hbmht.budget_book_id = hbmdt.budget_book_id(+)
       AND (   :p_budget_book_id IS NULL
            OR (UPPER (hbmht.budget_book_id) = UPPER ( :p_budget_book_id)));

--------------------------------------------------------------------------------

SELECT hbmht.budget_book_id bb_id, hbmht.description bb_description, hbmht.*
  FROM ifsapp.hpnret_bb_main_head_tab hbmht
 WHERE     1 = 1
       AND (   :p_budget_book_id IS NULL
            OR (UPPER (hbmht.budget_book_id) = UPPER ( :p_budget_book_id)));