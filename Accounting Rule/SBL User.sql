/* Formatted on 3/1/2023 8:53:56 AM (QP5 v5.381) */

select *
FROM   user_finance_tab uft
 where 1 = 1
 --AND ( :p_user_id IS NULL OR (uft.userid = :p_user_id))
 AND (:p_user_id IS NULL OR (UPPER(uft.userid) LIKE UPPER('%'||:p_user_id||'%') ));

--------------------------------------------------------------------------------

select *
FROM   user_finance_tab
 where 1 = 1;
 
 
--------------------------------------------------------------------------------
select *
  from ifsapp.user_finance
 where 1 = 1;