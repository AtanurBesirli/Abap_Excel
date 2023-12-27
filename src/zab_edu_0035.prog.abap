*&---------------------------------------------------------------------*
*& Report ZAB_EDU_0035
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zab_edu_0035.

SELECT EBELN,
       BUKRS,
       BSTYP,
       BSART,
       BSAKZ,
       LOEKZ UP TO 100 ROWS
  FROM ekko INTO TABLE @DATA(lt_data).

CALL FUNCTION 'ZAB_F_0001'
  TABLES
    table         = lt_data
.
BREAK-POINT.
