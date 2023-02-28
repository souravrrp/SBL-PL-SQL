/* Formatted on 2/23/2023 2:07:47 PM (QP5 v5.381) */
SELECT *
  FROM ifsapp.inventory_part pi;

SELECT ifsapp.inventory_part_api.Get_Description (pi.contract, pi.part_no)
           part_description,
       pi.*
  FROM ifsapp.inventory_part_tab pi
 WHERE     1 = 1
       AND (   :p_product_code IS NULL
            OR (UPPER (pi.PART_NO) LIKE UPPER ('%' || :p_product_code || '%')))
       AND ( :p_shop_code IS NULL OR (pi.contract = :p_shop_code))
       AND (   :p_product_description IS NULL
            OR (UPPER (pi.description) LIKE
                    UPPER ('%' || :p_product_description || '%')));