/* Formatted on 2/22/2023 9:53:57 AM (QP5 v5.381) */
SELECT whi.ware_house_name, whi.description
  FROM ifsapp.ware_house_info whi
 WHERE 1=1
 and (:p_warehouse_code is null or (whi.ware_house_name = :p_warehouse_code))
 AND (   :p_ware_house_name IS NULL OR (UPPER (whi.description) LIKE UPPER ('%' || :p_ware_house_name || '%')))
 ;

--------------------------------------------------------------------------------
SELECT w.ware_house_name, w.description
  FROM ifsapp.ware_house_info w
 WHERE w.ware_house_name LIKE '%WW'