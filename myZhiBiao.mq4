//+------------------------------------------------------------------+
//|                                                     2zhibiao.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property indicator_chart_window
#property indicator_buffers 2
#property indicator_plots   2
//--- plot xian1
#property indicator_label1  "xian1"
#property indicator_type1   DRAW_LINE
#property indicator_color1  clrRed
#property indicator_style1  STYLE_SOLID
#property indicator_width1  1
//--- plot xian2
#property indicator_label2  "xian2"
#property indicator_type2   DRAW_LINE
#property indicator_color2  clrRed
#property indicator_style2  STYLE_SOLID
#property indicator_width2  1
//--- indicator buffers
double         xian1Buffer[];
double         xian2Buffer[];
input int kshu=20;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexBuffer(0,xian1Buffer);
   SetIndexBuffer(1,xian2Buffer);
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
  int limt;
   if(prev_calculated==0){
    limt = rates_total;
   }else{
    limt=rates_total-prev_calculated+1;
   }
   for(int i=0;i<limt;i++){
       xian1Buffer[i]=iHigh(Symbol(),0,iHighest(Symbol(),0,MODE_HIGH,kshu,i));
       xian2Buffer[i]=iLow(Symbol(),0,iLowest(Symbol(),0,MODE_LOW,kshu,i));
   }
   return(rates_total);
  }
//+------------------------------------------------------------------+
