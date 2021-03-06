//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2020, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+
#property copyright "jfdelosrios@hotmail.com 2022."
#property link      "https://github.com/jfdelosrios/medidor"
#property version   "1.00"
#property description "Script que da a conocer:"
#property description "* Cuantos pixeles hay en cierta cantidad de puntos."
#property description "* Cuantas puntos hay en cierta cantidad de pixeles."
#property description "Imprime el resultado en la pestaña Expertos de la caja de herramientas de la plataforma Metatrader."


#property script_show_inputs
#property strict


#include <Indicators\TimeSeries.mqh>
#include <Trade\SymbolInfo.mqh>


enum ENUM_TIPO_MEDIDA
  {
   pixelesApuntos, // Pixeles a puntos
   puntosApixeles // Puntos a pixeles
  };


input ENUM_TIPO_MEDIDA tipoMedida; // Tipo de medida
input uint cantidad; // Cantidad


//+------------------------------------------------------------------+
//| Convierte una distancia de pixeles a puntos                      |
//|                                                                  |
//| Si la conversion no es satisfactoria devuelve -1                 |
//+------------------------------------------------------------------+
int CalcularDistanciaPuntos(
   const uint _distanciaPixeles,
   CSymbolInfo & simbolo
)
  {

   int      sub_window;
   datetime time1;
   double   price1 = 0;
   double   price2 = 0;

   if(!ChartXYToTimePrice(
         0,          // identificador del gráfico
         0,          // coordinada X en el gráfico
         0,          // coordinada Y en el gráfico
         sub_window, // número de subventana
         time1,      // fecha/hora en el gráfico
         price1      // precio en el gráfico
      ))
      return -1;

   if(!ChartXYToTimePrice(
         0,                 // identificador del gráfico
         0,                 // coordinada X en el gráfico
         _distanciaPixeles, // coordinada Y en el gráfico
         sub_window,        // número de subventana
         time1,             // fecha/hora en el gráfico
         price2             // precio en el gráfico
      ))
      return -1;

   return int(MathAbs(price1 - price2) / simbolo.Point());
  }


//+------------------------------------------------------------------+
//| Convierte una distancia de puntos a pixeles                      |
//|                                                                  |
//| Si la conversion no es satisfactoria devuelve -1                 |
//+------------------------------------------------------------------+
int CalcularDistanciaPixeles(
   const uint _distanciaPuntos,
   CSymbolInfo &simbolo
)
  {

   CiTime Time;

   if(!Time.Create(simbolo.Name(),PERIOD_CURRENT))
     {

      Print(
         "Error " + IntegerToString(_LastError) +
         ", linea" + IntegerToString(__LINE__)
      );

      return -1;
     }

   simbolo.RefreshRates();
   Time.Refresh();

   const double precioBase = simbolo.Ask();

   int x;

   int y1;

   if(!ChartTimePriceToXY(
         0,
         0,
         Time.GetData(0),
         precioBase,
         x,
         y1
      ))
     {

      Print(
         "Error " + IntegerToString(_LastError) +
         ", linea" + IntegerToString(__LINE__)
      );

      return -1;
     }

   int y2;

   if(!ChartTimePriceToXY(
         0,
         0,
         Time.GetData(0),
         precioBase + _distanciaPuntos * simbolo.Point(),
         x,
         y2
      ))
     {

      Print(
         "Error " + IntegerToString(_LastError) +
         ", linea" + IntegerToString(__LINE__)
      );

      return -1;
     }

   return (int)MathAbs(y1 - y2);

  }


//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---

   CSymbolInfo simbolo;

   if(!simbolo.Name(_Symbol))
     {

      Print(
         "Error " + IntegerToString(_LastError) +
         ", linea" + IntegerToString(__LINE__)
      );

      return;
     }

   if(tipoMedida == pixelesApuntos)
     {

      Print(

         IntegerToString(cantidad) +

         " pixeles = " +

         IntegerToString(
            CalcularDistanciaPuntos(cantidad, simbolo)
         ) +

         " puntos"

      );

     }
   else //tipoMedida == puntosApixeles
     {

      Print(

         IntegerToString(cantidad) +

         " puntos = " +

         IntegerToString(CalcularDistanciaPixeles(cantidad, simbolo)) +

         " pixeles"

      );

     }
  }
//+------------------------------------------------------------------+
