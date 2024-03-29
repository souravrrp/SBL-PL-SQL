-- Gift Voucher Sales
select a.contract,
       a.series_no,
       a.sheet_serial_no,
       a.create_date,
       a.expiry_date,
       a.dom_amount,
       a.book_no,
       a.customer_id,
       a.account_code,
       a.salesman_code,
       a.rowstate
  from IFSAPP.HPNRET_ADV_PAY_TAB a
 where a.account_code = 'GV'
   and a.create_date between to_date('&from_date', 'YYYY/MM/DD') and
       to_date('&to_date', 'YYYY/MM/DD')
   and a.rowstate = 'Approved' /*t.series_no = 'KHL-G7297'*/
 order by a.contract, a.series_no
