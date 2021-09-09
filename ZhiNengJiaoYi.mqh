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
   int               ColseOrderBySymbol(string symbol,int magic);//平单
   int               fanXianJC(string symbol,int magic);//反向加仓
   double            profitBySymbolTotal(string  symbol);//统计货币利润
   int               iSendOrder(int mySingal,string symbol,double volum);
   int               iSingal(string symbol); //做空做多信号
   int               CheckOrderByaSymbol(string symbol);//统计订单数量
   void              mobileStopLoss(string symbol,int magic,int stopLossNum);//移动止损

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
int ZhiNengJiaoYi::iSingal(string symbol) //做空做多信号
  {
   int mySingal = 9;
   double myMa= iMA(symbol,0,14,0,MODE_SMA,PRICE_CLOSE,1);
   double iLow_0 = iCustom(symbol,0,"myZhiBiao\myZhiBiao",20,1,0);
   double iLow_1 = iCustom(symbol,0,"myZhiBiao\myZhiBiao",20,1,1);
   double iLow_2 = iCustom(symbol,0,"myZhiBiao\myZhiBiao",20,1,2);
   double iHigh_0 = iCustom(symbol,0,"myZhiBiao\myZhiBiao",20,0,0);
   double iHigh_1 = iCustom(symbol,0,"myZhiBiao\myZhiBiao",20,0,1);
   double iHigh_2 = iCustom(symbol,0,"myZhiBiao\myZhiBiao",20,0,2);
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
int  ZhiNengJiaoYi::iSendOrder(int mySingal,string symbol,double volum)
  {
   int rt=0;
   if(mySingal==0)
     {
      rt=OrderSend(symbol,OP_BUY,volum,Ask,10,0,0,"Buy",5131148);
      if(rt<0)
         Print("OrderSend failed with error #",GetLastError());

     }
   if(mySingal==1)
     {
      rt=OrderSend(symbol,OP_SELL,volum,Bid,10,0,0,"Sell",5131148);
      if(rt<0)
         Print("OrderSend failed with error #",GetLastError());


     }
   return rt;

  }

int ZhiNengJiaoYi::fanXianJC(string symbol,int magic)
  {

   ZhiNengJiaoYi jy;
   int total = OrdersTotal();
   int rt = 0;

   for(int i=total-1; i>=0; i--)
     {
      if(OrderSelect(i, SELECT_BY_POS))
        {
         if(OrderSymbol()==symbol && magic==OrderMagicNumber())
           {
            double thisOrderLots;

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
            /* if(OrderLots()>=0.81){
              if((jy.iSingal(symbol)==0 && OrderType() == OP_BUY)
               ||(jy.iSingal(symbol)==1 && OrderType() == OP_SELL))
               break;
             } */
            double lr;
            if(symbol=="XAUUSD")
              {
               thisOrderLots = 3*OrderLots();
               lr =OrderProfit()/(OrderLots()/0.01)+OrderCommission()/(OrderLots()/0.01)+OrderSwap()/(OrderLots()/0.01);
              }
            else
              {
               thisOrderLots = 3*OrderLots();
               lr =OrderProfit()/(OrderLots()/0.1)+OrderCommission()/(OrderLots()/0.1)+OrderSwap()/(OrderLots()/0.1);
              }
            int lrz = 10;
            if(OrderType()==OP_BUY) //做多单
              {
               if(lr>lrz) //做多单0.01手盈利超过三美元
                 {
                  //rt=OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),10);
                  rt=jy.ColseOrderBySymbol(symbol,magic);//平仓该货币订单

                  if(!rt)
                     GetLastError();
                  break;
                 }
               else
                  if(lr<-lrz) //做多单0.01手亏损超过三美元
                    {

                     rt=OrderSend(symbol,OP_SELL,thisOrderLots,Bid,5,0,0,OrderComment(),OrderMagicNumber());
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
                     rt=jy.ColseOrderBySymbol(symbol,magic);//平仓该货币订单
                     if(!rt)
                        GetLastError();
                     break;

                    }
                  else
                     if(lr<-lrz) //做空单0.01手亏损超过三美元
                       {

                        rt = OrderSend(symbol,OP_BUY,thisOrderLots,Ask,5,0,0,OrderComment(),OrderMagicNumber());
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
int ZhiNengJiaoYi::ColseOrderBySymbol(string symbol,int magic)
  {
   int total = OrdersTotal();
   int rt = 0;
   for(int i=total-1; i>=0; i--)
     {
      if(OrderSelect(i, SELECT_BY_POS))
        {
         if(OrderSymbol()==symbol && magic==OrderMagicNumber())
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
         if(OrderSymbol()==symbol)
           {
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
int ZhiNengJiaoYi::CheckOrderByaSymbol(string symbol) //检查订单中当前货币的单数
  {
   int  total=OrdersTotal();
   int rt=0;
   for(int i=0; i<total; i++)
     {
      if(OrderSelect(i,SELECT_BY_POS))
        {
         if(OrderSymbol()==symbol)
            rt=1;
        }
     }
   return rt;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ZhiNengJiaoYi::mobileStopLoss(string symbol,int magic,int stopLossNum)//移动止损
  {

   int  total=OrdersTotal();
   int rt=0;
   for(int i=0; i<total; i++)
     {
      if(OrderSelect(i,SELECT_BY_POS))
        {
         if(OrderSymbol()==symbol && OrderMagicNumber()==magic)
            if(OrderType()==OP_BUY)
              {
               if(Bid-stopLossNum*Point()>OrderOpenPrice())
                 {
                  if(OrderStopLoss()<Bid-stopLossNum*Point() || OrderStopLoss()==0)
                    {
                     bool res =OrderModify(OrderTicket(),OrderOpenPrice(),Bid-stopLossNum*Point(),OrderTakeProfit(),0,clrNONE);
                     if(!res)
                        Print("Error in OrderModify. Error code=",GetLastError());

                    }

                 }
              }

         if(OrderType()==OP_SELL)
           {
            if(OrderOpenPrice()-Ask>stopLossNum*Point())
              {
               if(OrderStopLoss()>Ask+stopLossNum*Point() || OrderStopLoss()==0)
                 {
                  bool res=OrderModify(OrderTicket(),OrderClosePrice(),Ask+stopLossNum*Point(),OrderTakeProfit(),0,clrNONE);
                  if(!res)
                     Print("Error in OrderModify. Error code=",GetLastError());
                 }

              }

           }
        }

     }
  }
//+------------------------------------------------------------------+
