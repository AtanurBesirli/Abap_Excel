*&---------------------------------------------------------------------*
*& Report ZAB_EDU_062
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZAB_EDU_062.

* METHOD tckimlik_dogrula.
*    DATA: v_tcno    TYPE c LENGTH 11,
*          v_13579   TYPE i, " 1. 3. 5. 7. 9. basamak
*          v_13579x7 TYPE i, " 1. 3. 5. 7. 9. basamakların 7 katı
*          v_02468   TYPE i, " 2. 4. 6. 8. basamak
*          v_10      TYPE i,
*          v_11      TYPE i.
*
*    v_tcno = im_tckimlik.
*
*     1. 3. 5. 7. ve 9. hanelerin toplamı
*    v_13579 = v_tcno(1)   + v_tcno+2(1) + v_tcno+4(1)
*            + v_tcno+6(1) + v_tcno+8(1).
*
*     1. 3. 5. 7. ve 9. hanelerin toplamının 7 katı
*    v_13579x7 = v_13579 * 7.
*
*     2. 4. 6. ve 8. hanelerin toplamı
*    v_02468 = v_tcno+1(1) + v_tcno+3(1) + v_tcno+5(1)
*            + v_tcno+7(1).
*
*     Elde edilen sonucun 10'a bolumunden kalan
*     sayının Mod10'u bize 10. haneyi verir.
*    v_10 = ( v_13579x7 - v_02468 ) MOD 10.
*
*     Eldeki 10 hanenin toplamından elde edilen sonucun
*     10'a bolumunden kalan, yani Mod10'u bize 11. haneyi verir.
*    v_11 = ( v_13579 + v_02468 + v_10 ) MOD 10.
*
*
*    IF v_tcno+9(1) NE v_10.
*      es_retmsg = VALUE #( retcode = 4 msg = 'Geçersiz TC Kimlik numarası.' ).
*    ELSEIF v_tcno+10(1) NE v_11.
*      es_retmsg = VALUE #( retcode = 4 msg = 'Geçersiz TC Kimlik numarası.' ).
*    ENDIF.
*
*     TCKimlik sadece sayıdan oluşabilir
*    IF NOT v_tcno CA '0123456789'.
*      es_retmsg = VALUE #( retcode = 1
*                               msg = 'TC Kimlik numarası sadece sayıdan oluşabilir.' ).
*       TCKimlik no 11 karakter uzunluğunda olmalı.
*    ELSEIF strlen( v_tcno ) NE 11.
*      es_retmsg = VALUE #( retcode = 2
*                               msg = 'TC Kimlik numarası 11 karakter uzunluğunda olmalı.' ).
*       TCKimlik no sıfır ile başlayamaz
*    ELSEIF v_tcno(1) EQ 0.
*      es_retmsg = VALUE #( retcode = 3
*                               msg = 'TC Kimlik numarası sıfır ile başlayamaz.' ).
*    ENDIF.
*
*    IF es_retmsg-retcode IS INITIAL.
*      es_retmsg = VALUE #( retcode = 0 msg = 'TC Kimlik numarası doğru.' ).
*    ENDIF.
*  ENDMETHOD.

*zbc_t_cm_001
*
*ztools_cm_t001.

*select * FROM ztools_cm_t001 into TABLE @data(lv).
*
*  insert zbc_t_cm_001 FROM TABLE lv.
