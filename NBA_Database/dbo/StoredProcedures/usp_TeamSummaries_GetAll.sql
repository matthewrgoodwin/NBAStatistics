CREATE PROCEDURE [dbo].[usp_TeamSummaries_GetAll]
AS
WITH 
HomeGames AS (
		SELECT	
				HomeTeamID AS TeamID, 
				COUNT(HomeTeamID) AS HomeGamesPlayed,
				COUNT(CASE WHEN HomeScore > AwayScore THEN 1 ELSE NULL END) AS HomeGamesWon,
				COUNT(CASE WHEN HomeScore < AwayScore THEN 1 ELSE NULL END) AS HomeGamesLost,
				MAX(GameDateTime) LastHomeGameDate
		FROM 
			Games
		GROUP BY 
			HomeTeamID
), 
AwayGames AS (
		SELECT 
				AwayTeamID as TeamID,
				COUNT(AwayTeamID) as AwayGamesPlayed, 
				COUNT(CASE WHEN AwayScore > HomeScore THEN 1 ELSE NULL END) AS AwayGamesWon,
				COUNT(CASE WHEN AwayScore < HomeScore THEN 1 ELSE NULL END) AS AwayGamesLost,
				MAX(GameDateTime) LastAwayGameDate
		FROM 
			Games
		GROUP BY 
			AwayTeamID
),
MVPS AS (
	SELECT 
			TeamID, 
			MVPPlayerID, 
			p.Name, 
			COUNT(MVPPlayerID) AS MVPGames
	FROM 
			Games
	JOIN	
			Team_Player tp
	ON		MVPPlayerID = tp.PlayerID
	JOIN	
			Players p
	ON		MVPPlayerID = p.PlayerID
	GROUP BY	MVPPlayerID, 
				TeamID, 
				p.Name
),
TeamMVPGames AS (
	SELECT TeamID, MAX(MVPGames) AS MaxPlayerMVPS
	FROM MVPS m
	GROUP BY m.TeamID
),
LastHomeAndAwayGames AS (
	SELECT 
			TeamID, 
			LastHomeGameDate AS GameDate
	FROM 
			HomeGames hg
	UNION ALL
	SELECT 
			TeamID, 
			LastAwayGameDate AS GameDate
	FROM 
			AwayGames ag
),
LastGames AS (
	SELECT 
			TeamID, 
			MAX(GameDate) As LastGameDate
	FROM 
			LastHomeAndAwayGames
	GROUP BY 
			TeamID
),
GamePointsDifferences AS (
	SELECT 
			HomeTeamID AS TeamID,
			HomeScore - AwayScore AS PointDifference,
			GameID,
			HomeScore As PointsFor,
			AwayScore As PointsAgainst
	FROM 
			Games
	UNION ALL
	SELECT 
			AwayTeamID AS TeamID, 
			AwayScore - HomeScore AS PointDifference, 
			GameID, 
			AwayScore As PointsFor, 
			HomeScore As PointsAgainst
	FROM Games
),
TeamBiggestWinsAndLosses AS (
	SELECT 
			TeamID, 
			(CASE WHEN MAX(PointDifference) > 0 THEN MAX(PointDifference) ELSE NULL END) AS BiggestWin, 
			(CASE WHEN MIN(PointDifference) < 0 THEN MIN(PointDifference) ELSE NULL END) AS BiggestLoss
	FROM 
			GamePointsDifferences
	GROUP BY 
			TeamID
)

SELECT	T.TeamID
		,T.Name
		,T.Stadium
		,T.Logo
		,T.URL
		,HG.HomeGamesPlayed
		,AG.AwayGamesPlayed
		,HomeGamesPlayed + AwayGamesPlayed AS TotalGamesPlayed
		,HomeGamesLost + AwayGamesLost AS TotalGamesLost
		,HomeGamesWon + AwayGamesWon AS TotalGamesWon
		,MVP.Name AS SeasonMVP
		,BiggestWin.PointsFor AS BiggestWinPointsFor
		,BiggestWin.PointsAgainst AS BiggestWinPointsAgainst
		,BiggestLoss.PointsFor AS BiggestLossPointsFor
		,BiggestLoss.PointsAgainst AS BiggestLossPointsAgainst
		,LastGame.LastGameDate
		,LastGame.Stadium AS LastGameStadium
FROM
	Teams T
CROSS APPLY (
	SELECT 
		HomeGamesPlayed, 
		HomeGamesLost, 
		HomeGamesWon
	FROM	
		HomeGames
	WHERE	
		HomeGames.TeamID = T.TeamID
) HG
CROSS APPLY (
	SELECT 
		AwayGamesPlayed, 
		AwayGamesWon, 
		AwayGamesLost
	FROM	
		AwayGames
	WHERE 
		AwayGames.TeamID = T.TeamID
) AG
--Player for team with most games as MVP. If tied, chosen alphabetically.
CROSS APPLY (
	SELECT TOP 1 WITH TIES
			Name 
	FROM 
		TeamMVPGames
	INNER JOIN 
		MVPS
	ON 
		TeamMVPGames.TeamID = MVPS.TeamID 
		AND MaxPlayerMVPS = MVPS.MVPGames --join players with mvpgames equal to the max mvps any player has got on the team
	WHERE 
		TeamMVPGames.TeamID = T.TeamID
	ORDER BY 
		Name
)  MVP
CROSS APPLY (
	SELECT 
		LastGameDate,
		hometeam.Stadium
	FROM 
		LastGames lg
	JOIN 
		Games GameData --get data of last game team playe
	ON 
		GameDateTime = LastGameDate --join game where the date matches the last date the team played and the team ID is either home or away.
		AND 
		(GameData.AwayTeamID = lg.TeamID
		OR
		GameData.HomeTeamID = lg.TeamID)
	JOIN 
		Teams hometeam
	ON 
		GameData.HomeTeamID = hometeam.TeamID
	WHERE lg.TeamId = T.TeamID
) LastGame
--Join game with biggest points difference in favour of team. Where >1 exist, choose game with most total goals scored.
CROSS APPLY (
	SELECT TOP 1 WITH TIES 
			T.TeamID,
			GameID,
			PointsFor,
			PointsAgainst
	FROM 
		GamePointsDifferences gpd
	JOIN 
		TeamBiggestWinsAndLosses bwl 
	ON 
		bwl.TeamID = gpd.TeamID
		AND gpd.PointDifference = bwl.BiggestWin --join game where the point difference is the same as the team's biggest win
	WHERE 
		bwl.TeamID = T.TeamID
	ORDER BY 
		gpd.PointsFor DESC
) BiggestWin
--Join game with biggest points difference against team. Where >1 exist, choose game with least total goals scored.
CROSS APPLY (
	SELECT TOP 1 with TIES
			T.TeamID,
			GameID,
			PointsFor,
			PointsAgainst
	FROM 
		GamePointsDifferences gpd
	JOIN 
		TeamBiggestWinsAndLosses bwl
	ON 
		bwl.TeamID = gpd.TeamID
		AND gpd.PointDifference = bwl.BiggestLoss --join game where the point difference is the same as the team's biggest loss
	WHERE 
		bwl.TeamID = T.TeamID
	ORDER BY gpd.PointsFor ASC
) BiggestLoss
ORDER BY T.TeamID
