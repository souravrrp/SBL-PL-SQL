/* Formatted on 3/16/2020 2:03:07 PM (QP5 v5.287) */
  SELECT obj.object_name,
         atc.column_name,
         atc.data_type,
         atc.data_length,
         atc.column_name||' '||atc.data_type||' ('||atc.data_length||' BYTE),' PROPERTIES,
         atc.column_name||', ' table_comma
    FROM all_tab_columns atc, all_objects obj
   WHERE     1 = 1
         AND atc.table_name = obj.object_name
         --AND OBJ.object_name LIKE 'FND_USER%'
         --AND     (:P_TABLE_NAME IS NULL OR (UPPER(OBJ.object_name) LIKE UPPER('%'||:P_TABLE_NAME||'%') ))
          AND (( :P_TABLE_NAME IS NULL) OR (UPPER(object_name) = UPPER(:P_TABLE_NAME)))
         --AND owner = 'GL'
         AND object_type IN ('TABLE', 'VIEW')
ORDER BY obj.object_name, atc.column_name;

--------------------------------------------------------------------------------


  SELECT obj.object_name,
         atc.column_name,
         atc.data_type,
         atc.data_length
    FROM all_tab_columns atc,
         (SELECT *
            FROM all_objects
           WHERE     object_name LIKE 'MTL_ITEM_CATEGORIES_V%' --AND owner = 'GL'
                 AND object_type IN ('TABLE', 'VIEW')) obj
   WHERE atc.table_name = obj.object_name
ORDER BY obj.object_name, atc.column_name;