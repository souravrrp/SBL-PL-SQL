SELECT
    s.transaction_code, 
    s.transaction_type,
    s.site_transaction_category site_transaction_category_id, 
    substrb(Site_Transaction_Category_API.Decode(s.site_transaction_category),1,200) site_transaction_category,    
    s.rowstate
from IFSAPP.SITE_TRANSACTION_TYPES_TAB s
where 
  s.site_transaction_category = 2 and
  s.rowstate NOT IN ('Cancelled')
order by s.transaction_code
