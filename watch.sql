drop user watch@localhost;
drop database nwatch;
create database nwatch;
use nwatch;

CREATE TABLE USERS (
    USERID int NOT NULL AUTO_INCREMENT,
    FNAME varchar(60),
    LNAME varchar(60),
    HOUSE varchar(120),
    USERNAME varchar(20) UNIQUE,
    PASSWORD varchar(20),
    PRIMARY KEY (USERID)
);

INSERT INTO USERS(USERNAME,PASSWORD,FNAME,LNAME,HOUSE) VALUES ('admin','password123','JACK','OTOOL','64 THE GREEN');
INSERT INTO USERS(USERNAME,PASSWORD,FNAME,LNAME,HOUSE) VALUES ('POP','kjsdfkjsd','JACK','OTOOL','66 THE GREEN');
INSERT INTO USERS(USERNAME,PASSWORD,FNAME,LNAME,HOUSE) VALUES ('jibby','ksd','JACK','OTOOL','646 T fdgfdg dfg HE GREEN');
INSERT INTO USERS(USERNAME,PASSWORD,FNAME,LNAME,HOUSE) VALUES ('poo','lll','JACK','OTOOL','64 THE GREEN');
INSERT INTO USERS(USERNAME,PASSWORD,FNAME,LNAME,HOUSE) VALUES ('wank','poo','JACK','OTOOL','64 THE GREEN');
INSERT INTO USERS(USERNAME,PASSWORD,FNAME,LNAME,HOUSE) VALUES ('josshh','pass','JACK','OTOOL','64 THE GREEN');
INSERT INTO USERS(USERNAME,PASSWORD,FNAME,LNAME,HOUSE) VALUES ('ur maaa','ddd','JACK','OTOOL','64 THE GREEN');


CREATE USER 'watch'@'localhost' IDENTIFIED BY '3342234Pp&^';
GRANT ALL PRIVILEGES ON nwatch.USERS TO 'watch'@'localhost';

