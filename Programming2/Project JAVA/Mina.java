class Mina implements NaveMina
{
	protected Cerchio mina;
	/*Booleano che controlla se una mina è esplosa*/
	public boolean statoMina;
	
	/*Costruttore mina: costituita da un cerchio di raggio 3*/
	Mina(double x, double y)
	{
		statoMina=true;
		try{mina= new Cerchio(x,y,3);}
		catch(Exception e){;}
	}
	
	public double minimaX()
	{return this.mina.x-this.mina.getRaggio();}
	
	public double minimaY()
	{return this.mina.y-this.mina.getRaggio();}
	
	public double massimaX()
	{return this.mina.x+this.mina.getRaggio();}
	
	public double massimaY()
	{return this.mina.y+this.mina.getRaggio();}
	
	public boolean esiste()
	{
		return statoMina;
	}
	
	public boolean eMina()
	{return true;}
	
	public boolean eNave()
	{return false;}	
} 