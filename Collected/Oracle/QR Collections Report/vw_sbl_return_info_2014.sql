create or replace view sbl_return_info_2014 as
  select   r.order_no,
           r.contract,
           trunc(r.date_returned) date_returned
           --trunc(max(r.date_returned)) date_returned
  from     ifsapp.RETURN_MATERIAL_LINE_TAB r,
           ifsapp.HPNRET_HP_DTL_TAB h
  where    h.account_no = r.order_no
  and      h.ref_line_no = r.line_no 
  and      h.ref_rel_no = r.rel_no
  and      h.ref_line_item_no = r.line_item_no 
  and      h.catalog_no = r.catalog_no
  and      substr(r.order_no, 4, 2) = '-H' 
  and      h.reverted_date is null
  and      trunc(r.date_returned) between to_date('2014/1/1', 'YYYY/MM/DD') and to_date('2014/12/31', 'YYYY/MM/DD')
  group by r.order_no, r.contract, trunc(r.date_returned)
  order by r.order_no;
