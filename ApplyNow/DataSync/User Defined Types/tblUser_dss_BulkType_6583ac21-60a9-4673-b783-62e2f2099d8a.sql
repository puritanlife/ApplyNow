﻿CREATE TYPE [DataSync].[tblUser_dss_BulkType_6583ac21-60a9-4673-b783-62e2f2099d8a] AS TABLE (
    [UserId]                     INT           NOT NULL,
    [PersonID]                   INT           NULL,
    [UserTypeID]                 INT           NULL,
    [Email]                      VARCHAR (75)  NULL,
    [Pass]                       VARCHAR (60)  NULL,
    [Attempt]                    INT           NULL,
    [locked]                     BIT           NULL,
    [Last_Login]                 DATETIME      NULL,
    [IsAdmin]                    BIT           NULL,
    [PasswordChangeDate]         DATETIME      NULL,
    [Question1]                  VARCHAR (255) NULL,
    [Answer1]                    VARCHAR (255) NULL,
    [Question2]                  VARCHAR (255) NULL,
    [Answer2]                    VARCHAR (255) NULL,
    [Question3]                  VARCHAR (255) NULL,
    [Answer3]                    VARCHAR (255) NULL,
    [Question1ChangeDate]        DATETIME      NULL,
    [Answer1ChangeDate]          DATETIME      NULL,
    [Question2ChangeDate]        DATETIME      NULL,
    [Answer2ChangeDate]          DATETIME      NULL,
    [Question3ChangeDate]        DATETIME      NULL,
    [Answer3ChangeDate]          DATETIME      NULL,
    [CreatedDate]                DATETIME      NULL,
    [LastModifiedDate]           DATETIME      NULL,
    [sync_update_peer_timestamp] BIGINT        NULL,
    [sync_update_peer_key]       INT           NULL,
    [sync_create_peer_timestamp] BIGINT        NULL,
    [sync_create_peer_key]       INT           NULL,
    PRIMARY KEY CLUSTERED ([UserId] ASC));

