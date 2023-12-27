*&---------------------------------------------------------------------*
*& Report ZAB_EDU_0010
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zab_edu_0010.

*DATA : num1    TYPE p DECIMALS 1 VALUE '3.73',
*       result1 TYPE i.
*
*result1 = num1.
*
*WRITE : result1.

*DATA : num1    TYPE p DECIMALS 2 VALUE '5.73',
*       num2    TYPE p DECIMALS 2 VALUE '1.73',
*       result1 TYPE p DECIMALS 2.
*
*result1 = num1 / num2.  "vigülden sonrası var       result1 = num1 DIV num2. "DIV de virgülden sonrası yok
*
*WRITE : result1.

*DATA : zname1 TYPE char30 VALUE 'Doğu',
*       zname2 TYPE char40 VALUE 'BEŞİRLİ',
*       zname3 LIKE zname2.
*
*CONCATENATE zname1 zname2 INTO zname3 SEPARATED BY space.
*
*WRITE zname3.

*DATA : zname4 TYPE char30 VALUE 'Doğu     BEŞİRLİ   .'.
*CONDENSE zname4.
*WRITE zname4.

*DATA : zname5 TYPE char30 VALUE 'Mr Doğu BEŞİRLİ'.
**SEARCH zname5 FOR 'Doğu'.
*SEARCH zname5 FOR 'BE*'.
*WRITE : / sy-subrc , / sy-fdpos.

DATA : ztel_num1 TYPE char13 VALUE '+90 555 55 55',
       ztel_code TYPE char2,
       ztel_comp TYPE char3.

ztel_code = ztel_num1+1(2).
ztel_comp = ztel_num1+4(3).

WRITE : ztel_num1 , / ztel_code , / ztel_comp.
