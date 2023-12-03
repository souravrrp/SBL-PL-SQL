select
    --*
    l.company,
    l.identity,
    l.name,
    l.party_type,
    li.code_a Account_Head,
    li.code_b Contact,
    l.ledger_item_series_id,
    l.ncf_reference,
    l.ledger_date,
    l.voucher_type,
    l.voucher_no,
    case when l.inv_amount < 0 then l.inv_amount
      else 0 
        end Debit,
    case when l.inv_amount > 0 then l.inv_amount
      else 0 
        end Credit,
    l.open_amount,
    li.rowtype  
from 
  LEDGER_ITEM_SU_QRY l,
  LEDGER_ITEM_TAB li
where 
  --l.company = li.company and
  l.identity = li.identity and
  l.ledger_date is not null and
  l.identity like '&employee_id' and
  li.code_a = '&account_head'
order by l.ledger_date --l.ledger_item_series_id
