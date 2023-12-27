*&---------------------------------------------------------------------*
*& Report ZAB_EDU_0033
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zab_edu_0033.

*DATA: ur_string(13) VALUE 'idandher000',
*      str1(2)       VALUE '0'.
*
*SHIFT ur_string RIGHT DELETING TRAILING str1.
*
*WRITE ur_string.

*DATA : lv_str TYPE char20 VALUE 'ata000',
*       lv_zero TYPE char2 VALUE '0'.
*
*SHIFT lv_str RIGHT DELETING TRAILING lv_zero.
*
*WRITE / lv_str.

*DATA : lv_str TYPE char20 VALUE 'ata000',
*       lv_zero TYPE char2 VALUE '0'.
*
*CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
*  EXPORTING
*    input         =
** IMPORTING
**   OUTPUT        =
*          .
*
*
*WRITE / lv_str.

*DATA: ivals  TYPE TABLE OF sval.
*DATA: xvals  TYPE sval.
*
*SELECT * FROM scarr INTO TABLE @DATA(gt).
*
*xvals-tabname   = 'USR01'.
*xvals-fieldname = 'BNAME'. xvals-novaluehlp = ' '.
*append xvals to ivals.

*xvals-tabname   = 'USR02'.
*xvals-fieldname = 'BNAM1'.
*append xvals to ivals.
*LOOP AT gt INTO data(gs).
*xvals-tabname   = 'GT'.
*xvals-fieldname = 'CARRNAME'.
*xvals-novaluehlp = ' '.
*APPEND xvals TO ivals.
*ENDLOOP.

*CALL FUNCTION 'POPUP_GET_VALUES'
*  EXPORTING
*    popup_title     = 'What is your name?'
*  TABLES
*    fields          = ivals
*  EXCEPTIONS
*    error_in_fields = 1
*    OTHERS          = 2.
*
*READ TABLE ivals INTO xvals WITH KEY fieldname = 'BNAME'.
*IF sy-subrc  = 0.
*  WRITE:/ xvals-value.
*ENDIF.

*DATA : lt_mod TYPE TABLE OF zab_t_0030,
*       ls_mod TYPE  zab_t_0030.
*
*
*ls_mod-booking = 8.
*ls_mod-customername = 'ZAHA'.
*MODIFY zab_t_0030 FROM ls_mod.

*DATA: BEGIN OF fields OCCURS 1.
*        INCLUDE STRUCTURE sval.
*DATA: END OF fields.
*
*CLEAR fields.
*MOVE 'T001L' TO fields-tabname.
*MOVE 'WERKS' TO fields-fieldname.
*APPEND fields.
*CLEAR fields.
*MOVE 'T001L' TO fields-tabname.
*MOVE 'LGORT' TO fields-fieldname.
*APPEND fields.
*
*CALL FUNCTION 'POPUP_GET_VALUES_USER_HELP'
*  EXPORTING
*    popup_title = 'test'
*  TABLES
*    fields      = fields.

DATA : lt_scar TYPE TABLE of scarr,
       ls_scar TYPE scarr.

SELECt SINGLE carrid INTO CORRESPONDING FIELDS OF ls_scarr
SELECt carrname INTO CORRESPONDING FIELDS OF TABLE lt_scarr.
ls_scar-
BREAK-POINT.
