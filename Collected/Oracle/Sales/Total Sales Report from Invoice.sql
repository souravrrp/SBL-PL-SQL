--*****All Cash Sales Data
select 
    --*
    --count(*)
    t.invoice_id,
    t.c10 SITE,
    t.c1 ORDER_NO,
    case when t.net_curr_amount >= 0 and (select h.cash_conv from HPNRET_CUSTOMER_ORDER_TAB h where h.order_no = t.c1) = 'FALSE'
        then 'Cash Sale'
      when t.net_curr_amount >= 0 and (select h.cash_conv from HPNRET_CUSTOMER_ORDER_TAB h where h.order_no = t.c1) = 'TRUE'
        then 'CashConv Sale'
    else 'ReturnCompleted' 
        end STATUS,
    to_char(i.invoice_date, 'YYYY/MM/DD') SALES_DATE,
    t.identity CUSTOMER_NO,
    ifsapp.customer_info_api.Get_Name(t.identity) CUSTOMER_NAME,
    (select c.vendor_no from ifsapp.CUSTOMER_ORDER_LINE_TAB c where c.order_no = t.c1 and c.line_no = t.c2 and c.rel_no = t.c3 
      and c.catalog_no = t.c5) DELIVERY_SITE,
    t.c5 PRODUCT_CODE,
    IFSAPP.SALES_PART_API.Get_Catalog_Type(T.C5) Catalog_Type,
    case when t.net_curr_amount != 0 then (t.n2 * (t.net_curr_amount/abs(t.net_curr_amount))) 
      else t.n2 
        end SALES_QUANTITY,
    t.net_curr_amount SALES_PRICE,
    case when t.net_curr_amount != 0 
      then (select l.base_sale_unit_price from CUSTOMER_ORDER_LINE l where 
              l.order_no = t.c1 and l.line_no = t.c2 and l.rel_no = t.c3 and l.catalog_no = t.c5)
              * (t.net_curr_amount/abs(t.net_curr_amount)) 
      else (select l.base_sale_unit_price from CUSTOMER_ORDER_LINE l where 
              l.order_no = t.c1 and l.line_no = t.c2 and l.rel_no = t.c3 and l.catalog_no = t.c5)
      end UNIT_NSP,
    t.n5 "DISCOUNT(%)",
    t.vat_curr_amount VAT,    
    t.net_curr_amount + t.vat_curr_amount "AMOUNT(RSP)",
    --t.c2 LINE_NO,
    --t.c3 REL_NO,    
    --t.c6,    
    --t.c13 CUSTOMER_NO,    
    --t.n4,
    (select h.cash_conv from HPNRET_CUSTOMER_ORDER_TAB h where h.order_no = t.c1) CASH_CONV,
    (select h.Remarks from HPNRET_CUSTOMER_ORDER_TAB h where h.order_no = t.c1) REMARKS
from 
  ifsapp.invoice_item_tab t,
  ifsapp.INVOICE_TAB i
where 
  t.invoice_id = i.invoice_id and
  t.creator = 'CUSTOMER_ORDER_INV_ITEM_API' and    
  t.rowstate = 'Posted' and
  IFSAPP.SALES_PART_API.Get_Catalog_Type(T.C5) in ('INV', 'PKG', 'NON') and
  substr(t.c1,4,2) = '-R' and
  t.net_curr_amount != 0 and
  t.c10 not in ('BSCP', 'BLSP', 'CSCP', 'DSCP', 'JSCP', 'RSCP', 'SSCP', 'MS1C', 'MS2C', 'BTSC') and
  i.invoice_date between to_date('&from_date', 'yyyy/mm/dd') and to_date('&to_date', 'yyyy/mm/dd')
order by i.invoice_date, t.c10, t.c1


--*****All Positive Hire Sales Data
select 
    --*
    --count(*)
    t.invoice_id,
    t.c10 SITE,
    t.c1 ORDER_NO,
    (select hd.original_acc_no from HPNRET_HP_HEAD_TAB hd WHERE hd.account_no = t.c1) original_acc_no,
    case 
      --RevertReversed Accounts
      when t.net_curr_amount > 0 and 
        t.c1 != (select hd.original_acc_no from HPNRET_HP_HEAD_TAB hd WHERE hd.account_no = t.c1) and 
        (select d.reverted_date from HPNRET_HP_DTL_TAB d 
          WHERE d.account_no = (select hd.original_acc_no from HPNRET_HP_HEAD_TAB hd WHERE hd.account_no = t.c1) and
          d.ref_line_no = t.c2 and d.ref_rel_no = t.c3 and d.catalog_no = t.c5) is not null
      then
        (select 
              v.rowstate
          from 
            (select 
              d.account_no,
              d.ref_line_no,
              d.ref_rel_no,
              d.catalog_no,
              (select hd.original_acc_no from HPNRET_HP_HEAD_TAB hd where hd.account_no = d.account_no 
                and hd.original_acc_no = d.account_no) original_acc_no,
              d.rowstate,
              d.variated_date,
              d.reverted_date
            from HPNRET_HP_DTL_TAB d) v
          where 
            v.original_acc_no = t.c1 and
            v.ref_line_no = t.c2 and
            v.ref_rel_no = t.c3 and
            v.catalog_no = t.c5 and
            trunc(v.variated_date) = trunc(i.invoice_date))
    --Positive Hire Sales
    else 'Hire Sale' 
        end STATUS,
    to_char(i.invoice_date, 'YYYY/MM/DD') SALES_DATE,
    t.identity CUSTOMER_NO,
    ifsapp.customer_info_api.Get_Name(t.identity) CUSTOMER_NAME,
    (select c.vendor_no from ifsapp.CUSTOMER_ORDER_LINE_TAB c where c.order_no = t.c1 and c.line_no = t.c2 and c.rel_no = t.c3 
      and c.catalog_no = t.c5) DELIVERY_SITE,
    t.c5 PRODUCT_CODE,
    IFSAPP.SALES_PART_API.Get_Catalog_Type(T.C5) Catalog_Type,
    case when t.net_curr_amount != 0 then (t.n2 * (t.net_curr_amount/abs(t.net_curr_amount))) 
      else t.n2 
        end SALES_QUANTITY,
    t.net_curr_amount SALES_PRICE,
    case when t.net_curr_amount != 0 
      then (select l.base_sale_unit_price from CUSTOMER_ORDER_LINE l where 
              l.order_no = t.c1 and l.line_no = t.c2 and l.rel_no = t.c3 and l.catalog_no = t.c5)
              * (t.net_curr_amount/abs(t.net_curr_amount)) 
      else (select l.base_sale_unit_price from CUSTOMER_ORDER_LINE l where 
              l.order_no = t.c1 and l.line_no = t.c2 and l.rel_no = t.c3 and l.catalog_no = t.c5)
      end UNIT_NSP,
    t.n5 "DISCOUNT(%)",
    t.vat_curr_amount VAT,    
    t.net_curr_amount + t.vat_curr_amount "AMOUNT(RSP)",
    (select d.Amt_Finance from HPNRET_HP_DTL_TAB d where d.account_no = t.c1 and d.ref_line_no = t.c2 and d.ref_rel_no = t.c3 
      and d.catalog_no = t.c5) Amt_Finance,
    (select d.down_payment from HPNRET_HP_DTL_TAB d where d.account_no = t.c1 and d.ref_line_no = t.c2 and d.ref_rel_no = t.c3 
      and d.catalog_no = t.c5) down_payment,
    (select hd.length_of_contract from HPNRET_HP_HEAD_TAB hd where hd.account_no = t.c1) length_of_contract,
    (select d.install_amt from HPNRET_HP_DTL_TAB d where d.account_no = t.c1 and d.ref_line_no = t.c2 and d.ref_rel_no = t.c3 
      and d.catalog_no = t.c5) install_amt,
    (select d.service_charge from HPNRET_HP_DTL_TAB d where d.account_no = t.c1 and d.ref_line_no = t.c2 and d.ref_rel_no = t.c3 
      and d.catalog_no = t.c5) service_charge
    --t.c2 LINE_NO,
    --t.c3 REL_NO,    
    --t.c6,    
    --t.c13 CUSTOMER_NO,    
    --t.n4,
from 
  ifsapp.invoice_item_tab t,
  ifsapp.INVOICE_TAB i
where 
  t.invoice_id = i.invoice_id and
  t.creator = 'CUSTOMER_ORDER_INV_ITEM_API' and    
  t.rowstate = 'Posted' and
  IFSAPP.SALES_PART_API.Get_Catalog_Type(T.C5) in ('INV', 'PKG', 'NON') and
  substr(t.c1,4,2) = '-H' and
  t.net_curr_amount > 0 and
  t.c10 not in ('BSCP', 'BLSP', 'CSCP', 'DSCP', 'JSCP', 'RSCP', 'SSCP', 'MS1C', 'MS2C', 'BTSC') and
  i.invoice_date between to_date('&from_date', 'yyyy/mm/dd') and to_date('&to_date', 'yyyy/mm/dd')
order by i.invoice_date, t.c10, t.c1


--union


--*****All Negative Hire Sales Data
select 
    --*
    --count(*)
    t.invoice_id,
    t.c10 SITE,
    t.c1 ORDER_NO,
    (select hd.original_acc_no from HPNRET_HP_HEAD_TAB hd WHERE hd.account_no = t.c1) original_acc_no,
    case 
      --Negative Hire Sale Variations
      when t.net_curr_amount < 0 and 
        t.c1 = (select hd.account_no from HPNRET_HP_HEAD_TAB hd WHERE hd.account_no = t.c1 and hd.account_no = hd.original_acc_no) and 
        (select d.reverted_date from HPNRET_HP_DTL_TAB d WHERE d.account_no = t.c1 and d.ref_line_no = t.c2 and d.ref_rel_no = t.c3 
          and d.catalog_no = t.c5) is null
      then 
          (select 
              v.rowstate
          from 
            (select 
              d.account_no,
              d.ref_line_no,
              d.ref_rel_no,
              d.catalog_no,
              (select hd.original_acc_no from HPNRET_HP_HEAD_TAB hd where hd.account_no = d.account_no and hd.original_acc_no = d.account_no) original_acc_no,
              d.rowstate,
              d.variated_date,
              d.reverted_date
            from HPNRET_HP_DTL_TAB d) v
          where 
            v.account_no = t.c1 and
            v.ref_line_no = t.c2 and
            v.ref_rel_no = t.c3 and
            v.catalog_no = t.c5 and
            trunc(v.variated_date) = trunc(i.invoice_date))
    --Reverted Accounts
    when t.net_curr_amount < 0 and 
        t.c1 = (select hd.account_no from HPNRET_HP_HEAD_TAB hd WHERE hd.account_no = t.c1 and hd.account_no = hd.original_acc_no) and 
        (select d.reverted_date from HPNRET_HP_DTL_TAB d WHERE d.account_no = t.c1 and d.ref_line_no = t.c2 and d.ref_rel_no = t.c3 
          and d.catalog_no = t.c5) is not null
      then 
          'Reverted'
        end STATUS,
    to_char(i.invoice_date, 'YYYY/MM/DD') SALES_DATE,
    t.identity CUSTOMER_NO,
    ifsapp.customer_info_api.Get_Name(t.identity) CUSTOMER_NAME,
    (select c.vendor_no from ifsapp.CUSTOMER_ORDER_LINE_TAB c where c.order_no = t.c1 and c.line_no = t.c2 and c.rel_no = t.c3 
      and c.catalog_no = t.c5) DELIVERY_SITE,
    t.c5 PRODUCT_CODE,
    IFSAPP.SALES_PART_API.Get_Catalog_Type(T.C5) Catalog_Type,
    case when t.net_curr_amount != 0 then (t.n2 * (t.net_curr_amount/abs(t.net_curr_amount))) 
      else t.n2 
        end SALES_QUANTITY,
    t.net_curr_amount SALES_PRICE,
    case when t.net_curr_amount != 0 
      then (select l.base_sale_unit_price from CUSTOMER_ORDER_LINE l where 
              l.order_no = t.c1 and l.line_no = t.c2 and l.rel_no = t.c3 and l.catalog_no = t.c5)
              * (t.net_curr_amount/abs(t.net_curr_amount)) 
      else (select l.base_sale_unit_price from CUSTOMER_ORDER_LINE l where 
              l.order_no = t.c1 and l.line_no = t.c2 and l.rel_no = t.c3 and l.catalog_no = t.c5)
      end UNIT_NSP,
    t.n5 "DISCOUNT(%)",
    t.vat_curr_amount VAT,    
    t.net_curr_amount + t.vat_curr_amount "AMOUNT(RSP)",
    (select d.Amt_Finance from HPNRET_HP_DTL_TAB d where d.account_no = t.c1 and d.ref_line_no = t.c2 and d.ref_rel_no = t.c3 
      and d.catalog_no = t.c5) Amt_Finance,
    (select d.down_payment from HPNRET_HP_DTL_TAB d where d.account_no = t.c1 and d.ref_line_no = t.c2 and d.ref_rel_no = t.c3 
      and d.catalog_no = t.c5) down_payment,
    (select hd.length_of_contract from HPNRET_HP_HEAD_TAB hd where hd.account_no = t.c1) length_of_contract,
    (select d.install_amt from HPNRET_HP_DTL_TAB d where d.account_no = t.c1 and d.ref_line_no = t.c2 and d.ref_rel_no = t.c3 
      and d.catalog_no = t.c5) install_amt,
    (select d.service_charge from HPNRET_HP_DTL_TAB d where d.account_no = t.c1 and d.ref_line_no = t.c2 and d.ref_rel_no = t.c3 
      and d.catalog_no = t.c5) service_charge
    --t.c2 LINE_NO,
    --t.c3 REL_NO,    
    --t.c6,    
    --t.c13 CUSTOMER_NO,    
    --t.n4,
from 
  ifsapp.invoice_item_tab t,
  ifsapp.INVOICE_TAB i
where 
  t.invoice_id = i.invoice_id and
  t.creator = 'CUSTOMER_ORDER_INV_ITEM_API' and    
  t.rowstate = 'Posted' and
  IFSAPP.SALES_PART_API.Get_Catalog_Type(T.C5) in ('INV', 'PKG', 'NON') and
  substr(t.c1,4,2) = '-H' and
  t.net_curr_amount < 0 and
  t.c10 not in ('BSCP', 'BLSP', 'CSCP', 'DSCP', 'JSCP', 'RSCP', 'SSCP', 'MS1C', 'MS2C', 'BTSC') and
  i.invoice_date between to_date('&from_date', 'yyyy/mm/dd') and to_date('&to_date', 'yyyy/mm/dd')
order by i.invoice_date, t.c10, t.c1


--*****Core SQL
select 
    --*
    --count(*)
    t.invoice_id,
    t.c10 SITE,
    t.c1 ORDER_NO,
    to_char(i.invoice_date, 'YYYY/MM/DD') SALES_DATE,
    t.identity CUSTOMER_NO,
    ifsapp.customer_info_api.Get_Name(t.identity) CUSTOMER_NAME,
    --t.item_data,
    --t.creator,
    --ifsapp.cust_ord_customer_api.get_cust_grp(t.identity) CUSTOMER_GROUP,
    (select max(c.vendor_no) from ifsapp.CUSTOMER_ORDER_LINE_TAB c where c.order_no = t.c1 and c.line_no = t.c2 and c.rel_no = t.c3 
      group by c.order_no, c.line_no, c.rel_no) DELIVERY_SITE,
    t.c5 PRODUCT_CODE,
    IFSAPP.SALES_PART_API.Get_Catalog_Type(T.C5) Catalog_Type,
    case when t.net_curr_amount != 0 then (t.n2 * (t.net_curr_amount/abs(t.net_curr_amount))) 
      else t.n2 
        end SALES_QUANTITY,
    t.net_curr_amount SALES_PRICE,
    case when t.net_curr_amount != 0 
      then (select l.base_sale_unit_price from CUSTOMER_ORDER_LINE l where 
              l.order_no = t.c1 and l.line_no = t.c2 and l.rel_no = t.c3 and l.catalog_no = t.c5)
              * (t.net_curr_amount/abs(t.net_curr_amount)) 
      else (select l.base_sale_unit_price from CUSTOMER_ORDER_LINE l where 
              l.order_no = t.c1 and l.line_no = t.c2 and l.rel_no = t.c3 and l.catalog_no = t.c5)
      end UNIT_NSP,
    t.n5 "DISCOUNT(%)",
    t.vat_curr_amount VAT,    
    t.net_curr_amount + t.vat_curr_amount "AMOUNT(RSP)",
    t.c2 LINE_NO,
    t.c3 REL_NO    
    --t.c6,    
    --t.c13 CUSTOMER_NO,    
    --t.n4,
from 
  ifsapp.invoice_item_tab t,
  ifsapp.INVOICE_TAB i
where 
  t.invoice_id = i.invoice_id and
  --ifsapp.cust_ord_customer_api.get_cust_grp(t.identity) = '003' and
  --t.net_curr_amount > 0 and
  t.creator = 'CUSTOMER_ORDER_INV_ITEM_API' and /*in ('INVOICE_API', 'MAN_SUPP_INVOICE_API') and*/   
  t.rowstate = 'Posted' and
  --i.invoice_date between to_date('&from_date', 'yyyy/mm/dd') and to_date('&to_date', 'yyyy/mm/dd') and
  IFSAPP.SALES_PART_API.Get_Catalog_Type(T.C5) in ('INV', 'PKG', 'NON') and
  --IFSAPP.SALES_PART_API.Get_Catalog_Type(T.C5) is null
  --t.c10 = 'DSCP' --and
  --t.c10 not in ('BSCP', 'BLSP', 'CSCP', 'DSCP', 'JSCP', 'RSCP', 'SSCP', 'MS1C', 'MS2C', 'BTSC')
  --t.c5 in ('SRREF-DF2-18', 'SRREF-G-BCD-192')
  --t.c5 is null
  --t.identity = 'W0000929-2' and
  t.c1 = 'ZRN-H3393' --and  
  --t.c1 is null --and
  --t.n2 is not null and
  --i.party_type = 'CUSTOMER'
order by i.invoice_date, t.c10, t.c1


--Information Test in Invoice_Tab
/*select 
    --*
    i.identity,
    i.invoice_id,
    i.rowstate,
    i.series_id,
    i.invoice_no,
    i.invoice_date,
    i.pay_term_id,
    i.delivery_identity,
    i.creators_reference,
    i.voucher_no_ref,
    i.net_curr_amount,
    i.vat_curr_amount,
    i.net_dom_amount,
    i.vat_dom_amount,
    i.c7,
    i.create_state,
    i.payer_identity
from INVOICE_TAB i
where i.invoice_id = '2499187'*/
