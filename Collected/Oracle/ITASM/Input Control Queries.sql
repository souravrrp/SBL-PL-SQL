select * from IFSAPP.SBL_IT_INV_SITE_INFO_TAB s;

--
select s.site_area ITA_AREA
  from IFSAPP.SBL_IT_INV_SITE_INFO_TAB s
 where s.site_type in ('SP_SHOP', 'SP_ESA', 'SP_DSA')
 group by s.site_area
 order by s.site_area;

--
select s.site_district ITA_DISTRICT
  from IFSAPP.SBL_IT_INV_SITE_INFO_TAB s
 where s.site_type in ('SP_SHOP', 'SP_ESA', 'SP_DSA')
   and $X{IN, s.site_area, ITA_AREA}
 group by s.site_district
 order by s.site_district;

--
select s.site_code ITA_SHOP
  from IFSAPP.SBL_IT_INV_SITE_INFO_TAB s
 where s.site_type in ('SP_SHOP', 'SP_ESA', 'SP_DSA')
   and $X{IN, s.site_area, ITA_AREA}
   and $X{IN, s.site_district, ITA_DISTRICT}
 order by s.site_code;
