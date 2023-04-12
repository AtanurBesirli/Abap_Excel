*&---------------------------------------------------------------------*
*& Include          ZAB_I_0009_FRM
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form f_call_screen
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_call_screen .

  CALL SCREEN '0100'.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_get_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_get_data .

  SELECT likp~vbeln ,
         likp~kunnr ,
         kna1~name1 ,
         mara~matnr ,
         makt~maktx ,
         mara~meins ,
         mard~labst ,
         lips~posnr
    FROM lips
    INNER JOIN mara ON lips~matnr = mara~matnr
    INNER JOIN makt ON mara~matnr = makt~matnr
    INNER JOIN mard ON mard~matnr = mara~matnr
    INNER JOIN likp ON lips~vbeln = likp~vbeln
    INNER JOIN kna1 ON kna1~kunnr = likp~kunnr
    WHERE likp~vbeln = @gv_vbeln
    AND   makt~spras = @sy-langu
    INTO CORRESPONDING FIELDS OF TABLE @gt_data .

  SORT gt_data.
  DELETE ADJACENT DUPLICATES FROM gt_data.

  fill = lines( gt_data ).
  gv_page = fill / 2.

*mara-matnr malzeme no matnr
*makt-maktx malzeme tanımı matnr
*mara-meins ölçü birimi
*mard-labst miktar      matnr
*vbap-posnr kalem no    vbeln posnr

ENDFORM.
*&---------------------------------------------------------------------*
*& Module TRANSP_ITAB_OUT OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE transp_itab_out OUTPUT.
  idx = sy-stepl + line.
  READ TABLE gt_data INTO gs_data INDEX idx.
ENDMODULE.

*&---------------------------------------------------------------------*
*&      Module  TRANSP_ITAB_IN  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE transp_itab_in INPUT.
  lines = sy-loopc.
  idx = sy-stepl + line.
  MODIFY gt_data FROM gs_data INDEX idx.

  READ TABLE gt_data INTO gs_data INDEX idx.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Form f_s_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_s_data .
  CLEAR : gs_data, gv_kunnr, gv_name1.
  READ TABLE gt_data INTO gs_data INDEX 1.
  gv_kunnr = gs_data-kunnr.
  gv_name1 = gs_data-name1.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_add
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_add .

  READ TABLE gt_data INTO gs_data WITH KEY matnr = gv_matnr1.
  IF sy-subrc <> 0.
    gs_data-matnr = gv_matnr1.
    gs_data-labst = gv_labst1.
    gs_data-posnr = gv_posnr1.
    APPEND gs_data TO gt_data.

    CONCATENATE gs_data-matnr TEXT-002 INTO DATA(lv_text) SEPARATED BY space.
    MESSAGE lv_text TYPE 'S'.

    fill = lines( gt_data ).
    gv_page = fill / 2.
  ELSE.
    MESSAGE TEXT-001 TYPE 'E'.
  ENDIF.
  CLEAR : gv_matnr1, gv_labst1, gv_posnr1.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_del
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_del .

  LOOP AT gt_data INTO gs_data.
    DELETE gt_data WHERE matnr = gv_matnr1.
    IF sy-subrc = 0.
      CONCATENATE gv_matnr1 TEXT-003 INTO DATA(lv_text) SEPARATED BY space.
      MESSAGE lv_text TYPE 'S'.
    ENDIF.
  ENDLOOP.

  CLEAR : gv_matnr1.
  fill = lines( gt_data ).
  gv_page = fill / 2.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_save
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_save .

  DATA: lt_header_data TYPE TABLE OF bapiobdlvhdrchg,
        ls_header_data TYPE bapiobdlvhdrchg.
  DATA: lt_header_control TYPE TABLE OF  bapiobdlvhdrctrlchg,
        ls_header_control TYPE bapiobdlvhdrctrlchg.
  DATA: lt_return TYPE TABLE OF  bapiret2.
  DATA: lv_delivery TYPE vbeln_vl.

  lv_delivery = gv_vbeln.
  ls_header_data-deliv_numb = gv_vbeln.
  APPEND ls_header_data TO lt_header_data.

  ls_header_control-deliv_numb = gv_vbeln.
  ls_header_control-gdsi_date_flg = 'X'.


  CALL FUNCTION 'BAPI_OUTB_DELIVERY_CHANGE'
    EXPORTING
      header_data    = ls_header_data
      header_control = ls_header_control
      delivery       = lv_delivery
    TABLES
      return         = lt_return.

  CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'.

  PERFORM f_mail.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_mail
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_mail .

  gv_content = TEXT-010.
  gt_soli = cl_document_bcs=>string_to_soli( gv_content ).

  CALL METHOD go_gbt->set_main_html
    EXPORTING
      content = gt_soli.
*  TRY.
*      go_doc_bcs = cl_document_bcs=>create_from_multirelated(
*      i_subject  = 'Sipariş Detayları'
*      i_multirel_service = go_gbt  ).
*    CATCH cx_document_bcs. " BCS: Document Exceptions
*    CATCH cx_bcom_mime.    " Exceptions in MIME Conversion Tool
*    CATCH cx_gbt_mime.     " MIME Error(.
*
*  ENDTRY.

  TRY .
      go_doc_bcs = cl_document_bcs=>create_document(
                       i_type    = 'RAW'
                       i_text    = gt_soli
                       i_length  = '12'
                       i_subject = TEXT-011 ).
    CATCH  cx_document_bcs . " BCS: Document Exceptions(
  ENDTRY.

  CONCATENATE TEXT-004 TEXT-005 TEXT-006 TEXT-007
  TEXT-008 TEXT-009
  INTO gv_att_content
  SEPARATED BY cl_abap_char_utilities=>horizontal_tab.
  LOOP AT gt_data INTO gs_data.
    CONCATENATE gs_data-vbeln
                gs_data-kunnr
                gs_data-name1
                gs_data-matnr
                gs_data-posnr
                gs_data-meins
                INTO gv_att_line
                SEPARATED BY cl_abap_char_utilities=>horizontal_tab.

    CONCATENATE gv_att_content
                gv_att_line
                INTO gv_att_content
                SEPARATED BY cl_abap_char_utilities=>newline.
  ENDLOOP.

  TRY.
      cl_bcs_convert=>string_to_solix(
        EXPORTING
          iv_string   = gv_att_content                 " Input data
          iv_codepage = '4103'                 " Target Code Page in SAP Form  (Default = SAPconnect Setting)
          iv_add_bom  = 'X'                 " Add Byte-Order Mark
        IMPORTING
          et_solix    = gt_att_content_hex                   " Output data
          ev_size     = gv_attachment_size                  " Size of Document Content
      ).
    CATCH cx_bcs. " BCS: General Exceptions
  ENDTRY.

  TRY.
      go_doc_bcs->add_attachment(
        EXPORTING
          i_attachment_type     = 'CSV'                 " Document Class for Attachment
          i_attachment_subject  = TEXT-011                 " Attachment Title
          i_attachment_size     = gv_attachment_size                 " Size of Document Content
          i_att_content_hex     = gt_att_content_hex                 " Content (Binary)
      ).
    CATCH cx_document_bcs. " BCS: Document Exceptions
  ENDTRY.

  TRY.
      go_recipient = cl_cam_address_bcs=>create_internet_address( 'atanur_test@test.com' ).
    CATCH cx_address_bcs. " BCS: Address Exceptions (OS Exception)
  ENDTRY.
  TRY.
      go_bcs = cl_bcs=>create_persistent( ).
    CATCH cx_send_req_bcs. " BCS: Send Request Exceptions( ).
  ENDTRY.
  TRY.
      CALL METHOD go_bcs->set_document( i_document = go_doc_bcs ).
    CATCH cx_send_req_bcs. " BCS: Send Request Exceptions( ).
  ENDTRY.
  TRY.
      CALL METHOD go_bcs->add_recipient(
        EXPORTING
          i_recipient = go_recipient
      ).
    CATCH cx_send_req_bcs. " BCS: Send Request Exceptions( ).
  ENDTRY.

  gv_status = 'N'.
  TRY .

      CALL METHOD go_bcs->set_status_attributes
        EXPORTING
          i_requested_status = gv_status.
    CATCH cx_send_req_bcs. " BCS: Send Request Exceptions( ).
  ENDTRY.

  TRY .
      go_bcs->send(  ).
    CATCH cx_send_req_bcs. " BCS: Send Request Exceptions( ).
  ENDTRY.
  COMMIT WORK.

  IF sy-subrc EQ 0.
    MESSAGE TEXT-012 TYPE 'S'.
  ENDIF.

ENDFORM.
