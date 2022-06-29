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
CREATE TRIGGER trg_CheckPresenceOfCandidateID_OnCandidateListInsert
   ON  Candidate_List
   AFTER Insert
AS 
BEGIN
	SET NOCOUNT ON;

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
END
GO
