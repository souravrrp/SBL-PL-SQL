--***** Dealer's Market Code Info
select D.customer_id dealer_id,
       ifsapp.customer_info_api.Get_Name(D.customer_id) dealer_name,
       D.market_code,
       IFSAPP.SALES_MARKET_API.Get_Description(D.market_code) USER_ID,
       IFSAPP.FND_USER_API.Get_Description(IFSAPP.SALES_MARKET_API.Get_Description(D.market_code)) USER_NAME
  from IFSAPP.CUST_ORD_CUSTOMER_ENT D
 where D.customer_id LIKE 'W000%'
 order by d.customer_id
