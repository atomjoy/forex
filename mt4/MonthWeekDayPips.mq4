#property copyright     "Atomjoy"
#property link          "https://github.com/atomjoy"
#property version       "1.0"                                                     
#property description   "Month, week and day open pips."
//#property icon        "\\Images\\ico.ico";
#property strict
#property indicator_separate_window // Drawing in a separate window

extern int FontSize = 11;   

int windowIndex;
string Text0 = "";
string Text1 = "";
string Text2 = "";
string Text3 = "";
double profit = 0;

double CalcPipCost(double tickValue) {
   if(Digits == 5 || Digits == 3 || Digits == 2 || Digits == 1) {
      return tickValue / 10;
   }
   return cost;
}

int init()                         
{
   IndicatorShortName("MonthWeekDayPips");
   windowIndex=WindowFind("MonthWeekDayPips");
   //Print(windowIndex); // Show indicator info  
     
   if(windowIndex<0)
   {
      Print("Can\'t find window");
      return(0);
   }   
   
   return(0);                         
}


int start()                        
{
   ObjectsDeleteAll(windowIndex);
   
   profit = 0;      
   string txt1 = "";
   string txt2 = "";
   string txt3 = "";
   string txt4 = "";
   double ma50 = 0;
   double open  = Open[0];
   double Wopen = iOpen(Symbol(),PERIOD_W1,0);
   double Dopen = iOpen(Symbol(),PERIOD_D1,0);
   double Mopen = iOpen(Symbol(),PERIOD_MN1,0);
   double Wpips = (Wopen-Bid)/MarketInfo(OrderSymbol(),MODE_POINT)/10;
   double Dpips = (Dopen-Bid)/MarketInfo(OrderSymbol(),MODE_POINT)/10;
   double Mpips = (Mopen-Bid)/MarketInfo(OrderSymbol(),MODE_POINT)/10;   
   
   // Print( Symbol() + " Digits " + Digits + " Point " + DoubleToString(Point, 5));
   
   Wpips = MathAbs(NormalizeDouble(Wopen-Bid,Digits)/Point)/10;
   Dpips = MathAbs(NormalizeDouble(Dopen-Bid,Digits)/Point)/10;
   Mpips = MathAbs(NormalizeDouble(Mopen-Bid,Digits)/Point)/10;
   
   if(Digits == 0)
   {
      Wpips = MathAbs(NormalizeDouble(Wopen-Bid,Digits)/Point);
      Dpips = MathAbs(NormalizeDouble(Dopen-Bid,Digits)/Point);
      Mpips = MathAbs(NormalizeDouble(Mopen-Bid,Digits)/Point);
   }
   
   ma50 = iMA(NULL,0,50,0,MODE_SMA,PRICE_OPEN,0);
         
   if(open > Wopen)
   {
      txt1 = " BUY ";         
   }else{
      txt1 = " SELL ";
   }      
   
   if(open > Dopen)
   {
      txt2 = " BUY ";
   }else{
      txt2 = " SELL ";
   }
   
   if(open > Mopen)
   {
      txt3 = " BUY ";
   }else{
      txt3 = " SELL ";
   }   

   if(open > ma50 )
   {
      txt4 = " BUY ";
   }else{
      txt4 = " SELL ";
   }
   
   double PipCost;   
   int Spread;
   
   //Ask=SymbolInfoDouble(Symbol(),SYMBOL_ASK);
   //Bid=SymbolInfoDouble(Symbol(),SYMBOL_BID);   
   Spread=SymbolInfoInteger(Symbol(),SYMBOL_SPREAD);
   PipCost=(MarketInfo(Symbol(),MODE_TICKVALUE) * Point) / MarketInfo(Symbol(),MODE_TICKSIZE);      
   
   double SymbolPoint=MarketInfo(Symbol(),MODE_POINT);
   double TickSize=MarketInfo(Symbol(),MODE_TICKSIZE);
   double TickValue=MarketInfo(Symbol(),MODE_TICKVALUE);
   
   Text0 = Symbol() + " Point: " + Point;
   
   ObjectCreate("signal0",OBJ_LABEL,windowIndex,0,0);
   ObjectSet("signal0",OBJPROP_XDISTANCE,30);
   ObjectSet("signal0",OBJPROP_YDISTANCE,FontSize + 10);
   ObjectSetText("signal0",Text0,FontSize,"Arial", Black);
   
   Text1 = "Trends: [  M: " + txt3 + " W: " + txt2 + " D: " + txt1 + " MA50: " + txt4 + " ]";
    
   ObjectCreate("signal1",OBJ_LABEL,windowIndex,0,0);
   ObjectSet("signal1",OBJPROP_XDISTANCE,30);
   ObjectSet("signal1",OBJPROP_YDISTANCE,(FontSize + 10) * 2);
   ObjectSetText("signal1",Text1,FontSize,"Arial", Black);
         
   Text2 = "MonthPips: " + DoubleToString(Mpips,2) + " WeekPips: " + DoubleToString(Wpips,2) + " DayPips: " + DoubleToString(Dpips,2);
   
   ObjectCreate("signal2",OBJ_LABEL,windowIndex,0,0);
   ObjectSet("signal2",OBJPROP_XDISTANCE,30);
   ObjectSet("signal2",OBJPROP_YDISTANCE,(FontSize + 10) * 3);
   ObjectSetText("signal2",Text2,FontSize,"Arial", Green);
   
   Text3 = "Pip Cost: " + DoubleToString(CalcPipCost(PipCost),Digits + 1) + " Spread: " + DoubleToString(Spread,2) + " Ask: " + DoubleToString(Ask,2) + " Bid: " + DoubleToString(Bid,2);
   
   ObjectCreate("signal3",OBJ_LABEL,windowIndex,0,0);
   ObjectSet("signal3",OBJPROP_XDISTANCE,30);
   ObjectSet("signal3",OBJPROP_YDISTANCE,(FontSize + 10) * 4);
   ObjectSetText("signal3",Text3,FontSize,"Arial", Red);
   
   //--- Indicator window comment
   // Comment(StringFormat("Show prices\nAsk = %G\nBid = %G\nSpread = %d\nPip cost = %G", Ask, Bid, Spread, PipCost);

   return(0);                          
}   

int deinit()
{
   ObjectsDeleteAll(windowIndex); // delete all objects   
   return(0);
}
