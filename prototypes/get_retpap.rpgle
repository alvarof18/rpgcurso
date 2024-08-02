      *****************************************************************
      * Definicion de prototipo Get_retpar                            *
      *****************************************************************
     dDs_retparm     e ds                  extname(retparm)
      *
     dGet_retparm      pr            10I 0 Extproc('Get_retparm')
     d In_Codflg                      2A
     d In_CodRef                      4A
     d Ou_Resretparm                       likeds(Ds_retparm)
     d Ou_Message                   500A
      *
