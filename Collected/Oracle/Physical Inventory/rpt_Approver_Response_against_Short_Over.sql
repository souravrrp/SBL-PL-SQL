--***** Approvers' Response against Short Over
SELECT a.user_id,
       IFSAPP.CUSTOMER_INFO_API.Get_Name(A.USER_ID) USER_NAME,
       v.site,
       sum(case
             when v.qty_onhand > 0 then
              1
             else
              0
           end) no_of_products,
       sum(case
             when v.qty_short_over != 0 then
              1
             else
              0
           end) short_over,
       sum((case
             when v.settlement_deadline is not null then
              1
             else
              0
           end)) approver_response
  FROM IFSAPP.SBL_PHYSICAL_INVENTORY_STATUS v
 INNER JOIN IFSAPP.SBL_PI_SO_APPROVER a
    ON v.site = a.site
 WHERE a.user_id != 'E10206'
   and v.site LIKE '&Shop_Code'
 group by a.user_id, v.site
 order by a.user_id, v.site
