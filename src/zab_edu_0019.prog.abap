*&---------------------------------------------------------------------*
*& Report ZAB_EDU_0019
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zab_edu_0019.

TABLES : ZAB_T_0020.

DATA : gt_itab     TYPE TABLE OF ZAB_T_0020,
       gs_itab     TYPE ZAB_T_0020,
       gt_raw_data TYPE truxs_t_text_data.

START-OF-SELECTION.

*  PARAMETERS p_file TYPE rlgrap-filename.
DATA : p_file TYPE rlgrap-filename.
*AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.

  CALL FUNCTION 'F4_FILENAME'
  EXPORTING
    FIELD_NAME          = 'P_FILE'
    IMPORTING
      file_name = p_file.




  CALL FUNCTION 'TEXT_CONVERT_XLS_TO_SAP'
    EXPORTING
*     I_FIELD_SEPERATOR    =
     I_LINE_HEADER        = 'X'
      i_tab_raw_data       = gt_raw_data
      i_filename           = p_file
    TABLES
      i_tab_converted_data = gt_itab
 EXCEPTIONS
     CONVERSION_FAILED    = 1
     OTHERS               = 2
    .
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

LOOP AT gt_itab INTO gs_itab.
  INSERT ZAB_T_0020 FROM gs_itab.
ENDLOOP.

***DELETE FROM ZLIB_AB_T_0001.

*BREAK-POINT.
