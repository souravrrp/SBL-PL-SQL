/* Formatted on 4/13/2022 11:29:13 AM (QP5 v5.381) */
SELECT *
  FROM ifsapp.hpnret_pay_receipt_head_tab  hprht,
       ifsapp.hpnret_pay_receipt_tab       hprt
 WHERE     1 = 1
       AND hprht.receipt_no = hprt.receipt_no(+)
       AND (   :P_receipt_no IS NULL
            OR (UPPER (hprht.receipt_no) = UPPER ( :P_receipt_no)));


--------------------------------------------------------------------------------

SELECT *
  FROM ifsapp.hpnret_pay_receipt_tab hprt;

SELECT *
  FROM ifsapp.hpnret_pay_receipt_head_tab hprht;

--------------------------------------------------------------------------------

SELECT * FROM ifsapp.sbl_sms_hp_collection;

SELECT * FROM ifsapp.sbl_sms_cs_coll;

SELECT * FROM ifsapp.sbl_sms_online_collection;