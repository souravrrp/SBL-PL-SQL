--*****Wholesale VAT Receipt Analysis
--*****VAT Receipts of WH Delivery (Trip Plan)Sales of WS & Corpo
select j.site,
       j.order_no,
       /*j.line_no,
       j.rel_no,*/
       max(j.sales_date) sales_date,
       /*p.order_no,
       p.line_no,
       p.release_no,
       c.order_no,
       c.line_no,
       c.rel_no,
       c.line_item_no,*/
       v.vat_receipt_no vat_receipt
  from (select w.site,
               w.order_no,
               w.line_no,
               w.rel_no,
               max(w.sales_date) sales_date
          from ifsapp.SBL_JR_SALES_DTL_INV w
         where w.status = 'CashSale'
           and w.site in ('JWSS', 'SAOS', 'SCSM', 'SWSS', 'WSMO')
           and w.delivery_site in ('APWH',
                                   'BBWH',
                                   'BWHW',
                                   'CMWH',
                                   'CTGW',
                                   'KWHW',
                                   'MYWH',
                                   'RWHW',
                                   'SPWH',
                                   'SWHW',
                                   'SYWH',
                                   'TWHW',
                                   'ABWW', --Wholesale Warehouse
                                   'BAWW',
                                   'BGWW',
                                   'CLWW',
                                   'CTWW',
                                   'KHWW',
                                   'MHWW',
                                   'RHWW',
                                   'SDWW',
                                   'SVWW',
                                   'SLWW',
                                   'TUWW')
         group by w.site, w.order_no, w.line_no, w.rel_no) j
  left join ifsapp.PURCHASE_ORDER_LINE_TAB p
    on j.order_no = p.demand_order_no
   and j.line_no = p.demand_release
   and j.rel_no = p.demand_sequence_no
 inner join ifsapp.CUSTOMER_ORDER_LINE_TAB c
    on p.order_no = c.demand_order_ref1
   and p.line_no = c.demand_order_ref2
   and p.release_no = c.demand_order_ref3
 inner join (select t.order_no,
                    t.line_no,
                    t.rel_no,
                    t.line_item_no,
                    t.vat_receipt_no
               from ifsapp.TRN_TRIP_PLAN_CO_LINE_TAB t
              where t.vat_receipt_no is not null
              group by t.order_no,
                       t.line_no,
                       t.rel_no,
                       t.line_item_no,
                       t.vat_receipt_no) v
    on c.order_no = v.order_no
   and c.line_no = v.line_no
   and c.rel_no = v.rel_no
   and c.line_item_no = v.line_item_no
 where j.sales_date between to_date('&from_date', 'YYYY/MM/DD') and
       to_date('&to_date', 'YYYY/MM/DD')
 group by j.site, j.order_no, v.vat_receipt_no
 order by 1, 2, 3;

--*****VAT Receipts Details of WH Delivery (Trip Plan)Sales of WS & Corpo
select j.order_no,
       j.line_no,
       j.rel_no,
       j.sales_date,
       /*p.order_no,
       p.line_no,
       p.release_no,
       c.order_no,
       c.line_no,
       c.rel_no,
       c.line_item_no,*/
       v.vat_receipt_no vat_receipt
  from (select w.order_no, w.line_no, w.rel_no, max(w.sales_date) sales_date
          from ifsapp.SBL_JR_SALES_DTL_INV w
         where w.status = 'CashSale'
           and w.site in ('JWSS', 'SAOS', 'SCSM', 'SWSS', 'WSMO')
         group by w.order_no, w.line_no, w.rel_no) j
  left join ifsapp.PURCHASE_ORDER_LINE_TAB p
    on j.order_no = p.demand_order_no
   and j.line_no = p.demand_release
   and j.rel_no = p.demand_sequence_no
 inner join ifsapp.CUSTOMER_ORDER_LINE_TAB c
    on p.order_no = c.demand_order_ref1
   and p.line_no = c.demand_order_ref2
   and p.release_no = c.demand_order_ref3
 inner join (select t.order_no,
                    t.line_no,
                    t.rel_no,
                    t.line_item_no,
                    t.vat_receipt_no
               from ifsapp.TRN_TRIP_PLAN_CO_LINE_TAB t
              where t.vat_receipt_no is not null
              group by t.order_no,
                       t.line_no,
                       t.rel_no,
                       t.line_item_no,
                       t.vat_receipt_no) v
    on c.order_no = v.order_no
   and c.line_no = v.line_no
   and c.rel_no = v.rel_no
   and c.line_item_no = v.line_item_no
 where j.sales_date between to_date('&from_date', 'YYYY/MM/DD') and
       to_date('&to_date', 'YYYY/MM/DD')
 order by 1, 2, 3;

--*****Uniqueness Check of CO
select j.order_no, j.line_no, j.rel_no, count(*)
  from (select w.order_no, w.line_no, w.rel_no, max(w.sales_date) sales_date
          from ifsapp.SBL_JR_SALES_DTL_INV w
         where w.status = 'CashSale'
           and w.site in ('JWSS', 'SAOS', 'SCSM', 'SWSS', 'WSMO')
         group by w.order_no, w.line_no, w.rel_no) j
  left join ifsapp.PURCHASE_ORDER_LINE_TAB p
    on j.order_no = p.demand_order_no
   and j.line_no = p.demand_release
   and j.rel_no = p.demand_sequence_no
 inner join ifsapp.CUSTOMER_ORDER_LINE_TAB c
    on p.order_no = c.demand_order_ref1
   and p.line_no = c.demand_order_ref2
   and p.release_no = c.demand_order_ref3
 group by j.order_no, j.line_no, j.rel_no
having count(*) > 1;

--*****Uniqueness Check of CO against Internal PO
select c.order_no, c.line_no, c.rel_no, c.line_item_no, count(*)
  from (select w.order_no, w.line_no, w.rel_no, max(w.sales_date) sales_date
          from ifsapp.SBL_JR_SALES_DTL_INV w
         where w.status = 'CashSale'
           and w.site in ('JWSS', 'SAOS', 'SCSM', 'SWSS', 'WSMO')
         group by w.order_no, w.line_no, w.rel_no) j
  left join ifsapp.PURCHASE_ORDER_LINE_TAB p
    on j.order_no = p.demand_order_no
   and j.line_no = p.demand_release
   and j.rel_no = p.demand_sequence_no
 inner join ifsapp.CUSTOMER_ORDER_LINE_TAB c
    on p.order_no = c.demand_order_ref1
   and p.line_no = c.demand_order_ref2
   and p.release_no = c.demand_order_ref3
 group by c.order_no, c.line_no, c.rel_no, c.line_item_no
having count(*) > 1;
