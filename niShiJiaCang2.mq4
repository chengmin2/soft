//+------------------------------------------------------------------+
//|                                                 niShiJiaCnag.mq4 |
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
datetime alarm=0;
int magic=123456;
double volume=0.01;
#include <myInclude\ZhiNengJiaoYi.mqh>
ZhiNengJiaoYi jy;
int OnInit()
  {

   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {

  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
   if(alarm!=Time[0])   //datetime格式变量alarm在全局变量中定义，保证同一根K线只执 p 行一遍代码。
     {

      if(jy.CheckOrderByaSymbol(Symbol(),magic)==0)
        {
         OrderSend(Symbol(),OP_BUY,volume,Ask,3,0,0,"buy",magic);
        }
      jy.niSiJiaCang2(Symbol(),volume,magic);
      alarm=Time[0];

     }
   if(jy.profitBySymbolTotal(Symbol(),magic,OP_BUY)>5)
     {
      jy.ColseOrderBySymbol(Symbol(),magic,OP_BUY);

     }


   if(jy.profitBySymbolTotal(Symbol(),magic,OP_SELL)>5)
     {
      jy.ColseOrderBySymbol(Symbol(),magic,OP_SELL);
     }

  }

//+------------------------------------------------------------------+
