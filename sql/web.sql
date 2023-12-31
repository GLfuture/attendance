create database if not exists web;

use web;

create table user (
    uid         bigint primary key AUTO_INCREMENT,
    sex         tinyint,
    username    varchar(20),
    password    varchar(20),
    email       varchar(40),
    phone       varchar(11),
    address     varchar(40)
);

create table card (
    cid         tinyint primary key AUTO_INCREMENT,
    cname       varchar(20),
    description varchar(100)
);


create table conn (
    uid         bigint,
    cid         tinyint,
    num         int,
    foreign key(uid) references user(uid),
    foreign key(cid) references card(cid)
);

create table manager (
    mid         int primary key AUTO_INCREMENT,
    username    varchar(20),
    password    varchar(20)
);

create table time (
    uid         bigint,
    total_time  bigint default 0,
    need_time   bigint default 0,
    foreign key(uid) references user(uid)
);

DELIMITER //
CREATE TRIGGER insert_user AFTER INSERT ON user FOR EACH ROW
BEGIN 
INSERT INTO time(uid) VALUES (NEW.uid); 
END//
DELIMITER ;

DELIMITER //
CREATE TRIGGER delete_user BEFORE DELETE ON user FOR EACH ROW
BEGIN
DELETE FROM conn WHERE uid=OLD.uid;
DELETE FROM time WHERE uid=OLD.uid;
END//
DELIMITER ;

DELIMITER //
CREATE TRIGGER delete_card BEFORE DELETE ON card FOR EACH ROW
BEGIN
DELETE FROM conn WHERE uid=OLD.cid;
END//
DELIMITER ;

create user 'gong'@'%' identified by '123456';

grant all privileges on web.* to 'gong'@'%' ;
