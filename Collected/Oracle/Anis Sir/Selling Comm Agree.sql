select ct.agreement_id,
       ct.revision_no,
       ct.catalog_no,
       ct.commission_sales_type,
       ct.entitlement_type,
       ct.line_user_id,
       ct.amount,
       ct.location_no,
       ct.valid_from,
       ct.valid_to
  from COMMISSION_AGREE_LINE_TAB ct
 where ct.AGREEMENT_ID = 'SP_SC_RTL'
   and ct.CATALOG_NO like '&part_no'
   and ct.COMMISSION_SALES_TYPE = 'CASH'
   and ct.valid_from =
       (select max(VALID_FROM)
          from ifsapp.commission_agree_line_tab ch
         where ch.AGREEMENT_ID = 'SP_SC_RTL'
           and ch.CATALOG_NO = ct.CATALOG_NO
           and ch.COMMISSION_SALES_TYPE = 'CASH')
