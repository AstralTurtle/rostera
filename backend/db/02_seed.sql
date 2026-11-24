-- Sample data for local development. All passwords are fake placeholder hashes.

INSERT INTO users (full_name, email, password_hash) VALUES
    ('Dr. Maya Chen',   'mchen@example.edu',    'dev-hash'),  -- 1: instructor in 336, student in 410
    ('Prof. Leo Ortiz', 'lortiz@example.edu',   'dev-hash'),  -- 2: instructor in 410
    ('Sam Rivera',      'srivera@example.edu',  'dev-hash'),  -- 3: TA in 336, student in 410
    ('Priya Nair',      'pnair@example.edu',    'dev-hash'),  -- 4: student
    ('Jordan Lee',      'jlee@example.edu',     'dev-hash'),  -- 5: student
    ('Amara Okafor',    'aokafor@example.edu',  'dev-hash');  -- 6: student

INSERT INTO classes (class_name, section) VALUES
    ('CSC 336 Database Systems', 'A'),   -- 1
    ('CSC 410 Machine Learning', 'B');   -- 2

INSERT INTO enrollment (class_id, user_id, role) VALUES
    (1, 1, 'instructor'),
    (1, 3, 'ta'),
    (1, 4, 'student'),
    (1, 5, 'student'),
    (1, 6, 'student'),
    (2, 2, 'instructor'),
    (2, 1, 'student'),   -- same person who teaches CSC 336
    (2, 3, 'student'),
    (2, 4, 'student');

-- One finished session in CSC 336, started by its instructor.
INSERT INTO attendance_sessions (class_id, started_by, started_at, closed_at, session_status) VALUES
    (1, 1, '2026-11-18 10:00-05', '2026-11-18 10:15-05', 'closed');

INSERT INTO attendance_records (session_id, user_id, attendance_status, verified_at, flag_reason) VALUES
    (1, 4, 'present', '2026-11-18 10:02-05', NULL),
    (1, 5, 'flagged', '2026-11-18 10:04-05', 'Outside the geofence radius'),
    (1, 6, 'absent',  NULL,                  NULL);
