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

	insert into USERS(USERNAME,PASSWORD) values('admin','password123');

	CREATE TABLE EVENT (
	    ID int NOT NULL AUTO_INCREMENT,
	    REGPLATE varchar(60),
	    PHOTOLOC varchar(60),
	    TIME TIMESTAMP,
	    PRIMARY KEY (ID) 
	);

	CREATE TABLE TESTEVENT (
	    ID int NOT NULL AUTO_INCREMENT,
	    REGPLATE varchar(60),
	    PHOTOLOC varchar(60),
	    TIME TIMESTAMP,
	    PRIMARY KEY (ID) 
	);

	CREATE TABLE SCANNERLIMBO (
	    MAC varchar(60),
	    ESSID varchar(60),
	    TIME TIMESTAMP NOT NULL
	);

	CREATE TABLE CAMEVENT (
	    VIDID int NOT NULL AUTO_INCREMENT,
	    VIDDIR varchar(60),
	    PLATE varchar(20),
	    TIME TIMESTAMP,
	    PRIMARY KEY (VIDID)
	);

	CREATE TABLE SCANNER (
	    MAC varchar(60),
	    ESSID varchar(60),
	    TIME TIMESTAMP,
	    TRILAT varchar(60),
	    TRILONG varchar(60),
	    LASTSEEN varchar(60)
	);

	CREATE TABLE BEACON (
	    MAC varchar(60),
	    ESSID varchar(60),
	    TIME TIMESTAMP
	);

	CREATE TABLE LISTS (
	    LISTID int NOT NULL AUTO_INCREMENT,
	    WLIST varchar(15),
	    MACWLIST varchar(17),
	    MACBLIST varchar(17),
	    BLIST varchar(15),
	    USERID int NOT NULL,
	    TIMESTAMP TIMESTAMP,
	    PRIMARY KEY (LISTID),
	    FOREIGN KEY (USERID) REFERENCES USERS(USERID)
	);


	CREATE USER 'watch'@'localhost' IDENTIFIED BY '3342234Pp&^';
	GRANT ALL PRIVILEGES ON nwatch.* TO 'watch'@'localhost';


