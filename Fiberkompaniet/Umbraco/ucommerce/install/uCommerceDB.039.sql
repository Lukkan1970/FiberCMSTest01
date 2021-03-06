/*
	Adds sort order to product definitions and definitions
*/
SET NUMERIC_ROUNDABORT OFF
GO
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'tmpErrors')) DROP TABLE tmpErrors
GO
CREATE TABLE tmpErrors (Error int)
GO
SET XACT_ABORT ON
GO
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
GO
BEGIN TRANSACTION
GO
PRINT N'Altering [dbo].[uCommerce_Definition]'
GO
ALTER TABLE [dbo].[uCommerce_Definition] ADD
[SortOrder] [int] NOT NULL CONSTRAINT [DF_uCommerce_Definition_SortOrder] DEFAULT ((0))
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Altering [dbo].[uCommerce_ProductDefinition]'
GO
ALTER TABLE [dbo].[uCommerce_ProductDefinition] ADD
[SortOrder] [int] NOT NULL CONSTRAINT [DF_uCommerce_ProductDefinition_SortOrder] DEFAULT ((0))
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Altering [dbo].[uCommerce_ProductDefinitionField]'
GO
ALTER TABLE [dbo].[uCommerce_ProductDefinitionField] ADD
[SortOrder] [int] NOT NULL CONSTRAINT [DF_uCommerce_ProductDefinitionField_SortOrder] DEFAULT ((0))
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
IF EXISTS (SELECT * FROM tmpErrors) ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT>0 BEGIN
PRINT 'The database update succeeded'
COMMIT TRANSACTION
END
ELSE PRINT 'The database update failed'
GO
DROP TABLE tmpErrors
GO
