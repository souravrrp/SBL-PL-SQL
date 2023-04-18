select
*
from
ifsapp.order_coordinator_tab oct
WHERE 1=1
AND (:p_user_id IS NULL OR (UPPER(oct.authorize_code) LIKE UPPER('%'||:p_user_id||'%') ));

--------------------------------------------------------------------------------


select
*
from
ifsapp.order_coordinator oc
WHERE 1=1
AND (:p_user_id IS NULL OR (UPPER(oc.authorize_code) LIKE UPPER('%'||:p_user_id||'%') ));


--------------------------Package-----------------------------------------------

IFSAPP.ORDER_COORDINATOR_API