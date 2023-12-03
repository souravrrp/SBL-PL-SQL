-- Order No against Voucher No
select i.voucher_type_ref, i.voucher_no_ref, t.c1 order_no
  from ifsapp.invoice_item_tab t, ifsapp.INVOICE_TAB i
 where t.invoice_id = i.invoice_id
   and t.c1 is not null
   and i.voucher_type_ref = 'F'
   and i.voucher_no_ref in ('1900062236',
                            '1900105160',
                            '1900187075',
                            '1900241104',
                            '1900246127',
                            '1900270991')
 group by i.voucher_type_ref, i.voucher_no_ref, t.c1
 order by i.voucher_type_ref, i.voucher_no_ref, t.c1
