//+------------------------------------------------------------------+
//|                                              EvanGoldGrid.mq5    |
//|                        Copyright 2025, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.53"
#property strict

#include "CEvanGoldGrid.mqh"

//+------------------------------------------------------------------+
//| Input Parameters                                                   |
//+------------------------------------------------------------------+
input group "=== Trading Parameters ==="
input double    InpCenterPrice  = 0;
input int       InpGridCount    = 100;
input int       InpGridMode     = 0;
input double    InpGridSpacing  = 1.0;
input double    InpTakeProfit   = 1.0;

input group "=== Risk Management ==="
input double    InpLotSize      = 0.01;
input int       InpMaxOrders    = 200;
input int       InpMagicNumber  = 123456;
input int       InpSlippage     = 3;
input double    InpMaxLossUSD   = 500.0;

input group "=== Trading Hours ==="
input int       InpStartHour    = 0;
input int       InpEndHour      = 23;
input bool      InpAllowMonday  = true;
input bool      InpAllowFriday  = false;

input group "=== Profit Protection ==="
input bool      InpProfitProtection   = true;
input double    InpProfitThreshold    = 80.0;
input double    InpProfitTrigger      = 25.0;

input group "=== Grid Shift ==="
input bool      InpAutoShiftGrid    = false;
input int       InpShiftTriggerBars = 3;

input group "=== Auto Start ==="
input bool      InpAutoStartGrid    = true;

input group "=== Panel Settings ==="
input color     InpPanelBgColor = clrDimGray;
input color     InpButtonColor  = clrDodgerBlue;
input int       InpPanelX       = 20;
input int       InpPanelY       = 20;

//+------------------------------------------------------------------+
//| Global Expert Advisor Instance                                     |
//+------------------------------------------------------------------+
CEvanGoldGrid*  g_expert = NULL;

//+------------------------------------------------------------------+
//| Expert initialization function                                     |
//+------------------------------------------------------------------+
int OnInit()
{
   g_expert = new CEvanGoldGrid();
   if(g_expert == NULL)
   {
      Print("Failed to create expert advisor instance");
      return(INIT_FAILED);
   }

   if(!g_expert.Init(
      InpCenterPrice,
      InpGridCount,
      InpGridMode,
      InpGridSpacing,
      InpTakeProfit,
      InpLotSize,
      InpMaxOrders,
      InpMagicNumber,
      InpSlippage,
      InpStartHour,
      InpEndHour,
      InpAllowMonday,
      InpAllowFriday,
      InpProfitProtection,
      InpProfitThreshold,
      InpProfitTrigger,
      InpPanelBgColor,
      InpButtonColor,
      InpPanelX,
      InpPanelY,
      InpMaxLossUSD,
      InpAutoShiftGrid,
      InpShiftTriggerBars,
      InpAutoStartGrid))
   {
      Print("Expert advisor initialization failed");
      delete g_expert;
      g_expert = NULL;
      return(INIT_FAILED);
   }

   Print("=== EvanGoldGrid Expert Advisor initialized successfully ===");
   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                   |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   if(g_expert != NULL)
   {
      g_expert.Deinit(reason);
      delete g_expert;
      g_expert = NULL;
   }
   Print("=== EvanGoldGrid Expert Advisor deinitialized ===");
}

//+------------------------------------------------------------------+
//| Expert tick function                                               |
//+------------------------------------------------------------------+
void OnTick()
{
   if(g_expert != NULL)
   {
      g_expert.OnTick();
   }
}

//+------------------------------------------------------------------+
//| Expert chart event function                                        |
//+------------------------------------------------------------------+
void OnChartEvent(const int id, const long& lparam, const double& dparam, const string& sparam)
{
   if(g_expert != NULL)
   {
      g_expert.OnChartEvent(id, lparam, dparam, sparam);
   }
}

//+------------------------------------------------------------------+
//| Expert timer function                                              |
//+------------------------------------------------------------------+
void OnTimer()
{
   if(g_expert != NULL)
   {
      g_expert.OnTimer();
   }
}
//+------------------------------------------------------------------+
