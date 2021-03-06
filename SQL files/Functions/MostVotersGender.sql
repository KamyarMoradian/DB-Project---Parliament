USE [Parliament]
GO
/****** Object:  UserDefinedFunction [dbo].[MostVotersGender]    Script Date: 7/3/2022 2:25:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[MostVotersGender] (@ID INT)
RETURNS NVARCHAR(10)
AS
BEGIN
	DECLARE @res NVARCHAR(10),
	@c1 INT,
	@c2 INT;

	SET @c1 = 
	(
	SELECT COUNT(VO.Sex) 
	FROM Voter AS VO
		INNER JOIN
		Vote AS V 
		ON VO.ID = V.Voter_ID 
		INNER JOIN 
		Candidate_List AS CL
		ON 	V.ID = CL.Vote_ID						
		WHERE CL.Candidate_ID = @ID AND Sex ='M'
	)

	SET @c2 = 
	(
	SELECT COUNT(VO.Sex) 
	FROM Voter AS VO
		INNER JOIN
		Vote AS V 
		ON VO.ID = V.Voter_ID 
		INNER JOIN 
		Candidate_List AS CL
		ON 	V.ID = CL.Vote_ID						
		WHERE CL.Candidate_ID = @ID AND Sex ='F'
	)

	IF @c1 > @c2
		SET @res = N'MALE'

	ELSE IF @c1 < @c2
		SET @res = N'FEMALE'

	ELSE
		SET @res = N'EQUAL'

	RETURN @res
END
