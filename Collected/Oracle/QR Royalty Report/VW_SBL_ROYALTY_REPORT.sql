create or replace view SBL_ROYALTY_REPORT as
select extract(year from i.invoice_date) "YEAR",
       extract(month from i.invoice_date) period,
       t.c5 PRODUCT_CODE,
       IFSAPP.INVENTORY_PRODUCT_CODE_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Code('SCOM',
                                                                                                         t.c5)) brand,
       ifsapp.INVENTORY_PRODUCT_FAMILY_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Family('SCOM',
                                                                                                             t.c5)) product_family,
       IFSAPP.SALES_GROUP_API.Get_Description(IFSAPP.SALES_PART_API.Get_Catalog_Group('SCOM',
                                                                                      t.c5)) sales_group,
       sum(case
             when t.net_curr_amount != 0 then
              t.n2 * (t.net_curr_amount / abs(t.net_curr_amount))
             else
              t.n2
           end) TOTAL_SALES_QUANTITY,
       SUM(t.net_curr_amount) TOTAL_SALES_PRICE,
       SUM(case
             when t.net_curr_amount != 0 then
              (select l.base_sale_unit_price
                 from IFSAPP.CUSTOMER_ORDER_LINE l
                where l.order_no = t.c1
                  and l.line_no = t.c2
                  and l.rel_no = t.c3
                  and l.catalog_no = t.c5) *
              (t.net_curr_amount / abs(t.net_curr_amount))
             else
              (select l.base_sale_unit_price
                 from IFSAPP.CUSTOMER_ORDER_LINE l
                where l.order_no = t.c1
                  and l.line_no = t.c2
                  and l.rel_no = t.c3
                  and l.catalog_no = t.c5)
           end) TOTAL_NSP,
       SUM((case
             when t.net_curr_amount != 0 then
              (select l.base_sale_unit_price
                 from IFSAPP.CUSTOMER_ORDER_LINE l
                where l.order_no = t.c1
                  and l.line_no = t.c2
                  and l.rel_no = t.c3
                  and l.catalog_no = t.c5) *
              (t.net_curr_amount / abs(t.net_curr_amount))
             else
              (select l.base_sale_unit_price
                 from IFSAPP.CUSTOMER_ORDER_LINE l
                where l.order_no = t.c1
                  and l.line_no = t.c2
                  and l.rel_no = t.c3
                  and l.catalog_no = t.c5)
           end) - t.net_curr_amount) TOTAL_DISCOUNT,
       SUM(t.vat_curr_amount) TOTAL_VAT,
       SUM(t.net_curr_amount + t.vat_curr_amount) TOTAL_RSP
  from ifsapp.invoice_item_tab t, ifsapp.INVOICE_TAB i
 where t.invoice_id = i.invoice_id
   and t.creator = 'CUSTOMER_ORDER_INV_ITEM_API'
   and t.rowstate = 'Posted'
   and IFSAPP.SALES_PART_API.Get_Catalog_Type(T.C5) in
       ('INV', 'PKG', 'NON')
   /*and i.invoice_date between to_date('&from_date', 'yyyy/mm/dd') and
       to_date('&to_date', 'yyyy/mm/dd')*/
   and t.net_curr_amount != 0
   AND (IFSAPP.SALES_GROUP_API.Get_Description(IFSAPP.SALES_PART_API.Get_Catalog_Group('SCOM',
                                                                                       t.c5)) =
       'SINGER-FURNITURE' or T.C5 IN (SELECT R.CATALOG_NO FROM IFSAPP.SBL_ROYALTY_CATALOG_NO R))
 GROUP BY t.c5,
          extract(year from i.invoice_date),
          extract(month from i.invoice_date),
          IFSAPP.INVENTORY_PRODUCT_CODE_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Code('SCOM',
                                                                                                            t.c5)),
          ifsapp.INVENTORY_PRODUCT_FAMILY_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Family('SCOM',
                                                                                                                t.c5)),
          IFSAPP.SALES_GROUP_API.Get_Description(IFSAPP.SALES_PART_API.Get_Catalog_Group('SCOM',
                                                                                         t.c5))
 order by 4, 5, 6, t.c5

/*'SRFUR-BCCT002F',
'SRFUR-BCMG003F',
'SRFUR-BCOK001F',
'SRFUR-BCPT001F',
'SRFUR-BCWD001F',
'SRFUR-BCWD002F',
'SRFUR-BDCT002F',
'SRFUR-BDMG003F',
'SRFUR-BDOK001F',
'SRFUR-BDPT001F',
'SRFUR-BDWD001F',
'SRFUR-BDWD002F',
'SRFUR-BDWD003F',
'SRFUR-BDWD004F',
'SRFUR-BELO-FD101',
'SRFUR-BELO-FD201',
'SRFUR-BELO-FS101',
'SRFUR-BFD201F',
'SRFUR-BFS101F',
'SRFUR-BKCT002F',
'SRFUR-BKMG003F',
'SRFUR-BKOK001F',
'SRFUR-BKPT001F',
'SRFUR-BKSMG001F',
'SRFUR-BKSMG002F',
'SRFUR-BKSPT001F',
'SRFUR-BKSPT002F',
'SRFUR-BKWD001F',
'SRFUR-BKWD002F',
'SRFUR-BKWD003F',
'SRFUR-BSCT002F',
'SRFUR-BSMG003F',
'SRFUR-BSPT001F',
'SRFUR-CBCT002F',
'SRFUR-CBMG001F',
'SRFUR-CBMG003F',
'SRFUR-CBMG004F',
'SRFUR-CBMG005F',
'SRFUR-CBMG006F',
'SRFUR-CBOK001F',
'SRFUR-CBOK003F',
'SRFUR-CBOK005F',
'SRFUR-CBOK006F',
'SRFUR-CBPT001F',
'SRFUR-CBPT003F',
'SRFUR-CBPT004F',
'SRFUR-CBPT005F',
'SRFUR-CBPT006F',
'SRFUR-CBWD001F',
'SRFUR-CBWD002F',
'SRFUR-CDCT002F',
'SRFUR-CDMG003F',
'SRFUR-CDOK001F',
'SRFUR-CDPT001F',
'SRFUR-CDWD001F',
'SRFUR-CDWD002F',
'SRFUR-CHF001F',
'SRFUR-CHF002F',
'SRFUR-CHFTK002F',
'SRFUR-CT101F',
'SRFUR-CT102F',
'SRFUR-CT103F',
'SRFUR-CT104F',
'SRFUR-CT105F',
'SRFUR-CT106F',
'SRFUR-CT107F',
'SRFUR-CT108F',
'SRFUR-CTJ1190',
'SRFUR-CTJ1308',
'SRFUR-DIV001F',
'SRFUR-DSMG001F',
'SRFUR-DSMG002F',
'SRFUR-DSPT001F',
'SRFUR-DSPT002F',
'SRFUR-DTCT002F',
'SRFUR-DTMG003F',
'SRFUR-DTOK001F',
'SRFUR-DTPT001F',
'SRFUR-DTWD001F',
'SRFUR-DTWD002F',
'SRFUR-IRON-STAND',
'SRFUR-JBR101F',
'SRFUR-JBR201F',
'SRFUR-JBRR101F',
'SRFUR-JBRR201F',
'SRFUR-JCR101F',
'SRFUR-JCR201F',
'SRFUR-JGR101F',
'SRFUR-JGR201F',
'SRFUR-JNBR101F',
'SRFUR-JNBR201F',
'SRFUR-JOVANA-RD-201',
'SRFUR-JOVANA-RS-101',
'SRFUR-JTR101F',
'SRFUR-JTR201F',
'SRFUR-KELLY-FD-201',
'SRFUR-KELLY-FS-101',
'SRFUR-KFD101F',
'SRFUR-KFD201F',
'SRFUR-LFD201F',
'SRFUR-LFS101F',
'SRFUR-LSJ1182',
'SRFUR-LSJ1184',
'SRFUR-LSJ1185',
'SRFUR-LSJ1186',
'SRFUR-NAPLES-BR-1',
'SRFUR-NAPLES-BR-2',
'SRFUR-NBR101F',
'SRFUR-NBR201F',
'SRFUR-NBRR101F',
'SRFUR-NBRR201F',
'SRFUR-NCR101F',
'SRFUR-NCR201F',
'SRFUR-ODTK201F',
'SRFUR-OSTK101F',
'SRFUR-OXD201F',
'SRFUR-OXS101F',
'SRFUR-RCLB001F',
'SRFUR-RDWD201F',
'SRFUR-RSWD101F',
'SRFUR-RTLB001F',
'SRFUR-SDBRR002F',
'SRFUR-SDCR002F',
'SRFUR-SDF002F',
'SRFUR-SRMG001F',
'SRFUR-SRMG002F',
'SRFUR-SRMG003F',
'SRFUR-SRPT001F',
'SRFUR-SRPT002F',
'SRFUR-SRPT003F',
'SRFUR-SSBRR001F',
'SRFUR-SSCR001F',
'SRFUR-SSF001F',
'SRFUR-SSTR001F',
'SRFUR-SSTR002F',
'SRFUR-TCMG001F',
'SRFUR-TCPT001F',
'SRFUR-TD001F',
'SRFUR-TD002F',
'SRFUR-TDTK002F',
'SRFUR-TJ1304',
'SRFUR-TJ1306',
'SRFUR-TRMG001F',
'SRFUR-TRPT001F',
'SRFUR-VDWD201F',
'SRFUR-VSWD101F',*/
/*'PK-SRFUR-BELO-SET-1',
'PK-SRFUR-BFD-SET-1',
'PK-SRFUR-CINNAMON-SET-1',
'PK-SRFUR-KELLY-SET-1',
'PK-SRFUR-KFD-SET-1',
'PK-SRFUR-LORA-SET-1',
'PK-SRFUR-NAPLES-SET-1',
'PK-SRFUR-RICO-SET-1',
'PK-SRFUR-STDT001F-SET-1',
'PK-SRFUR-STDT002F-SET-1',
'PK-SRFUR-VIVO-SET-1'*/
