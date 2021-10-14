//+------------------------------------------------------------------+
//|                                                   myScript 1.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#include <myInclude\ZhiNengJiaoYi.mqh>
ZhiNengJiaoYi jy;
int magic=5131148;
void OnStart()
  {
   jy.ColseOrderBySymbol(Symbol(),magic);
   
  }
//+------------------------------------------------------------------+
