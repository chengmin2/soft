//+------------------------------------------------------------------+
//|                                                       GenDan.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property show_inputs
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
   int total = SignalBaseTotal();
   for(int  i=0; i<total; i++)
     {
      if(SignalBaseSelect(i))
        {
         //--- get signal properties
         long   id    =SignalBaseGetInteger(SIGNAL_BASE_ID);          // signal id
         long   pips  =SignalBaseGetInteger(SIGNAL_BASE_PIPS);        // profit in pips
         long   subscr=SignalBaseGetInteger(SIGNAL_BASE_SUBSCRIBERS); // number of subscribers
         string name  =SignalBaseGetString(SIGNAL_BASE_NAME);         // signal name
         double price =SignalBaseGetDouble(SIGNAL_BASE_PRICE);        // signal price
         string curr  =SignalBaseGetString(SIGNAL_BASE_CURRENCY);     // signal currency
         //--- print all profitable free signals with subscribers
         if(price==0.0 && pips>0 && subscr>0)
           {
           printf("进入-------");
            SignalInfoSetInteger(SIGNAL_INFO_CONFIRMATIONS_DISABLED,1);
            SignalInfoSetInteger(SIGNAL_INFO_COPY_SLTP,1);
            SignalInfoSetInteger(SIGNAL_INFO_DEPOSIT_PERCENT,20);
            SignalInfoSetInteger(SIGNAL_INFO_ID,id);
            SignalInfoSetInteger(SIGNAL_INFO_SUBSCRIPTION_ENABLED,1);
            SignalInfoSetInteger(SIGNAL_INFO_TERMS_AGREE,1);
            SignalInfoSetDouble(SIGNAL_INFO_EQUITY_LIMIT,5000);
            SignalInfoSetDouble(SIGNAL_INFO_SLIPPAGE,1.5);
            if(SignalSubscribe(id)==false)
              {
               printf("订阅失败："+GetLastError());
              }
            else
              {
               break;
              }

           }

        }
     }
  }
//+------------------------------------------------------------------+
