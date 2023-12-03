/* Formatted on 11/14/2023 12:53:22 PM (QP5 v5.381) */
SELECT *
  FROM ifsapp.sbl_sms_hp_collection sms
 WHERE 1 = 1 AND ( :p_order_no IS NULL OR (sms.account_no = :p_order_no));

SELECT *
  FROM ifsapp.sbl_sms_ws_sales_new sms
 WHERE 1 = 1 AND ( :p_order_no IS NULL OR (sms.account_no = :p_order_no));

SELECT *
  FROM ifsapp.sbl_sms_order_line sms
 WHERE 1 = 1 AND ( :p_order_no IS NULL OR (sms.account_no = :p_order_no));

SELECT *
  FROM ifsapp.sbl_sms_ws_return sms
 WHERE 1 = 1 AND ( :p_order_no IS NULL OR (sms.account_no = :p_order_no));

SELECT *
  FROM ifsapp.sbl_sms_ws_sales sms
 WHERE 1 = 1 AND ( :p_order_no IS NULL OR (sms.account_no = :p_order_no));

SELECT *
  FROM ifsapp.sbl_sms_cs_sales sms
 WHERE 1 = 1 AND ( :p_order_no IS NULL OR (sms.account_no = :p_order_no));

SELECT *
  FROM ifsapp.sbl_sms_cs_return sms
 WHERE 1 = 1 AND ( :p_order_no IS NULL OR (sms.account_no = :p_order_no));

SELECT *
  FROM ifsapp.sbl_sms_cs_coll sms
 WHERE 1 = 1 AND ( :p_order_no IS NULL OR (sms.account_no = :p_order_no));

SELECT *
  FROM ifsapp.sbl_sms_ws_return_new sms
 WHERE 1 = 1 AND ( :p_order_no IS NULL OR (sms.account_no = :p_order_no));

SELECT *
  FROM ifsapp.sbl_sms_lpr_cc sms
 WHERE 1 = 1 AND ( :p_order_no IS NULL OR (sms.account_no = :p_order_no));

SELECT *
  FROM ifsapp.sbl_sms_ws_coll sms
 WHERE 1 = 1 AND ( :p_order_no IS NULL OR (sms.account_no = :p_order_no));

SELECT *
  FROM ifsapp.sbl_sms_cash_sales sms
 WHERE 1 = 1 AND ( :p_order_no IS NULL OR (sms.account_no = :p_order_no));

SELECT *
  FROM ifsapp.sbl_sms_arrear_accts sms
 WHERE 1 = 1 AND ( :p_order_no IS NULL OR (sms.account_no = :p_order_no));

SELECT *
  FROM ifsapp.sbl_sms_cc_reminder sms
 WHERE 1 = 1 AND ( :p_order_no IS NULL OR (sms.account_no = :p_order_no));

SELECT *
  FROM ifsapp.sbl_sms_collection_cancel sms
 WHERE 1 = 1 AND ( :p_order_no IS NULL OR (sms.account_no = :p_order_no));

SELECT *
  FROM ifsapp.sbl_sms_coll_reminder sms
 WHERE 1 = 1 AND ( :p_order_no IS NULL OR (sms.account_no = :p_order_no));

SELECT *
  FROM ifsapp.sbl_sms_guarantor1 sms
 WHERE 1 = 1 AND ( :p_order_no IS NULL OR (sms.account_no = :p_order_no));

SELECT *
  FROM ifsapp.sbl_sms_guarantor2 sms
 WHERE 1 = 1 AND ( :p_order_no IS NULL OR (sms.account_no = :p_order_no));

SELECT *
  FROM ifsapp.sbl_sms_hp_sales sms
 WHERE 1 = 1 AND ( :p_order_no IS NULL OR (sms.account_no = :p_order_no));

SELECT *
  FROM ifsapp.sbl_sms_lpr sms
 WHERE 1 = 1 AND ( :p_order_no IS NULL OR (sms.account_no = :p_order_no));

SELECT *
  FROM ifsapp.sbl_sms_online_collection sms
 WHERE 1 = 1 AND ( :p_order_no IS NULL OR (sms.account_no = :p_order_no));

SELECT *
  FROM ifsapp.sbl_sms_revert sms
 WHERE 1 = 1 AND ( :p_order_no IS NULL OR (sms.account_no = :p_order_no));

SELECT *
  FROM ifsapp.sbl_sms_sales_exin sms
 WHERE 1 = 1 AND ( :p_order_no IS NULL OR (sms.account_no = :p_order_no));

SELECT *
  FROM ifsapp.sbl_sms_sales_return sms
 WHERE 1 = 1 AND ( :p_order_no IS NULL OR (sms.account_no = :p_order_no));


------------------------------------------------BKP-----------------------------

SELECT * FROM ifsapp.sbl_sms_cs_return_old;

SELECT * FROM ifsapp.sbl_sms_cs_return_bkp;

SELECT * FROM ifsapp.sbl_sms_cs_sales_bkp;

SELECT * FROM ifsapp.sbl_sms_ws_return_bkp;

SELECT * FROM ifsapp.sbl_sms_ws_sales_old;

SELECT * FROM ifsapp.sbl_sms_lpr_cc_old;