--***** Starts New Cash Sale
SELECT C.ORDER_NO,
       C.CONTRACT "SHOP_CODE",
       C.CATALOG_NO PART_NO,
       C.REAL_SHIP_DATE SALE_DATE,
       C.QTY_SHIPPED QUANTITY,
       'Cash Sale' ROWSTATE
  FROM CUSTOMER_ORDER_LINE_TAB C
 where substr(c.order_no, 4, 2) = '-R'
   and c.real_ship_date >= to_date('2015/11/1', 'YYYY/MM/DD')
   and C.CONTRACT NOT IN ('SCOM',
                          'WSMO',
                          'SWSS',
                          'SAOS',
                          'JWSS',
                          'SCSM',
                          'SAPM',
                          'SESM',
                          'SHOM',
                          'SISM',
                          'SFSM')
   and c.order_no in (select h.order_no
                        from HPNRET_CUSTOMER_ORDER_TAB h
                       where h.cash_conv = 'FALSE')
   --and c.catalog_type != 'KOMP' 
   and c.catalog_no not like 'PK%'
   and c.rowstate in ('Delivered', 'Invoiced', 'PartiallyDelivered')
   and c.demand_order_ref1 is null
   AND c.contract like '&SHOP_CODE'
--***** Ends New Cash Sale

union all

--***** Starts Cash Sale Returns
select R.ORDER_NO,
       R.CONTRACT SHOP_CODE,
       R.CATALOG_NO PART_NO,
       TRUNC(R.DATE_RETURNED) DATE_RETURNED,
       (-1) * R.QTY_RETURNED_INV QUANTIY,
       R.ROWSTATE ROWSTATE
  from HPNRET_SALES_RET_LINE_TAB R
 WHERE SUBSTR(R.ORDER_NO, 5, 1) = 'R'
   AND R.ROWSTATE IN ('ReturnCompleted')
   AND TRUNC(R.DATE_RETURNED) >= to_date('2015/11/1', 'YYYY/MM/DD')
   AND R.CONTRACT = '&Shop_Code'
--***** Ends Cash Sale Returns

union all

--***** Starts New HP Sale
select h.account_no,
       h.contract,
       h.catalog_no PART_NO,
       trunc(h.sales_date) sales_date,
       h.quantity,
       'Hire Sale' ROWSTATE
  from ifsapp.hpnret_hp_dtl_tab h
  left join IFSAPP.HPNRET_HP_HEAD_TAB T
    on H.ACCOUNT_NO = T.ACCOUNT_NO
   AND H.CONTRACT = T.CONTRACT
 where trunc(T.sales_date) >= to_date('2015/11/1', 'YYYY/MM/DD')
   --and h.catalog_type != 'KOMP' 
   and h.catalog_no not like 'PK%'
   and h.contract like '&Shop_Code'
   and h.contract not in ('SCOM',
                          'WSMO',
                          'SWSS',
                          'SAOS',
                          'JWSS',
                          'SCSM',
                          'SAPM',
                          'SESM',
                          'SHOM',
                          'SISM',
                          'SFSM')
   and h.rowstate not in ('AssumeClosed',
                          'Cancelled',
                          'CashConverted',
                          'Closed',
                          'DiscountClosed',
                          'ExchangedIn',
                          'Planned',
                          'Released',
                          'Returned',
                          'RevertReversed',
                          'Reverted',
                          'TermChanged',
                          'ToBeReverted',
                          'TransferAccount')
--***** Ends New HP Sale

union all

--***** Starts HP Variations
select h.account_no,
       h.contract,
       h.catalog_no PART_NO,
       trunc(h.variated_date) variated_date,
       (-1) * h.quantity quantity,
       h.rowstate ROWSTATE
  from ifsapp.hpnret_hp_dtl_tab h
 where trunc(H.VARIATED_DATE) >= to_date('2015/11/1', 'YYYY/MM/DD')
   --and h.catalog_type != 'KOMP' 
   and h.catalog_no not like 'PK%'
   and h.contract like '&Shop_Code'
   and h.contract not in ('SCOM',
                          'WSMO',
                          'SWSS',
                          'SAOS',
                          'JWSS',
                          'SCSM',
                          'SAPM',
                          'SESM',
                          'SHOM',
                          'SISM',
                          'SFSM')
   and h.rowstate in ('AssumeClosed',
                      'ExchangedIn',
                      'Returned',
                      'Reverted',
                      'TermChanged',
                      'TransferAccount')
--***** Ends HP Variations

union all

--***** Starts Revert Reversed Accounts
select h.account_no,
       h.contract,
       h.catalog_no PART_NO,
       trunc(h.variated_date) variated_date,
       h.quantity quantity,
       h.rowstate ROWSTATE
  from ifsapp.hpnret_hp_dtl_tab h
 where trunc(H.VARIATED_DATE) >= to_date('2015/11/1', 'YYYY/MM/DD')
   --and h.catalog_type != 'KOMP' 
   and h.catalog_no not like 'PK%'
   and h.contract like '&Shop_Code'
   and h.contract not in ('SCOM',
                          'WSMO',
                          'SWSS',
                          'SAOS',
                          'JWSS',
                          'SCSM',
                          'SAPM',
                          'SESM',
                          'SHOM',
                          'SISM',
                          'SFSM')
   and h.rowstate in ('RevertReversed')
--***** Ends Revert Reversed Accounts

 order by 2, 1
