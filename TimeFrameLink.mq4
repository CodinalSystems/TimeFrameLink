#property copyright "Codinal Systems"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property indicator_chart_window


enum CornerType{
   CORNER_1 = 0,//左上
   CORNER_2,//左下
   CORNER_3,//右上
   CORNER_4//右下
};


input string buttonSetting = "---------------ボタン設定---------------"; //▼ボタン
input CornerType cornerType = CORNER_4;//ボタンの位置
input int addPosX = 0;//x座標
input int addPosY = 0;//y座標

input string colorMargin=""; //　
input string colorSetting = "---------------カラー設定---------------"; //▼カラー
input color borderColor = clrWhite;//枠線色
input color textColor = clrWhite;//文字色

bool isClose = true;


int OnInit(){

   SetButton();
   return(INIT_SUCCEEDED);
}


void OnDeinit(const int reason){
   ObjectsDeleteAll();
}


void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
{
   string disc = "";
   if(id==CHARTEVENT_OBJECT_CLICK){
      string clickedChartObject = sparam; 
      
      if (clickedChartObject == "Close-btn"){
         
         string closeBtnText;
         int visibility;
      
         if (isClose){
         
            closeBtnText = "×";
            visibility = -1;
            isClose = false;
         
         }else{
            closeBtnText = "〇";
            visibility = 0;
            isClose = true;
         }
         ObjectSetString(0, "Close-btn", OBJPROP_TEXT, closeBtnText);
      }    
   }
   if (id == CHARTEVENT_CHART_CHANGE){
      int timeFrame = Period();
      for(long chartId = ChartFirst(); chartId != -1; chartId = ChartNext(chartId)){
         if (ChartPeriod(chartId) != timeFrame){
            ChartSetSymbolPeriod(chartId, ChartSymbol(chartId), timeFrame);
         }
      }
   }
}




void SetButton(){

   int btnSizeX = 50; int btnSizeY = 20;
   int closeX, closeY;
   int anchor;
   
   if (cornerType == 0){
   
      closeX = 55 - btnSizeX;
      closeY = 23 - btnSizeY;
      anchor = CORNER_LEFT_UPPER;  
   }
   
   if (cornerType == 1){
   
      closeX = 55 - btnSizeX;
      closeY = 23;
      anchor = CORNER_LEFT_LOWER;
   }
   
   if (cornerType == 2){
   
      closeX = 55;
      closeY = 23 - btnSizeY;
      anchor = CORNER_RIGHT_UPPER;
   }
   
   if (cornerType == 3){
      
      closeX = 55;
      closeY = 23;
      anchor = CORNER_RIGHT_LOWER;
   }
    
   CreateButton("Close-btn", closeX + addPosX, closeY + addPosY, btnSizeX, btnSizeY, "〇", anchor);
}


void CreateButton(string objName, int positionX, int positionY, int sizeX, int sizeY, string text, int anchor){

      ObjectCreate(objName, OBJ_EDIT, 0, 0, 0);
      ObjectSetInteger(0, objName, OBJPROP_BACK, True); 
      ObjectSetInteger(0, objName, OBJPROP_SELECTABLE, false);
      ObjectSetInteger(0, objName, OBJPROP_READONLY, true); 
      ObjectSetInteger(0, objName, OBJPROP_CORNER, anchor);
      ObjectSetInteger(0, objName, OBJPROP_BORDER_COLOR, borderColor);
      ObjectSetInteger(0, objName, OBJPROP_COLOR, textColor);
      ObjectSetInteger(0, objName, OBJPROP_BGCOLOR, clrNONE);
      ObjectSetString(0, objName, OBJPROP_TEXT, text);  
      ObjectSetString(0, objName, OBJPROP_FONT, "Meiryo UI");  
      ObjectSetInteger(0, objName, OBJPROP_BGCOLOR, clrNONE);
      ObjectSetInteger(0, objName, OBJPROP_XDISTANCE, positionX); 
      ObjectSetInteger(0, objName, OBJPROP_YDISTANCE, positionY);
      ObjectSetInteger(0, objName, OBJPROP_XSIZE, sizeX); 
      ObjectSetInteger(0, objName, OBJPROP_YSIZE, sizeY);
      ObjectSetInteger(0, objName, OBJPROP_BORDER_TYPE, BORDER_FLAT); 
      ObjectSetInteger(0, objName, OBJPROP_ALIGN, ALIGN_CENTER);
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