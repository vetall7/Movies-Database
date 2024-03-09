USE Films

SELECT * FROM NalezyDo
UPDATE Gatunki SET Nazwa = 'Comedy' WHERE Nazwa = 'Romance';
SELECT * FROM NalezyDo
/*
UPDATE StudiaFilmowe SET Nazwa = 'Company21' WHERE Nazwa = 'Company20';

UPDATE MuzykiFilmowe SET Autor = 'Beethoven' WHERE Nazwa = 'Theme1' AND Autor = 'Composer1' 

UPDATE Filmy SET Budzet = 1200000 WHERE Tytul = 'Movie1' AND Kraj = 'Poland' AND DataRozpoczecia = '2001-01-01';

UPDATE StudiaFilmowe SET RokUtworzenia = 1995 WHERE Nazwa = 'Company1' AND Kraj = 'Poland';

UPDATE Re¿yserzy SET StylTworzenia = 'Adventure-comedy' WHERE ID = (SELECT ID FROM LudzieKina WHERE Imie = 'Bob' AND Nazwisko = 'Johnson' AND Wiek = 45);




DELETE FROM Filmy WHERE Tytul = 'Movie1' AND Kraj = 'Poland' AND DataRozpoczecia = '2001-01-01';
DELETE FROM StudiaFilmowe WHERE Nazwa = 'Company1';

DELETE FROM Wytwarzanie WHERE NazwaStudii = 'Company2' AND FilmId = (SELECT FilmId FROM Filmy WHERE Tytul = 'Movie6' AND Kraj='Germany' AND DataRozpoczecia='2010-06-15');
DELETE FROM LudzieKina WHERE Imie = 'John' AND Nazwisko = 'Doe' AND Wiek=40;
*/

SELECT * FROM NalezyDo
DELETE FROM Gatunki WHERE Nazwa = 'Thriller';
SELECT * FROM NalezyDo