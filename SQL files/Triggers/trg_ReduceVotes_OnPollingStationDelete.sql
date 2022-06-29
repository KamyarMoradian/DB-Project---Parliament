SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Description:	Reduces votes when there is a delete
--				on the Polling_Station.
-- =============================================
CREATE TRIGGER trg_ReduceVotes_OnPollingStationDelete
   ON Polling_Station
   FOR DELETE
AS  
BEGIN
	SET NOCOUNT ON;

	-- finding number of votes recorded in the deleted polling station
   	DECLARE @fVotesNo INT,
			@sVotesNo INT;

	SELECT TOP 1 @fVotesNo = D.F_Votes_no, @sVotesNo = D.S_Votes_no
	FROM deleted AS D

	-- finding candidates who have soe votes recorded in the deleted polling station
	DECLARE @table TABLE (ID INT, F_vote BIT, TotalCount INT)
	INSERT INTO @table
	SELECT CA.ID, is_First_RD, COUNT(*) AS TotalCount
	FROM deleted AS D
		 JOIN Vote AS V ON V.PS_ID = D.ID
		 JOIN Candidate_List AS CL ON CL.Vote_ID = V.ID
		 JOIN Candidate AS CA ON CA.ID = CL.Candidate_ID
	GROUP BY CA.ID, V.is_First_RD

	-- get number of CO votes and P votes
	DECLARE @CO_ID INT,
			@P_ID INT,
			@CO_f_votes INT,
			@CO_s_votes INT,
			@P_f_votes INT,
			@P_s_votes INT

	SELECT @CO_ID = CO.ID, @P_ID = P.ID, @CO_f_votes = CO.F_Votes_no - @fVotesNo, @CO_s_votes = CO.S_Votes_no - @sVotesNo, @P_f_votes = P.F_Votes_no - @fVotesNo, @P_s_votes = P.S_Votes_no - @sVotesNo
	FROM deleted AS D
		 JOIN Constituency AS CO ON CO.ID = D.C_ID
		 JOIN Province AS P ON P.ID = CO.P_ID

	-- reducing from the candidates
	UPDATE Candidate
	SET F_Votes_no = F_Votes_no - (CASE WHEN T.F_vote = 1 THEN T.TotalCount ELSE 0 END), S_votes_no = S_votes_no - (CASE WHEN T.F_vote = 0 THEN T.TotalCount ELSE 0 END)
	FROM @table AS T
		 JOIN Candidate AS CA ON CA.ID = T.ID
		 
	-- deleteing from vote
	DELETE
	FROM Vote
	WHERE Vote.PS_ID IN (SELECT D.ID FROM deleted AS D)

	-- reducing from contituency and Province
	UPDATE Constituency
	SET F_Votes_no = @CO_f_votes, S_Votes_no = @CO_s_votes
	WHERE Constituency.ID = @CO_ID

	UPDATE Province
	SET F_Votes_no = @P_f_votes, S_Votes_no = @P_s_votes
	WHERE Province.ID = @P_ID
END
GO