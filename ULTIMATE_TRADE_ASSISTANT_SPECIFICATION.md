# ULTIMATE TRADE ASSISTANT PRO - Complete Development Specification

## 📋 TABLE OF CONTENTS
1. [Project Overview](#project-overview)
2. [Technical Architecture](#technical-architecture)
3. [Complete Feature Specifications](#complete-feature-specifications)
4. [Module-by-Module Implementation Guide](#module-by-module-implementation-guide)
5. [Code Structure](#code-structure)
6. [Development Roadmap](#development-roadmap)
7. [Testing Requirements](#testing-requirements)
8. [Monetization Strategy](#monetization-strategy)

---

## 🎯 PROJECT OVERVIEW

### Product Information
- **Name**: Ultimate Trade Assistant Pro (UTAP)
- **Type**: MetaTrader 5 Expert Advisor (Utility Tool)
- **Purpose**: Complete manual trading assistant with advanced risk management
- **Target Users**: Forex/Gold/Indices manual traders, prop firm challenge traders
- **Platform**: MetaTrader 5 only
- **Language**: MQL5 (pure, no DLL dependencies)
- **License Type**: Commercial ($299 one-time payment)

### Core Value Proposition
"The ONLY trading tool you'll ever need - combining risk management, order execution, trade automation, statistics tracking, and prop firm tools in ONE powerful assistant."

### Key Differentiators
1. ✅ **All-in-One Solution**: Replaces 10+ separate tools
2. ✅ **Prop Firm Ready**: Built-in FTMO/MFF/Funded Next trackers
3. ✅ **Visual Trade Management**: Drag-and-drop SL/TP on charts
4. ✅ **Smart Automation**: Breakeven, trailing, partials all automated
5. ✅ **Risk-First Design**: Protection built into every feature
6. ✅ **Professional Grade**: No lag, enterprise-level code quality

---

## 🏗️ TECHNICAL ARCHITECTURE

### Platform Requirements
```
Platform: MetaTrader 5 (Build 3000+)
Language: MQL5
Account Types: Both Hedging and Netting
Symbols: All (Forex, Metals, Indices, Crypto, Stocks)
Timeframes: All (M1, M5, M15, M30, H1, H4, D1, W1, MN1)
Dependencies: None (no external DLLs)
Resources: All embedded (images, sounds, data)
```

### File Structure
```
UltimateTrade assistantPro/
├── UltimateTradeAssistantPro.mq5          # Main EA file
├── Include/
│   ├── UTAP_Panel.mqh                      # UI Panel management
│   ├── UTAP_RiskManager.mqh                # Risk calculation engine
│   ├── UTAP_OrderManager.mqh               # Order execution system
│   ├── UTAP_TradeManager.mqh               # Trade management (BE, Trail, Partials)
│   ├── UTAP_ChartTools.mqh                 # Chart drawing utilities
│   ├── UTAP_Statistics.mqh                 # Stats tracking and journal
│   ├── UTAP_NewsFilter.mqh                 # News calendar integration
│   ├── UTAP_GridSystem.mqh                 # Grid trading module
│   ├── UTAP_Telegram.mqh                   # Telegram integration
│   └── UTAP_PropFirm.mqh                   # Prop firm tracking
├── Resources/
│   ├── Images/
│   │   ├── logo.bmp                        # EA logo
│   │   └── icons/                          # Button icons
│   └── Sounds/
│       ├── trade_opened.wav
│       ├── trade_closed.wav
│       ├── alert_warning.wav
│       └── alert_success.wav
├── Presets/
│   ├── Conservative_Scalper.set
│   ├── Aggressive_Swing.set
│   ├── Gold_Trader.set
│   ├── FTMO_Challenge.set
│   └── Grid_EUR_Range.set
└── Documentation/
    ├── User_Manual.pdf
    ├── Quick_Start_Guide.pdf
    └── Video_Tutorials.txt
```

### Core Classes and Includes
```cpp
#include <Trade\Trade.mqh>              // Trade operations
#include <Trade\PositionInfo.mqh>       // Position information
#include <Trade\AccountInfo.mqh>        // Account information
#include <Trade\SymbolInfo.mqh>         // Symbol information
#include <Trade\OrderInfo.mqh>          // Order information
#include <Arrays\ArrayObj.mqh>          // Array of objects
#include <Object.mqh>                   // Base object class
#include <ChartObjects\ChartObject.mqh> // Chart objects

// Custom classes
CTrade trade;                           // Trade execution
CPositionInfo positionInfo;             // Position info
CAccountInfo accountInfo;               // Account info
CSymbolInfo symbolInfo;                 // Symbol info
```

### Memory Management
- All chart objects stored in arrays with proper cleanup
- Settings saved to files (not registry)
- Maximum panel objects: ~200 (optimized for performance)
- Tick processing: Optimized to avoid lag
- Event-driven architecture (not polling-based where possible)

---

## 📦 COMPLETE FEATURE SPECIFICATIONS

### MODULE 1: MAIN TRADING PANEL

#### 1.1 Panel UI Framework

**Visual Layout:**
```
┌─────────────────────────────────────────────────┐
│  ⚡ ULTIMATE TRADE ASSISTANT PRO  [-][↔][⚙][X] │
├─────────────────────────────────────────────────┤
│ 📊 ACCOUNT STATISTICS                           │
│ Balance: $10,000.00  │  Equity: $10,150.00     │
│ Free Margin: $9,500  │  Margin Level: 425%     │
│ Daily P&L: +$150 (1.5%) 📈  │  Weekly: +$420   │
│ Open Trades: 2  │  Total Risk: 4.0%            │
├─────────────────────────────────────────────────┤
│ 💰 POSITION SIZING                              │
│ ⦿ Risk % [2.0%]    ○ Fixed Lots [0.10]         │
│ ○ Fixed $ [$200]  ○ Multi-Account View         │
│ ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ │
│ Calculated Lot Size: 0.15                       │
│ Risk Amount: $200.00  │  Point Value: $1.00    │
├─────────────────────────────────────────────────┤
│ 🎯 ENTRY SETUP                                  │
│ SL Mode: ⦿ Points  ○ ATR  ○ Price  ○ Drag     │
│ SL: [30] pips  │  TP: [60] pips               │
│ R:R Ratio: 1:2.0 ✓  │  Spread: 2.1 pips       │
│ ☑ Preview Lines  │  ☑ Account for Spread      │
├─────────────────────────────────────────────────┤
│ 🚀 ORDER ENTRY                                  │
│  [🟢 BUY MARKET]      [🔴 SELL MARKET]         │
│  [BUY LIMIT]  [BUY STOP]  [SELL LIMIT]  [SELL STOP] │
│  [⚡ BUY STOP + SELL STOP (OCO)]               │
├─────────────────────────────────────────────────┤
│ 📋 ACTIVE POSITIONS (2)                         │
│ ┌─────────────────────────────────────────────┐ │
│ │ #12345 XAUUSD Buy 0.10                      │ │
│ │ Entry: 2650.50 │ SL: 2647.50 │ TP: 2656.50 │ │
│ │ Profit: +$45.20 (+60 pips) 📈 [BE✓] [T✓]   │ │
│ │ [Modify] [Close 25%] [Close 50%] [Close All]│ │
│ ├─────────────────────────────────────────────┤ │
│ │ #12346 EURUSD Sell 0.05                     │ │
│ │ Entry: 1.0850 │ SL: 1.0880 │ TP: 1.0820    │ │
│ │ Profit: -$12.50 (-25 pips) 📉              │ │
│ │ [Modify] [Close 25%] [Close 50%] [Close All]│ │
│ └─────────────────────────────────────────────┘ │
├─────────────────────────────────────────────────┤
│ ⚙️ TRADE MANAGEMENT                            │
│ Breakeven: ☑ Auto @[20] pips + [5] pips buffer│
│ Trailing: ☑ [ATR-Based ▼] [⚙ Settings]        │
│ Partials: ☑ [50%@1R] [25%@2R] [⚙ Settings]    │
├─────────────────────────────────────────────────┤
│ 🆘 EMERGENCY CONTROLS                          │
│ [🚨 CLOSE ALL] [💰 Close Profit] [📉 Close Loss] │
│ [Close XAUUSD] [Close Buys] [Close Sells]      │
├─────────────────────────────────────────────────┤
│ 📈 STATISTICS                                   │
│ Today: 5W - 2L (71%) │ Week: 23W - 8L (74%)   │
│ Avg Win: $85  │  Avg Loss: $42  │  PF: 1.85   │
│ [View Full Stats] [Export Journal]             │
└─────────────────────────────────────────────────┘
```

**Technical Implementation:**

```cpp
// Panel Properties
class CMainPanel
{
private:
    // Panel dimensions
    int m_panel_width;
    int m_panel_height;
    int m_panel_x;
    int m_panel_y;
    ENUM_BASE_CORNER m_corner;

    // Colors
    color m_bg_color;
    color m_text_color;
    color m_border_color;
    color m_button_normal;
    color m_button_hover;
    color m_button_pressed;

    // Panel sections
    bool m_section_account_visible;
    bool m_section_sizing_visible;
    bool m_section_entry_visible;
    bool m_section_positions_visible;
    bool m_section_management_visible;
    bool m_section_emergency_visible;
    bool m_section_stats_visible;

    // UI Objects array
    string m_object_names[];

public:
    // Constructor
    CMainPanel();
    ~CMainPanel();

    // Initialization
    bool Create();
    void Destroy();

    // Update functions
    void UpdateAccountInfo();
    void UpdatePositionSizing();
    void UpdateActivePositions();
    void UpdateStatistics();
    void UpdateAll();

    // Interaction handling
    void OnClick(string clicked_object);
    void OnDrag(int x, int y);
    void OnHover(string object);

    // Section management
    void ToggleSection(string section_name);
    void SaveState();
    void LoadState();

    // Styling
    void SetTheme(ENUM_THEME theme);
    void SetFontSize(int size);
};
```

**Input Parameters for Panel:**
```cpp
input group "══════ PANEL DISPLAY ══════"
input bool inp_ShowPanel = true;                        // Show Main Panel
input ENUM_BASE_CORNER inp_PanelCorner = CORNER_LEFT_UPPER; // Panel Corner
input int inp_PanelX = 20;                              // Panel X Position
input int inp_PanelY = 50;                              // Panel Y Position
input int inp_PanelWidth = 450;                         // Panel Width
input ENUM_THEME inp_Theme = THEME_DARK;                // Color Theme
input ENUM_FONT_SIZE inp_FontSize = FONT_MEDIUM;        // Font Size
input bool inp_ShowAccountSection = true;               // Show Account Section
input bool inp_ShowSizingSection = true;                // Show Position Sizing
input bool inp_ShowEntrySection = true;                 // Show Entry Setup
input bool inp_ShowPositionsSection = true;             // Show Active Positions
input bool inp_ShowManagementSection = true;            // Show Trade Management
input bool inp_ShowEmergencySection = true;             // Show Emergency Controls
input bool inp_ShowStatsSection = true;                 // Show Statistics
input string inp_HideShowHotkey = "H";                  // Hide/Show Hotkey (Ctrl+)
```

**Color Themes:**
```cpp
enum ENUM_THEME
{
    THEME_DARK,      // Dark (Professional Black)
    THEME_LIGHT,     // Light (Clean White)
    THEME_BLUE,      // Blue (Ocean Blue)
    THEME_GREEN,     // Green (Money Green)
    THEME_CUSTOM     // Custom (User-defined colors)
};

// Theme definitions
struct ThemeColors
{
    color background;
    color text;
    color border;
    color button_normal;
    color button_hover;
    color button_pressed;
    color profit;
    color loss;
    color warning;
    color success;
};

ThemeColors GetThemeColors(ENUM_THEME theme)
{
    ThemeColors colors;
    switch(theme)
    {
        case THEME_DARK:
            colors.background = C'30,30,30';
            colors.text = clrWhite;
            colors.border = C'60,60,60';
            colors.button_normal = C'50,50,50';
            colors.button_hover = C'70,70,70';
            colors.button_pressed = C'90,90,90';
            colors.profit = clrLime;
            colors.loss = clrRed;
            colors.warning = clrOrange;
            colors.success = clrGreen;
            break;
        // Add other themes...
    }
    return colors;
}
```

---

### MODULE 2: RISK MANAGEMENT ENGINE

#### 2.1 Position Size Calculator

**Core Calculation Logic:**

```cpp
class CRiskManager
{
private:
    // Account info
    double m_account_balance;
    double m_account_equity;
    double m_account_free_margin;

    // Risk settings
    ENUM_RISK_MODE m_risk_mode;
    double m_risk_percent;
    double m_fixed_lots;
    double m_fixed_money_risk;

    // Symbol info
    double m_point_value;
    double m_tick_value;
    double m_tick_size;
    double m_lot_step;
    double m_min_lot;
    double m_max_lot;

public:
    // Main calculation function
    double CalculateLotSize(double entry_price, double stop_loss_price);

    // Helper functions
    double GetPointValue();
    double GetPipValue(double lots);
    double NormalizeLots(double lots);
    bool ValidateLotSize(double lots);

    // Risk exposure
    double GetCurrentRiskPercent();
    double GetCurrentRiskMoney();
    int GetMaxPossibleTrades();

    // Multi-account preview
    void CalculateMultiAccountView(double sl_distance);
};

enum ENUM_RISK_MODE
{
    RISK_PERCENT,       // Risk percentage of equity
    RISK_FIXED_LOTS,    // Fixed lot size
    RISK_FIXED_MONEY,   // Fixed money amount
    RISK_MULTI_ACCOUNT  // Multi-account preview
};
```

**Implementation:**

```cpp
double CRiskManager::CalculateLotSize(double entry_price, double stop_loss_price)
{
    double lot_size = 0.0;
    double sl_distance = MathAbs(entry_price - stop_loss_price);
    double sl_points = sl_distance / _Point;

    // Update account info
    m_account_balance = AccountInfoDouble(ACCOUNT_BALANCE);
    m_account_equity = AccountInfoDouble(ACCOUNT_EQUITY);

    // Calculate based on risk mode
    switch(m_risk_mode)
    {
        case RISK_PERCENT:
        {
            double risk_amount = m_account_equity * (m_risk_percent / 100.0);
            m_point_value = GetPointValue();
            if(m_point_value > 0)
                lot_size = risk_amount / (sl_points * m_point_value);
            break;
        }

        case RISK_FIXED_LOTS:
        {
            lot_size = m_fixed_lots;
            break;
        }

        case RISK_FIXED_MONEY:
        {
            m_point_value = GetPointValue();
            if(m_point_value > 0)
                lot_size = m_fixed_money_risk / (sl_points * m_point_value);
            break;
        }
    }

    // Normalize to broker requirements
    lot_size = NormalizeLots(lot_size);

    // Validate
    if(!ValidateLotSize(lot_size))
    {
        Print("ERROR: Invalid lot size calculated: ", lot_size);
        return 0.0;
    }

    return lot_size;
}

double CRiskManager::GetPointValue()
{
    double tick_value = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_VALUE);
    double tick_size = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE);
    double point = SymbolInfoDouble(_Symbol, SYMBOL_POINT);

    double point_value = (tick_value / tick_size) * point;
    return point_value;
}

double CRiskManager::NormalizeLots(double lots)
{
    double lot_step = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP);
    double min_lot = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);
    double max_lot = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MAX);

    // Round to lot step
    lots = MathFloor(lots / lot_step) * lot_step;

    // Clamp to min/max
    lots = MathMax(lots, min_lot);
    lots = MathMin(lots, max_lot);

    return NormalizeDouble(lots, 2);
}

bool CRiskManager::ValidateLotSize(double lots)
{
    double min_lot = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);
    double max_lot = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MAX);

    if(lots < min_lot)
    {
        Print("Lot size ", lots, " below minimum ", min_lot);
        return false;
    }

    if(lots > max_lot)
    {
        Print("Lot size ", lots, " above maximum ", max_lot);
        return false;
    }

    // Check free margin
    double required_margin = 0;
    if(!OrderCalcMargin(ORDER_TYPE_BUY, _Symbol, lots, SymbolInfoDouble(_Symbol, SYMBOL_ASK), required_margin))
    {
        Print("Failed to calculate required margin");
        return false;
    }

    if(required_margin > m_account_free_margin)
    {
        Print("Insufficient margin. Required: ", required_margin, " Available: ", m_account_free_margin);
        return false;
    }

    return true;
}
```

**Input Parameters:**

```cpp
input group "══════ RISK MANAGEMENT ══════"
input ENUM_RISK_MODE inp_RiskMode = RISK_PERCENT;       // Risk Mode
input double inp_RiskPercent = 2.0;                     // Risk Percent (0.1 - 10%)
input double inp_FixedLots = 0.10;                      // Fixed Lot Size
input double inp_FixedMoneyRisk = 200.0;                // Fixed Money Risk ($)
input bool inp_UseEquityNotBalance = true;              // Use Equity (not Balance)
input bool inp_ShowMultiAccountView = false;            // Show Multi-Account Preview
input string inp_MultiAccountSizes = "1000,5000,10000,50000,100000"; // Account Sizes for Preview
```

#### 2.2 Dynamic Risk Protection

**Daily/Weekly/Monthly Loss Limits:**

```cpp
class CRiskProtection
{
private:
    // Loss limits
    double m_max_daily_loss_percent;
    double m_max_daily_loss_money;
    double m_max_weekly_loss_percent;
    double m_max_monthly_loss_percent;

    // Profit targets
    double m_daily_profit_target_percent;
    double m_weekly_profit_target_percent;
    bool m_stop_trading_at_profit;
    bool m_close_trades_at_profit;

    // Current session tracking
    double m_daily_starting_balance;
    double m_weekly_starting_balance;
    double m_monthly_starting_balance;
    datetime m_last_daily_reset;
    datetime m_last_weekly_reset;
    datetime m_last_monthly_reset;

    // Protection states
    bool m_trading_disabled;
    string m_disable_reason;

public:
    // Initialization
    void Initialize();
    void ResetDaily();
    void ResetWeekly();
    void ResetMonthly();

    // Checking functions
    bool CheckDailyLossLimit();
    bool CheckWeeklyLossLimit();
    bool CheckMonthlyLossLimit();
    bool CheckDailyProfitTarget();
    bool IsTradingAllowed();

    // Current status
    double GetDailyPL();
    double GetWeeklyPL();
    double GetMonthlyPL();
    double GetDailyPLPercent();

    // Actions
    void DisableTrading(string reason);
    void EnableTrading();
    void CloseAllTrades();
};

void CRiskProtection::Initialize()
{
    m_daily_starting_balance = AccountInfoDouble(ACCOUNT_BALANCE);
    m_weekly_starting_balance = m_daily_starting_balance;
    m_monthly_starting_balance = m_daily_starting_balance;

    m_last_daily_reset = TimeCurrent();
    m_last_weekly_reset = TimeCurrent();
    m_last_monthly_reset = TimeCurrent();

    m_trading_disabled = false;
}

bool CRiskProtection::CheckDailyLossLimit()
{
    double current_pl = GetDailyPL();
    double current_pl_percent = GetDailyPLPercent();

    // Check percent limit
    if(m_max_daily_loss_percent > 0 && current_pl_percent <= -m_max_daily_loss_percent)
    {
        Print("🚨 DAILY LOSS LIMIT REACHED: ", current_pl_percent, "%");
        DisableTrading("Daily loss limit reached");
        CloseAllTrades();
        SendNotification("Daily loss limit reached: " + DoubleToString(current_pl_percent, 2) + "%");
        return false;
    }

    // Check money limit
    if(m_max_daily_loss_money > 0 && current_pl <= -m_max_daily_loss_money)
    {
        Print("🚨 DAILY LOSS LIMIT REACHED: $", current_pl);
        DisableTrading("Daily loss limit reached");
        CloseAllTrades();
        SendNotification("Daily loss limit reached: $" + DoubleToString(current_pl, 2));
        return false;
    }

    // Warning at 80% of limit
    if(m_max_daily_loss_percent > 0 && current_pl_percent <= -(m_max_daily_loss_percent * 0.8))
    {
        Print("⚠️ WARNING: At 80% of daily loss limit");
        SendNotification("WARNING: Approaching daily loss limit");
    }

    return true;
}

bool CRiskProtection::CheckDailyProfitTarget()
{
    double current_pl_percent = GetDailyPLPercent();

    if(m_daily_profit_target_percent > 0 && current_pl_percent >= m_daily_profit_target_percent)
    {
        Print("✅ DAILY PROFIT TARGET REACHED: ", current_pl_percent, "%");
        SendNotification("Daily profit target reached: " + DoubleToString(current_pl_percent, 2) + "%");

        if(m_stop_trading_at_profit)
        {
            DisableTrading("Daily profit target reached");
        }

        if(m_close_trades_at_profit)
        {
            CloseAllTrades();
        }

        return true;
    }

    return false;
}

double CRiskProtection::GetDailyPL()
{
    return AccountInfoDouble(ACCOUNT_BALANCE) - m_daily_starting_balance + GetFloatingPL();
}

double CRiskProtection::GetDailyPLPercent()
{
    return (GetDailyPL() / m_daily_starting_balance) * 100.0;
}

void CRiskProtection::ResetDaily()
{
    MqlDateTime current_time;
    TimeToStruct(TimeCurrent(), current_time);

    MqlDateTime last_reset;
    TimeToStruct(m_last_daily_reset, last_reset);

    // Check if new day
    if(current_time.day != last_reset.day)
    {
        Print("📅 Daily reset triggered");
        m_daily_starting_balance = AccountInfoDouble(ACCOUNT_BALANCE);
        m_last_daily_reset = TimeCurrent();

        // Re-enable trading if disabled by daily limit
        if(m_trading_disabled && StringFind(m_disable_reason, "Daily") >= 0)
        {
            EnableTrading();
        }
    }
}
```

**Input Parameters:**

```cpp
input group "══════ RISK PROTECTION ══════"
input double inp_MaxDailyLossPercent = 5.0;             // Max Daily Loss (%)
input double inp_MaxDailyLossMoney = 0;                 // Max Daily Loss ($, 0=disabled)
input double inp_MaxWeeklyLossPercent = 10.0;           // Max Weekly Loss (%)
input double inp_MaxMonthlyLossPercent = 15.0;          // Max Monthly Loss (%)
input double inp_DailyProfitTarget = 3.0;               // Daily Profit Target (%)
input bool inp_StopTradingAtProfit = false;             // Stop Trading At Profit Target
input bool inp_CloseTrades AtProfit = false;             // Close All Trades At Profit Target
input double inp_MaxRiskExposurePercent = 10.0;         // Max Total Risk Exposure (%)
input bool inp_ReduceRiskInDrawdown = true;             // Reduce Risk When In Drawdown
input double inp_DrawdownThreshold = 5.0;               // Drawdown Threshold To Reduce Risk (%)
input double inp_RiskReductionFactor = 0.5;             // Risk Reduction Factor (0.5 = 50%)
```

#### 2.3 Risk-Reward Calculator

```cpp
class CRiskRewardCalculator
{
private:
    double m_entry_price;
    double m_stop_loss;
    double m_take_profit;

public:
    // Calculate R:R ratio
    double CalculateRR(double entry, double sl, double tp);

    // Calculate TP for desired R:R
    double CalculateTPFromRR(double entry, double sl, double rr_ratio);

    // Display R:R levels on chart
    void DrawRRLevels(double entry, double sl);

    // Validate minimum R:R
    bool ValidateMinimumRR(double entry, double sl, double tp, double min_rr);
};

double CRiskRewardCalculator::CalculateRR(double entry, double sl, double tp)
{
    double risk_distance = MathAbs(entry - sl);
    double reward_distance = MathAbs(tp - entry);

    if(risk_distance == 0) return 0;

    double rr = reward_distance / risk_distance;
    return NormalizeDouble(rr, 2);
}

double CRiskRewardCalculator::CalculateTPFromRR(double entry, double sl, double rr_ratio)
{
    double risk_distance = MathAbs(entry - sl);
    double reward_distance = risk_distance * rr_ratio;

    bool is_buy = (entry > sl);

    double tp;
    if(is_buy)
        tp = entry + reward_distance;
    else
        tp = entry - reward_distance;

    return NormalizeDouble(tp, _Digits);
}

void CRiskRewardCalculator::DrawRRLevels(double entry, double sl)
{
    bool is_buy = (entry > sl);
    double risk = MathAbs(entry - sl);

    // Clear previous lines
    ObjectsDeleteAll(0, "UTAP_RR_");

    // Draw Entry line
    DrawHLine("UTAP_RR_ENTRY", entry, clrYellow, STYLE_SOLID, 2, "Entry");

    // Draw SL line
    DrawHLine("UTAP_RR_SL", sl, clrRed, STYLE_SOLID, 2, "Stop Loss (1R)");

    // Draw TP levels (1R, 1.5R, 2R, 2.5R, 3R)
    double rr_levels[] = {1.0, 1.5, 2.0, 2.5, 3.0};
    color rr_colors[] = {clrLimeGreen, clrGreen, clrDarkGreen, clrTeal, clrBlue};

    for(int i = 0; i < ArraySize(rr_levels); i++)
    {
        double tp = CalculateTPFromRR(entry, sl, rr_levels[i]);
        string label = "TP " + DoubleToString(rr_levels[i], 1) + "R";
        DrawHLine("UTAP_RR_TP" + IntegerToString(i), tp, rr_colors[i], STYLE_DOT, 1, label);
    }
}

void DrawHLine(string name, double price, color clr, ENUM_LINE_STYLE style, int width, string text)
{
    ObjectCreate(0, name, OBJ_HLINE, 0, 0, price);
    ObjectSetInteger(0, name, OBJPROP_COLOR, clr);
    ObjectSetInteger(0, name, OBJPROP_STYLE, style);
    ObjectSetInteger(0, name, OBJPROP_WIDTH, width);
    ObjectSetString(0, name, OBJPROP_TEXT, text);
    ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
    ObjectSetInteger(0, name, OBJPROP_BACK, false);
}
```

---

### MODULE 3: ORDER MANAGEMENT SYSTEM

#### 3.1 Quick Order Entry

```cpp
class COrderManager
{
private:
    CTrade m_trade;
    CPositionInfo m_position;
    CRiskManager* m_risk_manager;

    // Preview mode
    bool m_preview_mode;
    double m_preview_entry;
    double m_preview_sl;
    double m_preview_tp;

public:
    // Market orders
    bool OpenBuyMarket(double lots, double sl, double tp, string comment = "");
    bool OpenSellMarket(double lots, double sl, double tp, string comment = "");

    // Pending orders
    bool PlaceBuyLimit(double price, double lots, double sl, double tp);
    bool PlaceBuyStop(double price, double lots, double sl, double tp);
    bool PlaceSellLimit(double price, double lots, double sl, double tp);
    bool PlaceSellStop(double price, double lots, double sl, double tp);

    // OCO orders
    bool PlaceOCO(double buy_stop_price, double sell_stop_price, double lots, double sl_pips, double tp_pips);

    // Preview system
    void EnablePreview();
    void DisablePreview();
    void ShowPreview Lines(ENUM_ORDER_TYPE type, double entry, double sl, double tp, double lots);
    bool ConfirmPreview();

    // Modification
    bool ModifyPosition(ulong ticket, double new_sl, double new_tp);
    bool ModifyAllPositions(double new_sl_pips, double new_tp_pips);

    // Closing
    bool ClosePosition(ulong ticket, double lots = 0); // 0 = close all
    bool CloseAllPositions();
    bool CloseAllProfitable();
    bool CloseAllLosing();
    bool CloseBySymbol(string symbol);
    bool CloseByDirection(ENUM_ORDER_TYPE type);
};

bool COrderManager::OpenBuyMarket(double lots, double sl, double tp, string comment = "")
{
    // Validate inputs
    if(lots <= 0)
    {
        Print("ERROR: Invalid lot size");
        return false;
    }

    // Get current prices
    double ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
    double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);

    // Normalize SL/TP
    if(sl > 0) sl = NormalizeDouble(sl, _Digits);
    if(tp > 0) tp = NormalizeDouble(tp, _Digits);

    // Set magic number and comment
    m_trade.SetExpertMagicNumber(EXPERT_MAGIC);
    if(comment == "") comment = "UTAP Buy";

    // Execute order
    bool result = m_trade.Buy(lots, _Symbol, ask, sl, tp, comment);

    if(result)
    {
        Print("✅ BUY order opened: Ticket=", m_trade.ResultOrder(), " Lots=", lots, " Price=", ask);

        // Send notification
        SendAlert("Trade Opened", "BUY " + _Symbol + " " + DoubleToString(lots, 2) + " lots @ " + DoubleToString(ask, _Digits));

        // Play sound
        if(inp_UseSoundAlerts)
            PlaySound("trade_opened.wav");

        return true;
    }
    else
    {
        Print("❌ Failed to open BUY order: ", GetLastError());
        return false;
    }
}

bool COrderManager::PlaceOCO(double buy_stop_price, double sell_stop_price, double lots, double sl_pips, double tp_pips)
{
    // Calculate SL/TP for buy stop
    double buy_sl = buy_stop_price - (sl_pips * _Point * 10);
    double buy_tp = buy_stop_price + (tp_pips * _Point * 10);

    // Calculate SL/TP for sell stop
    double sell_sl = sell_stop_price + (sl_pips * _Point * 10);
    double sell_tp = sell_stop_price - (tp_pips * _Point * 10);

    // Place both orders
    bool buy_placed = PlaceBuyStop(buy_stop_price, lots, buy_sl, buy_tp);
    bool sell_placed = PlaceSellStop(sell_stop_price, lots, sell_sl, sell_tp);

    if(buy_placed && sell_placed)
    {
        Print("✅ OCO orders placed successfully");
        return true;
    }
    else
    {
        Print("❌ Failed to place OCO orders");
        // Clean up if only one succeeded
        if(buy_placed || sell_placed)
        {
            // Delete the successful one
            // Implementation: find and delete pending orders
        }
        return false;
    }
}

void COrderManager::ShowPreviewLines(ENUM_ORDER_TYPE type, double entry, double sl, double tp, double lots)
{
    // Delete previous preview
    ObjectsDeleteAll(0, "UTAP_PREVIEW_");

    // Determine color based on order type
    color entry_color = (type == ORDER_TYPE_BUY || type == ORDER_TYPE_BUY_LIMIT || type == ORDER_TYPE_BUY_STOP) ? clrBlue : clrRed;

    // Draw entry line
    ObjectCreate(0, "UTAP_PREVIEW_ENTRY", OBJ_HLINE, 0, 0, entry);
    ObjectSetInteger(0, "UTAP_PREVIEW_ENTRY", OBJPROP_COLOR, entry_color);
    ObjectSetInteger(0, "UTAP_PREVIEW_ENTRY", OBJPROP_STYLE, STYLE_DASH);
    ObjectSetInteger(0, "UTAP_PREVIEW_ENTRY", OBJPROP_WIDTH, 2);
    ObjectSetString(0, "UTAP_PREVIEW_ENTRY", OBJPROP_TEXT, "Entry: " + DoubleToString(entry, _Digits));
    ObjectSetInteger(0, "UTAP_PREVIEW_ENTRY", OBJPROP_SELECTABLE, true);

    // Draw SL line
    ObjectCreate(0, "UTAP_PREVIEW_SL", OBJ_HLINE, 0, 0, sl);
    ObjectSetInteger(0, "UTAP_PREVIEW_SL", OBJPROP_COLOR, clrRed);
    ObjectSetInteger(0, "UTAP_PREVIEW_SL", OBJPROP_STYLE, STYLE_DASH);
    ObjectSetInteger(0, "UTAP_PREVIEW_SL", OBJPROP_WIDTH, 2);
    ObjectSetString(0, "UTAP_PREVIEW_SL", OBJPROP_TEXT, "Stop Loss: " + DoubleToString(sl, _Digits));
    ObjectSetInteger(0, "UTAP_PREVIEW_SL", OBJPROP_SELECTABLE, true);

    // Draw TP line
    ObjectCreate(0, "UTAP_PREVIEW_TP", OBJ_HLINE, 0, 0, tp);
    ObjectSetInteger(0, "UTAP_PREVIEW_TP", OBJPROP_COLOR, clrGreen);
    ObjectSetInteger(0, "UTAP_PREVIEW_TP", OBJPROP_STYLE, STYLE_DASH);
    ObjectSetInteger(0, "UTAP_PREVIEW_TP", OBJPROP_WIDTH, 2);
    ObjectSetString(0, "UTAP_PREVIEW_TP", OBJPROP_TEXT, "Take Profit: " + DoubleToString(tp, _Digits));
    ObjectSetInteger(0, "UTAP_PREVIEW_TP", OBJPROP_SELECTABLE, true);

    // Calculate and display info
    double risk_pips = MathAbs(entry - sl) / (_Point * 10);
    double reward_pips = MathAbs(tp - entry) / (_Point * 10);
    double rr_ratio = reward_pips / risk_pips;

    // Draw info label
    string info = StringFormat("Lots: %.2f | Risk: %.1f pips | Reward: %.1f pips | R:R: 1:%.1f",
                               lots, risk_pips, reward_pips, rr_ratio);

    ObjectCreate(0, "UTAP_PREVIEW_INFO", OBJ_LABEL, 0, 0, 0);
    ObjectSetInteger(0, "UTAP_PREVIEW_INFO", OBJPROP_CORNER, CORNER_LEFT_UPPER);
    ObjectSetInteger(0, "UTAP_PREVIEW_INFO", OBJPROP_XDISTANCE, 10);
    ObjectSetInteger(0, "UTAP_PREVIEW_INFO", OBJPROP_YDISTANCE, 30);
    ObjectSetString(0, "UTAP_PREVIEW_INFO", OBJPROP_TEXT, info);
    ObjectSetInteger(0, "UTAP_PREVIEW_INFO", OBJPROP_COLOR, clrYellow);
    ObjectSetInteger(0, "UTAP_PREVIEW_INFO", OBJPROP_FONTSIZE, 10);

    m_preview_mode = true;
    m_preview_entry = entry;
    m_preview_sl = sl;
    m_preview_tp = tp;
}
```

**Input Parameters:**

```cpp
input group "══════ ORDER ENTRY ══════"
input int inp_Slippage = 30;                            // Maximum Slippage (points)
input bool inp_UsePreviewMode = true;                   // Enable Preview Mode
input bool inp_ConfirmBeforeEntry = true;               // Confirm Before Opening Trade
input bool inp_OneClickTrading = false;                 // One-Click Trading (No Confirmation)
input ENUM_SL_TP_MODE inp_SLTPMode = SLTP_POINTS;       // SL/TP Mode
input int inp_DefaultSLPoints = 300;                    // Default SL (Points)
input int inp_DefaultTPPoints = 600;                    // Default TP (Points)
input double inp_DefaultSLATR = 1.5;                    // Default SL (ATR Multiple)
input double inp_DefaultTPATR = 3.0;                    // Default TP (ATR Multiple)
input int inp_ATRPeriod = 14;                           // ATR Period
input bool inp_AccountForSpread = true;                 // Account For Spread In SL/TP
input int inp_MinimumRRRatio = 15;                      // Minimum R:R Ratio (1.0 = 1:1, 1.5 = 1:1.5, etc.)

enum ENUM_SL_TP_MODE
{
    SLTP_POINTS,        // Points/Pips
    SLTP_ATR,           // ATR-based
    SLTP_PRICE,         // Exact Price
    SLTP_DRAG           // Drag on chart
};
```

---

### MODULE 4: TRADE MANAGEMENT AUTOMATION

#### 4.1 Breakeven System

```cpp
class CBreakevenManager
{
private:
    bool m_auto_breakeven;
    int m_trigger_pips;
    int m_plus_pips;
    bool m_only_on_profit;

    // Track which positions have been moved to BE
    ulong m_breakeven_tickets[];

public:
    void Initialize();
    void CheckAllPositions();
    bool MoveToBreakeven(ulong ticket, bool manual = false);
    bool IsAtBreakeven(ulong ticket);
    void AddToBreakevenList(ulong ticket);
};

void CBreakevenManager::CheckAllPositions()
{
    if(!m_auto_breakeven) return;

    int total = PositionsTotal();
    for(int i = 0; i < total; i++)
    {
        ulong ticket = PositionGetTicket(i);
        if(ticket <= 0) continue;

        if(PositionSelectByTicket(ticket))
        {
            // Skip if already at breakeven
            if(IsAtBreakeven(ticket)) continue;

            // Check only positions for this symbol (optional)
            if(PositionGetString(POSITION_SYMBOL) != _Symbol) continue;

            // Check magic number
            if(PositionGetInteger(POSITION_MAGIC) != EXPERT_MAGIC) continue;

            // Get position details
            double entry_price = PositionGetDouble(POSITION_PRICE_OPEN);
            double current_price = PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY ?
                                   SymbolInfoDouble(_Symbol, SYMBOL_BID) :
                                   SymbolInfoDouble(_Symbol, SYMBOL_ASK);
            double current_sl = PositionGetDouble(POSITION_SL);

            // Calculate profit in pips
            double profit_pips;
            if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY)
                profit_pips = (current_price - entry_price) / (_Point * 10);
            else
                profit_pips = (entry_price - current_price) / (_Point * 10);

            // Check if trigger reached
            if(profit_pips >= m_trigger_pips)
            {
                MoveToBreakeven(ticket);
            }
        }
    }
}

bool CBreakevenManager::MoveToBreakeven(ulong ticket, bool manual = false)
{
    if(!PositionSelectByTicket(ticket))
    {
        Print("ERROR: Position not found: ", ticket);
        return false;
    }

    double entry_price = PositionGetDouble(POSITION_PRICE_OPEN);
    double current_tp = PositionGetDouble(POSITION_TP);
    ENUM_POSITION_TYPE pos_type = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);

    // Calculate new SL (entry + buffer)
    double new_sl;
    if(pos_type == POSITION_TYPE_BUY)
        new_sl = entry_price + (m_plus_pips * _Point * 10);
    else
        new_sl = entry_price - (m_plus_pips * _Point * 10);

    new_sl = NormalizeDouble(new_sl, _Digits);

    // Modify position
    CTrade trade;
    trade.SetExpertMagicNumber(EXPERT_MAGIC);

    if(trade.PositionModify(ticket, new_sl, current_tp))
    {
        Print("✅ Position #", ticket, " moved to breakeven (+", m_plus_pips, " pips)");

        // Add to breakeven list
        AddToBreakevenList(ticket);

        // Send notification
        string message = StringFormat("🔒 Breakeven: %s %s #%d at %s +%d pips",
                                     pos_type == POSITION_TYPE_BUY ? "BUY" : "SELL",
                                     PositionGetString(POSITION_SYMBOL),
                                     ticket,
                                     DoubleToString(entry_price, _Digits),
                                     m_plus_pips);
        SendAlert("Breakeven", message);

        return true;
    }
    else
    {
        Print("❌ Failed to move position #", ticket, " to breakeven: ", GetLastError());
        return false;
    }
}

bool CBreakevenManager::IsAtBreakeven(ulong ticket)
{
    // Check if ticket is in breakeven list
    for(int i = 0; i < ArraySize(m_breakeven_tickets); i++)
    {
        if(m_breakeven_tickets[i] == ticket)
            return true;
    }
    return false;
}

void CBreakevenManager::AddToBreakevenList(ulong ticket)
{
    int size = ArraySize(m_breakeven_tickets);
    ArrayResize(m_breakeven_tickets, size + 1);
    m_breakeven_tickets[size] = ticket;
}
```

**Input Parameters:**

```cpp
input group "══════ BREAKEVEN ══════"
input bool inp_AutoBreakeven = true;                    // Enable Auto Breakeven
input int inp_BreakevenTriggerPips = 20;               // Breakeven Trigger (Pips)
input int inp_BreakevenPlusPips = 5;                   // Breakeven Plus (Pips Buffer)
input bool inp_BreakevenOnlyProfit = true;             // Only When In Profit
input bool inp_BreakevenAllSymbols = false;            // Apply To All Symbols
```

#### 4.2 Trailing Stop System

```cpp
class CTrailingManager
{
private:
    bool m_use_trailing;
    ENUM_TRAIL_TYPE m_trail_type;
    int m_trail_pips;
    double m_trail_atr_multiple;
    bool m_trail_on_candle_close;
    int m_min_profit_to_trail;
    int m_trail_step;

    // Track last trailing price for each position
    struct TrailData
    {
        ulong ticket;
        double last_trail_price;
        datetime last_trail_time;
    };
    TrailData m_trail_data[];

public:
    void Initialize();
    void CheckAllPositions();
    void TrailPosition(ulong ticket);
    double CalculateTrailingStop(ulong ticket);

    // Different trailing methods
    double CalculateFixedPipsTrail(ulong ticket);
    double CalculateATRTrail(ulong ticket);
    double CalculateParabolicSARTrail(ulong ticket);
    double CalculateHighLowTrail(ulong ticket);
};

enum ENUM_TRAIL_TYPE
{
    TRAIL_FIXED_PIPS,       // Fixed pips trailing
    TRAIL_ATR,              // ATR-based
    TRAIL_CANDLE_CLOSE,     // On candle close only
    TRAIL_STEP,             // Step trailing
    TRAIL_PARABOLIC_SAR,    // Parabolic SAR
    TRAIL_HIGH_LOW          // Swing high/low
};

void CTrailingManager::CheckAllPositions()
{
    if(!m_use_trailing) return;

    // Check if we should trail on candle close only
    if(m_trail_on_candle_close)
    {
        static datetime last_candle_time = 0;
        datetime current_candle_time = iTime(_Symbol, PERIOD_CURRENT, 0);

        if(current_candle_time == last_candle_time)
            return; // No new candle, skip

        last_candle_time = current_candle_time;
    }

    int total = PositionsTotal();
    for(int i = 0; i < total; i++)
    {
        ulong ticket = PositionGetTicket(i);
        if(ticket <= 0) continue;

        TrailPosition(ticket);
    }
}

void CTrailingManager::TrailPosition(ulong ticket)
{
    if(!PositionSelectByTicket(ticket))
        return;

    // Check magic number
    if(PositionGetInteger(POSITION_MAGIC) != EXPERT_MAGIC)
        return;

    // Get position details
    double entry_price = PositionGetDouble(POSITION_PRICE_OPEN);
    double current_sl = PositionGetDouble(POSITION_SL);
    double current_tp = PositionGetDouble(POSITION_TP);
    ENUM_POSITION_TYPE pos_type = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
    double current_price = pos_type == POSITION_TYPE_BUY ?
                          SymbolInfoDouble(_Symbol, SYMBOL_BID) :
                          SymbolInfoDouble(_Symbol, SYMBOL_ASK);

    // Calculate profit in pips
    double profit_pips = pos_type == POSITION_TYPE_BUY ?
                        (current_price - entry_price) / (_Point * 10) :
                        (entry_price - current_price) / (_Point * 10);

    // Check minimum profit requirement
    if(profit_pips < m_min_profit_to_trail)
        return;

    // Calculate new trailing stop
    double new_sl = CalculateTrailingStop(ticket);
    if(new_sl <= 0) return;

    // For BUY: new SL must be higher than current SL
    // For SELL: new SL must be lower than current SL
    bool should_modify = false;
    if(pos_type == POSITION_TYPE_BUY && new_sl > current_sl)
        should_modify = true;
    else if(pos_type == POSITION_TYPE_SELL && (current_sl == 0 || new_sl < current_sl))
        should_modify = true;

    if(should_modify)
    {
        CTrade trade;
        trade.SetExpertMagicNumber(EXPERT_MAGIC);

        if(trade.PositionModify(ticket, new_sl, current_tp))
        {
            Print("✅ Trailing stop updated: #", ticket, " New SL: ", new_sl);

            // Update trail data
            UpdateTrailData(ticket, new_sl);
        }
    }
}

double CTrailingManager::CalculateTrailingStop(ulong ticket)
{
    switch(m_trail_type)
    {
        case TRAIL_FIXED_PIPS:
            return CalculateFixedPipsTrail(ticket);
        case TRAIL_ATR:
            return CalculateATRTrail(ticket);
        case TRAIL_PARABOLIC_SAR:
            return CalculateParabolicSARTrail(ticket);
        case TRAIL_HIGH_LOW:
            return CalculateHighLowTrail(ticket);
        default:
            return 0;
    }
}

double CTrailingManager::CalculateFixedPipsTrail(ulong ticket)
{
    if(!PositionSelectByTicket(ticket))
        return 0;

    ENUM_POSITION_TYPE pos_type = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
    double current_price = pos_type == POSITION_TYPE_BUY ?
                          SymbolInfoDouble(_Symbol, SYMBOL_BID) :
                          SymbolInfoDouble(_Symbol, SYMBOL_ASK);

    double trail_distance = m_trail_pips * _Point * 10;
    double new_sl;

    if(pos_type == POSITION_TYPE_BUY)
        new_sl = current_price - trail_distance;
    else
        new_sl = current_price + trail_distance;

    return NormalizeDouble(new_sl, _Digits);
}

double CTrailingManager::CalculateATRTrail(ulong ticket)
{
    if(!PositionSelectByTicket(ticket))
        return 0;

    string symbol = PositionGetString(POSITION_SYMBOL);
    ENUM_POSITION_TYPE pos_type = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);

    // Get ATR value
    double atr_buffer[];
    ArraySetAsSeries(atr_buffer, true);
    int atr_handle = iATR(symbol, PERIOD_CURRENT, 14);
    if(atr_handle == INVALID_HANDLE)
        return 0;

    if(CopyBuffer(atr_handle, 0, 0, 1, atr_buffer) <= 0)
        return 0;

    double atr = atr_buffer[0];
    double trail_distance = atr * m_trail_atr_multiple;

    double current_price = pos_type == POSITION_TYPE_BUY ?
                          SymbolInfoDouble(symbol, SYMBOL_BID) :
                          SymbolInfoDouble(symbol, SYMBOL_ASK);

    double new_sl;
    if(pos_type == POSITION_TYPE_BUY)
        new_sl = current_price - trail_distance;
    else
        new_sl = current_price + trail_distance;

    return NormalizeDouble(new_sl, _Digits);
}

double CTrailingManager::CalculateHighLowTrail(ulong ticket)
{
    if(!PositionSelectByTicket(ticket))
        return 0;

    string symbol = PositionGetString(POSITION_SYMBOL);
    ENUM_POSITION_TYPE pos_type = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);

    // Get recent swing high/low
    int lookback = 20;
    double new_sl = 0;

    if(pos_type == POSITION_TYPE_BUY)
    {
        // Find recent swing low
        double low_buffer[];
        ArraySetAsSeries(low_buffer, true);
        if(CopyLow(symbol, PERIOD_CURRENT, 0, lookback, low_buffer) > 0)
        {
            new_sl = low_buffer[ArrayMinimum(low_buffer, 0, lookback)];
        }
    }
    else
    {
        // Find recent swing high
        double high_buffer[];
        ArraySetAsSeries(high_buffer, true);
        if(CopyHigh(symbol, PERIOD_CURRENT, 0, lookback, high_buffer) > 0)
        {
            new_sl = high_buffer[ArrayMaximum(high_buffer, 0, lookback)];
        }
    }

    return NormalizeDouble(new_sl, _Digits);
}
```

**Input Parameters:**

```cpp
input group "══════ TRAILING STOP ══════"
input bool inp_UseTrailing = true;                      // Enable Trailing Stop
input ENUM_TRAIL_TYPE inp_TrailType = TRAIL_ATR;        // Trailing Type
input int inp_TrailPips = 20;                           // Trailing Stop (Pips)
input double inp_TrailATRMultiple = 2.0;                // ATR Multiple For Trailing
input bool inp_TrailOnCandleClose = false;              // Trail On Candle Close Only
input int inp_MinProfitToTrail = 10;                    // Minimum Profit To Start Trailing (Pips)
input int inp_TrailStep = 10;                           // Trail Step (Pips, for step trailing)
input bool inp_TrailOnlyProfitable = true;              // Trail Only Profitable Positions
input bool inp_TrailAllSymbols = false;                 // Trail All Symbols
input int inp_HighLowLookback = 20;                     // High/Low Lookback (Bars)
```

#### 4.3 Partial Close System

```cpp
class CPartialCloseManager
{
private:
    bool m_use_auto_partials;

    struct PartialLevel
    {
        double percent_to_close;
        int trigger_pips;
        bool move_sl_to_be;
        double move_sl_to_pips;
        bool executed;
    };

    PartialLevel m_partial_levels[];

    // Track which partials have been executed for each position
    struct PositionPartials
    {
        ulong ticket;
        bool levels_executed[];
    };
    PositionPartials m_position_partials[];

public:
    void Initialize();
    void AddPartialLevel(double percent, int pips, bool move_be, double move_sl);
    void CheckAllPositions();
    bool ExecutePartialClose(ulong ticket, int level_index);
    double CalculatePipsProfit(ulong ticket);
};

void CPartialCloseManager::Initialize()
{
    ArrayResize(m_partial_levels, 0);

    // Load partial levels from inputs
    if(inp_Partial1_Percent > 0 && inp_Partial1_Pips > 0)
        AddPartialLevel(inp_Partial1_Percent, inp_Partial1_Pips, true, 0);

    if(inp_Partial2_Percent > 0 && inp_Partial2_Pips > 0)
        AddPartialLevel(inp_Partial2_Percent, inp_Partial2_Pips, true, inp_Partial1_Pips);

    if(inp_Partial3_Percent > 0 && inp_Partial3_Pips > 0)
        AddPartialLevel(inp_Partial3_Percent, inp_Partial3_Pips, true, inp_Partial2_Pips);
}

void CPartialCloseManager::AddPartialLevel(double percent, int pips, bool move_be, double move_sl)
{
    int size = ArraySize(m_partial_levels);
    ArrayResize(m_partial_levels, size + 1);

    m_partial_levels[size].percent_to_close = percent;
    m_partial_levels[size].trigger_pips = pips;
    m_partial_levels[size].move_sl_to_be = move_be;
    m_partial_levels[size].move_sl_to_pips = move_sl;
    m_partial_levels[size].executed = false;
}

void CPartialCloseManager::CheckAllPositions()
{
    if(!m_use_auto_partials) return;
    if(ArraySize(m_partial_levels) == 0) return;

    int total = PositionsTotal();
    for(int i = 0; i < total; i++)
    {
        ulong ticket = PositionGetTicket(i);
        if(ticket <= 0) continue;

        if(!PositionSelectByTicket(ticket))
            continue;

        // Check magic number
        if(PositionGetInteger(POSITION_MAGIC) != EXPERT_MAGIC)
            continue;

        // Calculate current profit in pips
        double profit_pips = CalculatePipsProfit(ticket);
        if(profit_pips <= 0) continue;

        // Check each partial level
        for(int level = 0; level < ArraySize(m_partial_levels); level++)
        {
            // Check if already executed for this position
            if(IsPartialExecuted(ticket, level))
                continue;

            // Check if profit reached trigger
            if(profit_pips >= m_partial_levels[level].trigger_pips)
            {
                ExecutePartialClose(ticket, level);
            }
        }
    }
}

bool CPartialCloseManager::ExecutePartialClose(ulong ticket, int level_index)
{
    if(!PositionSelectByTicket(ticket))
        return false;

    double current_lots = PositionGetDouble(POSITION_VOLUME);
    double lots_to_close = NormalizeDouble(current_lots * (m_partial_levels[level_index].percent_to_close / 100.0), 2);

    // Ensure minimum lot size
    double min_lot = SymbolInfoDouble(PositionGetString(POSITION_SYMBOL), SYMBOL_VOLUME_MIN);
    if(lots_to_close < min_lot)
    {
        Print("WARNING: Partial close lot size ", lots_to_close, " below minimum ", min_lot);
        return false;
    }

    // Ensure we don't close more than available
    if(lots_to_close >= current_lots)
    {
        lots_to_close = current_lots;
    }

    // Close partial
    CTrade trade;
    trade.SetExpertMagicNumber(EXPERT_MAGIC);

    if(trade.PositionClosePartial(ticket, lots_to_close))
    {
        Print("✅ Partial close: #", ticket, " Closed ", lots_to_close, " lots (",
              m_partial_levels[level_index].percent_to_close, "%) at +",
              m_partial_levels[level_index].trigger_pips, " pips");

        // Mark as executed
        MarkPartialExecuted(ticket, level_index);

        // Move SL if configured
        if(m_partial_levels[level_index].move_sl_to_be)
        {
            double entry_price = PositionGetDouble(POSITION_PRICE_OPEN);
            double current_tp = PositionGetDouble(POSITION_TP);
            double new_sl = entry_price;

            if(m_partial_levels[level_index].move_sl_to_pips > 0)
            {
                ENUM_POSITION_TYPE pos_type = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
                if(pos_type == POSITION_TYPE_BUY)
                    new_sl = entry_price + (m_partial_levels[level_index].move_sl_to_pips * _Point * 10);
                else
                    new_sl = entry_price - (m_partial_levels[level_index].move_sl_to_pips * _Point * 10);
            }

            trade.PositionModify(ticket, NormalizeDouble(new_sl, _Digits), current_tp);
            Print("  └─ SL moved to ", NormalizeDouble(new_sl, _Digits));
        }

        // Send notification
        string message = StringFormat("📊 Partial Close: %s Closed %.0f%% at +%d pips",
                                     PositionGetString(POSITION_SYMBOL),
                                     m_partial_levels[level_index].percent_to_close,
                                     m_partial_levels[level_index].trigger_pips);
        SendAlert("Partial Close", message);

        return true;
    }
    else
    {
        Print("❌ Failed to close partial: ", GetLastError());
        return false;
    }
}

double CPartialCloseManager::CalculatePipsProfit(ulong ticket)
{
    if(!PositionSelectByTicket(ticket))
        return 0;

    double entry_price = PositionGetDouble(POSITION_PRICE_OPEN);
    ENUM_POSITION_TYPE pos_type = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
    string symbol = PositionGetString(POSITION_SYMBOL);

    double current_price = pos_type == POSITION_TYPE_BUY ?
                          SymbolInfoDouble(symbol, SYMBOL_BID) :
                          SymbolInfoDouble(symbol, SYMBOL_ASK);

    double profit_pips = pos_type == POSITION_TYPE_BUY ?
                        (current_price - entry_price) / (_Point * 10) :
                        (entry_price - current_price) / (_Point * 10);

    return profit_pips;
}
```

**Input Parameters:**

```cpp
input group "══════ PARTIAL CLOSE ══════"
input bool inp_UseAutoPartials = true;                  // Enable Auto Partial Close
input double inp_Partial1_Percent = 50.0;               // Partial 1: % To Close
input int inp_Partial1_Pips = 20;                       // Partial 1: Trigger (Pips)
input double inp_Partial2_Percent = 25.0;               // Partial 2: % To Close
input int inp_Partial2_Pips = 40;                       // Partial 2: Trigger (Pips)
input double inp_Partial3_Percent = 25.0;               // Partial 3: % To Close
input int inp_Partial3_Pips = 60;                       // Partial 3: Trigger (Pips)
input bool inp_MoveSLAfterPartial = true;               // Move SL After Partial
input bool inp_PartialOnlyProfitable = true;            // Only Close If Profitable
```

---

## 🎯 DEVELOPMENT ROADMAP

### Phase 1: Core Foundation (Weeks 1-2)
**Status: READY TO START**

**Week 1:**
- [ ] Set up project structure
- [ ] Create main EA file with basic framework
- [ ] Implement panel UI system (CMainPanel class)
- [ ] Create risk calculator (CRiskManager class)
- [ ] Basic account info display
- [ ] Settings save/load system

**Week 2:**
- [ ] Implement market order execution
- [ ] Basic SL/TP placement (points mode)
- [ ] Close all/partial buttons functionality
- [ ] Emergency controls
- [ ] Error handling system
- [ ] First testing phase

**Deliverable:** Working EA with basic panel, risk calculator, and order execution

---

### Phase 2: Trade Management (Weeks 3-4)

**Week 3:**
- [ ] Breakeven automation system
- [ ] Trailing stop (fixed pips method)
- [ ] Trailing stop (ATR method)
- [ ] Partial close system (3 levels)
- [ ] Position modification functions

**Week 4:**
- [ ] Additional trailing methods (SAR, High/Low)
- [ ] Hidden SL/TP system
- [ ] Trade management panel integration
- [ ] Testing and bug fixes

**Deliverable:** Full trade management automation

---

### Phase 3: Advanced Features (Weeks 5-6)

**Week 5:**
- [ ] Trading hours filter
- [ ] Day of week filter
- [ ] ATR-based SL/TP calculations
- [ ] Preview mode with draggable lines
- [ ] R:R calculator and visual display

**Week 6:**
- [ ] News filter system
- [ ] Session markers on chart
- [ ] Chart drawing tools (S/R, Supply/Demand)
- [ ] Multi-symbol support
- [ ] Symbol switcher

**Deliverable:** Advanced trading tools and filters

---

### Phase 4: Smart Systems (Weeks 7-8)

**Week 7:**
- [ ] Trade statistics calculator
- [ ] Trade journal (CSV export)
- [ ] Performance metrics
- [ ] Alert system (popup, sound, push)
- [ ] Telegram integration basics

**Week 8:**
- [ ] Telegram remote commands
- [ ] Grid trading module
- [ ] Custom indicator integration
- [ ] Prop firm tracking tools
- [ ] FTMO/MFF challenge assistant

**Deliverable:** Complete smart features

---

### Phase 5: Polish & Release (Weeks 9-10)

**Week 9:**
- [ ] Code optimization
- [ ] Memory leak fixes
- [ ] Performance testing
- [ ] Visual improvements
- [ ] Theme system
- [ ] Preset creation

**Week 10:**
- [ ] Documentation writing
- [ ] Video tutorials recording
- [ ] Beta testing with users
- [ ] Final bug fixes
- [ ] MQL5 Market submission prep
- [ ] Marketing materials

**Deliverable:** Production-ready EA

---

## 🧪 TESTING REQUIREMENTS

### Pre-Release Checklist

```
COMPILATION:
☐ Compiles without errors
☐ Compiles without warnings
☐ No deprecated functions used
☐ All resources embedded successfully

FUNCTIONALITY:
☐ Panel displays correctly on all corners
☐ All buttons respond to clicks
☐ Risk calculator accurate for all modes
☐ Market orders execute correctly
☐ Pending orders place correctly
☐ SL/TP calculated accurately
☐ Breakeven triggers at correct level
☐ Trailing stops work for all methods
☐ Partial closes execute correctly
☐ All emergency controls work
☐ Statistics calculated accurately

COMPATIBILITY:
☐ Works on hedging accounts
☐ Works on netting accounts
☐ Works with Forex pairs
☐ Works with Gold/Silver
☐ Works with Indices
☐ Works with Crypto
☐ Works on all timeframes (M1-MN1)
☐ Works on multiple monitors

RISK MANAGEMENT:
☐ Daily loss limit triggers correctly
☐ Profit target triggers correctly
☐ Max risk exposure respected
☐ Drawdown protection works
☐ No trades opened when limits hit

PERFORMANCE:
☐ No lag when opening panel
☐ No lag during tick processing
☐ Memory usage stable over time
☐ No memory leaks detected
☐ CPU usage acceptable (<5%)

ERROR HANDLING:
☐ Handles connection loss gracefully
☐ Handles insufficient margin
☐ Handles invalid inputs
☐ Handles broker rejections
☐ Handles symbol not found
☐ All errors logged properly

PERSISTENCE:
☐ Settings save correctly
☐ Settings load correctly
☐ Panel position saved
☐ Trade journal saves
☐ Statistics persist

MQL5 MARKET COMPLIANCE:
☐ No DLL dependencies
☐ No external file writes (except allowed)
☐ All text in English
☐ Description clear and accurate
☐ Screenshots prepared (720px minimum)
☐ Icon prepared (200x200, 140x140, 60x60)
☐ Video demo prepared
☐ User manual PDF completed
```

---

## 💰 MONETIZATION STRATEGY

### Pricing Structure

**Single Product Model:**
```
ULTIMATE TRADE ASSISTANT PRO
Price: $299 (One-time payment)

Includes:
✅ ALL features (no limitations)
✅ 10 account activations
✅ Lifetime updates
✅ Priority email support
✅ Access to private Telegram group
✅ 5 preset configurations
✅ Video training course
✅ 30-day money-back guarantee
```

### Future Expansion (6 months after launch):

```
LITE VERSION - $99
- Basic risk calculator
- Market orders only
- Simple trailing & breakeven
- 3 account activations
- Standard support

STANDARD VERSION - $199
- All risk management features
- Full order management
- Advanced trailing & partials
- Statistics & journal
- 5 account activations
- Priority support

PRO VERSION - $299 (Current offering)
- Everything in Standard
- Grid trading
- Telegram integration
- Prop firm tools
- Custom indicator integration
- 10 account activations
- VIP support + 1-on-1 setup call
```

### Marketing Channels

1. **MQL5 Market** (Primary)
   - Professional product page
   - 5+ screenshots
   - Demo video
   - Detailed description

2. **Forex Forums**
   - ForexFactory
   - BabyPips
   - Elite Trader
   - Provide value, subtle promotion

3. **YouTube**
   - Feature demonstrations
   - Comparison videos
   - User testimonials
   - Trading education content

4. **Telegram/Discord**
   - Free trading community
   - EA support channel
   - Share trading tips
   - Soft sell approach

5. **Affiliate Program**
   - 30% commission for affiliates
   - Promotional materials provided
   - Dedicated landing pages

### Value Proposition

"Ultimate Trade Assistant Pro replaces 10+ separate tools:
1. Position Size Calculator ($29)
2. Risk Manager ($49)
3. Trailing Stop EA ($39)
4. Partial Close Tool ($29)
5. Trading Timer ($19)
6. News Filter ($29)
7. Statistics Dashboard ($49)
8. Trade Journal ($29)
9. Prop Firm Tracker ($39)
10. Telegram Alerts ($29)

Total Value: $340+
**Your Price: $299** (All-in-One)"

---

## 📝 FINAL NOTES FOR AI CODING ASSISTANCE

### When Requesting AI Help:

**Use This Template:**

```
I need help coding [MODULE_NAME] for my MT5 Trade Assistant.

Context:
- This is part of an all-in-one trading utility EA
- Must be efficient and lag-free
- Target users: Professional manual traders

Requirements:
1. [Specific requirement 1]
2. [Specific requirement 2]
3. [Specific requirement 3]

Technical Constraints:
- MQL5 language only
- No external DLLs
- Must work on both hedging and netting accounts
- All resources embedded

Please provide:
- Complete working code with comments
- Error handling
- Input parameters
- Integration instructions

Refer to section [X.X] in the specification for full details.
```

### Code Quality Standards:

1. **Comments:**
   - Every function documented
   - Complex logic explained
   - Input parameters described

2. **Error Handling:**
   - All trade operations checked
   - Errors logged with context
   - User-friendly error messages

3. **Performance:**
   - Minimal tick processing
   - Efficient loops
   - No unnecessary redraws

4. **Maintainability:**
   - Clear variable names
   - Consistent formatting
   - Modular design

---

## 🚀 GETTING STARTED

### Next Steps:

1. **Review this specification thoroughly**
2. **Set up development environment (MetaEditor)**
3. **Start with Phase 1, Week 1 tasks**
4. **Build incrementally, test frequently**
5. **Use AI assistance for complex modules**
6. **Follow the roadmap strictly**

### Success Criteria:

✅ EA compiles without errors
✅ All features working as specified
✅ No performance issues
✅ Positive beta tester feedback
✅ Passes MQL5 Market review
✅ First sales within 30 days of launch

---

**Document Version:** 1.0
**Last Updated:** 2025-11-12
**Total Estimated Development Time:** 10 weeks
**Estimated Lines of Code:** 15,000+

---

*This specification is a living document. Updates will be versioned and tracked.*
