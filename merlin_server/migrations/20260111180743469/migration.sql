BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "google_oauth_token" (
    "id" bigserial PRIMARY KEY,
    "userProfileId" bigint NOT NULL,
    "accessToken" text NOT NULL,
    "refreshToken" text NOT NULL,
    "expiresAt" timestamp without time zone NOT NULL,
    "createdAt" timestamp without time zone,
    "updatedAt" timestamp without time zone
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "user_profile" (
    "id" bigserial PRIMARY KEY,
    "authUserId" text NOT NULL,
    "email" text,
    "fullName" text,
    "createdAt" timestamp without time zone,
    "updatedAt" timestamp without time zone
);


--
-- MIGRATION VERSION FOR merlin
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('merlin', '20260111180743469', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260111180743469', "timestamp" = now();

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
