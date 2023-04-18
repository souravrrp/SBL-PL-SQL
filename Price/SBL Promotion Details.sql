/* Formatted on 4/12/2023 2:31:09 PM (QP5 v5.381) */
SELECT *
  FROM ifsapp.sbl_discount_promotion sdp
 WHERE     1 = 1                             --AND d.channel IN ('ALL', '736')
       AND (   :p_promotion_name IS NULL
            OR (UPPER (sdp.description) LIKE
                    UPPER ('%' || :p_promotion_name || '%')))
       AND (   :p_product_code IS NULL
            OR (UPPER (sdp.part_no) LIKE UPPER ('%' || :p_product_code || '%')))
       AND NVL ( :p_date_from, sdp.valid_from) <= sdp.valid_from
       --AND TRUNC (SYSDATE) BETWEEN sdp.valid_from AND sdp.valid_to
       AND NVL ( :p_date_to, sdp.valid_to) >= sdp.valid_to;