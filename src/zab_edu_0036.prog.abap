*&---------------------------------------------------------------------*
*& Report ZAB_EDU_0036
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZAB_EDU_0036.

*SELECTION-SCREEN:
*      PUSHBUTTON /2(40) button1 USER-COMMAND but1,
*      PUSHBUTTON /2(40) button2 USER-COMMAND but2.

SELECTION-SCREEN BEGIN OF BLOCK bl1 WITH FRAME TITLE text-001.
  SELECTION-SCREEN:
      PUSHBUTTON /2(40) button1 USER-COMMAND but1,
      PUSHBUTTON /2(40) button2 USER-COMMAND but2.

SELECTION-SCREEN END OF BLOCK bl1.
