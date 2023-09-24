CREATE TABLE [dbo].[Team_Player] (
    [TeamID]   INT NOT NULL,
    [PlayerID] INT NOT NULL,
    CONSTRAINT [PK_Team_Player] PRIMARY KEY CLUSTERED ([PlayerID] ASC),
    CONSTRAINT [FK_Team_Player_Players] FOREIGN KEY ([PlayerID]) REFERENCES [dbo].[Players] ([PlayerID]),
    CONSTRAINT [FK_Team_Player_Teams] FOREIGN KEY ([TeamID]) REFERENCES [dbo].[Teams] ([TeamID])
);

