SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Description:	Inserting values inside QuittedCandidate after deleting it from Candidate table
-- =============================================
CREATE TRIGGER tr_AddQuittedCandidate_OnDeleteCandidate
   ON Candidate
   AFTER DELETE
AS 
BEGIN
	SET NOCOUNT ON;

    INSERT INTO QuittedCandidate
	SELECT *
	FROM Deleted
END
GO
