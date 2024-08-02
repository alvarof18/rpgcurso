      *****************************************************************
      * Definicion de prototipo Get_Retprv                            *
      *****************************************************************
     dDs_retprv      e ds                  extname(retprv)
      *
     dGet_Retprv       pr            10I 0 Extproc('Get_Retprv')
     d In_Prvcod                      9S 0
     d Ou_ResRetprv                        likeds(Ds_retprv)
     d Ou_Message                   500A
      *
