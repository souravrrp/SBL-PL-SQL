select v2.ORDER_NO,
min(v2.first_status)
from 
(select v.ORDER_NO,
       /*v.LINE_NO,
       v.REL_NO,
       v.status,
       v.SALES_DATE,
       v.PRODUCT_CODE,
       v.SALES_QUANTITY,
       v.SALES_PRICE,*/
       first_value(v.status) over(partition by v.ORDER_NO order by v.LINE_NO, v.REL_NO asc 
                             range between unbounded preceding and unbounded following) as first_status
  from (select t.c10 "SITE",
               t.c1 ORDER_NO,
               t.c2 LINE_NO,
               t.c3 REL_NO,
               ifsapp.get_sbl_account_status(t.c1,
                                             t.c2,
                                             t.c3,
                                             t.c5,
                                             t.net_curr_amount,
                                             i.invoice_date) status,
               to_char(i.invoice_date, 'YYYY/MM/DD') SALES_DATE,
               t.c5 PRODUCT_CODE,
               case
                 when t.net_curr_amount != 0 then
                  t.n2 * (t.net_curr_amount / abs(t.net_curr_amount))
                 else
                  IFSAPP.GET_SBL_FREE_ITEM_SALES_QTN(t.invoice_id,
                                                     t.item_id,
                                                     T.N2) --t.n2
               end SALES_QUANTITY,
               t.net_curr_amount SALES_PRICE,
               t.vat_curr_amount VAT,
               (t.net_curr_amount + t.vat_curr_amount) "RSP"
          from ifsapp.invoice_item_tab t, ifsapp.INVOICE_TAB i
         where t.invoice_id = i.invoice_id
           and t.creator = 'CUSTOMER_ORDER_INV_ITEM_API'
           and t.rowstate = 'Posted'
           and IFSAPP.SALES_PART_API.Get_Catalog_Type(T.C5) in
               ('INV', 'PKG')
           and t.c10 not in ('BSCP',
                             'BLSP',
                             'CLSP', --New Service Center
                             'CSCP',
                             'DSCP',
                             'JSCP',
                             'RSCP',
                             'SSCP',
                             'MS1C',
                             'MS2C',
                             'BTSC') --Service Sites
           and t.c10 not in ('JWSS', 'SAOS', 'SWSS', 'WSMO') --Wholesale Sites
           and t.c10 not in
               ('SAPM', 'SCSM', 'SESM', 'SHOM', 'SISM', 'SFSM', 'SOSM') --Corporate, Employee, & Scrap Sites
           and i.invoice_date between to_date('&from_date', 'yyyy/mm/dd') and
               to_date('&to_date', 'yyyy/mm/dd')
           and t.net_curr_amount < 0
         order by 2) v
         /*where v.order_no = 'ANW-H3685'*/) v2
         group by v2.order_no
