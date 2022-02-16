//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2020, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+
#property copyright "jfdelosrios@hotmail.com 2022."
#property link      "https://github.com/jfdelosrios/medidor"
#property version   "1.00"
#property description "Da a conocer cuantos pixeles hay en cierta " 
#property description "cantidad de puntos."
#property script_show_inputs
#property strict

#include <Indicators\TimeSeries.mqh>
#include <Trade\SymbolInfo.mqh>

CSymbolInfo simbolo;
CiTime Time;

input int   puntos;


//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---

   if(!simbolo.Name(_Symbol))
     {

      Print(
         "Error " + IntegerToString(_LastError) +
         ", linea" + IntegerToString(__LINE__)
      );

      return;
     }

   if(!Time.Create(simbolo.Name(),PERIOD_CURRENT))
     {

      Print(
         "Error " + IntegerToString(_LastError) +
         ", linea" + IntegerToString(__LINE__)
      );

      return;
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

      return;
     }

   int y2;

   if(!ChartTimePriceToXY(
         0,
         0,
         Time.GetData(0),
         precioBase + puntos * simbolo.Point(),
         x,
         y2
      ))
     {

      Print(
         "Error " + IntegerToString(_LastError) +
         ", linea" + IntegerToString(__LINE__)
      );

      return;
     }

   Print(
      "Distancia en pixeles: " +
      IntegerToString((int)MathAbs(y1 - y2))
   );

  }
//+------------------------------------------------------------------+
