//+------------------------------------------------------------------+
//|                                                         test.mq4 |
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
int magic=123456;
double volume=0.01;
int points=100;
datetime time=0;
int 小周期=10;
int 大周期=20;
int 止损 = 200;
#include <myInclude\ZhiNengJiaoYi.mqh>
ZhiNengJiaoYi jy;
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
   double 小周期_1=iMA(Symbol(),0,小周期,0,MODE_SMA,PRICE_CLOSE,0);
   double 大周期_1=iMA(Symbol(),0,大周期,0,MODE_SMA,PRICE_CLOSE,0);
   double 小周期_2=iMA(Symbol(),0,小周期,0,MODE_SMA,PRICE_CLOSE,1);
   double 大周期_2=iMA(Symbol(),0,大周期,0,MODE_SMA,PRICE_CLOSE,1);
   if(time!=Time[0])
     {

      if(小周期_1>大周期_1 && 小周期_2<大周期_2 && 小周期_1>小周期_2) //金叉
        {
         OrderSend(Symbol(),OP_BUY,volume,Ask,3,0,0,"buy",magic);
         double s = Ask+points*Point();
         double l = Ask-points*Point();
         for(int i=1; i<10; i++)
           {
            OrderSend(Symbol(),OP_BUYSTOP,volume*i,Ask+points*Point()*i,3,s-100*Point(),s+150*Point(),"buyStop",magic);
            OrderSend(Symbol(),OP_SELLSTOP,volume*i,Bid-points*Point()*i,3,Bid-points*Point()+100*Point(),Bid-points*Point()-250*Point(),"sellStop",magic);
           }


        }
      if(小周期_1<大周期_1 && 小周期_2>大周期_2 && 小周期_1<小周期_2) //死叉
        {

         OrderSend(Symbol(),OP_SELL,volume,Bid,3,0,0,"sell",magic);
         double s = Bid-points*Point();
         double l = Bid+points*Point();
         for(int i=1; i<10; i++)
           {
            OrderSend(Symbol(),OP_SELLSTOP,volume*i,Bid-points*Point()*i,3,s+100*Point(),s-150*Point(),"sellStop",magic);
            OrderSend(Symbol(),OP_BUYSTOP,volume*i,Ask+points*Point()*i,3,Ask+points*Point()-100*Point(), Ask+points*Point()+150*Point(),"buyStop",magic);
           }

        }



      time=Time[0];
     }
  }
//+------------------------------------------------------------------+
