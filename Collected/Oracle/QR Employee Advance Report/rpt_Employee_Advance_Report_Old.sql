select 
    --*
    'SBL' company,
    v.identity,
    SUBSTRB(Supplier_Info_API.Get_Name(v.identity),1,100) emp_name,
    '' party_type,
    '' account_head,
    '' Contact,
    '' ledger_item_series_id,
    'Opening_Balance' ncf_reference,
    '' ledger_date,
    '' voucher_type,
    0 voucher_no,
    case when sum(v.Debit) - sum(v.Credit) > 0
      then sum(v.Debit) - sum(v.Credit)
        else 0
          end Debit,
    case when sum(v.Debit) - sum(v.Credit) < 0
      then sum(v.Debit) - sum(v.Credit)
        else 0
          end Credit
from
(select
    --*
    l.company,
    l.identity,
    SUBSTRB(Supplier_Info_API.Get_Name(l.identity),1,100) emp_name,
    SUBSTRB(Party_Type_API.Decode(l.party_type),1,200) party_type,
    l.code_a Account_Head,
    l.code_b Contact,
    l.ledger_item_series_id,
    l.ncf_reference,
    to_char(i.invoice_date, 'YYYY/MM/DD') ledger_date,
    i.voucher_type_ref voucher_type,
    i.voucher_no_ref voucher_no,
    case when (l.full_curr_amount < 0 and SUBSTRB(Party_Type_API.Decode(l.party_type),1,200) = 'Supplier') or 
      (l.full_curr_amount >= 0 and SUBSTRB(Party_Type_API.Decode(l.party_type),1,200) = 'Customer') then abs(l.full_curr_amount)
        else 0 
          end Debit,
    case when (l.full_curr_amount >= 0 and SUBSTRB(Party_Type_API.Decode(l.party_type),1,200) = 'Supplier') or 
      (l.full_curr_amount < 0 and SUBSTRB(Party_Type_API.Decode(l.party_type),1,200) = 'Customer') then abs(l.full_curr_amount)
      else 0 
        end Credit
from 
  ledger_item_tab l,
  invoice_Tab i 
where 
  l.company = i.company and
  l.invoice_id = i.invoice_id and
  l.identity = i.identity and
  --i.invoice_date is not null and
  --l.party_type = 'SUPPLIER' and
  i.rowstate != 'Cancelled' and
  l.identity like '&employee_id' and
  l.code_a = '&account_head' and
  i.invoice_date < to_date('&from_date', 'YYYY/MM/DD')) v
group by v.identity

union

select
    --*
    l.company,
    l.identity,
    SUBSTRB(Supplier_Info_API.Get_Name(l.identity),1,100) emp_name,
    SUBSTRB(Party_Type_API.Decode(l.party_type),1,200) party_type,
    l.code_a Account_Head,
    l.code_b Contact,
    l.ledger_item_series_id,
    l.ncf_reference,
    to_char(i.invoice_date, 'YYYY/MM/DD') ledger_date,
    i.voucher_type_ref voucher_type,
    i.voucher_no_ref voucher_no,
    case when (l.full_curr_amount < 0 and SUBSTRB(Party_Type_API.Decode(l.party_type),1,200) = 'Supplier') or 
      (l.full_curr_amount >= 0 and SUBSTRB(Party_Type_API.Decode(l.party_type),1,200) = 'Customer') then abs(l.full_curr_amount)
        else 0 
          end Debit,
    case when (l.full_curr_amount >= 0 and SUBSTRB(Party_Type_API.Decode(l.party_type),1,200) = 'Supplier') or 
      (l.full_curr_amount < 0 and SUBSTRB(Party_Type_API.Decode(l.party_type),1,200) = 'Customer') then abs(l.full_curr_amount)
      else 0 
        end Credit
from 
  ledger_item_tab l,
  invoice_Tab i 
where 
  l.company = i.company and
  l.invoice_id = i.invoice_id and
  l.identity = i.identity and
  --i.invoice_date is not null and
  --l.party_type = 'SUPPLIER' and
  i.rowstate != 'Cancelled' and
  l.identity like '&employee_id' and
  l.code_a = '&account_head' and
  i.invoice_date between to_date('&from_date', 'YYYY/MM/DD') and to_date('&to_date', 'YYYY/MM/DD')
--order by i.invoice_date --l.ledger_item_series_id 
