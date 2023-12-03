select * from  ifsapp.site_expenses_detail_tab ed
where ed.lump_sum_trans_date between to_date('2014/11/1', 'YYYY/MM/DD') and to_date('2014/11/30', 'YYYY/MM/DD')

select * from ifsapp.site_expenses_tab s
where s.statement_date between to_date('2014/11/1', 'YYYY/MM/DD') AND to_date('2014/12/2', 'YYYY/MM/DD')
