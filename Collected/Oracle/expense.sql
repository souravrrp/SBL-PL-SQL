select * from SITE_EXPENSES_TAB t
where t.contract = 'DUTB' and
t.statement_date >= to_date('1/1/2014', 'MM/DD/YYYY')
