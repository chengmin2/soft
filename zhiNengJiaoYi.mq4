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
input double volum=0.01;
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
         iSendOrder(iSingal());
        }

      jy.fanXianJC(Symbol());
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
//|                                                                  |
//+------------------------------------------------------------------+
int iSingal() //做空做多信号
  {
   int mySingal = 9;
   double myMa= iMA(Symbol(),0,14,0,MODE_SMA,PRICE_CLOSE,1);
   double iLow_0 = iCustom(Symbol(),0,"myZhiBiao",20,1,0);
   double iLow_1 = iCustom(Symbol(),0,"myZhiBiao",20,1,1);
   double iLow_2 = iCustom(Symbol(),0,"myZhiBiao",20,1,2);
   double iHigh_0 = iCustom(Symbol(),0,"myZhiBiao",20,0,0);
   double iHigh_1 = iCustom(Symbol(),0,"myZhiBiao",20,0,1);
   double iHigh_2 = iCustom(Symbol(),0,"myZhiBiao",20,0,2);
   if(Ask>myMa && iLow_0>iLow_1 && iLow_1 == iLow_2) //下方k线做多信号
     {
      mySingal= 0;
     }
   if(Bid<myMa && iHigh_0<iHigh_1 && iHigh_1==iHigh_2) //上方k线做空信号
     {
      mySingal= 1;
     }
   return mySingal;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int iSendOrder(int mySingal)
  {
   int rt=0;
   if(mySingal==0)
     {
      rt=OrderSend(Symbol(),OP_BUY,volum,Ask,10,0,0,"Buy",5131148);
      if(rt<0)
         Print("OrderSend failed with error #",GetLastError());

     }
   if(mySingal==1)
     {
      rt=OrderSend(Symbol(),OP_SELL,volum,Bid,10,0,0,"Sell",51131148);
      if(rt<0)
         Print("OrderSend failed with error #",GetLastError());


     }
   return rt;

  }

//+------------------------------------------------------------------+
