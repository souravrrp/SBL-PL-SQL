/* Formatted on 4/6/2022 9:16:20 AM (QP5 v5.381) */
SELECT *
  FROM ifsapp.voucher v, ifsapp.voucher_row vr
 WHERE 1 = 1 AND v.voucher_no = vr.voucher_no AND v.voucher_no = '2100072863';


--------------------------------------------------------------------------------

SELECT *
  FROM ifsapp.voucher
 WHERE 1 = 1 AND voucher_no = '2100072863';

SELECT *
  FROM ifsapp.voucher_row
 WHERE 1 = 1 AND account = '60010050';