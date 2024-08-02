      ***********************************************************************
      * Prototipo Servicio de consulta de productos                         *
      ***********************************************************************
      *Estrutura de Entrada
     dDs_InpGetProd    ds                  Qualified
     d BusquedaPor                    1A
     d Condicion                     20A

      *Estrutura de Salida
     dDs_OutGetProd    ds                  Qualified
     d lst_productos                       likeds(Ds_Producto) Dim(100)

      *Estructura de Producto
     dDs_Producto      ds                  Qualified
     d Codigo                         9s 0
     d Descripcion                  100A
     d Stock                          5S 0
     d Precio                        10S 2
     d Categoria                      4A
     d Estado                         1A
     d Proveedor                      9S 0
     d Medida                         4A
      **********************************************************************
     dGet_Product      pr            10I 0 Extproc('ObtenerProductos')
     d In_Busqueda                         likeds(Ds_InpGetProd)
     d Ou_Productos                        likeds(Ds_OutGetProd)
     d Ou_Message                   500A
