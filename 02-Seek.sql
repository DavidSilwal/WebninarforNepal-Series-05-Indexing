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

-- What tables exist?
SELECT [t].* 
FROM [sys].[tables] AS [t];
GO

-------------------------------------------------------------------------------
-- Employee Table as a Clustered Table
-------------------------------------------------------------------------------

-- Review table definition and indexes
EXEC [sp_help] '[dbo].[Posts]';
GO

-- Use this to get some insight into what's happening:
SET STATISTICS IO ON;
GO

-- NOTE: IOs alone are not the ONLY way to understand
-- what's going on. We'll add graphical showplan as well.
-- Use Query, Include Actual Execution Plan

-- Obvious case where a seek can be performed
SELECT [p].Id
FROM [dbo].[Posts] AS [p]
WHERE [p].Id = 2548;
GO

-- Less obvious case where a seek can be performed
SELECT p.Id, p.OwnerUserId
FROM [dbo].[Posts] AS [p]
WHERE p.OwnerUserId =82511;
GO
--341

-- Bookmark lookups allow you to find data based
-- on secondary index keys
--Key Lookup

SELECT [p].* 
FROM [dbo].[Posts] AS [p]
WHERE p.OwnerUserId =82511;
GO


-- Use this to get some insight into what's happening:
SET STATISTICS IO ON;
GO

-- NOTE: I/Os alone are not the ONLY way to understand
-- what's going on. We'll add graphical showplan as well.
-- Use Query, Include Actual Execution Plan

-- Obvious case where a seek can be performed
SELECT [p].* 
FROM [dbo].[Posts] AS [p]
WHERE [p].[Id] = 890;
GO

-- A "clustered index seek" can be misleading
SELECT [p].* 
FROM [dbo].[Posts] AS [p]
WHERE [p].[Id] > 0;
GO

-------------------------------------------------------------------------------
-- PostsHeap Table as a Heap
-------------------------------------------------------------------------------

-- Review table definition and indexes
EXEC [sp_help] [PostsHeap];
GO

-- Limited cases on our heap due to minimal indexes
-- You need indexes for "seeking"
SELECT  [p].Id
FROM [dbo].[PostsHeap] AS [p]
WHERE [p].Id = 2548;
GO

-- Less obvious case where a seek can be performed
SELECT p.Id, p.OwnerUserId
FROM [dbo].[PostsHeap] AS [p]
WHERE p.OwnerUserId =82511;
GO

