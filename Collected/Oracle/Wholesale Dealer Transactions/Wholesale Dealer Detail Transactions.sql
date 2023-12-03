--Customer Orders, Returns, Collections & Advances
select c.identity dealer_id,
       IFSAPP.CUSTOMER_INFO_API.Get_Name(c.identity) dealer_name,
       c.party_type,
       c.ledger_item_series_id,
       c.ledger_item_id,
       c.ledger_item_version,
       c.invoice_id,
       c.ledger_date,
       c.voucher_no,
       c.voucher_type,
       c.inv_amount,
       c.open_amount,
       c.fully_paid,
       c.way_id,
       c.note,
       '' objstate
  from ifsapp.LEDGER_ITEM_CU_DET_QRY c
 where c.identity = '&dealer_id'
   and c.ledger_item_series_id in
       ('CD', 'CR', 'WSADV', 'SI', 'CF', 'CI', 'EX', 'TRADV', 'WSADVRF')
   and c.ledger_date between to_date('&from_date', 'YYYY/MM/DD') and
       to_date('&to_date', 'YYYY/MM/DD')

union all

--Supplier Invoices
select s.identity dealer_id,
       IFSAPP.SUPPLIER_INFO_API.Get_Name(s.identity) dealer_name,
       s.party_type,
       s.ledger_item_series_id,
       s.ledger_item_id,
       s.ledger_item_version,
       s.invoice_id,
       nvl(s.ledger_date, s.due_date) ledger_date,
       s.voucher_no,
       s.voucher_type,
       decode(s.open_amount, 0, s.inv_amount * (-1), s.inv_amount) inv_amount,
       s.open_amount,
       s.fully_paid,
       s.way_id,
       s.ncf_reference,
       s.objstate
  from ifsapp.LEDGER_ITEM_SU_QRY s
 where s.identity like '&dealer_id'
   and s.ledger_item_series_id in
       (/*'CD', 'CR', 'WSADV',*/ 'SI'/*, 'CF', 'CI', 'EX', 'TRADV', 'WSADVRF'*/)
   and s.objstate != 'Cancelled'
   and nvl(s.ledger_date, s.due_date) between
       to_date('&from_date', 'YYYY/MM/DD') and
       to_date('&to_date', 'YYYY/MM/DD')
 order by 8
