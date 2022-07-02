SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER TRIGGER trg_OnCandidateListInsert
   ON Candidate_List
   INSTEAD OF INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	DECLARE @flag BIT;
	-- ===================================================================================================================================================================
		
	-- Description: Checks equality of Constituency of canidate and the polling station,
	--				where the vote submitted.

	--DECLARE @Candiate_CO_ID INT,
	--		@PollingStation_CO_ID INT;

	--SELECT @PollingStation_CO_ID = PS.C_ID
	--FROM inserted AS I
	--	 JOIN Vote AS V ON I.Vote_ID = V.ID
	--	 JOIN Polling_Station AS PS ON PS.ID = V.PS_ID;

	--SELECT @Candiate_CO_ID = CA.CO_ID
	--FROM inserted AS I
	--	 JOIN Candidate AS CA ON CA.ID = I.Candidate_ID

	--IF (@Candiate_CO_ID <> @PollingStation_CO_ID)
	--	RAISERROR('The candidate in the candidate_List should have the same CO_ID as the Polling station, where the vote is submitted.', 1, 1);
	-- 	SET @flag = 1

	-- ===================================================================================================================================================================

	-- Description: This trigger checks that wether the inserted Candidate_List has the 
	--				Voter_ID that is present in the Vote table or not.

	IF ( NOT EXISTS 
		( SELECT V.ID
			FROM Vote AS V, inserted AS I
			WHERE V.ID = I.Vote_ID ))
			BEGIN
				RAISERROR ( 'There is no vote with this id', 1, 1);
				SET @flag = 1;
			END

	-- ===================================================================================================================================================================

	-- Description: This trigger checks that wether the inserted Candidate_List has the
	--				Candidate_ID present in the candidate table or not.

	IF ( NOT EXISTS 
		( SELECT C.ID
			FROM Candidate AS C, inserted AS I
			WHERE C.ID = I.Candidate_ID ))
			BEGIN
				RAISERROR ( 'There is no candidate with this id', 1, 1);
				SET @flag = 1;
			END

	-- ===================================================================================================================================================================

	-- Description:	when a vote is inserted one vote will be added to polling station.
	--				if the vote is for the first round, F_Votes_no will be increased.
	--				otherwise S_Votes_no will be increased.

	DECLARE @ps_id INT;
	SELECT TOP 1 @ps_id = P.ID
	FROM inserted AS I
			JOIN Vote AS V ON V.ID = I.Vote_ID
			JOIN Polling_Station AS P ON P.ID = V.PS_ID

	IF (SELECT TOP 1 V.is_First_RD FROM inserted AS I JOIN Vote AS V ON V.ID = I.Vote_ID) = 1
		UPDATE Polling_Station
		SET F_Votes_no = ISNULL(F_Votes_no, 0) + 1
		WHERE Polling_Station.ID = @ps_id
	ELSE
		UPDATE Polling_Station
		SET S_Votes_no = ISNULL(S_Votes_no, 0) + 1
		WHERE Polling_Station.ID = @ps_id

	-- ===================================================================================================================================================================

	-- Description:	when a candidate is observed in the candidate_List instance,
	--				one vote will be added to the candidate. if the vote is for
	--				for the first round, F_Votes_no will be increased. otherwise
	--				S_Votes_no will be increased.

	DECLARE @ca_id INT;
	SELECT TOP 1 @ca_id = C.ID
	FROM Candidate AS C
			JOIN inserted AS I ON C.ID = I.Candidate_ID;

	IF (SELECT TOP 1 V.is_First_RD FROM inserted AS I JOIN Vote AS V ON V.ID = I.Vote_ID) = 1
		UPDATE Candidate
		SET F_Votes_no = ISNULL(F_Votes_no, 0) + 1
		WHERE Candidate.ID = @ca_id
	ELSE
		UPDATE Candidate
		SET S_Votes_no = ISNULL(S_Votes_no, 0) + 1
		WHERE Candidate.ID = @ca_id

	-- ===================================================================================================================================================================

	-- Description:	if the S_RD_Vote is set 1, the candidate the voting is for, should 
	--				be in the Candidate_F_RD_Winners table.

	DECLARE @is_second_rd BIT

	SELECT @is_second_rd = V.is_Second_RD
	FROM inserted AS I
			JOIN Vote AS V ON V.ID = I.Vote_ID

	IF (@is_second_rd = 1 AND NOT EXISTS ( SELECT * 
											FROM inserted AS I 
												JOIN Candidate_Won_F_RD AS CAW ON CAW.ID = I.Candidate_ID ))
			BEGIN
				RAISERROR ( 'There is no candidate with such id in the Candidate_Won_F_RD table.', 1, 1);
				SET @flag = 1;
			END

		
	-- ===================================================================================================================================================================

	-- inserting data into the the Candidate_List table.

	IF (@flag <> 1)
		INSERT INTO Candidate_List
		SELECT *
		FROM inserted

END
GO
