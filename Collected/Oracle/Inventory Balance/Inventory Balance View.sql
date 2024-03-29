select t.year,
       t.period,
       t.site,
       t.location,
       t.part_no,
       t.open_bal,
       t.receipts,
       t.issues,
       t.closing_bal,
       t.cost,
       t.inv_value,
       t.net_sales_units,
       t.net_cos,
       t.cum_inv_value,
       t.cum_net_cos,
       t.product_family,
       t.product_line,
       t.in_transit,
       t.objid,
       t.objversion
  from IFSAPP.INVENTORY_BALANCE t
 where t.year = '&year_i'
   and t.period = '&period' 
   /*and t.site like '&site' 
   and t.part_no like '&part_no'*/
   /*and IFSAPP.PART_CATALOG_API.Get_Serial_Tracking_Code(t.part_no) <> 'Serial Tracking'*/
   --and t.in_transit > 0
 order by t.site, t.part_no
