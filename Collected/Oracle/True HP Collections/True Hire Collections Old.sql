  select c.contract,
         c.account_no,
         c.original_acc_no,
         c.receipt_no,
         c.amount amount,
         c.payment_date,
         c.pay_method,
         c.rowstate    
    from ifsapp.SBL_COLLECTION_INFO c
   where c.payment_date between to_date('&from_date', 'YYYY/MM/DD') and to_date('&to_date', 'YYYY/MM/DD') 
     and c.contract like '&site'
     and c.account_no in (select th.acct_no from sbl_hire_list_2014 th)
                            /*(SELECT distinct(v.acct_no)
                            from (SELECT h.YEAR,
                                         h.PERIOD,
                                         h.acct_no,
                                         h.sales_date
                                    from IFSAPP.hpnret_form249_arrears_tab h
                                   where H.YEAR = 2014
                                     AND H.PERIOD = 1
                                     AND H.ACT_OUT_BAL > 0
                                     and h.sales_date <= to_date('2014/12/31', 'YYYY/MM/DD')
                                     and h.cash_conversion_on_date < to_date('2014/1/31', 'YYYY/MM/DD')

                                UNION

                                  SELECT h.YEAR,
                                         h.PERIOD,
                                         h.acct_no,
                                         h.sales_date
                                    from IFSAPP.hpnret_form249_arrears_tab h
                                   where H.YEAR = 2014
                                     AND H.PERIOD = 2
                                     AND H.ACT_OUT_BAL > 0
                                     and h.sales_date <= to_date('2014/12/31', 'YYYY/MM/DD')
                                     and h.cash_conversion_on_date < to_date('2014/2/28', 'YYYY/MM/DD')

                                UNION

                                  SELECT h.YEAR,
                                         h.PERIOD,
                                         h.acct_no,
                                         h.sales_date
                                    from IFSAPP.hpnret_form249_arrears_tab h
                                   where H.YEAR = 2014
                                     AND H.PERIOD = 3
                                     AND H.ACT_OUT_BAL > 0
                                     and h.sales_date <= to_date('2014/12/31', 'YYYY/MM/DD')
                                     and h.cash_conversion_on_date < to_date('2014/3/31', 'YYYY/MM/DD')

                                UNION

                                  SELECT h.YEAR,
                                         h.PERIOD,
                                         h.acct_no,
                                         h.sales_date
                                    from IFSAPP.hpnret_form249_arrears_tab h
                                   where H.YEAR = 2014
                                     AND H.PERIOD = 4
                                     AND H.ACT_OUT_BAL > 0
                                     and h.sales_date <= to_date('2014/12/31', 'YYYY/MM/DD')
                                     and h.cash_conversion_on_date < to_date('2014/4/30', 'YYYY/MM/DD')

                                UNION

                                  SELECT h.YEAR,
                                         h.PERIOD,
                                         h.acct_no,
                                         h.sales_date
                                    from IFSAPP.hpnret_form249_arrears_tab h
                                   where H.YEAR = 2014
                                     AND H.PERIOD = 5
                                     AND H.ACT_OUT_BAL > 0
                                     and h.sales_date <= to_date('2014/12/31', 'YYYY/MM/DD')
                                     and h.cash_conversion_on_date < to_date('2014/5/31', 'YYYY/MM/DD')

                                UNION

                                  SELECT h.YEAR,
                                         h.PERIOD,
                                         h.acct_no,
                                         h.sales_date
                                    from IFSAPP.hpnret_form249_arrears_tab h
                                   where H.YEAR = 2014
                                     AND H.PERIOD = 6
                                     AND H.ACT_OUT_BAL > 0
                                     and h.sales_date <= to_date('2014/12/31', 'YYYY/MM/DD')
                                     and h.cash_conversion_on_date < to_date('2014/6/30', 'YYYY/MM/DD')

                                UNION

                                  SELECT h.YEAR,
                                         h.PERIOD,
                                         h.acct_no,
                                         h.sales_date
                                    from IFSAPP.hpnret_form249_arrears_tab h
                                   where H.YEAR = 2014
                                     AND H.PERIOD = 7
                                     AND H.ACT_OUT_BAL > 0
                                     and h.sales_date <= to_date('2014/12/31', 'YYYY/MM/DD')
                                     and h.cash_conversion_on_date < to_date('2014/7/31', 'YYYY/MM/DD')

                                UNION

                                  SELECT h.YEAR,
                                         h.PERIOD,
                                         h.acct_no,
                                         h.sales_date
                                    from IFSAPP.hpnret_form249_arrears_tab h
                                   where H.YEAR = 2014
                                     AND H.PERIOD = 8
                                     AND H.ACT_OUT_BAL > 0
                                     and h.sales_date <= to_date('2014/12/31', 'YYYY/MM/DD')
                                     and h.cash_conversion_on_date < to_date('2014/8/31', 'YYYY/MM/DD')

                                UNION

                                  SELECT h.YEAR,
                                         h.PERIOD,
                                         h.acct_no,
                                         h.sales_date
                                    from IFSAPP.hpnret_form249_arrears_tab h
                                   where H.YEAR = 2014
                                     AND H.PERIOD = 9
                                     AND H.ACT_OUT_BAL > 0
                                     and h.sales_date <= to_date('2014/12/31', 'YYYY/MM/DD')
                                     and h.cash_conversion_on_date < to_date('2014/9/30', 'YYYY/MM/DD')

                                UNION

                                  SELECT h.YEAR,
                                         h.PERIOD,
                                         h.acct_no,
                                         h.sales_date
                                    from IFSAPP.hpnret_form249_arrears_tab h
                                   where H.YEAR = 2014
                                     AND H.PERIOD = 10
                                     AND H.ACT_OUT_BAL > 0
                                     and h.sales_date <= to_date('2014/12/31', 'YYYY/MM/DD')
                                     and h.cash_conversion_on_date < to_date('2014/10/31', 'YYYY/MM/DD')

                                UNION

                                  SELECT h.YEAR,
                                         h.PERIOD,
                                         h.acct_no,
                                         h.sales_date
                                    from IFSAPP.hpnret_form249_arrears_tab h
                                   where H.YEAR = 2014
                                     AND H.PERIOD = 11
                                     AND H.ACT_OUT_BAL > 0
                                     and h.sales_date <= to_date('2014/12/31', 'YYYY/MM/DD')
                                     and h.cash_conversion_on_date < to_date('2014/11/30', 'YYYY/MM/DD')

                                UNION

                                  SELECT h.YEAR,
                                         h.PERIOD,
                                         h.acct_no,
                                         h.sales_date
                                    from IFSAPP.hpnret_form249_arrears_tab h
                                   where H.YEAR = 2014
                                     AND H.PERIOD = 12
                                     AND H.ACT_OUT_BAL > 0
                                     and h.sales_date <= to_date('2014/12/31', 'YYYY/MM/DD')
                                     and h.cash_conversion_on_date < to_date('2014/12/31', 'YYYY/MM/DD')

                                UNION

                                  SELECT h.YEAR,
                                         h.PERIOD,
                                         h.acct_no,
                                         h.sales_date
                                    from IFSAPP.hpnret_form249_arrears_tab h
                                   where H.YEAR = 2015
                                     AND H.PERIOD = 1
                                     AND H.ACT_OUT_BAL > 0
                                     and h.sales_date <= to_date('2014/12/31', 'YYYY/MM/DD')
                                     and h.cash_conversion_on_date < to_date('2015/1/31', 'YYYY/MM/DD')

                                UNION

                                  SELECT h.YEAR,
                                         h.PERIOD,
                                         h.acct_no,
                                         h.sales_date
                                    from IFSAPP.hpnret_form249_arrears_tab h
                                   where H.YEAR = 2015
                                     AND H.PERIOD = 2
                                     AND H.ACT_OUT_BAL > 0
                                     and h.sales_date <= to_date('2014/12/31', 'YYYY/MM/DD')
                                     and h.cash_conversion_on_date < to_date('2015/2/28','YYYY/MM/DD')

                                UNION

                                  SELECT h.YEAR,
                                         h.PERIOD,
                                         h.acct_no,
                                         h.sales_date
                                    from IFSAPP.hpnret_form249_arrears_tab h
                                   where H.YEAR = 2015
                                     AND H.PERIOD = 3
                                     AND H.ACT_OUT_BAL > 0
                                     and h.sales_date <= to_date('2014/12/31', 'YYYY/MM/DD')
                                     and h.cash_conversion_on_date < to_date('2015/3/31','YYYY/MM/DD')

                                UNION

                                  SELECT h.YEAR,
                                         h.PERIOD,
                                         h.acct_no,
                                         h.sales_date
                                    from IFSAPP.hpnret_form249_arrears_tab h
                                   where H.YEAR = 2015
                                     AND H.PERIOD = 4
                                     AND H.ACT_OUT_BAL > 0
                                     and h.sales_date <= to_date('2014/12/31', 'YYYY/MM/DD')
                                     and h.cash_conversion_on_date < to_date('2015/4/30','YYYY/MM/DD')) V)*/
     and c.account_no not in (select a.account_no from sbl_auth_var_cc a)
                              /*(select t.account_no
                                from IFSAPP.HPNRET_AUTH_VARIATION t
                               where t.utilized = 1
                                 and t.variation_db = 6
                                 and t.from_date >= to_date('2014/1/1','YYYY/MM/DD') 
                                 and t.to_date <= to_date('2015/5/31','YYYY/MM/DD'))*/
--order by c.contract, c.account_no
