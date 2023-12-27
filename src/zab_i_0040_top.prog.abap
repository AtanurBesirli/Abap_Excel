*&---------------------------------------------------------------------*
*& Include          ZEGT_I_0018_TOP
*&---------------------------------------------------------------------*

data: gt_scarr   type table of scarr,
      gs_scarr   type scarr,
      gv_carrid  type s_carr_id,
      gv_carrid2 type scarr-carrid.

data: begin of gs_new,
        carrid   type s_carr_id,
        carrname type s_carrname,
      end of gs_new,
      gt_new like table of gs_new.

data: gt_sflight type table of sflight,
      gs_sflight type sflight.

data: gv_seatsocc_f type s_socc_f.

*data: gv_string1(30) type c value 'KİTAPLIK',
*      gv_string2(30) type c value 'KİTAP',
*      gv_string3(30) type c value 'ABCDQQQEFG',
*      gv_string4(30) type c value 'QQQ',
*      gv_string5(30) type c value 'ABCDQ'.

data: gt_sflight_new type table of sflight,
      gs_sflight_new like line of gt_sflight_new.

data: gt_sflight_new2 type table of sflight,
      gs_sflight_new2 like line of gt_sflight_new.

data: gt_sflight_new3 type table of sflight with header line.

data: gv_char1(30) type c,
      gv_char2(30) type c,
      gv_char3(30) type c,
      gv_char4(30) type c,
      gv_char5(50) type c.

data: gv_int1 type i.

data: gv_matnr type mara-matnr.

data: gv_using type char50.

data: begin of gs_data,
        ebeln type ebeln,
        bukrs type bukrs,
        bstyp type ebstyp,
        bsart type esart,
        bsakz type bsakz,
        loekz type eloek,
      end of gs_data,
      gt_data like table of gs_data.

data: begin of gs_data_new,
        ebeln type ebeln,
        bukrs type bukrs,
        bstyp type ebstyp,
        bsart type esart,
        bsakz type bsakz,
        loekz type eloek,
      end of gs_data_new,
      gt_data_new like table of gs_data_new.

define gm_demo.
  data lv_demo(10) type c.
  lv_demo = &1.
  write: / lv_demo.
END-OF-DEFINITION.
