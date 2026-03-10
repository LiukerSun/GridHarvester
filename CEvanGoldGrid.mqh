//+------------------------------------------------------------------+
//|                                            CEvanGoldGrid.mqh     |
//|                        Copyright 2025, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, MetaQuotes Software Corp."
#property version   "1.55"
#property link      "https://www.mql5.com"
#include <Trade/Trade.mqh>

//+------------------------------------------------------------------+
//| Grid cache information structure                                 |
//+------------------------------------------------------------------+
struct SGridCacheInfo
{
   double m_price;
   bool   m_is_buy_order;
   bool   m_has_pending;
   bool   m_has_position;
   bool   m_has_buy_pending;
   bool   m_has_sell_pending;
   bool   m_has_buy_position;
   bool   m_has_sell_position;
};

//+------------------------------------------------------------------+
//| Grid order information structure for batch processing            |
//+------------------------------------------------------------------+
struct SGridOrderInfo
{
   int             m_grid_index;
   ENUM_ORDER_TYPE m_type;
   double          m_price;
   double          m_tp;
   string          m_comment;
   bool            m_is_buy_order;
};

//+------------------------------------------------------------------+
//| EvanGoldGrid Expert Advisor class                                |
//+------------------------------------------------------------------+
class CEvanGoldGrid
{
private:
   CTrade m_trade;
   
   double m_center_price;
   int    m_grid_count;
   int    m_grid_mode;
   double m_grid_spacing;
   double m_take_profit;
   double m_lot_size;
   int    m_max_orders;
   int    m_magic_number;
   int    m_slippage;
   int    m_start_hour;
   int    m_end_hour;
   bool   m_allow_monday;
   bool   m_allow_friday;
   
   color  m_panel_bg_color;
   color  m_button_color;
   int    m_panel_x;
   int    m_panel_y;
   
   int    m_panel_x_pos;
   int    m_panel_y_pos;
   bool   m_is_panel_created;
   int    m_current_grid_mode;
   bool   m_auto_refill_enabled;
   bool   m_manual_intervention;
   
   bool   m_trailing_stop_enabled;
   double m_profit_trailing_percent;
   bool   m_trading_stopped;
   
   double m_initial_equity;
   double m_highest_equity;
   double m_max_drawdown_percent;
   double m_dynamic_stop_loss_line;
   
   bool   m_auto_shift_grid;
   int    m_shift_trigger_bars;
   double m_grid_upper_price;
   double m_grid_lower_price;
   datetime m_last_bar_time;
   
   int    m_shift_thread_id;
   bool   m_shift_thread_running;
   bool   m_auto_start_grid;
   
   SGridCacheInfo m_grid_cache[];
   int            m_grid_cache_count;
   bool           m_is_grid_cache_valid;
   
   datetime m_last_check_time;
   
   enum ENUM_CONTROL_IDS
   {
      BTN_GENERATE = 1,
      BTN_CLOSE_LOSS = 2,
      BTN_CLOSE_PROFIT = 3,
      BTN_CLOSE_ALL = 4,
      BTN_CANCEL_ALL = 5,
      BTN_CANCEL_CLOSE = 6,
      BTN_REFRESH = 7,
      BTN_AUTO_REFILL = 8,
      BTN_TRAILING_STOP = 9,
      EDIT_CENTER_PRICE = 101,
      EDIT_GRID_COUNT = 102,
      EDIT_GRID_SPACING = 103,
      EDIT_TAKE_PROFIT = 104,
      EDIT_LOT_SIZE = 105,
      EDIT_MAX_DRAWDOWN = 108,
      LABEL_STATUS = 201,
      LABEL_POSITIONS = 202,
      LABEL_PENDING = 203,
      LABEL_PROFIT = 204,
      LABEL_CURRENT_PRICE = 205,
      LABEL_EQUITY = 206,
      LABEL_DRAWDOWN = 207,
      LABEL_RUN_PROFIT = 208,
      LABEL_HIGHEST_EQUITY = 209,
      LABEL_STOP_LOSS_LINE = 210
   };
   
   bool   InitializeParameters(void);
   void   CreateTradingPanel(void);
   void   DeletePanelObjects(void);
   void   CreateButton(const string name, const int x, const int y, const int width, const int height, const string text, const int id);
   void   CreateEdit(const string name, const int x, const int y, const int width, const int height, const string text, const int id);
   void   CreateLabel(const string name, const int x, const int y, const string text, const int id);
   void   UpdateDisplay(void);
   double GetEditValue(const int id);
   int    GetEditIntValue(const int id);
   void   SetEditValue(const int id, const double value);
   
   bool   IsTradingTime(void);
   int    CountMyOrders(void);
   void   GenerateGrid(void);
   int    BatchPlaceOrders(SGridOrderInfo &orders[], const double lot_size);
   void   BatchClosePositions(const bool close_loss_only, const bool close_profit_only);
   
   void   CheckAndRefillGrid(void);
   bool   HasPendingOrderForPrice(const double price, const bool is_buy_order);
   bool   HasPositionForPrice(const double price, const bool is_buy_order);
   bool   HasOrderForPrice(const double price, const bool is_buy_order);
   bool   RefillOrderAtPrice(const double price, const bool is_buy_order);
   bool   PlaceRefillOrder(const ENUM_ORDER_TYPE order_type, const double price, const double lot_size, const double take_profit, const string comment);
   
   bool   HasPendingOrderForGrid(const int grid_index);
   bool   HasPositionForGrid(const int grid_index);
   bool   HasOrderForGridIndex(const int grid_index);
   
   void   CreateDualSideOrder(SGridOrderInfo &orders[], int &order_index, const int grid_index, const double price, const bool is_buy_order, const double current_ask, const double current_bid, const double take_profit);
   bool   HasBuyOrderForGrid(const int grid_index);
   bool   HasSellOrderForGrid(const int grid_index);
   
   double GetTotalProfit(void);
   void   StopAllTrading(void);
   void   UpdateTrailingStop(void);
   
   void   OnGenerateGrid(void);
   void   OnCloseLosingPositions(void);
   void   OnCloseProfitingPositions(void);
   void   OnCloseAllPositions(void);
   void   OnCancelAllPending(void);
   void   OnCancelAndCloseAll(void);
   void   OnRefreshCenterPrice(void);
   void   OnToggleAutoRefill(void);
   void   OnToggleGridMode(void);
   void   OnToggleTrailingStop(void);
   
   void   StartShiftThread(void);
   void   StopShiftThread(void);
   void   ShiftThreadFunc(void);
   void   CheckAndShiftGrids(void);
   bool   ShiftGridUp(int grids_to_shift);
   bool   ShiftGridDown(int grids_to_shift);
   bool   ClosePositionAtGrid(const int grid_index);
   bool   MoveGridOrder(const int from_index, const int to_index);

public:
            CEvanGoldGrid(void);
           ~CEvanGoldGrid(void);
    
    bool   Init(const double center_price, const int grid_count, const int grid_mode, const double grid_spacing, const double take_profit, const double lot_size, const int max_orders, const int magic_number, const int slippage, const int start_hour, const int end_hour, const bool allow_monday, const bool allow_friday, const bool trailing_stop_enabled, const double profit_trailing_percent, const color panel_bg_color, const color button_color, const int panel_x, const int panel_y, const double max_drawdown_percent, const bool auto_shift_grid, const int shift_trigger_bars, const bool auto_start_grid);
    void   Deinit(const int reason);
    void   OnTick(void);
    void   OnChartEvent(const int id, const long &lparam, const double &dparam, const string &sparam);
    void   OnTimer(void);
};

//+------------------------------------------------------------------+
//| Constructor                                                        |
//+------------------------------------------------------------------+
CEvanGoldGrid::CEvanGoldGrid(void)
{
   m_panel_x_pos = 0;
   m_panel_y_pos = 0;
   m_is_panel_created = false;
   m_current_grid_mode = 0;
   m_auto_refill_enabled = true;
   m_manual_intervention = false;
   m_grid_cache_count = 0;
   m_is_grid_cache_valid = false;
   m_last_check_time = 0;
   
   m_trailing_stop_enabled = false;
   m_profit_trailing_percent = 50.0;
   m_trading_stopped = false;
   
   m_initial_equity = 0.0;
   m_highest_equity = 0.0;
   m_max_drawdown_percent = 2.0;
   m_dynamic_stop_loss_line = 0.0;
   
   m_auto_shift_grid = false;
   m_shift_trigger_bars = 3;
   m_grid_upper_price = 0;
   m_grid_lower_price = 0;
   m_last_bar_time = 0;
   
   m_shift_thread_id = 0;
   m_shift_thread_running = false;
   m_auto_start_grid = false;
}

//+------------------------------------------------------------------+
//| Destructor                                                         |
//+------------------------------------------------------------------+
CEvanGoldGrid::~CEvanGoldGrid(void)
{
   Deinit(REASON_REMOVE);
}

//+------------------------------------------------------------------+
//| Initialize the expert with input parameters                        |
//+------------------------------------------------------------------+
bool CEvanGoldGrid::Init(const double center_price, const int grid_count, const int grid_mode, const double grid_spacing, const double take_profit, const double lot_size, const int max_orders, const int magic_number, const int slippage, const int start_hour, const int end_hour, const bool allow_monday, const bool allow_friday, const bool trailing_stop_enabled, const double profit_trailing_percent, const color panel_bg_color, const color button_color, const int panel_x, const int panel_y, const double max_drawdown_percent, const bool auto_shift_grid, const int shift_trigger_bars, const bool auto_start_grid)
{
   m_center_price = center_price;
   m_grid_count = grid_count;
   m_grid_mode = grid_mode;
   m_grid_spacing = grid_spacing;
   m_take_profit = take_profit;
   m_lot_size = lot_size;
   m_max_orders = max_orders;
   m_magic_number = magic_number;
   m_slippage = slippage;
   m_start_hour = start_hour;
   m_end_hour = end_hour;
   m_allow_monday = allow_monday;
   m_allow_friday = allow_friday;
   m_trailing_stop_enabled = trailing_stop_enabled;
   m_profit_trailing_percent = profit_trailing_percent;
   m_panel_bg_color = panel_bg_color;
   m_button_color = button_color;
   m_panel_x = panel_x;
   m_panel_y = panel_y;
   m_max_drawdown_percent = max_drawdown_percent;
   m_auto_shift_grid = auto_shift_grid;
   m_shift_trigger_bars = shift_trigger_bars;
   m_auto_start_grid = auto_start_grid;
   
   m_current_grid_mode = m_grid_mode;
   m_initial_equity = AccountInfoDouble(ACCOUNT_EQUITY);
   m_highest_equity = m_initial_equity;
   m_dynamic_stop_loss_line = m_initial_equity * (1 - m_max_drawdown_percent / 100.0);
   m_grid_upper_price = 0;
   m_grid_lower_price = 0;
   m_last_bar_time = 0;
   m_shift_thread_id = 0;
   m_shift_thread_running = false;
   
   if(m_auto_shift_grid)
   {
      StartShiftThread();
   }
   
   m_trade.SetExpertMagicNumber(m_magic_number);
   m_trade.SetDeviationInPoints(m_slippage);
   m_trade.SetTypeFilling(ORDER_FILLING_RETURN);
   m_trade.SetAsyncMode(true);
   
   bool is_backtest = (MQLInfoInteger(MQL_TESTER) || MQLInfoInteger(MQL_OPTIMIZATION));
   
   if(!is_backtest)
   {
      ChartSetInteger(0, CHART_EVENT_OBJECT_CREATE, true);
      ChartSetInteger(0, CHART_EVENT_OBJECT_DELETE, true);
      ChartSetInteger(0, CHART_EVENT_MOUSE_MOVE, false);
      
      EventSetTimer(1);
      
      CreateTradingPanel();
      UpdateDisplay();
      ChartRedraw();
   }
   else
   {
      Print("=== Running in backtest/optimization mode - Panel disabled ===");
      Print("=== Grid Count: ", m_grid_count, ", Spacing: ", m_grid_spacing, ", TP: ", m_take_profit);
      
      if(m_auto_start_grid)
      {
         Print("=== Auto start enabled, generating grid... ===");
         Sleep(100);
         GenerateGrid();
      }
   }
   
   Print("=== CEvanGoldGrid initialization completed ===");
   return(true);
}

//+------------------------------------------------------------------+
//| Deinitialize the expert                                            |
//+------------------------------------------------------------------+
void CEvanGoldGrid::Deinit(const int reason)
{
   StopShiftThread();
   EventKillTimer();
   DeletePanelObjects();
}

//+------------------------------------------------------------------+
//| Check if current time is within trading hours                        |
//+------------------------------------------------------------------+
bool CEvanGoldGrid::IsTradingTime(void)
{
   MqlDateTime dt;
   TimeToStruct(TimeCurrent(), dt);
   
   if(dt.day_of_week == 0)
      return(false);
   if(dt.day_of_week == 1 && !m_allow_monday)
      return(false);
   if(dt.day_of_week == 5 && !m_allow_friday)
      return(false);
   
   if(dt.hour < m_start_hour || dt.hour > m_end_hour)
      return(false);
   
   return(true);
}

//+------------------------------------------------------------------+
//| Count orders and positions for this EA                             |
//+------------------------------------------------------------------+
int CEvanGoldGrid::CountMyOrders(void)
{
   int count = 0;
   
   for(int i = OrdersTotal() - 1; i >= 0; i--)
   {
      ulong ticket = OrderGetTicket(i);
      if(ticket == 0)
         continue;
      if(OrderSelect(ticket))
      {
         if(OrderGetInteger(ORDER_MAGIC) == m_magic_number && OrderGetString(ORDER_SYMBOL) == _Symbol)
         {
            count++;
         }
      }
   }
   
   for(int i = PositionsTotal() - 1; i >= 0; i--)
   {
      ulong ticket = PositionGetTicket(i);
      if(ticket == 0)
         continue;
      if(PositionSelectByTicket(ticket))
      {
         if(PositionGetInteger(POSITION_MAGIC) == m_magic_number && PositionGetString(POSITION_SYMBOL) == _Symbol)
         {
            count++;
         }
      }
   }
   
   return(count);
}

//+------------------------------------------------------------------+
//| Create the trading panel on chart                                  |
//+------------------------------------------------------------------+
void CEvanGoldGrid::CreateTradingPanel(void)
{
   if(m_is_panel_created)
      return;
   
   m_panel_x_pos = m_panel_x;
   m_panel_y_pos = m_panel_y;
   
   const int row_height = 28;
   const int label_width = 90;
   const int edit_width = 75;
   const int btn_width = 110;
   const int btn_height = 30;
   const int panel_width = 330;
   int row = 0;
   
   int content_width = label_width + 5 + edit_width;
   int start_x = m_panel_x_pos + (panel_width - content_width) / 2;
   int btn_start_x = m_panel_x_pos + (panel_width - btn_width) / 2;
   
   if(ObjectFind(0, "PANEL_BG") >= 0)
      ObjectDelete(0, "PANEL_BG");
   ObjectCreate(0, "PANEL_BG", OBJ_RECTANGLE_LABEL, 0, 0, 0);
   ObjectSetInteger(0, "PANEL_BG", OBJPROP_CORNER, CORNER_LEFT_UPPER);
   ObjectSetInteger(0, "PANEL_BG", OBJPROP_XDISTANCE, m_panel_x_pos + 10);
   ObjectSetInteger(0, "PANEL_BG", OBJPROP_YDISTANCE, m_panel_y_pos - 8);
   ObjectSetInteger(0, "PANEL_BG", OBJPROP_XSIZE, panel_width);
   ObjectSetInteger(0, "PANEL_BG", OBJPROP_YSIZE, 950);
   ObjectSetInteger(0, "PANEL_BG", OBJPROP_BGCOLOR, C'45,45,45');
   ObjectSetInteger(0, "PANEL_BG", OBJPROP_BORDER_COLOR, C'180,180,180');
   ObjectSetInteger(0, "PANEL_BG", OBJPROP_BORDER_TYPE, BORDER_FLAT);
   ObjectSetInteger(0, "PANEL_BG", OBJPROP_SELECTABLE, false);
   ObjectSetInteger(0, "PANEL_BG", OBJPROP_ZORDER, 0);
   
   int title_width = 120;
   CreateLabel("LBL_TITLE", m_panel_x_pos + (panel_width - title_width) / 2, m_panel_y_pos + row * row_height, "网格交易系统", 0);
   ObjectSetInteger(0, "LBL_TITLE", OBJPROP_COLOR, clrYellow);
   ObjectSetInteger(0, "LBL_TITLE", OBJPROP_FONTSIZE, 10);
   row++;
   
   CreateLabel("LBL_CENTER", start_x, m_panel_y_pos + row * row_height, "中心价格:", 0);
   CreateEdit("EDIT_101", start_x + label_width + 5, m_panel_y_pos + row * row_height, edit_width, 20, DoubleToString(m_center_price, _Digits), EDIT_CENTER_PRICE);
   CreateButton("BTN_REFRESH", start_x + label_width + 5 + edit_width + 5, m_panel_y_pos + row * row_height, 55, 20, "刷新", BTN_REFRESH);
   row++;
   
   CreateLabel("LBL_GRID_COUNT", start_x, m_panel_y_pos + row * row_height, "网格数量:", 0);
   CreateEdit("EDIT_102", start_x + label_width + 5, m_panel_y_pos + row * row_height, edit_width, 20, IntegerToString(m_grid_count), EDIT_GRID_COUNT);
   row++;
   
   CreateLabel("LBL_GRID_SPACE", start_x, m_panel_y_pos + row * row_height, "网格间隔:", 0);
   CreateEdit("EDIT_103", start_x + label_width + 5, m_panel_y_pos + row * row_height, edit_width, 20, DoubleToString(m_grid_spacing, 1), EDIT_GRID_SPACING);
   row++;
   
   CreateLabel("LBL_TP", start_x, m_panel_y_pos + row * row_height, "止盈点数:", 0);
   CreateEdit("EDIT_104", start_x + label_width + 5, m_panel_y_pos + row * row_height, edit_width, 20, DoubleToString(m_take_profit, 1), EDIT_TAKE_PROFIT);
   row++;
   
   CreateLabel("LBL_LOT", start_x, m_panel_y_pos + row * row_height, "手数:", 0);
   CreateEdit("EDIT_105", start_x + label_width + 5, m_panel_y_pos + row * row_height, edit_width, 20, DoubleToString(m_lot_size, 2), EDIT_LOT_SIZE);
   row += 2;
   
   CreateLabel("LBL_MAX_DRAWDOWN", start_x, m_panel_y_pos + row * row_height, "最大回撤%:", 0);
   CreateEdit("EDIT_108", start_x + label_width + 5, m_panel_y_pos + row * row_height, edit_width, 20, DoubleToString(m_max_drawdown_percent, 1), 108);
   row += 2;
   
   string mode_text = "做多";
   color mode_color = clrLimeGreen;
   if(m_current_grid_mode == 1)
   {
      mode_text = "做空";
      mode_color = clrRed;
   }
   else if(m_current_grid_mode == 2)
   {
      mode_text = "多空交替";
      mode_color = clrOrange;
   }
   else if(m_current_grid_mode == 3)
   {
      mode_text = "双边网格";
      mode_color = clrPurple;
   }
   CreateButton("BTN_DIRECTION", btn_start_x, m_panel_y_pos + row * row_height, btn_width, btn_height, mode_text, 0);
   ObjectSetInteger(0, "BTN_DIRECTION", OBJPROP_BGCOLOR, mode_color);
   row++;
   row++;
   
   int btn_y = m_panel_y_pos + row * row_height;
   const int btn_spacing = 5;
   
   CreateButton("BTN_CLOSE_LOSS", btn_start_x, btn_y, btn_width, btn_height, "平亏损", BTN_CLOSE_LOSS);
   btn_y += btn_height + btn_spacing;
   
   CreateButton("BTN_CLOSE_PROFIT", btn_start_x, btn_y, btn_width, btn_height, "平盈利", BTN_CLOSE_PROFIT);
   btn_y += btn_height + btn_spacing;
   
   CreateButton("BTN_CLOSE_ALL", btn_start_x, btn_y, btn_width, btn_height, "全平", BTN_CLOSE_ALL);
   btn_y += btn_height + btn_spacing;
   
   CreateButton("BTN_CANCEL_ALL", btn_start_x, btn_y, btn_width, btn_height, "撤单", BTN_CANCEL_ALL);
   btn_y += btn_height + btn_spacing;
   
   CreateButton("BTN_CANCEL_CLOSE", btn_start_x, btn_y, btn_width, btn_height, "撤单+平仓", BTN_CANCEL_CLOSE);
   btn_y += btn_height + btn_spacing;
   
   btn_y += 10;
   string refill_text = m_auto_refill_enabled ? "自动补单:开" : "自动补单:关";
   color refill_color = m_auto_refill_enabled ? clrLimeGreen : clrGray;
   CreateButton("BTN_AUTO_REFILL", btn_start_x, btn_y, btn_width, btn_height, refill_text, BTN_AUTO_REFILL);
   ObjectSetInteger(0, "BTN_AUTO_REFILL", OBJPROP_BGCOLOR, refill_color);
   btn_y += btn_height + btn_spacing;
   
   string trailing_text = m_trailing_stop_enabled ? "移动止损：开" : "移动止损：关";
   color trailing_color = m_trailing_stop_enabled ? clrLimeGreen : clrGray;
   CreateButton("BTN_TRAILING_STOP", btn_start_x, btn_y, btn_width, btn_height, trailing_text, BTN_TRAILING_STOP);
   ObjectSetInteger(0, "BTN_TRAILING_STOP", OBJPROP_BGCOLOR, trailing_color);
   btn_y += btn_height + 15;
   
   int status_label_width = 120;
   int status_start_x = m_panel_x_pos + (panel_width - status_label_width) / 2;
   CreateLabel("LBL_STATUS", status_start_x, btn_y, "运行状态：就绪", LABEL_STATUS);
   btn_y += 22;
   CreateLabel("LBL_POSITIONS", status_start_x, btn_y, "持仓：0", LABEL_POSITIONS);
   btn_y += 22;
   CreateLabel("LBL_PENDING", status_start_x, btn_y, "挂单：0", LABEL_PENDING);
   btn_y += 22;
   CreateLabel("LBL_PROFIT", status_start_x, btn_y, "盈亏：$0.00", LABEL_PROFIT);
   btn_y += 22;
   CreateLabel("LBL_EQUITY", status_start_x, btn_y, "净值：$0.00", LABEL_EQUITY);
   btn_y += 22;
   CreateLabel("LBL_DRAWDOWN", status_start_x, btn_y, "回撤：0.00%", LABEL_DRAWDOWN);
   btn_y += 22;
   CreateLabel("LBL_RUN_PROFIT", status_start_x, btn_y, "运行盈亏：$0.00", LABEL_RUN_PROFIT);
   btn_y += 22;
   CreateLabel("LBL_HIGHEST_EQUITY", status_start_x, btn_y, "最高净值：$0.00", LABEL_HIGHEST_EQUITY);
   btn_y += 22;
   CreateLabel("LBL_STOP_LOSS_LINE", status_start_x, btn_y, "止损线：$0.00", LABEL_STOP_LOSS_LINE);
   btn_y += 22;
   CreateLabel("LBL_PRICE", status_start_x, btn_y, "价格：", LABEL_CURRENT_PRICE);
   btn_y += 28;
   
   CreateButton("BTN_GENERATE", btn_start_x, btn_y, btn_width, btn_height, "生成网格", BTN_GENERATE);
   ObjectSetInteger(0, "BTN_GENERATE", OBJPROP_BGCOLOR, clrDodgerBlue);
   
   m_is_panel_created = true;
}

//+------------------------------------------------------------------+
//| Create a button object                                             |
//+------------------------------------------------------------------+
void CEvanGoldGrid::CreateButton(const string name, const int x, const int y, const int width, const int height, const string text, const int id)
{
   if(ObjectFind(0, name) >= 0)
      ObjectDelete(0, name);
   ObjectCreate(0, name, OBJ_BUTTON, 0, 0, 0);
   ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
   ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
   ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y);
   ObjectSetInteger(0, name, OBJPROP_XSIZE, width);
   ObjectSetInteger(0, name, OBJPROP_YSIZE, height);
   ObjectSetString(0, name, OBJPROP_TEXT, text);
   ObjectSetInteger(0, name, OBJPROP_BGCOLOR, m_button_color);
   ObjectSetInteger(0, name, OBJPROP_COLOR, clrWhite);
   ObjectSetInteger(0, name, OBJPROP_FONTSIZE, 8);
   ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
   ObjectSetInteger(0, name, OBJPROP_ZORDER, 100);
}

//+------------------------------------------------------------------+
//| Create an edit object                                              |
//+------------------------------------------------------------------+
void CEvanGoldGrid::CreateEdit(const string name, const int x, const int y, const int width, const int height, const string text, const int id)
{
   if(ObjectFind(0, name) >= 0)
      ObjectDelete(0, name);
   ObjectCreate(0, name, OBJ_EDIT, 0, 0, 0);
   ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
   ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
   ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y);
   ObjectSetInteger(0, name, OBJPROP_XSIZE, width);
   ObjectSetInteger(0, name, OBJPROP_YSIZE, height);
   ObjectSetString(0, name, OBJPROP_TEXT, text);
   ObjectSetInteger(0, name, OBJPROP_BGCOLOR, clrWhite);
   ObjectSetInteger(0, name, OBJPROP_COLOR, clrBlack);
   ObjectSetInteger(0, name, OBJPROP_READONLY, false);
   ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
   ObjectSetInteger(0, name, OBJPROP_ZORDER, 200);
}

//+------------------------------------------------------------------+
//| Create a label object                                              |
//+------------------------------------------------------------------+
void CEvanGoldGrid::CreateLabel(const string name, const int x, const int y, const string text, const int id)
{
   if(ObjectFind(0, name) >= 0)
      ObjectDelete(0, name);
   ObjectCreate(0, name, OBJ_LABEL, 0, 0, 0);
   ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
   ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
   ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y);
   ObjectSetString(0, name, OBJPROP_TEXT, text);
   ObjectSetInteger(0, name, OBJPROP_COLOR, clrWhite);
   ObjectSetInteger(0, name, OBJPROP_FONTSIZE, 8);
   ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
   ObjectSetInteger(0, name, OBJPROP_ZORDER, 100);
}

//+------------------------------------------------------------------+
//| Delete all panel objects                                           |
//+------------------------------------------------------------------+
void CEvanGoldGrid::DeletePanelObjects(void)
{
   for(int i = ObjectsTotal(0) - 1; i >= 0; i--)
   {
      string name = ObjectName(0, i);
      if(StringFind(name, "BTN_") == 0 || StringFind(name, "EDIT_") == 0 || StringFind(name, "LBL_") == 0 || name == "PANEL_BG")
      {
         ObjectDelete(0, name);
      }
   }
   m_is_panel_created = false;
}

//+------------------------------------------------------------------+
//| Update display information                                         |
//+------------------------------------------------------------------+
void CEvanGoldGrid::UpdateDisplay(void)
{
   int positions = 0;
   int pending = 0;
   double total_profit = 0.0;
   
   for(int i = PositionsTotal() - 1; i >= 0; i--)
   {
      ulong ticket = PositionGetTicket(i);
      if(ticket == 0)
         continue;
      if(PositionSelectByTicket(ticket))
      {
         if(PositionGetInteger(POSITION_MAGIC) == m_magic_number && PositionGetString(POSITION_SYMBOL) == _Symbol)
         {
            positions++;
            total_profit += PositionGetDouble(POSITION_PROFIT);
         }
      }
   }
   
   for(int i = OrdersTotal() - 1; i >= 0; i--)
   {
      ulong ticket = OrderGetTicket(i);
      if(ticket == 0)
         continue;
      if(OrderSelect(ticket))
      {
         if(OrderGetInteger(ORDER_MAGIC) == m_magic_number && OrderGetString(ORDER_SYMBOL) == _Symbol)
         {
            pending++;
         }
      }
   }
   
   ObjectSetString(0, "LBL_POSITIONS", OBJPROP_TEXT, "持仓: " + IntegerToString(positions));
   ObjectSetString(0, "LBL_PENDING", OBJPROP_TEXT, "挂单: " + IntegerToString(pending));
   ObjectSetString(0, "LBL_PROFIT", OBJPROP_TEXT, "盈亏: $" + DoubleToString(total_profit, 2));
   
   double current_equity = AccountInfoDouble(ACCOUNT_EQUITY);
   ObjectSetString(0, "LBL_EQUITY", OBJPROP_TEXT, "净值：$" + DoubleToString(current_equity, 2));
   
   double running_profit = 0.0;
   if(m_initial_equity > 0)
   {
      running_profit = current_equity - m_initial_equity;
   }
   ObjectSetString(0, "LBL_RUN_PROFIT", OBJPROP_TEXT, "运行盈亏：$" + DoubleToString(running_profit, 2));
   if(running_profit > 0)
      ObjectSetInteger(0, "LBL_RUN_PROFIT", OBJPROP_COLOR, clrLimeGreen);
   else if(running_profit < 0)
      ObjectSetInteger(0, "LBL_RUN_PROFIT", OBJPROP_COLOR, clrRed);
   else
      ObjectSetInteger(0, "LBL_RUN_PROFIT", OBJPROP_COLOR, clrWhite);
   
   double drawdown_pct = 0.0;
   if(m_initial_equity > 0)
   {
      drawdown_pct = (m_initial_equity - current_equity) / m_initial_equity * 100.0;
   }
   ObjectSetString(0, "LBL_DRAWDOWN", OBJPROP_TEXT, "回撤：" + DoubleToString(drawdown_pct, 2) + "%");
   if(drawdown_pct > 10.0)
      ObjectSetInteger(0, "LBL_DRAWDOWN", OBJPROP_COLOR, clrRed);
   else if(drawdown_pct > 5.0)
      ObjectSetInteger(0, "LBL_DRAWDOWN", OBJPROP_COLOR, clrOrange);
   else
      ObjectSetInteger(0, "LBL_DRAWDOWN", OBJPROP_COLOR, clrLimeGreen);
   
   ObjectSetString(0, "LBL_HIGHEST_EQUITY", OBJPROP_TEXT, "最高净值：$" + DoubleToString(m_highest_equity, 2));
   if(m_highest_equity > m_initial_equity)
      ObjectSetInteger(0, "LBL_HIGHEST_EQUITY", OBJPROP_COLOR, clrLimeGreen);
   else
      ObjectSetInteger(0, "LBL_HIGHEST_EQUITY", OBJPROP_COLOR, clrWhite);
   
   ObjectSetString(0, "LBL_STOP_LOSS_LINE", OBJPROP_TEXT, "止损线：$" + DoubleToString(m_dynamic_stop_loss_line, 2) + " (回撤" + DoubleToString(m_max_drawdown_percent, 1) + "%)");
   double current_drawdown_from_high = (m_highest_equity > 0) ? ((m_highest_equity - current_equity) / m_highest_equity * 100.0) : 0.0;
   if(current_drawdown_from_high > m_max_drawdown_percent * 0.8)
      ObjectSetInteger(0, "LBL_STOP_LOSS_LINE", OBJPROP_COLOR, clrRed);
   else if(current_drawdown_from_high > m_max_drawdown_percent * 0.5)
      ObjectSetInteger(0, "LBL_STOP_LOSS_LINE", OBJPROP_COLOR, clrOrange);
   else
      ObjectSetInteger(0, "LBL_STOP_LOSS_LINE", OBJPROP_COLOR, clrLimeGreen);
   
   double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   ObjectSetString(0, "LBL_PRICE", OBJPROP_TEXT, "价格：" + DoubleToString(bid, _Digits));
   
   if(m_trading_stopped)
   {
      ObjectSetString(0, "LBL_STATUS", OBJPROP_TEXT, "状态：已停止");
      ObjectSetInteger(0, "LBL_STATUS", OBJPROP_COLOR, clrRed);
   }
   else
   {
      ObjectSetString(0, "LBL_STATUS", OBJPROP_TEXT, "运行状态：就绪");
      ObjectSetInteger(0, "LBL_STATUS", OBJPROP_COLOR, clrLimeGreen);
   }
}

//+------------------------------------------------------------------+
//| Get double value from edit box                                     |
//+------------------------------------------------------------------+
double CEvanGoldGrid::GetEditValue(const int id)
{
   string name = "EDIT_" + IntegerToString(id);
   if(ObjectFind(0, name) >= 0)
   {
      string value = ObjectGetString(0, name, OBJPROP_TEXT);
      return(StringToDouble(value));
   }
   return(0.0);
}

//+------------------------------------------------------------------+
//| Get int value from edit box                                        |
//+------------------------------------------------------------------+
int CEvanGoldGrid::GetEditIntValue(const int id)
{
   string name = "EDIT_" + IntegerToString(id);
   if(ObjectFind(0, name) >= 0)
   {
      string value = ObjectGetString(0, name, OBJPROP_TEXT);
      return((int)StringToInteger(value));
   }
   return(0);
}

//+------------------------------------------------------------------+
//| Set value to edit box                                              |
//+------------------------------------------------------------------+
void CEvanGoldGrid::SetEditValue(const int id, const double value)
{
   string name = "EDIT_" + IntegerToString(id);
   if(ObjectFind(0, name) >= 0)
   {
      ObjectSetString(0, name, OBJPROP_TEXT, DoubleToString(value, _Digits));
   }
}

//+------------------------------------------------------------------+
//| OnTick processing                                                  |
//+------------------------------------------------------------------+
void CEvanGoldGrid::OnTick(void)
{
   double current_equity = AccountInfoDouble(ACCOUNT_EQUITY);
   
   if(current_equity > m_highest_equity)
   {
      m_highest_equity = current_equity;
      m_dynamic_stop_loss_line = m_highest_equity * (1 - m_max_drawdown_percent / 100.0);
   }
   
   if(m_initial_equity > 0 && m_max_drawdown_percent > 0)
   {
      if(current_equity <= m_dynamic_stop_loss_line)
      {
         Print(">>> DYNAMIC STOP LOSS TRIGGERED! Equity=", DoubleToString(current_equity, 2), 
               " HighestEquity=", DoubleToString(m_highest_equity, 2),
               " StopLine=", DoubleToString(m_dynamic_stop_loss_line, 2),
               " Drawdown=", DoubleToString((m_highest_equity - current_equity) / m_highest_equity * 100.0, 2), "%");
         StopAllTrading();
         return;
      }
   }
   
   if(m_trading_stopped)
      return;
   
   if(m_auto_shift_grid && m_is_grid_cache_valid)
   {
      ShiftThreadFunc();
   }
   
   static datetime last_update = 0;
   if(TimeCurrent() - last_update >= 1)
   {
      UpdateDisplay();
      last_update = TimeCurrent();
   }
}

//+------------------------------------------------------------------+
//| OnChartEvent processing                                            |
//+------------------------------------------------------------------+
void CEvanGoldGrid::OnChartEvent(const int id, const long &lparam, const double &dparam, const string &sparam)
{
   if(id == CHARTEVENT_OBJECT_CLICK)
   {
      string clicked_obj = sparam;
      if(StringFind(clicked_obj, "BTN_") == 0)
      {
         if(clicked_obj == "BTN_GENERATE")
            OnGenerateGrid();
         else if(clicked_obj == "BTN_CLOSE_LOSS")
            OnCloseLosingPositions();
         else if(clicked_obj == "BTN_CLOSE_PROFIT")
            OnCloseProfitingPositions();
         else if(clicked_obj == "BTN_CLOSE_ALL")
            OnCloseAllPositions();
         else if(clicked_obj == "BTN_CANCEL_ALL")
            OnCancelAllPending();
         else if(clicked_obj == "BTN_CANCEL_CLOSE")
            OnCancelAndCloseAll();
         else if(clicked_obj == "BTN_REFRESH")
            OnRefreshCenterPrice();
         else if(clicked_obj == "BTN_DIRECTION")
            OnToggleGridMode();
         else if(clicked_obj == "BTN_AUTO_REFILL")
            OnToggleAutoRefill();
         else if(clicked_obj == "BTN_TRAILING_STOP")
            OnToggleTrailingStop();
         
         ObjectSetInteger(0, clicked_obj, OBJPROP_STATE, false);
         ChartRedraw();
      }
   }
}

//+------------------------------------------------------------------+
//| Toggle grid mode (Long -> Short -> Alternating -> Dual Side -> Long) |
//+------------------------------------------------------------------+
void CEvanGoldGrid::OnToggleGridMode(void)
{
   m_current_grid_mode = (m_current_grid_mode + 1) % 4;
   string mode_text;
   color mode_color;
   
   switch(m_current_grid_mode)
   {
      case 0:
         mode_text = "做多";
         mode_color = clrLimeGreen;
         break;
      case 1:
         mode_text = "做空";
         mode_color = clrRed;
         break;
      case 2:
         mode_text = "多空交替";
         mode_color = clrOrange;
         break;
      case 3:
         mode_text = "双边网格";
         mode_color = clrPurple;
         break;
      default:
         mode_text = "做多";
         mode_color = clrLimeGreen;
         break;
   }
   
   ObjectSetString(0, "BTN_DIRECTION", OBJPROP_TEXT, mode_text);
   ObjectSetInteger(0, "BTN_DIRECTION", OBJPROP_BGCOLOR, mode_color);
   Print(">>> Grid mode changed to: ", mode_text, " (", m_current_grid_mode, ")");
   ChartRedraw();
}

//+------------------------------------------------------------------+
//| Toggle auto refill on/off                                          |
//+------------------------------------------------------------------+
void CEvanGoldGrid::OnToggleAutoRefill(void)
{
   m_auto_refill_enabled = !m_auto_refill_enabled;
   
   if(m_auto_refill_enabled)
   {
      m_manual_intervention = false;
      Print(">>> Auto refill enabled, manual intervention flag reset");
   }
   
   string refill_text = m_auto_refill_enabled ? "自动补单：开" : "自动补单：关";
   color refill_color = m_auto_refill_enabled ? clrLimeGreen : clrGray;
   ObjectSetString(0, "BTN_AUTO_REFILL", OBJPROP_TEXT, refill_text);
   ObjectSetInteger(0, "BTN_AUTO_REFILL", OBJPROP_BGCOLOR, refill_color);
   Print(">>> Auto refill ", m_auto_refill_enabled ? "enabled" : "disabled");
   ChartRedraw();
}

//+------------------------------------------------------------------+
//| Refresh center price to current market price                       |
//+------------------------------------------------------------------+
void CEvanGoldGrid::OnRefreshCenterPrice(void)
{
   double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   double ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   double mid_price = NormalizeDouble((bid + ask) / 2.0, _Digits);
   SetEditValue(EDIT_CENTER_PRICE, mid_price);
   Print(">>> Center price refreshed to: ", DoubleToString(mid_price, _Digits));
}

//+------------------------------------------------------------------+
//| Timer event handler - called every 500ms                           |
//+------------------------------------------------------------------+
void CEvanGoldGrid::OnTimer(void)
{
   if(m_auto_refill_enabled && !m_manual_intervention && m_is_grid_cache_valid && m_grid_cache_count > 0)
   {
      CheckAndRefillGrid();
   }
   
   if(m_trailing_stop_enabled && m_is_grid_cache_valid && m_grid_cache_count > 0)
   {
      UpdateTrailingStop();
   }
}

//+------------------------------------------------------------------+
//| Update trailing stop to lock profits                               |
//+------------------------------------------------------------------+
void CEvanGoldGrid::UpdateTrailingStop(void)
{
   double point = SymbolInfoDouble(_Symbol, SYMBOL_POINT);
   
   for(int i = PositionsTotal() - 1; i >= 0; i--)
   {
      ulong ticket = PositionGetTicket(i);
      if(ticket == 0) continue;
      
      if(PositionSelectByTicket(ticket))
      {
         if(PositionGetInteger(POSITION_MAGIC) == m_magic_number && 
            PositionGetString(POSITION_SYMBOL) == _Symbol)
         {
            ENUM_POSITION_TYPE pos_type = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
            double open_price = PositionGetDouble(POSITION_PRICE_OPEN);
            double current_sl = PositionGetDouble(POSITION_SL);
            double current_price = (pos_type == POSITION_TYPE_BUY) ? 
                                   SymbolInfoDouble(_Symbol, SYMBOL_BID) : 
                                   SymbolInfoDouble(_Symbol, SYMBOL_ASK);
            
            double profit_points = (pos_type == POSITION_TYPE_BUY) ? 
                                   (current_price - open_price) / point : 
                                   (open_price - current_price) / point;
            
            if(profit_points <= 0)
               continue;
            
            double breakeven_threshold = m_grid_spacing / point;
            double trailing_step = m_grid_spacing * m_profit_trailing_percent / 100.0;
            if(trailing_step < point * 5)
               trailing_step = point * 5;
            
            double new_sl = 0;
            
            if(profit_points >= breakeven_threshold)
            {
               if(pos_type == POSITION_TYPE_BUY)
               {
                  new_sl = open_price + point * 0.5;
                  
                  if(profit_points >= (breakeven_threshold + trailing_step * 2 / point))
                  {
                     double locked_profit = profit_points - (trailing_step * 2 / point);
                     new_sl = open_price + locked_profit * point;
                  }
                  
                  if(new_sl <= current_sl + point * 0.1 && current_sl > 0)
                     continue;
               }
               else
               {
                  new_sl = open_price - point * 0.5;
                  
                  if(profit_points >= (breakeven_threshold + trailing_step * 2 / point))
                  {
                     double locked_profit = profit_points - (trailing_step * 2 / point);
                     new_sl = open_price - locked_profit * point;
                  }
                  
                  if(new_sl >= current_sl - point * 0.1 && current_sl > 0)
                     continue;
               }
               
               MqlTradeRequest request;
               MqlTradeResult result;
               ZeroMemory(request);
               ZeroMemory(result);
               
               request.action = TRADE_ACTION_SLTP;
               request.position = ticket;
               request.sl = NormalizeDouble(new_sl, _Digits);
               request.tp = PositionGetDouble(POSITION_TP);
               
               if(OrderSend(request, result))
               {
                  if(result.retcode == TRADE_RETCODE_DONE)
                  {
                     Print(">>> TrailingStop: Ticket=", ticket, 
                           " Profit=", DoubleToString(profit_points, 1), " pts",
                           " NewSL=", DoubleToString(new_sl, _Digits));
                  }
               }
            }
         }
      }
   }
}

//+------------------------------------------------------------------+
//| Generate grid orders                                               |
//+------------------------------------------------------------------+
void CEvanGoldGrid::GenerateGrid(void)
{
   bool is_backtest = (MQLInfoInteger(MQL_TESTER) || MQLInfoInteger(MQL_OPTIMIZATION));
   
   double center_price = is_backtest ? m_center_price : GetEditValue(EDIT_CENTER_PRICE);
   int grid_count = is_backtest ? m_grid_count : GetEditIntValue(EDIT_GRID_COUNT);
   double grid_spacing = is_backtest ? m_grid_spacing : GetEditValue(EDIT_GRID_SPACING);
   double take_profit = is_backtest ? m_take_profit : GetEditValue(EDIT_TAKE_PROFIT);
   double lot_size = is_backtest ? m_lot_size : GetEditValue(EDIT_LOT_SIZE);
   
   if(grid_count <= 0 || grid_spacing <= 0 || lot_size <= 0)
   {
      Print("GenerateGrid failed: Invalid parameters. Count=", grid_count, " Spacing=", grid_spacing, " Lot=", lot_size);
      return;
   }
   
   if(center_price <= 0)
   {
      double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
      double ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
      center_price = NormalizeDouble((bid + ask) / 2.0, _Digits);
      Print("Center price is 0, using market price: ", DoubleToString(center_price, _Digits));
   }
   
   if(!IsTradingTime())
   {
      Print("GenerateGrid: Not in trading time");
      return;
   }
   
   int current_orders = CountMyOrders();
   if(current_orders >= m_max_orders)
      return;
   
   int available_slots = m_max_orders - current_orders;
   int orders_per_grid = (m_current_grid_mode == 3) ? 2 : 1;
   int max_grids = MathMin(grid_count, available_slots / orders_per_grid);
   int orders_to_create = max_grids * orders_per_grid;
   
   Print("Starting grid generation: Center=", center_price, ", Grids=", grid_count, ", ToCreate=", orders_to_create, ", Mode=", m_current_grid_mode);
   
   double current_bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   double current_ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   
   SGridOrderInfo orders[];
   ArrayResize(orders, orders_to_create);
   
   double grid_prices[];
   ArrayResize(grid_prices, max_grids);
   
   int half_grids = max_grids / 2;
   for(int i = 0; i < max_grids; i++)
   {
      grid_prices[i] = NormalizeDouble(center_price + (i - half_grids) * grid_spacing, _Digits);
   }
   
   Print("Grid price range: ", DoubleToString(grid_prices[0], _Digits), " ~ ", DoubleToString(grid_prices[max_grids - 1], _Digits));
   
   int order_index = 0;
   for(int i = 0; i < max_grids; i++)
   {
      double price = grid_prices[i];
      
      if(m_current_grid_mode == 3)
      {
         CreateDualSideOrder(orders, order_index, i, price, true, current_ask, current_bid, take_profit);
         order_index++;
         CreateDualSideOrder(orders, order_index, i, price, false, current_ask, current_bid, take_profit);
         order_index++;
      }
      else
      {
         ENUM_ORDER_TYPE order_type_local;
         double tp;
         string type_name;
         bool is_buy_order = false;
         
         if(m_current_grid_mode == 0)
            is_buy_order = true;
         else if(m_current_grid_mode == 1)
            is_buy_order = false;
         else if(m_current_grid_mode == 2)
            is_buy_order = (i % 2 == 0);
         
         if(is_buy_order)
         {
            tp = price + take_profit;
            if(price < current_ask)
            {
               order_type_local = ORDER_TYPE_BUY_LIMIT;
               type_name = "BUY_LIMIT";
            }
            else
            {
               order_type_local = ORDER_TYPE_BUY_STOP;
               type_name = "BUY_STOP";
            }
         }
         else
         {
            tp = price - take_profit;
            if(price > current_bid)
            {
               order_type_local = ORDER_TYPE_SELL_LIMIT;
               type_name = "SELL_LIMIT";
            }
            else
            {
               order_type_local = ORDER_TYPE_SELL_STOP;
               type_name = "SELL_STOP";
            }
         }
         
         orders[order_index].m_grid_index = i;
         orders[order_index].m_type = order_type_local;
         orders[order_index].m_price = price;
         orders[order_index].m_tp = tp;
         orders[order_index].m_is_buy_order = is_buy_order;
         orders[order_index].m_comment = "GP_" + DoubleToString(price, _Digits) + "_" + type_name;
         Print("Order #", order_index + 1, ": Index=", i, " Price=", DoubleToString(price, _Digits), " Type=", type_name, " TP=", DoubleToString(tp, _Digits));
         order_index++;
      }
   }
   
   ArrayResize(m_grid_cache, max_grids);
   for(int i = 0; i < max_grids; i++)
   {
      m_grid_cache[i].m_price = grid_prices[i];
      m_grid_cache[i].m_is_buy_order = (m_current_grid_mode == 0 || (m_current_grid_mode == 2 && i % 2 == 0));
      m_grid_cache[i].m_has_pending = false;
      m_grid_cache[i].m_has_position = false;
      m_grid_cache[i].m_has_buy_pending = false;
      m_grid_cache[i].m_has_sell_pending = false;
      m_grid_cache[i].m_has_buy_position = false;
      m_grid_cache[i].m_has_sell_position = false;
   }
   m_grid_cache_count = max_grids;
   m_is_grid_cache_valid = true;
   m_manual_intervention = false;
   
   if(m_grid_cache_count > 0)
   {
      m_grid_lower_price = m_grid_cache[0].m_price;
      m_grid_upper_price = m_grid_cache[m_grid_cache_count - 1].m_price;
   }
   
   Print(">>> Grid cache created: ", m_grid_cache_count, " grids, Range=[", m_grid_lower_price, " ~ ", m_grid_upper_price, "]");
   
   uint start_time = GetTickCount();
   int success_count = BatchPlaceOrders(orders, lot_size);
   uint elapsed = GetTickCount() - start_time;
   Print("=== Batch order placement completed: Success=", success_count, "/", order_index, ", Time=", elapsed, "ms ===");
   
   UpdateDisplay();
}

//+------------------------------------------------------------------+
//| Batch place orders using async mode                                |
//+------------------------------------------------------------------+
int CEvanGoldGrid::BatchPlaceOrders(SGridOrderInfo &orders[], const double lot_size)
{
   int total = ArraySize(orders);
   if(total == 0)
      return(0);
   
   int success_count = 0;
   int digits = (int)SymbolInfoInteger(_Symbol, SYMBOL_DIGITS);
   
   MqlTradeRequest request;
   MqlTradeResult result;
   ZeroMemory(request);
   request.action = TRADE_ACTION_PENDING;
   request.symbol = _Symbol;
   request.volume = lot_size;
   request.type_time = ORDER_TIME_GTC;
   request.type_filling = ORDER_FILLING_RETURN;
   request.deviation = m_slippage;
   request.magic = m_magic_number;
   
   const int batch_size = 10;
   int batches = (total + batch_size - 1) / batch_size;
   
   for(int b = 0; b < batches; b++)
   {
      int start = b * batch_size;
      int end = MathMin(start + batch_size, total);
      
      for(int i = start; i < end; i++)
      {
         request.type = orders[i].m_type;
         request.price = NormalizeDouble(orders[i].m_price, digits);
         request.tp = NormalizeDouble(orders[i].m_tp, digits);
         request.comment = orders[i].m_comment;
         
         if(OrderSendAsync(request, result))
            success_count++;
         else if(OrderSend(request, result))
            success_count++;
      }
      
      if(b < batches - 1)
         Sleep(5);
   }
   
   return(success_count);
}

//+------------------------------------------------------------------+
//| Check and refill grid positions                                    |
//+------------------------------------------------------------------+
void CEvanGoldGrid::CheckAndRefillGrid(void)
{
   if(!m_auto_refill_enabled)
      return;
   
   if(m_manual_intervention)
   {
      Print(">>> Manual intervention detected, skipping auto refill");
      return;
   }
   
   if(!m_is_grid_cache_valid || m_grid_cache_count == 0)
      return;
   
   datetime current_time = TimeCurrent();
   if(current_time - m_last_check_time < 0.1)
      return;
   m_last_check_time = current_time;
   
   int refill_count = 0;
   for(int i = 0; i < m_grid_cache_count; i++)
   {
      double price = m_grid_cache[i].m_price;
      bool is_buy = m_grid_cache[i].m_is_buy_order;
      
      if(!HasOrderForPrice(price, is_buy))
      {
         Print(">>> Vacant grid at price=", DoubleToString(price, _Digits), " IsBuy=", is_buy);
         if(RefillOrderAtPrice(price, is_buy))
            refill_count++;
         if(refill_count >= 10)
            break;
      }
   }
   
   if(refill_count > 0)
   {
      Print(">>> Grid refill completed: ", refill_count, " orders placed");
      UpdateDisplay();
   }
}

//+------------------------------------------------------------------+
//| Legacy compatibility functions for grid shift logic                |
//+------------------------------------------------------------------+
bool CEvanGoldGrid::HasPendingOrderForGrid(const int grid_index)
{
   if(grid_index < 0 || grid_index >= m_grid_cache_count)
      return(false);
   double price = m_grid_cache[grid_index].m_price;
   bool is_buy = m_grid_cache[grid_index].m_is_buy_order;
   return(HasPendingOrderForPrice(price, is_buy));
}

bool CEvanGoldGrid::HasPositionForGrid(const int grid_index)
{
   if(grid_index < 0 || grid_index >= m_grid_cache_count)
      return(false);
   double price = m_grid_cache[grid_index].m_price;
   bool is_buy = m_grid_cache[grid_index].m_is_buy_order;
   return(HasPositionForPrice(price, is_buy));
}

bool CEvanGoldGrid::HasOrderForGridIndex(const int grid_index)
{
   if(grid_index < 0 || grid_index >= m_grid_cache_count)
      return(false);
   double price = m_grid_cache[grid_index].m_price;
   bool is_buy = m_grid_cache[grid_index].m_is_buy_order;
   return(HasOrderForPrice(price, is_buy));
}

//+------------------------------------------------------------------+
//| Check if price has pending order                                   |
//+------------------------------------------------------------------+
bool CEvanGoldGrid::HasPendingOrderForPrice(const double price, const bool is_buy_order)
{
   string price_str = DoubleToString(price, _Digits);
   string order_prefix = "GP_" + price_str + "_";
   
   for(int i = 0; i < OrdersTotal(); i++)
   {
      ulong ticket = OrderGetTicket(i);
      if(ticket == 0)
         continue;
      if(OrderSelect(ticket))
      {
         if(OrderGetInteger(ORDER_MAGIC) == m_magic_number && OrderGetString(ORDER_SYMBOL) == _Symbol)
         {
            string comment = OrderGetString(ORDER_COMMENT);
            if(StringFind(comment, order_prefix) == 0)
            {
               string rest = StringSubstr(comment, StringLen(order_prefix));
               if(StringFind(rest, "BUY") == 0 || StringFind(rest, "SELL") == 0)
                  return(true);
            }
         }
      }
   }
   return(false);
}

//+------------------------------------------------------------------+
//| Check if price has position                                        |
//+------------------------------------------------------------------+
bool CEvanGoldGrid::HasPositionForPrice(const double price, const bool is_buy_order)
{
   string price_str = DoubleToString(price, _Digits);
   string order_prefix = "GP_" + price_str + "_";
   
   for(int i = 0; i < PositionsTotal(); i++)
   {
      ulong ticket = PositionGetTicket(i);
      if(ticket == 0)
         continue;
      if(PositionSelectByTicket(ticket))
      {
         if(PositionGetInteger(POSITION_MAGIC) == m_magic_number && PositionGetString(POSITION_SYMBOL) == _Symbol)
         {
            string comment = PositionGetString(POSITION_COMMENT);
            if(StringFind(comment, order_prefix) == 0)
            {
               string rest = StringSubstr(comment, StringLen(order_prefix));
               if(StringFind(rest, "BUY") == 0 || StringFind(rest, "SELL") == 0)
                  return(true);
            }
         }
      }
   }
   return(false);
}

//+------------------------------------------------------------------+
//| Check if price has any order (pending or position)                 |
//+------------------------------------------------------------------+
bool CEvanGoldGrid::HasOrderForPrice(const double price, const bool is_buy_order)
{
   if(m_current_grid_mode == 3)
   {
      bool has_buy = HasPendingOrderForPrice(price, true) || HasPositionForPrice(price, true);
      bool has_sell = HasPendingOrderForPrice(price, false) || HasPositionForPrice(price, false);
      
      if(!has_buy || !has_sell)
      {
         Print(">>> DualMode Price=", DoubleToString(price, _Digits), " Status: Buy=", has_buy ? "YES" : "NO", " Sell=", has_sell ? "YES" : "NO");
      }
      
      return(has_buy && has_sell);
   }
   
   return(HasPendingOrderForPrice(price, is_buy_order) || HasPositionForPrice(price, is_buy_order));
}

//+------------------------------------------------------------------+
//| Refill order at specific price                                     |
//+------------------------------------------------------------------+
bool CEvanGoldGrid::RefillOrderAtPrice(const double price, const bool is_buy_order)
{
   bool is_backtest = (MQLInfoInteger(MQL_TESTER) || MQLInfoInteger(MQL_OPTIMIZATION));
   double take_profit = is_backtest ? m_take_profit : GetEditValue(EDIT_TAKE_PROFIT);
   double lot_size = is_backtest ? m_lot_size : GetEditValue(EDIT_LOT_SIZE);
   
   if(lot_size <= 0)
   {
      Print("Auto refill failed: Invalid lot size");
      return(false);
   }
   
   if(!IsTradingTime())
   {
      Print("Auto refill: Not in trading time");
      return(false);
   }
   
   int current_orders = CountMyOrders();
   if(current_orders >= m_max_orders)
   {
      Print("Auto refill: Maximum order limit reached");
      return(false);
   }
   
   double current_bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   double current_ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   
   if(m_current_grid_mode == 3)
   {
      int refilled = 0;
      
      if(!HasPendingOrderForPrice(price, true) && !HasPositionForPrice(price, true))
      {
         double tp_buy = price + take_profit;
         ENUM_ORDER_TYPE buy_type = (price < current_ask) ? ORDER_TYPE_BUY_LIMIT : ORDER_TYPE_BUY_STOP;
         string type_name = (buy_type == ORDER_TYPE_BUY_LIMIT) ? "BUY_LIMIT" : "BUY_STOP";
         string comment = "GP_" + DoubleToString(price, _Digits) + "_" + type_name;
         
         Print(">>> Refilling BUY order: Price=", DoubleToString(price, _Digits), " Type=", type_name, " TP=", DoubleToString(tp_buy, _Digits));
         if(PlaceRefillOrder(buy_type, price, lot_size, tp_buy, comment))
         {
            refilled++;
            Print(">>> BUY order refilled successfully");
         }
      }
      
      if(!HasPendingOrderForPrice(price, false) && !HasPositionForPrice(price, false))
      {
         double tp_sell = price - take_profit;
         ENUM_ORDER_TYPE sell_type = (price > current_bid) ? ORDER_TYPE_SELL_LIMIT : ORDER_TYPE_SELL_STOP;
         string type_name = (sell_type == ORDER_TYPE_SELL_LIMIT) ? "SELL_LIMIT" : "SELL_STOP";
         string comment = "GP_" + DoubleToString(price, _Digits) + "_" + type_name;
         
         Print(">>> Refilling SELL order: Price=", DoubleToString(price, _Digits), " Type=", type_name, " TP=", DoubleToString(tp_sell, _Digits));
         if(PlaceRefillOrder(sell_type, price, lot_size, tp_sell, comment))
         {
            refilled++;
            Print(">>> SELL order refilled successfully");
         }
      }
      
      if(refilled > 0)
      {
         UpdateDisplay();
         return(true);
      }
      return(false);
   }
   
   if(HasOrderForPrice(price, is_buy_order))
   {
      Print("Auto refill: Price=", DoubleToString(price, _Digits), " already has order");
      return(false);
   }
   
   Print(">>> Refill decision: Price=", DoubleToString(price, _Digits), " IsBuy=", is_buy_order ? "true" : "false", " Bid=", DoubleToString(current_bid, _Digits), " Ask=", DoubleToString(current_ask, _Digits));
   
   double tp = is_buy_order ? (price + take_profit) : (price - take_profit);
   ENUM_ORDER_TYPE order_type;
   string type_name;
   
   if(is_buy_order)
   {
      if(price < current_ask)
      {
         order_type = ORDER_TYPE_BUY_LIMIT;
         type_name = "BUY_LIMIT";
      }
      else
      {
         order_type = ORDER_TYPE_BUY_STOP;
         type_name = "BUY_STOP";
      }
   }
   else
   {
      if(price > current_bid)
      {
         order_type = ORDER_TYPE_SELL_LIMIT;
         type_name = "SELL_LIMIT";
      }
      else
      {
         order_type = ORDER_TYPE_SELL_STOP;
         type_name = "SELL_STOP";
      }
   }
   
   string comment = "GP_" + DoubleToString(price, _Digits) + "_" + type_name;
   
   Print(">>> Sending refill order: Type=", type_name, " Price=", DoubleToString(price, _Digits), " TP=", DoubleToString(tp, _Digits), " Lot=", lot_size, " Comment=", comment);
   
   if(PlaceRefillOrder(order_type, price, lot_size, tp, comment))
   {
      Print(">>> Auto refill success: Price=", DoubleToString(price, _Digits), " Type=", type_name, " TP=", DoubleToString(tp, _Digits));
      UpdateDisplay();
      return(true);
   }
   else
   {
      Print(">>> Auto refill failed: Type=", type_name, " Error=", GetLastError());
      return(false);
   }
}

//+------------------------------------------------------------------+
//| Place a single refill order                                        |
//+------------------------------------------------------------------+
bool CEvanGoldGrid::PlaceRefillOrder(const ENUM_ORDER_TYPE order_type, const double price, const double lot_size, const double take_profit, const string comment)
{
   MqlTradeRequest request;
   MqlTradeResult result;
   ZeroMemory(request);
   request.action = TRADE_ACTION_PENDING;
   request.symbol = _Symbol;
   request.volume = lot_size;
   request.type = order_type;
   request.price = NormalizeDouble(price, _Digits);
   request.tp = NormalizeDouble(take_profit, _Digits);
   request.type_time = ORDER_TIME_GTC;
   request.type_filling = ORDER_FILLING_RETURN;
   request.deviation = m_slippage;
   request.magic = m_magic_number;
   request.comment = comment;
   
   Print(">>> Sending order: Action=", request.action, " Symbol=", request.symbol, " Type=", request.type, " Price=", DoubleToString(request.price, _Digits), " TP=", DoubleToString(request.tp, _Digits), " Volume=", request.volume);
   
   if(OrderSend(request, result))
   {
      Print(">>> OrderSend success: RetCode=", result.retcode, " Order=", result.order);
      return(true);
   }
   
   Print(">>> OrderSend failed: RetCode=", result.retcode, " Error=", GetLastError());
   Print(">>> Trying CTrade.OrderOpen...");
   
   if(m_trade.OrderOpen(request.symbol, (ENUM_ORDER_TYPE)request.type, request.volume, request.price, 0, 0, request.tp, ORDER_TIME_GTC, 0, request.comment))
   {
      Print(">>> CTrade.OrderOpen success");
      return(true);
   }
   
   Print(">>> CTrade.OrderOpen also failed: ", m_trade.ResultRetcode());
   return(false);
}

//+------------------------------------------------------------------+
//| Close losing positions                                             |
//+------------------------------------------------------------------+
void CEvanGoldGrid::OnCloseLosingPositions(void)
{
   m_manual_intervention = true;
   Print(">>> Closing losing positions, manual intervention flagged");
   BatchClosePositions(true, false);
}

//+------------------------------------------------------------------+
//| Close profitable positions                                         |
//+------------------------------------------------------------------+
void CEvanGoldGrid::OnCloseProfitingPositions(void)
{
   m_manual_intervention = true;
   Print(">>> Closing profitable positions, manual intervention flagged");
   BatchClosePositions(false, true);
}

//+------------------------------------------------------------------+
//| Close all positions                                                |
//+------------------------------------------------------------------+
void CEvanGoldGrid::OnCloseAllPositions(void)
{
   m_manual_intervention = true;
   Print(">>> Closing all positions, manual intervention flagged");
   BatchClosePositions(false, false);
}

//+------------------------------------------------------------------+
//| Cancel all pending orders                                          |
//+------------------------------------------------------------------+
void CEvanGoldGrid::OnCancelAllPending(void)
{
   m_manual_intervention = true;
   
   int canceled = 0;
   
   for(int i = OrdersTotal() - 1; i >= 0; i--)
   {
      ulong ticket = OrderGetTicket(i);
      if(ticket == 0)
         continue;
      
      if(OrderSelect(ticket) && OrderGetInteger(ORDER_MAGIC) == m_magic_number && OrderGetString(ORDER_SYMBOL) == _Symbol)
      {
         if(m_trade.OrderDelete(ticket))
         {
            canceled++;
         }
         else
         {
            Print("Cancel order failed: Ticket=", ticket, " RetCode=", m_trade.ResultRetcode());
         }
      }
   }
   
   Sleep(50);
   Print("OnCancelAllPending: Canceled=", canceled);
   UpdateDisplay();
}

//+------------------------------------------------------------------+
//| Cancel all pending and close all positions                         |
//+------------------------------------------------------------------+
void CEvanGoldGrid::OnCancelAndCloseAll(void)
{
   m_manual_intervention = true;
   
   int canceled = 0;
   for(int i = OrdersTotal() - 1; i >= 0; i--)
   {
      ulong ticket = OrderGetTicket(i);
      if(ticket == 0)
         continue;
      
      if(OrderSelect(ticket) && OrderGetInteger(ORDER_MAGIC) == m_magic_number && OrderGetString(ORDER_SYMBOL) == _Symbol)
      {
         if(m_trade.OrderDelete(ticket))
         {
            canceled++;
         }
         else
         {
            Print("Cancel order failed: Ticket=", ticket, " RetCode=", m_trade.ResultRetcode());
         }
      }
   }
   
   if(canceled > 0)
   {
      Sleep(50);
   }
   
   int closed = 0;
   for(int i = PositionsTotal() - 1; i >= 0; i--)
   {
      ulong ticket = PositionGetTicket(i);
      if(ticket == 0)
         continue;
      
      if(PositionSelectByTicket(ticket) && PositionGetInteger(POSITION_MAGIC) == m_magic_number && PositionGetString(POSITION_SYMBOL) == _Symbol)
      {
         if(m_trade.PositionClose(ticket))
         {
            closed++;
         }
         else
         {
            Print("Close position failed: Ticket=", ticket, " RetCode=", m_trade.ResultRetcode());
         }
      }
   }
   
   Sleep(50);
   Print("OnCancelAndCloseAll: Canceled=", canceled, ", Closed=", closed);
   UpdateDisplay();
}

//+------------------------------------------------------------------+
//| Batch close positions                                              |
//+------------------------------------------------------------------+
void CEvanGoldGrid::BatchClosePositions(const bool close_loss_only, const bool close_profit_only)
{
   int closed = 0;
   
   for(int i = PositionsTotal() - 1; i >= 0; i--)
   {
      ulong ticket = PositionGetTicket(i);
      if(ticket == 0)
         continue;
      
      if(PositionSelectByTicket(ticket) && PositionGetInteger(POSITION_MAGIC) == m_magic_number && PositionGetString(POSITION_SYMBOL) == _Symbol)
      {
         double profit = PositionGetDouble(POSITION_PROFIT);
         
         if(close_loss_only && profit >= 0)
            continue;
         if(close_profit_only && profit <= 0)
            continue;
         
         if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY)
         {
            if(m_trade.PositionClose(ticket))
               closed++;
            else
               Print("Close BUY position failed: Ticket=", ticket, " RetCode=", m_trade.ResultRetcode());
         }
         else
         {
            if(m_trade.PositionClose(ticket))
               closed++;
            else
               Print("Close SELL position failed: Ticket=", ticket, " RetCode=", m_trade.ResultRetcode());
         }
      }
   }
   
   Sleep(50);
   Print("BatchClosePositions: Closed=", closed, " LossOnly=", close_loss_only, " ProfitOnly=", close_profit_only);
   UpdateDisplay();
}

//+------------------------------------------------------------------+
//| Event handler wrapper for button click                             |
//+------------------------------------------------------------------+
void CEvanGoldGrid::OnGenerateGrid(void)
{
   GenerateGrid();
}

//+------------------------------------------------------------------+
//| Create dual side order (Mode 3)                                    |
//+------------------------------------------------------------------+
void CEvanGoldGrid::CreateDualSideOrder(SGridOrderInfo &orders[], int &order_index, const int grid_index, const double price, const bool is_buy_order, const double current_ask, const double current_bid, const double take_profit)
{
   ENUM_ORDER_TYPE order_type_local;
   double tp;
   string type_name;
   
   if(is_buy_order)
   {
      tp = price + take_profit;
      if(price < current_ask)
      {
         order_type_local = ORDER_TYPE_BUY_LIMIT;
         type_name = "BUY_LIMIT";
      }
      else
      {
         order_type_local = ORDER_TYPE_BUY_STOP;
         type_name = "BUY_STOP";
      }
   }
   else
   {
      tp = price - take_profit;
      if(price > current_bid)
      {
         order_type_local = ORDER_TYPE_SELL_LIMIT;
         type_name = "SELL_LIMIT";
      }
      else
      {
         order_type_local = ORDER_TYPE_SELL_STOP;
         type_name = "SELL_STOP";
      }
   }
   
   orders[order_index].m_grid_index = grid_index;
   orders[order_index].m_type = order_type_local;
   orders[order_index].m_price = price;
   orders[order_index].m_tp = tp;
   orders[order_index].m_is_buy_order = is_buy_order;
   orders[order_index].m_comment = "GP_" + DoubleToString(price, _Digits) + "_" + type_name;
   
   Print("DualSide Order #", order_index + 1, ": Grid=", grid_index, " Price=", DoubleToString(price, _Digits), " Type=", type_name, " TP=", DoubleToString(tp, _Digits));
}

//+------------------------------------------------------------------+
//| Check if price has buy order (pending or position)                 |
//+------------------------------------------------------------------+
bool CEvanGoldGrid::HasBuyOrderForGrid(const int grid_index)
{
   double price = m_grid_cache[grid_index].m_price;
   string price_str = DoubleToString(price, _Digits);
   string order_prefix = "GP_" + price_str + "_";
   
   for(int i = 0; i < OrdersTotal(); i++)
   {
      ulong ticket = OrderGetTicket(i);
      if(ticket == 0)
         continue;
      if(OrderSelect(ticket))
      {
         if(OrderGetInteger(ORDER_MAGIC) == m_magic_number && OrderGetString(ORDER_SYMBOL) == _Symbol)
         {
            string comment = OrderGetString(ORDER_COMMENT);
            if(StringFind(comment, order_prefix) == 0)
            {
               string rest = StringSubstr(comment, StringLen(order_prefix));
               if(StringFind(rest, "BUY") == 0)
               {
                  Print(">>> HasBuyOrder: Found BUY pending order #", ticket, " Comment=", comment);
                  return(true);
               }
            }
         }
      }
   }
   
   for(int i = 0; i < PositionsTotal(); i++)
   {
      ulong ticket = PositionGetTicket(i);
      if(ticket == 0)
         continue;
      if(PositionSelectByTicket(ticket))
      {
         if(PositionGetInteger(POSITION_MAGIC) == m_magic_number && PositionGetString(POSITION_SYMBOL) == _Symbol)
         {
            string comment = PositionGetString(POSITION_COMMENT);
            if(StringFind(comment, order_prefix) == 0)
            {
               string rest = StringSubstr(comment, StringLen(order_prefix));
               if(StringFind(rest, "BUY") == 0)
               {
                  Print(">>> HasBuyOrder: Found BUY position #", ticket, " Comment=", comment);
                  return(true);
               }
            }
         }
      }
   }
   return(false);
}

//+------------------------------------------------------------------+
//| Check if price has sell order (pending or position)                |
//+------------------------------------------------------------------+
bool CEvanGoldGrid::HasSellOrderForGrid(const int grid_index)
{
   double price = m_grid_cache[grid_index].m_price;
   string price_str = DoubleToString(price, _Digits);
   string order_prefix = "GP_" + price_str + "_";
   
   for(int i = 0; i < OrdersTotal(); i++)
   {
      ulong ticket = OrderGetTicket(i);
      if(ticket == 0)
         continue;
      if(OrderSelect(ticket))
      {
         if(OrderGetInteger(ORDER_MAGIC) == m_magic_number && OrderGetString(ORDER_SYMBOL) == _Symbol)
         {
            string comment = OrderGetString(ORDER_COMMENT);
            if(StringFind(comment, order_prefix) == 0)
            {
               string rest = StringSubstr(comment, StringLen(order_prefix));
               if(StringFind(rest, "SELL") == 0)
               {
                  Print(">>> HasSellOrder: Found SELL pending order #", ticket, " Comment=", comment);
                  return(true);
               }
            }
         }
      }
   }
   
   for(int i = 0; i < PositionsTotal(); i++)
   {
      ulong ticket = PositionGetTicket(i);
      if(ticket == 0)
         continue;
      if(PositionSelectByTicket(ticket))
      {
         if(PositionGetInteger(POSITION_MAGIC) == m_magic_number && PositionGetString(POSITION_SYMBOL) == _Symbol)
         {
            string comment = PositionGetString(POSITION_COMMENT);
            if(StringFind(comment, order_prefix) == 0)
            {
               string rest = StringSubstr(comment, StringLen(order_prefix));
               if(StringFind(rest, "SELL") == 0)
               {
                  Print(">>> HasSellOrder: Found SELL position #", ticket, " Comment=", comment);
                  return(true);
               }
            }
         }
      }
   }
   return(false);
}

//+------------------------------------------------------------------+
//| Get total profit of all positions                                  |
//+------------------------------------------------------------------+
double CEvanGoldGrid::GetTotalProfit(void)
{
   double total_profit = 0.0;
   for(int i = 0; i < PositionsTotal(); i++)
   {
      ulong ticket = PositionGetTicket(i);
      if(ticket == 0)
         continue;
      if(PositionSelectByTicket(ticket))
      {
         if(PositionGetInteger(POSITION_MAGIC) == m_magic_number && PositionGetString(POSITION_SYMBOL) == _Symbol)
         {
            total_profit += PositionGetDouble(POSITION_PROFIT);
         }
      }
   }
   return(total_profit);
}

//+------------------------------------------------------------------+
//| Stop all trading and close positions                               |
//+------------------------------------------------------------------+
void CEvanGoldGrid::StopAllTrading(void)
{
   m_trading_stopped = true;
   m_auto_refill_enabled = false;
   
   int canceled = 0;
   for(int i = OrdersTotal() - 1; i >= 0; i--)
   {
      ulong ticket = OrderGetTicket(i);
      if(ticket == 0)
         continue;
      
      if(OrderSelect(ticket) && OrderGetInteger(ORDER_MAGIC) == m_magic_number && OrderGetString(ORDER_SYMBOL) == _Symbol)
      {
         if(m_trade.OrderDelete(ticket))
         {
            canceled++;
         }
      }
   }
   
   if(canceled > 0)
   {
      Sleep(50);
   }
   
   int closed = 0;
   for(int i = PositionsTotal() - 1; i >= 0; i--)
   {
      ulong ticket = PositionGetTicket(i);
      if(ticket == 0)
         continue;
      
      if(PositionSelectByTicket(ticket) && PositionGetInteger(POSITION_MAGIC) == m_magic_number && PositionGetString(POSITION_SYMBOL) == _Symbol)
      {
         if(m_trade.PositionClose(ticket))
         {
            closed++;
         }
      }
   }
   
   Sleep(50);
   Print("StopAllTrading: Canceled=", canceled, ", Closed=", closed);
   UpdateDisplay();
}

//+------------------------------------------------------------------+
//| Toggle trailing stop on/off                                        |
//+------------------------------------------------------------------+
void CEvanGoldGrid::OnToggleTrailingStop(void)
{
   m_trailing_stop_enabled = !m_trailing_stop_enabled;
   
   if(m_trailing_stop_enabled)
   {
      Print(">>> Trailing Stop enabled");
   }
   
   string trailing_text = m_trailing_stop_enabled ? "移动止损：开" : "移动止损：关";
   color trailing_color = m_trailing_stop_enabled ? clrLimeGreen : clrGray;
   ObjectSetString(0, "BTN_TRAILING_STOP", OBJPROP_TEXT, trailing_text);
   ObjectSetInteger(0, "BTN_TRAILING_STOP", OBJPROP_BGCOLOR, trailing_color);
   ChartRedraw();
}

//+------------------------------------------------------------------+
//| Check and shift grids based on current price                       |
//+------------------------------------------------------------------+
void CEvanGoldGrid::CheckAndShiftGrids(void)
{
   double current_price = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   
   m_grid_lower_price = m_grid_cache[0].m_price;
   m_grid_upper_price = m_grid_cache[m_grid_cache_count - 1].m_price;
   
   bool needs_update = false;
   
   for(int i = 0; i < m_grid_cache_count; i++)
   {
      double grid_price = m_grid_cache[i].m_price;
      bool has_position = HasPositionForGrid(i);
      bool has_pending = HasPendingOrderForGrid(i);
      
      if(!has_position && !has_pending)
         continue;
      
      bool should_move = false;
      int new_grid_index = -1;
      
      if(m_grid_cache[i].m_is_buy_order)
      {
         if(current_price > grid_price + m_grid_spacing * 2)
         {
            int grids_above = (int)((current_price - grid_price) / m_grid_spacing);
            new_grid_index = i + grids_above;
            
            if(new_grid_index >= m_grid_cache_count)
               new_grid_index = m_grid_cache_count - 1;
            
            if(new_grid_index != i && !HasOrderForGridIndex(new_grid_index))
               should_move = true;
         }
         else if(current_price < grid_price - m_grid_spacing * 2)
         {
            int grids_below = (int)((grid_price - current_price) / m_grid_spacing);
            new_grid_index = i - grids_below;
            
            if(new_grid_index < 0)
               new_grid_index = 0;
            
            if(new_grid_index != i && !HasOrderForGridIndex(new_grid_index))
               should_move = true;
         }
      }
      else
      {
         if(current_price < grid_price - m_grid_spacing * 2)
         {
            int grids_below = (int)((grid_price - current_price) / m_grid_spacing);
            new_grid_index = i - grids_below;
            
            if(new_grid_index < 0)
               new_grid_index = 0;
            
            if(new_grid_index != i && !HasOrderForGridIndex(new_grid_index))
               should_move = true;
         }
         else if(current_price > grid_price + m_grid_spacing * 2)
         {
            int grids_above = (int)((current_price - grid_price) / m_grid_spacing);
            new_grid_index = i + grids_above;
            
            if(new_grid_index >= m_grid_cache_count)
               new_grid_index = m_grid_cache_count - 1;
            
            if(new_grid_index != i && !HasOrderForGridIndex(new_grid_index))
               should_move = true;
         }
      }
      
      if(should_move && new_grid_index >= 0)
      {
         Print(">>> Grid #", i, " should move to #", new_grid_index, 
               " Price=", DoubleToString(grid_price, _Digits), 
               " Current=", DoubleToString(current_price, _Digits));
         
         if(has_position)
         {
            Print(">>> Closing position at grid #", i);
            ClosePositionAtGrid(i);
            Sleep(10);
          }
          
          if(has_pending)
          {
             string grid_tag = "Grid_" + IntegerToString(i) + "_";
             MqlTradeRequest request;
             MqlTradeResult result;
             ZeroMemory(request);
             ZeroMemory(result);
             request.action = TRADE_ACTION_PENDING;
             
             for(int j = OrdersTotal() - 1; j >= 0; j--)
             {
                ulong ticket = OrderGetTicket(j);
                if(ticket == 0) continue;
                
             if(OrderSelect(ticket))
             {
                if(OrderGetInteger(ORDER_MAGIC) == m_magic_number && 
                   OrderGetString(ORDER_SYMBOL) == _Symbol)
                {
                   string comment = OrderGetString(ORDER_COMMENT);
                   if(StringFind(comment, grid_tag) == 0)
                   {
                      if(m_trade.OrderDelete(ticket))
                      {
                         Print(">>> Deleted pending order at grid #", i);
                      }
                   }
                }
             }
             }
          }
          
          double new_price = m_grid_cache[new_grid_index].m_price;
          m_grid_cache[i].m_price = new_price;
          
          Print(">>> Moved grid #", i, " to price ", DoubleToString(new_price, _Digits));
         
         needs_update = true;
      }
   }
   
   if(needs_update)
   {
      m_grid_lower_price = m_grid_cache[0].m_price;
      m_grid_upper_price = m_grid_cache[m_grid_cache_count - 1].m_price;
      Print(">>> Grid range updated: [", m_grid_lower_price, " ~ ", m_grid_upper_price, "]");
   }
}

//+------------------------------------------------------------------+
//| Shift grid up (move lowest grids to top)                           |
//+------------------------------------------------------------------+
bool CEvanGoldGrid::ShiftGridUp(int grids_to_shift)
{
   if(m_grid_cache_count < 2 || grids_to_shift <= 0)
      return(false);
   
   if(grids_to_shift >= m_grid_cache_count)
      grids_to_shift = m_grid_cache_count - 1;
   
   Print(">>> Shifting ", grids_to_shift, " grid(s) up");
   
   double current_bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   double current_ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   bool is_backtest = (MQLInfoInteger(MQL_TESTER) || MQLInfoInteger(MQL_OPTIMIZATION));
    double take_profit = is_backtest ? m_take_profit : GetEditValue(EDIT_TAKE_PROFIT);
    double lot_size = is_backtest ? m_lot_size : GetEditValue(EDIT_LOT_SIZE);
    
    MqlTradeRequest request;
    MqlTradeResult result;
    
    for(int i = 0; i < grids_to_shift; i++)
    {
       if(HasPositionForGrid(i))
       {
          Print(">>> Closing position at grid #", i);
          ClosePositionAtGrid(i);
          Sleep(10);
       }
       
       if(HasPendingOrderForGrid(i))
       {
          string grid_tag = "Grid_" + IntegerToString(i) + "_";
          ZeroMemory(request);
          ZeroMemory(result);
          request.action = TRADE_ACTION_PENDING;
          
          for(int j = OrdersTotal() - 1; j >= 0; j--)
          {
             ulong ticket = OrderGetTicket(j);
             if(ticket == 0) continue;
             
             if(OrderSelect(ticket))
             {
                if(OrderGetInteger(ORDER_MAGIC) == m_magic_number && 
                   OrderGetString(ORDER_SYMBOL) == _Symbol)
                {
                   string comment = OrderGetString(ORDER_COMMENT);
                   if(StringFind(comment, grid_tag) == 0)
                   {
                      request.order = ticket;
                      if(OrderSendAsync(request, result))
                      {
                         Print(">>> Deleted pending order at grid #", i);
                      }
                      else
                      {
                         OrderSend(request, result);
                      }
                   }
                }
             }
          }
       }
      
      double old_price = m_grid_cache[i].m_price;
      m_grid_cache[i].m_price = m_grid_cache[m_grid_cache_count - 1].m_price + m_grid_spacing;
      double new_price = m_grid_cache[i].m_price;
      
      Print(">>> Moving grid #", i, " from ", DoubleToString(old_price, _Digits), 
            " to ", DoubleToString(new_price, _Digits));
      
      ENUM_ORDER_TYPE order_type;
      double tp;
      string type_name;
      
      if(m_grid_cache[i].m_is_buy_order)
      {
         tp = new_price + take_profit;
         if(new_price < current_ask)
         {
            order_type = ORDER_TYPE_BUY_LIMIT;
            type_name = "BUY_LIMIT";
         }
         else
         {
            order_type = ORDER_TYPE_BUY_STOP;
            type_name = "BUY_STOP";
         }
      }
      else
      {
         tp = new_price - take_profit;
         if(new_price > current_bid)
         {
            order_type = ORDER_TYPE_SELL_LIMIT;
            type_name = "SELL_LIMIT";
         }
         else
         {
            order_type = ORDER_TYPE_SELL_STOP;
            type_name = "SELL_STOP";
         }
      }
      
      string comment = "Grid_" + IntegerToString(i) + "_" + type_name;
      
      MqlTradeRequest request;
      MqlTradeResult result;
      ZeroMemory(request);
      ZeroMemory(result);
      
      request.action = TRADE_ACTION_PENDING;
      request.symbol = _Symbol;
      request.volume = lot_size;
      request.type = order_type;
      request.price = NormalizeDouble(new_price, _Digits);
      request.tp = NormalizeDouble(tp, _Digits);
      request.type_time = ORDER_TIME_GTC;
      request.type_filling = ORDER_FILLING_RETURN;
      request.deviation = m_slippage;
      request.magic = m_magic_number;
      request.comment = comment;
      
      if(OrderSend(request, result))
      {
         Print(">>> Replaced order at grid #", i, " Ticket=", result.order, " Price=", DoubleToString(new_price, _Digits));
      }
      else
      {
         Print(">>> Failed to replace order at grid #", i, " RetCode=", result.retcode);
      }
   }
   
   m_grid_lower_price = m_grid_cache[0].m_price;
   m_grid_upper_price = m_grid_cache[m_grid_cache_count - 1].m_price;
   
   Print(">>> Grid shifted up. New range=[", m_grid_lower_price, " ~ ", m_grid_upper_price, "]");
   
   return(true);
}

//+------------------------------------------------------------------+
//| Shift grid down (move highest grids to bottom)                     |
//+------------------------------------------------------------------+
bool CEvanGoldGrid::ShiftGridDown(int grids_to_shift)
{
   if(m_grid_cache_count < 2 || grids_to_shift <= 0)
      return(false);
   
   if(grids_to_shift >= m_grid_cache_count)
      grids_to_shift = m_grid_cache_count - 1;
   
   Print(">>> Shifting ", grids_to_shift, " grid(s) down");
   
   double current_bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   double current_ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   bool is_backtest = (MQLInfoInteger(MQL_TESTER) || MQLInfoInteger(MQL_OPTIMIZATION));
    double take_profit = is_backtest ? m_take_profit : GetEditValue(EDIT_TAKE_PROFIT);
    double lot_size = is_backtest ? m_lot_size : GetEditValue(EDIT_LOT_SIZE);
    
    MqlTradeRequest request;
    MqlTradeResult result;
    
    for(int i = m_grid_cache_count - 1; i >= m_grid_cache_count - grids_to_shift; i--)
    {
       if(HasPositionForGrid(i))
       {
          Print(">>> Closing position at grid #", i);
          ClosePositionAtGrid(i);
          Sleep(10);
       }
       
       if(HasPendingOrderForGrid(i))
       {
          string grid_tag = "Grid_" + IntegerToString(i) + "_";
          
          for(int j = OrdersTotal() - 1; j >= 0; j--)
          {
             ulong ticket = OrderGetTicket(j);
             if(ticket == 0) continue;
             
             if(OrderSelect(ticket))
             {
                if(OrderGetInteger(ORDER_MAGIC) == m_magic_number && 
                   OrderGetString(ORDER_SYMBOL) == _Symbol)
                {
                   string comment = OrderGetString(ORDER_COMMENT);
                   if(StringFind(comment, grid_tag) == 0)
                   {
                      if(m_trade.OrderDelete(ticket))
                      {
                         Print(">>> Deleted pending order at grid #", i);
                      }
                   }
                }
             }
          }
       }
       
       double old_price = m_grid_cache[i].m_price;
       m_grid_cache[i].m_price = m_grid_cache[0].m_price - m_grid_spacing;
      double new_price = m_grid_cache[i].m_price;
      
      Print(">>> Moving grid #", i, " from ", DoubleToString(old_price, _Digits), 
            " to ", DoubleToString(new_price, _Digits));
      
      ENUM_ORDER_TYPE order_type;
      double tp;
      string type_name;
      
      if(m_grid_cache[i].m_is_buy_order)
      {
         tp = new_price + take_profit;
         if(new_price < current_ask)
         {
            order_type = ORDER_TYPE_BUY_LIMIT;
            type_name = "BUY_LIMIT";
         }
         else
         {
            order_type = ORDER_TYPE_BUY_STOP;
            type_name = "BUY_STOP";
         }
      }
      else
      {
         tp = new_price - take_profit;
         if(new_price > current_bid)
         {
            order_type = ORDER_TYPE_SELL_LIMIT;
            type_name = "SELL_LIMIT";
         }
         else
         {
            order_type = ORDER_TYPE_SELL_STOP;
            type_name = "SELL_STOP";
         }
      }
      
      string comment = "Grid_" + IntegerToString(i) + "_" + type_name;
      
      MqlTradeRequest request;
      MqlTradeResult result;
      ZeroMemory(request);
      ZeroMemory(result);
      
      request.action = TRADE_ACTION_PENDING;
      request.symbol = _Symbol;
      request.volume = lot_size;
      request.type = order_type;
      request.price = NormalizeDouble(new_price, _Digits);
      request.tp = NormalizeDouble(tp, _Digits);
      request.type_time = ORDER_TIME_GTC;
      request.type_filling = ORDER_FILLING_RETURN;
      request.deviation = m_slippage;
      request.magic = m_magic_number;
      request.comment = comment;
      
      if(OrderSend(request, result))
      {
         Print(">>> Replaced order at grid #", i, " Ticket=", result.order, " Price=", DoubleToString(new_price, _Digits));
      }
      else
      {
         Print(">>> Failed to replace order at grid #", i, " RetCode=", result.retcode);
      }
   }
   
   m_grid_lower_price = m_grid_cache[0].m_price;
   m_grid_upper_price = m_grid_cache[m_grid_cache_count - 1].m_price;
   
   Print(">>> Grid shifted down. New range=[", m_grid_lower_price, " ~ ", m_grid_upper_price, "]");
   
   return(true);
}

//+------------------------------------------------------------------+
//| Close position at specific grid index                              |
//+------------------------------------------------------------------+
bool CEvanGoldGrid::ClosePositionAtGrid(const int grid_index)
{
   string grid_tag = "Grid_" + IntegerToString(grid_index) + "_";
   
   for(int i = PositionsTotal() - 1; i >= 0; i--)
   {
      ulong ticket = PositionGetTicket(i);
      if(ticket == 0) continue;
      
      if(PositionSelectByTicket(ticket))
      {
         if(PositionGetInteger(POSITION_MAGIC) == m_magic_number && 
            PositionGetString(POSITION_SYMBOL) == _Symbol)
         {
            string comment = PositionGetString(POSITION_COMMENT);
            if(StringFind(comment, grid_tag) == 0)
            {
               if(m_trade.PositionClose(ticket))
               {
                  Print(">>> Closed position at grid #", grid_index, " Ticket=", ticket);
                  return(true);
               }
               else
               {
                  Print(">>> Failed to close position at grid #", grid_index, " RetCode=", m_trade.ResultRetcode());
               }
            }
         }
      }
   }
   return(false);
}

//+------------------------------------------------------------------+
//| Move grid order from one index to another                          |
//+------------------------------------------------------------------+
bool CEvanGoldGrid::MoveGridOrder(const int from_index, const int to_index)
{
   if(from_index < 0 || from_index >= m_grid_cache_count ||
      to_index < 0 || to_index >= m_grid_cache_count)
      return(false);
   
   double new_price = m_grid_cache[to_index].m_price;
   bool is_buy = m_grid_cache[from_index].m_is_buy_order;
   
   Print(">>> Moving order from grid #", from_index, " to #", to_index, " Price=", DoubleToString(new_price, _Digits));
   
   return(true);
}

//+------------------------------------------------------------------+
//| Start grid shift monitoring thread                                 |
//+------------------------------------------------------------------+
void CEvanGoldGrid::StartShiftThread(void)
{
   if(m_shift_thread_running)
      return;
   
   m_shift_thread_running = true;
   Print(">>> Grid shift monitoring started");
}

//+------------------------------------------------------------------+
//| Stop grid shift monitoring thread                                  |
//+------------------------------------------------------------------+
void CEvanGoldGrid::StopShiftThread(void)
{
   m_shift_thread_running = false;
   Print(">>> Grid shift monitoring stopped");
}

//+------------------------------------------------------------------+
//| Grid shift thread main loop                                        |
//+------------------------------------------------------------------+
void CEvanGoldGrid::ShiftThreadFunc(void)
{
   if(!m_shift_thread_running || !m_auto_shift_grid)
      return;
   
   if(!m_is_grid_cache_valid || m_grid_cache_count == 0)
      return;
   
   CheckAndShiftGrids();
}
//+------------------------------------------------------------------+
