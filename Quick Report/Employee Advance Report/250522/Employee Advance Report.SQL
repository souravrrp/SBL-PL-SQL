select a.*
from
(select 
    'SBL' company,
    '&employee_id' emp_id,
    SUBSTRB(ifsapp.Supplier_Info_API.Get_Name('&employee_id'),1,100) emp_name,
    '' party_type,
    '' account_head,
    '' Contact,
    '' ledger_item_series_id,
    'Opening_Balance' notes,
    to_char(to_date('&from_date', 'YYYY/MM/DD'), 'YYYY/MM/DD') ledger_date,
    '' voucher_type,
    0 voucher_no,
    case when ifsapp.get_sbl_opening_balance('&employee_id', '10100200', to_date('&from_date', 'YYYY/MM/DD')) > 0
      then abs(ifsapp.get_sbl_opening_balance('&employee_id', '10100200', to_date('&from_date', 'YYYY/MM/DD')))
      else 0            
      end Debit,
    case when ifsapp.get_sbl_opening_balance('&employee_id', '10100200', to_date('&from_date', 'YYYY/MM/DD')) < 0
      then abs(ifsapp.get_sbl_opening_balance('&employee_id', '10100200', to_date('&from_date', 'YYYY/MM/DD')))
      else 0
      end Credit
from dual

union

select
    v.company,
    v.identity emp_id,
    v.emp_name,
    v.party_type,
    v.Account_Head,
    v.Contact,
    v.ledger_item_series_id,
    v.notes,
    to_char(v.ledger_date, 'YYYY/MM/DD') ledger_date,
    v.voucher_type,
    v.voucher_no voucher_no,
    v.Debit,
    v.Credit
from ifsapp.SBL_LEDGER_ITEMS v
where 
  v.identity like '&employee_id' and
  v.Account_Head = '10100200' and
  v.ledger_date between to_date('&from_date', 'YYYY/MM/DD') and to_date('&to_date', 'YYYY/MM/DD')) a
order by a.ledger_date