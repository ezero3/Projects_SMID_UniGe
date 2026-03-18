class Cerchio extends Punto implements FiguraDueD
{
   protected double raggio;

   public double getRaggio()
   { return raggio; }
   
   protected void setRaggio(double r) throws RaggioErrato
   {
	if (r>=0) raggio = r;
	else throw new RaggioErrato("Tentativo di assegnare raggio negativo");
   }
   
   public double area()
   { return raggio*raggio*Math.PI; }
   
   Cerchio(double x, double y, double r) throws RaggioErrato
   {super(x,y); setRaggio(r);}
   
   Cerchio()
   {super(); raggio= 0.0;}
   
   protected double circonferenza()
   {return 2.0*raggio*Math.PI;}
   
   public String toString()
   { return "Cerchio di centro (" + x + "," + y + ") e raggio "+getRaggio();}
   
   protected boolean eUguale(Cerchio c)
   {return (super.eUguale(c) && (c.raggio==raggio));}
}

  
