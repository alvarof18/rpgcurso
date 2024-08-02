**free
ctl-opt nomain;
//*********************************************************
//Programa: SAV_ORDER
//Fecha...: 01/08/2024
//Objetivo: Modulo para grabar ordenes
//*********************************************************

//Archivos
dcl-f RETORH usage(*input:*output) keyed;
dcl-f RETORD usage(*output);

//Copys
/Copy PROTOTYPES,SAV_ORDERP
/Copy PROTOTYPES,GET_RETMSP
//Prototipos
dcl-proc sav_order Export;
    dcl-pi *n zoned(4);
        In_Order    likeds(InpOrderDs);
        Ou_Message  char(500);
    end-pi;
//Variables Internas
    dcl-s ierror zoned(4);
    dcl-s pError int(10);
    dcl-s newCode zoned(9);
    dcl-s ni zoned(3);
//Estructura Internas
    dcl-ds reg_Item likeds(ds_items);

//****************************************************************************
//Programa Principal                                                         *
//****************************************************************************
    ierror = *Zeros;
    clear reg_Item;
    ni = 1;

    ierror = val_Entrada(In_Order:Ou_Message);

    if (ierror = 0);
        newCode = Get_Cod();

        chain newCode RETORH;
        if not %found;
            RORCOD = newCode;
            RORPRV = In_Order.codprv;
            ROREST = In_Order.status;
            RORCRT = %TimeStamp();
            RORPGM = 'SAV_ORDER';
            RORTOT = In_Order.total;

            dow In_Order.lst_items(ni).codpro > 0;
                RDRCOO = newCode;
                RDRPRC = reg_Item.codpro;
                RDRCAN = reg_Item.canti;
                RDRPRP = reg_Item.precio;
                RDRSUB = reg_Item.canti * reg_Item.precio;
                write RRETORD;
                ni += 1;
            enddo;


            write RRETORH;
        else;
            //Nuevo Orden no puede ser procesada
            ierror = 17;
        endif;
    endif;
    pError = ierror;
    ierror = Get_retmsg(pError:Ou_Message);
    return ierror;
end-proc;
//****************************************************************************
//Genera codigo de Orden                                                     *
//****************************************************************************
dcl-proc Get_Cod;
    dcl-pi *n zoned(9);
    end-pi;

    //Variables Internas
    dcl-s codigo zoned(9);
//****************************************************************************
//Inicio de prototipo                                                        *
//****************************************************************************
    setll *end RETORH;
    readp RETORH;

    if not %eof;
        codigo = RORCOD + 1;
    else;
        codigo = 1;
    endif;
    return codigo;
end-proc;
//****************************************************************************
//Validaciones Generales                                                     *
//****************************************************************************
dcl-proc val_Entrada;
    dcl-pi *n zoned(4);
        In_Order    likeds(InpOrderDs);
        Ou_Message  char(500);
    end-pi;

    //Variables Internas
    dcl-s ierror zoned(4);
//****************************************************************************
//Inicio de prototipo                                                        *
//****************************************************************************
    //NEXT FEATURE
    //Validar el codigo del proveedor contra la tabla retprv
    if In_Order.codprv = 0;
        ierror = 7;
    endif;

    if ierror = 0;
        if In_Order.status <> 'P' and
           In_Order.status <> 'E' and
           In_Order.status <> 'C' and
           In_Order.status <> 'X';
            ierror = 11;
        endif;
    endif;

    if ierror = 0;
        if In_Order.total = 0;
            ierror = 15;
        endif;
    endif;

    if ierror = 0;
        if In_Order.lst_items(1).codpro = 0;
            ierror = 16;
        endif;
    endif;

    return ierror;
end-proc;
