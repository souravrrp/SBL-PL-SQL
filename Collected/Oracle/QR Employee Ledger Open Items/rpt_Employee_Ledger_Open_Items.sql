select U.IDENTITY,
       U.PARTY_NAME,
       U.LEDGER_ITEM_SERIES_ID,
       U.ledger_item_id,
       U.REST_AMOUNT,
       U.DUE_DATE,
       U.code_a ACCOUNT_HEAD,
       U.code_b CONTRACT,
       U.OBJSTATE
from   IFSAPP.LEDGER_ITEM3_EMU U
where  U.IDENTITY like '&EMP_ID'--'W00%'
and    U.due_date BETWEEN TO_DATE('&FROM_DATE', 'YYYY/MM/DD') AND TO_DATE('&TO_DATE', 'YYYY/MM/DD')
AND    U.code_a LIKE '&ACCOUNT_HEAD'
ORDER BY U.due_date
