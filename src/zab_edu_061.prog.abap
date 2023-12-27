*&---------------------------------------------------------------------*
*& Report ZAB_EDU_061
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZAB_EDU_061.

TABLES:
  sscrfields.TYPE-POOLS icon.
DATA :  li_txline  TYPE STANDARD TABLE OF txline.
SELECTION-SCREEN: PUSHBUTTON 33(35) ebtn USER-COMMAND editor
                                         MODIF ID g1
                                         VISIBLE LENGTH 25.
INITIALIZATION.

  CALL FUNCTION 'ICON_CREATE'
    EXPORTING
      name   = icon_msg
      text   = 'hi'
      info   = 'EDITOR'
    IMPORTING
      RESULT = ebtn
    EXCEPTIONS
      OTHERS = 0.
AT SELECTION-SCREEN.
  CASE sscrfields.
    WHEN 'EDITOR'.
      CALL FUNCTION 'CATSXT_SIMPLE_TEXT_EDITOR'
        EXPORTING
          im_title        = 'hi'
          im_display_mode = space
        CHANGING
          ch_text         = li_txline[].

*      li_txline[]-

      data(lv) = li_txline.
   BREAK-POINT.
  ENDCASE.
