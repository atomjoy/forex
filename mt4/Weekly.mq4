#property copyright     "Atomjoy"
#property link          "https://github.com/atomjoy"
#property version       "1.0"                                                     
#property description   "Week open line."

#property indicator_chart_window
#property indicator_buffers 1
#property indicator_color1 Gold

double Weekopen[];
double line;
double m;

int init()
{
   SetIndexStyle(0,DRAW_LINE,0,3);   
   SetIndexBuffer(0,Weekopen);
   
   string mopen;   
   mopen = "Weekly";  
   
   IndicatorShortName(mopen);
   SetIndexLabel(0,mopen);
   
   //SetIndexDrawBegin(0,1);   
   
   return(0);
}

int deinit()
{   
   ObjectDelete("Weekly");
   return(0);
}
  
int start()
{
   IndicatorShortName("Weekly");
   int counted_bars=IndicatorCounted();
   int limit, i;
   
   if(counted_bars==0)
   {
      //d=Period();
      //if (d>240)return(-1);      
      ObjectCreate("Weekly",OBJ_HLINE,0,0,0);
   }   
  
   if(counted_bars<0) return(-1);
   
   limit=(Bars-counted_bars)-1;
   
   for(i=limit; i>=0; i--)
   {
   
      if(1==TimeDayOfWeek(Time[i]) && 1!=TimeDayOfWeek(Time[i+1]))
      {
         m=Open[i];
         ObjectMove("Weekly Open",0,Time[i],line);
      }
      
      Weekopen[i]=m;
   }
   
   return(0);
}
