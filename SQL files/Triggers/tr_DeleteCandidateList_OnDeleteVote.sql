SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

USE Parlimant
GO
-- =============================================
-- Description:	when an instance of Vote is deleted, all instances of CandidateList with same Vote_ID as ID of Vote, will be deleted as well.
-- =============================================
CREATE OR ALTER TRIGGER tr_DeleteCandidateList_OnDeleteVote
   ON Vote
   FOR DELETE
AS 
BEGIN
	SET NOCOUNT ON;

    DELETE CL 
	FROM Candidate_List AS CL
	WHERE EXISTS ( SELECT *	
				   FROM deleted
				   WHERE deleted.ID = CL.VoteId )
END
GO
