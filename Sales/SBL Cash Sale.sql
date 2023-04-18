/* Formatted on 5/18/2022 9:44:35 AM (QP5 v5.381) */
SELECT *
  FROM ifsapp.hpnret_pay_receipt_head_tab  hprht,
       ifsapp.hpnret_pay_receipt_tab       hprt
 WHERE     1 = 1
       AND hprht.receipt_no = hprt.receipt_no
       AND (   :p_receipt_no IS NULL
            OR (UPPER (hprht.receipt_no) LIKE
                    UPPER ('%' || :p_receipt_no || '%')));


--------------------------------------------------------------------------------

SELECT *
  FROM ifsapp.hpnret_pay_receipt_head_tab hprht;

SELECT *
  FROM ifsapp.hpnret_pay_receipt_tab hprt;