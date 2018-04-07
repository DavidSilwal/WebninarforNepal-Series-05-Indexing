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
UPDATE STATISTICS [dbo].[Users];
GO

-- Review index definitions
EXEC [sp_helpindex] '[dbo].[Users]';
GO

-- Use this to get some insight into what's happening:
SET STATISTICS IO ON;
GO

-- Include Actual Execution Plan to view graphically

-- Without ANY useful indexes - what does this query do?
SELECT [e].[LastName], [e].[FirstName], 
  [e].[Location], [e].[AccountId]
FROM [dbo].[Users] AS [e]
WHERE [e].[LastName] LIKE '[S-Z]%';
GO
select top 10 * from dbo.Users
---------------------------------------------------------
-- Option 1: bookmark lookups
---------------------------------------------------------
CREATE INDEX [UsersLastNameIX]
ON [dbo].[Users] ([LastName]);
GO

-- Without hints, SQL Server doesn't use it:
SELECT [e].[LastName], [e].[FirstName], 
  [e].[Location], [e].[AccountId]
FROM [dbo].[Users] AS [e]
WHERE [e].[LastName] LIKE '[S-Z]%';
GO

-- How bad is it?
SELECT [e].[LastName], [e].[FirstName], 
  [e].[Location], [e].[AccountId]
FROM [dbo].[Users] AS [e] WITH (INDEX ([UsersLastNameIX]))
WHERE [e].[LastName] LIKE '[S-Z]%';
GO

---------------------------------------------------------
-- Option 2: all columns in key
---------------------------------------------------------
CREATE INDEX [UsersCoversAll4ColsIX] 
ON [dbo].[Users] ([LastName], [FirstName], [Location], [AccountId]);
GO

-- Without hints, SQL Server uses this one!
SELECT [e].[LastName], [e].[FirstName], 
  [e].[Location], [e].[AccountId]
FROM [dbo].[Users] AS [e]
WHERE [e].[LastName] LIKE '[S-Z]%';
GO

---------------------------------------------------------
-- Option 3: only LastName in the key
---------------------------------------------------------
CREATE INDEX [UsersLNinKeyInclude3OtherColsIX] 
ON [dbo].[Users] ([LastName])
INCLUDE ([FirstName], [Location], [AccountId]);
GO

-- But does SQL Server use it?
SELECT [e].[LastName], [e].[FirstName], 
  [e].[Location], [e].[AccountId]
FROM [dbo].[Users] AS [e]
WHERE [e].[LastName] LIKE '[S-Z]%';
GO

SELECT [e].[LastName], [e].[FirstName], 
  [e].[Location], [e].[AccountId]
FROM [dbo].[Users] AS [e] WITH (INDEX ([UsersLNinKeyInclude3OtherColsIX]))
WHERE [e].[LastName] LIKE '[S-Z]%';
GO

---------------------------------------------------------
-- Option 4: only LastName in the key
---------------------------------------------------------
CREATE INDEX [UsersLnFnMiIncludeAccountIdIX]
ON [dbo].[Users] ([LastName], [FirstName], [Location])
INCLUDE ([AccountId]);
GO

-- But does SQL Server use it?
SELECT [e].[LastName], [e].[FirstName], 
  [e].[Location], [e].[AccountId]
FROM [dbo].[Users] AS [e]
WHERE [e].[LastName] LIKE '[S-Z]%';
GO

SELECT [e].[LastName], [e].[FirstName], 
  [e].[Location], [e].[AccountId]
FROM [dbo].[Users] AS [e] WITH (INDEX ([UsersLnFnMiIncludeAccountIdIX]))
WHERE [e].[LastName] LIKE '[S-Z]%';
GO

SELECT [e].[LastName], [e].[FirstName], 
  [e].[Location], [e].[AccountId]
FROM [dbo].[Users] AS [e] WITH (INDEX ([UsersLNinKeyInclude3OtherColsIX]))
WHERE [e].[LastName] LIKE '[S-Z]%';
GO


---------------------------------------------------------
-- Query Tuning
---------------------------------------------------------

-- Option 3 is the best option for the QUERY


---------------------------------------------------------
-- Server Tuning
---------------------------------------------------------

-- Option 4 is probably the best for the server
-- (this is likely during index consolidation)
