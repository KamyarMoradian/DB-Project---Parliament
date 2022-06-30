--Political Faction Ranking In Each Province

	SELECT Co.C_Name, C.Political_Faction, COUNT(C.Political_Faction)
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
		GROUP BY C.Political_Faction, C_Name
		ORDER BY COUNT(C.Political_Faction) DESC
