SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Description:	when a vote is inserted one vote will be added to polling station.
--				if the vote is for the first round, F_Votes_no will be increased.
--				otherwise S_Votes_no will be increased.
--				
-- =============================================
CREATE TRIGGER trg_AddVoteToPollingStation_OnCanidateListInsert
   ON  Candidate_List
   AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	DECLARE @id INT;
	SELECT TOP 1 @id = P.ID
	FROM inserted AS I
		 JOIN Vote AS V ON V.ID = I.Vote_ID
		 JOIN Polling_Station AS P ON P.ID = V.PS_ID

    IF (SELECT TOP 1 V.is_First_RD FROM inserted AS I JOIN Vote AS V ON V.ID = I.Vote_ID) = 1
		UPDATE Polling_Station
		SET F_Votes_no = ISNULL(F_Votes_no, 0) + 1
		WHERE Polling_Station.ID = @id
	ELSE
		UPDATE Polling_Station
		SET S_Votes_no = ISNULL(S_Votes_no, 0) + 1
		WHERE Polling_Station.ID = @id
END
GO
