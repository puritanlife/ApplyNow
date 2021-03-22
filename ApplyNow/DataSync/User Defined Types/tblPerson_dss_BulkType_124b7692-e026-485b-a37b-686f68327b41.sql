﻿CREATE TYPE [DataSync].[tblPerson_dss_BulkType_124b7692-e026-485b-a37b-686f68327b41] AS TABLE (
    [PersonID]                   INT            NOT NULL,
    [BusinessName]               NVARCHAR (MAX) NULL,
    [FirstName]                  NVARCHAR (MAX) NULL,
    [MiddleName]                 NVARCHAR (MAX) NULL,
    [LastName]                   NVARCHAR (MAX) NULL,
    [DOB]                        DATE           NULL,
    [ResidentAlien]              BIT            NULL,
    [USCitizen]                  BIT            NULL,
    [GenderTypeID]               INT            NULL,
    [SSNTINTypeID]               INT            NULL,
    [BirthStateID]               INT            NULL,
    [IDNumber]                   NVARCHAR (100) NULL,
    [SSNTIN]                     NVARCHAR (100) NULL,
    [UUID]                       NVARCHAR (250) NULL,
    [CreatedDate]                DATETIME       NULL,
    [LastModifiedDate]           DATETIME       NULL,
    [sync_update_peer_timestamp] BIGINT         NULL,
    [sync_update_peer_key]       INT            NULL,
    [sync_create_peer_timestamp] BIGINT         NULL,
    [sync_create_peer_key]       INT            NULL,
    PRIMARY KEY CLUSTERED ([PersonID] ASC));

