/* Formatted on 8/30/2022 12:44:13 PM (QP5 v5.381) */
SELECT *
  FROM ifsapp.commission_receiver
 WHERE     commission_receiver_group IN ('SH_DSA', 'SP_SHOP')
       --AND com_receiver_status_db = 'ACTIVE'
       AND com_receiver_status = 'Active';