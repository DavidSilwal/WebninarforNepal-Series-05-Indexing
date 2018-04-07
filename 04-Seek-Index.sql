-------------------------------------------------------------------------------
-- Stackoverflow  Database 
-- Download location: https://stackoverflowdb.blob.core.windows.net/stackoverflowdbcontainer/StackOverflow2010-compress.bak
-------------------------------------------------------------------------------

-- Set the database compat mode for the version you're running:
--	110 SQL Server 2012
--	120 SQL Server 2014
--	130 SQL Server 2016
--	140 SQL Server 2017


ALTER DATABASE [StackOverflow2010]
		SET COMPATIBILITY_LEVEL = 140; -- SQL Server 2017
GO

-------------------------------------------------------------------------------
-- Demo: Uses a SCAN to find data
-------------------------------------------------------------------------------

USE [StackOverflow2010];
GO

-- When you upgrade a database, you should always 
-- UPDATE STATISTICS! 
UPDATE STATISTICS [dbo].[Posts];
GO

-- Review index definitions
EXEC [sp_helpindex] '[dbo].[Posts]';
GO

-- Use this to get some insight into what's happening:
SET STATISTICS IO ON;
GO

--Include Actual Execution Plan to view graphically


-- The example we saw before used the SSNUK index - but
-- with bookmark lookups:
SELECT [p].* 
FROM [dbo].[Posts] AS [p]
WHERE [p].[OwnerUserId] BETWEEN 469345 AND 469395;
GO  

-- The following query is covered by the index ALONE - no 
-- bookmark lookups are necessary.
-- The big difference is in the limited select list:
SELECT [p].[Id], [p].[OwnerUserId]
FROM [dbo].[Posts] AS [p]
WHERE [p].[OwnerUserId] BETWEEN 469345 AND 469395;
GO 

-------------------------------------------------------------------------------
-- But even range queries benefit!
-------------------------------------------------------------------------------

-- If a query is not selective enough then the index
-- won't be used (when it's not covered):
SELECT [p].* 
FROM [dbo].[Posts] AS [p]
WHERE [p].[OwnerUserId] BETWEEN 469345 AND 469395;
GO  

-- Again, it's all about the limited select list:
SELECT [p].[Id], [p].[OwnerUserId]
FROM [dbo].[Posts] AS [p]
WHERE [p].[OwnerUserId] BETWEEN 469345 AND 469395;
GO 

-- Even if the entire data set is required:
SELECT [p].[Id], [p].[OwnerUserId]
FROM [dbo].[Posts] AS [p]
WHERE [p].[OwnerUserId] BETWEEN 469345 AND 469395;
GO 

-- It's even useful without a WHERE clause:
SELECT [p].[Id], [p].[OwnerUserId]
FROM [dbo].[Posts] AS [p]

GO 