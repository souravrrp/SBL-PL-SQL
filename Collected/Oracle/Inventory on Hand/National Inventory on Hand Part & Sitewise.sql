--National Inventory Part & Sitewise
select i.contract,
       i.part_no,
       p.product_family,
       p.brand,
       sum(i.qty_onhand) qty_onhand,
       /*sum(i.qty_reserved) qty_reserved,
       sum(i.qty_in_transit) qty_in_transit*/
       (SELECT T.SALE_PRICE_NSP
          from IFSAPP.SBL_LATEST_PRICE_LIST T
         where T.PRICE_LIST_NO = '1'
           and T.SALE_PART_NO = I.part_no) UNIT_NSP,
       sum(i.qty_onhand) *
       (SELECT T.SALE_PRICE_NSP
          from IFSAPP.SBL_LATEST_PRICE_LIST T
         where T.PRICE_LIST_NO = '1'
           and T.SALE_PART_NO = I.part_no) TOTAL_NSP
  from IFSAPP.INVENTORY_PART_IN_STOCK i
 inner join IFSAPP.SBL_JR_PRODUCT_DTL_INFO p
    on i.part_no = p.product_code
 where (i.qty_onhand > 0 or i.qty_reserved > 0 or i.qty_in_transit > 0)
   and ifsapp.inventory_part_api.Get_Part_Product_Family(i.contract,
                                                         i.part_no) not in
       ('RBOOK', 'GIFT VOUCHER')
   and ifsapp.inventory_part_api.Get_Part_Product_Code(i.contract,
                                                       i.part_no) != 'RAW' /*'PLS'*/
   and ifsapp.inventory_part_api.Get_Second_Commodity(i.contract, i.part_no) not like
       'S-%'
   /*and i.contract \*LIKE '&SITE'*\
       in (select w.ware_house_name
             from IFSAPP.WARE_HOUSE_INFO w
            where w.ware_house_name \*not*\ like '%WW'
              \*AND*\ or
                  w.ware_house_name \*!*\= 'DWWH'
              \*and w.ware_house_name not like '%CW'*\)*/
   /*and i.part_no like '%REF-%'*/ /*'&PART_NO'*/
/*in ('SRFUR-AUDI-7201B(DOW3)',
'SRFUR-AUDI-7202B(DOW3)',
'SRFUR-AUDI-7205B(DOW3)',
'SRFUR-AUDI-7210B(DOW3)',
'SRFUR-BT-STUDY-SET(BLUE)',
'SRFUR-CUBE-12(DOW)',
'SRFUR-CUBE-6(DOW)',
'SRFUR-HM-BS9019B(WN2)',
'SRFUR-HM-CS805(FT)',
'SRFUR-HM-WB820T(FT)',
'SRFUR-HM-WB830(FT)',
'SRFUR-IZ-BC900(PN01)',
'SRFUR-IZ-SK1700(PN01)',
'SRFUR-JA-124-2B(WN2)',
'SRFUR-JA-124B(WN2)',
'SRFUR-JA-20B(WN2)',
'SRFUR-JA-24B(WN2)',
'SRFUR-K-158B(MP)',
'SRFUR-K-159B(MP)',
'SRFUR-KM-1510PB-(DOW)',
'SRFUR-KM-2S-HB(DOW)',
'SRFUR-KM-33S(DO)-CK',
'SRFUR-KM-4000(DO)',
'SRFUR-LA-BK1820(MP)',
'SRFUR-LA-BQ1620(MP)',
'SRFUR-LA-BS475(MP)',
'SRFUR-LA-DS800(MP)',
'SRFUR-LA-WB820(MP)',
'SRFUR-LA-WB830(MP)',
'SRFUR-MAF-118/SF(CH)',
'SRFUR-ND-6500B(DOW)',
'SRFUR-PC-3600B(WN2)',
'SRFUR-SM-BS430(DOW3)',
'SRFUR-SM-CS800(DOW3)',
'SRFUR-SM-DT1000(DOW3)',
'SRFUR-TECKNO-006B(CH7)',
'SRFUR-TECKNO-012B(CH7)',
'SRFUR-TECKNO-013B(CH7)',
'SRFUR-TZ-BC1802(2T05)',
'SRFUR-TZ-COF1202(2T05)',
'SRFUR-TZ-SK1702(2T05)')*/
 group by i.contract, I.part_no, p.product_family, p.brand
 ORDER BY 1, 3, /*4,*/ 2

--Imported Furniture List
/*
'SRFUR-AUDI-7201B(DOW3)',
'SRFUR-AUDI-7202B(DOW3)',
'SRFUR-AUDI-7205B(DOW3)',
'SRFUR-AUDI-7210B(DOW3)',
'SRFUR-BT-STUDY-SET(BLUE)',
'SRFUR-CUBE-12(DOW)',
'SRFUR-CUBE-6(DOW)',
'SRFUR-HM-BS9019B(WN2)',
'SRFUR-HM-CS805(FT)',
'SRFUR-HM-WB820T(FT)',
'SRFUR-HM-WB830(FT)',
'SRFUR-IZ-BC900(PN01)',
'SRFUR-IZ-SK1700(PN01)',
'SRFUR-JA-124-2B(WN2)',
'SRFUR-JA-124B(WN2)',
'SRFUR-JA-20B(WN2)',
'SRFUR-JA-24B(WN2)',
'SRFUR-K-158B(MP)',
'SRFUR-K-159B(MP)',
'SRFUR-KM-1510PB-(DOW)',
'SRFUR-KM-2S-HB(DOW)',
'SRFUR-KM-33S(DO)-CK',
'SRFUR-KM-4000(DO)',
'SRFUR-LA-BK1820(MP)',
'SRFUR-LA-BQ1620(MP)',
'SRFUR-LA-BS475(MP)',
'SRFUR-LA-DS800(MP)',
'SRFUR-LA-WB820(MP)',
'SRFUR-LA-WB830(MP)',
'SRFUR-MAF-118/SF(CH)',
'SRFUR-ND-6500B(DOW)',
'SRFUR-PC-3600B(WN2)',
'SRFUR-SM-BS430(DOW3)',
'SRFUR-SM-CS800(DOW3)',
'SRFUR-SM-DT1000(DOW3)',
'SRFUR-TECKNO-006B(CH7)',
'SRFUR-TECKNO-012B(CH7)',
'SRFUR-TECKNO-013B(CH7)',
'SRFUR-TZ-BC1802(2T05)',
'SRFUR-TZ-COF1202(2T05)',
'SRFUR-TZ-SK1702(2T05)'
*/
