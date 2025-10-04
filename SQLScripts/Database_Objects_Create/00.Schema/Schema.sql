IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = '{@Schema}')
    EXEC ('CREATE SCHEMA [{@Schema}]')