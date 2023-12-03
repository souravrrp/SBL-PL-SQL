--PI Sitewise Inventory Position & Cost
select t.site,
       CASE
         WHEN t.SITE IN ('SACF', 'SAVF', 'SFRF') THEN
          'Factory'
         WHEN t.SITE IN ('BSCP',
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
                         'BTSC') THEN
          'Service Center'
         WHEN t.SITE IN ('ABCW',
                         'APWH',
                         'ABWW',
                         'BACW',
                         'BBWH',
                         'BAWW',
                         'BGCW',
                         'BWHW',
                         'BGWW',
                         'CHBW',
                         'CTCW',
                         'CTGW',
                         'CTWW',
                         'CLCW',
                         'CMWH',
                         'CLWW',
                         'DWWH',
                         'FECW',
                         'FWHW',
                         'FEWW',
                         'GTCW',
                         'GWTW',
                         'GTWW',
                         'KLCW',
                         'KWHW',
                         'KHWW',
                         'MYCW',
                         'MYWH',
                         'MHWW',
                         'RHCW',
                         'RWHW',
                         'RHWW',
                         'SVCW',
                         'SWHW',
                         'SVWW',
                         'SPCW',
                         'SPWH',
                         'SDWW',
                         'SYCW',
                         'SYWH',
                         'SLWW',
                         'TUCW',
                         'TWHW',
                         'TUWW') THEN
          'Warehouse'
         ELSE
          'Branch'
       END SITE_TYPE,
       t.catalog_no,
       decode(IFSAPP.SALES_PART_API.Get_Catalog_Type(t.catalog_no),
              'PKG',
              ifsapp.INVENTORY_PRODUCT_FAMILY_API.Get_Description(ifsapp.sales_part_api.Get_Part_Product_Family(t.site,
                                                                                                                t.catalog_no)),
              ifsapp.INVENTORY_PRODUCT_FAMILY_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Family(t.site,
                                                                                                                    t.catalog_no))) product_family,
       (select p.product_group
          from PRODUCT_CATEGORY_INFO c, sbl_product_info p
         where c.group_no = p.group_no
           and c.product_code = t.catalog_no) product_group,
       t.qty_onhand,
       t.qty_in_transit,
       (t.qty_onhand + t.qty_in_transit) total_qty,
       nvl(round((select c.cost
                   from /*ifsapp.INVENT_ONLINE_COST c*/ ifsapp.COST_PER_PART_TAB c
                  where c.year = 2019
                    and c.period = 3
                    /*and c.contract = t.site*/
                    and c.part_no = t.catalog_no),
                 2),
           0) unit_cost,
       ((t.qty_onhand + t.qty_in_transit) *
       nvl(round((select c.cost
                    from /*ifsapp.INVENT_ONLINE_COST c*/ ifsapp.COST_PER_PART_TAB c
                   where c.year = 2019
                     and c.period = 3
                     /*and c.contract = t.site*/
                     and c.part_no = t.catalog_no),
                  2),
            0)) total_cost
  from ifsapp.SBL_INVENTORY_COUNTING_DTS t
 where t.qty_onhand != 0
/*and (select c.cost
 from ifsapp.COST_PER_PART_TAB c
where c.year = 2019
  and c.period = 2
  and c.part_no = t.catalog_no) is not null*/
 order by 2, 1, 4, 3
