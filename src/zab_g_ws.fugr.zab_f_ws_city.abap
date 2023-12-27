FUNCTION zab_f_ws_city.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IV_CITY_ID) TYPE  ZAB_DE_CITY_ID
*"     VALUE(IV_CITY_NAME) TYPE  ZAB_DE_CITY_NAME
*"  EXPORTING
*"     VALUE(EV_SUCCESS) TYPE  XFELD
*"     VALUE(EV_MESSAGE) TYPE  BAPI_MSG
*"----------------------------------------------------------------------

  DATA : ls_city TYPE zab_f_t_0001.

  ls_city-z_city_id = iv_city_id.
  ls_city-z_city_name = iv_city_name.
  ls_city-z_uname = sy-uname.
  ls_city-z_datum = sy-datum.
  ls_city-z_uzeit = sy-uzeit.

  SELECT COUNT(*) FROM zab_f_t_0001
    WHERE z_city_id EQ iv_city_id.
  IF sy-subrc EQ 0.
    ev_success = ' '.
    ev_message = 'bu şehir kodu daha önce kaydedilmiştir.'.
  ELSE.
    INSERT zab_f_t_0001 FROM ls_city.
    COMMIT WORK.
    ev_success = 'X'.
    ev_message = 'Şehir kodu başarıyla kaydedilmiştir.'.

  ENDIF.



ENDFUNCTION.
