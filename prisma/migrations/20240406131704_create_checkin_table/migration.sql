-- AlterarTabela
CREATE TABLE check_ins (
    id SERIAL PRIMARY KEY NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    attendee_id TEXT NOT NULL, -- Alterado o tipo de dados para TEXT
    CONSTRAINT check_ins_attendee_id_fkey FOREIGN KEY (attendee_id) REFERENCES attendees (id) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CriarÍndice
CREATE UNIQUE INDEX check_ins_attendee_id_key ON check_ins (attendee_id);
