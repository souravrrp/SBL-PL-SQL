-- GL Transaction Details
select *
  from IFSAPP.GL_AND_HOLD_VOU_ROW_QRY t
 where t.account = '10110010'
   and t.voucher_date between to_date('2018/2/1', 'YYYY/MM/DD') and
       to_date('2018/2/28', 'YYYY/MM/DD')
 order by t.voucher_type, t.voucher_no
