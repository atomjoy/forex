#property copyright   "Atomjoy"
#property link        "https://github.com/atomjoy"
#property version     "1.0"                                                     
#property description "100 Pip levels."

#property indicator_chart_window

extern int       GridWeeks=10;            // Period over which to calc High/Low of gird
extern int       GridPips=100;            // Size of grid in Pips
extern color     LineColor1=Black;        // Color of grid
extern color     LineColor2=DodgerBlue;   // Every 100 pips, change grid color to this.
extern int       LineWidth=2;

bool firstTime = true;
datetime lastTime = 0;

//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+

int start()
  {
   IndicatorShortName("100Pips");
   int counted_bars=IndicatorCounted();
   
   /* lastTime == 0 || CurTime() - lastTime > 5 */
   if ( true ) {
      firstTime = false;
      lastTime = CurTime();
      
      if ( GridWeeks > 0 && GridPips > 0 ) {
         double weekH = iHigh( NULL, PERIOD_W1, 0 );
         double weekL = iLow( NULL, PERIOD_W1, 0 );
         
         for ( int i = 1; i < GridWeeks; i++ ) {
            weekH = MathMax( weekH, iHigh( NULL, PERIOD_W1, i ) );
            weekL = MathMin( weekL, iLow( NULL, PERIOD_W1, i ) );
         }
      
         double pipRange = GridPips * Point;
         if ( Symbol() == "GOLD" )
            pipRange = pipRange * 10.0;

         double topPips = (weekH + pipRange) - MathMod( weekH, pipRange );
         double botPips = weekL - MathMod( weekL, pipRange );
      
         for ( double p = botPips; p <= topPips; p += pipRange ) {
            string gridname = "Horizontal_line_" + DoubleToStr( p, Digits );
            ObjectCreate( gridname, OBJ_HLINE, 0, 0, p );
            
            double pp = p / Point;
            int pInt = MathRound( pp );
            int mod = 100;
            
            if ( Symbol() == "GOLD" )
               mod = 1000;
               
            if ( (pInt % mod) == 0 ) {
               ObjectSet( gridname, OBJPROP_COLOR, LineColor2 );
               ObjectSet( gridname, OBJPROP_STYLE, STYLE_SOLID );
             } else {
               ObjectSet( gridname, OBJPROP_COLOR, LineColor1 );
               ObjectSet( gridname, OBJPROP_STYLE, STYLE_DASH );
             }
               
            // Style line
            ObjectSet( gridname, OBJPROP_BACK, false ); // Show line labels
            ObjectSet( gridname, OBJPROP_PRICE1, p );            
            ObjectSet( gridname, OBJPROP_WIDTH, LineWidth );
         }
      }            
   } 

   return(0); 
} 

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+

int init()
{
   firstTime = true;
   return(0);
}

//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+

int deinit()
{
   for ( int i = ObjectsTotal() - 1; i >= 0; i-- ) {
      string name = ObjectName( i );
      if ( StringFind( name, "Horizontal_line_" ) >= 0 ) 
         ObjectDelete( name );
   }

   return(0);
}
