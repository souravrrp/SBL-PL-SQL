--Weekly Sales (National/Retail)
select to_char(i.invoice_date - 7 / 24, 'IYYY') "YEAR",
       to_char(i.invoice_date - 7 / 24, 'IW') WEEK,
       sum(case
             when t.net_curr_amount != 0 then
              t.n2 * (t.net_curr_amount / abs(t.net_curr_amount))
             else
              IFSAPP.GET_SBL_FREE_ITEM_SALES_QTN(t.invoice_id, t.item_id, T.N2) --t.n2
           end) SALES_QUANTITY,
       sum(t.net_curr_amount) SALES_PRICE
  from ifsapp.invoice_item_tab t, ifsapp.INVOICE_TAB i
 where t.invoice_id = i.invoice_id
   and t.creator = 'CUSTOMER_ORDER_INV_ITEM_API'
   and t.rowstate = 'Posted'
   and IFSAPP.SALES_PART_API.Get_Catalog_Type(T.C5) in ('INV', 'PKG')
   and t.c10 not in ('BSCP',
                     'BLSP',
                     'CLSP',
                     'CSCP',
                     'CXSP', --New Service Center
                     'DSCP',
                     'JSCP',
                     'MSCP',
                     'RPSP', --New Service Center
                     'RSCP',
                     'SSCP',
                     'MS1C',
                     'MS2C',
                     'BTSC') --Service Sites
      /*and t.c10 not in ('JWSS', 'SAOS', 'SWSS', 'WSMO') --Wholesale Sites
      and t.c10 not in
          ('SAPM', 'SCSM', 'SESM', 'SHOM', 'SISM', 'SFSM', 'SOSM')*/ --Corporate, Employee, & Scrap Sites
   and i.invoice_date between to_date('&from_date', 'yyyy/mm/dd') and
       to_date('&to_date', 'yyyy/mm/dd')
   and t.net_curr_amount != 0
 group by to_char(i.invoice_date - 7 / 24, 'IYYY'),
          to_char(i.invoice_date - 7 / 24, 'IW')
 order by to_number(to_char(i.invoice_date - 7 / 24, 'IYYY')),
          to_number(to_char(i.invoice_date - 7 / 24, 'IW'))
