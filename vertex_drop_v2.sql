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
INSERT INTO user (name, password) VALUES
    ('Bob', '$2y$12$fRe5UcrDaabLe3thSAu1HOQLBo0Nko6yX0yEHveYfLZuN4dw/TlYG'),    --  Password123%%    
    ('Alice', '$2y$12$oTM2Oia6UBBAy4uZIwCYlexn5eYg2buQIzNWzvq165sR.ulWBdXfi'),  --  Password123££
    ('John', '$2y$12$tW7YFaRVEc0sMQxfu.OKn./CNPwJK.db1k7nsy4eW.4asDRilEX82');   --  Password123()
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
INSERT INTO channel (name, creator_id, type) VALUES
    ('Study Chat', 100, 'TEXT'),
    ('Work Group', 102, 'TEXT'),
    ('Gaming Sessions', 100, 'VOICE');
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
INSERT INTO message (channel, author, content) VALUES
    (200, 100, 'Hey did our professor release the exam timetable yet?'),
    (201, 102, 'Alice the meeting is re-scheduled to mid-day.'),
    (202, 100, 'Will we play another round?');
CREATE TABLE session
(
    id VARCHAR(255) NOT NULL, -- UUID
    user INTEGER(4) unsigned NOT NULL,
    expire_after INT(8) NOT NULL, -- Unix epoch time store

    PRIMARY KEY(id),
    FOREIGN KEY(user) REFERENCES user(id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = INNODB;
INSERT INTO session (id, user, expire_after) VALUES
    ('e26195ee-72a1-11ea-bc55-0242ac130003', 100, 5),
    ('e261980a-72a1-11ea-bc55-0242ac130003', 101, 10),
    ('e2619904-72a1-11ea-bc55-0242ac130003', 102, 15);
CREATE TABLE member
(
    channel INTEGER(4) unsigned NOT NULL,
    user INTEGER(4) unsigned NOT NULL,

    UNIQUE KEY (channel, user), -- avoid duplicate entries
    FOREIGN KEY(channel) REFERENCES channel(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY(user) REFERENCES user(id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = INNODB;
INSERT INTO member (channel, user) VALUES
    (200, 100),
    (200, 101),
    (200, 102),
    (201, 101),
    (201, 102),
    (202, 100),
    (202, 102);
SELECT id AS 'ID', name AS 'USER NAME', password AS PASSWORD FROM user;
SELECT id AS 'ID', name AS 'CHANNEL NAME', creator_id AS 'CHANNEL CREATOR', type AS 'CHANNEL TYPE' FROM channel ORDER BY id;
SELECT id AS 'ID', channel AS 'CHANNEL ID', author AS 'AUTHOR ID', content AS 'MESSAGE CONTENT', timestamp AS TIMESTAMP FROM message ORDER BY timestamp DESC;
SELECT id AS 'SESSION ID', user AS 'USER ID', expire_after AS 'EXPIRE AFTER' FROM session;
SELECT channel AS 'CHANNEL ID ', user AS 'USER ID' FROM member;
#