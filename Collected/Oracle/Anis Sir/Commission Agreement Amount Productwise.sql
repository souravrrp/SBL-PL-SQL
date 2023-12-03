--Productwise Commission Agreement Amount (Commission Sales Type)
select c.agreement_id,
       c.catalog_no,
       c.commission_sales_type,
       c.location_no, --normal, consignment, blank
       c.valid_from,
       c.valid_to,
       c.amount
  from COMMISSION_AGREE_LINE_TAB c
 where c.AGREEMENT_ID = 'SP_SC_RTL'
   and c.COMMISSION_SALES_TYPE = 'CASH'
   and c.VALID_FROM =
       (select max(VALID_FROM)
          from ifsapp.commission_agree_line_tab cc
         where cc.AGREEMENT_ID = 'SP_SC_RTL'
           and cc.CATALOG_NO = c.CATALOG_NO
           and cc.COMMISSION_SALES_TYPE = 'CASH'
           and cc.valid_from < to_date('&valid_date', 'YYYY/MM/DD'))
 order by c.catalog_no
