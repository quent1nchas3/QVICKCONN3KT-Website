/*
# Create contact_messages table (single-tenant, no auth)

1. New Tables
- `contact_messages`
  - `id` (uuid, primary key)
  - `name` (text, not null) — sender's name
  - `email` (text, not null) — sender's email for replies
  - `subject` (text, not null) — message subject line
  - `message` (text, not null) — the body of the message
  - `read` (boolean, default false) — tracks whether the message has been read
  - `created_at` (timestamptz, default now()) — when the message was submitted

2. Security
- Enable RLS on `contact_messages`.
- Allow anon + authenticated INSERT only — visitors can submit messages without signing in.
- No SELECT/UPDATE/DELETE for anon — only the project owner (via service role / dashboard) can read or manage messages.
*/

CREATE TABLE IF NOT EXISTS contact_messages (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  email text NOT NULL,
  subject text NOT NULL,
  message text NOT NULL,
  read boolean NOT NULL DEFAULT false,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE contact_messages ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "anon_insert_contact_messages" ON contact_messages;
CREATE POLICY "anon_insert_contact_messages"
  ON contact_messages FOR INSERT
  TO anon, authenticated
  WITH CHECK (true);
