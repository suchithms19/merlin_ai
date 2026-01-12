BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "calendar" (
    "id" bigserial PRIMARY KEY,
    "userProfileId" bigint NOT NULL,
    "googleCalendarId" text NOT NULL,
    "name" text NOT NULL,
    "description" text,
    "backgroundColor" text,
    "isPrimary" boolean NOT NULL,
    "createdAt" timestamp without time zone,
    "updatedAt" timestamp without time zone
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "calendar_event" (
    "id" bigserial PRIMARY KEY,
    "userProfileId" bigint NOT NULL,
    "calendarId" text NOT NULL,
    "googleEventId" text NOT NULL,
    "title" text NOT NULL,
    "description" text,
    "startTime" timestamp without time zone NOT NULL,
    "endTime" timestamp without time zone NOT NULL,
    "location" text,
    "attendees" json NOT NULL,
    "organizerEmail" text,
    "recurrenceRule" text,
    "status" text NOT NULL,
    "createdAt" timestamp without time zone,
    "updatedAt" timestamp without time zone
);


--
-- MIGRATION VERSION FOR merlin
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('merlin', '20260112182144202', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260112182144202', "timestamp" = now();

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
