/*
	Es 2.a
	Separatamente per ogni tipo di biglietto e per ogni mese (della validità del biglietto), 
	analizzare: le entrate medie giornaliere, le entrate cumulative dall'inizio dell'anno, la 
	percentuale  di  biglietti  relativi  al  tipo  di  biglietto  considerato  sul  numero  totale  di 
	biglietti del mese 
*/

SELECT 	Tipo, Mese,
		SUM(Quantità * Costo) / COUNT(DISTINCT Data) as EntrateMedieGiornaliere,
		SUM(SUM(Quantità * Costo)) OVER (	PARTITION BY Tipo, Anno
											ORDER BY Mese
											ROWS UNBOUNDED PRECEDING
										) as EntrateCumulativeAnnuali,
		100 * SUM(Quantità * Costo) / SUM(SUM(Quantità * Costo))
			OVER (PARTITION BY Mese) as PercTipoBigliettiSuTotaleMese											
FROM BIGLIETTO B, TEMPO T
WHERE B.CodT = T.CodT
GROUP BY Tipo, Mese, Anno

/*	
	Es 2.b
	Considerare  i  biglietti  del  2021.  Separatamente  per  ogni  museo  e  tipo  di  biglietto 
	analizzare: il ricavo medio per un biglietto, la percentuale di ricavo sul ricavo totale 
	per  la  categoria  di  museo  e  tipo  di  biglietto  corrispondenti,  assegnare  un  rango  al 
	museo,  per  ogni  tipo  di  biglietto,  secondo  il  numero  totale  di  biglietti  in  ordine 
	decrescente. 
*/

SELECT	NomeMuseo, Tipo,
		SUM(Quantità * Costo) / SUM(Quantità) as RicavoMedioPerBiglietto,
		100 * SUM(Quantità * Costo) / SUM(SUM(Quantità * Costo))
			OVER (PARTITION BY Categoria, Tipo) as PercRicavoSuTotalePerCategoriaETipo,
		RANK() OVER (	PARTITION BY Tipo
						ORDER BY SUM(Quantità) DESC
					) as RankNumBigliettiPerTipo
FROM MUSEO M, BIGLIETTO B, TEMPO T
WHERE	M.CodM = B.CodM AND
		B.CodT = T.CodT AND
		T.Anno = 2021
GROUP BY NomeMuseo, Categoria, Tipo
