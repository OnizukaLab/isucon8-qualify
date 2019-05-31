CREATE TABLE IF NOT EXISTS users (
    id          INTEGER PRIMARY KEY AUTOINCREMENT,
    nickname    VARCHAR(128) NOT NULL,
    login_name  VARCHAR(128) UNIQUE,
    pass_hash   VARCHAR(128) NOT NULL
);

CREATE TABLE IF NOT EXISTS events (
    id          INTEGER PRIMARY KEY AUTOINCREMENT,
    title       VARCHAR(128)     NOT NULL,
    public_fg   TINYINT(1)       NOT NULL,
    closed_fg   TINYINT(1)       NOT NULL,
    price       INTEGER UNSIGNED NOT NULL
);

CREATE TABLE IF NOT EXISTS sheets (
    id          INTEGER PRIMARY KEY AUTOINCREMENT,
    `rank`      VARCHAR(128)     NOT NULL,
    num         INTEGER UNSIGNED NOT NULL,
    price       INTEGER UNSIGNED NOT NULL,
    UNIQUE (`rank`, num)
);

CREATE TABLE IF NOT EXISTS reservations (
    id          INTEGER PRIMARY KEY AUTOINCREMENT,
    event_id    INTEGER UNSIGNED NOT NULL,
    sheet_id    INTEGER UNSIGNED NOT NULL,
    user_id     INTEGER UNSIGNED NOT NULL,
    reserved_at DATETIME(6)      NOT NULL,
    canceled_at DATETIME(6)      DEFAULT NULL
);

CREATE TABLE IF NOT EXISTS administrators (
    id          INTEGER PRIMARY KEY AUTOINCREMENT,
    nickname    VARCHAR(128) NOT NULL,
    login_name  VARCHAR(128) UNIQUE ,
    pass_hash   VARCHAR(128) NOT NULL
);
