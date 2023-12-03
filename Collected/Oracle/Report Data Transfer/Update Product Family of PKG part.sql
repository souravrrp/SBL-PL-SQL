--*****
select *
  from IFSAPP.sales_part_tab p
 where p.catalog_no = 'PK-SRFUR-BSWD001F-SET-1'
   and p.contract = 'SCOM';

--*****Update Product Family of PKG part
/*update IFSAPP.sales_part_tab p
   set p.part_product_family = 'FURLR'
 where p.catalog_no in ('PK-SRFUR-BASIL-SET-1',
                        'PK-SRFUR-BELO-SET-1',
                        'PK-SRFUR-BFD-SET-1',
                        'PK-SRFUR-CINNAMON-SET-1',
                        'PK-SRFUR-CINNAMON-SET-2',
                        'PK-SRFUR-JCR-SET-1',
                        'PK-SRFUR-JGR-SET-1',
                        'PK-SRFUR-JOVANA-BLACK-SET',
                        'PK-SRFUR-JOVANA-BROWN-SET',
                        'PK-SRFUR-JOVANA-COFF-SET2',
                        'PK-SRFUR-JOVANA-COFFE-SET',
                        'PK-SRFUR-JOVANA-NBLUE-SET',
                        'PK-SRFUR-JOVANA-SET-1',
                        'PK-SRFUR-JOVANA-TABS-SET2',
                        'PK-SRFUR-JOVANA-TABSC-SET',
                        'PK-SRFUR-JOVANA2-BROW-SET',
                        'PK-SRFUR-JOVANA2-COFF-SET',
                        'PK-SRFUR-JOVANA2-TABS-SET',
                        'PK-SRFUR-KELLY-SET-1',
                        'PK-SRFUR-KFD-SET-1',
                        'PK-SRFUR-LORA-SET-1',
                        'PK-SRFUR-MINT-BLACK-SET-1',
                        'PK-SRFUR-MINT-BLACK-SET-2',
                        'PK-SRFUR-MINT-COFFEE-SET1',
                        'PK-SRFUR-MINT-COFFEE-SET2',
                        'PK-SRFUR-MINT-FEBRIC-SET1',
                        'PK-SRFUR-NAPLES-BLACK-SET',
                        'PK-SRFUR-NAPLES-BROWN-SET',
                        'PK-SRFUR-NAPLES-COFFE-SET',
                        'PK-SRFUR-NAPLES-SET-1',
                        'PK-SRFUR-ONYX-SET-1',
                        'PK-SRFUR-ONYX-SET-2',
                        'PK-SRFUR-OPAL-MAHOGANY',
                        'PK-SRFUR-OPAL-TEAK-SET',
                        'PK-SRFUR-RAISIN-SET-1',
                        'PK-SRFUR-RAISIN-SET-2',
                        'PK-SRFUR-RICO-SET-1',
                        'PK-SRFUR-VIVO-SET-1',
                        'PKSRFUR-JOVANA2-COFF-SET2',
                        'PKSRFUR-JOVANA2-TABS-SET2',
                        'PKSRFUR-MINT-TABASCO-SET1',
                        'PKSRFUR-MINT-TABASCO-SET2');
commit;*/
