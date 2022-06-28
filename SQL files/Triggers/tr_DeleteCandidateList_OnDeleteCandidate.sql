SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

USE Parlimant
GO
-- =============================================
-- Description:	when an instance of Candidate is deleted, all instances of CandidateList with same Canidate_SSN as SSN of Candidate, will be deleted as well.
-- =============================================
CREATE OR ALTER TRIGGER tr_DeleteCandidateList_OnDeleteCandidate
   ON Candidate
   FOR DELETE
AS 
BEGIN
	SET NOCOUNT ON;

    DELETE CL 
	FROM Candidate_List AS CL
	WHERE EXISTS ( SELECT *	
				   FROM deleted
				   WHERE deleted.ID = CL.Candidate_ID )
END
GO
