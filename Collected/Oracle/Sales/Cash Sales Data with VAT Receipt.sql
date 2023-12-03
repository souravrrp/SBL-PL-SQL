--Cash Sales Data with VAT Receipt
select c.SITE,
       v.order_no,
       to_char(c.SALES_DATE, 'YYYY/MM/DD') SALES_DATE,
       c.status,
       v.receipt_no,
       to_char(v.receipt_date, 'YYYY/MM/DD') receipt_date,
       v.vat_receipt,
       substr(v.vat_receipt, 5) vat_receipt_no
  from ( --Cash Sales Data
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
                i.invoice_date SALES_DATE,
                t.c5 PRODUCT_CODE,
                IFSAPP.INVENTORY_PRODUCT_CODE_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Code('SCOM',
                                                                                                                  t.c5)) brand,
                ifsapp.INVENTORY_PRODUCT_FAMILY_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Family('SCOM',
                                                                                                                      t.c5)) product_family,
                IFSAPP.COMMODITY_GROUP_API.Get_Description(IFSAPP.INVENTORY_PART_API.Get_Second_Commodity('SCOM',
                                                                                                          t.c5)) commodity_group2,
                case
                  when t.net_curr_amount != 0 then
                   t.n2 * (t.net_curr_amount / abs(t.net_curr_amount))
                  else
                   t.n2
                end SALES_QUANTITY,
                t.net_curr_amount SALES_PRICE,
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
                (t.net_curr_amount + t.vat_curr_amount) "RSP",
                i.invoice_no
          from ifsapp.invoice_item_tab t, ifsapp.INVOICE_TAB i
         where t.invoice_id = i.invoice_id
           and t.creator = 'CUSTOMER_ORDER_INV_ITEM_API'
           and t.rowstate = 'Posted'
           and IFSAPP.SALES_PART_API.Get_Catalog_Type(T.C5) in
               ('INV', 'PKG', 'NON')
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
           and i.invoice_date between to_date('&from_date', 'yyyy/mm/dd') and
               to_date('&to_date', 'yyyy/mm/dd')
           and t.net_curr_amount != 0
           and ifsapp.get_sbl_account_status(t.c1,
                                             t.c2,
                                             t.c3,
                                             t.c5,
                                             t.net_curr_amount,
                                             i.invoice_date) = 'CashSale') c
 inner join ( --Cash Sales VAT Receipts
             select p.contract,
                     d.order_no,
                     p.receipt_no,
                     p.receipt_date,
                     p.rowstate              head_status,
                     p.appr_date,
                     p.vat_receipt,
                     p.lpr_printed,
                     d.pay_no,
                     d.pay_line_no,
                     d.payment_method,
                     d.curr_amount,
                     d.lump_sum_trans_date,
                     d.voucher_no,
                     d.voucher_type,
                     d.voucher_date,
                     d.user_id,
                     d.identity,
                     d.ledger_item_series_id,
                     d.ledger_item_id,
                     d.mixed_payment_id,
                     d.bcb_statement_id,
                     d.short_name,
                     d.rowstate              line_status
               from hpnret_co_pay_head_tab p
              inner join hpnret_co_pay_dtl_tab d
                 on p.PAY_NO = d.PAY_NO
              where p.lpr_printed is null
                and p.ROWSTATE = 'Printed'
                and d.rowstate = 'Paid'
                and d.curr_amount > 0) v
    on

 c.SITE = v.contract
 and c.ORDER_NO = v.order_no
 and c.invoice_no = v.ledger_item_id
 order by 8
