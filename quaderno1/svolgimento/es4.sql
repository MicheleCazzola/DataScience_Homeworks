/*
	Es 4.1
	Creazione struttura vista materializzata
*/

CREATE TABLE VM_UpdateTempoBiglietti(
	Tipo varchar(30) NOT NULL,
	Mese date NOT NULL,
	Semestre date NOT NULL,
	Anno integer NOT NULL,
	ModAcquisto varchar(50) NOT NULL,
	NumBigliettiPerTipoMeseModalità integer NOT NULL,
	EntrataPerTipoMeseModalità number NOT NULL,
	PRIMARY KEY(Tipo, Mese, ModAcquisto)
);

/* 
	Es 4.2
	Popolazione tabella
*/

INSERT INTO VM_UpdateTempoBiglietti(Tipo, Mese, Semestre, Anno,
	ModAcquisto, NumBigliettiPerTipoMeseModalità, EntrataPerTipoMeseModalità)
SELECT 	Tipo, Mese, Semestre, Anno, ModAcquisto,
			SUM(Quantità) as NumBigliettiPerTipoMeseModalità,
			SUM(Quantità * Costo) as EntrataPerTipoMeseModalità
FROM BIGLIETTO B, TEMPO T
WHERE B.CodT = T.CodT
GROUP BY Tipo, Mese, Semestre, Anno, ModAcquisto;

/*
	Es 4.3
	Scrivere il trigger necessario per propagare le modifiche (inserimento di un nuovo 
	record) effettuate nella tabella BIGLIETTO alla vista materializzata
*/

CREATE OR REPLACE TRIGGER UpdateBiglietto
AFTER INSERT ON BIGLIETTO
FOR EACH ROW
DECLARE
	N number;
	S date;
	A integer;
BEGIN
	
	-- Check esistenza record in BIGLIETTO
	select count(*) into N
	from BIGLIETTO
	where	Tipo = :NEW.Tipo AND
			Mese = :NEW.Mese AND
			ModAcquisto = :NEW.ModAcquisto;
	
	if(N > 0) then
		-- Record presente: aggiornamento vista
		update VM_UpdateTempoBiglietti
		set NumBigliettiPerTipoMeseModalità = NumBigliettiPerTipoMeseModalità + :NEW.Quantità,
			EntrataPerTipoMeseModalità = EntrataPerTipoMeseModalità + :NEW.Quantità * :NEW.Costo
		where	Tipo = :NEW.Tipo AND
				Mese = :NEW.Mese AND
				ModAcquisto = :NEW.ModAcquisto;
	
	else
		-- Record assente
		-- Ricavo semestre ed anno corrispondenti al record inserito
		select Semestre, Anno into (S, A)
		from TEMPO
		where CodT = :NEW.CodT;
	
		-- Inserimento record corrispondente in vista
		insert into VM_UpdateTempoBiglietti(Tipo, Mese, Semestre, Anno,
				ModAcquisto, NumBigliettiPerTipoMeseModalità, EntrataPerTipoMeseModalità)
			value(:NEW.Tipo, :NEW.Mese, S, A, :NEW.ModAcquisto, :NEW.Quantità, :NEW.Quantità * :NEW.Costo);
	
	end if;
	
END;

/*
	Es 4.4
	Operazioni che scatenano il trigger: INSERT effettuata su tabella BIGLIETTO
*/