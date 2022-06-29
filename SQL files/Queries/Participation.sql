SELECT CAST(COUNT(*) AS FLOAT) / SUM(Voter_Population) AS [Participation(%)]
	FROM VOTE, Province