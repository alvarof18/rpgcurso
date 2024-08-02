      **********************************************************************
      * Definicion de prototipo GET_RETPRO                                 *
      * Obtener producto usando su codigo
      **********************************************************************
     dDs_Retpro      e ds                  extname(retpro) qualified
      *
     dGet_retpro       pr            10I 0 Extproc('Get_retpro')
     d In_procod                      9S 0
     d Ou_xResRetpro                       likeds(Ds_Retpro)
     d Ou_Message                   500A

