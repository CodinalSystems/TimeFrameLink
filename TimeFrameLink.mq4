#property copyright "Codinal Systems"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property indicator_chart_window

bool isLink = true;

input bool isLabel = true;//動作中ラベル表示


int OnInit(){
   
   if (isLabel){
      ObjectCreate("label", OBJ_LABEL, 0, 0, 0);
      ObjectSetInteger(0, "label", OBJPROP_SELECTABLE, false);
      ObjectSetInteger(0, "label", OBJPROP_ANCHOR, ANCHOR_LEFT_LOWER);
      ObjectSetInteger(0, "label", OBJPROP_CORNER, CORNER_LEFT_LOWER);
      ObjectSetInteger(0, "label", OBJPROP_XDISTANCE, 2); 
      ObjectSetInteger(0, "label", OBJPROP_YDISTANCE, 2);
      ObjectSetText("label", "時間軸リンク動作中", 12, "Meiryo UI", clrWhite);
   }
   
   return(INIT_SUCCEEDED);
}


void OnDeinit(const int reason){

   ObjectDelete("label");
}


void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
{
   if (id == CHARTEVENT_CHART_CHANGE && isLink){
      int timeFrame = Period();
      for(long chartId = ChartFirst(); chartId != -1; chartId = ChartNext(chartId)){
         if (ChartPeriod(chartId) != timeFrame){
            ChartSetSymbolPeriod(chartId, ChartSymbol(chartId), timeFrame);
         }
      }
   }
}


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

   return(rates_total);
}
