*---------------------------------------------------------------------*
*    program for:   TABLEFRAME_ZAB_T_0003
*---------------------------------------------------------------------*
FUNCTION TABLEFRAME_ZAB_T_0003         .

  PERFORM TABLEFRAME TABLES X_HEADER X_NAMTAB DBA_SELLIST DPL_SELLIST
                            EXCL_CUA_FUNCT
                     USING  CORR_NUMBER VIEW_ACTION VIEW_NAME.

ENDFUNCTION.