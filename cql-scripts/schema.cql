-- Create the keyspace
CREATE KEYSPACE IF NOT EXISTS movies WITH REPLICATION = { 'class' : 'SimpleStrategy', 'replication_factor' : '1' };

-- Create the table Netflix_titles
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
);


-- Create the table ratings
CREATE TABLE IF NOT EXISTS movies.ratings (
    show_id text, 
    rating text, 
    type text, 
    title text, 
    duration text, 
    description text, 
    PRIMARY KEY (rating, type, show_id)
);


    
