     h nomain
      **********************************************************************
      * Procedimiento para devolver una descripcion de un codigo de error  *
      **********************************************************************
      /Copy prototypes,Get_retmsp
      *
     pGet_retmsg       b                   export
     dGet_retmsg       pi            10I 0
     d In_CodErr                     10I 0
     d Ou_Message                   500A
      *
     dnerror           S             10I 0
      *****************************************************************
      * Inicio de procedimiento                                       *
      *****************************************************************
        Exec Sql
         Select regnom into :Ou_Message from retmsg where
                                 regcod = :In_CodErr;
         if sqlcode = 100;
            Ou_Message = 'Mensaje no parametrizado';
         endif;
         nerror = sqlcode;

         if sqlcode <> 0 and sqlcode <> 100;
            Ou_Message = 'Error SQL: ' + %Char(Sqlcode) +
                                     '! modulo: GET_RETMSG';
            nerror = 9999; //Error al ejecutar sentencia SQL
         endif;
         return nerror;
     pGet_retmsg       e
