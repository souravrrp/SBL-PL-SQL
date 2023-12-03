select
    v.area, 
    v.district, 
    v.site, 
    v.site_description, 
    v.book_no,
    v.sheet_serial_no, 
    v.price,
    v.customer_id, 
    v.Cust_Name, 
    v.hpnret_other_pay_type,  
    v.state, 
    to_char(v.date_created, 'YYYY/MM/DD') date_created,
    to_char(v.expiry_date, 'YYYY/MM/DD') expiry_date
from sbl_vw_586_advance v
where 
  UPPER(v.State) = UPPER('Created') AND 
  v.site LIKE '&Site' AND
  v.date_created <= to_date('&as_on_date','YYYY/MM/DD')
