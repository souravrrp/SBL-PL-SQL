create or replace procedure SBL_JR_SALES_INSERT_INV_PRC is

begin
  insert into SBL_JR_SALES_DTL_INV
    select t.invoice_id,
           t.item_id,
           t.c10 SITE,
           t.c1 ORDER_NO,
           t.c2 LINE_NO,
           t.c3 REL_NO,
           '0' COMP_NO,
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
              from ifsapp.CUSTOMER_ORDER_LINE_TAB c
             where c.order_no = t.c1
               and c.line_no = t.c2
               and c.rel_no = t.c3
               and c.catalog_no = t.c5) DELIVERY_SITE,
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
           t.n5 DISCOUNT,
           t.vat_curr_amount VAT,
           t.net_curr_amount + t.vat_curr_amount AMOUNT_RSP,
           i.pay_term_id,
           t.vat_code,
           i.series_id invoice_series,
           i.invoice_no,
           i.voucher_type_ref voucher_type,
           i.voucher_no_ref voucher_no,
           ifsapp.hpnret_hp_head_api.Get_Budget_Book_Id(t.c1, 1) bb_no
      from ifsapp.invoice_item_tab t, ifsapp.INVOICE_TAB i
     where t.invoice_id = i.invoice_id
       and t.creator = 'CUSTOMER_ORDER_INV_ITEM_API'
       and t.rowstate = 'Posted'
       and IFSAPP.SALES_PART_API.Get_Catalog_Type(T.C5) = 'INV'
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
                         'BTSC')
       and i.invoice_date =
           to_date(to_char(sysdate - 1, 'YYYY/MM/DD'), 'YYYY/MM/DD')
    /*and t.net_curr_amount != 0*/
     order by t.c10, t.c1, i.invoice_date;
  COMMIT;
EXCEPTION
  WHEN no_data_found THEN
    dbms_output.put_line('Not inputed yet!');
  WHEN others THEN
    dbms_output.put_line('Error!');
  
end SBL_JR_SALES_INSERT_INV_PRC;
/
