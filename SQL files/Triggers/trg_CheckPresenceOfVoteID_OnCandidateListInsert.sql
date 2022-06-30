SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ===================================================
-- Description:	This trigger checks that wether the 
--				inserted Candidate_List has the 
--				Voter_ID that is present in the Vote 
--				table or not.
-- ===================================================
CREATE OR ALTER TRIGGER trg_CheckPresenceOfVoteID_OnCandidateListInsert
   ON  Candidate_List
   AFTER Insert
AS 
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		IF ( NOT EXISTS ( SELECT V.ID
						  FROM Vote AS V, inserted AS I
						  WHERE V.ID = I.Vote_ID ))
				BEGIN
					RAISERROR ( 'There is no vote with this id', 1, 1)
				END
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
