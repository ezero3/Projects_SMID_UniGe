class Nave implements NaveMina
{
	protected Cerchio prua;
	protected Cerchio poppa;
	protected Rettangolo ponte;
	/*Booleani per controllare se è stata colpita prua,poppa o ponte*/
	public boolean statoPoppa;
	public boolean statoPrua;
	public boolean statoPonte;
	/*Intero che conta quante volte è stata colpita una nave*/
	public int N;
	/*Booleano per controllare se è stata affondata una nave(se N è <= di 0 e prua poppa e ponte sono 
	stati colpiti*/
	public boolean statoNave;
	
	/*Costruttore nave: costituita da due cerchi(prua e poppa) di raggio 5 e un rettangolo centrale(ponte) 
	lungo k quadrati 10x10, se entra true la nave viene costruite in orizzontale, se false in verticale*/
	Nave(double x, double y, int k, boolean VersoNave) /*K=1,2,3,4*/
	{
		N=k+1;
		statoPoppa=true;
		statoPrua=true;
		statoPonte=true;
		statoNave=true;
		try
		{
			if(VersoNave)
			{
				ponte= new Rettangolo(x,y,10,k*10);
				poppa= new Cerchio(x,y+5,5);
				prua= new Cerchio(x+k*10,y+5,5);
			}
			else
			{
				ponte= new Rettangolo(x,y,k*10,10);
				poppa= new Cerchio(x+5,y,5);
				prua= new Cerchio(x+5,y+k*10,5);
			}
		}
		catch(Exception e){;}
	}
	
	public double minimaX()
	{return this.poppa.x-this.poppa.getRaggio();}
	
	public double minimaY()
	{return this.poppa.y-this.poppa.getRaggio();}
	
	public double massimaX()
	{return this.prua.x+this.prua.getRaggio();}
	
	public double massimaY()
	{return this.prua.y+this.prua.getRaggio();}
	
	public boolean esiste()
	{
		return statoNave;
	}
	
	public boolean eMina()
	{return false;}
	
	public boolean eNave()
	{return true;}	
	
	/*Funzione che controlla se una nave NON si interseca con un'altra nave*/
	public boolean intersezione(Nave n)
	{
		if(massimaX()<n.minimaX() || n.massimaX()<minimaX() || massimaY()<n.minimaY() || n.massimaY()<minimaY())
			return true;
		else
			return false;
	}
	
	/*Funzione che controlla se una nave NON si interseca con una mina*/
	public boolean intersezione(Mina m)
	{
		if(massimaX()<m.minimaX() || m.massimaX()<minimaX() || massimaY()<m.minimaY() || m.massimaY()<minimaY())
			return true;
		else
			return false;
	}
}