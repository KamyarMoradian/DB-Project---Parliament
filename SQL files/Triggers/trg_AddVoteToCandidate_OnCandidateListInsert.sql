SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Description:	when a candidate is observed in the candidate_List instance,
--				one vote will be added to the candidate. if the vote is for
--				for the first round, F_Votes_no will be increased. otherwise
--				S_Votes_no will be increased.
-- =============================================
CREATE OR ALTER TRIGGER trg_AddVoteToCandidate_OnCandidateListInsert
   ON  Candidate_List
   AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		DECLARE @id INT;
		SELECT TOP 1 @id = C.ID
		FROM Candidate AS C
			 JOIN inserted AS I ON C.ID = I.Candidate_ID;

		IF (SELECT TOP 1 V.is_First_RD FROM inserted AS I JOIN Vote AS V ON V.ID = I.Vote_ID) = 1
			UPDATE Candidate
			SET F_Votes_no = ISNULL(F_Votes_no, 0) + 1
			WHERE Candidate.ID = @id
		ELSE
			UPDATE Candidate
			SET S_Votes_no = ISNULL(S_Votes_no, 0) + 1
			WHERE Candidate.ID = @id
	END TRY
	BEGIN CATCH
		SELECT   
			ERROR_NUMBER() AS ErrorNumber  
			,ERROR_SEVERITY() AS ErrorSeverity  
			,ERROR_STATE() AS ErrorState  
			,ERROR_PROCEDURE() AS ErrorProcedure  
			,ERROR_LINE() AS ErrorLine  
			,ERROR_MESSAGE() AS ErrorMessage; 
	END CATCH
END
GO
