CREATE TABLE [dbo].[Players] (
    [PlayerID] INT           NOT NULL,
    [Name]     VARCHAR (100) NOT NULL,
    CONSTRAINT [PK_Players] PRIMARY KEY CLUSTERED ([PlayerID] ASC)
);

