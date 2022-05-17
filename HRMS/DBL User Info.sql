/* Formatted on 3/22/2022 11:50:15 AM (QP5 v5.381) */
select 
       web_user,
       oracle_user,
       identity,
       description,
       objversion,
       active,
       objid
  --,FU.*
  from fnd_user fu
 where 1 = 1 and (( :p_emp_id is null) or (oracle_user = :p_emp_id));