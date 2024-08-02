     h nomain
      **********************************************************************
      * Procedimiento para devolver un proveedor
      **********************************************************************
      /Copy Prototypes,get_retpvp
      *
     pGet_Retprv       b                   export
     dGet_Retprv       pi            10I 0
     d In_Prvcod                      9S 0
     d Ou_ResRetprv                        likeds(Ds_retprv)
     d Ou_Message                   500A
      *
     dnerror           S             10I 0
      *****************************************************************
      * Inicio de procedimiento                                       *
      *****************************************************************
        Exec Sql
         Select * into :Ou_ResRetprv from retprv where
                        revcod = :In_Prvcod;

         if sqlcode = 100;
            nerror  = 7; // Codigo de proveedor no valido
         endif;
         nerror = sqlcode;

         if sqlcode <> 0 and sqlcode <> 100;
            Ou_Message = 'Error SQL: ' + %Char(Sqlcode) +
                                     '! modulo: GET_RETPVR';
            nerror = 9999; //Error al ejecutar sentencia SQL
         endif;
         return nerror;
     pGet_Retprv       e
