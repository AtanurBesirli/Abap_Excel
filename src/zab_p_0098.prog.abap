*&---------------------------------------------------------------------*
*& Report ZAB_P_0098
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZAB_P_0098.

*    DATA : lv_date TYPE  dats,
*         lv_time TYPE  tims.
*
*  CALL FUNCTION 'FVD_MAP_CP_DATE_GET'
*    IMPORTING
*      e_date = lv_date
*      e_time = lv_time
*    EXCEPTIONS
*      error  = 1
*      OTHERS = 2.
*  IF sy-subrc <> 0.
** Implement suitable error handling here
*  ENDIF.
*
*  lv_time += 3600.

DATA(lv_date) = syst-datum.

  BREAK-POINT.
