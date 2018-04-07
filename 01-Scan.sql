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

-------------------------------------------------------------------------------
-- Users Table as a Clustered Table
-------------------------------------------------------------------------------

-- Indexes and table description
EXEC [sp_help] '[dbo].[Users]';
GO

-- Logical reads and physical reads:
SET STATISTICS IO ON;
GO

-- Include Actual Execution Plan to view graphically

-- This query uses scan NONSARGABLE
SELECT [u].* 
FROM [dbo].[Users] AS [u]
WHERE [u].[DisplayName] LIKE N'%d%';
GO

-- Still the scan?
SELECT [u].* 
FROM [dbo].[Users] AS [u]
WHERE [u].[DisplayName] LIKE N'D%';
GO

-- Again scan is happenig ?
SELECT [u].* 
FROM [dbo].[Users] AS [u]
WHERE [u].[DisplayName] LIKE N'David';
GO


-------------------------------------------------------------------------------
-- UsersHeap Table as a Heap
-------------------------------------------------------------------------------

-- Indexes and table description
EXEC [sp_help] [UsersHeap];
GO

-- This query uses Table scan 
SELECT [u].* 
FROM [dbo].[UsersHeap] AS [u]
WHERE [u].[DisplayName] LIKE  N'%d%';
GO

