*&---------------------------------------------------------------------*
*& Report ZAB_EDU_0002
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZAB_EDU_0002.

DATA : gv_var1 TYPE i,
       gv_var2 TYPE n LENGTH 10,
       gv_var3 TYPE i,
       gv_text TYPE string.

gv_var1 = 1.
gv_var2 = 30.

*WRITE : gv_var1,
*      / gv_var2.

*gv_text = 'Toplam = '.
*gv_var3 = gv_var1 + gv_var2.
*WRITE : gv_text , gv_var3.

*IF gv_var1 > gv_var2.
*  WRITE : 'First number is bigger than second one.'.
*  ELSEIF gv_var2 > gv_var1.
*  WRITE : 'Second number is bigger than first one.'.
*  ELSE.
*  WRITE : 'First number is equal to secoond number.'.
*ENDIF.

*CASE gv_var1.
*  WHEN 10.
*    WRITE '10'.
*  WHEN 20.
*    WRITE '20'.
*  WHEN OTHERS.
*    WRITE 'Others'.
*ENDCASE.

*DO 10 TIMES.
*  WRITE : / gv_var1 , 'DO'.
*  gv_var1 = gv_var1 + 1.
*ENDDO.

WHILE gv_var1 < 10.
  WRITE : / gv_var1 , 'WHILE'.
  gv_var1 = gv_var1 + 1.
ENDWHILE.
