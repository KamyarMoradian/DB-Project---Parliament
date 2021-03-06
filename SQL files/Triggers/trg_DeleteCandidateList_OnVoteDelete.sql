USE Parlimant
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER TRIGGER dbo.trg_DeleteCandidateList_OnVoteDelete
   ON Vote
   AFTER DELETE
AS 
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
    DELETE CL 
	FROM Candidate_List AS CL
	WHERE EXISTS ( SELECT *	
				   FROM deleted
				   WHERE deleted.ID = CL.Vote_ID );
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
