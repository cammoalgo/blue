//+------------------------------------------------------------------+
//|                                             UTAP_RiskManager.mqh |
//|                                   Ultimate Trade Assistant Pro   |
//|                                   Risk Management & Calculation  |
//+------------------------------------------------------------------+
#property copyright "Ultimate Trade Assistant Pro"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

//--- Include necessary libraries
#include <Trade\AccountInfo.mqh>
#include <Trade\SymbolInfo.mqh>

//+------------------------------------------------------------------+
//| Risk Mode Enumeration                                             |
//+------------------------------------------------------------------+
enum ENUM_RISK_MODE
{
   RISK_PERCENT,       // Risk percentage of equity
   RISK_FIXED_LOTS,    // Fixed lot size
   RISK_FIXED_MONEY    // Fixed money amount
};

//+------------------------------------------------------------------+
//| Risk Manager Class                                                |
//+------------------------------------------------------------------+
class CRiskManager
{
private:
   // Account info
   CAccountInfo m_accountInfo;
   CSymbolInfo m_symbolInfo;

   // Risk settings
   ENUM_RISK_MODE m_riskMode;
   double m_riskPercent;
   double m_fixedLots;
   double m_fixedMoneyRisk;
   bool m_useEquity;

   // Symbol properties
   double m_pointValue;
   double m_tickValue;
   double m_tickSize;
   double m_lotStep;
   double m_minLot;
   double m_maxLot;
   int m_digits;

   // Last calculation results
   double m_lastCalculatedLots;
   double m_lastRiskAmount;
   double m_lastSLDistance;

public:
   // Constructor
   CRiskManager();

   // Initialization
   bool Initialize(string symbol);

   // Configuration
   void SetRiskMode(ENUM_RISK_MODE mode) { m_riskMode = mode; }
   void SetRiskPercent(double percent) { m_riskPercent = percent; }
   void SetFixedLots(double lots) { m_fixedLots = lots; }
   void SetFixedMoneyRisk(double money) { m_fixedMoneyRisk = money; }
   void SetUseEquity(bool useEquity) { m_useEquity = useEquity; }

   // Main calculation function
   double CalculateLotSize(double entryPrice, double stopLossPrice);

   // Helper functions
   double GetPointValue();
   double GetPipValue(double lots);
   double NormalizeLots(double lots);
   bool ValidateLotSize(double lots, string &errorMessage);

   // Risk exposure
   double GetCurrentRiskPercent();
   double GetCurrentRiskMoney();
   double GetMaxPossibleLots();
   int GetMaxPossibleTrades(double lotsPerTrade);

   // Getters for last calculation
   double GetLastCalculatedLots() { return m_lastCalculatedLots; }
   double GetLastRiskAmount() { return m_lastRiskAmount; }
   double GetLastSLDistance() { return m_lastSLDistance; }

   // Utility functions
   double CalculatePipsFromPoints(double points);
   double CalculatePointsFromPips(double pips);
   double CalculateRequiredMargin(double lots);

private:
   // Internal helpers
   void UpdateSymbolProperties();
   double GetAccountBase();
};

//+------------------------------------------------------------------+
//| Constructor                                                        |
//+------------------------------------------------------------------+
CRiskManager::CRiskManager()
{
   m_riskMode = RISK_PERCENT;
   m_riskPercent = 2.0;
   m_fixedLots = 0.10;
   m_fixedMoneyRisk = 200.0;
   m_useEquity = true;

   m_pointValue = 0;
   m_tickValue = 0;
   m_tickSize = 0;
   m_lotStep = 0.01;
   m_minLot = 0.01;
   m_maxLot = 100.0;
   m_digits = 5;

   m_lastCalculatedLots = 0;
   m_lastRiskAmount = 0;
   m_lastSLDistance = 0;
}

//+------------------------------------------------------------------+
//| Initialize risk manager                                           |
//+------------------------------------------------------------------+
bool CRiskManager::Initialize(string symbol)
{
   if(!m_symbolInfo.Name(symbol))
   {
      Print("ERROR: Failed to initialize symbol info for ", symbol);
      return false;
   }

   UpdateSymbolProperties();

   Print("✓ Risk Manager initialized for ", symbol);
   Print("  Point Value: $", DoubleToString(m_pointValue, 5));
   Print("  Lot Step: ", m_lotStep);
   Print("  Min Lot: ", m_minLot);
   Print("  Max Lot: ", m_maxLot);

   return true;
}

//+------------------------------------------------------------------+
//| Calculate lot size based on risk                                  |
//+------------------------------------------------------------------+
double CRiskManager::CalculateLotSize(double entryPrice, double stopLossPrice)
{
   // Validate inputs
   if(entryPrice <= 0 || stopLossPrice <= 0)
   {
      Print("ERROR: Invalid entry or stop loss price");
      return 0;
   }

   if(entryPrice == stopLossPrice)
   {
      Print("ERROR: Entry price equals stop loss price");
      return 0;
   }

   // Calculate SL distance
   double slDistance = MathAbs(entryPrice - stopLossPrice);
   double slPoints = slDistance / m_symbolInfo.Point();
   m_lastSLDistance = slPoints;

   double lotSize = 0;

   // Calculate based on risk mode
   switch(m_riskMode)
   {
      case RISK_PERCENT:
      {
         double accountBase = GetAccountBase();
         double riskAmount = accountBase * (m_riskPercent / 100.0);
         m_lastRiskAmount = riskAmount;

         if(m_pointValue > 0)
         {
            lotSize = riskAmount / (slPoints * m_pointValue);
         }
         else
         {
            Print("ERROR: Point value is zero");
            return 0;
         }

         break;
      }

      case RISK_FIXED_LOTS:
      {
         lotSize = m_fixedLots;

         // Calculate risk amount for display
         if(m_pointValue > 0)
         {
            m_lastRiskAmount = lotSize * slPoints * m_pointValue;
         }

         break;
      }

      case RISK_FIXED_MONEY:
      {
         m_lastRiskAmount = m_fixedMoneyRisk;

         if(m_pointValue > 0)
         {
            lotSize = m_fixedMoneyRisk / (slPoints * m_pointValue);
         }
         else
         {
            Print("ERROR: Point value is zero");
            return 0;
         }

         break;
      }
   }

   // Normalize lot size
   lotSize = NormalizeLots(lotSize);

   // Validate
   string errorMsg;
   if(!ValidateLotSize(lotSize, errorMsg))
   {
      Print("ERROR: Lot size validation failed: ", errorMsg);
      return 0;
   }

   m_lastCalculatedLots = lotSize;

   // Debug output
   Print("═══ Risk Calculation ═══");
   Print("Entry: ", entryPrice, " | SL: ", stopLossPrice);
   Print("SL Distance: ", DoubleToString(slPoints, 0), " points (", DoubleToString(CalculatePipsFromPoints(slPoints), 1), " pips)");
   Print("Risk Amount: $", DoubleToString(m_lastRiskAmount, 2));
   Print("Calculated Lots: ", DoubleToString(lotSize, 2));
   Print("═══════════════════════");

   return lotSize;
}

//+------------------------------------------------------------------+
//| Get point value                                                   |
//+------------------------------------------------------------------+
double CRiskManager::GetPointValue()
{
   if(m_pointValue > 0)
      return m_pointValue;

   UpdateSymbolProperties();
   return m_pointValue;
}

//+------------------------------------------------------------------+
//| Get pip value for given lot size                                  |
//+------------------------------------------------------------------+
double CRiskManager::GetPipValue(double lots)
{
   // For most pairs, 1 pip = 10 points
   // For JPY pairs and others, it's different
   double pipPoints = (m_digits == 3 || m_digits == 5) ? 10.0 : 1.0;

   return lots * m_pointValue * pipPoints;
}

//+------------------------------------------------------------------+
//| Normalize lots to broker requirements                             |
//+------------------------------------------------------------------+
double CRiskManager::NormalizeLots(double lots)
{
   if(lots <= 0)
      return 0;

   // Round down to lot step
   lots = MathFloor(lots / m_lotStep) * m_lotStep;

   // Clamp to min/max
   lots = MathMax(lots, m_minLot);
   lots = MathMin(lots, m_maxLot);

   // Normalize to 2 decimal places
   return NormalizeDouble(lots, 2);
}

//+------------------------------------------------------------------+
//| Validate lot size                                                 |
//+------------------------------------------------------------------+
bool CRiskManager::ValidateLotSize(double lots, string &errorMessage)
{
   // Check minimum
   if(lots < m_minLot)
   {
      errorMessage = "Lot size " + DoubleToString(lots, 2) + " below minimum " + DoubleToString(m_minLot, 2);
      return false;
   }

   // Check maximum
   if(lots > m_maxLot)
   {
      errorMessage = "Lot size " + DoubleToString(lots, 2) + " above maximum " + DoubleToString(m_maxLot, 2);
      return false;
   }

   // Check if zero
   if(lots == 0)
   {
      errorMessage = "Calculated lot size is zero";
      return false;
   }

   // Check free margin
   double requiredMargin = CalculateRequiredMargin(lots);
   double freeMargin = m_accountInfo.FreeMargin();

   if(requiredMargin > freeMargin)
   {
      errorMessage = "Insufficient margin. Required: $" + DoubleToString(requiredMargin, 2) +
                     " Available: $" + DoubleToString(freeMargin, 2);
      return false;
   }

   return true;
}

//+------------------------------------------------------------------+
//| Get current risk exposure (percent)                               |
//+------------------------------------------------------------------+
double CRiskManager::GetCurrentRiskPercent()
{
   double totalRisk = 0;
   double accountBase = GetAccountBase();

   if(accountBase == 0)
      return 0;

   // Calculate risk from all open positions
   // TODO: Implement position risk calculation

   return (totalRisk / accountBase) * 100.0;
}

//+------------------------------------------------------------------+
//| Get current risk exposure (money)                                 |
//+------------------------------------------------------------------+
double CRiskManager::GetCurrentRiskMoney()
{
   // TODO: Implement position risk calculation
   return 0;
}

//+------------------------------------------------------------------+
//| Get maximum possible lots                                         |
//+------------------------------------------------------------------+
double CRiskManager::GetMaxPossibleLots()
{
   double freeMargin = m_accountInfo.FreeMargin();

   // Estimate based on leverage and symbol
   // This is simplified - actual calculation is complex
   double estimatedMarginPerLot = 1000.0; // Placeholder

   double maxLots = freeMargin / estimatedMarginPerLot;
   return NormalizeLots(maxLots);
}

//+------------------------------------------------------------------+
//| Get maximum possible trades                                       |
//+------------------------------------------------------------------+
int CRiskManager::GetMaxPossibleTrades(double lotsPerTrade)
{
   double maxLots = GetMaxPossibleLots();

   if(lotsPerTrade == 0)
      return 0;

   return (int)(maxLots / lotsPerTrade);
}

//+------------------------------------------------------------------+
//| Calculate pips from points                                        |
//+------------------------------------------------------------------+
double CRiskManager::CalculatePipsFromPoints(double points)
{
   // For 5-digit and 3-digit brokers
   double pipFactor = (m_digits == 3 || m_digits == 5) ? 10.0 : 1.0;
   return points / pipFactor;
}

//+------------------------------------------------------------------+
//| Calculate points from pips                                        |
//+------------------------------------------------------------------+
double CRiskManager::CalculatePointsFromPips(double pips)
{
   double pipFactor = (m_digits == 3 || m_digits == 5) ? 10.0 : 1.0;
   return pips * pipFactor;
}

//+------------------------------------------------------------------+
//| Calculate required margin                                         |
//+------------------------------------------------------------------+
double CRiskManager::CalculateRequiredMargin(double lots)
{
   double margin = 0;

   // Use MT5 built-in function
   if(!OrderCalcMargin(ORDER_TYPE_BUY, m_symbolInfo.Name(), lots,
                       m_symbolInfo.Ask(), margin))
   {
      Print("ERROR: Failed to calculate margin");
      return 0;
   }

   return margin;
}

//+------------------------------------------------------------------+
//| Update symbol properties                                          |
//+------------------------------------------------------------------+
void CRiskManager::UpdateSymbolProperties()
{
   m_tickValue = m_symbolInfo.TradeTickValue();
   m_tickSize = m_symbolInfo.TradeTickSize();
   double point = m_symbolInfo.Point();

   // Calculate point value
   m_pointValue = (m_tickValue / m_tickSize) * point;

   // Get lot properties
   m_lotStep = m_symbolInfo.LotsStep();
   m_minLot = m_symbolInfo.LotsMin();
   m_maxLot = m_symbolInfo.LotsMax();
   m_digits = (int)m_symbolInfo.Digits();
}

//+------------------------------------------------------------------+
//| Get account base (balance or equity)                              |
//+------------------------------------------------------------------+
double CRiskManager::GetAccountBase()
{
   if(m_useEquity)
      return m_accountInfo.Equity();
   else
      return m_accountInfo.Balance();
}

//+------------------------------------------------------------------+
