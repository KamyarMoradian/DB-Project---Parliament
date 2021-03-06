USE [Parliament]
GO
/****** Object:  StoredProcedure [dbo].[LowVotesCandidates]    Script Date: 7/1/2022 3:51:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER PROCEDURE [dbo].[VotesWithinDesiredRange]
(
	@Start_Date DATETIME2(0),
	@End_Date DATETIME2(0)
)
AS
BEGIN
	SELECT COUNT(ID)
	FROM Vote 
		WHERE VoteDate < @End_Date AND VoteDate > @Start_Date 
END

EXEC VotesWithinDesiredRange
@Start_Date = '2022-01-06 17:46:39',
@End_Date = '2022-03-06 17:46:39'
