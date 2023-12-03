select li.company,
  li.identity,
  li.party_type,
  li.ledger_item_series_id,
  li.ledger_item_id,
  li.full_curr_amount,
  li.cleared_curr_amount,
  li.full_curr_amount - li.cleared_curr_amount "Open Amount",
  li.currency,
  li.curr_rate,
  li.status_id,
  li.code_a,
  li.rowstate
from LEDGER_ITEM_TAB li
WHERE --li.IDENTITY = 'E10018' AND
  li.CODE_A = '10100200' AND
  li.party_type = 'CUSTOMER' and
  li.ROWSTATE IN ('Unpaid', 'PartlyPaid')
  
select * from payment_plan_tab pp
where pp.identity = 'E10018'

SELECT * from SUP_OPEN_ITEM_NAMES_RPT

select * from CUST_OPEN_ITEM_NAMES_RPT
