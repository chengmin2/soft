//+------------------------------------------------------------------+
//|                                                 baoLiJiaCang.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
input int magic=123456;//魔术号
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
  if(AccountProfit()<0){
    
   printf(MathAbs(AccountProfit())/AccountBalance());
   if(MathAbs(AccountProfit())/AccountBalance()>0.3){
   ExpertRemove();
   }
 
  }
 
  /* if(AccountFreeMargin()>2){
    OrderSend(Symbol(),OP_BUY,0.01,Ask,2,0,0,"baoli",magic);
   }*/
  }
//+------------------------------------------------------------------+
