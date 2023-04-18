/* Formatted on 4/2/2023 1:40:45 PM (QP5 v5.381) */
SELECT pit.part_no
           product_code,
       ifsapp.inventory_part_api.Get_Description (pit.contract, pit.part_no)
           part_description,
       second_commodity,
       pit.*
  FROM ifsapp.inventory_part_tab pit
 WHERE     1 = 1
       AND (   :p_product_code IS NULL
            OR (UPPER (pit.part_no) LIKE UPPER ('%' || :p_product_code || '%')))
       AND ( :p_shop_code IS NULL OR (pit.contract = :p_shop_code))
       AND (   :p_product_description IS NULL
            OR (UPPER (pit.description) LIKE
                    UPPER ('%' || :p_product_description || '%')));