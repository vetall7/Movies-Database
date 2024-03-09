# Movies Database SQL Implementation

This repository contains the SQL implementation of a movies database. The database schema includes tables for films, genres, film studios, awards, people in the film industry (directors, actors, reviewers), reviews, music related to films, and more. 

## Schema Overview

- **Filmy**: Stores information about films such as title, budget, country, release dates, summary, duration, etc.
- **Gatunki**: Contains information about genres along with their characteristics.
- **NalezyDo**: A many-to-many relationship table between films and genres.
- **StudiaFilmowe**: Holds data about film studios including name, country, and year of establishment.
- **Wytwarzanie**: Represents the many-to-many relationship between films and film studios.
- **Nagrody**: Stores information about awards with name, year, and category.
- **LudzieKina**: Contains data about people involved in the film industry such as their name, country, age, etc.
- **Reżyserzy**: Holds information specifically about directors along with their style of work.
- **Tworzenie**: Represents the many-to-many relationship between films and directors.
- **Aktorzy**: Contains data about actors including their height.
- **Role**: Stores information about roles played by actors in films.
- **Recenzenci**: Holds information about film reviewers.
- **OcenyFilmu**: Stores ratings and reviews given by reviewers for films.
- **Posiadanie_Przez_Film**: Represents the many-to-many relationship between films and awards.
- **Posiadanie_Przez_Reżysera**: Represents the many-to-many relationship between directors and awards.
- **Posiadanie_Przez_Aktora**: Represents the many-to-many relationship between actors and awards.
- **MuzykiFilmowe**: Contains information about music related to films including name, author, genre, and year.
- **MuzykaWFilmie**: Represents the usage of music in films with start and end times.

## Files Overview

- **create.sql**: SQL script to create the necessary tables.
- **insert.sql**: SQL script to insert sample data into the tables.
- **zapytania.sql**: SQL script containing sample queries to retrieve information from the database.

## Usage

1. Run the `create_tables.sql` script to create the database schema.
2. Optionally, run the `insert_data.sql` script to populate the tables with sample data.
3. Use the `queries.sql` script to execute queries and retrieve information from the database.
