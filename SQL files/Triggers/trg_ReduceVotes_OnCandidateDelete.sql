SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Description:	Reduces votes when there is a delete
--				on the candidate.
-- =============================================
CREATE TRIGGER trg_ReduceVotes_OnCandidateDelete
   ON Candidate
   FOR DELETE
AS 
BEGIN
	SET NOCOUNT ON;

	DECLARE @table TABLE
	(
		is_First_RD BIT, 
		totalCount INT
	);

	-- finding count of votes inserted in first round or second round
	INSERT INTO @table
    SELECT V.is_First_RD, COUNT(*) AS totalCount
	FROM deleted AS D
		 JOIN Candidate_List AS CL ON CL.Candidate_ID = D.ID
		 JOIN Vote AS V ON V.ID = CL.Vote_ID
	GROUP BY V.is_First_RD

	DECLARE @fVotesNo INT,
			@sVotesNo INT;

	SELECT @fVotesNo = T.totalCount
	FROM @table AS T
	WHERE T.is_First_RD = 1;

	SELECT @sVotesNo = T.totalCount
	FROM @table AS T
	WHERE T.is_First_RD = 0;

	DECLARE @candidateID INT
	SELECT TOP 1 @candidateID = D.ID
	FROM deleted AS D;

	-- reducing number of votes from the polling stations.
	Update Polling_Station
	SET F_Votes_no = F_Votes_no - @fVotesNo, S_Votes_no = S_Votes_no - @sVotesNo
	WHERE ID IN ( SELECT PS.ID
				  FROM deleted AS D
					   JOIN Candidate_List AS CL ON CL.Candidate_ID = D.ID
					   JOIN Vote AS V ON V.ID = CL.Vote_ID
					   JOIN Polling_Station AS PS ON PS.ID = V.PS_ID )

	-- deleting votes have the candidate Id, which is present in deleted table
	DELETE 
	FROM Candidate_List
	WHERE Candidate_ID = @candidateID;

	-- finding vote instances that are not refrenced by any candidate_list instances.
	DECLARE @emptyVotes TABLE (id INT);
	INSERT INTO @emptyVotes
	SELECT V.ID
	FROM Vote AS V
		 JOIN Candidate_List AS CL ON CL.Vote_ID = V.ID
	GROUP BY V.ID
	HAVING COUNT(*) = 0;

	-- deleting vote instances that are not refrenced by any candidate_list instances.
	DELETE
	FROM Vote
	WHERE ID IN (SELECT EV.id FROM @emptyVotes AS EV);

	-- finding ids of constituencies
	DECLARE @CO_table TABLE (id INT)
	INSERT INTO @CO_table
	SELECT D.CO_ID
	FROM deleted AS D

	-- reducing number of votes from Constituencies
	Update Constituency
	SET F_Votes_no = F_Votes_no - @fVotesNo, S_Votes_no = S_Votes_no - @sVotesNo
	WHERE ID IN ( Select CO.id FROM @CO_table AS CO )

	-- finding ids of provinces
	DECLARE @P_table TABLE (id INT)
	INSERT INTO @P_table
	SELECT P.ID
	FROM @CO_table AS CO1
		 JOIN Constituency AS CO2 ON CO2.ID = CO1.id
		 JOIN Province AS P ON P.ID = CO2.P_ID

	-- reducing number of votes from provinces
	Update Province
	SET F_Votes_no = F_Votes_no - 2 * @fVotesNo, S_Votes_no = S_Votes_no - 2 * @sVotesNo
	WHERE ID IN ( Select P.id FROM @P_table AS P )
END
GO
