CREATE TABLE IF NOT EXISTS meet (
    meet_id       INTEGER PRIMARY KEY,
    code          TEXT    NOT NULL CHECK( LENGTH(name) > 0 ) UNIQUE,
    name          TEXT    NOT NULL CHECK( LENGTH(name) > 0 ),
    location      TEXT,
    start         TEXT    NOT NULL DEFAULT ( STRFTIME( '%Y-%m-%d %H:%M-08:00', 'NOW', 'LOCALTIME' ) ),
    days          INTEGER NOT NULL DEFAULT 1,
    last_modified TEXT    NOT NULL DEFAULT ( STRFTIME( '%Y-%m-%d %H:%M:%f', 'NOW', 'LOCALTIME' ) ),
    created       TEXT    NOT NULL DEFAULT ( STRFTIME( '%Y-%m-%d %H:%M:%f', 'NOW', 'LOCALTIME' ) )
);
CREATE UNIQUE INDEX IF NOT EXISTS meet_instance ON meet ( name, location, start );
CREATE TRIGGER IF NOT EXISTS meet_last_modified
    AFTER UPDATE OF
        name,
        location,
        start,
        days
    ON meet
    BEGIN
        UPDATE meet
            SET last_modified = STRFTIME( '%Y-%m-%d %H:%M:%f', 'NOW', 'LOCALTIME' )
            WHERE meet_id = OLD.meet_id;
    END;

CREATE TABLE IF NOT EXISTS quiz (
    quiz_id       INTEGER PRIMARY KEY,
    meet_id       INTEGER NULL REFERENCES meet(meet_id) ON UPDATE CASCADE ON DELETE CASCADE,
    bracket       TEXT,
    name          TEXT,
    stats         TEXT,
    last_modified TEXT    NOT NULL DEFAULT ( STRFTIME( '%Y-%m-%d %H:%M:%f', 'NOW', 'LOCALTIME' ) ),
    created       TEXT    NOT NULL DEFAULT ( STRFTIME( '%Y-%m-%d %H:%M:%f', 'NOW', 'LOCALTIME' ) )
);
CREATE UNIQUE INDEX IF NOT EXISTS quiz_instance ON quiz ( meet_id, bracket, name );
CREATE TRIGGER IF NOT EXISTS quiz_last_modified
    AFTER UPDATE OF
        meet_id,
        bracket,
        name,
        stats
    ON quiz
    BEGIN
        UPDATE quiz
            SET last_modified = STRFTIME( '%Y-%m-%d %H:%M:%f', 'NOW', 'LOCALTIME' )
            WHERE quiz_id = OLD.quiz_id;
    END;
