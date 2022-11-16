/* Formatted on 10/12/2022 12:00:17 PM (QP5 v5.381) */
SELECT *
  FROM DUAL
 WHERE     1 = 1
       AND ( :p_number IS NULL OR (num = :p_number))
       AND (   :p_name IS NULL
            OR (UPPER (name) LIKE UPPER ('%' || :p_name || '%')))
       AND TRUNC (date) BETWEEN NVL ( :p_date_from, TRUNC (date))
                            AND NVL ( :p_date_to, TRUNC (date));