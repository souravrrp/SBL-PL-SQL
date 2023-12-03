select 
    s.catalog_no,
    s.catalog_desc,
    s.catalog_group sales_group,
    IFSAPP.SALES_GROUP_API.Get_Description(s.catalog_group) sales_group_desc
from SALES_PART s
where s.contract = 'SCOM'
