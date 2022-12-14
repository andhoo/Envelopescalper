//+------------------------------------------------------------------+
//|                                              envelopescalper.mq5 |
//| Strategy:             https://www.onestepremoved.com/scalper-ea/ |
//|                                Copyright 2022, André Hoogendoorn |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#include "bar.mqh"
#include <Trade\Trade.mqh>
#define o(n) iOpen(_Symbol,PERIOD_CURRENT,n)
#define h(n) iHigh(_Symbol,PERIOD_CURRENT,n)
#define l(n) iLow(_Symbol,PERIOD_CURRENT,n)
#define c(n) iClose(_Symbol,PERIOD_CURRENT,n)
#define v(n) iVolume(_Symbol,PERIOD_CURRENT,n)
#define Ask SymbolInfoDouble(_Symbol,SYMBOL_ASK)
#define Bid SymbolInfoDouble(_Symbol,SYMBOL_BID)
//--- input parameters
input int    Ma1 = 200;                //Moving average
input ENUM_MA_METHOD Mode = MODE_EMA;  //MA mode
input double dev = 1.0;                //Deviation from MA [%]
input double lot = 0.01;               //Lot-size
input string start = "02:00";          //Start time [hh:mm]
input string stop = "18:00";           //Stop time [hh:mm]
input long Magic = 2143;               // Magic #
//--- global variables
CBar bar;
CTrade trade;
int h_ma1;
double b_ma1[];
double uband, lband;
bool direction;
double openprice;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   h_ma1 = iMA(_Symbol, PERIOD_CURRENT, Ma1, 0, Mode, PRICE_CLOSE);
   trade.SetExpertMagicNumber(Magic);
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
   if(bar.New())
     {
      CopyBuffer(h_ma1, 0, 0, 10, b_ma1);
      ArraySetAsSeries(b_ma1, true);
      uband = b_ma1[1] * (1 + dev / 100);
      lband = b_ma1[1] * (1 - dev / 100);
      if(total() == 0 && TimeCurrent() % 86400 > StringToTime(start) % 86400 && TimeCurrent() % 86400 < StringToTime(stop) % 86400)
        {
         //         if(o(1) < c(1) && h(1) > uband)
         if(c(1) > uband)
           {
            trade.PositionOpen(_Symbol, ORDER_TYPE_SELL, lot, Bid, 0, 0);
            direction = false;
            openprice = Bid;
           }
         //         if(o(1) > c(1) && l(1) < lband)
         if(c(1) < lband)
           {
            trade.PositionOpen(_Symbol, ORDER_TYPE_BUY, lot, Ask, 0, 0);
            direction = true;
            openprice = Ask;
           }
        }
      if(total())
        {
         if((c(1) < uband && !direction) || (c(1) > lband && direction))
            //         if((c(1) < openprice && !direction) && (c(1) > openprice && direction))
           {
            trade.PositionClose(_Symbol);
           }
        }
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int total()
  {
   int pos = 0;
   for(int i = PositionsTotal() - 1; i >= 0; i--)
     {
      if(PositionGetSymbol(i) == _Symbol && PositionGetInteger(POSITION_MAGIC) == Magic) //select position and check it with symbol and magic #
        {
         pos++;
        }
     }
   return pos; // filtered positions total
  }
//+------------------------------------------------------------------+
//| Trade function                                                   |
//+------------------------------------------------------------------+
void OnTrade()
  {
//---

  }
//+------------------------------------------------------------------+
//| TradeTransaction function                                        |
//+------------------------------------------------------------------+
void OnTradeTransaction(const MqlTradeTransaction& trans,
                        const MqlTradeRequest& request,
                        const MqlTradeResult& result)
  {
//---

  }
//+------------------------------------------------------------------+
//| Tester function                                                  |
//+------------------------------------------------------------------+
double OnTester()
  {
//---
   double ret = 0.0;
//---

//---
   return(ret);
  }
//+------------------------------------------------------------------+
//| TesterInit function                                              |
//+------------------------------------------------------------------+
void OnTesterInit()
  {
//---

  }
//+------------------------------------------------------------------+
//| TesterPass function                                              |
//+------------------------------------------------------------------+
void OnTesterPass()
  {
//---

  }
//+------------------------------------------------------------------+
//| TesterDeinit function                                            |
//+------------------------------------------------------------------+
void OnTesterDeinit()
  {
//---

  }
//+------------------------------------------------------------------+
//| BookEvent function                                               |
//+------------------------------------------------------------------+
void OnBookEvent(const string &symbol)
  {
//---

  }
//+------------------------------------------------------------------+
