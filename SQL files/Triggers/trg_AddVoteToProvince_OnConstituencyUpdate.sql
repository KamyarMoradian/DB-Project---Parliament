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
CREATE TRIGGER trg_AddVoteToProvince_OnConstituencyUpdate
   ON Constituency
   AFTER Update
AS 
BEGIN
	SET NOCOUNT ON;

	DECLARE @id INT;
	SELECT TOP 1 @id = P.ID
	FROM Province AS P
		 JOIN inserted AS I ON I.P_ID = P.ID;

	IF (UPDATE(F_votes_no))
		BEGIN
			UPDATE Province
			SET F_Votes_no = ISNULL(F_Votes_no, 0) + 1
			WHERE Province.ID = @id
		END
	ELSE IF (UPDATE(S_votes_no))
		BEGIN
			UPDATE Province
			SET S_Votes_no = ISNULL(S_Votes_no, 0) + 1
			WHERE Province.ID = @id
		END
END
GO
