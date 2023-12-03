select t.c10 "SITE",
       (select s.area_code
          from ifsapp.SHOP_DTS_INFO s
         where s.shop_code = t.c10) area_code,
       (select s.district_code
          from ifsapp.SHOP_DTS_INFO s
         where s.shop_code = t.c10) district_code,
       t.c1 ORDER_NO,
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
       t.c2 LINE_NO,
       t.c3 REL_NO,
       to_char(i.invoice_date, 'YYYY/MM/DD') SALES_DATE,
       t.c5 PRODUCT_CODE,
       IFSAPP.INVENTORY_PRODUCT_CODE_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Code(t.c10,
                                                                                                         t.c5)) brand,
       decode(IFSAPP.SALES_PART_API.Get_Catalog_Type(T.C5),
              'PKG',
              ifsapp.INVENTORY_PRODUCT_FAMILY_API.Get_Description(ifsapp.sales_part_api.Get_Part_Product_Family(t.c10,
                                                                                                                t.c5)),
              ifsapp.INVENTORY_PRODUCT_FAMILY_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Family(t.c10,
                                                                                                                    t.c5))) product_family,
       decode(IFSAPP.SALES_PART_API.Get_Catalog_Type(T.C5),
              'PKG',
              IFSAPP.SALES_GROUP_API.Get_Description(IFSAPP.SALES_PART_API.Get_Catalog_Group(t.c10,
                                                                                             t.c5)),
              IFSAPP.COMMODITY_GROUP_API.Get_Description(IFSAPP.INVENTORY_PART_API.Get_Second_Commodity(t.c10,
                                                                                                        t.c5))) commodity_group2,
       IFSAPP.SALES_GROUP_API.Get_Description(IFSAPP.SALES_PART_API.Get_Catalog_Group(t.c10,
                                                                                      t.c5)) sales_group,
       /*(select g.product_group
          from ifsapp.product_category_info p
         inner join ifsapp.product_info g
            on p.group_no = g.group_no
         where p.product_code = t.c5) product_group,*/
       case
         when t.net_curr_amount != 0 then
          t.n2 * (t.net_curr_amount / abs(t.net_curr_amount))
         else
          IFSAPP.GET_SBL_FREE_ITEM_SALES_QTN(t.invoice_id, t.item_id, T.N2) --t.n2
       end SALES_QUANTITY,
       case
         when t.net_curr_amount < 0 and t.n1 = 0 then
           (select l.base_sale_unit_price
             from IFSAPP.CUSTOMER_ORDER_LINE l
            where l.order_no = t.c1
              and l.line_no = t.c2
              and l.rel_no = t.c3
              and l.line_item_no = t.n1) *
          (t.net_curr_amount / abs(t.net_curr_amount))
         when t.net_curr_amount < 0 and t.n1 > 0 then
           (select l.part_price
             from IFSAPP.CUSTOMER_ORDER_LINE l
            where l.order_no = t.c1
              and l.line_no = t.c2
              and l.rel_no = t.c3
              and l.line_item_no = t.n1) *
          (t.net_curr_amount / abs(t.net_curr_amount))
         else
          (select l.base_sale_unit_price
             from IFSAPP.CUSTOMER_ORDER_LINE l
            where l.order_no = t.c1
              and l.line_no = t.c2
              and l.rel_no = t.c3
              and l.line_item_no = t.n1)
       end UNIT_NSP,
       t.n5 "DISCOUNT(%)",
       t.net_curr_amount SALES_PRICE,
       t.vat_curr_amount VAT,
       (t.net_curr_amount + t.vat_curr_amount) "RSP",
       t.c13 customer_id,
       ifsapp.customer_info_api.Get_Name(t.c13) customer_name,
       ifsapp.CUSTOMER_INFO_COMM_METHOD_API.Get_Any_Phone_No(t.c13) phone_no,
       IFSAPP.CUSTOMER_INFO_ADDRESS_API.Get_Address1(t.c13, 1) || ' ' ||
       IFSAPP.CUSTOMER_INFO_ADDRESS_API.Get_Address2(t.c13, 1) customer_address --,
       /*fsapp.INVENTORY_TRANSACTION_HIST_API.Get_Serial_No((SELECT ih.transaction_id
                                                              FROM ifsapp.INVENTORY_TRANSACTION_HIST_TAB ih
                                                             where ih.order_no = t.c1
                                                               and ih.sequence_no = t.c3
                                                               and ih.release_no = t.c2)) serial_no,
       ifsapp.Serial_Oem_Conn_Api.Get_Oem_No(t.c5,
                                             ifsapp.INVENTORY_TRANSACTION_HIST_API.Get_Serial_No((SELECT ih.transaction_id
                                                                                                   FROM ifsapp.INVENTORY_TRANSACTION_HIST_TAB ih
                                                                                                  where ih.order_no = t.c1
                                                                                                    and ih.sequence_no = t.c3
                                                                                                    and ih.release_no = t.c2))) OEM_No*/ --,
       /*i.invoice_no,*/
       /*(select h.VAT_RECEIPT
          from IFSAPP.HPNRET_PAY_RECEIPT_head_tab h
         where h.ACCOUNT_NO = t.c1
           and substr(h.receipt_no, 4, 3) = '-HF'
           and h.rowstate = 'Printed') VAT_RECEIPT_HP,
       (select p.VAT_RECEIPT
          from hpnret_co_pay_head_tab p, hpnret_co_pay_dtl_tab d
         where p.PAY_NO = d.PAY_NO
           and d.ORDER_NO = t.c1
           and p.lpr_printed is null
           and p.ROWSTATE = 'Printed'
           and d.rowstate = 'Paid') VAT_RECEIPT_CASH*/
  from ifsapp.invoice_item_tab t, ifsapp.INVOICE_TAB i
 where t.invoice_id = i.invoice_id
   and t.creator = 'CUSTOMER_ORDER_INV_ITEM_API'
   and t.rowstate = 'Posted'
   and IFSAPP.SALES_PART_API.Get_Catalog_Type(T.C5) in
       ('INV', 'PKG' /*, 'NON'*/)
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
       ('SAPM', 'SCSM', 'SESM', 'SHOM', 'SISM', 'SFSM', 'SOSM')*/ --Corporate, Employee, & Scrap Sites
   and i.invoice_date between to_date('&from_date', 'yyyy/mm/dd') and
       to_date('&to_date', 'yyyy/mm/dd')
   and t.net_curr_amount != 0
   /*and ifsapp.get_sbl_account_status(t.c1,
                                     t.c2,
                                     t.c3,
                                     t.c5,
                                     t.net_curr_amount,
                                     i.invoice_date) in
       ('CashSale', 'ReturnCompleted', 'HireSale', 'Returned', 'ReturnAfterCashConv', 'ExchangedIn', 'PositiveExchangedIn')*/
   and t.c5 like '%FUR-%' --FUR, SGTV- REF- TV- SRVS- DLCOM- MO- RC-
   /*and IFSAPP.INVENTORY_PRODUCT_CODE_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Code('SCOM',
                                                                                                         t.c5)) =
       'Samsung'*/
   /*and ifsapp.INVENTORY_PRODUCT_FAMILY_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Family('SCOM',
                                                                                                             t.c5)) in
       ('AIR-CONDITIONER', 'AIR-COOLER')*/
   /*and IFSAPP.SALES_GROUP_API.Get_Description(IFSAPP.SALES_PART_API.Get_Catalog_Group('SCOM',
                                                                                      t.c5)) not in
       ('SINGER-FURNITURE', 'SINGER-SEWING MACHINE ACCESSORIES')*/
   /*and (select g.product_group
          from ifsapp.product_category_info p
         inner join ifsapp.product_info g
            on p.group_no = g.group_no
         where p.product_code = t.c5) = 'Small appliance'*/
 order by /*area_code,*/ to_number(district_code), t.c10, t.c1, i.invoice_date
