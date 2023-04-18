/* Formatted on 3/19/2023 11:17:38 AM (QP5 v5.381) */
SELECT *
  FROM ifsapp.trn_trip_plan_tab ttpt, ifsapp.trn_trip_plan_co_line_tab ttpclt
 WHERE     1 = 1
       AND ttpt.trip_no = ttpclt.trip_no
       AND ttpt.release_no = ttpclt.release_no;

--------------------------------------------------------------------------------

SELECT *
  FROM ifsapp.trn_trip_plan_tab ttpt
 WHERE 1 = 1;

SELECT *
  FROM ifsapp.trn_trip_plan_co_line_tab ttpclt
 WHERE 1 = 1 AND ( :p_order_no IS NULL OR (ttpclt.order_no = :p_order_no));