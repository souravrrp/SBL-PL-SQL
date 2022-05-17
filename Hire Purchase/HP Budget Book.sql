/* Formatted on 4/7/2022 11:17:12 AM (QP5 v5.381) */
SELECT hhht.budget_book_id     bbid
  --,hhht.*
  --,hbmdt
  FROM ifsapp.hpnret_hp_head_tab hhht, hpnret_bb_main_detail_tab hbmdt
 WHERE     1 = 1
       AND hhht.budget_book_id = hbmdt.budget_book_id
       AND hhht.account_no IN ('KTA-H8296', 'KTA-H8297');

--------------------------------------------------------------------------------

SELECT budget_book_id bbid, tab.*
  FROM ifsapp.hpnret_hp_head_tab tab
 WHERE account_no IN ('KTA-H8296', 'KTA-H8297');

SELECT * FROM hpnret_bb_main_detail_tab;

--------------------------------------------------------------------------------

SELECT *
  FROM ifsapp.hpnret_bb_main hbm;

SELECT * FROM ifsapp.hpnret_bb_main_detail;