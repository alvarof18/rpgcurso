**free
ctl-opt debug(*yes) option(*srcstmt:*nodebugio);
ctl-opt bnddir('BNDORDER');

//*********************************************************
//Programa: RORD01
//Fecha...: 01/08/2024
//Objetivo: Grabar Ordenes
//*********************************************************

//CRTBNDDIR BNDDIR(BNDORDER) TEXT('Directorio de enlaces Ordenes')
//WRKBNDDIRE BNDDIR(BNDORDER)

//Archivos
dcl-f RORD01FM workstn sfile(RORD000SFL:NumR);
dcl-f RETORH keyed;

//Variables
dcl-s NumR zoned(4);
dcl-s newCode zoned(9);
dcl-s indicadores pointer Inz(%Addr(*In));
dcl-s currentDate zoned(8);
dcl-s ierror Int(10);
dcl-s In_Code zoned(9);
dcl-s Ou_Message char(500);
dcl-s ni zoned(2);
dcl-s index zoned(2);

//Estructuras
dcl-ds IndDsplay based(indicadores);
    Aceptar ind pos(1);
    Salir ind pos(3);
    Productos ind pos(4);
    Grabar ind pos(10);
    Enter ind pos(25);
    VerSf  ind pos(40);
    VerCabSf ind pos(41);
    iniSf ind pos(42);
    LimpiarSf ind pos(43);
end-ds;

dcl-ds PgmsDs psds qualified;
    CurrentUser char(10) pos(358);
end-ds;

dcl-ds lstArticulos qualified dim(10);
    procod zoned(9);
    procan zoned(5);
    propre zoned(7:2);
end-ds;

dcl-ds Ou_Proveedor likeds(Ds_retprv);
dcl-ds Ou_Producto likeds(Ds_Retpro);
dcl-ds In_Order    likeds(InpOrderDs);
dcl-ds regItem likeds(ds_items);

//Copys
/copy prototypes,get_retpvp
/Copy Prototypes,Get_retprp
/Copy prototypes,Sav_Orderp

//****************************************************************************
//Programa Principal                                                         *
//****************************************************************************

Exsr Inicializar;
//Exsr Cargar;
Exsr MostrarSF;

*inlr = *on;
//****************************************************************************
//Subrutina de inicializacion
//****************************************************************************
Begsr Inicializar;

    clear In_Order;
    VerSf = *Off;
    VerCabSf = *Off;
    IniSf = *Off;
    LimpiarSf = *On;
    NumR = 1;
    ni = 1;
    setll *end RETORH;
    readp RETORH;
    if not %eof;
        newCode = RORCOD + 1;
    else;
        newCode = 1;
    endif;
    $NRORD = %editc(newCode :'X');
    currentDate = %Dec(%Date() : *ISO);
    TITLE = '         AGREGAR ORDEN';
    $STSORD = 'P';
    $CRTORD = %EditC(currentDate : 'X');
    $USRCRT = PgmsDs.CurrentUser;
    $TOTAL = 00000.00;
    Write RORD000CTL;
Endsr;

//****************************************************************************
//Mostrar Subfile                                                         *
//****************************************************************************
Begsr MostrarSF;

    VerCabSf = *On;
    LimpiarSf = *Off;
    Enter = *On;
    Write RORD000PIE;
    Dow salir <> *On;
        Exfmt RORD000CTL;
        if Enter =*off and $CODPRV > 0;
            In_Code = $CODPRV;
            ierror = Get_Retprv(In_Code:Ou_Proveedor:Ou_Message);
            if ierror = 0;
                $DSCPRV = %subst(Ou_Proveedor.REVNOM :1 :30);
            else;
                $DSCPRV = 'CODIGO DE PRV NO VALIDO';
            endif;
            Enter =*On;
        endif;
        if Productos = *On;
            Exsr addProductos;
            Productos = *Off;
        endif;

        if Grabar = *On and lstArticulos(1).procod > 0;

            In_Order.codprv = $CODPRV;
            In_Order.status = $STSORD;
            In_Order.total = $TOTAL;
            for index = 1 to ni - 1;
                clear regItem;
                regItem.codpro = lstArticulos(index).procod;
                regItem.canti = lstArticulos(index).procan;
                regItem.precio = lstArticulos(index).propre;
                In_Order.lst_items(index) = regItem;
            endfor;
            ierror = sav_order(In_Order:Ou_Message);
            if (ierror = *Zeros);
                $MSG = 'Registro guardado exitosamente';
            endif;
            Grabar = *Off;
        endif;
    Enddo;
Endsr;

//****************************************************************************
//Agregar productos                                                        *
//****************************************************************************
Begsr addProductos;
    salir = *off;
    Enter = *on;
    Aceptar = *off;
    Dow salir <> *On;
        Exfmt RORD000W;
        $WMSG = *blanks;
        if Enter = *off and $WCODPRO > 0 ;
            In_Code = $WCODPRO;
            ierror = Get_retpro(In_Code:Ou_Producto:Ou_Message);
            if ierror = 0;
                $WDSCPRO = Ou_Producto.REPNOM;
                $WPROPRE = Ou_Producto.REPPRI;
            else;
                $WMSG = 'PRODUCTO CODIGO INVALIDO';
            endif;
            Enter = *on;
        endif;

        if Aceptar = *on and $WMSG = *blanks;
            if VerSf <> *On;
                VerSf = *On;
            endif;
            $PROCOD = Ou_Producto.REPCOD;
            $PRONAM = Ou_Producto.REPNOM;
            $PROCAN = $WPROCAN;
            $PROPRE = Ou_Producto.REPPRI;
            $SUBTOTAL = $WPROCAN * $PROPRE;
            $TOTAL += $SUBTOTAL;
            Write RORD000SFL;
            NumR += 1;
            lstArticulos(ni).procan = $PROCAN;
            lstArticulos(ni).procod = $PROCOD;
            lstArticulos(ni).propre = $PROPRE;
            ni += 1;
            Aceptar = *off;
        endif;
    Enddo;
    $WDSCPRO = *blanks;
    $WPROPRE = 0;
    $WPROCAN = 0;
    salir = *off;
Endsr;

