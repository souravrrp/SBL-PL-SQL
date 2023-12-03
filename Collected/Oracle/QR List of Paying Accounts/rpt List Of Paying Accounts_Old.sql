select h.PERIOD,
       h.ACCT_NO,
       c.CUST_NAME,
       h.TEL_NO,
       h.ACT_OUT_BAL,
       h.ARR_AMT ARREAR,
       h.ARR_MON ARR_MONTH,
       h.MONTHLY_PAY INST_SIZE,
       h.SALES_DATE,
       to_char(pay.last_pay_dt, 'DD-MON-YY') Pay_dt,
       pay.New_collection,
       hm.ROWSTATE
  from IFSAPP.hpnret_form249_arrears_tab h,
       IFSAPP.HPNRET_HP_HEAD_TAB hm,
       ifsapp.sbl_cust_info c,
       (select pay_m.ACCOUNT_NO,
               max(pay_d.VOUCHER_DATE) Last_pay_dt,
               sum(pay_d.AMOUNT) New_collection
          from ifsapp.hpnret_pay_receipt_tab      pay_d,
               ifsapp.HPNRET_PAY_RECEIPT_head_TAB pay_m
         where pay_m.RECEIPT_NO = pay_d.RECEIPT_NO
           and TRUNC(pay_d.VOUCHER_DATE) between
               to_date('&START_DATE', 'DD/MM/YYYY') and
               to_date('&End_DATE', 'DD/MM/YYYY')
         group by pay_m.ACCOUNT_NO) pay
 where pay.account_no(+) = h.ACCT_NO
   and h.ACCT_NO = hm.ACCOUNT_NO
   and h.CUSTOMER = c.CUST_ID
   and
      --h.PERIOD=to_char(add_months(to_date(concat('01',substr(to_date('&START_DATE', 'DD/MM/YYYY'),3,10)),'dd/mm/yy')-1,0),'mm')*1 and
       h.PERIOD = to_char((to_date(concat('01',
                                          substr(to_char(to_date('&START_DATE',
                                                                 'DD/MM/YYYY'),
                                                         'DD/MM/YYYY'),
                                                 3,
                                                 10)),
                                   'DD/MM/YY') - 1),
                          'MM')
   and
      --h.period = extract (month from (trunc(to_date('&START_DATE', 'DD/MM/YYYY'), 'mm') - 1)) and
      --h.year=to_char(add_months(to_date(concat('01',substr(to_date('&START_DATE', 'DD/MM/YYYY'),3,10)),'dd/mm/yy')-1,0),'yyyy')*1 AND
      --h.year = extract (year from (trunc(to_date('&START_DATE', 'DD/MM/YYYY'), 'mm') - 1)) and
      --h.year= 2015 and
       h.year = to_char((to_date(concat('01',
                                        substr(to_char(to_date('&START_DATE',
                                                               'DD/MM/YYYY'),
                                                       'DD/MM/YYYY'),
                                               3,
                                               10)),
                                 'DD/MM/YY') - 1),
                        'YYYY')
   and HM.ID = C.CUST_ID
   and h.ACT_OUT_BAL > 0
   and decode('&Site', null, '1', hm.CONTRACT) =
       decode('&Site', null, '1', '&Site')
   and hm.CONTRACT in (select d.CONTRACT
                         from IFSAPP.USER_ALLOWED_SITE d
                        where d.USERID in (select ifsapp.fnd_session_api.Get_Fnd_User
                                             from dual))
 order by (substr(h.ACCT_NO, 1, 5)), to_number(substr(h.ACCT_NO, 6))
