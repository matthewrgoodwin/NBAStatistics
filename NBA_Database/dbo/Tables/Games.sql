CREATE TABLE [dbo].[Games] (
    [GameID]       INT      NOT NULL,
    [HomeTeamID]   INT      NOT NULL,
    [AwayTeamID]   INT      NOT NULL,
    [GameDateTime] DATETIME NOT NULL,
    [HomeScore]    INT      NOT NULL,
    [AwayScore]    INT      NOT NULL,
    [MVPPlayerID]  INT      NOT NULL,
    CONSTRAINT [PK_Games] PRIMARY KEY CLUSTERED ([GameID] ASC),
    CONSTRAINT [FK_Games_Players] FOREIGN KEY ([MVPPlayerID]) REFERENCES [dbo].[Players] ([PlayerID]),
    CONSTRAINT [FK_Games_Teams] FOREIGN KEY ([HomeTeamID]) REFERENCES [dbo].[Teams] ([TeamID]),
    CONSTRAINT [FK_Games_Teams1] FOREIGN KEY ([AwayTeamID]) REFERENCES [dbo].[Teams] ([TeamID])
);

