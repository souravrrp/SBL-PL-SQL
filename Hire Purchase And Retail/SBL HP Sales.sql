/* Formatted on 4/11/2022 2:03:46 PM (QP5 v5.381) */
SELECT hhdt.account_no hp_account_no
  ,hhht.*
  --,colt.*
  FROM ifsapp.hpnret_hp_head_tab hhht, ifsapp.hpnret_hp_dtl_tab hhdt
 WHERE     1 = 1
       AND hhht.account_no = hhdt.account_no
       --AND hhht.account_no = 'DGN-H11284'
       AND (   :p_account_no IS NULL
            OR (UPPER (hhht.account_no) = UPPER ( :p_account_no)));

--------------------------------------------------------------------------------

SELECT *
  FROM ifsapp.hpnret_hp_head_tab hhht
 WHERE 1 = 1 
 --AND hhht.account_no = 'NRL-H4522'
 AND (   :p_account_no IS NULL
            OR (UPPER (hhht.account_no) = UPPER ( :p_account_no)));;

SELECT 
*
--distinct CATALOG_TYPE
  FROM ifsapp.hpnret_hp_dtl_tab hhdt
 WHERE 1 = 1 
 --and CATALOG_TYPE='PKG'
 --AND hhdt.account_no = 'NRL-H4522'
 AND (   :p_account_no IS NULL
            OR (UPPER (hhdt.account_no) = UPPER ( :p_account_no)));;