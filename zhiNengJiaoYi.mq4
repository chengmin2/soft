//+------------------------------------------------------------------+
//|                                                        study.mq4 |
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
input double volum=0.1;
datetime alarm=0;
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

  }//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {

   if(alarm!=Time[0])   //datetime格式变量alarm在全局变量中定义，保证同一根K线只执行一遍代码。
     {
      if(CheckOrderByaSymbol()==0)
        {
         jy.iSendOrder(jy.iSingal(Symbol()),Symbol(),volum);
        }

      jy.fanXianJC(Symbol(),5131148);
      alarm=Time[0];
     }



  }
//+------------------------------------------------------------------+
void jiaoyi()
  {
   int  total=OrdersTotal();
   if(total==0)
     {
      double ima = iMA(Symbol(),0,14,0,MODE_SMA,PRICE_CLOSE,0);

      if(Ask>ima && (Open[1]<iMA(Symbol(),0,14,0,MODE_SMA,PRICE_CLOSE,1) || Open[1]==iMA(Symbol(),0,14,0,MODE_SMA,PRICE_CLOSE,1))) //方向向上
        {
         OrderSend(Symbol(),OP_BUY,volum,Ask,0,0,"BUY",51131148,2);
        }
      if(Bid<ima && (Close[1]>iMA(Symbol(),0,14,0,MODE_SMA,PRICE_CLOSE,1) || Close[1]==iMA(Symbol(),0,14,0,MODE_SMA,PRICE_CLOSE,1))) //方向向下
        {
         OrderSend(Symbol(),OP_SELL,volum,Bid,0,0,"Sell",51131148,2);
        }
     }

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int CheckOrderByaSymbol() //检查订单中当前货币的单数
  {
   int  total=OrdersTotal();
   int rt=0;
   for(int i=0; i<total; i++)
     {
      if(OrderSelect(i,SELECT_BY_POS))
        {
         if(OrderSymbol()==Symbol())
            rt=1;
        }
     }
   return rt;
  }




//+------------------------------------------------------------------+
