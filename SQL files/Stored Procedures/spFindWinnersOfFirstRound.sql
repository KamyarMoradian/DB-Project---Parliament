CREATE OR ALTER PROCEDURE spFindWinnersOfFirstRound
AS
BEGIN
	INSERT INTO Candidate_Won_F_RD
	SELECT TOP (20) PERCENT ID 
	FROM Candidate AS CA
	ORDER BY F_Votes_no DESC
END