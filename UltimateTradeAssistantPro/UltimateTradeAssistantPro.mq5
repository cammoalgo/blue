//+------------------------------------------------------------------+
//|                                   UltimateTradeAssistantPro.mq5 |
//|                                            Ultimate Trade Assistant Pro |
//|                                            https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Ultimate Trade Assistant Pro"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property description "Complete trading assistant with advanced risk management"
#property strict

//--- Include necessary libraries
#include <Trade\Trade.mqh>
#include <Trade\PositionInfo.mqh>
#include <Trade\AccountInfo.mqh>
#include <Trade\SymbolInfo.mqh>

//--- Include custom classes
#include "Include/UTAP_Panel.mqh"

//+------------------------------------------------------------------+
//| Input Parameters - Organized by Sections                         |
//+------------------------------------------------------------------+

//========== EXPERT SETTINGS ==========
input group "══════ EXPERT SETTINGS ══════"
input ulong inp_MagicNumber = 20241112;                 // Magic Number
input string inp_TradeComment = "UTAP";                 // Trade Comment

//========== PANEL DISPLAY ==========
input group "══════ PANEL DISPLAY ══════"
input bool inp_ShowPanel = true;                        // Show Main Panel
input ENUM_BASE_CORNER inp_PanelCorner = CORNER_LEFT_UPPER; // Panel Corner
input int inp_PanelX = 20;                              // Panel X Position
input int inp_PanelY = 50;                              // Panel Y Position
input int inp_PanelWidth = 450;                         // Panel Width
input color inp_PanelBgColor = C'30,30,30';            // Panel Background Color
input color inp_PanelTextColor = clrWhite;             // Panel Text Color
input color inp_PanelBorderColor = C'60,60,60';        // Panel Border Color
input int inp_FontSize = 9;                            // Font Size
input string inp_FontName = "Arial";                   // Font Name

//========== RISK MANAGEMENT ==========
input group "══════ RISK MANAGEMENT ══════"
input bool inp_UseRiskPercent = true;                  // Use Risk Percent
input double inp_RiskPercent = 2.0;                    // Risk Percent (0.1 - 10%)
input double inp_FixedLots = 0.10;                     // Fixed Lot Size
input double inp_FixedMoneyRisk = 200.0;               // Fixed Money Risk ($)
input bool inp_UseEquityNotBalance = true;             // Use Equity (not Balance)

//========== RISK PROTECTION ==========
input group "══════ RISK PROTECTION ══════"
input double inp_MaxDailyLossPercent = 5.0;            // Max Daily Loss (%)
input double inp_MaxDailyLossMoney = 0;                // Max Daily Loss ($, 0=disabled)
input double inp_DailyProfitTarget = 3.0;              // Daily Profit Target (%)
input bool inp_StopTradingAtProfit = false;            // Stop Trading At Profit Target

//========== ORDER ENTRY ==========
input group "══════ ORDER ENTRY ══════"
input int inp_Slippage = 30;                           // Maximum Slippage (points)
input bool inp_UsePreviewMode = true;                  // Enable Preview Mode
input bool inp_ConfirmBeforeEntry = true;              // Confirm Before Opening Trade
input int inp_DefaultSLPoints = 300;                   // Default SL (Points)
input int inp_DefaultTPPoints = 600;                   // Default TP (Points)
input bool inp_AccountForSpread = true;                // Account For Spread In SL/TP

//========== BREAKEVEN ==========
input group "══════ BREAKEVEN ══════"
input bool inp_AutoBreakeven = true;                   // Enable Auto Breakeven
input int inp_BreakevenTriggerPips = 20;              // Breakeven Trigger (Pips)
input int inp_BreakevenPlusPips = 5;                  // Breakeven Plus (Pips Buffer)

//========== TRAILING STOP ==========
input group "══════ TRAILING STOP ══════"
input bool inp_UseTrailing = true;                     // Enable Trailing Stop
input int inp_TrailPips = 20;                          // Trailing Stop (Pips)
input int inp_MinProfitToTrail = 10;                   // Minimum Profit To Start Trailing (Pips)

//========== PARTIAL CLOSE ==========
input group "══════ PARTIAL CLOSE ══════"
input bool inp_UseAutoPartials = false;                // Enable Auto Partial Close
input double inp_Partial1_Percent = 50.0;              // Partial 1: % To Close
input int inp_Partial1_Pips = 20;                      // Partial 1: Trigger (Pips)

//========== ALERTS ==========
input group "══════ ALERTS & NOTIFICATIONS ══════"
input bool inp_UsePopupAlerts = true;                  // Use Popup Alerts
input bool inp_UseSoundAlerts = true;                  // Use Sound Alerts
input bool inp_UsePushNotifications = false;           // Use Push to Phone

//+------------------------------------------------------------------+
//| Global Variables                                                  |
//+------------------------------------------------------------------+

// Trading objects
CTrade trade;
CPositionInfo positionInfo;
CAccountInfo accountInfo;
CSymbolInfo symbolInfo;

// Panel object
CMainPanel* mainPanel = NULL;

// Expert state
bool expertInitialized = false;
bool tradingEnabled = true;
string disableReason = "";

// Session tracking for daily limits
datetime sessionStartTime;
double sessionStartBalance;

//+------------------------------------------------------------------+
//| Expert initialization function                                    |
//+------------------------------------------------------------------+
int OnInit()
{
   Print("═══════════════════════════════════════════════════════");
   Print("  Ultimate Trade Assistant Pro v1.0");
   Print("  Initializing...");
   Print("═══════════════════════════════════════════════════════");

   // Set up trade object
   trade.SetExpertMagicNumber(inp_MagicNumber);
   trade.SetDeviationInPoints(inp_Slippage);
   trade.SetTypeFilling(ORDER_FILLING_FOK);
   trade.SetAsyncMode(false);

   // Initialize symbol info
   if(!symbolInfo.Name(_Symbol))
   {
      Print("ERROR: Failed to initialize symbol info");
      return INIT_FAILED;
   }

   // Initialize session tracking
   sessionStartTime = TimeCurrent();
   sessionStartBalance = accountInfo.Balance();

   // Create main panel
   if(inp_ShowPanel)
   {
      mainPanel = new CMainPanel();

      if(mainPanel == NULL)
      {
         Print("ERROR: Failed to create main panel object");
         return INIT_FAILED;
      }

      if(!mainPanel.Create(inp_PanelX, inp_PanelY, inp_PanelWidth, inp_PanelCorner))
      {
         Print("ERROR: Failed to create main panel");
         delete mainPanel;
         mainPanel = NULL;
         return INIT_FAILED;
      }

      Print("✓ Main panel created successfully");
   }

   // Set chart to foreground
   ChartSetInteger(0, CHART_FOREGROUND, false);
   ChartSetInteger(0, CHART_BRING_TO_TOP, true);

   expertInitialized = true;

   Print("═══════════════════════════════════════════════════════");
   Print("  ✓ Initialization Complete");
   Print("  Magic Number: ", inp_MagicNumber);
   Print("  Risk Mode: ", inp_UseRiskPercent ? "Risk Percent" : "Fixed Lots");
   Print("  Symbol: ", _Symbol);
   Print("  Account: ", accountInfo.Name());
   Print("  Balance: $", DoubleToString(accountInfo.Balance(), 2));
   Print("═══════════════════════════════════════════════════════");

   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                  |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   Print("═══════════════════════════════════════════════════════");
   Print("  Ultimate Trade Assistant Pro");
   Print("  Shutting down...");
   Print("  Reason: ", GetDeinitReasonText(reason));
   Print("═══════════════════════════════════════════════════════");

   // Delete panel and cleanup
   if(mainPanel != NULL)
   {
      mainPanel.Destroy();
      delete mainPanel;
      mainPanel = NULL;
   }

   // Remove all chart objects created by this EA
   ObjectsDeleteAll(0, "UTAP_");

   // Redraw chart
   ChartRedraw();

   Print("✓ Cleanup complete");

   expertInitialized = false;
}

//+------------------------------------------------------------------+
//| Expert tick function                                              |
//+------------------------------------------------------------------+
void OnTick()
{
   // Only process if initialized
   if(!expertInitialized)
      return;

   // Update panel on every tick (will be optimized later)
   if(mainPanel != NULL && inp_ShowPanel)
   {
      mainPanel.Update();
   }

   // Check daily reset
   CheckDailyReset();

   // TODO: Add trade management logic
   // - Check breakeven
   // - Check trailing
   // - Check partial closes
}

//+------------------------------------------------------------------+
//| Chart event handler                                               |
//+------------------------------------------------------------------+
void OnChartEvent(const int id, const long &lparam, const double &dparam, const string &sparam)
{
   // Only process if initialized
   if(!expertInitialized)
      return;

   // Pass events to panel
   if(mainPanel != NULL)
   {
      mainPanel.OnChartEvent(id, lparam, dparam, sparam);
   }
}

//+------------------------------------------------------------------+
//| Check for daily reset                                             |
//+------------------------------------------------------------------+
void CheckDailyReset()
{
   MqlDateTime currentTime, sessionTime;
   TimeToStruct(TimeCurrent(), currentTime);
   TimeToStruct(sessionStartTime, sessionTime);

   // Check if new day
   if(currentTime.day != sessionTime.day)
   {
      Print("═══════════════════════════════════════════════════════");
      Print("  Daily Reset Triggered");
      Print("  Previous session P&L: $", DoubleToString(accountInfo.Balance() - sessionStartBalance, 2));
      Print("═══════════════════════════════════════════════════════");

      // Reset session tracking
      sessionStartTime = TimeCurrent();
      sessionStartBalance = accountInfo.Balance();

      // Re-enable trading if disabled by daily limit
      if(!tradingEnabled && StringFind(disableReason, "Daily") >= 0)
      {
         tradingEnabled = true;
         disableReason = "";
         Print("✓ Trading re-enabled after daily reset");
      }
   }
}

//+------------------------------------------------------------------+
//| Get deinitialization reason text                                  |
//+------------------------------------------------------------------+
string GetDeinitReasonText(int reason)
{
   switch(reason)
   {
      case REASON_PROGRAM:     return "Program terminated";
      case REASON_REMOVE:      return "EA removed from chart";
      case REASON_RECOMPILE:   return "EA recompiled";
      case REASON_CHARTCHANGE: return "Chart symbol/period changed";
      case REASON_CHARTCLOSE:  return "Chart closed";
      case REASON_PARAMETERS:  return "Input parameters changed";
      case REASON_ACCOUNT:     return "Account changed";
      case REASON_TEMPLATE:    return "Template applied";
      case REASON_INITFAILED:  return "Initialization failed";
      case REASON_CLOSE:       return "Terminal closed";
      default:                 return "Unknown reason";
   }
}

//+------------------------------------------------------------------+
//| Get current daily P&L                                             |
//+------------------------------------------------------------------+
double GetDailyPL()
{
   double currentBalance = accountInfo.Balance();
   double floatingPL = accountInfo.Equity() - currentBalance;
   return (currentBalance - sessionStartBalance) + floatingPL;
}

//+------------------------------------------------------------------+
//| Get current daily P&L percentage                                  |
//+------------------------------------------------------------------+
double GetDailyPLPercent()
{
   if(sessionStartBalance == 0)
      return 0;

   return (GetDailyPL() / sessionStartBalance) * 100.0;
}

//+------------------------------------------------------------------+
//| Calculate total floating P&L                                      |
//+------------------------------------------------------------------+
double GetFloatingPL()
{
   return accountInfo.Equity() - accountInfo.Balance();
}

//+------------------------------------------------------------------+
//| Count open positions                                              |
//+------------------------------------------------------------------+
int CountOpenPositions()
{
   int count = 0;
   int total = PositionsTotal();

   for(int i = 0; i < total; i++)
   {
      if(positionInfo.SelectByIndex(i))
      {
         if(positionInfo.Magic() == inp_MagicNumber)
            count++;
      }
   }

   return count;
}

//+------------------------------------------------------------------+
