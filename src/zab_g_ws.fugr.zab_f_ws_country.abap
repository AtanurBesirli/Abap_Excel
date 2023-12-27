FUNCTION ZAB_F_WS_COUNTRY.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IV_COUNTRY_ID) TYPE  ZAB_DE_COUNTRY_ID
*"     VALUE(IV_COUNTRY_NAME) TYPE  ZAB_DE_COUNTRY_NAME
*"  EXPORTING
*"     VALUE(EV_SUCCESS) TYPE  XFELD
*"     VALUE(EV_MESSAGE) TYPE  BAPI_MSG
*"----------------------------------------------------------------------

DATA : ls_country TYPE zab_f_t_0002.

  ls_country-z_country_id = iv_country_id.
  ls_country-z_country_name = iv_country_name.
  ls_country-z_uname = sy-uname.
  ls_country-z_datum = sy-datum.
  ls_country-z_uzeit = sy-uzeit.

  SELECT COUNT(*) FROM zab_f_t_0002
    WHERE z_country_id EQ iv_country_id.
  IF sy-subrc EQ 0.
    ev_success = ' '.
    ev_message = 'bu ülke kodu daha önce kaydedilmiştir.'.
  ELSE.
    INSERT zab_f_t_0002 FROM ls_country.
    COMMIT WORK.
    ev_success = 'X'.
    ev_message = 'Ülke kodu başarıyla kaydedilmiştir.'.

  ENDIF.




ENDFUNCTION.
