-- RedefinirTabelas
BEGIN;

-- Desativar chaves estrangeiras temporariamente
ALTER TABLE "attendees" DROP CONSTRAINT "attendees_event_id_fkey";
ALTER TABLE "check_ins" DROP CONSTRAINT "check_ins_attendee_id_fkey";

-- Criar novas tabelas
CREATE TABLE "new_attendees" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "name" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "created_at" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "event_id" TEXT NOT NULL
);
CREATE TABLE "new_check_ins" (
    "id" SERIAL NOT NULL PRIMARY KEY,
    "created_at" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "attendee_id" TEXT NOT NULL
);

-- Copiar dados das tabelas antigas para as novas
INSERT INTO "new_attendees" ("id", "name", "email", "created_at", "event_id")
SELECT "id", "name", "email", "created_at", "event_id" FROM "attendees";

INSERT INTO "new_check_ins" ("id", "created_at", "attendee_id")
SELECT "id", "created_at", "attendee_id" FROM "check_ins";

-- Remover tabelas antigas
DROP TABLE "attendees";
DROP TABLE "check_ins";

-- Recriar índices únicos
CREATE UNIQUE INDEX "attendees_event_id_email_key" ON "new_attendees"("event_id", "email");
CREATE UNIQUE INDEX "check_ins_attendee_id_key" ON "new_check_ins"("attendee_id");

-- Reativar chaves estrangeiras
ALTER TABLE "new_attendees" ADD CONSTRAINT "new_attendees_event_id_fkey" FOREIGN KEY ("event_id") REFERENCES "events" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "new_check_ins" ADD CONSTRAINT "new_check_ins_attendee_id_fkey" FOREIGN KEY ("attendee_id") REFERENCES "new_attendees" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

COMMIT;