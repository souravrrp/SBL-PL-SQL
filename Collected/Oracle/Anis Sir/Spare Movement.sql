--***** Spare Movement
select inu.year,
       inu.period,
       inu.part_no,
       IFSAPP.INVENTORY_PART_API.Get_Description('DSCP', inu.part_no) part_desc,
       IFSAPP.INVENTORY_PRODUCT_CODE_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Code('DSCP',
                                                                                                         inu.part_no)) brand,
       ifsapp.INVENTORY_PRODUCT_FAMILY_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Family('DSCP',
                                                                                                             inu.part_no)) product_family,
       IFSAPP.COMMODITY_GROUP_API.Get_Description(IFSAPP.INVENTORY_PART_API.Get_Second_Commodity('DSCP',
                                                                                                 inu.part_no)) commodity_group2,
       round(nvl(cst.cost, 0), 2) unit_cost,
       nvl(inu.open_bal, 0) open_bal,
       nvl(otr.open_in_transit, 0) open_in_transit,
       nvl(inu.open_bal, 0) + nvl(otr.open_in_transit, 0) open_unit,
       round((nvl(inu.open_bal, 0) + nvl(otr.open_in_transit, 0)) *
             nvl(cst.cost, 0),
             2) open_value,
       nvl(pur.purchase_unit, 0) purchase_unit,
       round(nvl(pur.purchase_unit, 0) * nvl(cst.cost, 0), 2) purchase_value,
       nvl(sls.SALES_QUANTITY, 0) sales_unit,
       round(nvl(sls.SALES_QUANTITY, 0) * nvl(cst.cost, 0), 2) sales_value,
       /*nvl(nrc.nrec, 0) nrec,
       nvl(nis.niss, 0) niss,*/
       nvl(nrc.nrec, 0) - nvl(nis.niss, 0) adj_unit,
       round((nvl(nrc.nrec, 0) - nvl(nis.niss, 0)) * nvl(cst.cost, 0), 2) adj_value,
       nvl(inu.closing_bal, 0) closing_bal,
       nvl(inu.close_in_transit, 0) close_in_transit,
       nvl(inu.closing_bal, 0) + nvl(inu.close_in_transit, 0) close_unit,
       round((nvl(inu.closing_bal, 0) + nvl(inu.close_in_transit, 0)) *
             nvl(cst.cost, 0),
             2) close_value
  from (select b.year, --Inventory Unit
               b.period,
               b.part_no,
               sum(b.open_bal) open_bal,
               sum(b.closing_bal) closing_bal,
               sum(b.in_transit) close_in_transit
          from IFSAPP.INVENTORY_BALANCE b
         where b.year = '&year_i'
           and b.period = '&period'
         group by b.year, b.period, b.part_no) inu

  left join

 (select b1.part_no, --Open in transit
         sum(b1.in_transit) open_in_transit
    from IFSAPP.INVENTORY_BALANCE b1
   where b1.year =
         extract(year from add_months(to_date('&year_i' || '/' || '&period' || '/1',
                                    'YYYY/MM/DD'),
                            -1))
     and b1.period =
         extract(month from add_months(to_date('&year_i' || '/' || '&period' || '/1',
                                    'YYYY/MM/DD'),
                            -1))
   group by b1.part_no) otr
    on inu.part_no = otr.part_no

  left join

 (select extract(year from pr.arrival_date) "YEAR", --Partwise Monthly Purchase
         extract(month from pr.arrival_date) PERIOD,
         pr.part_no,
         sum(pr.qty_invoiced) purchase_unit
    from ifsapp.PURCHASE_RECEIPT_NEW pr
   where IFSAPP.IDENTITY_INVOICE_INFO_API.Get_Group_Id('SBL',
                                                       pr.vendor_no,
                                                       'Supplier') = '0'
     and IFSAPP.INVENTORY_PART_API.Get_Part_Product_Family('DSCP',
                                                           pr.part_no) !=
         'RBOOK'
     and trunc(pr.arrival_date) between
         to_date('&year_i' || '/' || '&period' || '/1', 'YYYY/MM/DD') and
         last_day(to_date('&year_i' || '/' || '&period' || '/1',
                          'YYYY/MM/DD'))
     and pr.state != 'Cancelled'
   group by extract(year from pr.arrival_date),
            extract(month from pr.arrival_date),
            pr.part_no) pur
    on inu.year = pur.YEAR
   and inu.period = pur.PERIOD
   and inu.part_no = pur.part_no

  left join

 (select tsl.YEAR,
         tsl.PERIOD,
         tsl.PRODUCT_CODE,
         sum(tsl.SALES_QUANTITY) SALES_QUANTITY
    from ( --Consumption on Active WO
          select extract(year from a.reg_date) "YEAR",
                  extract(month from a.reg_date) PERIOD,
                  m.part_no PRODUCT_CODE,
                  sum(m.qty) SALES_QUANTITY
            from ifsapp.MAINT_MATERIAL_REQ_LINE m
            left join ifsapp.ACTIVE_SEPARATE a
              on m.wo_no = a.wo_no
           where trunc(a.reg_date) between
                 to_date('&year_i' || '/' || '&period' || '/1', 'YYYY/MM/DD') and
                 last_day(to_date('&year_i' || '/' || '&period' || '/1',
                                  'YYYY/MM/DD'))
          /*and m.part_no like \*'BO-COMP-CNE60520M-260W'*\
          'BO-COMP-GNEV222S-220W'*/
           group by extract(year from a.reg_date),
                     extract(month from a.reg_date),
                     m.part_no
          
          union all
          
          --Consumption on Historical WO
          select extract(year from h.reg_date) "YEAR",
                 extract(month from h.reg_date) PERIOD,
                 m.part_no PRODUCT_CODE,
                 sum(m.qty) SALES_QUANTITY
            from ifsapp.MAINT_MATERIAL_REQ_LINE m
            left join ifsapp.HISTORICAL_SEPARATE h
              on m.wo_no = h.wo_no
           where trunc(h.reg_date) between
                 to_date('&year_i' || '/' || '&period' || '/1', 'YYYY/MM/DD') and
                 last_day(to_date('&year_i' || '/' || '&period' || '/1',
                                  'YYYY/MM/DD'))
          /*and m.part_no like \*'BO-COMP-CNE60520M-260W'*\
          'BO-COMP-GNEV222S-220W'*/
           group by extract(year from h.reg_date),
                    extract(month from h.reg_date),
                    m.part_no) tsl
   group by tsl.YEAR, tsl.PERIOD, tsl.PRODUCT_CODE) sls
    on inu.year = sls.YEAR
   and inu.period = sls.PERIOD
   and inu.part_no = sls.PRODUCT_CODE

  left join

 (select extract(year from ih.dated) "YEAR", --NREC
         extract(month from ih.dated) PERIOD,
         ih.part_no,
         ih.transaction_code,
         sum(ih.quantity) nrec
    from IFSAPP.INVENTORY_TRANSACTION_HIST_TAB ih
   where ih.transaction_code = 'NREC'
     and trunc(ih.dated) between
         to_date('&year_i' || '/' || '&period' || '/1', 'YYYY/MM/DD') and
         last_day(to_date('&year_i' || '/' || '&period' || '/1',
                          'YYYY/MM/DD'))
   group by extract(year from ih.dated),
            extract(month from ih.dated),
            ih.part_no,
            ih.transaction_code) nrc
    on inu.year = nrc.YEAR
   and inu.period = nrc.PERIOD
   and inu.part_no = nrc.part_no

  left join

 (select extract(year from ih.dated) "YEAR", --NISS
         extract(month from ih.dated) PERIOD,
         ih.part_no,
         ih.transaction_code,
         sum(ih.quantity) niss
    from IFSAPP.INVENTORY_TRANSACTION_HIST_TAB ih
   where ih.transaction_code = 'NISS'
     and trunc(ih.dated) between
         to_date('&year_i' || '/' || '&period' || '/1', 'YYYY/MM/DD') and
         last_day(to_date('&year_i' || '/' || '&period' || '/1',
                          'YYYY/MM/DD'))
   group by extract(year from ih.dated),
            extract(month from ih.dated),
            ih.part_no,
            ih.transaction_code) nis
    on inu.year = nis.YEAR
   and inu.period = nis.PERIOD
   and inu.part_no = nis.part_no

 inner join

 (select c.year, --Costing
         c.period,
         c.part_no,
         c.cost
    from IFSAPP.COST_PER_PART_TAB c
   where c.year = '&year_i'
     and c.period = '&period') cst
    on inu.year = cst.year
   and inu.period = cst.period
   and inu.part_no = cst.part_no
 where IFSAPP.INVENTORY_PART_API.Get_Second_Commodity('DSCP', inu.part_no) like
       'S-%'
 order by 5, 3
