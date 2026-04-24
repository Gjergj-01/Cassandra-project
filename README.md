# Cassandra-project

Project for the Large-Scale Data Management course (Big Data part)

### Description
A simple project Developed for the Big Data course to practice with **NoSQL** databases, precisely **Cassandra**.

I took a simple (and classic) database from Kaggle, [Netflix-movies](https://www.kaggle.com/datasets/shivamb/netflix-shows) for which e defined the following *"schema"*:

``` sql
CREATE KEYSPACE IF NOT EXISTS movies
    WITH REPLICATION = {"class": "SimpleStrategy","replication_factor": 1};
```

``` sql
CREATE TABLE IF NOT EXISTS movies.Netflix_titles (  
    show_id text,
    type text, 
    title text, 
    rating text,   
    duration text, 
    director text, 
    cast set<text>,    
    release_year int,
    country text, 
    PRIMARY KEY (type, show_id)
)
```

``` sql
CREATE TABLE IF NOT EXISTS movies.ratings (
    show_id text, 
    rating text, 
    type text, 
    title text, 
    duration text, 
    description text, 
    PRIMARY KEY (rating, type, show_id)
)
```
