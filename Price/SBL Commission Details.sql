/* Formatted on 4/3/2023 9:57:37 AM (QP5 v5.381) */
SELECT ROW_NUMBER ()
           OVER (PARTITION BY calt.catalog_no ORDER BY calt.valid_from DESC)
           row_num,
       (CASE
            WHEN     calt.agreement_id = 'SP_SC_RTL'
                 AND calt.commission_sales_type = 'CASH'
            THEN
                'Cash Commission'
            WHEN     calt.agreement_id = 'SP_SC_RTL'
                 AND calt.commission_sales_type = 'HP'
            THEN
                'HP Commission'
            ELSE
                'Others'
        END)
           commission_sales_tye,
       calt.*
  FROM ifsapp.commission_agree_line_tab calt
 WHERE     1 = 1
       --AND calt.agreement_id = 'SP_SC_RTL'
       --AND calt.commission_sales_type = 'CASH' --HP
       AND calt.location_no = 'NORMAL'
       AND TRUNC (SYSDATE) BETWEEN calt.valid_from AND calt.valid_to
       AND calt.catalog_no = NVL ( :p_price_list_no, calt.catalog_no);