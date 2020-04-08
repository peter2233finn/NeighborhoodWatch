	create database nwatch;
	use nwatch;

	CREATE TABLE USERS (
	    USERID int NOT NULL AUTO_INCREMENT,
	    FNAME varchar(60) NOT NULL,
	    LNAME varchar(60) NOT NULL,
	    HOUSE varchar(120),
	    USERNAME varchar(20) UNIQUE NOT NULL,
	    PASSWORD varchar(20) NOT NULL,
	    PRIMARY KEY (USERID)
	);

	insert into USERS(USERNAME,PASSWORD,FNAME,LNAME) values('admin','password123','Admin','Admin');

	CREATE TABLE EVENT (
	    ID int NOT NULL AUTO_INCREMENT,
	    REGPLATE varchar(60),
	    PHOTOLOC varchar(120),
	    TIME TIMESTAMP,
	    PRIMARY KEY (ID) 
	);

	CREATE TABLE SCANNERLIMBO (
	    ID int NOT NULL AUTO_INCREMENT,
	    MAC varchar(60),
	    ESSID varchar(60),
	    TIME TIMESTAMP NOT NULL,
	    PRIMARY KEY (ID)
	);

	CREATE TABLE CAMEVENT (
	    VIDID int NOT NULL AUTO_INCREMENT,
	    VIDDIR varchar(120) UNIQUE,
	    PLATE varchar(20),
	    TIME TIMESTAMP UNIQUE,
	    PRIMARY KEY (VIDID)
	);

	CREATE TABLE SCANNER (
	    MAC varchar(60),
	    ESSID varchar(60),
	    TIME TIMESTAMP,
	    TRILAT varchar(60),
	    TRILONG varchar(60),
	    ADDRESS varchar(120),
	    LASTSEEN varchar(60)
	);

	CREATE TABLE BEACON (
	    MAC varchar(60),
	    ESSID varchar(60),
	    VENDOR varchar(60),
	    TIME TIMESTAMP
	);

	CREATE TABLE LISTS (
	    LISTID int NOT NULL AUTO_INCREMENT,
	    WLIST varchar(15) UNIQUE,
	    MACWLIST varchar(17) UNIQUE,
	    MACBLIST varchar(17) UNIQUE,
	    BLIST varchar(15) UNIQUE,
	    USERID int NOT NULL,
	    TIMESTAMP TIMESTAMP,
	    PRIMARY KEY (LISTID),
	    FOREIGN KEY (USERID) REFERENCES USERS(USERID)
	);


	CREATE USER 'watch'@'localhost' IDENTIFIED BY '3342234Pp&^';
	GRANT ALL PRIVILEGES ON nwatch.* TO 'watch'@'localhost';

