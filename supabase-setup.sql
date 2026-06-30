-- ============================================================
--  SETUP DATABASE — jalankan SEKALI di Supabase > SQL Editor
--  (Jika sebelumnya sudah membuat tabel versi lama, hapus dulu:
--   drop table if exists wf_audit, wf_edges, wf_nodes, workflows cascade; )
-- ============================================================

create table workflows (
  id text primary key, name text,
  created_by text, created_at timestamptz default now()
);

create table wf_nodes (
  id text primary key, workflow_id text, type text, label text, descr text,
  input_data text, output_data text, rules text, pic text,
  cx int, cy int, w int, h int,
  updated_by text, updated_at timestamptz default now()
);

create table wf_edges (
  eid text primary key, workflow_id text, src text, tgt text, label text,
  via text, fs text, ts text, lx int, ly int,
  updated_by text, updated_at timestamptz default now()
);

create table wf_audit (
  id bigserial primary key, workflow_id text, node_id text, node_label text,
  field text, old_value text, new_value text,
  changed_by text, changed_at timestamptz default now()
);

-- Keamanan: hanya user yang sudah login (Google) yang bisa baca/tulis
alter table workflows enable row level security;
alter table wf_nodes  enable row level security;
alter table wf_edges  enable row level security;
alter table wf_audit  enable row level security;

create policy p_wf    on workflows for all to authenticated using (true) with check (true);
create policy p_nodes on wf_nodes  for all to authenticated using (true) with check (true);
create policy p_edges on wf_edges  for all to authenticated using (true) with check (true);
create policy p_audit on wf_audit  for all to authenticated using (true) with check (true);

-- Aktifkan sinkronisasi real-time
alter publication supabase_realtime add table wf_nodes, wf_edges, wf_audit;
