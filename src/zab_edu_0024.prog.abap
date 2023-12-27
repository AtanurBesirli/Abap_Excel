*&---------------------------------------------------------------------*
*& Report ZAB_EDU_0024
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZAB_EDU_0024.
DATA: i_otf       TYPE itcoo OCCURS 0 WITH HEADER LINE,
      i_tline     TYPE TABLE OF tline WITH HEADER LINE,
      i_receivers TYPE TABLE OF somlreci1 WITH HEADER LINE,
      i_record    LIKE solisti1 OCCURS 0 WITH HEADER LINE,
* Objects to send mail.
      i_objpack   LIKE sopcklsti1 OCCURS 0 WITH HEADER LINE,
      i_objtxt    LIKE solisti1 OCCURS 0 WITH HEADER LINE,
      i_objbin    LIKE solisti1 OCCURS 0 WITH HEADER LINE,
      i_reclist   LIKE somlreci1 OCCURS 0 WITH HEADER LINE,


**************Work Area declarations***********************

      w_objhead   TYPE soli_tab,
      w_doc_chng  TYPE sodocchgi1,
      w_data      TYPE sodocchgi1,
      w_buffer    TYPE string."To convert from 132 to 255

data:     v_len_in     TYPE sood-objlen,
     v_len_out    TYPE sood-objlen,
     v_len_outn   TYPE i,
     v_lines_txt  TYPE i,
     v_lines_bin  TYPE i.

DATA : gv_fm_name    TYPE rs38l_fnam,
       gs_controls   TYPE ssfctrlop,
       gs_output     TYPE ssfcompop,
       gs_job_output TYPE ssfcrescl,
       gt_form TYPE TABLE OF zsf_ab_s_0003,
       gs_form TYPE zsf_ab_s_0003.

  DATA : lv_bukrs   TYPE bukrs,
         lv_gjahr   TYPE gjahr,
         lv_stcd1   TYPE stcd1,
         lv_stcd2   TYPE stcd2,
         lv_belnr   TYPE belnr_d,
         lv_bldat   TYPE bldat,
         lv_sgtxt   TYPE sgtxt,
         lv_word    TYPE char100,
         lv_decword TYPE char50,
         lv_address TYPE char100,
         lv_name    TYPE char50,
         lv_total   LIKE bseg-wrbtr.

start-of-selection.

  gs_controls-no_dialog = 'X'.
  gs_controls-getotf    = 'X'.
  gs_controls-preview   = 'X'.
  gs_output-tddest      = 'LP01'.

 PERFORM call_smartform.

  PERFORM convert_to_otf_format.

  PERFORM pdf_formatting.

  PERFORM build_mail_format.

  PERFORM send_mail.


form call_smartform.


  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
    EXPORTING
      formname = 'ZSF_SF_AB_0001'
*     VARIANT  = ' '
*     DIRECT_CALL              = ' '
    IMPORTING
      fm_name  = gv_fm_name
*   EXCEPTIONS
*     NO_FORM  = 1
*     NO_FUNCTION_MODULE       = 2
*     OTHERS   = 3
    .
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.


  CALL FUNCTION gv_fm_name
    EXPORTING
*     ARCHIVE_INDEX      =
*     ARCHIVE_INDEX_TAB  =
*     ARCHIVE_PARAMETERS =
      control_parameters = gs_controls
*     MAIL_APPL_OBJ      =
*     MAIL_RECIPIENT     =
*     MAIL_SENDER        =
      output_options     = gs_output
      user_settings      = ' '
      iv_bukrs           = lv_bukrs
      iv_gjahr           = lv_gjahr
      iv_stcd1           = lv_stcd1
      iv_stcd2           = lv_stcd2
      iv_belnr           = lv_belnr
      iv_bldat           = lv_bldat
      iv_sgtxt           = lv_sgtxt
      iv_word            = lv_word
      iv_decword         = lv_decword
      iv_total           = lv_total
      iv_name            = lv_name
      iv_address         = lv_address
      it_form            = gt_form
    IMPORTING
      job_output_info    = gs_job_output.

  CLEAR : gs_controls.
  CLEAR : gt_form.

*      control_parameters = w_ctrlop gs_controls
*      output_options     = w_compop gs_output
*    IMPORTING
*      job_output_info    = w_return gs_job_output
*    TABLES
*      it_det             = gt_items

endform.

form convert_to_otf_format.
  i_otf[] = gs_job_output-otfdata[].

  CALL FUNCTION 'CONVERT_OTF'
    EXPORTING
      format                = 'PDF'
      max_linewidth         = 132
    IMPORTING
      bin_filesize          = v_len_in
    TABLES
      otf                   = i_otf
      lines                 = i_tline
    EXCEPTIONS
      err_max_linewidth     = 1
      err_format            = 2
      err_conv_not_possible = 3
      OTHERS                = 4.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
    WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

endform.


form pdf_formatting.


* Convert PDF from 132 to 255.
  LOOP AT i_tline.
* Replacing space by ~
    TRANSLATE i_tline USING ' ~'.
    CONCATENATE w_buffer i_tline INTO w_buffer.
  ENDLOOP.

* Replacing ~ by space
  TRANSLATE w_buffer USING '~ '.
  DO.
    i_record = w_buffer.
* Appending 255 characters as a record
    APPEND i_record.
    SHIFT w_buffer LEFT BY 255 PLACES.
    IF w_buffer IS INITIAL.
      EXIT.
    ENDIF.
  ENDDO.

endform.

FORM build_mail_format .

 DATA:lv_dash(1)         TYPE c VALUE '-'.
  DATA:lv_xtn(4)          TYPE c VALUE '.pdf'.
  CONSTANTS:lv_esacpe     TYPE so_escape  VALUE 'U'.
  CONSTANTS:lv_so_obj_tp  TYPE so_obj_tp  VALUE 'PDF'.
  CONSTANTS:lv_so_obj_tp1 TYPE so_obj_tp  VALUE 'RAW'.
  CONSTANTS:lv_so_obj_sns TYPE so_obj_sns VALUE 'F'.

* Get Email ID's
*  SELECT * INTO TABLE gt_address[] FROM adr6
*  WHERE addrnumber = gw_kna1-adrnr.

  REFRESH:i_reclist,
          i_objtxt,
          i_objbin,
          i_objpack.

  CLEAR w_objhead.

* Object with PDF.
  i_objbin[] = i_record[].

  DESCRIBE TABLE i_objbin[] LINES v_lines_bin.

* Object with main text of the mail.
  i_objtxt = text-002.
  APPEND i_objtxt.

  DESCRIBE TABLE i_objtxt LINES v_lines_txt.

* Document information.
  w_doc_chng-obj_name = text-005.
  w_doc_chng-expiry_dat = sy-datum + 10.

  CONCATENATE w_doc_chng-obj_descr 'lv_dash' 'v_vbeln' INTO w_doc_chng-obj_descr.

  w_doc_chng-sensitivty = lv_so_obj_sns. "Functional object
  w_doc_chng-doc_size = v_lines_txt * 255.

* Pack to main body as RAW.
* Obj. to be transported not in binary form
  CLEAR i_objpack-transf_bin.

* Start line of object header in transport packet
  i_objpack-head_start = 1.

* Number of lines of an object header in object packet
  i_objpack-head_num = 0.

* Start line of object contents in an object packet
  i_objpack-body_start = 1.

* Number of lines of the object contents in an object packet
  i_objpack-body_num = v_lines_txt.

* Code for document class
  i_objpack-doc_type = lv_so_obj_tp1.

  APPEND i_objpack.

* Packing as PDF.
  i_objpack-transf_bin = 'X'.
  i_objpack-head_start = 1.
  i_objpack-head_num = 1.
  i_objpack-body_start = 1.
  i_objpack-body_num = v_lines_bin.
  i_objpack-doc_type = lv_so_obj_tp.
  i_objpack-obj_name = text-005.


  CONCATENATE w_doc_chng-obj_descr 'lv_xtn' INTO i_objpack-obj_descr.
  i_objpack-doc_size = v_lines_bin * 255.
  APPEND i_objpack.

* Document information.
  CLEAR i_reclist.

* e-mail receivers.
*  LOOP AT gt_address INTO gw_adr6.
    i_reclist-receiver = 'test@test1234.com'.
    i_reclist-express =  'X'.
    i_reclist-rec_type = lv_esacpe. "Internet address
    APPEND i_reclist.
*  ENDLOOP.

endform.

FORM send_mail .

  CALL FUNCTION 'SO_NEW_DOCUMENT_ATT_SEND_API1'
    EXPORTING
      document_data              = w_doc_chng
      put_in_outbox              = ' '
    TABLES
      packing_list               = i_objpack[]
      object_header              = w_objhead[]
      contents_bin               = i_objbin[]
      contents_txt               = i_objtxt[]
      receivers                  = i_reclist[]
    EXCEPTIONS
      too_many_receivers         = 1
      document_not_sent          = 2
      document_type_not_exist    = 3
      operation_no_authorization = 4
      parameter_error            = 5
      x_error                    = 6
      enqueue_error              = 7
      OTHERS                     = 8.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
    WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  COMMIT WORK.

ENDFORM.
