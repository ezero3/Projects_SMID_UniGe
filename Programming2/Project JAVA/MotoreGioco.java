import java.util.Random;
class MotoreGioco implements RequisitiGioco
{
	/*Array che contengono le navi e le mine create*/
	protected Mina[] arrayMine;
	protected Nave[] arrayNavi;
	/*Interi che contano il numero di navi affondate, mine esplose e aerei abbattuti*/
    protected int naviAffondate;
	protected int mineEsplose;
	protected int aereiAbbattuti;
	
	public int numeroAerei()
	{return 4;}
	
	public int numeroNavi()
	{return 10;}
	
	public int numeroMine()
	{return 5;}
	
	/*Costruttore MotoreGioco: crea le navi e le mine e le posiziona in modo corretto*/
	MotoreGioco()
	{
		naviAffondate=0;
		mineEsplose=0;
		aereiAbbattuti=0;
		Random rd = new Random();
		arrayMine= new Mina[numeroMine()];
		arrayNavi= new Nave[numeroNavi()];
		/*Booleano che serve per dire se una mina o una nave è stata posizionata correttamente*/
		boolean controllo=true;
		/*Creazione della prima mina in modo random*/
		arrayMine[0]=new Mina(rd.nextDouble()*94+3,rd.nextDouble()*94+3);
		/*Intero che conta le mine create*/
		int P=1;
		/*Creazione delle restanti 4 mine in modo random controllando ad una ad una che non si intersechi
		con le mine create in precedenza, se va bene crea la successiva se no ricrea quella finchè non va bene*/
		while(P!=numeroMine())
		{
			arrayMine[P]=new Mina(rd.nextDouble()*94+3,rd.nextDouble()*94+3);
			for(int h=1;h<=P;h++)
			{
				if(arrayMine[P].mina.distanza(arrayMine[P-h].mina)<=6)
					controllo=false;
			}
			if(controllo)
				P+=1;
		    else
				controllo=true;
		} 
		/*Intero che conta le nave creati*/
		int R=0;
		/*Booleano a cui viene assegnato un valore random che costruisce la nave in verticale o orizzontale*/
		boolean orizzontale;
		/*Creazione della prima nave di lato 10x10 in posizione random e controllo che la nave non si 
		intersechi con le mine già create, se non va bene ricrea*/
		while(R!=1)
		{
			orizzontale=rd.nextBoolean();
			if(orizzontale)
				arrayNavi[R]=new Nave(rd.nextDouble()*80+5,rd.nextDouble()*90,1,orizzontale);
			else
				arrayNavi[R]=new Nave(rd.nextDouble()*90,rd.nextDouble()*80+5,1,orizzontale);
			for(int e=0;e<numeroMine();e++)
			{
				if(arrayNavi[R].intersezione(arrayMine[e])==false)
					controllo=false;
			}
			if(controllo)
				R+=1;
		    else
				controllo=true;
		}
		int a=80;
		int b=1;
		/*Creazione delle restanti nave in modo randomico, prima quelle 10x10,poi 20x10,30x10 e 40x10, ogni nave
		viene controllata in modo che non si intersechi con le mine e le navi costruite precedentemente, se
		vanno bene R cresce, se no ricrea*/
		while(R!=numeroNavi())
		{
			orizzontale=rd.nextBoolean();
			if(orizzontale)
				arrayNavi[R]=new Nave(rd.nextDouble()*a+5,rd.nextDouble()*90,b,orizzontale);
			else
				arrayNavi[R]=new Nave(rd.nextDouble()*90,rd.nextDouble()*a+5,b,orizzontale);
			for(int h=1;h<=R;h++)
			{
				if(arrayNavi[R].intersezione(arrayNavi[R-h])==false)
					controllo=false;
			}
			for(int e=0;e<numeroMine();e++)
			{
				if(arrayNavi[R].intersezione(arrayMine[e])==false)
					controllo=false;
			}
			/*Quando R arriva a 4 (sono state create le mine 10x10) a e b cambiano in moto che inizi a 
			creare le navi 20x10, quando arriva a 7 inizia a creare le 30x10, quando arriva a 9 crea 
			l'ultima nave 40x10*/
			if(controllo)
			{
				R+=1;
				if(R==4 || R==7 || R==9)
				{
					a-=10; 
					b+=1;
				}
			}
		    else
				controllo=true;
		}
	}
	
	public NaveMina naveNumero(int i)
	{
		if(0<=i && i<numeroNavi())
			return arrayNavi[i];
		else
			return null;
	}
	
	public NaveMina minaNumero(int i)
	{
		if(0<=i && i<numeroMine())
			return arrayMine[i];
		else
			return null;
	}
	
	public int mineRimaste()
	{return numeroMine()-mineEsplose;}
	
	public int naviRimaste()
	{return numeroNavi()-naviAffondate;}
	
	public int aereiRimasti()
	{return numeroAerei()-aereiAbbattuti;}
	
	public NaveMina processaColpo(double x, double y)
	{
		/*Punto in cui viene sparato il colpo*/
		Punto colpo=new Punto(x,y);
		/*Ciclo che controlla che il punto colpito dal colpo appartiene o no ad una mina, se la distanza dal 
		punto e il centro della mina è <=3 allora la mina è stata colpita, lo statoMina diventa falso,
		gli aerei abbattuti e le navi esplose crescono di uno e la funzione ritorna la mina colpita*/
		for(int j=0;j<numeroMine();j++)
		{
			if (arrayMine[j].mina.distanza(colpo)<=3 && arrayMine[j].statoMina)
			{
				arrayMine[j].statoMina=false;
				mineEsplose+=1;
				aereiAbbattuti+=1;
				return arrayMine[j];
			}
		}
		/*Ciclo che controlla se il colpo ha colpito una nave o no, ogni volta che viene colpita una nave
		N scende di uno e la funzione ritorna la nave colpita , se colpisce per la prima volta prua poppa 
		o corpo lo stato della rispettiva parte diventa false, quando viene colpita una nave e tutti i pezzi
		della nave sono falsi e k è <=0 la nave è stata affondata, allora lo statoNave diventa falso e
		le navi affondate crescono di uno*/
		for(int j=0;j<numeroNavi();j++)
		{
			if((arrayNavi[j].poppa.distanza(colpo)<=5 || arrayNavi[j].prua.distanza(colpo)<=5 ||
			    arrayNavi[j].ponte.appartiene(colpo)) && arrayNavi[j].statoNave)
			{
				arrayNavi[j].N-=1;
				if(arrayNavi[j].statoPoppa && arrayNavi[j].poppa.distanza(colpo)<=5)
					arrayNavi[j].statoPoppa=false;
				if(arrayNavi[j].statoPrua && arrayNavi[j].prua.distanza(colpo)<=5)
					arrayNavi[j].statoPrua=false;
				if(arrayNavi[j].statoPonte && arrayNavi[j].ponte.appartiene(colpo))
					arrayNavi[j].statoPonte=false;
				if(arrayNavi[j].N<=0 && arrayNavi[j].statoPoppa==false && arrayNavi[j].statoPrua==false && 
				   arrayNavi[j].statoPonte==false && arrayNavi[j].statoNave)
					{
						arrayNavi[j].statoNave=false;
						naviAffondate+=1;
					}
				return arrayNavi[j];
			}
		}
		/*Se il colpo non colpisce ne una nave ne una mina la funzione ritorna null*/
		return null;
	}
	
	public boolean giocoFinito()
	{
		if( naviRimaste()==0 || aereiRimasti()==0)
			return true;
		else
			return false;
	}
}