/* Formatted on 7/27/2022 10:46:25 AM (QP5 v5.381) */
SELECT *
  FROM ifsapp.inventory_part pi;

SELECT *
  FROM ifsapp.inventory_part_tab pi
 WHERE     1 = 1
       and (   :p_product_code IS NULL
            OR (UPPER (pi.PART_NO) LIKE
                    UPPER ('%' || :p_product_code || '%')))
       AND (   :p_product_description IS NULL
            OR (UPPER (pi.description) LIKE
                    UPPER ('%' || :p_product_description || '%')));