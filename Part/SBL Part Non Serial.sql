/* Formatted on 3/20/2023 10:20:43 AM (QP5 v5.381) */
SELECT order_no,
       line_no,
       rel_no,
       line_item_no,
       hnsrt.*
  FROM ifsapp.hpnret_non_serial_res_tab hnsrt
 WHERE     1 = 1
       --AND ref_no = ref_no_
       AND (   :p_part_no IS NULL
            OR (UPPER (hnsrt.catalog_no) LIKE
                    UPPER ('%' || :p_part_no || '%')))
       AND expired = 'FALSE';