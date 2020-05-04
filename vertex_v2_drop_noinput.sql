DROP DATABASE IF EXISTS vertex_db;
create database vertex_db default CHARACTER SET = utf8 default COLLATE = utf8_general_ci;
use vertex_db;
CREATE TABLE user
(
    id INTEGER(4) unsigned NOT NULL auto_increment,
    name VARCHAR(32) NOT NULL,
    password VARCHAR(255) NOT NULL,

    PRIMARY KEY(id),
    UNIQUE KEY (name)
) ENGINE = INNODB;
ALTER TABLE user AUTO_INCREMENT=100;
CREATE TABLE channel
(
    id INTEGER(4) unsigned NOT NULL auto_increment,
    name VARCHAR(32) NOT NULL,
    creator_id INTEGER(4) unsigned NOT NULL, --  User ID of channel creator
    type ENUM ('TEXT', 'VOICE') NOT NULL,

    PRIMARY KEY(id),
    UNIQUE KEY (name, creator_id, type), -- avoid duplicate entries
    FOREIGN KEY(creator_id) REFERENCES user(id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = INNODB;
ALTER TABLE channel AUTO_INCREMENT=200;
CREATE TABLE message
(
    id INTEGER(4) unsigned NOT NULL auto_increment,
    channel INTEGER(4) unsigned NOT NULL,
    author INTEGER(4) unsigned NOT NULL,
    content VARCHAR(255) NOT NULL,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY(id),
    FOREIGN KEY(channel) REFERENCES channel(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY(author) REFERENCES user(id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = INNODB;
ALTER TABLE message AUTO_INCREMENT=300;
CREATE TABLE session
(
    id VARCHAR(255) NOT NULL, -- UUID
    user INTEGER(4) unsigned NOT NULL,
    expire_after INT(8) NOT NULL, -- Unix epoch time store

    PRIMARY KEY(id),
    FOREIGN KEY(user) REFERENCES user(id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = INNODB;
CREATE TABLE member
(
    channel INTEGER(4) unsigned NOT NULL,
    user INTEGER(4) unsigned NOT NULL,

    UNIQUE KEY (channel, user), -- avoid duplicate entries
    FOREIGN KEY(channel) REFERENCES channel(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY(user) REFERENCES user(id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = INNODB;