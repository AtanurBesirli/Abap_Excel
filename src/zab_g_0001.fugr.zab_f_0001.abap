FUNCTION zab_f_0001.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  TABLES
*"      TABLE STRUCTURE  ZAB_S_0004
*"----------------------------------------------------------------------

  DATA : lv_int TYPE i VALUE 1,
         lv_mod TYPE i.

  LOOP AT table INTO DATA(ls_data).

*    lv_mod = lv_int MOD 2.
*    IF lv_mod EQ 0.
      INSERT INITIAL LINE INTO table INDEX lv_int * 2 .
*    ENDIF.

    lv_int += 1.
  ENDLOOP.




ENDFUNCTION.
