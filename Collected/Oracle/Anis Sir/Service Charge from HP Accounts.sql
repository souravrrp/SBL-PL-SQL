--Service Charge from HP Accounts
select t.c10             shop_code,
       t.c1              account_no,
       i.invoice_date    sales_date,
       t.c5              item,
       t.net_curr_amount charge_amount,
       t.c2,
       t.c3,
       t.c4,
       t.n1,
       t.invoice_id,
       t.item_id
  from ifsapp.invoice_item_tab t, ifsapp.INVOICE_TAB i
 where t.invoice_id = i.invoice_id
   and t.creator = 'CUSTOMER_ORDER_INV_ITEM_API'
   and t.rowstate = 'Posted'
   and t.c5 = 'SERVICE CHARGE' /*'UCC'*/
      /*and t.c10 like '&shop_code'*/
   and i.invoice_date between to_date('&from_date', 'yyyy/mm/dd') and
       to_date('&to_date', 'yyyy/mm/dd')
   and substr(t.c1, 4, 2) = '-H' --'DUT-H8987'
/*and ifsapp.hpnret_hp_head_api.Get_Budget_Book_Id(t.c1, 1) = 'SP-27'*/
/*and t.net_curr_amount > 0
and t.c1 in ('ABD-H15866',
             'AKH-H4276',
             'AKP-H2684',
             'BBZ-H5544',
             'BCM-H4069',
             'BFH-H3202',
             'BGR-H2214',
             'BKA-H4171',
             'BKA-H4249',
             'BKA-H4278',
             'BKA-H4289',
             'BLK-H4402',
             'BLK-H4406',
             'BLM-H3579',
             'BLM-H3581',
             'BLM-H3586',
             'BNG-H3977',
             'BNG-H4022',
             'BRB-H4946',
             'BSG-H4020',
             'BSP-H6771',
             'CAG-H4105',
             'CBB-H8863',
             'CBB-H8959',
             'CBK-H2291',
             'CBO-H562',
             'CBO-H593',
             'CBY-H7324',
             'CBY-H7354',
             'CCB-H13234',
             'CCB-H13373',
             'CCB-H13414',
             'CCB-H13430',
             'CCG-H6427',
             'CCK-H8652',
             'CCK-H8653',
             'CCK-H8733',
             'CCK-H8740',
             'CCK-H8793',
             'CCK-H8806',
             'CDG-H3463',
             'CDG-H3527',
             'CDR-H7736',
             'CDR-H7745',
             'CEG-H5796',
             'CEG-H5801',
             'CEG-H5830',
             'CFT-H2776',
             'CHU-H6300',
             'CHU-H6341',
             'CJN-H2219',
             'CJT-H5497',
             'CKR-H6380',
             'CMM-H4978',
             'CMS-H4662',
             'CMT-H2151',
             'CMT-H2159',
             'COT-H4017',
             'CPK-H682',
             'CPK-H698',
             'CPT-H4037',
             'CPT-H4836',
             'CPT-H4855',
             'CPZ-H5621',
             'CPZ-H5685',
             'CRJ-H2238',
             'CRJ-H2253',
             'CRM-H542',
             'CRM-H543',
             'CTM-H10508',
             'CTN-H9372',
             'CTN-H9397',
             'CXN-H6161',
             'CXN-H6169',
             'DAS-H3065',
             'DBA-H6858',
             'DBL-H3531',
             'DBS-H4322',
             'DDK-H6070',
             'DGN-H10056',
             'DGN-H9940',
             'DGN-H9952',
             'DHM-H2729',
             'DHP-H7581',
             'DHZ-H8444',
             'DHZ-H8451',
             'DHZ-H8495',
             'DKB-H7310',
             'DMA-H3452',
             'DMA-H3527',
             'DMM-H3938',
             'DNJ-H6198',
             'DPL-H8512',
             'DPL-H8540',
             'DRJ-H1714',
             'DRR-H4101',
             'DRS-H5122',
             'DRS-H5150',
             'DSG-H2666',
             'DSK-H6054',
             'DSK-H6128',
             'DSN-H1941',
             'DSQ-H892',
             'DSQ-H961',
             'DSY-H7632',
             'DTB-H9398',
             'DUC-H2280',
             'DUC-H2295',
             'FEN-H6479',
             'FGQ-H3803',
             'FGQ-H3893',
             'FLP-H4908',
             'FLP-H4953',
             'FSG-H2612',
             'GKB-H9354',
             'GKB-H9565',
             'GMC-H4308',
             'GRP-H7285',
             'GRP-H7400',
             'HAT-H4285',
             'HBJ-H4948',
             'HNJ-H3069',
             'ISD-H5006',
             'JDP-H4183',
             'JKP-H3423',
             'KAL-H4777',
             'KER-H8250',
             'KHC-H605',
             'KHL-H12612',
             'KHL-H12615',
             'KHL-H12760',
             'KHL-H12799',
             'KPG-H6161',
             'KPG-H6171',
             'KPG-H6172',
             'KPG-H6223',
             'KPP-H3544',
             'KRG-H3943',
             'KRL-H6843',
             'KTA-H6912',
             'KTN-H6197',
             'KTN-H6209',
             'KUL-H7416',
             'KUL-H7458',
             'KUL-H7475',
             'KUR-H4100',
             'LMH-H3359',
             'LMH-H3415',
             'MBG-H2822',
             'MFB-H4168',
             'MFB-H4180',
             'MGR-H5127',
             'MHD-H7499',
             'MHD-H7504',
             'MLJ-H2725',
             'NAG-H6065',
             'NAG-H6166',
             'NAG-H6167',
             'NAG-H6169',
             'NAG-H6186',
             'NAG-H6187',
             'NAO-H7709',
             'NAO-H7750',
             'NBR-H4730',
             'NDB-H6022',
             'NDB-H6114',
             'NDB-H6187',
             'NGJ-H12526',
             'NKP-H9758',
             'NMG-H163',
             'NNP-H6742',
             'NPR-H6348',
             'NPZ-H4267',
             'NPZ-H4374',
             'NRL-H5355',
             'NSD-H4396',
             'NSH-H2854',
             'NVN-H703',
             'NVN-H745',
             'PSR-H3326',
             'PTY-H8265',
             'RAJ-H7883',
             'RBP-H3973',
             'RKH-H3171',
             'RPT-H5332',
             'RPT-H5333',
             'RSB-H4076',
             'RSB-H4118',
             'RSB-H4147',
             'RUH-H10784',
             'SBG-H3447',
             'SBI-H4008',
             'SCH-H3028',
             'SCH-H3029',
             'SCH-H3030',
             'SCT-H4548',
             'SCT-H4549',
             'SCT-H4560',
             'SDM-H9050',
             'SDM-H9051',
             'SDM-H9052',
             'SDM-H9053',
             'SDM-H9054',
             'SDM-H9055',
             'SDS-H3751',
             'SFI-H10040',
             'SFI-H10340',
             'SFI-H10344',
             'SFI-H10491',
             'SGB-H4269',
             'SGB-H4290',
             'SGS-H7519',
             'SGS-H7521',
             'SGS-H7522',
             'SGS-H7569',
             'SHA-H4544',
             'SHB-H3231',
             'SHB-H3299',
             'SIP-H6993',
             'SIP-H6994',
             'SIP-H7146',
             'SMM-H3873',
             'SNG-H8327',
             'SRC-H2197',
             'STA-H6658',
             'STA-H6707',
             'TEK-H6398',
             'TGL-H5084',
             'TGN-H2229',
             'TGR-H182',
             'TKG-H7659',
             'TMR-H6881',
             'TON-H12582')*/
 order by 2, 3