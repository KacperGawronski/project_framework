DROP USER IF EXISTS 'userhandler'@'localhost';
CREATE USER 'userhandler'@'localhost' IDENTIFIED BY '123';
DROP DATABASE IF EXISTS users;
CREATE DATABASE users;
GRANT ALL PRIVILEGES ON users.* TO 'userhandler'@'localhost';
USE users;
CREATE TABLE Users (
	id int PRIMARY KEY NOT NULL AUTO_INCREMENT,
	login varchar(50) NOT NULL,
	pass char(128) NOT NULL, 
	mail varchar(100));

CREATE TABLE Sessions (
	id int PRIMARY KEY NOT NULL AUTO_INCREMENT,
	user_id int, 
	cookie char(128),
	salt int,
	FOREIGN KEY(user_id) REFERENCES Users(id)
);

