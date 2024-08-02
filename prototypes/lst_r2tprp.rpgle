      *****************************************************************
      * Definicion de prototipo Lst_r2tprp                            *
      *****************************************************************
     dDs_r2tpro      e ds                  extname(retpro) qualified
     d                                     prefix(r2:2)

     dLst_R2tpro       pr            10I 0 Extproc('Lst_R2tpro')
     d In_nombre                     10a
     d Ou_R2tpro                           likeds(Ds_r2tpro) Dim(500)
     d Ou_Message                   500A
      *
