--Wholesale Supplier List
select s.supplier_id dealer_id,
       s.name dealer_name,
       IFSAPP.SUPPLIER_INFO_ADDRESS_API.Get_Address1(s.supplier_id, 1) || ' ' ||
       IFSAPP.SUPPLIER_INFO_ADDRESS_API.Get_Address2(s.supplier_id, 1) dealer_address,
       IFSAPP.SUPPLIER_INFO_COMM_METHOD_API.Get_Phone(s.supplier_id) phone_no,
       IFSAPP.SUPPLIER_INFO_COMM_METHOD_API.Get_Default_E_Mail(s.supplier_id) email_add,
       s.party_type
  from ifsapp.SUPPLIER_INFO s
 inner join ifsapp.IDENTITY_INVOICE_INFO i
    on s.supplier_id = i.identity
   and s.party_type = i.party_type
 where s.supplier_id like '&supplier_id'
   and i.identity_type = 'External'
   and i.group_id in
       ('WDAPPL', 'WDCABLE', 'WIAPPL', 'WICABLE', 'WOTAPPL', 'WOTCABLE')
 order by s.supplier_id
