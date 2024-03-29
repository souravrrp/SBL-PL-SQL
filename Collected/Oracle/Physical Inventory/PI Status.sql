select count(distinct(t.shop_code)) from SBL_SHOP_ARRPOVE_TBL t

select count(t1.site) from SBL_USER_LIST t1
where t1.user_id != 'E10206'
and t1.date_of_count <= to_date('2015/11/3', 'yyyy/mm/dd')

select *
from SBL_USER_LIST t1
where t1.user_id != 'E10206'
and t1.date_of_count <= to_date('2015/11/3', 'yyyy/mm/dd')
and t1.site not in (select distinct(t.shop_code) from SBL_SHOP_ARRPOVE_TBL t)
order by t1.date_of_count, t1.site

select * from SBL_SHOP_ARRPOVE_TBL t
order by t.approve_date desc
