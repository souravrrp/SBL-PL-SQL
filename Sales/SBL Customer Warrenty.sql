/* Formatted on 10/18/2023 4:12:28 PM (QP5 v5.381) */
SELECT * FROM cust_warranty_condition_tab;

  SELECT COUNT (WARRANTY_ID) WWW, WT.warranty_id,WARRANTY_DESCRIPTION,PART_NO
    FROM cust_warranty_TYPE_TAB WT, ifsapp.inventory_part i
   WHERE i.cust_warranty_id = WT.warranty_id
GROUP BY WT.warranty_id,WARRANTY_DESCRIPTION,PART_NO
  HAVING COUNT (WARRANTY_ID) > 1
  
  ;
  select
  *
  from
  ifsapp.inventory_part i
  where 1=1
  and i.cust_warranty_id='7355673'
  and CONTRACT='SCOM';
  
  /* Formatted on 10/18/2023 4:00:53 PM (QP5 v5.381) */
SELECT i.part_no,
       p.product_family,
       c.warranty_type_id     warranty_template,
       ifsapp.warranty_condition_api.Get_Condition_Description (
           c.condition_id)    warranty,c.*
  FROM ifsapp.inventory_part  i
       JOIN ifsapp.cust_warranty_condition c
           ON i.cust_warranty_id = c.warranty_id
       JOIN ifsapp.sbl_jr_product_dtl_info p ON i.part_no = p.product_code
 WHERE     i.contract = 'SCOM'
       AND p.product_family = 'COMPUTER-LAPTOP'
       AND i.part_no = 'HPCOM-DA0004TU'