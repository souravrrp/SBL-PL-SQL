--Wholesale Customer List
select c.CUSTOMER_ID dealer_id,
       c.name dealer_name,
       IFSAPP.CUSTOMER_INFO_ADDRESS_API.Get_Address1(c.CUSTOMER_ID, '01') || ' ' ||
       IFSAPP.CUSTOMER_INFO_ADDRESS_API.Get_Address2(c.CUSTOMER_ID, '01') dealer_address,
       ifsapp.CUSTOMER_INFO_COMM_METHOD_API.Get_Any_Phone_No(c.CUSTOMER_ID) phone_no,
       ifsapp.CUSTOMER_INFO_COMM_METHOD_API.Get_Customer_E_Mail(c.CUSTOMER_ID,
                                                                1) email_add,
       c.party_type
  from IFSAPP.CUSTOMER_INFO c
 inner join ifsapp.IDENTITY_INVOICE_INFO i
    on c.customer_id = i.identity
   and c.party_type = i.party_type
 where c.customer_id like '&customer_id'
   and i.identity_type = 'External'
   and i.group_id /*in
       ('WDAPPL', 'WDCABLE', 'WIAPPL', 'WICABLE', 'WOTAPPL', 'WOTCABLE')*/ = 'TDCORP'
 order by c.customer_id
