//+------------------------------------------------------------------+
//|                                                          Bar.mqh |
//|                                Copyright 2022, André Hoogendoorn |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, André Hoogendoorn"
#property link      "https://www.mql5.com"
#property version   "1.00"
class CBar
  {
private:
   ENUM_TIMEFRAMES   m_tf;
   string            m_sym;
   datetime          m_p;

public:
                     CBar(ENUM_TIMEFRAMES timeframe = PERIOD_CURRENT, string symbol = NULL);
                    ~CBar();
   bool              New();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CBar::CBar(ENUM_TIMEFRAMES timeframe = PERIOD_CURRENT, string symbol = NULL)
  {
   m_tf = timeframe;
   m_sym = symbol == NULL ?  _Symbol : symbol;
   m_p = iTime(m_sym, m_tf, 0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CBar::~CBar()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CBar::New()
  {
   return m_p != (m_p = iTime(m_sym, m_tf, 0));
  }
//+------------------------------------------------------------------+
