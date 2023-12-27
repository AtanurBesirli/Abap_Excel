FUNCTION ZAB_EDU_F_0001.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IV_NUM1) TYPE  INT4 DEFAULT 10
*"     VALUE(IV_NUM2) TYPE  INT4 DEFAULT 5
*"  EXPORTING
*"     REFERENCE(EV_RESULT) TYPE  INT4
*"----------------------------------------------------------------------

ev_result = iv_num1 * iv_num2.



ENDFUNCTION.
