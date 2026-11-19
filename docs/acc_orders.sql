-- Orders from the "הזמנה חדשה" form: customer intake + a receipt issued at the provider. The row is
-- written before any provider call, so a crash or a lost answer never leads to a second receipt.
CREATE TABLE IF NOT EXISTS acc_orders (
  id                   INTEGER PRIMARY KEY AUTOINCREMENT,
  order_key            TEXT NOT NULL UNIQUE,             -- one per opened form: repeats return the same order
  connection_id        INTEGER NOT NULL REFERENCES acc_connections(id),
  status               TEXT NOT NULL DEFAULT 'draft',    -- draft | client_created | issuing | issued | failed | uncertain
  customer_id          INTEGER REFERENCES customers(id),
  customer_external_id TEXT,
  customer_name        TEXT NOT NULL DEFAULT '',
  data                 TEXT NOT NULL,                    -- the validated order (no card or bank numbers)
  total                INTEGER NOT NULL,                 -- agorot
  document_external_id TEXT,
  document_number      TEXT,
  pdf_url              TEXT,
  error                TEXT,
  client_uncertain     INTEGER NOT NULL DEFAULT 0,       -- a client creation whose answer was lost
  issuing_at           TEXT,
  issued_at            TEXT,
  created_at           TEXT NOT NULL DEFAULT ${NOW},
  updated_at           TEXT NOT NULL DEFAULT ${NOW}
);
CREATE INDEX IF NOT EXISTS idx_acc_orders_status ON acc_orders(status, id);
