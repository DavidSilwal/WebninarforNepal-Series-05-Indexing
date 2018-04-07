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

-- All table names in this database
SELECT [t].* 
FROM [sys].[tables] AS [t];
GO

-- When you upgrade a database, you should always 
-- UPDATE STATISTICS! 
UPDATE STATISTICS [dbo].[Posts];
GO

select top 10  * from dbo.Posts

-- Review table definition and indexes
EXEC [sp_help] '[dbo].[Posts]';
GO

-- What does the status column look like?
SELECT [e].[PostTypeId], COUNT(*) AS [Rows]
FROM [dbo].[Posts] AS [e]
GROUP BY [e].[PostTypeId]
ORDER BY [e].[PostTypeId];
GO

-- All posts by PostTypeID 

CREATE INDEX [PostPostTypeIX]
ON [dbo].[Posts] ([PostTypeId]);
GO

-- Use this to get some insight into what's happening:
SET STATISTICS IO ON;
GO

-- Include Actual Execution Plan


-- Will your queries use it?
SELECT [e].[LastEditorDisplayName], [e].[OwnerUserId]
FROM [dbo].[Posts] AS [e]
WHERE [e].[PostTypeId] = 4;
GO

-- Will your queries use it?
SELECT [e].[LastEditorDisplayName], [e].[OwnerUserId]
FROM [dbo].[Posts] AS [e]
WHERE [e].[PostTypeId] = 5;
GO

-- For all Userss with
-- a specific PostTypeID (and for all of the different types)
-- a normal covering index as
CREATE INDEX [UsersStatusCoveringIX]
ON [dbo].[Posts] ([PostTypeId])
INCLUDE ([LastEditorDisplayName], [OwnerUserId]);
GO

-- Any/all PostType requests can use it:
SELECT  [e].[LastEditorDisplayName], [e].[OwnerUserId]
FROM [dbo].[Posts] AS [e]
WHERE [e].[PostTypeId] = 5;
GO

SELECT  [e].[LastEditorDisplayName], [e].[OwnerUserId]
FROM [dbo].[Posts] AS [e]
WHERE [e].[PostTypeId] = 1;
GO

SELECT  [e].[LastEditorDisplayName], [e].[OwnerUserId]
FROM [dbo].[Posts] AS [e]
WHERE [e].[PostTypeId] > 2;
GO
