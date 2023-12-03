create or replace view sbl_return_info as
  select   r.order_no,
           r.contract,
           trunc(r.date_returned) date_returned
           --trunc(max(r.date_returned)) date_returned
  from     ifsapp.RETURN_MATERIAL_LINE_TAB r
  where    substr(r.order_no, 4, 2) = '-H' 
  and      r.order_no in (select h.account_no 
                          from   HPNRET_HP_DTL_TAB h
                          where  h.account_no = r.order_no 
                          and    h.ref_line_no = r.line_no 
                          and    h.ref_rel_no = r.rel_no
                          and    h.ref_line_item_no = r.line_item_no 
                          and    h.catalog_no = r.catalog_no 
                          and    h.reverted_date is null)
  group by r.order_no, r.contract, trunc(r.date_returned)
  order by r.order_no;
