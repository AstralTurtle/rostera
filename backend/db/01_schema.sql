-- Rostera attendance database (one per institution deployment).
--
-- Change from the mid-pitch ERD: roles are per course, not global.
-- There is one kind of user account. Whether someone is a student, an
-- instructor or a TA is stored on their enrollment in each class, so the
-- same person can teach one class and take another. CLASSES.faculty_id
-- is gone, and ENROLLMENT now holds course staff as well as students.

CREATE TABLE users (
    user_id       INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    full_name     VARCHAR(100) NOT NULL,
    email         VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    created_at    TIMESTAMPTZ  NOT NULL DEFAULT now()
);

CREATE TABLE classes (
    class_id   INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    class_name VARCHAR(100) NOT NULL,
    section    VARCHAR(20)  NOT NULL,
    created_at TIMESTAMPTZ  NOT NULL DEFAULT now(),
    UNIQUE (class_name, section)
);

-- Who belongs to which class, and in what role.
CREATE TABLE enrollment (
    class_id    INTEGER     NOT NULL REFERENCES classes (class_id) ON DELETE CASCADE,
    user_id     INTEGER     NOT NULL REFERENCES users (user_id) ON DELETE CASCADE,
    role        VARCHAR(20) NOT NULL CHECK (role IN ('student', 'instructor', 'ta')),
    enrolled_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    PRIMARY KEY (class_id, user_id)
);

CREATE INDEX enrollment_user_id_idx ON enrollment (user_id);

CREATE TABLE attendance_sessions (
    session_id     INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    class_id       INTEGER     NOT NULL,
    started_by     INTEGER     NOT NULL,
    started_at     TIMESTAMPTZ NOT NULL DEFAULT now(),
    closed_at      TIMESTAMPTZ,
    session_status VARCHAR(10) NOT NULL DEFAULT 'open'
                   CHECK (session_status IN ('open', 'closed')),
    -- The person who starts a session must be a member of that class.
    -- Checking that they are an instructor or TA is left to the API,
    -- because a foreign key can't look at the role column.
    FOREIGN KEY (class_id, started_by) REFERENCES enrollment (class_id, user_id),
    CHECK ((session_status = 'closed') = (closed_at IS NOT NULL))
);

CREATE INDEX attendance_sessions_class_id_idx ON attendance_sessions (class_id);

-- One row per user per session.
-- class_id is deliberately not stored here: it depends on session_id
-- alone, so storing it would be a partial dependency and break 2NF.
CREATE TABLE attendance_records (
    session_id        INTEGER     NOT NULL REFERENCES attendance_sessions (session_id) ON DELETE CASCADE,
    user_id           INTEGER     NOT NULL REFERENCES users (user_id) ON DELETE CASCADE,
    attendance_status VARCHAR(10) NOT NULL
                      CHECK (attendance_status IN ('present', 'flagged', 'absent')),
    verified_at       TIMESTAMPTZ,
    PRIMARY KEY (session_id, user_id)
);
