//+------------------------------------------------------------------+
//|                                                           9转.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   
  }
 /** bool kaiDuo(){
   if(Close[9]<Close[13]&&
     Close[8]<Close[12]&&
     Close[7]<Close[11]&&
     Close[6]<Close[10]&&
     Close[5]<Close[9]&&
     Close[4]<Close[8]&&
     Close[3]<Close[7]&&
     Close[2]<Close[6]&&
     Close[1]<Close[5] && 
     (Close[2]<MathMin(Close[3],Close[4]) ||
      Close[1]<MathMin(Close[3],Close[4]))){
      
      }
  }
  */
//+------------------------------------------------------------------+
