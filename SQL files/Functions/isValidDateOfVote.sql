CREATE OR ALTER FUNCTION isValidDateOfVote (@is_first_rd BIT, @voteDate DATETIME2(0))
		RETURNS INT
AS
BEGIN
	IF ((@is_first_rd = 1) AND (@voteDate BETWEEN CONVERT(DATETIME2, '2022-07-01') AND CONVERT(DATETIME2,'2022-08-01')))
		RETURN 1;
	ELSE IF ((@is_first_rd = 0) AND (@voteDate BETWEEN CONVERT(DATETIME2, '2023-01-01') AND CONVERT(DATETIME2, '2023-02-01')))
		RETURN 1;
	RETURN 0;
END
