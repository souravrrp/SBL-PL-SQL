/* Formatted on 2/22/2023 9:53:57 AM (QP5 v5.381) */
SELECT w.ware_house_name, w.description
  FROM ifsapp.ware_house_info w
 WHERE 1=1
 and (:p_ware_house_name is null or (W.ware_house_name = :p_ware_house_name));

--------------------------------------------------------------------------------
SELECT w.ware_house_name, w.description
  FROM ifsapp.ware_house_info w
 WHERE w.ware_house_name LIKE '%WW'