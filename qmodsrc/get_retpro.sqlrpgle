     h nomain
      **********************************************************************
      * Modulo para obtener un producto utilizando su codigo
      **********************************************************************
      /Copy Prototypes,Get_Retprp
     pGet_Retpro       B                   Export
     dGet_Retpro       pi            10I 0
     d In_procod                      9S 0
     d Ou_xResRetpro                       likeds(Ds_Retpro)
     d Ou_Message                   500A
      *
     d error           S             10I 0
      **********************************************************************
      * Inicio de procedimiento
      **********************************************************************

         clear Ou_xResRetpro;
         clear Ou_Message;

         Exec Sql
            Select * into :Ou_xResRetpro from retpro where
                                     repcod = :In_procod;

         if sqlcode = 100;
            error = 1;
         endif;

         if sqlcode <> 100 and sqlcode <> 0;
            Ou_Message = 'Error SQL: ' + %Char(sqlcode) +
                                     '! modulo: GET_RETPRO';
            error = 9999;
         endif;
       return error;
     pGet_Retpro       E
