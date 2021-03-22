CREATE TABLE [DataSync].[schema_info_dss] (
    [schema_major_version] INT            NOT NULL,
    [schema_minor_version] INT            NOT NULL,
    [schema_extended_info] NVARCHAR (100) NOT NULL,
    CONSTRAINT [PK_DataSync.schema_info_dss] PRIMARY KEY CLUSTERED ([schema_major_version] ASC, [schema_minor_version] ASC)
);

