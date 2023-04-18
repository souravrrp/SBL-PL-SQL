/* Formatted on 4/3/2023 10:03:43 AM (QP5 v5.381) */
SELECT pit.part_no
           product_code,
       ifsapp.inventory_part_api.Get_Description (pit.contract, pit.part_no)
           part_description,
       second_commodity,
       pit.*
  FROM ifsapp.inventory_part_tab pit
 WHERE     1 = 1
       AND (   :p_product_code IS NULL
            OR (UPPER (pit.part_no) LIKE
                    UPPER ('%' || :p_product_code || '%')));

SELECT *
  FROM ifsapp.inventory_part pi;


SELECT *
  FROM ifsapp.sbl_jr_product_dtl_info p;

-----------------------------------Sales Part-----------------------------------

SELECT * FROM ifsapp.sales_part_tab;

SELECT * FROM ifsapp.sales_part;

-----------------------------------Panning Part-----------------------------------

/* Formatted on 4/3/2023 10:24:11 AM (QP5 v5.381) */
SELECT *
  FROM ifsapp.inventory_part_planning_tab ippt
 WHERE     1 = 1
       AND TRUNC (ippt.rowversion) BETWEEN NVL ( :p_date_from,
                                                TRUNC (ippt.rowversion))
                                       AND NVL ( :p_date_to,
                                                TRUNC (ippt.rowversion));

-----------------------------------API------------------------------------------
--ifsapp.inventory_part_api
--ifsapp.sales_part_api
