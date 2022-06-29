SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Description:	when f_votes_no or s_votes_no of 
--				candidate is updated, the same 
--				columns of constituency will be
--				increased too.
-- =============================================
CREATE TRIGGER trg_AddVoteToConstituecy_OnCandidateUpdate
   ON Candidate
   AFTER Update
AS 
BEGIN
	SET NOCOUNT ON;

	DECLARE @id INT
	SELECT TOP 1 @id = CO.ID
	FROM Constituency AS CO
		 JOIN inserted AS I ON I.CO_ID = CO.ID;

	IF (UPDATE(F_votes_no))
		BEGIN
			UPDATE Constituency
			SET F_Votes_no = F_Votes_no + 1
			WHERE Constituency.ID = @id
		END
	ELSE IF (UPDATE(S_votes_no))
		BEGIN
			UPDATE Constituency
			SET S_Votes_no = S_Votes_no + 1
			WHERE Constituency.ID = @id
		END
END
GO
