-- Create a demo user in seed.sql
INSERT INTO auth.users (
    email,
    encrypted_password,
    email_confirmed_at,
    raw_app_meta_data,
    raw_user_meta_data
)
VALUES (
    'demo@mgmt.golf',
    crypt('password', gen_salt('bf')),
    now(),
    '{"provider":"email","providers":["email"]}',
    '{"name":"Demo User"}'
) ON CONFLICT (email) DO NOTHING;