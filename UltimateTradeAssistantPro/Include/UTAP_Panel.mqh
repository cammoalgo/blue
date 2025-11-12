//+------------------------------------------------------------------+
//|                                                   UTAP_Panel.mqh |
//|                                   Ultimate Trade Assistant Pro   |
//|                                   Panel UI Management Class      |
//+------------------------------------------------------------------+
#property copyright "Ultimate Trade Assistant Pro"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

//--- Include necessary libraries
#include <Trade\AccountInfo.mqh>
#include <Trade\PositionInfo.mqh>

//+------------------------------------------------------------------+
//| Main Panel Class                                                  |
//+------------------------------------------------------------------+
class CMainPanel
{
private:
   // Panel properties
   int m_x;                    // X position
   int m_y;                    // Y position
   int m_width;                // Panel width
   int m_height;               // Panel height (calculated)
   ENUM_BASE_CORNER m_corner;  // Corner for positioning

   // Colors
   color m_bgColor;
   color m_textColor;
   color m_borderColor;
   color m_profitColor;
   color m_lossColor;

   // Panel state
   bool m_isDragging;
   int m_dragStartX;
   int m_dragStartY;
   bool m_isMinimized;

   // Object tracking
   int m_objectCount;
   string m_objectNames[];

   // Account info
   CAccountInfo accountInfo;
   CPositionInfo positionInfo;

   // Update throttling
   datetime m_lastUpdate;
   int m_updateIntervalMs;

public:
   // Constructor & Destructor
   CMainPanel();
   ~CMainPanel();

   // Initialization
   bool Create(int x, int y, int width, ENUM_BASE_CORNER corner);
   void Destroy();

   // Update functions
   void Update();
   void UpdateAccountInfo();
   void UpdatePositionInfo();
   void ForceRedraw();

   // Event handling
   void OnChartEvent(const int id, const long &lparam, const double &dparam, const string &sparam);

   // Panel state
   void Minimize();
   void Maximize();
   void ToggleMinimize();

private:
   // Object creation helpers
   bool CreateBackground();
   bool CreateHeader();
   bool CreateAccountSection();
   bool CreateRiskSection();
   bool CreateEntrySection();
   bool CreatePositionsSection();
   bool CreateControlsSection();

   // Drawing helpers
   bool CreateRectLabel(string name, int x, int y, int width, int height, color bgColor, color borderColor = clrNONE, int borderWidth = 0);
   bool CreateLabel(string name, int x, int y, string text, color textColor, int fontSize, string fontName = "Arial");
   bool CreateButton(string name, int x, int y, int width, int height, string text, color bgColor, color textColor);
   bool CreateEditBox(string name, int x, int y, int width, int height, string text);

   // Object management
   void AddObject(string name);
   void DeleteAllObjects();
   string GetObjectName(string suffix);

   // Utility functions
   void HandleDrag(const long &lparam, const double &dparam);
   void HandleButtonClick(const string &sparam);
   string FormatMoney(double value);
   string FormatPercent(double value);
   color GetPLColor(double value);

   // Position calculations
   int GetAbsoluteX(int relativeX);
   int GetAbsoluteY(int relativeY);
};

//+------------------------------------------------------------------+
//| Constructor                                                        |
//+------------------------------------------------------------------+
CMainPanel::CMainPanel()
{
   m_x = 0;
   m_y = 0;
   m_width = 450;
   m_height = 600;
   m_corner = CORNER_LEFT_UPPER;

   m_bgColor = C'30,30,30';
   m_textColor = clrWhite;
   m_borderColor = C'60,60,60';
   m_profitColor = clrLime;
   m_lossColor = clrRed;

   m_isDragging = false;
   m_dragStartX = 0;
   m_dragStartY = 0;
   m_isMinimized = false;

   m_objectCount = 0;
   ArrayResize(m_objectNames, 0);

   m_lastUpdate = 0;
   m_updateIntervalMs = 500; // Update every 500ms
}

//+------------------------------------------------------------------+
//| Destructor                                                         |
//+------------------------------------------------------------------+
CMainPanel::~CMainPanel()
{
   Destroy();
}

//+------------------------------------------------------------------+
//| Create panel                                                       |
//+------------------------------------------------------------------+
bool CMainPanel::Create(int x, int y, int width, ENUM_BASE_CORNER corner)
{
   m_x = x;
   m_y = y;
   m_width = width;
   m_corner = corner;

   // Get colors from inputs
   extern color inp_PanelBgColor;
   extern color inp_PanelTextColor;
   extern color inp_PanelBorderColor;

   m_bgColor = inp_PanelBgColor;
   m_textColor = inp_PanelTextColor;
   m_borderColor = inp_PanelBorderColor;

   Print("Creating panel at X:", x, " Y:", y, " Width:", width);

   // Create all panel elements
   if(!CreateBackground())
   {
      Print("ERROR: Failed to create background");
      return false;
   }

   if(!CreateHeader())
   {
      Print("ERROR: Failed to create header");
      return false;
   }

   if(!CreateAccountSection())
   {
      Print("ERROR: Failed to create account section");
      return false;
   }

   if(!CreateRiskSection())
   {
      Print("ERROR: Failed to create risk section");
      return false;
   }

   // Initial update
   Update();

   Print("✓ Panel created successfully with ", m_objectCount, " objects");

   return true;
}

//+------------------------------------------------------------------+
//| Destroy panel                                                      |
//+------------------------------------------------------------------+
void CMainPanel::Destroy()
{
   DeleteAllObjects();
   ArrayResize(m_objectNames, 0);
   m_objectCount = 0;
}

//+------------------------------------------------------------------+
//| Update panel (throttled)                                          |
//+------------------------------------------------------------------+
void CMainPanel::Update()
{
   // Throttle updates
   datetime currentTime = TimeCurrent();
   if(currentTime == m_lastUpdate)
      return;

   m_lastUpdate = currentTime;

   // Update sections
   UpdateAccountInfo();
   UpdatePositionInfo();
}

//+------------------------------------------------------------------+
//| Update account information display                                |
//+------------------------------------------------------------------+
void CMainPanel::UpdateAccountInfo()
{
   double balance = accountInfo.Balance();
   double equity = accountInfo.Equity();
   double freeMargin = accountInfo.FreeMargin();
   double marginLevel = accountInfo.MarginLevel();

   // Update balance label
   string balanceText = "Balance: " + FormatMoney(balance) + " | Equity: " + FormatMoney(equity);
   ObjectSetString(0, GetObjectName("AccBalance"), OBJPROP_TEXT, balanceText);

   // Update margin label
   string marginText = "Free Margin: " + FormatMoney(freeMargin) + " | Margin Level: " + DoubleToString(marginLevel, 0) + "%";
   ObjectSetString(0, GetObjectName("AccMargin"), OBJPROP_TEXT, marginText);

   // Calculate daily P&L
   extern double sessionStartBalance;
   double dailyPL = balance - sessionStartBalance + (equity - balance);
   double dailyPLPercent = (sessionStartBalance > 0) ? (dailyPL / sessionStartBalance) * 100.0 : 0;

   string plText = "Daily P&L: " + FormatMoney(dailyPL) + " (" + FormatPercent(dailyPLPercent) + ")";
   if(dailyPL > 0)
      plText += " 📈";
   else if(dailyPL < 0)
      plText += " 📉";

   ObjectSetString(0, GetObjectName("AccDailyPL"), OBJPROP_TEXT, plText);
   ObjectSetInteger(0, GetObjectName("AccDailyPL"), OBJPROP_COLOR, GetPLColor(dailyPL));
}

//+------------------------------------------------------------------+
//| Update position information display                               |
//+------------------------------------------------------------------+
void CMainPanel::UpdatePositionInfo()
{
   int posCount = 0;
   double floatingPL = 0;
   extern ulong inp_MagicNumber;

   // Count positions and calculate floating P&L
   int total = PositionsTotal();
   for(int i = 0; i < total; i++)
   {
      if(positionInfo.SelectByIndex(i))
      {
         if(positionInfo.Magic() == inp_MagicNumber)
         {
            posCount++;
            floatingPL += positionInfo.Profit() + positionInfo.Swap() + positionInfo.Commission();
         }
      }
   }

   string posText = "Open Trades: " + IntegerToString(posCount) + " | Floating: " + FormatMoney(floatingPL);
   ObjectSetString(0, GetObjectName("AccPositions"), OBJPROP_TEXT, posText);
   ObjectSetInteger(0, GetObjectName("AccPositions"), OBJPROP_COLOR, GetPLColor(floatingPL));
}

//+------------------------------------------------------------------+
//| Force redraw of panel                                             |
//+------------------------------------------------------------------+
void CMainPanel::ForceRedraw()
{
   ChartRedraw();
}

//+------------------------------------------------------------------+
//| Handle chart events                                               |
//+------------------------------------------------------------------+
void CMainPanel::OnChartEvent(const int id, const long &lparam, const double &dparam, const string &sparam)
{
   switch(id)
   {
      case CHARTEVENT_OBJECT_CLICK:
         HandleButtonClick(sparam);
         break;

      case CHARTEVENT_MOUSE_MOVE:
         if(m_isDragging)
            HandleDrag(lparam, dparam);
         break;

      case CHARTEVENT_CLICK:
         // Check if clicked on header to start dragging
         if(!m_isDragging)
         {
            int x = (int)lparam;
            int y = (int)dparam;

            // Simple check if clicked near top of panel
            int panelTop = m_y;
            int panelBottom = m_y + 30; // Header height
            int panelLeft = m_x;
            int panelRight = m_x + m_width;

            if(x >= panelLeft && x <= panelRight && y >= panelTop && y <= panelBottom)
            {
               m_isDragging = true;
               m_dragStartX = x - m_x;
               m_dragStartY = y - m_y;
            }
         }
         else
         {
            m_isDragging = false;
         }
         break;
   }
}

//+------------------------------------------------------------------+
//| Create background                                                  |
//+------------------------------------------------------------------+
bool CMainPanel::CreateBackground()
{
   string name = GetObjectName("Background");

   if(!CreateRectLabel(name, 0, 0, m_width, m_height, m_bgColor, m_borderColor, 2))
      return false;

   ObjectSetInteger(0, name, OBJPROP_BACK, false);
   ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
   ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);

   return true;
}

//+------------------------------------------------------------------+
//| Create header                                                      |
//+------------------------------------------------------------------+
bool CMainPanel::CreateHeader()
{
   int y = 5;

   // Title
   string titleName = GetObjectName("Title");
   if(!CreateLabel(titleName, 10, y, "⚡ ULTIMATE TRADE ASSISTANT PRO", clrGold, 11, "Arial Bold"))
      return false;

   y += 20;

   // Separator line
   string sepName = GetObjectName("HeaderSep");
   if(!CreateRectLabel(sepName, 5, y, m_width - 10, 2, m_borderColor))
      return false;

   return true;
}

//+------------------------------------------------------------------+
//| Create account section                                            |
//+------------------------------------------------------------------+
bool CMainPanel::CreateAccount Section()
{
   int y = 35;
   extern int inp_FontSize;
   extern string inp_FontName;

   // Section title
   string secTitle = GetObjectName("AccSectionTitle");
   if(!CreateLabel(secTitle, 10, y, "📊 ACCOUNT STATISTICS", clrWhite, inp_FontSize + 1, inp_FontName))
      return false;

   y += 20;

   // Balance & Equity
   string balName = GetObjectName("AccBalance");
   if(!CreateLabel(balName, 10, y, "Balance: $0.00 | Equity: $0.00", m_textColor, inp_FontSize, inp_FontName))
      return false;

   y += 18;

   // Free Margin & Margin Level
   string marName = GetObjectName("AccMargin");
   if(!CreateLabel(marName, 10, y, "Free Margin: $0.00 | Margin Level: 0%", m_textColor, inp_FontSize, inp_FontName))
      return false;

   y += 18;

   // Daily P&L
   string plName = GetObjectName("AccDailyPL");
   if(!CreateLabel(plName, 10, y, "Daily P&L: $0.00 (0.00%)", m_textColor, inp_FontSize, inp_FontName))
      return false;

   y += 18;

   // Open positions & floating P&L
   string posName = GetObjectName("AccPositions");
   if(!CreateLabel(posName, 10, y, "Open Trades: 0 | Floating: $0.00", m_textColor, inp_FontSize, inp_FontName))
      return false;

   y += 22;

   // Separator
   string sepName = GetObjectName("AccSep");
   if(!CreateRectLabel(sepName, 5, y, m_width - 10, 2, m_borderColor))
      return false;

   return true;
}

//+------------------------------------------------------------------+
//| Create risk section                                               |
//+------------------------------------------------------------------+
bool CMainPanel::CreateRiskSection()
{
   int y = 155;
   extern int inp_FontSize;
   extern string inp_FontName;

   // Section title
   string secTitle = GetObjectName("RiskSectionTitle");
   if(!CreateLabel(secTitle, 10, y, "💰 POSITION SIZING", clrWhite, inp_FontSize + 1, inp_FontName))
      return false;

   y += 20;

   // Risk mode display
   string riskMode = GetObjectName("RiskMode");
   extern bool inp_UseRiskPercent;
   extern double inp_RiskPercent;
   extern double inp_FixedLots;

   string modeText = inp_UseRiskPercent ?
                     "Mode: Risk " + DoubleToString(inp_RiskPercent, 1) + "% per trade" :
                     "Mode: Fixed " + DoubleToString(inp_FixedLots, 2) + " lots";

   if(!CreateLabel(riskMode, 10, y, modeText, m_textColor, inp_FontSize, inp_FontName))
      return false;

   y += 18;

   // Calculated lot size (will be updated dynamically)
   string lotSize = GetObjectName("CalcLotSize");
   if(!CreateLabel(lotSize, 10, y, "Calculated Lot Size: 0.00", clrYellow, inp_FontSize, inp_FontName))
      return false;

   y += 18;

   // Risk amount
   string riskAmt = GetObjectName("RiskAmount");
   if(!CreateLabel(riskAmt, 10, y, "Risk Amount: $0.00 | Point Value: $0.00", m_textColor, inp_FontSize, inp_FontName))
      return false;

   y += 22;

   // Separator
   string sepName = GetObjectName("RiskSep");
   if(!CreateRectLabel(sepName, 5, y, m_width - 10, 2, m_borderColor))
      return false;

   return true;
}

//+------------------------------------------------------------------+
//| Create entry section (placeholder for now)                        |
//+------------------------------------------------------------------+
bool CMainPanel::CreateEntrySection()
{
   // Will be implemented in next iteration
   return true;
}

//+------------------------------------------------------------------+
//| Create positions section (placeholder for now)                    |
//+------------------------------------------------------------------+
bool CMainPanel::CreatePositionsSection()
{
   // Will be implemented in next iteration
   return true;
}

//+------------------------------------------------------------------+
//| Create controls section (placeholder for now)                     |
//+------------------------------------------------------------------+
bool CMainPanel::CreateControlsSection()
{
   // Will be implemented in next iteration
   return true;
}

//+------------------------------------------------------------------+
//| Create rectangle label                                            |
//+------------------------------------------------------------------+
bool CMainPanel::CreateRectLabel(string name, int x, int y, int width, int height,
                                 color bgColor, color borderColor = clrNONE, int borderWidth = 0)
{
   if(ObjectCreate(0, name, OBJ_RECTANGLE_LABEL, 0, 0, 0))
   {
      ObjectSetInteger(0, name, OBJPROP_XDISTANCE, GetAbsoluteX(x));
      ObjectSetInteger(0, name, OBJPROP_YDISTANCE, GetAbsoluteY(y));
      ObjectSetInteger(0, name, OBJPROP_XSIZE, width);
      ObjectSetInteger(0, name, OBJPROP_YSIZE, height);
      ObjectSetInteger(0, name, OBJPROP_BGCOLOR, bgColor);
      ObjectSetInteger(0, name, OBJPROP_BORDER_TYPE, BORDER_FLAT);
      ObjectSetInteger(0, name, OBJPROP_CORNER, m_corner);
      ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);
      ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);

      if(borderColor != clrNONE && borderWidth > 0)
      {
         ObjectSetInteger(0, name, OBJPROP_BORDER_COLOR, borderColor);
         ObjectSetInteger(0, name, OBJPROP_WIDTH, borderWidth);
      }

      AddObject(name);
      return true;
   }

   Print("ERROR: Failed to create rectangle label: ", name);
   return false;
}

//+------------------------------------------------------------------+
//| Create label                                                       |
//+------------------------------------------------------------------+
bool CMainPanel::CreateLabel(string name, int x, int y, string text, color textColor,
                             int fontSize, string fontName = "Arial")
{
   if(ObjectCreate(0, name, OBJ_LABEL, 0, 0, 0))
   {
      ObjectSetInteger(0, name, OBJPROP_XDISTANCE, GetAbsoluteX(x));
      ObjectSetInteger(0, name, OBJPROP_YDISTANCE, GetAbsoluteY(y));
      ObjectSetInteger(0, name, OBJPROP_CORNER, m_corner);
      ObjectSetString(0, name, OBJPROP_TEXT, text);
      ObjectSetInteger(0, name, OBJPROP_COLOR, textColor);
      ObjectSetInteger(0, name, OBJPROP_FONTSIZE, fontSize);
      ObjectSetString(0, name, OBJPROP_FONT, fontName);
      ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);
      ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);

      AddObject(name);
      return true;
   }

   Print("ERROR: Failed to create label: ", name);
   return false;
}

//+------------------------------------------------------------------+
//| Create button                                                      |
//+------------------------------------------------------------------+
bool CMainPanel::CreateButton(string name, int x, int y, int width, int height,
                              string text, color bgColor, color textColor)
{
   if(ObjectCreate(0, name, OBJ_BUTTON, 0, 0, 0))
   {
      ObjectSetInteger(0, name, OBJPROP_XDISTANCE, GetAbsoluteX(x));
      ObjectSetInteger(0, name, OBJPROP_YDISTANCE, GetAbsoluteY(y));
      ObjectSetInteger(0, name, OBJPROP_XSIZE, width);
      ObjectSetInteger(0, name, OBJPROP_YSIZE, height);
      ObjectSetInteger(0, name, OBJPROP_CORNER, m_corner);
      ObjectSetString(0, name, OBJPROP_TEXT, text);
      ObjectSetInteger(0, name, OBJPROP_COLOR, textColor);
      ObjectSetInteger(0, name, OBJPROP_BGCOLOR, bgColor);
      ObjectSetInteger(0, name, OBJPROP_BORDER_COLOR, m_borderColor);
      ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);

      AddObject(name);
      return true;
   }

   Print("ERROR: Failed to create button: ", name);
   return false;
}

//+------------------------------------------------------------------+
//| Add object to tracking array                                      |
//+------------------------------------------------------------------+
void CMainPanel::AddObject(string name)
{
   ArrayResize(m_objectNames, m_objectCount + 1);
   m_objectNames[m_objectCount] = name;
   m_objectCount++;
}

//+------------------------------------------------------------------+
//| Delete all tracked objects                                        |
//+------------------------------------------------------------------+
void CMainPanel::DeleteAllObjects()
{
   for(int i = 0; i < m_objectCount; i++)
   {
      ObjectDelete(0, m_objectNames[i]);
   }
}

//+------------------------------------------------------------------+
//| Get object name with prefix                                       |
//+------------------------------------------------------------------+
string CMainPanel::GetObjectName(string suffix)
{
   return "UTAP_" + suffix;
}

//+------------------------------------------------------------------+
//| Handle dragging                                                    |
//+------------------------------------------------------------------+
void CMainPanel::HandleDrag(const long &lparam, const double &dparam)
{
   int x = (int)lparam;
   int y = (int)dparam;

   m_x = x - m_dragStartX;
   m_y = y - m_dragStartY;

   // Update all object positions
   for(int i = 0; i < m_objectCount; i++)
   {
      string name = m_objectNames[i];
      int objX = (int)ObjectGetInteger(0, name, OBJPROP_XDISTANCE);
      int objY = (int)ObjectGetInteger(0, name, OBJPROP_YDISTANCE);

      // This is simplified - in production would need to recalculate relative positions
   }

   ChartRedraw();
}

//+------------------------------------------------------------------+
//| Handle button clicks                                              |
//+------------------------------------------------------------------+
void CMainPanel::HandleButtonClick(const string &sparam)
{
   // Check if it's one of our buttons
   if(StringFind(sparam, "UTAP_") != 0)
      return;

   // Reset button state
   ObjectSetInteger(0, sparam, OBJPROP_STATE, false);

   Print("Button clicked: ", sparam);

   // TODO: Implement button handlers
}

//+------------------------------------------------------------------+
//| Format money value                                                |
//+------------------------------------------------------------------+
string CMainPanel::FormatMoney(double value)
{
   return "$" + DoubleToString(value, 2);
}

//+------------------------------------------------------------------+
//| Format percent value                                              |
//+------------------------------------------------------------------+
string CMainPanel::FormatPercent(double value)
{
   string sign = (value >= 0) ? "+" : "";
   return sign + DoubleToString(value, 2) + "%";
}

//+------------------------------------------------------------------+
//| Get color based on P&L                                            |
//+------------------------------------------------------------------+
color CMainPanel::GetPLColor(double value)
{
   if(value > 0)
      return m_profitColor;
   else if(value < 0)
      return m_lossColor;
   else
      return m_textColor;
}

//+------------------------------------------------------------------+
//| Get absolute X position                                           |
//+------------------------------------------------------------------+
int CMainPanel::GetAbsoluteX(int relativeX)
{
   return m_x + relativeX;
}

//+------------------------------------------------------------------+
//| Get absolute Y position                                           |
//+------------------------------------------------------------------+
int CMainPanel::GetAbsoluteY(int relativeY)
{
   return m_y + relativeY;
}

//+------------------------------------------------------------------+
//| Minimize panel                                                     |
//+------------------------------------------------------------------+
void CMainPanel::Minimize()
{
   m_isMinimized = true;
   // TODO: Implement minimize logic
}

//+------------------------------------------------------------------+
//| Maximize panel                                                     |
//+------------------------------------------------------------------+
void CMainPanel::Maximize()
{
   m_isMinimized = false;
   // TODO: Implement maximize logic
}

//+------------------------------------------------------------------+
//| Toggle minimize state                                             |
//+------------------------------------------------------------------+
void CMainPanel::ToggleMinimize()
{
   if(m_isMinimized)
      Maximize();
   else
      Minimize();
}

//+------------------------------------------------------------------+
