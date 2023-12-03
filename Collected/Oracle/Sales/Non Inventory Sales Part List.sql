select 
    --*
    t.contract "Site",
    t.catalog_no "Sales Part Number",
    t.catalog_desc "Description",
    t.catalog_group "Sales Group",
    t.date_entered "Created",
    t.list_price "Price", 
    t.activeind Active
from SALES_PART t
where 
  --t.catalog_no = 'REF-SRVS' and
  --t.contract = 'DSCP' and
  t.catalog_type_db = 'NON' AND
  --t.activeind_db = 'Y' and
  t.non_inv_part_type_db = 'SERVICE'
