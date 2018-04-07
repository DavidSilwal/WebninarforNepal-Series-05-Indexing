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


-- UPDATE STATISTICS in Posts table! 
UPDATE STATISTICS [dbo].[Posts];
GO

-- Review index definitions
EXEC [sp_helpindex] '[dbo].[Posts]';
GO

-- Use this to get some insight into what's happening:
SET STATISTICS IO ON;
SET STATISTICS TIME ON;
GO

-- Include Actual Execution Plan to view graphically


-- When there are 10,000 rows, the NC covering SCAN is best:
SELECT [e].[Id], [e].[LastEditorDisplayName]
FROM [dbo].[Posts] AS [e]
WHERE [e].[Id] < 27845;
GO

-- If there are only 1,000 rows, the clustered index seek is better:
SELECT [e].[Id], [e].[LastEditorDisplayName]
FROM [dbo].[Posts] AS [e] 
WHERE [e].[Id] < 1000;
GO  

drop index NCCoveringSeekableIX on dbo.Posts

-- If this query were critical, I'd *CONSIDER* creating
-- a nonclustered, covering, SEEKABLE index:
CREATE INDEX [NCCoveringSeekableIX] 
ON [dbo].[Posts] ([Id], [LastEditorDisplayName]);
GO

-- Now, it doesn't matter what range I use!
SELECT [e].[Id], [e].[LastEditorDisplayName]
FROM [dbo].[Posts] AS [e]
WHERE [e].[Id] < 27845;
GO

-- It's still best:
SELECT [e].[Id], [e].[LastEditorDisplayName]
FROM [dbo].[Posts] AS [e] 
WHERE [e].[Id] < 1000;
GO  

-- It's still best - even here:
SELECT [e].[Id], [e].[LastEditorDisplayName]
FROM [dbo].[Posts] AS [e] 
WHERE [e].[Id] < 80000;
GO  

-------------------------------------------------------------------------------
-- what's best depends on the QUERY
-- and the different costs of the possible options!

-- For critical queries, I'd consider covering but be careful
-- covering ALWAYS works (and VERY well). 

-- Do not  over index! 
-------------------------------------------------------------------------------
