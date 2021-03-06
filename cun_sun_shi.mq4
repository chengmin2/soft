//+------------------------------------------------------------------+
//|                                                   cun_ni_shi.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
datetime alarm=0;
int magic=123456;
double volume=0.01;
int rt=0;
int jiShu=30;
int guaDian=100;
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
//|                                                                  |
//+------------------------------------------------------------------+
void OnTick()
  {

     {
      if(jy.CheckOrderByaSymbol(Symbol(),magic,OP_BUY)==0 )
        {
         OrderSend(Symbol(),OP_BUY,volume,Ask,3,0,0,"buy",magic);
         //OrderSend(Symbol(),OP_SELL,volume,Bid,3,0,0,"sell",magic);
        }
       if(jy.CheckOrderByaSymbol(Symbol(),magic,OP_SELL)==0){
       OrderSend(Symbol(),OP_SELL,volume,Bid,3,0,0,"sell",magic);
       }        
      shunShiBuy();
       shunShiSell();
      close();
      alarm=Time[0];
     }

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void shunShiBuy()
  {
   int totals = OrdersTotal();
   string symbol = Symbol();
   int ticket;
   for(int i=totals-1; i>=0; i--)
     {
      if(OrderSelect(i, SELECT_BY_POS))
        {
         if(OrderSymbol()==symbol && magic==OrderMagicNumber() && OrderType()==OP_BUY)
           {
            double b = OrderLots();
            if(Ask-OrderOpenPrice()>jiShu*Point())
              {
               if(b<0.07)
                 {
                  int buyNum = jy.CheckOrderByaSymbol(symbol,magic,OP_BUY);
                  double buyLots = buyNum/4*2*0.01+0.01+b;
                  ticket= OrderSend(Symbol(),OP_BUY,buyLots,Ask,3,0,0,"buy",magic);
                  if(ticket<0)
                    {
                     Print("OrderSend failed with error #",GetLastError());
                     Alert("开多单失败！");
                    }
                 }
              }
            break;
           }
        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void shunShiSell()
  {
   int totals = OrdersTotal();
   string symbol = Symbol();
   int ticket;
   for(int i=totals-1; i>=0; i--)
     {
      if(OrderSelect(i, SELECT_BY_POS))
        {
         if(OrderSymbol()==symbol && magic==OrderMagicNumber() && OrderType()==OP_SELL)
           {
            double s = OrderLots();
            if(OrderOpenPrice()-Bid>jiShu*Point())
              {
               if(s<0.07)
                 {
                  int sellNum = jy.CheckOrderByaSymbol(symbol,magic,OP_SELL);
                  double sellLots = sellNum/4*2*0.01+0.01+s;
                  ticket = OrderSend(Symbol(),OP_SELL,sellLots,Bid,3,0,0,"sell",magic);
                  if(ticket<0)
                    {
                     Print("OrderSend failed with error #",GetLastError());
                     Alert("开空单失败！");
                    }
                 }

              }
            break;
           }
        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void close()
  {
   if(jy.profitBySymbolTotal(Symbol(),magic,OP_BUY)>5)
     {
      jy.ColseOrderGuaBySymbol(Symbol(),magic);
      rt = jy.ColseOrderBySymbol(Symbol(),magic,OP_BUY);
      if(rt==0)
         Alert("关闭多单交易出错！");

     }
   if(jy.profitBySymbolTotal(Symbol(),magic,OP_SELL)>5)
     {
      jy.ColseOrderGuaBySymbol(Symbol(),magic);
      rt = jy.ColseOrderBySymbol(Symbol(),magic,OP_SELL);
      if(rt==0)
         Alert("关闭空单交易出错！");
     }

  }
