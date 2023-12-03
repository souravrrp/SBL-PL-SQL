--***** Spare or Raw Inventory on Hand Site-wise
select i.contract,
       i.part_no,
       ifsapp.inventory_part_api.Get_Description('SCOM', i.part_no) part_desc,
       ifsapp.INVENTORY_PRODUCT_FAMILY_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Family('SCOM',
                                                                                                             i.part_no)) product_family,
       sum(i.qty_onhand) qty_onhand
  from IFSAPP.INVENTORY_PART_IN_STOCK i
 where i.qty_onhand > 0
   and ifsapp.inventory_part_api.Get_Part_Product_Family('SCOM', i.part_no) in
       ('AVRAW', 'PCB', 'RC')
   and i.part_no like '&PART_NO'
   and i.contract in ('BSCP',
                      'BLSP',
                      'CLSP',
                      'CSCP',
                      'CXSP', --New Service Center
                      'DSCP',
                      'JSCP',
                      'MSCP',
                      'RPSP', --New Service Center
                      'RSCP',
                      'SSCP',
                      'MS1C',
                      'MS2C',
                      'BTSC') --Service Sites
 group by i.contract,
          i.part_no,
          ifsapp.INVENTORY_PRODUCT_FAMILY_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Family('SCOM',
                                                                                                                i.part_no))
 ORDER BY 1, 2;


--***** Opening Balance
select t.stat_year,
       t.stat_period_no,
       t.contract,
       t.part_no,
       ifsapp.inventory_part_api.Get_Description('DSCP', t.part_no) part_desc,
       ifsapp.INVENTORY_PRODUCT_FAMILY_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Family('DSCP',
                                                                                                             t.part_no)) product_family,
       t.Cf_Balance
  from ifsapp.REP246_TAB t
 where t.stat_year = '&year_i'
   and t.stat_period_no = '&period'
      --*** All Service Sites
   and t.contract in ('BSCP',
                      'BLSP',
                      'CLSP',
                      'CSCP',
                      'CXSP', --New Service Center
                      'DSCP',
                      'MSCP', --New Service Center
                      'JSCP',
                      'RPSP', --New Service Center
                      'RSCP',
                      'SSCP',
                      'MS1C',
                      'MS2C',
                      'BTSC') --Service Sites
   and t.part_no in ('SR-PANEL-SLE19T3520TC-DPY',
                     'SW-PANEL-19E65-DISPLAY',
                     'SW-PANEL-19E57-DISPLAY',
                     'SR-PANEL-SLE20S1300TC-DPY',
                     'SR-PANEL-SLE23D1200TC-DPY',
                     'SR-PANEL-SLE24E2000AC-DPY',
                     'SR-PANEL-SLE24D1600TC-DPY',
                     'SR-PANEL-SLE24E510AC-DPY',
                     'SR-PANEL-SLE24B2500TC-DPY',
                     'SR-PANEL-SLE24D2700TC-DPY',
                     'SR-PANEL-SLE24B2820TC-DPY',
                     'SW-PANEL-24E58-DISPLAY',
                     'SW-PANEL-24E300A-DISPLAY',
                     'SR-PANEL-SLE24E3HDTV-DPY',
                     'SR-PANEL-SLE28D2700TC-DPY',
                     'SR-PANEL-SLE28D1620TC-DPY',
                     'SR-PANEL-SLE28T3520TC-DPY',
                     'SR-PANEL-SLE32D1200TC-DPY',
                     'SR-PANEL-SLE32E3SMTV-DPY',
                     'SR-PANEL-SLE32E610SC-DPY',
                     'SW-PANEL-32E360A-DISPLAY',
                     'SR-PANEL-SLE32B3700TC-DPY',
                     'SR-PANEL-SLE32E2SMTV-DPY',
                     'SR-PANEL-SLE32E3HDTV-DPY',
                     'SR-PANEL-SLE32D2700TC-DPY',
                     'SW-PANEL-32E300A-DISPLAY',
                     'SW-PANEL-32E2000-DISPLAY',
                     'SR-PANEL-SLE32D1700STC-DY',
                     'SR-PANEL-SLE32D2700STC-DY',
                     'SR-PANEL-SLE32D1680TC-DPY',
                     'SR-PANEL-SLE32A7000STC-DY',
                     'SW-PANEL-39E3100-DISPLAY',
                     'SR-PANEL-SLE40E2FHTV-DPY',
                     'SR-PANEL-SLE40E2SMTV-DPY',
                     'SR-PANEL-SLE40E3SMTV-DPY',
                     'SR-PANEL-SLE40D1620TC-DPY',
                     'SR-PANEL-SLE40E5720UDS-DY',
                     'SR-PANEL-SLE40E5800UDS-DY',
                     'SR-PANEL-SLE40D1680TC-DPY',
                     'SR-PANEL-SLE40B2820ATC-DY',
                     'SR-PANEL-SLE42D2700TC-DPY',
                     'SR-PANEL-SLE43D1570TC-DPY',
                     'SR-PANEL-SLE43D1201TC-DPY',
                     'SR-PANEL-SLE43D1800STC-DY',
                     'SR-PANEL-SLE43U5UDS-DPY',
                     'SR-PANEL-SLE43E3SMTV-DPY',
                     'SR-PANEL-SLE48D2740TC-DPY',
                     'SR-PANEL-SLE49E2SMTV-DPY',
                     'SR-PANEL-SLE49E3SMTV-DPY',
                     'SR-PANEL-SLE55E3SMTV-DPY',
                     'SR-PANEL-SLE55E2SMTV-DPY',
                     'SR-PCB-SLE19T3520TC-MAIN',
                     'SW-PCB-19E65-MAIN',
                     'SW-PCB-19E57-MAIN',
                     'SR-PCB-SLE20S1300TC-MAIN',
                     'SR-PCB-SLE23D1200TC-MAIN',
                     'SR-PCB-SLE24E2000AC-MAIN',
                     'SR-PCB-SLE24D1600TC-MAIN',
                     'SR-PCB-SLE24E510AC-MAIN',
                     'SR-PCB-SLE24B2500TC-MAIN',
                     'SR-PCB-SLE24D2700TC-MAIN',
                     'SR-PCB-SLE24B2820TC-MAIN',
                     'SW-PCB-24E58-MAIN',
                     'SW-PCB-24E300A-MAIN',
                     'SR-PCB-SLE24E3HDTV-MAIN',
                     'SR-PCB-SLE28D2700TC-MAIN',
                     'SR-PCB-SLE28D1620TC-MAIN',
                     'SR-PCB-SLE28T3520TC-MAIN',
                     'SR-PCB-SLE32D1200TC-MAIN',
                     'SR-PCB-SLE32E3SMTV-MAIN',
                     'SR-PCB-SLE32E610SC-MAIN',
                     'SW-PCB-32E360A-LOADING',
                     'SR-PCB-SLE32B3700TC-MAIN',
                     'SR-PCB-SLE32E2SMTV-MAIN',
                     'SR-PCB-SLE32E3HDTV-MAIN',
                     'SR-PCB-SLE32D2700TC-MAIN',
                     'SW-PCB-32E300A-MAIN',
                     'SW-PCB-32E2000-MAIN',
                     'SR-PCB-SLE32D1700STC-MAIN',
                     'SR-PCB-SLE32D2700STC-MAIN',
                     'SR-PCB-SLE32D1680TC-MAIN',
                     'SR-PCB-SLE32A7000STC-MAIN',
                     'SW-PCB-39E3100-MAIN',
                     'SR-PCB-SLE40E2FHTV-MAIN',
                     'SR-PCB-SLE40E2SMTV-MAIN',
                     'SR-PCB-SLE40E3SMTV-MAIN',
                     'SR-PCB-SLE40D1620TC-MAIN',
                     'SR-PCB-SLE40E5720UDS-MAIN',
                     'SR-PCB-SLE40E5800UDS-MAIN',
                     'SR-PCB-SLE40D1680TC-MAIN',
                     'SR-PCB-SLE40B2820ATC-MAIN',
                     'SR-PCB-SLE42D2700TC-MAIN',
                     'SR-PCB-SLE43D1570TC-MAIN',
                     'SR-PCB-SLE43D1201TC-MAIN',
                     'SR-PCB-SLE43D1800STC-MAIN',
                     'SR-PCB-SLE43U5UDS-MAIN',
                     'SR-PCB-SLE43E3SMTV-MAIN',
                     'SR-PCB-SLE48D2740TC-MAIN',
                     'SR-PCB-SLE49E2SMTV-MAIN',
                     'SR-PCB-SLE49E3SMTV-MAIN',
                     'SR-PCB-SLE55E3SMTV-MAIN',
                     'SR-PCB-SLE55E2SMTV-MAIN',
                     'SW-PCB-19E65-POWER',
                     'SW-PCB-19E57-POWER',
                     'SW-PCB-24E58-POWER',
                     'SR-PCB-SLE28T3520TC-POWER',
                     'SR-PCB-SLE40E5800UDS-POWR',
                     'SR-PCB-SLE40B2820ATC-POWR',
                     'SR-PCB-SLE43U5UDS-POWER',
                     'SR-PCB-SLE43E3SMTV-POWER',
                     'SR-PCB-SLE48D2740TC-POWER',
                     'SR-PCB-SLE49E2SMTV-POWER',
                     'SR-PCB-SLE55E3SMTV-POWER',
                     'SR-PCB-SLE55E2SMTV-POWER')
 order by t.stat_year, t.stat_period_no, t.contract, t.part_no;
