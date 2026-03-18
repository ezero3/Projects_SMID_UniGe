import sys

def leggi_punti(nome_file):
    lista_punti=[]
    try:
        with open(nome_file,"r") as file:
            for linea in file:
                if linea:
                    coordinate = linea.split()
                    if len(coordinate) == 2:
                        try:
                            x, y = map(float, coordinate)
                            lista_punti.append((x, y))
                        except ValueError:
                            sys.exit(f"Errore: la linea '{linea}' contiene valori non numerici.")
                    else:
                        sys.exit(f"Errore: la linea '{linea}' non contiene esattamente due numeri.")
    except FileNotFoundError:
        sys.exit(f"Errore: File '{nome_file}' non trovato.")
    if len(lista_punti)<2:
            sys.exit(f"Errore: il file '{nome_file}' contiene meno di due punti.")
    for i in range(len(lista_punti)-1):
        if lista_punti[i][0]>=lista_punti[i+1][0]:
            sys.exit(f"Errore: il file '{nome_file}' contiene due punti con ascissa uguale o i punti non sono ordinati in modo crescente.")
    lista_punti.reverse()
    return lista_punti
 
def controllo(A,P,B):
    if (P[0]-A[0])*(B[1]-A[1])<=(P[1]-A[1])*(B[0]-A[0]):
        return True

def crea_guscio(lista_punti):
    lista_guscio=[]
    MIN=lista_punti.pop()
    lista_guscio.append(MIN)
    while len(lista_punti)!=1:
        P=lista_punti.pop()
        if controllo(lista_guscio[-1],P,lista_punti[-1])==True:
            lista_guscio.append(P)
        else:
            if len(lista_guscio)!=1:
                lista_punti.append(lista_guscio.pop())
    MAX=lista_punti.pop()
    lista_guscio.append(MAX)
    return lista_guscio
 
def scrivi_punti(file_guscio,lista_guscio):
    try:
        with open(file_guscio, 'w') as file:
            for punto in lista_guscio:
                file.write(f"{punto[0]} {punto[1]}\n")
    except IOError:
        sys.exit(f"Errore durante la scrittura su '{nome_file}'.")    

print("Questo programma legge una lista di punti da un file (con ascisse diverse e ordinate in modo crescente) e scrive sul file 'guscio.txt' i punti che appartengono al guscio convesso.")
file_input = input("Inserire il nome del file di input:")            
lista_punti = leggi_punti(file_input)
lista_guscio = crea_guscio(lista_punti)
file_output="guscio.txt"
scrivi_punti(file_output, lista_guscio)
print("Grazie per aver usato il programma!")
