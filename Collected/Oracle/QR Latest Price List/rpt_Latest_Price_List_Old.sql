select t.CATALOG_NO SALE_PART_NO,
       to_char(t.VALID_FROM_DATE, 'YYYY/MM/DD') VALID_FROM_DATE,
       t.SALES_PRICE SALE_PRICE_NSP,
       f.FEE_CODE TAX_NAME,
       f.FEE_RATE TAX_RATE,
       nvl((select d.amount
             from ifsapp.SBL_DISCOUNT_PROMOTION d
            where sysdate between d.valid_from and d.valid_to
              and d.t_line_no = 1
              and d.part_no = t.catalog_no),
           0) co_discount,
       nvl((select d.amount
             from ifsapp.SBL_DISCOUNT_PROMOTION d
            where sysdate between d.valid_from and d.valid_to
              and d.t_line_no = 16
              and d.part_no = t.catalog_no),
           0) hp_discount,
       (select d.channel
             from ifsapp.SBL_DISCOUNT_PROMOTION d
            where sysdate between d.valid_from and d.valid_to
              and d.t_line_no = 1
              and d.part_no = t.catalog_no) co_discount_channel,
       (select d.channel
             from ifsapp.SBL_DISCOUNT_PROMOTION d
            where sysdate between d.valid_from and d.valid_to
              and d.t_line_no = 16
              and d.part_no = t.catalog_no) hp_discount_channel,
       t.SALES_PRICE + round(t.SALES_PRICE * (f.FEE_RATE / 100), 2) - nvl((select d.amount
             from ifsapp.SBL_DISCOUNT_PROMOTION d
            where sysdate between d.valid_from and d.valid_to
              and d.t_line_no = 1
              and d.part_no = t.catalog_no),
           0) CASH_PRICE,
       t.SALES_PRICE + round(t.SALES_PRICE * (f.FEE_RATE / 100), 2) - nvl((select d.amount
             from ifsapp.SBL_DISCOUNT_PROMOTION d
            where sysdate between d.valid_from and d.valid_to
              and d.t_line_no = 16
              and d.part_no = t.catalog_no),
           0) HIRE_CASH_PRICE,
       NVL((select DISTINCT c.AMOUNT
          from ifsapp.commission_agree_line_tab c
         where c.AGREEMENT_ID = 'SP_SC_RTL'
           and c.CATALOG_NO = t.CATALOG_NO
           and c.COMMISSION_SALES_TYPE = 'CASH'
           and c.VALID_FROM =
               (select max(VALID_FROM)
                  from ifsapp.commission_agree_line_tab cc
                 where cc.AGREEMENT_ID = 'SP_SC_RTL'
                   and cc.CATALOG_NO = c.CATALOG_NO
                   and cc.COMMISSION_SALES_TYPE = 'CASH')), 0) CASH_COMISSION,       
       NVL((select DISTINCT ct.AMOUNT
          from ifsapp.commission_agree_line_tab ct
         where ct.AGREEMENT_ID = 'SP_SC_RTL'
           and ct.CATALOG_NO = t.CATALOG_NO
           and ct.COMMISSION_SALES_TYPE = 'HP'
           and ct.VALID_FROM =
               (select max(VALID_FROM)
                  from ifsapp.commission_agree_line_tab ch
                 where ch.AGREEMENT_ID = 'SP_SC_RTL'
                   and ch.CATALOG_NO = ct.CATALOG_NO
                   and ch.COMMISSION_SALES_TYPE = 'HP')), 0) HP_COMISSION
  FROM ifsapp.SALES_PRICE_LIST_PART_TAB t, IFSAPP.statutory_fee_tab f
 where t.CASH_TAX_CODE = f.FEE_CODE
   and t.PRICE_LIST_NO = '&PRICE_LIST_NO'   
   and t.VALID_FROM_DATE =
       (select max(s.VALID_FROM_DATE)
          from ifsapp.SALES_PRICE_LIST_PART_TAB s
         where s.CATALOG_NO = t.CATALOG_NO
         and t.valid_from_date <= sysdate
           and s.PRICE_LIST_NO = '&PRICE_LIST_NO'
           and s.CATALOG_NO like '%&CATALOG_NO%')
