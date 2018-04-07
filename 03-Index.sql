USE [StackOverflow2010]
GO
CREATE NONCLUSTERED INDEX [NCI_Posts_OwnerUserID]
ON [dbo].[Posts] ([OwnerUserId])
GO


-- a nonclustered, covering, SEEKABLE index:
CREATE INDEX [NCCoveringSeekableIX] 
ON [dbo].[Posts] ([Id], [OwnerUserId]);
GO


CREATE INDEX [UsersLnFnMiIncludeAccountIdIX]
ON [dbo].[Users] ([LastName], [FirstName], [Location])
INCLUDE ([AccountId]);
GO
