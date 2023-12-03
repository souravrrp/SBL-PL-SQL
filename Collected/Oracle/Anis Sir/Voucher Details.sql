select * from GL_AND_HOLD_VOU_ROW_QRY g
where g.accounting_year = 2015
and g.accounting_period = 11
and g.account = '10100020'
order by g.voucher_no
