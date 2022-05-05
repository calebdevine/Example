SET NAMES latin1;
SET FOREIGN_KEY_CHECKS = 0;

BEGIN;
CREATE DATABASE IF NOT EXISTS `eDevice`; 
COMMIT;

/* Area Produzione *************************************************************************************/
USE `eDevice`;

-- PARTE(nome, prezzo, coeffSvalutazione, assemblata)
DROP TABLE IF EXISTS `Parte`;
CREATE TABLE `Parte` (
	nome char(100) NOT NULL,
	prezzo int NOT NULL,
    coeffSvalutazione int NOT NULL,
    assemblata boolean NOT NULL,
    PRIMARY KEY (nome)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- MATERIALE(nome, peso)
DROP TABLE IF EXISTS `Materiale`;
CREATE TABLE `Materiale` (
	nome char(100) NOT NULL,
	peso int NOT NULL,
    PRIMARY KEY (nome)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- COSTITUZIONE(materiale, parte)
DROP TABLE IF EXISTS `Costituzione`;
CREATE TABLE `Costituzione` (
	materiale char(100) NOT NULL,
	parte char(100) NOT NULL,
    PRIMARY KEY (materiale, parte),
    FOREIGN KEY (materiale) REFERENCES Materiale(nome),
    FOREIGN KEY (parte) REFERENCES Parte(nome)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- OPERAZIONE(idOperazione, faccia, precedenza)
DROP TABLE IF EXISTS `Operazione`;
CREATE TABLE `Operazione` (
	idOperazione int NOT NULL auto_increment,
	faccia char(100) NOT NULL,
    precedenza int NOT NULL,
    PRIMARY KEY (idOperazione)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 auto_increment=1;

-- MONTAGGIO(parte, idOperazione)
DROP TABLE IF EXISTS `Montaggio`;
CREATE TABLE `Montaggio` (
	parte char(100) NOT NULL,
	idOperazione int NOT NULL,
    PRIMARY KEY (idOperazione, parte),
    FOREIGN KEY (idOperazione) REFERENCES Operazione(idOperazione),
    FOREIGN KEY (parte) REFERENCES Parte(nome)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- GIUNZIONI(nome, tipo, caratteristica)
DROP TABLE IF EXISTS `Giunzioni`;
CREATE TABLE `Giunzioni` (
	nome char(100) NOT NULL,
	tipo char(100) NOT NULL,
    caratteristiche text,
    PRIMARY KEY (nome)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ASSEMBLAGGIO(giunzione, idOperazione)	
DROP TABLE IF EXISTS `Assemblaggio`;
CREATE TABLE `Assemblaggio` (
	giunzione char(100) NOT NULL,
	idOperazione int NOT NULL,
    PRIMARY KEY (idOperazione, giunzione),
    FOREIGN KEY (idOperazione) REFERENCES Operazione(idOperazione),
    FOREIGN KEY (giunzione) REFERENCES Giunzioni(nome)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- UTENSILI(nome, caratteristiche)
DROP TABLE IF EXISTS `Utensile`;
CREATE TABLE `Utensile` (
	nome char(100) NOT NULL,
    caratteristiche text,
    PRIMARY KEY (nome)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- UTILIZZO(utensile, idOperazione)
DROP TABLE IF EXISTS `Utilizzo`;
CREATE TABLE `Utilizzo` (
	utensile char(100) NOT NULL,
	idOperazione int NOT NULL,
    PRIMARY KEY (utensile, idOperazione),
    FOREIGN KEY (utensile) REFERENCES Utensile(nome),
    FOREIGN KEY (idOperazione) REFERENCES Operazione(idOperazione)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- LOTTO(codLotto, sede, tipo, durataPreventiva, durataEffettiva)
DROP TABLE IF EXISTS `Lotto`;
CREATE TABLE `Lotto` (
	codLotto int NOT NULL auto_increment,
    durataEffettiva int,
    durataPreventiva int NOT NULL,
	sede char(100) NOT NULL,
    tipo char(100),             -- refurbishemnt/nuovo/reso
    categoria char(100),        -- nome prodotto
    PRIMARY KEY(codLotto)
)ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1;

-- MAGAZZINO (codMagazzino, capienza, predisposizione)
DROP TABLE IF EXISTS `Magazzino`;
CREATE TABLE `Magazzino` (
	codMagazzino int NOT NULL auto_increment,
    capienza int NOT NULL,  -- metri quadri
	predisposizione char(100) NOT NULL,
    PRIMARY KEY(codMagazzino)
)ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1;

-- AREA(codArea, nPezzi, codMagazzino)
DROP TABLE IF EXISTS `Area`;
CREATE TABLE `Area` (
	codArea int NOT NULL auto_increment,
    nPezzi int,
    codMagazzino int NOT NULL,
    PRIMARY KEY(codArea, codMagazzino),
    FOREIGN KEY(codMagazzino) REFERENCES Magazzino(codMagazzino)
)ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1;

-- UBICAZIONE(codArea, codLotto, dataInizioUbicazione, dataFineUbicazione)
DROP TABLE IF EXISTS `Ubicazione`;
CREATE TABLE `Ubicazione` (
	codArea int NOT NULL ,
    codLotto int NOT NULL,
    dataInizioUbicazione date NOT NULL,
    dataFineUbicazione date,
    PRIMARY KEY(codArea, codLotto),
    FOREIGN KEY(codLotto) REFERENCES Lotto(codLotto),
    FOREIGN KEY(codArea) REFERENCES Area(codArea)
)ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- PRODOTTO(codSeriale, nome, marca, modello, facce, costo, dataProduzione, codLotto)
DROP TABLE IF EXISTS `Prodotto`;
CREATE TABLE `Prodotto` (
    codSeriale INT NOT NULL AUTO_INCREMENT,
    nome CHAR(100) NOT NULL,
    marca CHAR(100) NOT NULL,
    modello CHAR(100) NOT NULL,
    prezzo INT NOT NULL,
    nFacce INT NOT NULL,
    codLotto INT NOT NULL,
    dataProduzione date NOT NULL,
    tipo CHAR(100) NOT NULL,
    PRIMARY KEY (codSeriale),
    FOREIGN KEY (codLotto) REFERENCES Lotto (codLotto)
)  ENGINE=INNODB DEFAULT CHARSET=LATIN1 AUTO_INCREMENT=1;

-- RIPARTIZIONE(prodotto, parte)
DROP TABLE IF EXISTS `Ripartizione`;
CREATE TABLE `Ripartizione` (
	codSeriale int NOT NULL,
	parte char(100) NOT NULL,
    PRIMARY KEY (codSeriale, parte),
    FOREIGN KEY (codSeriale) REFERENCES Prodotto(codSeriale),
    FOREIGN KEY (parte) REFERENCES Parte(nome)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- VARIANTI(colore, dimensione)
DROP TABLE IF EXISTS `Variante`;
CREATE TABLE `Variante` (
	colore char(100) NOT NULL,
	dimensione char(100) NOT NULL,
    PRIMARY KEY (colore, dimensione)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- DIVERSIFICAZIONE(codSeriale, colore, dimensione)
DROP TABLE IF EXISTS `Diversificazione`;
CREATE TABLE `Diversificazione` (
	colore char(100) NOT NULL,
	dimensione char(100) NOT NULL,
	codSeriale int NOT NULL,
    PRIMARY KEY (colore, dimensione, codSeriale),
 /*   FOREIGN KEY (colore) REFERENCES Variante(colore),
    FOREIGN KEY (dimensione) REFERENCES Variante(dimensione),*/
    FOREIGN KEY (codSeriale) REFERENCES Prodotto(codSeriale)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- LINEA(codLinea, tempo, sequenza, codLotto)
DROP TABLE IF EXISTS `Linea`;
CREATE TABLE `Linea` (
	codLinea int NOT NULL auto_increment,
    sequenza int,
	tempo int NOT NULL,
	codLotto int NOT NULL,
    PRIMARY KEY (codLinea),
    FOREIGN KEY (codLotto) REFERENCES Lotto(codLotto)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 auto_increment=1;

-- STAZIONE(codStazione, tempoMedio, orientazione, codLinea)
DROP TABLE IF EXISTS `Stazione`;
CREATE TABLE `Stazione` (
	codStazione int NOT NULL auto_increment,
	codLinea int NOT NULL,
    orientazione char(100) NOT NULL,
    tempoMedio int NOT NULL,
    PRIMARY KEY (codStazione, codLinea),
    FOREIGN KEY (codLinea) REFERENCES Linea(codLinea)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 auto_increment=1;

-- ESECUZIONE(idOperazione, codStazione, ranking, fallimento)
DROP TABLE IF EXISTS `Esecuzione`;
CREATE TABLE `Esecuzione` (
	codStazione int NOT NULL,
	idOperazione int NOT NULL,
    fallimenti int,
    ranking int NOT NULL,
    PRIMARY KEY (codStazione, idOperazione),
    FOREIGN KEY (codStazione) REFERENCES Stazione(codStazione),
    FOREIGN KEY (idOperazione) REFERENCES Operazione(idOperazione)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- UNITA’ PERSE(nomeParte, codStazione, quantità)
DROP TABLE IF EXISTS `UnitaPerse`;
CREATE TABLE `UnitaPerse` (
	parte char(100) NOT NULL,
	quantita int NOT NULL,
    stazione int NOT NULL,
    PRIMARY KEY (parte,stazione),
	FOREIGN KEY (stazione) REFERENCES Stazione(codStazione),
    FOREIGN KEY (parte) REFERENCES Parte(nome)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- OPERATORE(matricola, nome, cognome, reparto)
DROP TABLE IF EXISTS `Operatore`;
CREATE TABLE `Operatore` (
	matricola int NOT NULL auto_increment,
	nome char(100) NOT NULL,
    cognome char(100) NOT NULL,
    reparto char(100) NOT NULL,
    PRIMARY KEY (matricola)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 auto_increment=1;

-- LAVORO(matricola, codStazione, dataInizio, dataFine)
DROP TABLE IF EXISTS `Lavoro`;
CREATE TABLE `Lavoro` (
	matricola int NOT NULL,
	codStazione int NOT NULL,
    dataInizio date,
    dataFine date,
    PRIMARY KEY (matricola, codStazione),
    FOREIGN KEY (codStazione) REFERENCES Stazione(codStazione),
    FOREIGN KEY (matricola) REFERENCES Operatore(matricola)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/* Area Vendita *************************************************************************************/


-- UTENTE(codFiscale, nome, cognome, numero, dataIscrizione)
DROP TABLE IF EXISTS `Utente`;
CREATE TABLE `Utente` (
	codFiscale char(100) NOT NULL,
	cognome char(100) NOT NULL,
	nome char(100) NOT NULL,
    numero char(10) NOT NULL,
    dataIscrizione date NOT NULL,
    PRIMARY KEY (`codFiscale`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- DOMICILIO(codFiscale, CAP, via, numeroCivico, città, nazione)
DROP TABLE IF EXISTS `Domicilio`;
CREATE TABLE `Domicilio` (
    via char(100) NOT NULL,
    numeroCivico int NOT NULL,
    codFiscale char(100) NOT NULL,
    cap int NOT NULL,
    citta char(100),
    nazione char(100),
    PRIMARY KEY (via, numeroCivico, cap, citta, nazione),
    FOREIGN KEY(codFiscale) REFERENCES Utente(codFiscale)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- DOCUMENTO(codDocumento, tipo, datascadenza, codFiscale)
DROP TABLE IF EXISTS `Documento`;
CREATE TABLE `Documento` (
	codDocumento char(100) NOT NULL,					
    tipo char(100) NOT NULL,
    dataScadenza date NOT NULL,
    codFiscale char(100) NOT NULL,
    PRIMARY KEY (codDocumento),
    FOREIGN KEY(codFiscale) REFERENCES Utente(codFiscale)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ACCOUNT(username, password, domandaSicurezza, risposta, codFiscale)
DROP TABLE IF EXISTS `Account`;
CREATE TABLE `Account` (
	username char(100) NOT NULL,
	codFiscale char(100) NOT NULL,
	passwordAccount char(100) NOT NULL,			-- password 
	domandaSicurezza char(100) NOT NULL,
    risposta char(100) NOT NULL,
    PRIMARY KEY (username),
    FOREIGN KEY(codFiscale) REFERENCES Utente(codFiscale)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ORDINE(codOrdine, istanteOrdine, stato, account)	 account -> username per comodità	
DROP TABLE IF EXISTS `Ordine`;
CREATE TABLE `Ordine` (
	codOrdine int NOT NULL auto_increment,
    istanteOrdine timestamp NOT NULL, 
	username char(100) NOT NULL,
    stato char(100) NOT NULL,
    PRIMARY KEY (codOrdine),
    FOREIGN KEY(username) REFERENCES `Account`(username)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1;

-- ACQUISTO(codOrdine, codProdotto)
DROP TABLE IF EXISTS `Acquisto`;
CREATE TABLE `Acquisto` (
	codOrdine int NOT NULL,
    codSeriale int NOT NULL, 
    PRIMARY KEY (codOrdine, codSeriale),
	FOREIGN KEY(codOrdine) REFERENCES Ordine(codOrdine),
	FOREIGN KEY(codSeriale) REFERENCES Prodotto(codSeriale)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- SCONTO(codSconto, evento, percentuale)
DROP TABLE IF EXISTS `Sconto`;
CREATE TABLE `Sconto` (
	codSconto int NOT NULL auto_increment,
	evento char(100) NOT NULL,
    percentuale int NOT NULL,
    PRIMARY KEY (codSconto)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1;

-- RIDUZIONE(codOrdine, codSconto)
DROP TABLE IF EXISTS `Riduzione`;
CREATE TABLE `Riduzione` (
	codOrdine int NOT NULL,
    codSconto int NOT NULL, 
    PRIMARY KEY (codOrdine, codSconto),
	FOREIGN KEY(codOrdine) REFERENCES Ordine(codOrdine),
	FOREIGN KEY(codSconto) REFERENCES Sconto(codSconto)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- SPEDIZIONE(codSpedizione, stato, arrivoPrevisto, codOrdine)	
DROP TABLE IF EXISTS `Spedizione`;
CREATE TABLE `Spedizione` (
    codSpedizione int NOT NULL auto_increment,		
    stato char(100) NOT NULL,
    arrivoPrevisto timestamp NOT NULL,
    codOrdine int NOT NULL,
    PRIMARY KEY (codSpedizione),
    FOREIGN KEY(codOrdine) REFERENCES Ordine(codOrdine)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1;

-- HUB(codHub, località)
DROP TABLE IF EXISTS `Hub`;
CREATE TABLE `Hub` (
    codHub int NOT NULL auto_increment,
    località char(100) NOT NULL, 
    PRIMARY KEY (codHub)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1;

-- PASSAGGIO(codSpedizione, codHub, istante)
DROP TABLE IF EXISTS `Passaggio`;
CREATE TABLE `Passaggio` (
    codSpedizione int NOT NULL,
    codHub int NOT NULL,
    istante timestamp NOT NULL,	-- al posto di data e ora
    PRIMARY KEY (codSpedizione, codHub),
	FOREIGN KEY(codHub) REFERENCES Hub(codHub),
    FOREIGN KEY(codSpedizione) REFERENCES Spedizione(codSpedizione)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1;

-- RECENSIONE(codRecensione, commento, voto, codSeriale)
DROP TABLE IF EXISTS `Recensione`;
CREATE TABLE `Recensione` (
	codRecensione int NOT NULL auto_increment,
	codSeriale int NOT NULL,
    voto int,
    commento text,
    PRIMARY KEY (codRecensione),
    FOREIGN KEY(codSeriale) REFERENCES Prodotto(codSeriale)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1;

-- MOTIVAZIONE(codMotivazione, nome, descrizione)
DROP TABLE IF EXISTS `Motivazione`;
CREATE TABLE `Motivazione` (
	codMotivazione int NOT NULL auto_increment,
	nome char(100) NOT NULL,
    descrizione text,
    PRIMARY KEY (codMotivazione)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1;

-- DIFETTO(codDifetto, nome, descrizione)
DROP TABLE IF EXISTS `Difetto`;
CREATE TABLE `Difetto` (
	codDifetto int NOT NULL auto_increment,
	nome char(100) NOT NULL,
    descrizione text,
    PRIMARY KEY (codDifetto)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1;

-- RESTITUZIONE(codRestituzione, codProdotto, accettata, dataRichiesta, codMotivazione, codDifetto)
DROP TABLE IF EXISTS `Restituzione`;
CREATE TABLE `Restituzione` (
	codRestituzione int NOT NULL auto_increment,
	codSeriale int NOT NULL,
    accettata boolean,
    dataRichiesta date NOT NULL,
    codMotivazione int,
    codDifetto int,
    PRIMARY KEY (codRestituzione),
    FOREIGN KEY(codMotivazione) REFERENCES Motivazione(codMotivazione),
    FOREIGN KEY(codDifetto) REFERENCES Difetto(codDifetto)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1;

-- FORMULA(codFormula, costo, durata)
DROP TABLE IF EXISTS `Formula`;
CREATE TABLE `Formula` (
	codFormula int NOT NULL auto_increment,
    costo int,
    durata int NOT NULL,
    PRIMARY KEY (codFormula)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1;

-- GARANZIA(codGaranzia, durata)
DROP TABLE IF EXISTS `Garanzia`;
CREATE TABLE `Garanzia` (
    codGaranzia int NOT NULL auto_increment,
	durata int NOT NULL,						-- in mesi
    codFormula int,
    PRIMARY KEY (codGaranzia),
    FOREIGN KEY(codFormula) REFERENCES Formula(codFormula)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1;

-- VALENZA(codSeriale, codGaranzia)
DROP TABLE IF EXISTS `Valenza`;
CREATE TABLE `Valenza` (
    codGaranzia int NOT NULL,
	codSeriale int NOT NULL,
    PRIMARY KEY (codGaranzia, codSeriale),
	FOREIGN KEY(codGaranzia) REFERENCES Garanzia(codGaranzia),
    FOREIGN KEY(codSeriale) REFERENCES Prodotto(codSeriale)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- CLASSE DI GUASTO(nome, descrizione)
DROP TABLE IF EXISTS `ClasseGuasto`;
CREATE TABLE `ClasseGuasto` (
	nome char(100) NOT NULL,
	descrizione text NOT NULL,
    PRIMARY KEY (nome)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- COPERTURA(codFormula, classeGuasto)
DROP TABLE IF EXISTS `Copertura`;
CREATE TABLE `Copertura` (
    codGaranzia int NOT NULL,
	classeGuasto char(100) NOT NULL,
    PRIMARY KEY (codGaranzia, classeGuasto),
	FOREIGN KEY(codGaranzia) REFERENCES Garanzia(codGaranzia),
    FOREIGN KEY(classeGuasto) REFERENCES ClasseGuasto(nome)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/* area Assistenza *************************************************************************************/


-- GUASTO(codGuasto, descrizione, codProdotto)
DROP TABLE IF EXISTS `Guasto`;
CREATE TABLE `Guasto` (
	codGuasto int NOT NULL auto_increment,
    codSeriale int NOT NULL,
    descrizione text,
    classeGuasto char(100),
    PRIMARY KEY (codGuasto),
    FOREIGN KEY(codSeriale) REFERENCES Prodotto(codSeriale),
    FOREIGN KEY(classeGuasto) REFERENCES ClasseGuasto(nome)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1;

-- CODICE D’ERRORE(codiceErrore, descrizione)
DROP TABLE IF EXISTS `CodErrore`;
CREATE TABLE `CodErrore` (
	codErrore int NOT NULL auto_increment,
    descrizione text,
    PRIMARY KEY (codErrore)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1;

-- DETTAGLIO(codGuasto, codiceErrore)
DROP TABLE IF EXISTS `Dettaglio`;
CREATE TABLE `Dettaglio` (
	codErrore int NOT NULL,
    codGuasto int NOT NULL,
    PRIMARY KEY (codErrore, codGuasto),
    FOREIGN KEY(codErrore) REFERENCES CodErrore(codErrore),
    FOREIGN KEY(codGuasto) REFERENCES Guasto(codGuasto)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- DOMANDA(codDomanda, testo)
DROP TABLE IF EXISTS `Domanda`;
CREATE TABLE `Domanda` (
	codDomanda int NOT NULL auto_increment,
    testo text,
    PRIMARY KEY (codDomanda)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1;

-- ASSISTENZA VIRTUALE(codDomanda, codGuasto)
DROP TABLE IF EXISTS `AssistenzaVirtuale`;
CREATE TABLE `AssistenzaVirtuale` (
	codDomanda int NOT NULL,
    codGuasto int NOT NULL,
    PRIMARY KEY (codDomanda, codGuasto),
    FOREIGN KEY(codDomanda) REFERENCES Domanda(codDomanda),
    FOREIGN KEY(codGuasto) REFERENCES Guasto(codGuasto)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- RIMEDIO(codRimedio, testo)
DROP TABLE IF EXISTS `Rimedio`;
CREATE TABLE `Rimedio` (
	codRimedio int NOT NULL auto_increment,
    testo text,
    PRIMARY KEY (codRimedio)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1;

-- RISPOSTA(codDomanda, codRimedio) 
DROP TABLE IF EXISTS `Risposta`;
CREATE TABLE `Risposta` (
	codDomanda int NOT NULL,
    codRimedio int NOT NULL,
    PRIMARY KEY (codDomanda, codRimedio),
    FOREIGN KEY(codDomanda) REFERENCES Domanda(codDomanda),
    FOREIGN KEY(codRimedio) REFERENCES Rimedio(codRimedio)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ORARIO(codOrario, giornoInizio, giornoFine, oraInizio, oraFine)
DROP TABLE IF EXISTS `Orario`;
CREATE TABLE `Orario` (
	codOrario int NOT NULL auto_increment,
	giornoInizio int NOT NULL, -- 1 = lunedi
	giornoFine int NOT NULL, -- 2 = martedi
	oraInizio time NOT NULL,
	oraFine time NOT NULL,
    PRIMARY KEY (codOrario)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1;

-- CENTRO ASSISTENZA(nome, località)
DROP TABLE IF EXISTS `CentroAssistenza`;
CREATE TABLE `CentroAssistenza` (
    nome char(100) NOT NULL,
	localita char(100) NOT NULL,
    PRIMARY KEY (nome)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- TECNICO(matricola, nome, cognome, categoriaProd, centroAssistenza, orario, pagaOraria)
DROP TABLE IF EXISTS `Tecnico`;
CREATE TABLE `Tecnico` (
	matricola int NOT NULL auto_increment,
	nome char(100) NOT NULL,
	cognome char(100) NOT NULL,
	categoriaProd char(100) NOT NULL,
	centroAssistenza char(100) NOT NULL,
    orario int NOT NULL,
    pagaOraria int NOT NULL,
    PRIMARY KEY (matricola),
    FOREIGN KEY(centroAssistenza) REFERENCES CentroAssistenza(nome),
    FOREIGN KEY(orario) REFERENCES Orario(codOrario)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1;		

-- INTERVENTO(ticket, descrizioneSoluzione, oreLavoro, dataInizio, dataFine, codGuasto, tecnico)	
DROP TABLE IF EXISTS `Intervento`;
CREATE TABLE `Intervento` (
	ticket int NOT NULL auto_increment,
    codGuasto int NOT NULL,
	dataInizio date,
	dataFine date,
	tecnico int NOT NULL,
    oreLavoro int,
    descrizioneSoluzione text,
    PRIMARY KEY (ticket),
    FOREIGN KEY(tecnico) REFERENCES Tecnico(matricola),
    FOREIGN KEY(codGuasto) REFERENCES Guasto(codGuasto)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1;

-- PREVENTIVO(codPreventivo, importo, accettazione, ticket)		
DROP TABLE IF EXISTS `Preventivo`;
CREATE TABLE `Preventivo` (
	codPreventivo int NOT NULL auto_increment,
    importo int NOT NULL,
    accettazione boolean,
	ticket int NOT NULL,
    PRIMARY KEY (codPreventivo),
    FOREIGN KEY(ticket) REFERENCES Intervento(ticket)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1;

-- RICEVUTA(codRicevuta, importo, modPagamento, codPreventivo)
DROP TABLE IF EXISTS `Ricevuta`;
CREATE TABLE `Ricevuta` (
	codRicevuta int NOT NULL auto_increment,
    importo int,
    modPagamento char(100),
	codPreventivo int NOT NULL,
    PRIMARY KEY (codRicevuta),
    FOREIGN KEY(codPreventivo) REFERENCES Preventivo(codPreventivo)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1;

-- PARTI DI RICAMBIO(nomeParte, costo)
DROP TABLE IF EXISTS `ParteRicambio`;
CREATE TABLE `ParteRicambio` (
	nomeParte char(100) NOT NULL ,
    costo int NOT NULL,
    PRIMARY KEY (nomeParte)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ORDINE PARTI RICAMBIO(codOrdine, dataPrevista, dataEffettiva, dataRichiesta, ticket)
DROP TABLE IF EXISTS `OrdinePartiRicambio`;
CREATE TABLE `OrdinePartiRicambio` (
	codOrdine int NOT NULL auto_increment,
    ticket int NOT NULL,
    dataRichiesta date NOT NULL,
    dataConsegnaPrevista date NOT NULL,
    dataConsegnaEffettiva date,
    PRIMARY KEY (codOrdine),
    FOREIGN KEY(ticket) REFERENCES Intervento(ticket)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1;

-- RICAMBIO(codOridne, nomeParte)	
DROP TABLE IF EXISTS `Ricambio`;
CREATE TABLE `Ricambio` (
	codOrdine int NOT NULL,
    nomeParte char(100) NOT NULL,
    PRIMARY KEY (nomeParte, codOrdine),
    FOREIGN KEY(codOrdine) REFERENCES OrdinePartiRicambio(codOrdine),
    FOREIGN KEY(nomeParte) REFERENCES ParteRicambio(nomeParte)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/* area refurbishment  ********************************************************************************/

-- SOGLIA(nomeProdotto, numeroMax)
DROP TABLE IF EXISTS `Soglia`;
CREATE TABLE `Soglia` (	
	nomeProdotto char(100),
    nMax int NOT NULL,
    PRIMARY KEY (nomeProdotto)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- TEST(codTest, descrizione, livello, nomeProdotto, partiVerificate)
DROP TABLE IF EXISTS `Test`;
CREATE TABLE `Test` (
	codTest int NOT NULL auto_increment,
	nome char(100),
    descrizione text,
    livello int NOT NULL,
    partiVerificate text,
    nomeProdotto char(100),
    PRIMARY KEY (codTest)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1;

-- VERIFICA(codProdotto, codTest, esito)
DROP TABLE IF EXISTS `Verifica`;
CREATE TABLE `Verifica` (
	codTest int NOT NULL,
	codSeriale int NOT NULL,
    esito char(100),
    PRIMARY KEY (codTest, codSeriale),
    FOREIGN KEY(codSeriale) REFERENCES Prodotto(codSeriale),
    FOREIGN KEY(codTest) REFERENCES Test(codTest)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- GERARCHIA(testPrecedente, testSuccessivo)
DROP TABLE IF EXISTS `Gerarchia`;
CREATE TABLE `Gerarchia` (
	testPrecedente int NOT NULL,
	testSuccessivo int NOT NULL,
    PRIMARY KEY (testPrecedente, testSuccessivo),
    FOREIGN KEY(testPrecedente) REFERENCES Test(codTest),
    FOREIGN KEY(testSuccessivo) REFERENCES Test(codTest)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- POLITICA(nomeProdotto, percentuale)
DROP TABLE IF EXISTS `Politica`;
CREATE TABLE `Politica` (
	nomeProdotto char(100),
	percentuale int NOT NULL,
    PRIMARY KEY (nomeProdotto)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- MODIFICA(nomeProdotto, parteCambiata)
DROP TABLE IF EXISTS `Modifica`;
CREATE TABLE `Modifica` (
	nomeProdotto char(100) NOT NULL,
	parteCambiata char(100),
    PRIMARY KEY (nomeProdotto, parteCambiata)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ATTUAZIONE(codProdotto, codTest, nomeProdotto, parteCambiata)
DROP TABLE IF EXISTS `Attuazione`;
CREATE TABLE `Attuazione` (
    codSeriale INT NOT NULL,
    codTest int NOT NULL,
    nomeProdotto char(100) NOT NULL,
    parteCambiata CHAR(100) NOT NULL,
    PRIMARY KEY (codSeriale,  codTest, nomeProdotto, parteCambiata),
	FOREIGN KEY(codSeriale) REFERENCES Prodotto(codSeriale),
    FOREIGN KEY(codTest) REFERENCES Test(codTest),
    FOREIGN KEY(nomeProdotto, parteCambiata) REFERENCES Modifica(nomeProdotto, parteCambiata)
)  ENGINE=INNODB DEFAULT CHARSET=LATIN1;			





















/* verifica validità sequenza */

drop trigger if exists verifica_validita_sequenza;
delimiter $$
create trigger verifica_validita_sequenza
before update on Linea          -- quando si è scelta una sequenza di operazioni, dopo l'inserimento di queste si setta l'attributo sequenza
for each row
begin
-- controllo precedenza
    declare _precedente int default 0;
    declare _operazione int;
-- controllo orientazione
    declare _stazione int default 0;
    declare _orientazione char(100);
    declare _faccia char(100);
	
    declare valida char(2) default 'si';
    declare seq int;
    declare finito int default 0;
    /*
     cursore che scorre in ordine di stazione e poi di ranking
     la tabella contenente i valori dell'attributo precedenza
    */
    declare scorri_operazioni cursor for
        select O.precedenza, E.codStazione, O.faccia
        from Esecuzione E
             natural join
             Operazione O 
        where E.codStazione in (
                                    select S.codStazione
                                    from Stazione S
                                    where S.codLinea = (select L.codLinea 
                                                        from Linea L
                                                        where L.codLinea = new.codLinea)
                                )
        order by E.codStazione, E.ranking;

    declare continue handler for not found set finito = 1;
    /*
    precedenza di operazione più è basso prima deve essere fatta
    ranking di esecuzione più è basso prima viene fatto
    */
    set seq = (select sequenza from Linea where sequenza = new.sequenza);
    
    open scorri_operazioni;
    controllo: LOOP
        FETCH scorri_operazioni into _operazione, _stazione, _faccia;    -- prelevo

        IF finito = 1 THEN 
            LEAVE controllo;
        END IF;
        /*
        se la precedenza dell'operazione precedente è maggiore di 
        quella presa in esame adesso la squenza non è valida perchè
        quella di adesso ha ranking maggiore di quella precedente
        */
        IF _precedente > _operazione THEN  
            -- non va bene
            DELETE from Esecuzione where codStazione in (
                                    select S.codStazione
                                    from Stazione S
                                    where S.codLinea = (select L.codLinea 
                                                        from Linea L
                                                        where L.codLinea = new.codLinea)
                                                        );
            SET new.sequenza = null;
            SET valida = 'no';
            LEAVE controllo;
        END IF;
        /* se nella stazione la faccia su cui agisce l'operazione
           è diversa dall'orientazione della stazione la sequenza non 
           è valida
        */
        set _orientazione = (select orientazione from Stazione where codStazione = _stazione);
        IF _faccia <> _orientazione THEN 
        -- non va bene
            DELETE from Esecuzione where codStazione in (
                                    select S.codStazione
                                    from Stazione S
                                    where S.codLinea = (select L.codLinea 
                                                        from Linea L
                                                        where L.codLinea = new.codLinea)
                                                        );
            SET new.sequenza = null;
			SET valida = 'no';
            LEAVE controllo;
        END IF;

        set _precedente = _operazione;

    END LOOP controllo;
    close scorri_operazioni;
	
	insert into sequenzeValide values(seq, valida); -- solo per verifica
    
end $$
delimiter ;




























-- utente
INSERT INTO `utente` (`codFiscale`, `cognome`, `nome`, `numero`, `dataIscrizione`) VALUES ('mds82', 'Di Stefano', 'Mattea', '33392817', '2018-8-10');
INSERT INTO `utente` (`codFiscale`, `cognome`, `nome`, `numero`, `dataIscrizione`) VALUES ('sn79', 'Nava', 'Sirio', '9843743', '2018-7-5');
INSERT INTO `utente` (`codFiscale`, `cognome`, `nome`, `numero`, `dataIscrizione`) VALUES ('rp09', 'Pini', 'Raffaello', '932747429', '2019-10-9');
INSERT INTO `utente` (`codFiscale`, `cognome`, `nome`, `numero`, `dataIscrizione`) VALUES ('gr9', 'Guglielmo', 'Rossi', '2849849357', '2019-1-1');
INSERT INTO `utente` (`codFiscale`, `cognome`, `nome`, `numero`, `dataIscrizione`) VALUES ('bv10', 'Bonella', 'Viganò', '382837294', '2017-11-25');
-- account
INSERT INTO `account` VALUES ('bonellavigano','bv10','cji9nwu','come stai?','male'),('matteadistefano','mds82','abc123','come stai?','bene'),('raffaellopini','rp09','ma12po','dove sei nato?','ospedale'),('rossiguglielmo','gr9','pq9zt5','colore preferito?','verde'),('sirionava','sn79','jswo00','colore preferito?','rosso');

























/*Trigger che modifica il tipo di un prodotto in venduto*/

DROP TRIGGER IF EXISTS Cambia_Tipo_Venduto;
DELIMITER $$
CREATE TRIGGER Cambia_Tipo_Venduto
AFTER INSERT ON Acquisto
FOR EACH ROW 
	BEGIN
		
		DECLARE _stato VARCHAR(100);
		DECLARE _Prodotto INT;
        
        SELECT stato INTO _stato
        FROM Ordine 
        WHERE codOrdine = NEW.codOrdine;
        
        IF _stato <> 'pendente' THEN 
			UPDATE Prodotto
			SET Tipo = "Venduto" 
			WHERE codSeriale = NEW.codSeriale;
		END IF;

    END$$
DELIMITER ;

/*Trigger che modifica il tipo di un prodotto in reso*/

DROP TRIGGER IF EXISTS Cambia_Tipo_Reso;
DELIMITER $$
CREATE TRIGGER Cambia_Tipo_Reso
AFTER INSERT ON Restituzione
FOR EACH ROW 
	BEGIN
		IF NEW.Accettata = 1 THEN
			UPDATE Prodotto
            SET Tipo = "Reso" 
            WHERE codSeriale = NEW.codSeriale;
		END IF;
    END$$
DELIMITER ;









































-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------















/*CREAIMO UNA MATERIALIZZED VIEW CON INCREMENTAL REFRESH E ONDEMAN REFRESH*/
USE eDevice;


SET GLOBAL log_bin_trust_function_creators = 1;	-- Ci permette di creare funzioni NON DETERMINISTCHE

DROP TABLE IF EXISTS MW_PRESTAZIONI;
-- CREAZIONE MATERIALIZZED VIEW
CREATE TABLE MW_PRESTAZIONI(
    Linea INT NOT NULL,
    Disponibilita DOUBLE DEFAULT 0,
    Rendimento DOUBLE DEFAULT 0,
    Qualita DOUBLE DEFAULT 0,
    Stato VARCHAR (10) DEFAULT 'NUOVA', 
    PRIMARY KEY(Linea)
) ENGINE = InnoDB DEFAULT CHARSET = Latin1;

/*CALOLO DI DISPONIBILITà 
Percentuale dell'effetivo tempo di attività rispetto a quello disponibile 
-> Rapporto tra la somma dei tempi medi di una stazione e il tempo totale di una linea
*/
DROP FUNCTION IF EXISTS Calcolo_Disponibilita;
DELIMITER $$

CREATE FUNCTION Calcolo_Disponibilita(_linea INT)
RETURNS DOUBLE NOT DETERMINISTIC

BEGIN
    DECLARE Somma_T_Medi INT DEFAULT 0;
    DECLARE Tempo_ INT;
	DECLARE N_stazioni INT;
    DECLARE Disponibilita_ DOUBLE;

    SELECT SUM(TempoMedio), COUNT(*) INTO Somma_T_Medi, N_stazioni
    FROM STAZIONE
    WHERE codLinea = _linea;

    SELECT Tempo INTO Tempo_
    FROM LINEA
	WHERE codLinea = _linea;
	
    SET Tempo_ = Tempo_ * N_stazioni;

    IF Tempo_ = 0 THEN 
        SET Disponibilita_ = NULL;
    ELSE 
        SET Disponibilita_ = ( Somma_T_Medi / Tempo_ ) * 100;
    END IF;

    RETURN Disponibilita_;
END$$
DELIMTER ;


/*CALCOLO DI RENDIMENTO
Percentuale di parti prodotte rispetto alla potenzialità teorica quando l'impianto è attivo 
-> Rapporto tra quantità di prodotti ricavati  e quantità prodotti ricavabili in situazione ottimale (PROD RICAVATI +UNITà PERSE)
*/

DELIMITER $$
DROP FUNCTION IF EXISTS Calcolo_Rendimento $$
CREATE FUNCTION Calcolo_Rendimento( _linea INT )
RETURNS DOUBLE NOT DETERMINISTIC

BEGIN
    DECLARE prodotti_ricavati INT ;
    DECLARE Unita_perse INT;
    DECLARE Rendimento_ DOUBLE;
-- prodotti_ricavati si ricava contando i prodotti appartennti ad un lotto legato ad una linea

    SELECT COUNT(CodSeriale) INTO prodotti_ricavati
    FROM Prodotto P NATURAL JOIN Lotto LT NATURAL JOIN Linea LN
    WHERE codLinea = _linea;
-- Unita_perse si ricava sommando le unita perse di ogni stazione appartenente alla linea data 
    SELECT COUNT(Quantita) INTO Unita_perse
    FROM Linea NATURAL JOIN Stazione S INNER JOIN UnitaPerse U on U.stazione = S.codStazione
    WHERE codLinea = _linea;

    IF (prodotti_ricavati <> 0 ) THEN
        SET Rendimento_ = (prodotti_ricavati / (prodotti_ricavati + Unita_perse)) * 100;
    ELSE IF Unita_perse <> 0 THEN
        SET Rendimento_ = -Unita_perse;
		ELSE 
			SET Rendimento_ = NULL;
		END IF;
	END IF;
    RETURN Rendimento_ ;
END$$
DELIMTER ;


/*CALCOLO DI QUALITÀ
Percentuale di parti conformi rispetto rispetto al totale delle parti prodotte 
-> Rapporto tra (prodotti totali del lotto - resi per difetto ) e prodotti iniziali del lotto
*/



DELIMITER $$
DROP FUNCTION IF EXISTS Calcolo_Qualita $$
CREATE FUNCTION Calcolo_Qualita (_linea INT)
RETURNS DOUBLE NOT DETERMINISTIC
BEGIN
    DECLARE prodotti_ricavati INT;
    DECLARE prodotti_resi INT;
    DECLARE Qualita_ DOUBLE;

-- prodotti_ricavati si ricava contando i prodotti appartennti ad un lotto legato ad una linea

    SELECT COUNT(CodSeriale) INTO prodotti_ricavati
    FROM Linea LN NATURAL JOIN Prodotto P  JOIN Lotto L USING(codLotto)
    WHERE codLinea = _linea;

-- prodotti resi si calcola selezionando i prodotti resi apparteneti allo stesso lotto  dei prodotti_ricavati
    SELECT COUNT(CodSeriale) INTO prodotti_resi
    FROM Linea LN NATURAL JOIN Prodotto P  JOIN Lotto L USING(codLotto)
    WHERE codLinea = _linea
        AND P.Tipo = "reso"
        AND codSeriale IN (SELECT codSeriale
							FROM Restituzione 
                            WHERE accettata = 1
								AND codDifetto IS NOT NULL);

    IF (prodotti_ricavati <> 0 ) THEN
        SET Qualita_ = ((prodotti_ricavati - prodotti_resi) / prodotti_ricavati ) * 100;
    ELSE
        SET Qualita_ = NULL;

    END IF;

    RETURN Qualita_ ;
END$$

DELIMITER ;


/*CALCOLO DELLO STATO
Lo stato di un processo può essere: 
1)"NUOVO" se la linea è stata appena inserita e non è legata a nessun lotto
2)"IN CORSO" se la durata effetiva è NULL
3)"TERMINAT0" se la durata effettiva ha un valore 
*/


   
DELIMITER $$ 
DROP FUNCTION IF EXISTS Calcola_Stato $$
CREATE FUNCTION Calcola_Stato(_linea INT)
RETURNS VARCHAR(9)
BEGIN
    DECLARE Stato_ VARCHAR(9);
    DECLARE Lotto_ INT DEFAULT NULL;
    DECLARE Durata_ INT DEFAULT NULL;
    
    SELECT codLotto INTO Lotto_
    FROM Linea
    WHERE codLinea = _linea;

    SELECT DurataEffettiva INTO Durata_
    FROM Linea NATURAL JOIN Lotto
    WHERE codLinea = _linea;

    IF Lotto_ IS NULL THEN
        SET Stato_ = "NUOVO";
    ELSE IF Durata_ IS NULL THEN
			SET Stato_ = "IN CORSO";
		ELSE 
			SET Stato_ = "TERMINATO";
		END IF;
    END IF;
    RETURN Stato_;
END $$
DELIMITER ;




-- AGGIORNAMENTO 

/*Ogni volta che viene inserita una nuova linea si aggiorna la MW */

DROP TRIGGER IF EXISTS Aggiorna_Disponibilita; 

DELIMITER $$

CREATE TRIGGER Aggiorna_Disponibilita
AFTER INSERT ON Linea
FOR EACH ROW
BEGIN
    INSERT INTO MW_PRESTAZIONI 
    VALUES (NEW.codLinea, Calcolo_Disponibilita(NEW.CodLinea), Calcolo_Rendimento(NEW.CodLinea), Calcolo_Qualita(NEW.CodLinea),Calcola_Stato(NEW.CodLinea));
END $$
DELIMITER ;
/*OGNI MESE SI AGGIORNANO LE PRESTAZIONI */
-- RICALCOLA SOLO QUELLE NON CONCLUSE 
-- CURSORE CHE SCORRE LA TAB LINEA E CALCOLA I PARAMETRI 
-- FUNCTION linea conlusa
DROP EVENT IF EXISTS Aggiorna_Prestazioni; 
DELIMITER $$

CREATE EVENT Aggiorna_Prestazioni
ON SCHEDULE EVERY 1 MINUTE
STARTS NOW()
DO
    BEGIN 

        DECLARE finito INTEGER DEFAULT 0;
        DECLARE Codice_Linea INTEGER;

        DECLARE cursore_linea CURSOR FOR 
            SELECT Linea 
            FROM  MW_PRESTAZIONI 
            WHERE Stato <> 'TERMINATO';

        DECLARE CONTINUE HANDLER 
            FOR NOT FOUND SET finito = 1;
    
        OPEN cursore_linea;

        preleva: LOOP
            FETCH cursore_linea INTO Codice_Linea;
        IF finito = 1 THEN
            LEAVE preleva;
        END IF;
    
        UPDATE MW_PRESTAZIONI
        SET Disponibilita =  Calcolo_Disponibilita(Codice_Linea),
			Rendimento =  Calcolo_Rendimento(Codice_Linea),
			Qualita =  Calcolo_Qualita(Codice_Linea),
			Stato = Calcola_Stato(Codice_Linea)
		WHERE Linea = Codice_Linea;

        END LOOP;
    END$$
DELIMITER ;

SET GLOBAL event_scheduler = ON;






-- ----------------------------------------------------------------------------------------------------------------------------------------------



































-- riempire lotto
INSERT INTO `edevice`.`lotto` (`codLotto`, `durataEffettiva`, `durataPreventiva`, `sede`, `tipo`, `categoria`) VALUES ('1', NULL, '6', 'Livorno', 'nuovo', 'smartphone');
INSERT INTO `edevice`.`lotto` (`codLotto`, `durataEffettiva`, `durataPreventiva`, `sede`, `tipo`, `categoria`) VALUES ('2', '3', '2', 'Firenze', 'nuovo', 'PC');

-- riempire linea senza sequenza
INSERT INTO `edevice`.`linea` (`codLinea`, `tempo`, `codLotto`) VALUES ('1', '10', '1');
INSERT INTO `edevice`.`linea` (`codLinea`, `tempo`, `codLotto`) VALUES ('2', '15', '2');

/* riempire operazione */
-- (operazioni per smartphone)
INSERT INTO `edevice`.`operazione` (`faccia`, `precedenza`) VALUES ('schermo', '1');
INSERT INTO `edevice`.`operazione` (`faccia`, `precedenza`) VALUES ('schermo', '2');
INSERT INTO `edevice`.`operazione` (`faccia`, `precedenza`) VALUES ('schermo', '2');
INSERT INTO `edevice`.`operazione` (`faccia`, `precedenza`) VALUES ('schermo', '3');
INSERT INTO `edevice`.`operazione` (`faccia`, `precedenza`) VALUES ('lato dx', '4');
INSERT INTO `edevice`.`operazione` (`faccia`, `precedenza`) VALUES ('lato dx', '5');
INSERT INTO `edevice`.`operazione` (`faccia`, `precedenza`) VALUES ('lato dx', '5');
INSERT INTO `edevice`.`operazione` (`faccia`, `precedenza`) VALUES ('lato dx', '6');
-- (operazioni per PC)
INSERT INTO `edevice`.`operazione` (`faccia`, `precedenza`) VALUES ('tastiera', '1');
INSERT INTO `edevice`.`operazione` (`faccia`, `precedenza`) VALUES ('tastiera', '1');
INSERT INTO `edevice`.`operazione` (`faccia`, `precedenza`) VALUES ('tastiera', '2');
INSERT INTO `edevice`.`operazione` (`faccia`, `precedenza`) VALUES ('tastiera', '3');
INSERT INTO `edevice`.`operazione` (`faccia`, `precedenza`) VALUES ('schermo', '4');
INSERT INTO `edevice`.`operazione` (`faccia`, `precedenza`) VALUES ('schermo', '5');
INSERT INTO `edevice`.`operazione` (`faccia`, `precedenza`) VALUES ('schermo', '5');
INSERT INTO `edevice`.`operazione` (`faccia`, `precedenza`) VALUES ('schermo', '6');

-- riempire stazione
-- (stazioni di linea 1)
INSERT INTO `edevice`.`stazione` (`codLinea`, `orientazione`, `tempoMedio`) VALUES ('1', 'schermo', '9');
INSERT INTO `edevice`.`stazione` (`codLinea`, `orientazione`, `tempoMedio`) VALUES ('1', 'lato dx', '8');
-- (stazioni di linea 2)
INSERT INTO `edevice`.`stazione` (`codLinea`, `orientazione`, `tempoMedio`) VALUES ('2', 'tastiera', '10');
INSERT INTO `edevice`.`stazione` (`codLinea`, `orientazione`, `tempoMedio`) VALUES ('2', 'schermo', '11');

-- riempire esecuzione
-- (esecuzione di smartphone)
INSERT INTO `edevice`.`esecuzione` (`codStazione`, `idOperazione`, `fallimenti`, `ranking`) VALUES ('1', '1', null, '1');
INSERT INTO `edevice`.`esecuzione` (`codStazione`, `idOperazione`, `fallimenti`, `ranking`) VALUES ('1', '2', null, '2');
INSERT INTO `edevice`.`esecuzione` (`codStazione`, `idOperazione`, `fallimenti`, `ranking`) VALUES ('1', '4', null, '3');
INSERT INTO `edevice`.`esecuzione` (`codStazione`, `idOperazione`, `fallimenti`, `ranking`) VALUES ('2', '5', null, '1');
INSERT INTO `edevice`.`esecuzione` (`codStazione`, `idOperazione`, `fallimenti`, `ranking`) VALUES ('2', '7', null, '2');
INSERT INTO `edevice`.`esecuzione` (`codStazione`, `idOperazione`, `fallimenti`, `ranking`) VALUES ('2', '8', null, '3');
-- (esecuzione di PC) (è una sequenza errata)
INSERT INTO `edevice`.`esecuzione` (`codStazione`, `idOperazione`, `fallimenti`, `ranking`) VALUES ('3', '9', '1', '1');
INSERT INTO `edevice`.`esecuzione` (`codStazione`, `idOperazione`, `fallimenti`, `ranking`) VALUES ('3', '11', '1', '2');
INSERT INTO `edevice`.`esecuzione` (`codStazione`, `idOperazione`, `fallimenti`, `ranking`) VALUES ('3', '10', '1', '3');



-- CREO UNA TABELLA DI PROVA
DROP TABLE IF EXISTS `sequenzeValide`;
CREATE TABLE `sequenzeValide` (
	sequ int,
    valida char(2)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

select * from esecuzione;


/* facciamo la prima verifica (che dovrebbe tornare giusta) */
update Linea
set sequenza = 1
where codLinea = 1;

/* seconda verifica (che dovrebbe dare sequenza errata) */
update Linea
set sequenza = 2
where codLinea = 2;

select * from sequenzeValide;
/*
    si
    no
*/
select * from esecuzione;




























/* calcolo costo intervento */

drop trigger if exists costo_intervento;
delimiter $$
create trigger costo_intervento
after update on Intervento          
for each row
begin

    declare costoTot int default 0;
    declare spesa_ricambi int default 0;
    declare spesa_tecnico int default 0;

    declare ricevuta_intervento int;

    SET ricevuta_intervento = (select R.codRicevuta
                               from Ricevuta R inner join Preventivo P on R.codPreventivo = P.codPreventivo
                               where P.ticket = new.ticket);
-- il trigger fa qualcosa solo se l'intervento è finito
    IF new.dataFine is not null THEN
        -- calcolo spesa dovuta ai ricambi
        SET spesa_ricambi = (select SUM(P.costo)
                             from ParteRicambio P 
                                  natural join
                                  Ricambio R 
                             where R.codOrdine in (select O.codOrdine
                                                   from OrdinePartiRicambio O 
                                                   where O.ticket = new.ticket));
        -- calcolo spesa tecnico
        SET spesa_tecnico = (select SUM(pagaOraria)
                             from tecnico
                             where matricola = new.tecnico	)
                             * new.oreLavoro;

        SET costoTot = spesa_ricambi + spesa_tecnico;

        UPDATE Ricevuta 
        SET importo = costoTot 
        WHERE codRicevuta = ricevuta_intervento;
    END IF;    

end $$
delimiter ;



























-- verifica stato spedizione su richiesta
drop procedure if exists controllo_spedizione;
delimiter $$
create procedure controllo_spedizione(IN account_richiedente char(100))
begin
	select S.codOrdine, S.stato
    from Spedizione S
		 inner join 
		 Ordine O on S.codOrdine = O.codOrdine
    where O.username = account_richiedente;
end $$
delimiter ;




























-- iscrizione di un nuovo cliente
begin;
	insert into Utente values('em64', 'Manfrin', 'Elia', '5530202', current_date);
    insert into `Account` values('eliamanfrin','em64', 'gomma', 'colore preferito?', 'terra di Siena');
    insert into Documento values('GS11821642', 'carta d\'identità', '2029-1-1', 'em64');
    insert into Domicilio values('delle more', 193, 'em64', 57890, 'San Giovanni in Persicieto', 'Italia');
commit;




























-- prodotti
INSERT INTO `prodotto` (`nome`, `marca`, `modello`, `prezzo`, `nFacce`, `codLotto`, `dataProduzione`, `tipo`) VALUES ('smartphone', 'apple', 'iphone 10', '1000', '6', '1', '2020-11-17', 'nuovo');
INSERT INTO `prodotto` (`nome`, `marca`, `modello`, `prezzo`, `nFacce`, `codLotto`, `dataProduzione`, `tipo`) VALUES ('smartphone', 'apple', 'iphone 10', '1000', '6', '1', '2020-11-17', 'nuovo');
INSERT INTO `prodotto` (`nome`, `marca`, `modello`, `prezzo`, `nFacce`, `codLotto`, `dataProduzione`, `tipo`) VALUES ('smartphone', 'apple', 'iphone 10', '1000', '6', '1', '2020-11-17', 'nuovo');
INSERT INTO `prodotto` (`nome`, `marca`, `modello`, `prezzo`, `nFacce`, `codLotto`, `dataProduzione`, `tipo`) VALUES ('smartphone', 'apple', 'iphone 10', '1000', '6', '1', '2020-11-17', 'nuovo');
INSERT INTO `prodotto` (`nome`, `marca`, `modello`, `prezzo`, `nFacce`, `codLotto`, `dataProduzione`, `tipo`) VALUES ('smartphone', 'apple', 'iphone 10', '1000', '6', '1', '2020-11-17', 'nuovo');
INSERT INTO `prodotto` (`nome`, `marca`, `modello`, `prezzo`, `nFacce`, `codLotto`, `dataProduzione`, `tipo`) VALUES ('smartphone', 'apple', 'iphone 10', '1000', '6', '1', '2020-11-17', 'nuovo');
INSERT INTO `prodotto` (`nome`, `marca`, `modello`, `prezzo`, `nFacce`, `codLotto`, `dataProduzione`, `tipo`) VALUES ('smartphone', 'apple', 'iphone 10', '1000', '6', '1', '2020-11-17', 'nuovo');
INSERT INTO `prodotto` (`nome`, `marca`, `modello`, `prezzo`, `nFacce`, `codLotto`, `dataProduzione`, `tipo`) VALUES ('smartphone', 'apple', 'iphone 10', '1000', '6', '1', '2020-11-17', 'nuovo');
INSERT INTO `prodotto` (`nome`, `marca`, `modello`, `prezzo`, `nFacce`, `codLotto`, `dataProduzione`, `tipo`) VALUES ('smartphone', 'apple', 'iphone 10', '1000', '6', '1', '2020-11-17', 'nuovo');
INSERT INTO `prodotto` (`nome`, `marca`, `modello`, `prezzo`, `nFacce`, `codLotto`, `dataProduzione`, `tipo`) VALUES ('smartphone', 'apple', 'iphone 10', '1000', '6', '1', '2020-11-17', 'nuovo');
INSERT INTO `prodotto` (`nome`, `marca`, `modello`, `prezzo`, `nFacce`, `codLotto`, `dataProduzione`, `tipo`) VALUES ('smartphone', 'apple', 'iphone 10', '1000', '6', '1', '2020-11-17', 'nuovo');
INSERT INTO `prodotto` (`nome`, `marca`, `modello`, `prezzo`, `nFacce`, `codLotto`, `dataProduzione`, `tipo`) VALUES ('smartphone', 'apple', 'iphone 10', '1000', '6', '1', '2020-11-17', 'nuovo');
INSERT INTO `prodotto` (`nome`, `marca`, `modello`, `prezzo`, `nFacce`, `codLotto`, `dataProduzione`, `tipo`) VALUES ('smartphone', 'apple', 'iphone 10', '1000', '6', '1', '2020-11-17', 'nuovo');
INSERT INTO `eDevice`.`Prodotto` ( `nome`, `marca`, `modello`, `prezzo`, `nFacce`, `codLotto`, `dataProduzione`, `tipo`) VALUES ( 'smartphone', 'apple', 'iphone 10', '1000', '6', '1', '2020-11-17', 'reso');
INSERT INTO `eDevice`.`Prodotto` ( `nome`, `marca`, `modello`, `prezzo`, `nFacce`, `codLotto`, `dataProduzione`, `tipo`) VALUES ( 'smartphone', 'apple', 'iphone 10', '1000', '6', '1', '2020-11-17', 'reso');
INSERT INTO `eDevice`.`Prodotto` ( `nome`, `marca`, `modello`, `prezzo`, `nFacce`, `codLotto`, `dataProduzione`, `tipo`) VALUES ( 'smartphone', 'apple', 'iphone 10', '1000', '6', '1', '2020-11-17', 'reso');

-- parti
INSERT INTO `parte` (`nome`, `prezzo`, `coeffSvalutazione`, `assemblata`) VALUES ('schermo iphone', '180', '2', '0');
INSERT INTO `parte` (`nome`, `prezzo`, `coeffSvalutazione`, `assemblata`) VALUES ('ram 4gb', '50', '3', '0');
INSERT INTO `parte` (`nome`, `prezzo`, `coeffSvalutazione`, `assemblata`) VALUES ('ram 6gb', '80', '3', '0');
INSERT INTO `edevice`.`PARTE` (`nome`, `prezzo`, `coeffSvalutazione`, `assemblata`) VALUES ('tastiera', '40', '3', '0');
INSERT INTO `edevice`.`PARTE` (`nome`, `prezzo`, `coeffSvalutazione`, `assemblata`) VALUES ('monitor', '200', '1', '0');



-- ripartizione
INSERT INTO `eDevice`.`Ripartizione` (`codSeriale`, `parte`) VALUES ('1', 'schermo iphone');
INSERT INTO `eDevice`.`Ripartizione` (`codSeriale`, `parte`) VALUES ('2', 'schermo iphone');
INSERT INTO `eDevice`.`Ripartizione` (`codSeriale`, `parte`) VALUES ('3', 'schermo iphone');
INSERT INTO `eDevice`.`Ripartizione` (`codSeriale`, `parte`) VALUES ('1', 'ram 4gb');
INSERT INTO `eDevice`.`Ripartizione` (`codSeriale`, `parte`) VALUES ('2', 'ram 4gb');
INSERT INTO `eDevice`.`Ripartizione` (`codSeriale`, `parte`) VALUES ('3', 'ram 6gb');


























/* conteggio parti di un prodotto */

begin;
	select parte, count(parte) as quantipezzi
    from Ripartizione
    group by parte;
commit;



























/* ordine di un cliente */

begin;
	-- Raffaello Pini ha comprato due iphone 10
    
	insert into Ordine(codOrdine, istanteOrdine, username, stato)			
    values(1, current_timestamp(), 'raffaellopini', 'in processazione');     
    
    insert into Spedizione(stato, arrivoPrevisto, codOrdine)	-- il codice viene autoincrementato
    values('spedita', date_add(current_timestamp(), interval 7 day), 1);
    
    insert into Acquisto(codOrdine, codSeriale)
    values(1, 2),(1, 3);    -- i due iphone 10

    insert into Riduzione(codOrdine, codSconto)
    values(1, 1);
        
commit;




























-- inserire orari
INSERT INTO `orario` (`giornoInizio`, `giornoFine`, `oraInizio`, `oraFine`) VALUES ('1', '5', '8', '17');

-- inserire centro assistenza
INSERT INTO `centroassistenza` (`nome`, `localita`) VALUES ('Clinica iPhone', 'Pisa');

-- inserire tecnici
INSERT INTO `tecnico` (`nome`, `cognome`, `categoriaProd`, `centroAssistenza`, `orario`, `pagaOraria`) VALUES ('Alessandro ', 'Marino', 'smartphone', 'Clinica iPhone', '1', '15');
INSERT INTO `tecnico` (`nome`, `cognome`, `categoriaProd`, `centroAssistenza`, `orario`, `pagaOraria`) VALUES ('Maria Pia', 'Bianchi', 'smartphone', 'Clinica iPhone', '1', '17');

-- inserire classi di guasto
INSERT INTO `classeguasto` (`nome`, `descrizione`) VALUES ('urti', 'guasti causati dall urto del prodotto');

-- inserire guasti
INSERT INTO `guasto` (`codSeriale`, `descrizione`, `classeGuasto`) VALUES ('3', 'il prodotto presenta una crepa sullo schermo e non si accende', 'urti');

-- inserire parte ricambo
INSERT INTO `partericambio` (`nomeParte`, `costo`) VALUES ('schermo iPhone 10', '103');

-- inserire interventi
INSERT INTO `intervento` (`codGuasto`, `dataInizio`, `tecnico`) VALUES ('1', '2020-11-30', '1');

-- inserire ordini ricambi
INSERT INTO `ordinepartiricambio` (`codOrdine`, `ticket`, `dataRichiesta`, `dataConsegnaPrevista`) VALUES ('1', '1', '2020-11-30', '2020-12-1');

-- inserire ricambi
INSERT INTO `ricambio` (`codOrdine`, `nomeParte`) VALUES ('1', 'schermo iPhone 10');

-- inserire preventivi
INSERT INTO `preventivo` (`codPreventivo`, `importo`, `accettazione`, `ticket`) VALUES ('1', '200', '0', '1');

-- inserire ricevute
INSERT INTO `ricevuta` (`codRicevuta`, `codPreventivo`) VALUES ('1', '1');

/* aggiungiamo dataFine all'intervento 1*/
UPDATE `intervento` SET `dataFine` = '2020-12-4', `oreLavoro` = '2' WHERE (`ticket` = '1');

/* si attiva il trigger che inserirà il costo in ricevuta */




























/* disponibilità tecnici */

begin;
	select T.matricola as tecniciDisponibili, T.nome, T.cognome
    from Tecnico T
    where T.matricola not in ( select I.tecnico
							   from Intervento I
                               where I.dataFine is null);
commit;



























/* gestione richiesta di reso */

drop trigger if exists gestione_richiesta_reso;
delimiter $$
create trigger gestione_richiesta_reso
before insert on Restituzione          
for each row
begin

    declare data_acquisto date;

    set data_acquisto = (
						select O.istanteOrdine
						from Ordine O natural join Acquisto A
						where A.codSeriale = new.codSeriale
						);
	-- date_format(, '%Y-%m-%d'
    -- condizione sul diritto di recesso (valido 1 mese)
    IF (data_acquisto + interval 30 day) > current_date THEN
        set new.accettata = true;
    END IF;

    -- condizione sulla motivazione
    IF (new.codMotivazione is null) THEN
        set new.accettata = false;
    END IF;
    
end $$
delimiter ;


























-- inserisco motivazione
INSERT INTO `edevice`.`motivazione` (`codMotivazione`, `nome`, `descrizione`) VALUES ('1', 'diverso dal vivo', 'il prodotto non appare come mostrato in foto sul sito web');
INSERT INTO `eDevice`.`Motivazione` (`codMotivazione`, `nome`, `descrizione`) VALUES ('2', 'dimensione sbagliata', 'il prodotto non risulta compatibile con le misure cercate');

-- inserimento difetto

INSERT INTO `eDevice`.`Difetto` (`codDifetto`, `nome`, `descrizione`) VALUES ('1', 'Batteria', 'La batteria ha prestazioni nettamente inferiori a quelle dichiarate');


-- inserisco restituzione
INSERT INTO `edevice`.`restituzione` (`codRestituzione`, `codSeriale`, `dataRichiesta`, `codMotivazione`, `codDifetto`) VALUES ('1', '2', '2020-11-25', '1', '1');
INSERT INTO `eDevice`.`Restituzione` (`codRestituzione`, `codSeriale`, `accettata`, `dataRichiesta`, `codMotivazione`) VALUES ('2', '3', '1', '2020-11-25', NULL);

-- accettata viene riempito dal trigger

select * from restituzione;    
/*
    codRestituzione 1
    accettata 0 ---> True
*/





















-- Inserimento Unita Perse
INSERT INTO `eDevice`.`UnitaPerse` (`parte`, `quantita`, `stazione`) VALUES ('ram 4gb', '1', '1');
INSERT INTO `eDevice`.`UnitaPerse` (`parte`, `quantita`, `stazione`) VALUES ('schermo iphone', '2', '2');
INSERT INTO `eDevice`.`UnitaPerse` (`parte`, `quantita`, `stazione`) VALUES ('tastiera', '1', '3');
INSERT INTO `eDevice`.`UnitaPerse` (`parte`, `quantita`, `stazione`) VALUES ('monitor', '1', '4');





































use edevice;

DROP TABLE IF EXISTS mv_CBR;		-- contiene le soluzioni di CBR()
CREATE TABLE mv_CBR(
	guasto int NOT NULL,			-- codGuasto in esame
    possibileRimedio int NOT NULL,	-- codGuasto simile
    score float NOT NULL				-- percentuale di somiglianza
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

ALTER TABLE Guasto
ADD COLUMN cbr BOOL DEFAULT false;	-- attributo che fa da filtro ( nei guasti candidati alla cbr i "doppioni" non vengono presi in considerazione )

-- _____________________________________________________________________________________________
-- RETRIEVE
-- ricerca di casi simili al caso in analisi (_guasto preso in input)
-- due casi sono simili quando hanno dei codErrore in comune e sono della stessa classe di guasto
-- REUSE
-- dare una lista di possibili soluzioni con uno score di affidabilità in base alla somiglianza
-- in pratica l'output sarà una tabella con le soluzioni dei casi simili in una colonna e nell'altra la percentuale di codErrori uguali

DROP PROCEDURE IF EXISTS CBR;
DELIMITER $$
CREATE PROCEDURE CBR( IN _guasto int )
BEGIN
	-- dichiaro variabili
    declare _classe char(100);					-- classe di guasto del guasto preso in input
    declare contaCodErrore int default 0;		-- conta i codErrore per poi fare la percentuale
    
	declare candidatoInUso int;					-- nel loop prende il valore del guasto candidato che si sta utilizzando
    declare score float;						-- percentale di matching
    declare soluzione_ int;						-- ticket della soluzione
    declare descrizione_ text;
    declare finito int default 0;

    -- dichiaro cursore e handler
    declare guastiCandidati cursor for			-- guasti con stessa _classe 
		select distinct(G.codGuasto)
        from  dettaglio D natural join guasto G
		where G.classeGuasto in ( select classeGuasto from Guasto where codGuasto = _guasto )	-- = _classe
			  and
              G.cbr = false;	-- controlla non sia già risolto con cbr
    
    declare continue handler for not found set finito = 1;
		

    set _classe = ( select classeGuasto from Guasto where codGuasto = _guasto );
    set contaCodErrore = (select count(D.codErrore)		-- di _guasto
						  from dettaglio D
						  where D.codGuasto = _guasto);

    DROP TABLE IF EXISTS risultato;
    CREATE TABLE risultato 
    (
		soluzione int,
        descrizione text,
        score float
    );
    
	open guastiCandidati;
    matching: LOOP									-- prendo un guasto cadidato alla volta e calcolo lo score
    
		FETCH guastiCandidati INTO candidatoInUso;
        IF finito = 1 THEN 
			LEAVE matching;			-- condizione di uscita dal loop
		END IF;
			
		set score = (
					select count(*)/contaCodErrore
					from dettaglio D1
					where  codGuasto = candidatoInUso and
							D1.codErrore in (select D2.codErrore
											 from dettaglio D2
											 where D2.codGuasto = _guasto) -- elenco codErrore di _guasto
				);
            
		set soluzione_ = ( select ticket from intervento where codGuasto = candidatoInUso);
		set descrizione_ =  ( select descrizioneSoluzione from intervento where codGuasto = candidatoInUso);
		
        IF score > 0.7 and candidatoInUso <> _guasto THEN
			INSERT INTO mv_CBR VALUES (_guasto, soluzione_, score );			-- aggiorna mv se score > 0.7
            INSERT INTO risultato VALUES (soluzione_, descrizione_, score);
		END IF;

    END LOOP matching;
    close guastiCandidati;
    
    SELECT *
    FROM risultato;
    
    DROP TABLE risultato;

END $$
DELIMITER ;

-- ________________________________________________________________________________________________

-- REVISE
-- dopo che il tecnico risolve il guasto inserirà la soluzione all'interno del database ( soluzione sotto forma di quali parti sono state cambiate )
-- con un trigger che chiama una sp si controlla se il consiglio del cbr ha risolto il problema o se è stato fatto da un'altra soluzione

DROP PROCEDURE IF EXISTS revise_CBR;
DELIMITER $$
CREATE PROCEDURE revise_CBR( IN _guasto int )
BEGIN
	
    declare finito int default 0;
    declare soluzioneInUso int;
    declare totRicambi int;
    declare quantiRicambi int;
    
    declare soluzioniCandidate cursor for
		select possibileRimedio
        from mv_CBR
        where guasto = _guasto;
        
	declare continue handler for not found set finito = 1;

    set totRicambi = (select count(R.nomeParte) 				-- del guasto in input
					  from Intervento I natural join
							OrdinePartiRicambio O natural join
							Ricambio R
					  where I.codGuasto = _guasto);
    
    open soluzioniCandidate;
    matching: LOOP
		FETCH soluzioniCandidate INTO soluzioneInUso;
        IF finito = 1 THEN
			LEAVE matching;
		END IF;
                            
		set quantiRicambi = (
								select count(R1.nomeParte)					-- conta i ricambi della soluzione in uso uguali a quelli di _guasto
								from OrdinePartiRicambio O1 natural join
									 Ricambio R1
								where O1.ticket = soluzioneInUso
									  and
                                      R1.nomeParte in (	-- ricambi di _guasto
														select R2.nomeParte
														from Intervento I2 natural join
															 OrdinePartiRicambio O2 natural join
															 Ricambio R2
														where I2.codGuasto = _guasto
                                                     )
							);
                            
-- RETAIN
		IF quantiRicambi = totRicambi THEN		-- se i ricambi della soluz. in uso sono gli stessi del guasto in input
			UPDATE 
            Intervento SET cbr = True;			-- settiamo l'attributo ridondante cbr per non avere doppioni
            LEAVE matching;
		END IF;
    
    END LOOP;    
    close soluzioniCandidate;
END $$
DELIMITER ;

DROP TRIGGER IF EXISTS Solution_Alert;
DELIMITER $$
CREATE TRIGGER Solution_Alert
AFTER UPDATE ON Intervento
FOR EACH ROW
BEGIN
	CALL revise_CBR(new.codGuasto);
END $$
DELIMITER ;








































-- guasto
INSERT INTO `edevice`.`guasto` (`codGuasto`, `codSeriale`, `descrizione`, `classeGuasto`) VALUES ('2', '4', 'il prodotto non si accende e presenta crepe sulla fotocamera ', 'urti');
INSERT INTO `edevice`.`guasto` (`codGuasto`, `codSeriale`, `descrizione`, `classeGuasto`) VALUES ('3', '5', 'il prodotto presenta una grossa crepa nell angolo in alto a dx', 'urti');
INSERT INTO `edevice`.`guasto` (`codGuasto`, `codSeriale`, `descrizione`, `classeGuasto`) VALUES ('4', '6', 'il prodotto presenta varie crepe sulla parte bassa dello schermo e non si accende', 'urti');
INSERT INTO `edevice`.`guasto` (`codGuasto`, `codSeriale`, `descrizione`, `classeGuasto`) VALUES ('5', '7', 'il prodotto non si accende e presenta una grossa crepa nei pressi della fotocamera interna', 'urti');

-- cod errore
INSERT INTO `edevice`.`coderrore` (`codErrore`, `descrizione`) VALUES ('1', 'rottura schermo iphone 10');
INSERT INTO `edevice`.`coderrore` (`codErrore`, `descrizione`) VALUES ('2', 'rottura fotocamera interna iphone 10');
INSERT INTO `edevice`.`coderrore` (`codErrore`, `descrizione`) VALUES ('3', 'rottura fotocamera esterna iphone 10');
INSERT INTO `edevice`.`coderrore` (`codErrore`, `descrizione`) VALUES ('4', 'rottura cristalli liquidi iphone 10');
INSERT INTO `edevice`.`coderrore` (`codErrore`, `descrizione`) VALUES ('5', 'rottura tasto di accensione iphone 10');

-- dettaglio
INSERT INTO `edevice`.`dettaglio` (`codErrore`, `codGuasto`) VALUES ('3', '2');
INSERT INTO `edevice`.`dettaglio` (`codErrore`, `codGuasto`) VALUES ('1', '2');
INSERT INTO `edevice`.`dettaglio` (`codErrore`, `codGuasto`) VALUES ('1', '3');
INSERT INTO `edevice`.`dettaglio` (`codErrore`, `codGuasto`) VALUES ('4', '3');
INSERT INTO `edevice`.`dettaglio` (`codErrore`, `codGuasto`) VALUES ('1', '4');
INSERT INTO `edevice`.`dettaglio` (`codErrore`, `codGuasto`) VALUES ('4', '4');
INSERT INTO `edevice`.`dettaglio` (`codErrore`, `codGuasto`) VALUES ('5', '4');
INSERT INTO `edevice`.`dettaglio` (`codErrore`, `codGuasto`) VALUES ('5', '5');
INSERT INTO `edevice`.`dettaglio` (`codErrore`, `codGuasto`) VALUES ('1', '5');
INSERT INTO `edevice`.`dettaglio` (`codErrore`, `codGuasto`) VALUES ('4', '5');
INSERT INTO `edevice`.`dettaglio` (`codErrore`, `codGuasto`) VALUES ('2', '5');

-- intervento
INSERT INTO `edevice`.`intervento` (`ticket`, `codGuasto`, `dataInizio`, `dataFine`, `tecnico`, `oreLavoro`, `descrizioneSoluzione`) VALUES ('2', '2', '2020-12-1', '2020-12-3', '3', '2', 'cambio fotocamera e schermo');
INSERT INTO `edevice`.`intervento` (`ticket`, `codGuasto`, `dataInizio`, `dataFine`, `tecnico`, `oreLavoro`, `descrizioneSoluzione`) VALUES ('3', '3', '2020-12-3', '2020-12-5', '3', '2', 'cambio lcd');
INSERT INTO `edevice`.`intervento` (`ticket`, `codGuasto`, `dataInizio`, `dataFine`, `tecnico`, `oreLavoro`, `descrizioneSoluzione`) VALUES ('4', '4', '2020-12-3', '2020-12-5', '3', '2', 'cambio lcd e tasto accensione');
INSERT INTO `edevice`.`intervento` (`ticket`, `codGuasto`, `dataInizio`, `tecnico`, `oreLavoro`) VALUES ('5', '5', '2020-12-10', '3', NULL);

-- parti ricambio
INSERT INTO `edevice`.`partericambio` (`nomeParte`, `costo`) VALUES ('lcd iPhone 10', '180');
INSERT INTO `edevice`.`partericambio` (`nomeParte`, `costo`) VALUES ('tasto accensione iphone 10', '50');
INSERT INTO `edevice`.`partericambio` (`nomeParte`, `costo`) VALUES ('fotocamera esterna iPhone 10', '82');
INSERT INTO `edevice`.`partericambio` (`nomeParte`, `costo`) VALUES ('fotocamera interna iPhone 10', '65');

-- ordine pr
INSERT INTO `edevice`.`ordinepartiricambio` (`codOrdine`, `ticket`, `dataRichiesta`, `dataConsegnaPrevista`) VALUES ('2', '2', '2020-12-1', '2020-12-2');
INSERT INTO `edevice`.`ordinepartiricambio` (`codOrdine`, `ticket`, `dataRichiesta`, `dataConsegnaPrevista`) VALUES ('3', '3', '2020-12-3', '2020-12-4');
INSERT INTO `edevice`.`ordinepartiricambio` (`codOrdine`, `ticket`, `dataRichiesta`, `dataConsegnaPrevista`) VALUES ('4', '4', '2020-12-3', '2020-12-4');

-- ricambio
INSERT INTO `edevice`.`ricambio` (`codOrdine`, `nomeParte`) VALUES ('2', 'schermo iPhone 10');
INSERT INTO `edevice`.`ricambio` (`codOrdine`, `nomeParte`) VALUES ('2', 'fotocamera esterna iPhone 10');
INSERT INTO `edevice`.`ricambio` (`codOrdine`, `nomeParte`) VALUES ('3', 'lcd iPhone 10');
INSERT INTO `edevice`.`ricambio` (`codOrdine`, `nomeParte`) VALUES ('4', 'lcd iPhone 10');
INSERT INTO `edevice`.`ricambio` (`codOrdine`, `nomeParte`) VALUES ('4', 'tasto accensione iphone 10');


select G.codGuasto, G.descrizione, C.descrizione from dettaglio D natural join coderrore C inner join guasto G on G.codGuasto = D.codguasto;

select * from Guasto;

call CBR(5);

select * from MV_CBR;



