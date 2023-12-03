--*****Product Sales History
select t.c10 "SITE",
       t.c1  ORDER_NO,
       t.c2  LINE_NO,
       t.c3  REL_NO,
       case
         when t.net_curr_amount = 0 then
          ifsapp.GET_SBL_FREE_ISSUE_LINE_STATE(t.invoice_id, t.item_id, t.c1)
         else
          ifsapp.get_sbl_account_status(t.c1,
                                        t.c2,
                                        t.c3,
                                        t.c5,
                                        t.net_curr_amount,
                                        i.invoice_date)
       end status,
       to_char(i.invoice_date, 'YYYY/MM/DD') SALES_DATE,
       t.c5 PRODUCT_CODE,
       IFSAPP.INVENTORY_PRODUCT_CODE_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Code('SCOM',
                                                                                                         t.c5)) brand,
       decode(IFSAPP.SALES_PART_API.Get_Catalog_Type(T.C5),
              'PKG',
              ifsapp.INVENTORY_PRODUCT_FAMILY_API.Get_Description(ifsapp.sales_part_api.Get_Part_Product_Family('SCOM',
                                                                                                                t.c5)),
              ifsapp.INVENTORY_PRODUCT_FAMILY_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Family('SCOM',
                                                                                                                    t.c5))) product_family,
       case
         when t.net_curr_amount != 0 then
          t.n2 * (t.net_curr_amount / abs(t.net_curr_amount))
         else
          IFSAPP.GET_SBL_FREE_ITEM_SALES_QTN(t.invoice_id, t.item_id, T.N2) --t.n2
       end SALES_QUANTITY,
       t.net_curr_amount SALES_PRICE,
       t.vat_code,
       t.vat_curr_amount VAT,
       (t.net_curr_amount + t.vat_curr_amount) "RSP",
       i.pay_term_id,
       t.identity CUSTOMER_NO,
       ifsapp.customer_info_api.Get_Name(t.identity) CUSTOMER_NAME,
       ifsapp.CUSTOMER_INFO_COMM_METHOD_API.Get_Any_Phone_No(t.identity) phone_no,
       IFSAPP.CUSTOMER_INFO_ADDRESS_API.Get_Address1(t.identity, 1) || ' ' ||
       IFSAPP.CUSTOMER_INFO_ADDRESS_API.Get_Address2(t.identity, 1) customer_address
  from ifsapp.invoice_item_tab t, ifsapp.INVOICE_TAB i
 where t.invoice_id = i.invoice_id
   and t.creator = 'CUSTOMER_ORDER_INV_ITEM_API'
   and t.rowstate = 'Posted'
   and IFSAPP.SALES_PART_API.Get_Catalog_Type(T.C5) in ('INV' /*, 'PKG'*/)
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
   and t.c10 not in ('JWSS', 'SAOS', 'SWSS', 'WSMO') --Wholesale Sites
   and t.c10 not in
       ('SAPM', 'SCSM', 'SESM', 'SHOM', 'SISM', 'SFSM', 'SOSM') --Corporate, Employee, & Scrap Sites
   /*and i.invoice_date between to_date('&from_date', 'yyyy/mm/dd') and
       to_date('&to_date', 'yyyy/mm/dd')*/
   and t.net_curr_amount != 0
   and /*decode(IFSAPP.SALES_PART_API.Get_Catalog_Type(T.C5),
              'PKG',
              ifsapp.INVENTORY_PRODUCT_FAMILY_API.Get_Description(ifsapp.sales_part_api.Get_Part_Product_Family('SCOM',
                                                                                                                t.c5)),*/
              ifsapp.INVENTORY_PRODUCT_FAMILY_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Family('SCOM',
                                                                                                                    t.c5))/*)*/ in
       ('AIR-CONDITIONER', 'AIR-COOLER')
   and ifsapp.get_sbl_account_status(t.c1,
                                     t.c2,
                                     t.c3,
                                     t.c5,
                                     t.net_curr_amount,
                                     i.invoice_date) in
       ('HireSale',
        'CashSale',
        'Returned',
        'ReturnCompleted'/*,
        'ReturnAfterCashConv',
        'ExchangedIn',
        'PositiveExchangedIn'*/)
 order by 6, 2, 3, 4
