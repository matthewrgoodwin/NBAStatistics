CREATE TABLE [dbo].[Teams] (
    [TeamID]  INT           NOT NULL,
    [Name]    VARCHAR (100) NOT NULL,
    [Stadium] VARCHAR (100) NOT NULL,
    [Logo]    VARCHAR (100) NULL,
    [URL]     VARCHAR (50)  NULL,
    CONSTRAINT [PK_Teams] PRIMARY KEY CLUSTERED ([TeamID] ASC)
);

