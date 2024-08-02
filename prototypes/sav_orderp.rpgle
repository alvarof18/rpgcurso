**free

// *********************************************************
// Programa: SAV_ORDERP
// Fecha...: 01/08/2024
// Objetivo: Prototipo para grabar ordenes
// *********************************************************

// Estructura de entrada
dcl-ds InpOrderDs qualified;
    codprv zoned(9);
    status char(1);
    total zoned(17:2);
    lst_items likeds(ds_items) dim(100);
end-ds;

// Estructura de Items de Orden
dcl-ds ds_items qualified;
    codpro zoned(9);
    canti zoned(3);
    precio zoned(17:2);
end-ds;

//
// Definicion de prototipo
//

dcl-pr sav_order zoned(4) Extproc('SaveOrder');
    In_Order    likeds(InpOrderDs);
    Ou_Message  char(500);
end-pr;

