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

## QUERIES

### Query 1

```sql
SELECT *
FROM movies.ratings 
WHERE rating = 'TV-MA' AND type = 'Movie' 
LIMIT 10 ; 
```

### Query 2

``` sql
SELECT show_id, title
FROM movies.netflix_titles
WHERE type = 'TV Show' AND rating = 'TV-14'
LIMIT 10 ;
```

We get the following answer from the database:

```
InvalidRequest: Error from server: code=2200 [Invalid query] message="Cannot execute this query as it might involve data filtering and thus may have unpredictable performance. If you want to execute this query despite the performance unpredictability, use ALLOW FILTERING"
```

This happens because rating is not part of the primary key, and therefore is not considered to *partition* the data. Therefore the system might have to look at different partitions to retireved the requested data, thus possibly downgrading the performances.
At this point we have to choices, use `ALLOW FILTERING`: 

``` sql
SELECT show_id, title
FROM movies.netflix_titles
WHERE type = 'TV Show' AND rating = 'TV-14'
LIMIT 10
ALLOW FILTERING;
```

Or define an index on the `rating` attribute:

``` sql
CREATE INDEX rating_index ON movies.netflix_titles (rating);
```

Now by running again the original query, we get the desired result.

```
 show_id | title
---------+-------------------------------------------------
    s103 |        Countdown: Inspiration4 Mission to Space
    s122 |                                  Hotel Del Luna
    s149 |                                      HQ Barbers
    s182 |       Turning Point: 9/11 and the War on Terror
    s187 |                            Hometown Cha-Cha-Cha
     s21 | Monsters Inside: The 24 Faces of Billy Milligan
    s219 |                                  Titletown High
     s22 |                          Resurrection: Ertugrul
    s220 |                                      EDENS ZERO
    s225 |                                  Motel Makeover
```


### Query 3

```sql
SELECT COUNT(*)
FROM movies.ratings
WHERE rating = 'TV-14' AND type = 'TV Show';
```

### Query 4

``` sql
SELECT show_id, title, type 
FROM movies.ratings
WHERE rating = 'TV-MA' 
ORDER BY show_id ASC
LIMIT 10;
```

We get:

```
InvalidRequest: Error from server: code=2200 [Invalid query] message="Order by currently only supports the ordering of columns following their declared order in the PRIMARY KEY"
```

This because the **primary key** is defined as: `PRIMARY KEY (rating, type, show_id)`.
To solve the problem, either we change the **primary key** to: `PRIMARY KEY (rating, show_id, type)` (so we invert `show_id` and `type`) or we fix the `type` attribute. So for example we write the query as:

``` sql
SELECT show_id, title, type 
FROM movies.ratings
WHERE rating = 'TV-MA' AND type = 'Movie'
ORDER BY show_id ASC
LIMIT 10;
```