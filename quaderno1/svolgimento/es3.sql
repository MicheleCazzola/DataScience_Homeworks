/*
	Analizzare le entrate medie mensili relative ad ogni tipo di biglietto e per ogni 
	semestre
	
	GB: Tipo, Semestre
	SEL: / 
	MIS: SUM(Quantità * Costo), COUNT(DISTINCT Mese)
*/

SELECT 	Tipo, Semestre,
		SUM(Quantità * Costo) / COUNT(DISTINCT Mese) as EntrataMediaMensile
FROM TEMPO T, BIGLIETTO B
WHERE T.CodT = B.CodT
GROUP BY Tipo, Semestre

/*
	Separatamente per ogni tipo di biglietto e per ogni mese analizzare le entrate 
	cumulative dall'inizio dell'anno

	GB: Tipo, Mese, Anno
	SEL: / 
	MIS: SUM(Quantità * Costo)
*/

SELECT	Tipo, Mese,
		SUM(SUM(Quantità * Costo)) OVER (	PARTITION BY Tipo, Anno
											ORDER BY Mese
											ROWS UNBOUNDED PRECEDING
										) as EntrataCumulativaAnnua
FROM BIGLIETTO B, TEMPO T
WHERE B.CodT = T.CodT
GROUP BY Tipo, Mese, Anno

/*
	Considerando solo i biglietti acquistati online, separatamente per ogni tipo di 
	biglietto  e  per  ogni  mese  analizzare  il  numero  totale  di  biglietti,  le  entrate 
	totali e le entrate medie per biglietto
	
	GB: Tipo, Mese
	SEL: ModAcquisto
	MIS: SUM(Quantità), SUM(Quantità * Costo)
*/

SELECT	Tipo, Mese,
		SUM(Quantità) as NumTotaleBiglietti,
		SUM(Quantità * Costo) as EntrataTotale,
		SUM(Quantità * Costo) / SUM(Quantità) as EntrataMedia
FROM BIGLIETTO B, TEMPO T
WHERE	B.CodT = T.CodT AND
		ModAcquisto = 'Online'
GROUP BY Tipo, Mese
/*
	Separatamente per ogni tipo di biglietto e per ogni mese analizzare il numero 
	totale di biglietti, le entrate totali e le entrate medie per biglietto per l'anno 
	2021
	
	GB: Tipo, Mese
	SEL: Anno
	MIS: SUM(Quantità), SUM(Quantità * Costo)
*/

SELECT	Tipo, Mese,
		SUM(Quantità) as NumTotaleBiglietti,
		SUM(Quantità * Costo) as EntrataTotale,
		SUM(Quantità * Costo) / SUM(Quantità) as EntrataMedia
FROM BIGLIETTO B, TEMPO T
WHERE	B.CodT = T.CodT AND
		T.Anno = 2021
GROUP BY Tipo, Mese

/*
	Analizzare la percentuale di biglietti relativi ad ogni tipo di biglietto e mese sul 
	numero totale di biglietti del mese
	
	GB: Tipo, Mese
	SEL: /
	MIS: SUM(Quantità)
*/

SELECT 	Tipo, Mese,
		100 * SUM(Quantità) / SUM(SUM(Quantità)) OVER (PARTITION BY Mese)
FROM BIGLIETTO B, TEMPO T
WHERE	B.CodT = T.CodT
GROUP BY Tipo, Mese


/* 
	Es 3.1
	Creazione vista 
*/

CREATE MATERIALIZED VIEW VM_UpdateTempoBiglietti
BUILD IMMEDIATE
REFRESH FAST ON COMMIT
AS
	SELECT 	Tipo, Mese, Semestre, Anno, ModAcquisto,
			SUM(Quantità) as NumBigliettiPerTipoMeseModalità,
			SUM(Quantità * Costo) as EntrataPerTipoMeseModalità
	FROM BIGLIETTO B, TEMPO T
	WHERE B.CodT = T.CodT
	GROUP BY Tipo, Mese, Semestre, Anno, ModAcquisto;
	
/* 
	Es 3.2
	Creazione materialized view log
	Tabelle necessarie: BIGLIETTO, TEMPO
	Attributi necessari:
	-	BIGLIETTO: Tipo, CodT, ModAcquisto, Quantità, Costo
	-	TEMPO: CodT, Mese, Semestre, Anno
*/

CREATE MATERIALIZED VIEW LOG ON BIGLIETTO
WITH ROWID, SEQUENCE(Tipo, CodT, ModAcquisto, Quantità, Costo)
INCLUDING NEW VALUES;

CREATE MATERIALIZED VIEW LOG ON TEMPO
WITH ROWID, SEQUENCE(CodT, Mese, Semestre, Anno)
INCLUDING NEW VALUES;

/* 	Es 3.3
	Operazioni che causano cambiamento vista: inserimento/aggiornamento/cancellazione record in BIGLIETTO o in TEMPO
*/