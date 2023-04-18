SELECT *
  FROM ifsapp.serial_oem_conn_tab soct
  where 1=1
  AND (:p_part_no IS NULL OR (UPPER(soct.part_no) LIKE UPPER('%'||:p_part_no||'%')));

--------------------------------------------------------------------------------

--ifsapp.serial_oem_conn_api