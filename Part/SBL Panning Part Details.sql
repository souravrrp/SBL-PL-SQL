/* Formatted on 4/3/2023 10:24:34 AM (QP5 v5.381) */
SELECT ipt.part_no,
       ipt.type_code,
       ippt.mrp_order_code,
       ipt.lead_time_code,
       ipt.manuf_leadtime,
       ipt.purch_leadtime
  FROM ifsapp.inventory_part_tab ipt, ifsapp.inventory_part_planning_tab ippt
 WHERE     1 = 1
       AND ipt.part_no = ippt.part_no
       --AND ippt.mrp_order_code IN ('B', 'C')
       AND ipt.contract = ippt.contract
       AND TRUNC (ippt.rowversion) BETWEEN NVL ( :p_date_from,
                                                TRUNC (ippt.rowversion))
                                       AND NVL ( :p_date_to,
                                                TRUNC (ippt.rowversion));