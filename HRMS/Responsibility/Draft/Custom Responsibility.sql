/* Formatted on 11/7/2020 10:34:03 AM (QP5 v5.287) */
SELECT FM.MENU_ID,
       FU.USER_NAME,
       FR.RESPONSIBILITY_NAME,
       FME.PROMPT PROMPT_NAME,
       FF.FORM_NAME,
       FM.MENU_NAME,
       FFF.FUNCTION_NAME,
       RES.START_DATE,
       RES.END_DATE
  --,FM.*
  --,FF.*
  --,FFF.*
  FROM APPS.FND_MENU_ENTRIES_VL FME,
       APPS.FND_MENUS_VL FM,
       APPS.FND_FORM_FUNCTIONS_VL FFF,
       APPS.FND_FORM_VL FF,
       APPS.FND_RESPONSIBILITY_VL FR,
       APPS.FND_USER FU,
       APPS.FND_USER_RESP_GROUPS_DIRECT RES
 WHERE     1 = 1
       AND RES.RESPONSIBILITY_ID = FR.RESPONSIBILITY_ID
       --AND    ff.form_name = 'XXAKG_FUEL' --:p_fmb
       AND ff.form_name LIKE 'XX%'                                    --:p_fmb
       AND FFF.FORM_ID = FF.FORM_ID
       AND FME.FUNCTION_ID = FFF.FUNCTION_ID
       AND FM.MENU_ID = FME.MENU_ID
       AND FR.MENU_ID = FM.MENU_ID
       --AND UPPER (FR.RESPONSIBILITY_NAME) LIKE UPPER ('%'||:P_REPONSIBILITY_NAME||'%')
       --AND (   :P_REPONSIBILITY_NAME IS NULL OR (UPPER (FR.RESPONSIBILITY_NAME) LIKE UPPER ('%'||:P_REPONSIBILITY_NAME||'%')))
       --AND ( :P_EMP_NUM IS NULL OR (FU.USER_NAME = :P_EMP_NUM))
       --AND FME.PROMPT IS NOT NULL
       AND FR.RESPONSIBILITY_ID = RES.RESPONSIBILITY_ID(+)
       AND RES.USER_ID = FU.USER_ID(+);

---------------------------------------------------------------------------

SELECT FU.USER_NAME,
       FR.RESPONSIBILITY_NAME,
       FME.PROMPT PROMPT_NAME,
       FF.FORM_NAME,
       FM.MENU_NAME,
       FFF.FUNCTION_NAME,
       RES.START_DATE,
       RES.END_DATE
  --,FM.*
  --,FF.*
  --,FFF.*
  FROM APPS.FND_MENU_ENTRIES_VL FME,
       APPS.FND_MENUS_VL FM,
       APPS.FND_FORM_FUNCTIONS_VL FFF,
       APPS.FND_FORM_VL FF,
       APPS.FND_RESPONSIBILITY_VL FR,
       APPS.FND_USER FU,
       APPS.FND_USER_RESP_GROUPS_DIRECT RES
 WHERE     1 = 1
       AND RES.RESPONSIBILITY_ID = FR.RESPONSIBILITY_ID
       --AND    ff.form_name = 'XXAKG_FUEL' --:p_fmb
       AND FFF.FORM_ID = FF.FORM_ID
       AND FME.FUNCTION_ID = FFF.FUNCTION_ID
       AND FM.MENU_ID = FME.MENU_ID
       AND FR.MENU_ID = FM.MENU_ID
       AND UPPER (FR.RESPONSIBILITY_NAME) LIKE UPPER ('%' || :P_REPONSIBILITY_NAME || '%')
       --AND (   :P_REPONSIBILITY_NAME IS NULL OR (UPPER (FR.RESPONSIBILITY_NAME) LIKE UPPER ('%'||:P_REPONSIBILITY_NAME||'%')))
       AND ( :P_EMP_NUM IS NULL OR (FU.USER_NAME = :P_EMP_NUM))
       AND FR.RESPONSIBILITY_ID = RES.RESPONSIBILITY_ID(+)
       AND RES.USER_ID = FU.USER_ID(+)
       AND FME.PROMPT IS NOT NULL;