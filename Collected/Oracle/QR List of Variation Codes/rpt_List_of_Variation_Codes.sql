select 
    v.variation variation_code,
    substrb(Variation_API.Decode(v.variation),1,200) variation
from HPNRET_VARIATION_CONTROL_TAB v
order by v.variation
