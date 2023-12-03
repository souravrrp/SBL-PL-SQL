select i.invoice_date SALES_DATE,
       sum(t.net_curr_amount) SALES_PRICE,
       sum(t.vat_curr_amount) VAT,
       sum(t.net_curr_amount + t.vat_curr_amount) "RSP"
  from ifsapp.invoice_item_tab t, ifsapp.INVOICE_TAB i
 where t.invoice_id = i.invoice_id
   and t.creator = 'CUSTOMER_ORDER_INV_ITEM_API'
   and t.rowstate = 'Posted'
   and IFSAPP.SALES_PART_API.Get_Catalog_Type(T.C5) in ('INV', 'PKG')
   and t.c10 not in ('BSCP',
                     'BLSP',
                     'CLSP',
                     'CSCP',
                     'CXSP',
                     'DSCP',
                     'JSCP',
                     'KSCP', --New Service Center
                     'MSCP',
                     'NSCP', --New Service Center
                     'RPSP',
                     'RSCP',
                     'SSCP',
                     'MS1C',
                     'MS2C',
                     'BTSC') --Service Sites
      /*and t.c10 not in ('JWSS', 'SAOS', 'SWSS', 'WSMO') --Wholesale Sites
      and t.c10 not in
          ('SAPM', 'SCSM', 'SESM', 'SHOM', 'SISM', 'SFSM', 'SOSM', 'SITM')*/ --Corporate, Employee, & Scrap Sites
   and i.invoice_date between to_date('&from_date', 'yyyy/mm/dd') and
       to_date('&to_date', 'yyyy/mm/dd')
/*and t.net_curr_amount != 0*/
/*and t.c10 = \*'IBRD'*\ 'DITF'*/
/*and t.c1 = '&ACCT_NO'*/
/*and IFSAPP.INVENTORY_PRODUCT_CODE_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Code(t.c10,
                                                                                                         t.c5)) = 'V-GUARD'*/
/*and t.c5 LIKE '%12L78%'*/ /*'SRAC-%'*/ --'SRBAT-HPD-100T'
/*and ifsapp.get_sbl_account_status(t.c1,
                              t.c2,
                              t.c3,
                              t.c5,
                              t.net_curr_amount,
                              i.invoice_date) in
('HireSale',
 'CashSale',
 'Returned',
 'ReturnCompleted',
 'ReturnAfterCashConv',
 'ExchangedIn',
 'PositiveExchangedIn')*/
 group by i.invoice_date
 order by 1
