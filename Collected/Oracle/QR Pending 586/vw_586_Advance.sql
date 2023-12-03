create or replace view sbl_vw_586_advance
as
  SELECT
      v.area, 
      v.district, 
      a.site, 
      ifsapp.Site_Api.Get_Description(a.site)site_description, 
      a.book_no,
      a.sheet_serial_no, 
      a.price,
      a.customer_id, 
      IFSAPP.Customer_Info_Api.Get_Name(a.customer_id) Cust_Name, 
      a.hpnret_other_pay_type,  
      a.state, 
      trunc(a.date_created) date_created,
      trunc(a.expiry_date) expiry_date
  FROM
    ifsapp.hpnret_com_register a,
    ifsapp.hpnret_levels_overview v 
  WHERE
    v.site_id = a.site AND
    a.hpnret_other_pay_type = '586' AND
    a.redeem = 'TRUE'
