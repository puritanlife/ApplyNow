CREATE SCHEMA [dss]
    AUTHORIZATION [##MS_SyncAccount##];


GO
EXECUTE sp_addextendedproperty @name = N'MS_name', @value = N'DataSync', @level0type = N'SCHEMA', @level0name = N'dss';

