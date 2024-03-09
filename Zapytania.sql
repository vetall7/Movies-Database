 --1
 /* Dziennikarz, żeby napisać w nowym wydaniu swojego czasopisma artykuł o krajach z największą ilością aktorów, którzy osiągnęli ogromny sukces, jest zainteresowany zestawieniem krajów wg. 
 Ilości aktorów którzy otrzymali nagrodę w 2023 roku.
 Oprócz tego trzeba podać informację o ilości nagród zdobytych przez wszystkich aktorów tego kraju oraz najczęstszą kategorię w której aktorzy zdobyli nagrody dla każdego kraju.
 Zestawienie powinno być posortowane w kolejności od największej ilości aktorów do najmniejszej (a jeżeli ilość aktorów taka sama, to według ilości nagród).*/

WITH NagrodyAktorow AS (
    SELECT 
        L.ID AS AktorId,
        L.Kraj,
        N.Kategoria,
        COUNT(N.ID) AS IloscNagrod
    FROM LudzieKina L
    JOIN Posiadanie_Przez_Aktora PPA ON L.ID = PPA.CzlowiekId
    JOIN Nagrody N ON PPA.IdNagrody = N.ID
    WHERE N.Rok = 2023
    GROUP BY L.ID, L.Kraj, N.Kategoria
)

SELECT 
    NA.Kraj,
    COUNT(DISTINCT NA.AktorId) AS IloscAktorow,
    SUM(NA.IloscNagrod) AS IloscNagrod,
    MAX(NA.Kategoria) AS NajczestszaKategoria
FROM NagrodyAktorow NA
GROUP BY NA.Kraj
ORDER BY IloscAktorow DESC, IloscNagrod DESC;

 --2
/* Administrator serwisu “Świat filmów” potrzebuje dla nowego rozdziału ze statystycznymi danymi o kinematografii zestawienia dla każdego recenzenta który reżyser jest ich ulubionym reżyserem
(należy wyświetlić zarówno imię jak i nazwisko zarówno recenzenta jak i reżysera), na podstawie średniej z ocen wystawionych przez nich filmom wyprodukowanych przez tego reżysera. 
Zestawienie powinno być posortowane alfabetycznie wg. Nazwiska a następnie wg. Imienia recenzenta 
*/

WITH AverageDirectorRating AS (
    SELECT 
        R.Imie AS Recenzent_Imie, 
        R.Nazwisko AS Recenzent_Nazwisko, 
        LD.Imie AS Rezyser_Imie, 
        LD.Nazwisko AS Rezyser_Nazwisko,
        AVG(Ocena.Ocena) AS SredniaOcena
    FROM Recenzenci R
    JOIN OcenyFilmu Ocena ON R.ID = Ocena.RecenzentId
    JOIN Filmy F ON Ocena.FilmID = F.FilmId
    JOIN Tworzenie T ON F.FilmId = T.FilmId
    JOIN LudzieKina LD ON T.CzlowiekId = LD.ID
    GROUP BY R.ID, LD.ID, R.Imie, R.Nazwisko, LD.Imie, LD.Nazwisko
),
RankedDirectors AS (
    SELECT 
        Recenzent_Imie, 
        Recenzent_Nazwisko, 
        Rezyser_Imie, 
        Rezyser_Nazwisko,
        SredniaOcena,
        ROW_NUMBER() OVER (PARTITION BY Recenzent_Imie, Recenzent_Nazwisko ORDER BY SredniaOcena DESC) AS RowNum
    FROM AverageDirectorRating
)
SELECT 
    Recenzent_Imie,
    Recenzent_Nazwisko,
    Rezyser_Imie,
    Rezyser_Nazwisko,
    SredniaOcena
FROM RankedDirectors
WHERE RowNum = 1
ORDER BY Recenzent_Nazwisko, Recenzent_Imie;

 --3
 /*  Stowarzyszenie aktorów wniosło zapytanie o przesłanie danych na temat Najczęstszych kolaboracji między aktorami a reżyserami. 
Zestawienie powinno zawierać 20 najczęstszych par reżyser – aktor, posortowanych według ilości wspólnych filmów (ilość filmów dla każdej pary też trzeba przesłać).
*/

WITH RezyserAktorCounts AS (
    SELECT
        LK_Rezyser.Imie AS Rezyser_Imie, 
        LK_Rezyser.Nazwisko AS Rezyser_Nazwisko,
        LK_Aktor.Imie AS Aktor_Imie, 
        LK_Aktor.Nazwisko AS Aktor_Nazwisko,
        COUNT(*) AS FilmCount
    FROM Reżyserzy R
    JOIN Tworzenie TK ON R.Id = TK.CzlowiekId
    JOIN Role Rola ON TK.FilmId = Rola.FilmId
    JOIN LudzieKina LK_Aktor ON Rola.CzlowiekId = LK_Aktor.ID
    JOIN LudzieKina LK_Rezyser ON R.Id = LK_Rezyser.ID
    GROUP BY LK_Rezyser.ID, LK_Aktor.ID, LK_Rezyser.Imie, LK_Rezyser.Nazwisko, LK_Aktor.Imie, LK_Aktor.Nazwisko
)
SELECT TOP 20
    Rezyser_Imie,
    Rezyser_Nazwisko,
    Aktor_Imie,
    Aktor_Nazwisko,
    FilmCount
FROM (
    SELECT
        Rezyser_Imie,
        Rezyser_Nazwisko,
        Aktor_Imie,
        Aktor_Nazwisko,
        FilmCount,
        RANK() OVER (PARTITION BY Rezyser_Imie, Rezyser_Nazwisko ORDER BY FilmCount DESC) AS RowNum
    FROM RezyserAktorCounts
) RankedRezyserAktor
WHERE RowNum = 1
ORDER BY FilmCount DESC;


 --4
 /* Na jeden z forumów znanego serwisu filmowego przyszło takie zapytanie: “Podczas oglądania filmu usłyszałem piosenkę, która bardzo mi się spodobała, 
 ale nie pamietam z jakiego filmu pochodzi. Znam tylko że reżyserem tego filmu jest John Doe, gatunek filmu na pewno “Thriller”, a główną rolę “Hero” w
 tym filmie zagrał Ricardo Lopez. Który to mógłby być film i jaka jest możliwa nazwa tej piosenki?”. Trzeba napisać zapytanie, które pokaże wszystkie filmy i
 piosenki (oraz autorów), które spełniają te kryteria, żeby pomóc tej osobie w znalezieniu piosenki.
*/

SELECT DISTINCT
    MF.NazwaMuzyki,
    MF.Autor,
    F.Tytul AS TytulFilmu
FROM MuzykaWFilmie MF
JOIN Filmy F ON MF.FilmId = F.FilmId
JOIN NalezyDo ND ON F.FilmId = ND.FilmId
JOIN Gatunki G ON ND.NazwaGatunku = G.Nazwa
JOIN Tworzenie T ON F.FilmId = T.FilmId
JOIN Role Rola ON F.FilmId = Rola.FilmId
JOIN LudzieKina LK_Rezyser ON T.CzlowiekId = LK_Rezyser.ID
JOIN LudzieKina LK_Aktor ON Rola.CzlowiekId = LK_Aktor.ID
WHERE 
    G.Nazwa = 'Thriller'
    AND LK_Rezyser.Imie = 'John'
    AND LK_Rezyser.Nazwisko = 'Doe'
    AND LK_Aktor.Imie = 'Ricardo'
    AND LK_Aktor.Nazwisko = 'Lopez'
    AND Rola.Nazwa = 'Hero';


 --5
 /* Dziennikarz, którego specjalizacją jest utwory muzyczne w filmach, dla swojego nowego artykułu o najdłuższych muzykach w znanych filmach potrzebuje
 informacji na temat filmów, które zdobyły nagrody w kategorii “Muzyka”, oraz top 3 najdłuższe utwory muzyczne dla każdego z tych filmów, oprócz tego trzeba 
 wyświetlić długość utworów, nazwę, autora, rok i gatunek każdej piosenki.
*/

WITH FilmyZMuzyką AS (
    SELECT DISTINCT F.Tytul AS TytulFilmu, F.FilmId
    FROM Filmy F
    JOIN Posiadanie_Przez_Film PPF ON F.FilmId = PPF.FilmId
	JOIN Nagrody N ON PPF.IdNagrody = N.ID
    WHERE N.Kategoria = 'Muzyka'
)
, TopUtwory AS (
    SELECT
        FZM.TytulFilmu,
        FZM.FilmId,
        MF.Nazwa,
        MF.Autor,
        MF.Rok,
        MF.Gatunek,
        DATEDIFF(MINUTE, MW.CzasRozpoczecia, MW.CzasZakonczenia) AS CzasTrwaniaMinuty,
        ROW_NUMBER() OVER (PARTITION BY FZM.FilmId ORDER BY DATEDIFF(SECOND, MW.CzasRozpoczecia, MW.CzasZakonczenia) DESC) AS RowNum
    FROM FilmyZMuzyką FZM
    JOIN MuzykaWFilmie MW ON FZM.FilmId = MW.FilmId
    JOIN MuzykiFilmowe MF ON MW.NazwaMuzyki = MF.Nazwa AND MW.Autor = MF.Autor
)
SELECT
    TytulFilmu,
    Nazwa,
    Autor,
    Rok,
    Gatunek,
    CONCAT(CzasTrwaniaMinuty / 60, ':', CzasTrwaniaMinuty % 60) AS DlugoscUtworu
FROM
    TopUtwory
WHERE
    RowNum <= 3
ORDER BY
    TytulFilmu, RowNum;


 --6
/* Dla napisania artykułu badawczego, który porównuje popularność gatunków filmowych za ostatnie 50 lat, musimy wyprowadzić lata, w których był 
ten sam najpopularniejszy gatunek i pokazać który dokładnie jest to gatunek. To zapytanie bardzo uprości zadanie dla dziennikarza, który teraz nie 
musi samodzielnie porównywać informacje za ostatnie 50 lat. 
*/

WITH GatunekRank AS (
    SELECT 
        YEAR(F.DataRozpoczecia) AS Rok,
        G.Nazwa AS Gatunek,
        COUNT(*) AS IloscFilmow,
        RANK() OVER (PARTITION BY YEAR(F.DataRozpoczecia) ORDER BY COUNT(*) DESC) AS Ranking
    FROM Gatunki G
    JOIN NalezyDo ND ON G.Nazwa = ND.NazwaGatunku
    JOIN Filmy F ON ND.FilmId = F.FilmId
    WHERE YEAR(F.DataRozpoczecia) BETWEEN YEAR(GETDATE()) - 50 AND YEAR(GETDATE())
    GROUP BY YEAR(F.DataRozpoczecia), G.Nazwa
)
, NajpopularniejszePary AS (
    SELECT
        R1.Rok AS Rok1,
        R1.Gatunek AS Gatunek,
        R2.Rok AS Rok2
    FROM GatunekRank R1
    JOIN GatunekRank R2 ON R1.Ranking = R2.Ranking AND R1.Rok < R2.Rok
    WHERE R1.Gatunek = R2.Gatunek
)

SELECT 
    Rok1,
    Gatunek,
    Rok2
FROM 
    NajpopularniejszePary;

 --7
 /* Zapytanie ma na celu przedstawienie top 3 najdroższe wytwórni filmowe według wydanych pieniędzy na filmy w 2023 roku, zakładając,
 że filmy zostały wyprodukowane przez studia założone w 21 wieku. Takiej informacji potrzebuje dziennikarz który ma na celu napisać artykuł
 o młodych wytwórniach, które w krótkim czasie osiągnęły największego sukcesu. Podać trzeba zarówno nazwę studii jak i wydaną sumę.
*/

WITH SpendingByStudios AS (
    SELECT
        SF.Nazwa AS NazwaStudia,
        SUM(F.Budzet) AS SumaBudzetu
    FROM
        StudiaFilmowe SF
    JOIN Wytwarzanie WF ON SF.Nazwa = WF.NazwaStudii
    JOIN Filmy F ON WF.FilmId = F.FilmId
    WHERE
        YEAR(F.DataRozpoczecia) = 2023
        AND SF.RokUtworzenia >= 2000
    GROUP BY
        SF.Nazwa
)
SELECT
    NazwaStudia,
    SumaBudzetu
FROM (
    SELECT
        NazwaStudia,
        SumaBudzetu,
        ROW_NUMBER() OVER (ORDER BY SumaBudzetu DESC) AS Rownosc
    FROM
        SpendingByStudios
) AS RankedStudios
WHERE
    Rownosc <= 3;


 --8
 /* Dla artykułu na temat “Jak ocena filmu zależy od jego długości i gatunku” dziennikarz potrzebuje statystycznej informacji na ten temat,
 a dokładnie dla każdego gatunku ocenę długości jego filmów(długi, krótki lub średni oraz), oraz średnia ocena filmów tego gatunku.*/

SELECT Gatunek, 
       KategoriaDlugosci,
       AVG(OC.Ocena) AS SredniReiting
FROM (
   SELECT G.Nazwa AS Gatunek, 
         F.FilmId,
         CASE 
            WHEN F.CzasTrwania <= 90 THEN 'Krótki'
            WHEN F.CzasTrwania > 90 AND F.CzasTrwania <= 120 THEN 'Średni'
            WHEN F.CzasTrwania > 120 THEN 'Długi'
         END AS KategoriaDlugosci
   FROM Gatunki G
   JOIN NalezyDo ND ON G.Nazwa = ND.NazwaGatunku
   JOIN Filmy F ON ND.FilmId = F.FilmId
) AS FilmyDlugosc
LEFT JOIN OcenyFilmu OC ON FilmyDlugosc.FilmId = OC.FilmId
WHERE OC.Ocena IS NOT NULL
GROUP BY Gatunek, KategoriaDlugosci;

 --9
 /* Dziennikarz chce dowiedzieć się, czy jeden z kilku wymienionych aktorów kiedykolwiek grał w filmie stworzonym przez reżysera “John  Doe”,
 trzeba napisać zapytanie które będzie pokazywało wspólne filmy dla jednego z wielu aktora i reżysera.
*/ 

 GO 

CREATE VIEW FilmInfo AS
SELECT
    F.Tytul AS Film,
    LK_Rezyserzy.Imie + ' ' + LK_Rezyserzy.Nazwisko AS Rezyser,
    LK_Aktorzy.Imie + ' ' + LK_Aktorzy.Nazwisko AS Aktor,
    Rol.Nazwa AS Rola
FROM 
    Filmy F
JOIN Tworzenie T ON F.FilmId = T.FilmId
JOIN Reżyserzy R ON T.CzlowiekId = R.Id
JOIN Role Rol ON F.FilmId = Rol.FilmId
JOIN Aktorzy A ON Rol.CzlowiekId = A.CzlowiekId
JOIN LudzieKina LK_Aktorzy ON A.CzlowiekId = LK_Aktorzy.ID
JOIN LudzieKina LK_Rezyserzy ON R.Id = LK_Rezyserzy.ID;

GO

SELECT DISTINCT
	Film,
	Rezyser,
	Aktor
FROM 
		FilmInfo
WHERE 
	Rezyser = 'John Doe' 
	AND Aktor IN ('Ricardo Lopez', 'Tom Hardy', 'Joseph Gordon-Levitt');

DROP VIEW [FilmInfo];

 --10
 /*Dziennikarz który zajmuje się zestawieniem najbogatszych wytwórni filmowych potrzebuje informacji na temat tego, ile pieniędzy wydała studia
 na stworzenie swojego najdroższego filmu w tym wieku, oraz trzeba podać ile sumie pieniędzy było wydano za całą historię wytwórni.
 Bierzemy pod uwagę tylko te wytwórnie, które mają co najmniej trzy filmy. */

WITH StudioStats AS (
    SELECT 
        SF.Nazwa AS KinoStudia,
        COUNT(F.FilmId) AS LiczbaFilmow,
        SUM(F.Budzet) AS PotraconePieniadze,
        MAX(F.Budzet) AS MaxBudzet
    FROM 
        StudiaFilmowe SF
    JOIN Wytwarzanie W ON SF.Nazwa = W.NazwaStudii
    JOIN Filmy F ON W.FilmId = F.FilmId
    WHERE YEAR(F.DataRozpoczecia) >= 2000
    GROUP BY SF.Nazwa
    HAVING COUNT(F.FilmId) >= 3
)
SELECT 
    KinoStudia,
    LiczbaFilmow,
    PotraconePieniadze,
    MaxBudzet
FROM 
    StudioStats
ORDER BY 
    PotraconePieniadze DESC, MaxBudzet DESC;
