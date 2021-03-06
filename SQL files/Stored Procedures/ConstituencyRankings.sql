USE [Parliament]
GO
/****** Object:  StoredProcedure [dbo].[ConstituencyRankings]    Script Date: 6/30/2022 2:02:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER PROC [dbo].[ConstituencyRankings]
	@P INT, -- Specify Province
    @Base INT -- Filter Type

AS
BEGIN
	-- Total Votes Of Constituencies Ranking
	IF (@Base = 1)
	BEGIN
		SELECT C.C_Name, SUM(C.F_Votes_no + C.S_Votes_no) AS [Votes]
		FROM Province AS P
			INNER JOIN 
			Constituency AS C 
			ON C.P_ID = P.ID
			WHERE P.ID = @P
			GROUP BY C.C_Name
			ORDER BY SUM(C.F_Votes_no + C.S_Votes_no) DESC
	END
	-- Political Factions Ranking Of Constituencies
	ELSE IF (@Base = 2)
	BEGIN
		SELECT Co.C_Name, C.Political_Faction, COUNT(C.Political_Faction) AS [Total Count]
		FROM Candidate_List AS CL
			INNER JOIN 
			Candidate AS C
			ON C.ID = CL.Candidate_ID
			INNER JOIN 
			Constituency AS Co
			ON Co.ID = C.CO_ID
			INNER JOIN 
			Province AS P
			ON Co.P_ID = P.ID
			WHERE P.ID = 2
			GROUP BY C.Political_Faction, C_Name
			ORDER BY COUNT(C.Political_Faction) DESC
	END
	-- Participating Ranking In Each Constituency
	ELSE
	BEGIN
		SELECT C_Name, ROUND(CAST(SUM(C.F_Votes_no + C.S_Votes_no) AS FLOAT) / P.Voter_Population * 100, 4) AS [Population(%)]
		FROM Province AS P 
			INNER JOIN
			Constituency AS C
			ON C.P_ID = P.ID
			WHERE P.ID = @P
			GROUP BY C_Name, Voter_Population
			ORDER BY CAST(SUM(C.F_Votes_no + C.S_Votes_no) AS FLOAT) / P.Voter_Population DESC
	END
END

EXEC ConstituencyRankings @P = 1, @Base = 1
EXEC ConstituencyRankings @P = 1, @Base = 2
EXEC ConstituencyRankings @P = 1, @Base = 3
EXEC ConstituencyRankings @P = 2, @Base = 2