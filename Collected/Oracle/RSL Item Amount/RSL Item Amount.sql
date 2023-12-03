select
    r.sequence_no,
    r.contract,
    to_char(r.from_date, 'YYYY/MM/DD') from_date,
    to_char(r.to_date, 'YYYY/MM/DD') to_date,
    i.rsl_item_description rsl_item,
    i.amount
from 
  HPNRET_RSL_ITEM i,
  HPNRET_RSL r
where 
  r.company = i.company and
  r.contract = i.contract and
  r.sequence_no = i.sequence_no and
  substr(r.sequence_no, 4, 3) = 'RSL' and
  i.rsl_item_description in ('Down Payment', 'Ext Warranty', 'Service Charge', 'Installment', 'Cash Sales', 
      'Sales Return', 'HP Penalty', 'Cash Penalty') and
  r.from_date between to_date('&from_date', 'YYYY/MM/DD') and to_date('&to_date', 'YYYY/MM/DD') and
  r.to_date between to_date('&from_date', 'YYYY/MM/DD') and to_date('&to_date', 'YYYY/MM/DD')
order by r.contract, r.sequence_no, r.from_date, r.to_date, i.rsl_item_description
