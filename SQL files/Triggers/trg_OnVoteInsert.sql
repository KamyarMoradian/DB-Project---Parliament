SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER TRIGGER dbo.trg_OnVoteInsert
   ON  Vote
   INSTEAD OF INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	-- ==========================================================================================================================

	-- Description:	This trigger is to check the votes. if F_RD_Vote is set to 1, count of 
	--				Candidate_F_RD_Winners should be 0. ELSE, S_RD_Vote is set to 1. then the
	--				count of Candidate_F_RD_Winners should be greater than 0. 
		
	DECLARE @f_rd_vote BIT,
			@flag BIT;

	SELECT @f_rd_vote = I.is_First_RD
	FROM inserted AS I
	
	IF (@f_rd_vote = 1 AND EXISTS ( SELECT * FROM Candidate_Won_F_RD))
		BEGIN
			RAISERROR ('Vote for first round can not be inserted, since voting for second round is started.', 1, 1);
			SET @flag = 1;
		END
	ELSE IF (@f_rd_vote = 0 AND NOT EXISTS ( SELECT * FROM Candidate_Won_F_RD ))
		BEGIN
			RAISERROR ('Vote for second round can not be inserted, since voting for second round is not started yet.', 1, 1);
			SET @flag = 1;
		END

	-- ==========================================================================================================================
		
	-- Description:	To set the BIT value of Has_F_RD_Vote and Has_S_RD_Vote of Voter instance,
	--				to whom this instance of vote belongs to.

	UPDATE Voter
	SET Has_F_RD_Vote = (CASE WHEN I.is_First_RD = 1 THEN 1 END), Has_S_RD_Vote = (CASE WHEN I.is_Second_RD = 1 THEN 1 END)
	FROM inserted AS I
			JOIN Voter AS V ON V.ID = I.Voter_ID

	-- ==========================================================================================================================

	-- inserting data into the Vote table

	IF (@flag <> 1)
		INSERT INTO Vote
		SELECT Voter_ID, PS_ID, VoteDate, is_First_RD, is_Second_RD
		FROM inserted
END
GO
