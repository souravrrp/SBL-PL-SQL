select t.*, t.rowid from HPNRET_HP_HEAD_TAB t
where t.rowstate = 'Invoiced'
order by t.account_no;

/*
update HPNRET_HP_HEAD_TAB t
set t.rowstate = 'Active'
where t.rowstate = 'Invoiced';
commit;
*/