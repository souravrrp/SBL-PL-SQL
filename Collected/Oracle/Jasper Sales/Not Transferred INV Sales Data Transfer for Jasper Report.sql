--***** Not Transferred INV Sales Data Transfer for Jasper Report
declare
  from_date_ date := to_date('&from_date', 'YYYY/MM/DD');
  to_date_   date := to_date('&to_date', 'YYYY/MM/DD');

begin
  insert into SBL_JR_SALES_DTL_INV
    select a.*
      from (select t.invoice_id,
                   t.item_id,
                   t.c10 SITE,
                   t.c1 ORDER_NO,
                   t.c2 LINE_NO,
                   t.c3 REL_NO,
                   t.n1 COMP_NO,
                   case
                     when t.net_curr_amount = 0 then
                      ifsapp.GET_SBL_FREE_ISSUE_LINE_STATE(t.invoice_id,
                                                           t.item_id,
                                                           t.c1)
                     else
                      ifsapp.get_sbl_account_status(t.c1,
                                                    t.c2,
                                                    t.c3,
                                                    t.c5,
                                                    t.net_curr_amount,
                                                    i.invoice_date)
                   end status,
                   i.invoice_date SALES_DATE,
                   t.identity CUSTOMER_NO,
                   (select c.vendor_no
                      from ifsapp.CUSTOMER_ORDER_LINE c
                     where c.order_no = t.c1
                       and c.line_no = t.c2
                       and c.rel_no = t.c3
                       and c.line_item_no = t.n1) DELIVERY_SITE,
                   t.c5 PRODUCT_CODE,
                   case
                     when t.net_curr_amount != 0 then
                      (t.n2 * (t.net_curr_amount / abs(t.net_curr_amount)))
                     else
                      IFSAPP.GET_SBL_FREE_ITEM_SALES_QTN(t.invoice_id,
                                                         t.item_id,
                                                         T.N2)
                   end SALES_QUANTITY,
                   t.net_curr_amount SALES_PRICE,
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
                   t.n5 DISCOUNT,
                   t.vat_curr_amount VAT,
                   t.net_curr_amount + t.vat_curr_amount AMOUNT_RSP,
                   i.pay_term_id,
                   t.vat_code,
                   i.series_id invoice_series,
                   i.invoice_no,
                   i.voucher_type_ref voucher_type,
                   i.voucher_no_ref voucher_no,
                   ifsapp.hpnret_hp_head_api.Get_Budget_Book_Id(t.c1, 1) bb_no,
                   IFSAPP.STATUTORY_FEE_API.Get_Fee_Rate('SBL', t.vat_code) vat_rate,
                   CASE
                     WHEN SUBSTR(t.c1, 4, 2) = '-H' THEN
                      (select D.LINE_NO
                         from IFSAPP.HPNRET_HP_DTL_TAB D
                        where D.ACCOUNT_NO = t.c1
                          AND D.REF_LINE_NO = t.c2
                          AND D.REF_REL_NO = t.c3
                          AND D.CATALOG_NO = t.c5)
                     ELSE
                      t.c4
                   END ACCT_LINE_NO
              from ifsapp.invoice_item_tab t
             inner join ifsapp.INVOICE_TAB i
                on t.invoice_id = i.invoice_id
             where t.creator = 'CUSTOMER_ORDER_INV_ITEM_API'
               and t.rowstate = 'Posted'
               and IFSAPP.SALES_PART_API.Get_Catalog_Type(T.C5) = 'INV') a
     inner join (select t2.invoice_id, t2.item_id
                   from ifsapp.invoice_item_tab t2, ifsapp.INVOICE_TAB i2
                  where t2.invoice_id = i2.invoice_id
                    and t2.creator = 'CUSTOMER_ORDER_INV_ITEM_API'
                    and t2.rowstate = 'Posted'
                    and IFSAPP.SALES_PART_API.Get_Catalog_Type(T2.C5) =
                        'INV'
                    and t2.c10 not in ('BSCP',
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
                    and i2.invoice_date between from_date_ and to_date_
                 
                 minus
                 
                 select s.invoice_id, s.item_id
                   from IFSAPP.SBL_JR_SALES_DTL_INV s
                  where s.sales_date between from_date_ and to_date_) b
        on a.invoice_id = b.invoice_id
       and a.item_id = b.item_id
     order by a.SITE, a.ORDER_NO, a.SALES_DATE;
  COMMIT;

EXCEPTION
  WHEN no_data_found THEN
    dbms_output.put_line('Not inputed yet!');
  WHEN others THEN
    dbms_output.put_line('Error!');
end;