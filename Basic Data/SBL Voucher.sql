/* Formatted on 4/4/2022 12:20:30 PM (QP5 v5.381) */
SELECT vt.voucher_type, vt.voucher_group, vt.description
  FROM ifsapp.voucher_type vt, ifsapp.voucher_type_detail vtd
 WHERE     1 = 1
       AND vt.voucher_type = vtd.voucher_type
       AND (   :p_voucher_type IS NULL
            OR (UPPER (vt.voucher_type) LIKE
                    UPPER ('%' || :p_voucher_type || '%')))
       AND (   :p_voucher_description IS NULL
            OR (UPPER (vt.description) LIKE
                    UPPER ('%' || :p_voucher_description || '%')));

--------------------------------------------------------------------------------

SELECT *
  FROM ifsapp.voucher_type vt;

SELECT *
  FROM ifsapp.voucher_type_detail vtd;

SELECT *
  FROM ifsapp.voucher_type_detail_query vtdq;