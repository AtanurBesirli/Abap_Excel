*&---------------------------------------------------------------------*
*& Report ZAB_EDU_0006
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZAB_EDU_0006.

DATA : gt_scarr TYPE TABLE of scarr,
       gs_scarr TYPE scarr.
*DATA : gt_ekpo  TYPE TABLE of ekpo,
*       gs_ekpo  TYPE ekpo,
*       gv_txz01 TYPE txz01.
*
*TYPES : BEGIN OF gty_scarr,
**  CARRID   TYPE  S_CARR_ID,
*  CARRNAME TYPE  S_CARRNAME,
*  CURRCODE TYPE  S_CURRCODE,
**  URL      TYPE S_CARRURL,
*        END OF gty_scarr.
*
*DATA : gt_scarr TYPE TABLE OF gty_scarr,
*       gs_scarr TYPE gty_scarr.

START-OF-SELECTION.

*SELECT * FROM scarr INTO TABLE gt_scarr.

*SELECT * FROM scarr WHERE CARRNAME like 'A%'
*  INTO TABLE @gt_scarr.

*SELECT ekpo~ebeln FROM ekpo WHERE ebelp BETWEEN 10 and 25
*  INTO CORRESPONDING FIELDS OF TABLE @gt_ekpo.

*SELECT * FROM ekpo INTO TABLE gt_ekpo WHERE ebeln eq '4500000001'.
*READ TABLE gt_ekpo INTO gs_ekpo INDEX 1.
*  WRITE : gs_ekpo-txz01.

*SELECT * UP TO 10 ROWS FROM ekpo INTO TABLE gt_ekpo.

*SELECT SINGLE * FROM ekpo INTO gs_ekpo WHERE ebeln eq '4500000001'.
*  WRITE : gs_ekpo-txz01.

*SELECT SINGLE txz01 FROM ekpo INTO gv_txz01 WHERE ebeln eq '4500000001'.
*  WRITE gv_txz01.

*SELECT * FROM scarr INTO TABLE gt_scarr.
*READ TABLE gt_scarr INTO gs_scarr INDEX 4.
*  WRITE : gs_scarr.

*SELECT * FROM scarr INTO TABLE gt_scarr.
*READ TABLE gt_scarr INTO gs_scarr WITH KEY carrid = 'AZ'.
*WRITE : gs_scarr-carrname.

*SELECT * FROM scarr INTO TABLE gt_scarr.
*READ TABLE gt_scarr INTO gs_scarr WITH KEY currcode = 'EUR'
*                                           carrname = 'Air France'.
*WRITE gs_scarr.

*SELECT carrname currcode FROM scarr INTO CORRESPONDING
*   FIELDS OF TABLE gt_scarr.

*SELECT * FROM scarr INTO CORRESPONDING FIELDS OF TABLE gt_scarr.   "gty_scarr

*select * from scarr ORDER BY carrid INTO CORRESPONDING FIELDS OF TABLE @gt_scarr.



BREAK-POINT.
