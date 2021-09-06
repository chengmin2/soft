//+------------------------------------------------------------------+
//|                                                ZhiNengJiaoYi.mqh |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
class ZhiNengJiaoYi
  {
private:

public:
                     ZhiNengJiaoYi();
                    ~ZhiNengJiaoYi();
   int               buyOrders(int num,string symbol,int type,double volume,int slippage,int   stoploss,int   takeprofit,string comment,int magics);

   int               ColseOrderBySymbol(string symbol);
   int               fanXianJC(string symbol);
   double            profitBySymbolTotal(string  symbol);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ZhiNengJiaoYi::ZhiNengJiaoYi()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ZhiNengJiaoYi::~ZhiNengJiaoYi()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int ZhiNengJiaoYi::buyOrders(int num,string symbol,int type,double volume,int slippage,int   stoploss,int   takeprofit,string comment,int magics)
  {
   int ticket=0;
   for(int i=0; i<num; i++)
     {
      double price=Ask;
      if(stoploss>0)
        {
         stoploss=NormalizeDouble(Bid-stoploss*Point,Digits);
        }

      if(takeprofit>0)
        {
         takeprofit=NormalizeDouble(Bid+takeprofit*Point,Digits);
        }


      ticket = OrderSend(symbol,type,volume,price,slippage*Point(),stoploss*Point(),comment,magics,0,clrNONE);
      if(ticket<0)
        {
         Print("OrderSend failed with error #",GetLastError());
         continue;
        }
      else
         Print("OrderSend placed successfully");

      //---
     }
   return ticket;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int ZhiNengJiaoYi::fanXianJC(string symbol)
  {

   ZhiNengJiaoYi jy;
   int total = OrdersTotal();
   int rt = 0;

   for(int i=total-1; i>=0; i--)
     {
      if(OrderSelect(i, SELECT_BY_POS))
        {
         if(OrderSymbol()==symbol)
           {
           double thisOrderLots;
           if(OrderLots()>=0.81){
             double thisOrderLots = OrderLots()+0.2;
           }else{
           thisOrderLots = 3*OrderLots();
           }
            /**if(OrderLots()>=0.81)
              {
               if(jy.profitBySymbolTotal(symbol)>0)
                 {
                  rt=jy.ColseOrderBySymbol(symbol);//平仓该货币订单

                  if(!rt)
                     GetLastError();
                  break;
                 }

              }*/
            double lr =OrderProfit()/(OrderLots()/0.01)+OrderCommission()/(OrderLots()/0.01)+OrderSwap()/(OrderLots()/0.01);
            int lrz = 3;
            if(OrderType()==OP_BUY) //做多单
              {
               if(lr>lrz) //做多单0.01手盈利超过三美元
                 {
                  //rt=OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),10);
                  rt=jy.ColseOrderBySymbol(symbol);//平仓该货币订单

                  if(!rt)
                     GetLastError();
                  break;
                 }
               else
                  if(lr<-lrz) //做多单0.01手亏损超过三美元
                    {

                     rt=OrderSend(symbol,OP_SELL,thisOrderLots,Bid,20,0,0,OrderComment(),OrderMagicNumber());
                     if(rt<0)
                        GetLastError();
                     break;
                    }
              }
            else
               if(OrderType()==OP_SELL) //做空单
                 {
                  if(lr>lrz) //做空单0.01手盈利超过三美元
                    {
                     //rt = OrderClose(OrderTicket(),OrderLots(),Ask,0);
                     rt=jy.ColseOrderBySymbol(symbol);//平仓该货币订单
                     if(!rt)
                        GetLastError();
                     break;

                    }
                  else
                     if(lr<-lrz) //做空单0.01手亏损超过三美元
                       {

                        rt = OrderSend(symbol,OP_BUY,thisOrderLots,Ask,20,0,0,OrderComment(),OrderMagicNumber());
                        if(rt<0)
                           GetLastError();
                        break;
                       }

                 }

            break;
           }
        }

     }
   return rt;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int ZhiNengJiaoYi::ColseOrderBySymbol(string symbol)
  {
   int total = OrdersTotal();
   int rt = 0;
   for(int i=total-1; i>=0; i--)
     {
      if(OrderSelect(i, SELECT_BY_POS))
        {
         if(OrderSymbol()==symbol)
           {
            if(OrderType()==OP_BUY)
              {
               rt=OrderClose(OrderTicket(),OrderLots(),Bid,5);
               if(!rt)
                  GetLastError();
              }

            if(OrderType()==OP_SELL)
              {
               rt=OrderClose(OrderTicket(),OrderLots(),Ask,5);
               if(!rt)
                  GetLastError();
              }
           }

        }
     }


   return rt;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double ZhiNengJiaoYi::profitBySymbolTotal(string  symbol) //计算当前货币的总利润
  {

   int total = OrdersTotal();
   double lr = 0;
   for(int i=total-1; i>=0; i--)
     {
      if(OrderSelect(i, SELECT_BY_POS))
        {
         if(OrderSymbol()==symbol){
            lr = lr+OrderProfit()+OrderCommission()+OrderSwap();
              printf("当前手续费："+OrderCommission());
              printf("当前库存费："+OrderSwap());
         }
        }
    }
      printf("当前利润："+lr);

   return lr;
  }
//+------------------------------------------------------------------+
