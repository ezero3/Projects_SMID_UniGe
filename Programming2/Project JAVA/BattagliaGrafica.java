import java.awt.*;
import java.awt.event.*;
import javax.swing.*;
import java.awt.geom.*;
import javax.swing.border.*;
import java.io.*;
import java.util.*;

/** Classe che realizza l'interfaccia utente per la nostra
 * versione della battaglia navale.
 * Il quadrato azzurro e' il mare, per sparare bisogna 
 * semplicementre fare click su un punto.
 * I punti dove si e' gia' sparato sono mostrati in blu se
 * finiti in acqua e in rosso se hanno colpito qualcosa.
 * Il punto con cerchi concentrici e' la posizione dell'ultimo
 * sparo. L'esito dell'ultimo sparo e' mostrato anche sul
 * pannello informativo a destra.
 * Normalmente viene mostrata all'utente solo la posizione
 * delle le navi affondate e delle mine gia' scoppiate.
 * Il bottone Mostra serve a fare vedere tutte le navi e 
 * tutte le mine, e non dovrebbe stare nella versione vera 
 * del gioco.
 */
public class BattagliaGrafica extends JPanel 
implements ActionListener, MouseListener, MouseMotionListener
{

// ==================== Parte per interazione con l'utente:

  /** La finestra all'interno della quale si trova questo
   * pannello di disegno. */
  protected JFrame finestra; 
  
  /** Bottone per vedere tutte le navi e le mine. */
  protected JButton bottoneVedere;
  /** Bottone per finire il programma. */
  protected JButton bottoneUscita;
  
  /** Campo che mostra quanti aerei sono rimasti. */
  protected JTextField infoAerei;
  /** Campo che mostra quante navi sono rimaste. */
  protected JTextField infoNavi;
  /** Campo che mostra quante mine sono rimaste. */
  protected JTextField infoMine;
  /** Campo che mostra l'esito dell'ultimo colpo sparato. */
  protected JTextField infoEsito;
  /** Campo che mostra l'esito dell'ultimo colpo sparato
   * (seconda riga se il messaggio e' lungo). */
  protected JTextField infoEsitoBis;

  /** Per mostrare le coordinate correnti del punto in cui
   * si trova il cursore nel pannello di disegno. */
  protected JLabel coordinate;

// ================ Parte per il gioco

  /** Il gioco sottostante. */
  protected RequisitiGioco gioco;
  
  /** Dice se mostrare tutte le navi e le mine. */
  protected boolean mostra = false;
  
  /** Tiene le x di tutti i colpi sparati. */
  protected LinkedList<Double> xSparate;
  /** Tiene le y di tutti i colpi sparati. */
  protected LinkedList<Double> ySparate;
  /** Tiene l'esito di tutti i colpi sparati:
   * true se e solo se e' caduto in acqua. */
  protected LinkedList<Boolean> acqua;
    
// ==================== Parte per interazione con l'utente:
 
  /** Colore per il mare. */ 
  public Color coloreMare  = Color.cyan;
  /** Colore per navi ancora esistenti. */ 
  public Color coloreNaveSi = Color.yellow;
  /** Colore per le navi affondate. */ 
  public Color coloreNaveNo = Color.blue;
  /** Colore per le mine ancora esistenti. */ 
  public Color coloreMinaSi = Color.red;
  /** Colore per le mine scoppiate. */ 
  public Color coloreMinaNo = Color.orange;
  
  /** Colore per il gli spari caduti in acqua. */ 
  public Color coloreInAcqua = Color.blue;
  /** Colore per il gli spari che hanno colpito qualcosa. */ 
  public Color coloreColpito = Color.red;
  
  /** Colore iniziale dello sfondo dei campi di testo. */
  public Color coloreNeutro;
  /** Colore per lo sfondo del campo che mostra l'esito dello sparo. */
  protected Color sfondo;
  
// ================ Parte per il disegno delle figure:

  /* Le coordinate in pixel sono [0,getWidth()] x [0,getHeight()],
  le coordinate reali invece sono
  [0,RequisitiGioco.LATO_MARE] x [0,RequisitiGioco.LATO_MARE]
  quindi bisogna operare una scalatura.  
  Le seguenti funzioni realizzano la trasformazione di coordinate 
  tra coordinare reali e coordinate intere in pixel.
  */
  
  /** Calcola la coordinata x in pixel dove va disegnata la x reale data. */
  int disegnoX(double x)
  {  return (int)(getWidth()*(x/100.0)); }

  /** Calcola la coordinata y in pixel dove va disegnata la y reale data. */
  int disegnoY(double y)
  {  return (int)(getHeight()*(y/100.0)); }

  /** Calcola la coordinata x reale corrispondente alla data x in pixel. */
  double realeX(int x)
  {  return (double)x*100.0/getWidth(); }

  /** Calcola la coordinata y reale corrispondente alla data y in pixel. */
  double realeY(double y)
  {  return (double)y*100.0/getHeight(); }

  /** Funzione ausiliaria chiamata da paintComponent per disegnare le navi. */
  protected void disegnaNavi(Graphics g)
  {
    int i;
    int x1,y1,x2,y2,larg,alte;
    NaveMina elem;
    int num = gioco.numeroNavi();
    for (i=0; i<num; i++)
    {
      elem = gioco.naveNumero(i);
//System.out.println(elem);
      if (!mostra && elem.esiste())
         continue;
      x1 = disegnoX(elem.minimaX());
      y1 = disegnoY(elem.minimaY());
      x2 = disegnoX(elem.massimaX());
      y2 = disegnoY(elem.massimaY());
      larg = x2-x1;
      alte = y2-y1;
      if (larg>alte) // nave orizzontale
      {
         if (elem.esiste()) // disegna l'interno
         {
           g.setColor(coloreNaveSi);
           g.fillArc(x1,y1, alte,alte, 90,360);
           g.fillRect(x1+alte/2,y1, larg-alte, alte);
           g.fillArc(x1+larg-alte,y1, alte,alte,270,360);
           g.setColor(coloreNaveNo);
           // suddivisione in quadretti
           int tratti = (int)(0.2+(double)larg/(double)alte);
           for (int h=0; h<tratti; h++)
              g.drawLine(x1+(int)((h+0.5)*alte),y1, 
                         x1+(int)((h+0.5)*alte),y1+alte);

         }
         // disegna i contorni
         g.setColor(coloreNaveNo);
         g.drawArc(x1,y1, alte,alte, 90,180);
         g.drawLine(x1+alte/2,y1,      x2-alte/2,y1);
         g.drawLine(x1+alte/2,y1+alte, x2-alte/2,y1+alte);
         g.drawArc(x1+larg-alte,y1, alte,alte, 270, 180);
      }
      else // nave verticale
      {
         if (elem.esiste()) // disegna l'interno
         {
            g.setColor(coloreNaveSi);
            g.fillArc(x1,y1, larg,larg, 0, 360);
            g.fillRect(x1,y1+larg/2,  larg, alte-larg);
            g.fillArc(x1,y1+alte-larg, larg,larg, 180, 360);
            g.setColor(coloreNaveNo);
            // suddivisione in quadretti
            int tratti = (int)(0.2+(double)alte/(double)larg);
            for (int h=0; h<tratti; h++)
              g.drawLine(x1,y1+(int)((h+0.5)*larg),
                         x1+larg,y1+(int)((h+0.5)*larg));
         }
         // disegna i contorni
         g.setColor(coloreNaveNo);
         g.drawArc(x1,y1, larg,larg, 0, 180);
         g.drawLine(x1,     y1+larg/2, x1,     y2-larg/2);
         g.drawLine(x1+larg,y1+larg/2, x1+larg,y2-larg/2);
         g.drawArc(x1,y1+alte-larg, larg,larg, 180, 180);
      }
    }
  }

 /** Funzione ausiliaria chiamata da paintComponent per disegnare le mine. */
  protected void disegnaMine(Graphics g)
  {
    Ellipse2D.Double ellisse;
    int i;
    int x1,y1,x2,y2,larg,alte;
    NaveMina elem;
    int num = gioco.numeroMine();
    for (i=0; i<num; i++)
    {
      elem = gioco.minaNumero(i);
//System.out.println(elem);
      if (!mostra && elem.esiste())
         continue;
      x1 = disegnoX(elem.minimaX());
      y1 = disegnoY(elem.minimaY());
      x2 = disegnoX(elem.massimaX());
      y2= disegnoY(elem.massimaY());
      larg = x2-x1; // == y2-y1 poiche' cerchio
      if (elem.esiste()) // disegna l'interno
      {
         g.setColor(coloreMinaSi);
         g.fillArc(x1,y1, larg,larg, 0, 360);
      }
      // disegna il contorno
      g.setColor(coloreMinaNo);
      g.drawArc(x1,y1, larg,larg, 0, 360);
    }
  }

 /** Funzione ausiliaria chiamata da paintComponent per disegnare i colpi sparati. */
  protected void disegnaSpari(Graphics g)
  {
    ListIterator<Double> ix = xSparate.listIterator();
    ListIterator<Double> iy = ySparate.listIterator();
    ListIterator<Boolean> ia = acqua.listIterator();
    for (int i=0; i<acqua.size(); i++)
    {
       double x = ix.next();
       double y = iy.next();
       int mezzaLarg = 2;
       boolean inAcqua = ia.next();
       if (inAcqua)
         g.setColor(coloreInAcqua);
       else
         g.setColor(coloreColpito);
       g.fillArc(disegnoX(x)-mezzaLarg,disegnoY(y)-mezzaLarg,
                 2*mezzaLarg,2*mezzaLarg, 0,360);
       if (i==acqua.size()-1)
       {
         g.drawArc(disegnoX(x)-2*mezzaLarg,disegnoY(y)-2*mezzaLarg,
                   4*mezzaLarg,4*mezzaLarg, 0,360);
         g.drawArc(disegnoX(x)-4*mezzaLarg,disegnoY(y)-4*mezzaLarg,
                   8*mezzaLarg,8*mezzaLarg, 0,360);
       }
    }
  }
  
 /** Soprascrive la funzione di disegno ereditata dalla superclasse
  * JPanel per disegnare lo stato attuale del gioco. */
  public void paintComponent(Graphics g)
  {
    super.paintComponent(g);

    // disegno lo sfondo
    g.setColor(coloreMare);
    g.fillRect(0,0, getWidth(), getHeight());

    disegnaNavi(g);
    disegnaMine(g);
    disegnaSpari(g);
  }

  /** Aggiorna le informazioni secondo l'esito dell'ultimo sparo.
   * Nell'area dell'esito viene cambiato il colore di sfondo. */
  protected void aggiorna(String s, String sBis)
  {
     infoEsito.setBackground(sfondo); 
     if (sBis==null)
     {
        infoEsitoBis.setBackground(coloreNeutro); 
        infoEsito.setText(s + "!");
     }
     else
     {
        infoEsito.setText(s);
        infoEsitoBis.setBackground(sfondo); 
        infoEsitoBis.setText(sBis + "!");
     }
     infoAerei.setText("Hai ancora "+gioco.aereiRimasti()+" aerei");
     infoNavi.setText("Ci sono ancora "+gioco.naviRimaste()+" navi a galla");
     infoMine.setText("Ci sono ancora "+gioco.mineRimaste()+" mine attive");
     if (gioco.giocoFinito())
        removeMouseListener(this); // disabilita il click
  }
  
  
  /** Crea la finestra grafica che contiene questo pannello di disegno
   * e tutti gli elementi per l'interazione con l'utente. */
  protected void creaFinestra()
  {
    coloreNeutro = this.getBackground();
  
    // Parte a destra che mostra le informazioni sul gioco
    JPanel destro = new JPanel(new GridLayout(14,1));
    destro.add(new JLabel("La situazione dell'avversario:"));
    destro.add(infoNavi = new JTextField(25));
    destro.add(infoMine = new JTextField(25));
    destro.add(new JLabel());
    destro.add(new JLabel("La tua situazione:"));
    destro.add(infoAerei = new JTextField(25));
    destro.add(infoEsito = new JTextField(25));
    destro.add(infoEsitoBis = new JTextField(25));
    infoAerei.setEditable(false);
    infoNavi.setEditable(false);
    infoMine.setEditable(false);
    infoEsito.setEditable(false);
    infoEsitoBis.setEditable(false);
    destro.add(new JLabel());
    destro.add(new JLabel());
    destro.add(new JLabel());
    destro.add(new JLabel());
    if (mostra) bottoneVedere = new JButton("Nascondi");
    else bottoneVedere = new JButton("Mostra");
    destro.add(bottoneVedere);
    destro.add(bottoneUscita = new JButton("Termina"));

    // Parte inferiore con le coordinate del cursore 
    JPanel sotto = new JPanel(new FlowLayout());
    sotto.add(new JLabel("Posizione del cursore: "));
    sotto.add(coordinate = new JLabel("(0,0)"));

    // Parte al centro per contenere questo pannello grafico
    JPanel intorno = new JPanel(new BorderLayout());
    intorno.setBorder(new LineBorder(Color.blue,2));
    this.setPreferredSize(new Dimension(4*RequisitiGioco.LATO_MARE,
                                        4*RequisitiGioco.LATO_MARE));
    intorno.add(this, BorderLayout.CENTER);
        
    // Composizione della finestra
    finestra = new JFrame();
    finestra.setTitle("Battaglia navale rivisitata");
    finestra.getContentPane().setLayout(new BorderLayout());
    finestra.getContentPane().add(BorderLayout.EAST, destro);
    finestra.getContentPane().add(BorderLayout.SOUTH, sotto);
    finestra.getContentPane().add(BorderLayout.CENTER, intorno);
    finestra.pack();
  }
  
  /** Collega gli event listener per reagire alle sollecitazioni
   * dell'utente: il click sul pannello e i due bottoni. */
  protected void allacciaEventi()
  {
    // Bottoni
    bottoneVedere.addActionListener(this);
    bottoneUscita.addActionListener(this);

    // Interazione col mouse per sparare
    addMouseListener(this);
    addMouseMotionListener(this);
  }

// ===== Mouse e MouseMotionListener per il pannello di disegno (this)

  /** Necessario per implementare MouseListener, non fa nulla. */
  public void mouseEntered(MouseEvent ev) {}
  /** Necessario per implementare MouseListener, non fa nulla. */
  public void mouseExited(MouseEvent ev) {}
  /** Necessario per implementare MouseListener, non fa nulla. */
  public void mousePressed(MouseEvent ev) {}
  /** Necessario per implementare MouseListener, non fa nulla. */
  public void mouseReleased(MouseEvent ev) {}
  /** Necessario per implementare MouseListener, non fa nulla. */
  public void mouseDragged(MouseEvent ev) {} 

  /** Necessario per implementare MouseListener, definisce che cosa
   * succede quando l'utente fa click sul pannello di disegno. */
  public void mouseClicked(MouseEvent ev)
  {
     double x = realeX(ev.getX());
     double y = realeY(ev.getY());
//System.out.print("colpo in "+x+","+y+" --> ");
    
     // salvo quante navi c'erano prima del colpo in (x,y)
     int nNavi = gioco.naviRimaste();
     // processo lo sparo
     NaveMina esito = gioco.processaColpo(x,y);
     
     // aggiorno la situazione
     xSparate.add(x);
     ySparate.add(y);
     acqua.add(esito==null);
     String s = null, sBis = null;
     
     if (esito==null) // acqua
     {
         s = "Buco nell'acqua";
         sfondo = Color.cyan;
     }
     else if (esito.eMina()) // mina
     {
         s = "Hai centrato una mina e perdi un aereo";
         if (gioco.giocoFinito())
         {
           sBis = "ed era l'ultimo: HAI PERSO";
           sfondo = Color.red;
         }
         else
           sfondo = Color.orange;
     }    
     else // nave
     if (nNavi>gioco.naviRimaste())
     {
         s = "Hai affondato una nave";
         if (gioco.giocoFinito())
         {  sBis = "ed era l'ultima: hai VINTO";
            sfondo = Color.green;
         }
         else 
            sfondo = Color.yellow;
     }
     else 
     {
         s = "Hai colpito una nave";
         sfondo = Color.magenta;
     }
     aggiorna(s,sBis);
     repaint();
  }

  /** Necessaria per implementare MouseMotionListener, definisce che cosa
   * succede quando l'utente nuove il mouse sul pannello di disegno.
   * (aggiorna le coordinate del mouse mostrate in basso). */
  public void mouseMoved(MouseEvent ev)
  {
    coordinate.setText("("+(int)realeX(ev.getX())+","+(int)realeY(ev.getY())+")"); 
  } 
  
// ======================== ActionListener per i bottoni

  /** Necessario per implementare ActionListener, stabilisce
   * che cosa succede quando l'utente fa click sui bottoni. */
  public void actionPerformed(ActionEvent ev)
  {
    if (ev.getSource()==bottoneVedere)
    {
       mostra = !mostra;
       if (mostra) 
         bottoneVedere.setText("Nascondi");
       else
         bottoneVedere.setText("Mostra");
       // e' necessario ridisegnare
       repaint();
    }
    else if (ev.getSource()==bottoneUscita)
    {
       System.exit(0);
    }
  }

// ================ Costruttore
  
  /** Costruisce il pannello di disegno 
   * che non contiene nessuna figura da disegnare,
   * costruisce anche la finestra che lo contiene con tutti
   * gli elementi per gestire l'interazione con l'utente.<BR>
   * QUI DOVETE INTERVENIRE PER COLLEGARE LA VOSTRA CLASSE
   * CHE IMPLEMENTA L'UNTERFACCIA RequisitiGioco */
  public BattagliaGrafica()
  {
    // ************* CAMBIARE LA RIGA QUI SOTTO
    gioco = new MotoreGioco();
    // ************* CAMBIARE LA RIGA QUI SOPRA

    xSparate = new LinkedList<Double>();
    ySparate = new LinkedList<Double>();
    acqua = new LinkedList<Boolean>();
    creaFinestra();
    allacciaEventi();
    aggiorna("Non e' ancora stato sparato un colpo",null);
    finestra.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
    finestra.setVisible(true);
  }  

// =================== MAIN
  
  /** Fa partire il programma. */
  public static void main(String[] arg)
  {
    if (arg.length>0)
        System.out.println("Gli argomenti forniti "
        + "sulla linea di comando vengono ignorati.");
    BattagliaGrafica dis = new BattagliaGrafica();
  }
    
}