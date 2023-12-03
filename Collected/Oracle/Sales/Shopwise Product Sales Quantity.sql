select t.c10 "SITE",
       (select s.area_code
          from ifsapp.SHOP_DTS_INFO s
         where s.shop_code = t.c10) area_code,
       (select s.district_code
          from ifsapp.SHOP_DTS_INFO s
         where s.shop_code = t.c10) district_code,
       t.c1 ORDER_NO,
       ifsapp.get_sbl_account_status(t.c1,
                                     t.c2,
                                     t.c3,
                                     t.c5,
                                     t.net_curr_amount,
                                     i.invoice_date) status,
       /*t.c2, t.c3,*/
       to_char(i.invoice_date, 'YYYY/MM/DD') SALES_DATE,
       t.c5 PRODUCT_CODE,
       IFSAPP.INVENTORY_PRODUCT_CODE_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Code('SCOM',
                                                                                                         t.c5)) brand,
       ifsapp.INVENTORY_PRODUCT_FAMILY_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Family('SCOM',
                                                                                                             t.c5)) product_family,
       IFSAPP.COMMODITY_GROUP_API.Get_Description(IFSAPP.INVENTORY_PART_API.Get_Second_Commodity('SCOM',
                                                                                                 t.c5)) commodity_group2,
       IFSAPP.SALES_GROUP_API.Get_Description(IFSAPP.SALES_PART_API.Get_Catalog_Group('SCOM',
                                                                                      t.c5)) sales_group,
       case
         when t.net_curr_amount != 0 then
          t.n2 * (t.net_curr_amount / abs(t.net_curr_amount))
         else
          IFSAPP.GET_SBL_FREE_ITEM_SALES_QTN(t.invoice_id, t.item_id, T.N2) --t.n2
       end SALES_QUANTITY,
       t.net_curr_amount SALES_PRICE,
       /*(select ct.amount
        from COMMISSION_AGREE_LINE_TAB ct
       where ct.AGREEMENT_ID = 'SP_SC_RTL'
         and ct.CATALOG_NO = t.c5
         and ct.COMMISSION_SALES_TYPE = 'HP'
         and i.invoice_date between ct.valid_from and ct.valid_to) comm_amount,*/
       case
         when t.net_curr_amount != 0 then
          (select l.base_sale_unit_price
             from CUSTOMER_ORDER_LINE l
            where l.order_no = t.c1
              and l.line_no = t.c2
              and l.rel_no = t.c3
              and l.catalog_no = t.c5) *
          (t.net_curr_amount / abs(t.net_curr_amount))
         else
          (select l.base_sale_unit_price
             from CUSTOMER_ORDER_LINE l
            where l.order_no = t.c1
              and l.line_no = t.c2
              and l.rel_no = t.c3
              and l.catalog_no = t.c5)
       end UNIT_NSP,
       t.n5 "DISCOUNT(%)",
       t.vat_curr_amount VAT,
       (t.net_curr_amount + t.vat_curr_amount) "RSP" --,
/*t.c13 customer_id,
ifsapp.customer_info_api.Get_Name(t.c13) customer_name,
ifsapp.CUSTOMER_INFO_COMM_METHOD_API.Get_Any_Phone_No(t.c13) phone_no,*/
/*ifsapp.INVENTORY_TRANSACTION_HIST_API.Get_Serial_No((SELECT ih.transaction_id
                                                      FROM ifsapp.INVENTORY_TRANSACTION_HIST_TAB ih
                                                     where ih.order_no = t.c1
                                                       and ih.sequence_no = t.c3
                                                       and ih.release_no = t.c2)) serial_no,
ifsapp.Serial_Oem_Conn_Api.Get_Oem_No(t.c5,
                                      ifsapp.INVENTORY_TRANSACTION_HIST_API.Get_Serial_No((SELECT ih.transaction_id
                                                                                            FROM ifsapp.INVENTORY_TRANSACTION_HIST_TAB ih
                                                                                           where ih.order_no = t.c1
                                                                                             and ih.sequence_no = t.c3
                                                                                             and ih.release_no = t.c2))) OEM_No,
i.invoice_no,
(select h.VAT_RECEIPT
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
   and t.c10 not in ('SAPM', 'SCSM', 'SESM', 'SHOM', 'SISM', 'SFSM', 'SOSM') --Corporate, Employee, & Scrap Sites
      /*and t.c10 in ('NSRB', 'BNGB', 'BFTB', 'BSBB', 'BKLB', 'BCMB', 'BSPB', 'SRCB', 'SRGB', 'BLKB')*/
   and i.invoice_date between to_date('&from_date', 'yyyy/mm/dd') and
       to_date('&to_date', 'yyyy/mm/dd')
   and t.net_curr_amount != 0
   and ifsapp.get_sbl_account_status(t.c1,
                                     t.c2,
                                     t.c3,
                                     t.c5,
                                     t.net_curr_amount,
                                     i.invoice_date) in
       ('CashSale', 'ReturnCompleted', 'HireSale', 'Returned')
/*and IFSAPP.INVENTORY_PRODUCT_CODE_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Code('SCOM',
                                                                                                         t.c5)) =
       'Beko'
   and IFSAPP.SALES_GROUP_API.Get_Description(IFSAPP.SALES_PART_API.Get_Catalog_Group('SCOM',
                                                                                      t.c5)) not in
       ('SINGER-FURNITURE', 'SINGER-SEWING MACHINE ACCESSORIES')
and ifsapp.INVENTORY_PRODUCT_FAMILY_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Family('SCOM',
                                                                                                          t.c5)) in
    ('Panel Television', 'Color Television LCD/Plasma/RPT')*/
/*and t.c5 like '%TV-%'*/ /*in ('SGTV-UA23F4003ARSER',
'SGTV-UA32J4100ARSER',
'SGTV-UA40J5100ARSER',
'SGTV-UA40J5300ARSER',
'SGTV-UA40J6300ARSER',
'SGTV-UA40EH5000RSER',
'SGTV-UA40H5100ARSER',
'SGTV-UA48J5300ARSER')*/
/*and t.c10 = 'DITF'*/
/*and t.c1 = 'DUC-R524'*/
 order by area_code, district_code, t.c10, t.c1, i.invoice_date
