#property copyright     "Atomjoy"
#property link          "https://github.com/atomjoy"
#property version       "1.0"                                                     
#property description   "Month, week and day open lines."

#property indicator_chart_window
#property indicator_buffers 3
#property indicator_color1 Black
#property indicator_color2 DarkOrange
#property indicator_color3 Chartreuse

double dailyopen[];
double weeklyopen[];
double monthopen[];
double line;
double d,w,m;

int init()
{
   SetIndexStyle(0,DRAW_LINE,1,2);
   SetIndexBuffer(0,dailyopen);
   SetIndexStyle(1,DRAW_LINE,1,3);
   SetIndexBuffer(1,weeklyopen);
   SetIndexStyle(2,DRAW_LINE,1,4);
   SetIndexBuffer(2,monthopen);
   
   string dopen, wopen, mopen;
   dopen = "Daily Open";
   wopen = "Weekly Open";
   mopen = "Month Open";
   
   IndicatorShortName(dopen);
   IndicatorShortName(wopen);
   IndicatorShortName(mopen);
   
   SetIndexLabel(0,dopen);
   SetIndexLabel(1,wopen);
   SetIndexLabel(2,mopen);
   
   //SetIndexDrawBegin(0,1);
   //SetIndexDrawBegin(1,1);
   
   return(0);
}

int deinit()
{
   ObjectDelete("Weekly_open");
   ObjectDelete("Daily_open");
   ObjectDelete("Month_open");
   return(0);
}
  
int start()
{
   IndicatorShortName("MonthWeekDayOpen");
   int counted_bars=IndicatorCounted();
   int limit, i;
   
   if(counted_bars==0)
   {
      //d=Period();
      //if (d>240)return(-1);
      ObjectCreate("Weekly_open",OBJ_HLINE,0,0,0);
      ObjectCreate("Daily_open",OBJ_HLINE,0,0,0);
      ObjectCreate("Month_open",OBJ_HLINE,0,0,0);
   }
   
  
   if(counted_bars<0) return(-1);
   
   limit=(Bars-counted_bars)-1;
   
   for(i=limit; i>=0; i--)
   {
      if(1==TimeDayOfWeek(Time[i]) && 1!=TimeDayOfWeek(Time[i+1]))
      {
         w=Open[i];
         ObjectMove("Weekly Open",0,Time[i],line);
      }
      
      if (TimeDay(Time[i]) !=TimeDay(Time[i+1]))
      {
         d=Open[i];
         ObjectMove("Daily Open",0,Time[i],line);
      }
      
      if (TimeMonth(Time[i]) !=TimeMonth(Time[i+1]))
      {
         m=Open[i];
         ObjectMove("Month Open",0,Time[i],line);
      }
      
      weeklyopen[i]=w;
      dailyopen[i]=d;
      monthopen[i]=m;
   }
   
   return(0);
}
