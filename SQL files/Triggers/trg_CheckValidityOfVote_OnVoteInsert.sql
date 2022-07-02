SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ===================================================
-- Description:	This trigger is to check the validity
--				votes. if F_RD_Vote is set to 1, count
--				of Candidate_F_RD_Winners should be 0.
--				ELSE, S_RD_Vote is set to 1. then the
--				count of Candidate_F_RD_Winners should 
--				be greater than 0. 
-- ==================================================
CREATE OR ALTER TRIGGER dbo.trg_CheckValidityOfVote_OnVoteInsert
   ON  Vote
   INSTEAD OF INSERT
AS 
BEGIN
	SET NOCOUNT ON;

    DECLARE @f_rd_vote BIT;

	SELECT @f_rd_vote = I.is_First_RD
	FROM inserted AS I

	IF (@f_rd_vote = 1 AND EXISTS ( SELECT * FROM Candidate_Won_F_RD))
	BEGIN
		RAISERROR ('Vote for first round can not be inserted, since voting for second round is started.', 1, 1);
	END
	ELSE IF (@f_rd_vote = 0 AND NOT EXISTS ( SELECT * FROM Candidate_Won_F_RD ))
	BEGIN
		RAISERROR ('Vote for second round can not be inserted, since voting for second round is not started yet.', 1, 1);
	END
	ELSE
	BEGIN
		INSERT INTO Vote
		SELECT Voter_ID, PS_ID, VoteDate, is_First_RD, is_Second_RD
		FROM inserted
	END
END
GO
