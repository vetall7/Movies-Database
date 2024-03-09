USE Films

CREATE TABLE Filmy(
	FilmId UNIQUEIDENTIFIER DEFAULT NEWID() PRIMARY KEY,
	Tytul VARCHAR(255) NOT NULL CHECK (Tytul NOT LIKE '%[^a-zA-Z����󜟿��ʣ�ӌ��0-9,: -]%' AND  Tytul LIKE '[A-Z��ʣ�ӌ��]%'),
	Budzet BIGINT CHECK (Budzet >= 0),
	Kraj VARCHAR(56) CHECK (Kraj NOT LIKE '%[^a-zA-Z����󜟿��ʣ�ӌ��0-9,: -]%' AND  Kraj LIKE '[A-Z��ʣ�ӌ��]%'),
	DataRozpoczecia DATE CHECK (YEAR(DataRozpoczecia) >= 1888),
	DataZakonczenia DATE CHECK (YEAR(DataZakonczenia) >= 1888),
	Streszczenie NVARCHAR(MAX),
	Zdjecie VARCHAR(255),
	CzasTrwania INT CHECK (CzasTrwania >= 0 AND CzasTrwania < 5100)
);

CREATE TABLE Gatunki (
	Nazwa VARCHAR(30) CHECK (Nazwa NOT LIKE '%[^a-zA-Z����󜟿��ʣ�ӌ��0-9,: -]%' AND  Nazwa LIKE '[A-Z��ʣ�ӌ��]%') PRIMARY KEY,
	CharakterystyczneCechy VARCHAR(500) CHECK (CharakterystyczneCechy NOT LIKE '%[^a-zA-Z����󜟿��ʣ�ӌ��0-9,: -]%')
);

CREATE TABLE NalezyDo(
	FilmId UNIQUEIDENTIFIER REFERENCES Filmy ON DELETE CASCADE,
	NazwaGatunku VARCHAR(30) REFERENCES Gatunki ON DELETE CASCADE ON UPDATE CASCADE,
	PRIMARY KEY(FilmID, NazwaGatunku)
);

CREATE TABLE StudiaFilmowe(
	Nazwa VARCHAR(255) CHECK (Nazwa NOT LIKE '%[^a-zA-Z����󜟿��ʣ�ӌ��0-9,: -]%' AND Nazwa LIKE '[A-Z��ʣ�ӌ��]%') PRIMARY KEY,
	Kraj VARCHAR(56) CHECK (Kraj NOT LIKE '%[^a-zA-Z����󜟿��ʣ�ӌ��0-9,: -]%' AND  Kraj LIKE '[A-Z��ʣ�ӌ��]%'),
	RokUtworzenia SMALLINT CHECK (RokUtworzenia >= 1892)
);

CREATE TABLE Wytwarzanie(
	NazwaStudii VARCHAR(255) REFERENCES StudiaFilmowe ON DELETE CASCADE ON UPDATE CASCADE,
	FilmId UNIQUEIDENTIFIER REFERENCES Filmy ON DELETE CASCADE,
	PRIMARY KEY(FilmID, NazwaStudii)
);

CREATE TABLE Nagrody(
	ID UNIQUEIDENTIFIER DEFAULT NEWID() PRIMARY KEY,
	NazwaNagrody VARCHAR(80) NOT NULL CHECK (NazwaNagrody NOT LIKE '%[^a-zA-Z����󜟿��ʣ�ӌ��0-9,: -]%' AND NazwaNagrody LIKE '[A-Z��ʣ�ӌ��]%'),
	Rok SMALLINT NOT NULL CHECK (Rok >= 1900),
	Kategoria VARCHAR(80) NOT NULL CHECK (Kategoria NOT LIKE '%[^a-zA-Z����󜟿��ʣ�ӌ��0-9,: -]%' AND Kategoria LIKE '[A-Z��ʣ�ӌ��]%')
);

CREATE TABLE LudzieKina(
	ID UNIQUEIDENTIFIER DEFAULT NEWID() PRIMARY KEY,
	Imie VARCHAR(40) NOT NULL CHECK (Imie NOT LIKE '%[^a-zA-Z����󜟿��ʣ�ӌ��0-9 -]%' AND Imie LIKE '[A-Z��ʣ�ӌ��]%'),
	Nazwisko VARCHAR(40) NOT NULL CHECK (Nazwisko NOT LIKE '%[^a-zA-Z����󜟿��ʣ�ӌ��0-9 -]%' AND Nazwisko LIKE '[A-Z��ʣ�ӌ��]%'),
	Kraj VARCHAR(56) CHECK (Kraj NOT LIKE '%[^a-zA-Z����󜟿��ʣ�ӌ��0-9,: -]%' AND  Kraj LIKE '[A-Z��ʣ�ӌ��]%'),
	Wiek TINYINT CHECK (Wiek > 0 AND Wiek < 125),
	RokRozpocz�ciaKariery SMALLINT CHECK (RokRozpocz�ciaKariery >= 1893),
	Zdj�cie VARCHAR(255)
);

CREATE TABLE Re�yserzy(
	Id UNIQUEIDENTIFIER REFERENCES LudzieKina ON DELETE CASCADE PRIMARY KEY,
	StylTworzenia VARCHAR(500) CHECK (StylTworzenia NOT LIKE '%[^a-zA-Z����󜟿��ʣ�ӌ��0-9,: -]%')
);

CREATE TABLE Tworzenie(
	FilmId UNIQUEIDENTIFIER REFERENCES Filmy ON DELETE CASCADE,
	CzlowiekId UNIQUEIDENTIFIER REFERENCES Re�yserzy ON DELETE CASCADE,
	PRIMARY KEY(FilmID, CzlowiekId)
);

CREATE TABLE Aktorzy(
	CzlowiekId UNIQUEIDENTIFIER REFERENCES LudzieKina PRIMARY KEY,
	Wzrost SMALLINT CHECK (Wzrost > 0 AND Wzrost < 270)
);

CREATE TABLE Role(
	Nazwa VARCHAR(70) CHECK (Nazwa NOT LIKE '%[^a-zA-Z����󜟿��ʣ�ӌ��0-9,: -]%' AND Nazwa LIKE '[A-Z��ʣ�ӌ��]%'),
	FilmId UNIQUEIDENTIFIER REFERENCES Filmy ON DELETE CASCADE,
	CzlowiekId UNIQUEIDENTIFIER NOT NULL REFERENCES Aktorzy ON DELETE CASCADE,
	PRIMARY KEY(Nazwa, FilmID)
);

CREATE TABLE Recenzenci(
	ID UNIQUEIDENTIFIER DEFAULT NEWID() PRIMARY KEY,
	Imie VARCHAR(40) NOT NULL CHECK (Imie NOT LIKE '%[^a-zA-Z����󜟿��ʣ�ӌ��0-9 -]%' AND Imie LIKE '[A-Z��ʣ�ӌ��]%'),
	Nazwisko VARCHAR(40) NOT NULL CHECK (Nazwisko NOT LIKE '%[^a-zA-Z����󜟿��ʣ�ӌ��0-9 -]%' AND Nazwisko LIKE '[A-Z��ʣ�ӌ��]%')
);

CREATE TABLE OcenyFilmu(
	Id UNIQUEIDENTIFIER DEFAULT NEWID() PRIMARY KEY,
	Ocena TINYINT NOT NULL CHECK (Ocena >= 0 AND Ocena <= 100),
	Recenzja NVARCHAR(MAX) CHECK (Recenzja NOT LIKE '%[^a-zA-Z����󜟿��ʣ�ӌ��0-9!,: -]%'),
	FilmID UNIQUEIDENTIFIER NOT NULL REFERENCES Filmy ON DELETE CASCADE,
	RecenzentId UNIQUEIDENTIFIER NOT NULL REFERENCES Recenzenci ON DELETE CASCADE
);

CREATE TABLE Posiadanie_Przez_Film (
    IdNagrody UNIQUEIDENTIFIER REFERENCES Nagrody ON DELETE CASCADE,
    FilmId UNIQUEIDENTIFIER REFERENCES Filmy ON DELETE CASCADE,
    PRIMARY KEY (IdNagrody, FilmID)
);

CREATE TABLE Posiadanie_Przez_Re�ysera(
	IdNagrody UNIQUEIDENTIFIER REFERENCES Nagrody ON DELETE CASCADE,
	CzlowiekId UNIQUEIDENTIFIER REFERENCES Re�yserzy ON DELETE CASCADE,
	PRIMARY KEY(IdNagrody, CzlowiekId)
);

CREATE TABLE Posiadanie_Przez_Aktora(
	IdNagrody UNIQUEIDENTIFIER REFERENCES Nagrody ON DELETE CASCADE,
	CzlowiekId UNIQUEIDENTIFIER REFERENCES Aktorzy ON DELETE CASCADE,
	PRIMARY KEY(IdNagrody, CzlowiekId)
);

CREATE TABLE MuzykiFilmowe (
	Nazwa VARCHAR(40) CHECK (Nazwa NOT LIKE '%[^a-zA-Z����󜟿��ʣ�ӌ��0-9,: -]%' AND Nazwa LIKE '[A-Z��ʣ�ӌ��]%'),
	Autor VARCHAR(80) CHECK (Autor NOT LIKE '%[^a-zA-Z����󜟿��ʣ�ӌ��0-9,: -]%' AND Autor LIKE '[A-Z��ʣ�ӌ��]%'),
	Rok SMALLINT CHECK (Rok >= 1400),
	Gatunek VARCHAR(30) CHECK (Gatunek NOT LIKE '%[^a-zA-Z����󜟿��ʣ�ӌ��0-9,: -]%' AND  Gatunek LIKE '[A-Z��ʣ�ӌ��]%'),
	PRIMARY KEY(Nazwa, Autor)
);

CREATE TABLE MuzykaWFilmie (
	Id UNIQUEIDENTIFIER DEFAULT NEWID() PRIMARY KEY,
	CzasRozpoczecia TIME NOT NULL,
	CzasZakonczenia TIME NOT NULL,
	FilmId UNIQUEIDENTIFIER REFERENCES Filmy ON DELETE CASCADE,
	NazwaMuzyki VARCHAR(40),
	Autor VARCHAR(80),
	FOREIGN KEY (NazwaMuzyki, Autor) REFERENCES MuzykiFilmowe ON DELETE CASCADE ON UPDATE CASCADE,
	CHECK (CzasRozpoczecia < CzasZakonczenia)
);