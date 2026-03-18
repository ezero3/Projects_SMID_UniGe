class Punto
{
   protected double x, y;

   Punto(double xx, double yy)
   { x = xx; y = yy; }
   
   Punto()
   {x = y =0;}

   protected double distanza()
   { return Math.sqrt(x*x+ y*y); }
   
   /*Funzione che calcola la distanza tra due punti o tra il centro di due cerchi,
   non essendoci la funzione distanza nella classe cerchio.*/
   public double distanza(Punto p)
   { return Math.sqrt((x-p.x)*(x-p.x)+ (y-p.y)*(y-p.y)); }
   
   public String toString()
   { return "Punto (" + x + "," + y + ")";}
   
   protected boolean eUguale(Punto p)
   {return ( (p.x==x) && (p.y==y) );}
}

class RaggioErrato extends Exception
   {
     public RaggioErrato(String messaggio) 
     {super(messaggio);}
   }