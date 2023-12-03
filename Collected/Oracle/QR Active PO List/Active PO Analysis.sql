--
select * from IFSAPP.PURCHASE_ORDER_TAB p where p.order_no = 'A-29950882';

--
select *
  from IFSAPP.purchase_order_line_tab l
 where l.order_no = 'A-29950882'; --A-29951669

--
select *
  from IFSAPP.purchase_order_line_tab l
 where l.purchase_modified = 'Internal'
   and substr(l.order_no, 1, 2) != 'A-';

--
select distinct p.rowstate
  from IFSAPP.PURCHASE_ORDER_TAB p
 order by p.rowstate;

--
select distinct l.rowstate
  from IFSAPP.purchase_order_line_tab l
 order by l.rowstate;

--
select substr(p.order_no, 1, 2)
  from IFSAPP.PURCHASE_ORDER_TAB p
 where substr(p.order_no, 2, 1) = '-'
 group by substr(p.order_no, 1, 2)
 order by substr(p.order_no, 1, 2);

--
select p.order_date, p.rowstate, l.*
  from IFSAPP.PURCHASE_ORDER_TAB p
 inner join IFSAPP.purchase_order_line_tab l
    on p.order_no = l.order_no
 where l.rowstate = 'Closed'
   and p.rowstate not in ('Closed', 'Cancelled')
 order by p.order_date desc;

--
select *
  from USER_ALLOWED_SITE_TAB a
 where a.userid = 'MANNAN1004'; --ifsapp.fnd_session_api.Get_Fnd_User

--
select *
  from IFSAPP.FND_USER u
 where u.active = 'TRUE'
 and u.description like '%Man%'
 order by u.identity;
