--***** Sales Data Comparison between Live & Jasper Table (INV)
select t.invoice_id, t.item_id, t.c1, t.c2, t.c3
  from ifsapp.invoice_item_tab t, ifsapp.INVOICE_TAB i
 where t.invoice_id = i.invoice_id and
       t.creator = 'CUSTOMER_ORDER_INV_ITEM_API'
   and t.rowstate = 'Posted'
   and IFSAPP.SALES_PART_API.Get_Catalog_Type(T.C5) = 'INV'
   and t.c10 not in ('BSCP',
                     'BLSP',
                     'CLSP',
                     'CSCP',
                     'CXSP', --New Service Center
                     'DSCP',
                     'JSCP',
                     'KSCP', --New Service Center
                     'MSCP', --New Service Center   
                     'NSCP', --New Service Center
                     'RPSP', --New Service Center
                     'RSCP',
                     'SSCP',
                     'MS1C',
                     'MS2C',
                     'BTSC')
   and i.invoice_date between to_date('&from_date', 'YYYY/MM/DD') and
       to_date('&to_date', 'YYYY/MM/DD')

minus

select s.invoice_id, s.item_id, s.order_no, s.line_no, s.rel_no
  from IFSAPP.SBL_JR_SALES_DTL_INV s
 where s.sales_date between to_date('&from_date', 'YYYY/MM/DD') and to_date('&to_date', 'YYYY/MM/DD')

--***** Sales Data Comparison between Live & Jasper Table (All)
select t.invoice_id, t.c1
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
                     'KSCP', --New Service Center
                     'MSCP', --New Service Center   
                     'NSCP', --New Service Center
                     'RPSP', --New Service Center
                     'RSCP',
                     'SSCP',
                     'MS1C',
                     'MS2C',
                     'BTSC')
   and i.invoice_date between to_date('&from_date', 'YYYY/MM/DD') and
       to_date('&to_date', 'YYYY/MM/DD')
 group by t.invoice_id, t.c1

minus

select s.invoice_id, s.order_no
  from (select *
          from IFSAPP.SBL_JR_SALES_DTL_INV i
        union all
        select * from IFSAPP.SBL_JR_SALES_DTL_PKG_COMP c) s
 where s.sales_date between to_date('&from_date', 'YYYY/MM/DD') and
       to_date('&to_date', 'YYYY/MM/DD')
 group by s.invoice_id, s.order_no
 order by /*1,*/ 2

