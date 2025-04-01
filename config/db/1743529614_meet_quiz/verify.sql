SELECT CASE WHEN
    ( SELECT 1 FROM sqlite_master WHERE type = 'table'   AND name = 'meet'               ) +
    ( SELECT 1 FROM sqlite_master WHERE type = 'table'   AND name = 'quiz'               ) +
    ( SELECT 1 FROM sqlite_master WHERE type = 'index'   AND name = 'meet_instance'      ) +
    ( SELECT 1 FROM sqlite_master WHERE type = 'index'   AND name = 'quiz_instance'      ) +
    ( SELECT 1 FROM sqlite_master WHERE type = 'trigger' AND name = 'meet_last_modified' ) +
    ( SELECT 1 FROM sqlite_master WHERE type = 'trigger' AND name = 'quiz_last_modified' )
    = 6
THEN 1 ELSE 0 END;
