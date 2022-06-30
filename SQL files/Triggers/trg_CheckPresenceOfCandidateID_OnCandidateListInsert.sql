SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ===================================================
-- Description:	This trigger checks that wether the 
--				inserted Candidate_List has the 
--				Candidate_ID present in the candidate 
--				table or not.
-- ===================================================
CREATE OR ALTER TRIGGER trg_CheckPresenceOfCandidateID_OnCandidateListInsert
   ON  Candidate_List
   AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		DECLARE @ID INT;
		SELECT @ID = I.Candidate_ID
		FROM inserted AS I

		IF ( NOT EXISTS 
		   ( SELECT C.ID
			 FROM Candidate AS C, inserted AS I
			 WHERE C.ID = I.Candidate_ID ))
				BEGIN
					RAISERROR ( 'There is no candidate with this id', 1, 1)
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
