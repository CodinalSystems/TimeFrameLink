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
input CornerType cornerType = CORNER_2;//ボタンの位置
input int addPosX = 0;//x座標
input int addPosY = 0;//y座標

input string colorMargin=""; //　
input string colorSetting = "---------------カラー設定---------------"; //▼カラー
input color borderColor = clrWhite;//枠線色
input color textColor = clrWhite;//文字色

int isLink;


int OnInit(){
   
   if (ReadToText("isLink.txt") == NULL){
      WriteToText("isLink.txt", "1");
   }
   isLink = ReadToText("isLink.txt");
   
   SetButton();
   
   return(INIT_SUCCEEDED);
}


void OnDeinit(const int reason){

   ObjectDelete("Link-btn");
}


void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
{

   if(id==CHARTEVENT_OBJECT_CLICK){
      string clickedChartObject = sparam; 
      
      if (clickedChartObject == "Link-btn"){
         
         string linkBtnText;
         int visibility;
         
         isLink = ReadToText("isLink.txt");
         if (isLink){
         
            linkBtnText = "リンクOFF";
            isLink = WriteToText("isLink.txt", "0");
         
         }else{
         
            linkBtnText = "リンクON";
            isLink = WriteToText("isLink.txt", "1");
            
         }
         
         ObjectSetString(0, "Link-btn", OBJPROP_TEXT, linkBtnText);
      }    
   }
   
   
   if (id == CHARTEVENT_CHART_CHANGE){
      if (isLink){
         int timeFrame = Period();
         for(long chartId = ChartFirst(); chartId != -1; chartId = ChartNext(chartId)){
            if (ChartPeriod(chartId) != timeFrame){
               ChartSetSymbolPeriod(chartId, ChartSymbol(chartId), timeFrame);
            }
         }
      }
   }
}


void SetButton(){

   int btnSizeX = 73; int btnSizeY = 22;
   int posX, posY, anchor;
   string objName = "Link-btn";
   
   if (cornerType == 0){
   
      posX = 76 - btnSizeX;
      posY = 25 - btnSizeY;
      anchor = CORNER_LEFT_UPPER; 
   
   }
   
   if (cornerType == 1){
   
      posX = 76 - btnSizeX;
      posY = 25;
      anchor = CORNER_LEFT_LOWER;

   }
   
   if (cornerType == 2){
   
      posX = 76;
      posY = 25 - btnSizeY;
      anchor = CORNER_RIGHT_UPPER;
   
   }
   
   if (cornerType == 3){
      
      posX = 76;
      posY = 25;
      anchor = CORNER_RIGHT_LOWER;
   
   } 
   
   string text = "リンクOFF";
   if (isLink) text = "リンクON";
   
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
   ObjectSetInteger(0, objName, OBJPROP_FONTSIZE, 12); 
   ObjectSetInteger(0, objName, OBJPROP_BGCOLOR, clrNONE);
   ObjectSetInteger(0, objName, OBJPROP_XDISTANCE, posX + addPosX); 
   ObjectSetInteger(0, objName, OBJPROP_YDISTANCE, posY + addPosY);
   ObjectSetInteger(0, objName, OBJPROP_XSIZE, btnSizeX); 
   ObjectSetInteger(0, objName, OBJPROP_YSIZE, btnSizeY);
   ObjectSetInteger(0, objName, OBJPROP_BORDER_TYPE, BORDER_FLAT); 
   ObjectSetInteger(0, objName, OBJPROP_ALIGN, ALIGN_CENTER);
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
      ObjectSetInteger(0, objName, OBJPROP_FONTSIZE, 12); 
      ObjectSetInteger(0, objName, OBJPROP_BGCOLOR, clrNONE);
      ObjectSetInteger(0, objName, OBJPROP_XDISTANCE, positionX); 
      ObjectSetInteger(0, objName, OBJPROP_YDISTANCE, positionY);
      ObjectSetInteger(0, objName, OBJPROP_XSIZE, sizeX); 
      ObjectSetInteger(0, objName, OBJPROP_YSIZE, sizeY);
      ObjectSetInteger(0, objName, OBJPROP_BORDER_TYPE, BORDER_FLAT); 
      ObjectSetInteger(0, objName, OBJPROP_ALIGN, ALIGN_CENTER);
}


int WriteToText(string fileName, string text){
   int handle = FileOpen(fileName, FILE_WRITE | FILE_TXT);
   if (handle > 0)
   {
      FileWrite(handle, text);
      FileClose(handle);
   }
   return 0;
}


string ReadToText(string fileName){
   int handle = FileOpen(fileName, FILE_READ | FILE_TXT);
   string text;
   if (handle > 0)
   {
      text = StrToInteger(FileReadString(handle));
      FileClose(handle);
   }
   return text;
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
