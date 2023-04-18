/* Formatted on 3/9/2023 10:21:50 AM (QP5 v5.381) */
WITH
    tab_a AS (SELECT * FROM table_a),
    tab_b AS (SELECT * FROM table_b)
SELECT *
  FROM tab_a ta, tab_b tb
 WHERE ta.col = tb.col;