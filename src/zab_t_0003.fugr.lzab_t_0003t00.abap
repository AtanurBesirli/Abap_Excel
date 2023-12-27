*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZAB_T_0003......................................*
DATA:  BEGIN OF STATUS_ZAB_T_0003                    .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZAB_T_0003                    .
CONTROLS: TCTRL_ZAB_T_0003
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZAB_T_0003                    .
TABLES: ZAB_T_0003                     .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
