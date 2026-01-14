BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "email" (
    "id" bigserial PRIMARY KEY,
    "userProfileId" bigint NOT NULL,
    "googleMessageId" text NOT NULL,
    "googleThreadId" text NOT NULL,
    "subject" text,
    "fromEmail" text NOT NULL,
    "fromName" text,
    "toEmails" json NOT NULL,
    "ccEmails" json,
    "bccEmails" json,
    "snippet" text,
    "bodyPlainText" text,
    "bodyHtml" text,
    "isRead" boolean NOT NULL DEFAULT false,
    "isStarred" boolean NOT NULL DEFAULT false,
    "hasAttachments" boolean NOT NULL DEFAULT false,
    "labels" json NOT NULL,
    "receivedAt" timestamp without time zone NOT NULL,
    "createdAt" timestamp without time zone,
    "updatedAt" timestamp without time zone
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "email_attachment" (
    "id" bigserial PRIMARY KEY,
    "emailId" bigint NOT NULL,
    "attachmentId" text NOT NULL,
    "filename" text NOT NULL,
    "mimeType" text NOT NULL,
    "size" bigint NOT NULL,
    "createdAt" timestamp without time zone
);


--
-- MIGRATION VERSION FOR merlin
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('merlin', '20260114185134777', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260114185134777', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20251208110333922-v3-0-0', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251208110333922-v3-0-0', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_idp
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_idp', '20251208110420531-v3-0-0', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251208110420531-v3-0-0', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_core
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_core', '20251208110412389-v3-0-0', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251208110412389-v3-0-0', "timestamp" = now();


COMMIT;
