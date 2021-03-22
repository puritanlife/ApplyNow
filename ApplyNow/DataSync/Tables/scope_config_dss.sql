CREATE TABLE [DataSync].[scope_config_dss] (
    [config_id]    UNIQUEIDENTIFIER NOT NULL,
    [config_data]  XML              NOT NULL,
    [scope_status] CHAR (1)         NULL,
    CONSTRAINT [PK_DataSync.scope_config_dss] PRIMARY KEY CLUSTERED ([config_id] ASC)
);

