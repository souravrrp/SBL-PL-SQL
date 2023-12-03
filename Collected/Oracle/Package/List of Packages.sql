--List of Packages
select * from ALL_OBJECTS o
   where o.OBJECT_TYPE in ('PACKAGE') AND --PACKAGE VIEW
     o.OWNER = 'IFSAPP' and
     --o.object_type in ('PACKAGE') --'PROCEDURE', 'FUNCTION', 'PACKAGE BODY'
     o.OBJECT_NAME like '%COLLECTION%'
     

SELECT * FROM DBA_PROCEDURES

SELECT owner, NAME
  FROM dba_dependencies
 WHERE referenced_owner = 'IFSAPP' --:table_owner
   AND referenced_name = 'HPNRET_FORM249_ARREARS_TAB' --:table_name
   AND TYPE IN ('PACKAGE', 'PACKAGE BODY')
