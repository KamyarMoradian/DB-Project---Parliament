SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Description:	This trigger checks equality of
--				Constituency of canidate and the
--				polling station, where the vote
--				submitted.
-- =============================================
CREATE TRIGGER trg_CheckEqualityOfCandidateANDPollingStation_OnCandidateListInsert
   ON Candidate_List
   INSTEAD OF INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		DECLARE @Candiate_CO_ID INT,
				@PollingStation_CO_ID INT;

		SELECT @PollingStation_CO_ID = PS.C_ID
		FROM inserted AS I
			 JOIN Vote AS V ON I.Vote_ID = V.ID
			 JOIN Polling_Station AS PS ON PS.ID = V.PS_ID;

		SELECT @Candiate_CO_ID = CA.CO_ID
		FROM inserted AS I
			 JOIN Candidate AS CA ON CA.ID = I.Candidate_ID

		IF (@Candiate_CO_ID = @PollingStation_CO_ID)
			BEGIN
				INSERT INTO Candidate_List
				SELECT * FROM inserted
			END
		ELSE
			RAISERROR('The candidate in the candidate_List should have the same CO_ID as the Polling station, where the vote is submitted.', 1, 1);
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
