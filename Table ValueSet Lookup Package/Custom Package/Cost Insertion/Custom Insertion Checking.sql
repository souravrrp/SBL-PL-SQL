/* Formatted on 2/26/2023 4:08:46 PM (QP5 v5.381) */
SELECT *
  FROM ifsapp.sbl_fin_item_cost_upld sficu;

DELETE ifsapp.sbl_fin_item_cost_upld;

SELECT *
  FROM ifsapp.sbl_fin_item_cost sfic;
  
  DELETE ifsapp.sbl_fin_item_cost;

SELECT MAX (cost_id)
  FROM ifsapp.sbl_fin_item_cost sfic;

 EXECUTE ifsapp.sbl_fin_item_cost_pkg.update_item_cost;


UPDATE ifsapp.sbl_fin_item_cost sfic
   SET sfic.end_date = NVL (cur_update_cost.END_DATE, SYSDATE - 1)
 WHERE sfic.part_no = cur_update_cost.part_no AND sfic.end_date IS NULL;