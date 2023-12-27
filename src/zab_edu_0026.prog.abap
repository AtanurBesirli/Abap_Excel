*&---------------------------------------------------------------------*
*& Report ZAB_EDU_0026
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zab_edu_0026.

DATA : go_gbt       TYPE REF TO cl_gbt_multirelated_service,
       go_bcs       TYPE REF TO cl_bcs,
       go_doc_bcs   TYPE REF TO cl_document_bcs,
       go_recipient TYPE REF TO if_recipient_bcs,
       gt_soli      TYPE TABLE OF soli,
       gs_soli      TYPE soli,
       gv_status    TYPE bcs_rqst,
       gv_content   TYPE string.

DATA : gv_attachment_size TYPE sood-objlen,
       gt_attachment_hex  TYPE solix_tab,
       gv_attachment_con  TYPE string,
       gv_attachment_lin  TYPE string.


DATA : gt_scarr TYPE TABLE OF scarr,
       gs_scarr TYPE scarr.

START-OF-SELECTION.

  SELECT * FROM scarr INTO CORRESPONDING FIELDS OF TABLE gt_scarr.

  CREATE OBJECT go_gbt.

* gv_content = 'Hiiiiiii'.

  gv_content = '<!DOCTYPE html>                           '
            && '<html>                                    '
            && '  <head>                                  '
            && '    <meta charset = "utf-8">              '
            && '      <style>                             '
            && '        th{ background-color: red;   '
            && '               border: 1px solid;         '
            && '               }                          '
            && '        td{ background-color: yellow;         '
            && '               border: 1px solid;         '
            && '               }                          '
            && '      </style>                            '
            && '  </head>                                 '
            && '  <body>                                  '
            && '  <table>                                     '
            && '  <tr>                       '
            && '  <th>last index1</th>                       '
            && '  <th>last index2</th>                       '
            && '  <th>last index3</th>                       '
            && '  <th>last index4</th>                       '
            && '  </tr>                       ' .

  LOOP AT gt_scarr INTO gs_scarr.
    gv_content = gv_content && '  <tr>                       '
                            && '  <td>' && gs_scarr-carrid && '</td>                       '
                            && '  <td>' && gs_scarr-currcode && '</td>                       '
                            && '  <td>' && gs_scarr-carrname && '</td>                       '
                            && '  <td>' && gs_scarr-url && '</td>                       '
                            && '  </tr>                       '.

  ENDLOOP.
  gv_content = gv_content && '  </table>                                     '
                          && '  </body>                                 '
                          && '</html>                                   '
 .

  gt_soli = cl_document_bcs=>string_to_soli( gv_content ).

  CALL METHOD go_gbt->set_main_html
    EXPORTING
      content = gt_soli                 " Objcont and Objhead as Table Type
*     filename    =                  " File Name (Proposal Only)
*     description =                  " Short description of contents
    .

  go_doc_bcs = cl_document_bcs=>create_from_multirelated(
              i_subject          = 'Test Mail Başlık'
*             i_language         = space
*             i_importance       =
*             i_sensitivity      =
              i_multirel_service = go_gbt
*             iv_vsi_profile     =
            ).
*           CATCH cx_document_bcs. " BCS: Document Exceptions
*           CATCH cx_bcom_mime.    " Exceptions in MIME Conversion Tool
*           CATCH cx_gbt_mime.     " MIME Error

    LOOP AT gt_scarr INTO gs_scarr.
    CONCATENATE gs_scarr-carrid
                gs_scarr-carrname
                gs_scarr-currcode
                gs_scarr-url
                INTO gv_attachment_lin
                SEPARATED BY cl_abap_char_utilities=>horizontal_tab.
    IF sy-tabix eq 1.
      gv_attachment_con = gv_attachment_lin.
      ELSE.
            CONCATENATE gv_attachment_con
                        gv_attachment_lin
                INTO gv_attachment_con
                SEPARATED BY cl_abap_char_utilities=>newline.
    ENDIF.
  ENDLOOP.

  cl_bcs_convert=>string_to_solix(
    EXPORTING
      iv_string   = gv_attachment_con                 " Input data
      iv_codepage = '4103'                 " Target Code Page in SAP Form  (Default = SAPconnect Setting)
      iv_add_bom  = 'X'                  " Add Byte-Order Mark
    IMPORTING
      et_solix    = gt_attachment_hex                 " Output data
      ev_size     = gv_attachment_size                 " Size of Document Content
  ).
*  CATCH cx_bcs. " BCS: General Exceptions



  go_doc_bcs->add_attachment(
    EXPORTING
      i_attachment_type     = 'xls'                 " Document Class for Attachment
      i_attachment_subject  = 'attachment1'                 " Attachment Title
      i_attachment_size     = gv_attachment_size                 " Size of Document Content
*      i_attachment_language = space            " Language in Which Attachment Is Created
*      i_att_content_text    =                  " Content (Text-Like)
      i_att_content_hex     = gt_attachment_hex                 " Content (Binary)
*      i_attachment_header   =                  " Attachment Header Data
*      iv_vsi_profile        =                  " Virus Scan Profile
  ).
*  CATCH cx_document_bcs. " BCS: Document Exceptions

  go_recipient = cl_cam_address_bcs=>create_internet_address(
                   i_address_string = 'ata@dogu.com'
*                  i_address_name   =
*                  i_incl_sapuser   =
                 ).
*                CATCH cx_address_bcs. " BCS: Address Exceptions (OS Exception)
  go_bcs = cl_bcs=>create_persistent( ).
*          CATCH cx_send_req_bcs. " BCS: Send Request Exceptions

  go_bcs->set_document( i_document = go_doc_bcs ).
* CATCH cx_send_req_bcs. " BCS: Send Request Exceptions

  go_bcs->add_recipient(
    EXPORTING
      i_recipient  = go_recipient                 " Recipient of Message
*     i_express    =                  " Send As Express Message
*     i_copy       =                  " Send Copy
*     i_blind_copy =                  " Send As Blind Copy
*     i_no_forward =                  " No Forwarding
  ).
* CATCH cx_send_req_bcs. " BCS: Send Request Exceptions

  gv_status = 'N'.
  CALL METHOD go_bcs->set_status_attributes
    EXPORTING
      i_requested_status = gv_status                 " Requested Status
*     i_status_mail      = 'E'              " Setting for Which Statuses Are Reported by Mail
    .
* CATCH cx_send_req_bcs. " BCS: Send Request Exceptions

  go_bcs->send(
*     i_with_error_screen = space
  ).
* CATCH cx_send_req_bcs. " BCS: Send Request Exceptions
  COMMIT WORK.
