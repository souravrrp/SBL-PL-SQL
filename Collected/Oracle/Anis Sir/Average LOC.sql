--Average LOC Calcultation
select v.status, v.length_of_contract, sum(v.SALES_PRICE) total_SALES_PRICE
  from (select ifsapp.get_sbl_account_status(t.c1,
                                             t.c2,
                                             t.c3,
                                             t.c5,
                                             t.net_curr_amount,
                                             i.invoice_date) status,
               (select hd.length_of_contract
                  from HPNRET_HP_HEAD_TAB hd
                 where hd.account_no = t.c1) length_of_contract,
               t.net_curr_amount SALES_PRICE
          from ifsapp.invoice_item_tab t, ifsapp.INVOICE_TAB i
         where t.invoice_id = i.invoice_id
           and t.creator = 'CUSTOMER_ORDER_INV_ITEM_API'
           and t.rowstate = 'Posted'
           and IFSAPP.SALES_PART_API.Get_Catalog_Type(T.C5) in
               ('INV', 'PKG', 'NON')
           and t.c10 not in ('BSCP',
                             'BLSP',
                             'CLSP',
                             'CSCP',
                             'CXSP',
                             'DSCP',
                             'FSCP', --New Service Center
                             'JSCP',
                             'KSCP',
                             'MSCP',
                             'NSCP',
                             'RSCP',
                             'RPSP',
                             'SSCP',
                             'MS1C',
                             'MS2C',
                             'BTSC') --Service Sites
           and t.c10 not in ('JWSS', 'SAOS', 'SWSS', 'WSMO', 'SITM', 'SSAM', 'WITM') --Wholesale Sites
           and t.c10 not in ('SAPM', 'SCOM', 'SCSM', 'SESM', 'SHOM', 'SISM', 'SFSM', 'SOSM') --Corporate, Employee, & Scrap Sites
           and i.invoice_date between to_date('&from_date', 'yyyy/mm/dd') and
               to_date('&to_date', 'yyyy/mm/dd')
           and t.net_curr_amount != 0
              --and substr(t.c1, 4, 2) = '-H'
           and ifsapp.get_sbl_account_status(t.c1,
                                             t.c2,
                                             t.c3,
                                             t.c5,
                                             t.net_curr_amount,
                                             i.invoice_date) = ('HireSale')) v --in('CashSale', 'ReturnCompleted', 'Returned')
 group by v.status, v.length_of_contract
 order by v.length_of_contract
