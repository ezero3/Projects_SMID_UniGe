class Rettangolo extends Punto implements FiguraDueD
{
	protected double Lunghezza;
	protected double Larghezza;
	
	protected double getLunghezza()
   { return Lunghezza; }
   
   protected double getLarghezza()
   { return Larghezza; }
   
   protected void setLunghezza(double h) throws Exception
   {
	if (h>0) Lunghezza = h;
	else throw new Exception("Tentativo di assegnare lunghezza non positiva");
   }
   
   protected void setLarghezza(double l) throws Exception
   {
	if (l>0) Larghezza = l;
	else throw new Exception("Tentativo di assegnare larghezza non positiva");
   }
   
   public double area()
   {return Lunghezza*Larghezza;}
   
   protected double perimetro()
   {return 2*Lunghezza+2*Larghezza;}
   
   Rettangolo(double x, double y, double h, double l) throws Exception
   {super(x,y); setLunghezza(h); setLarghezza(l);}
   
   protected Punto[] vertici()
   {
	   Punto a[] = new Punto[4];
	   a[0] = new Punto(x,y);
	   a[1] = new Punto(x,y+Lunghezza);
	   a[2] = new Punto(x+Larghezza,y);
	   a[3] = new Punto(x+Larghezza,y+Lunghezza);
	   return a;
   }
   
   /*Funzione per controllare se un punto appartiene ad un rettangolo*/
   public boolean appartiene(Punto p)
   {
	   Punto[] estremi = vertici();
	   if(estremi[0].x<=p.x && p.x<=estremi[2].x && estremi[0].y<=p.y && p.y<=estremi[1].y)
		   return true;
	   else
		   return false;
   }
   
   public String toString()
   { return "Rettangolo con vertice in basso a sinistra (" + x + "," + y + "), di altezza "+getLunghezza()+" e di larghezza "+getLarghezza();}
}