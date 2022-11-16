SELECT cit.customer_id,
       cit.name           customer_name,
       cit.party_type     party_type,
       civ.vat_no bin_number
  --,cit.*
  --,civ.*
  FROM ifsapp.customer_info_tab cit, ifsapp.customer_info_vat_tab civ
 WHERE     1 = 1
       AND cit.customer_id = civ.customer_id
       --AND cit.customer_id = '83'
       and civ.vat_no is not null;