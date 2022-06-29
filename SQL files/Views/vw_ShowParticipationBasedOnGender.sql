CREATE VIEW vw_ShowParticipationBasedOnGender
AS
SELECT  PS.City, PS.[Address], 
		CONVERT(decimal(6,2),(( SELECT COUNT(*)
							    FROM Polling_Station AS PS1
									 JOIN Vote AS V1 ON V1.PS_ID = PS1.ID
									 JOIN Voter AS VR1 ON VR1.ID = V1.Voter_ID
								WHERE VR1.Sex = 'M' AND PS1.ID = PS.ID ) * 1.0
									/
									(SELECT COUNT(*) 
									 FROM Polling_Station AS PS1
									      JOIN Vote AS V1 ON V1.PS_ID = PS1.ID
								     WHERE PS.ID = PS1.ID ) * 1.0) * 100) AS [Men Participation Percentage],
		CONVERT(decimal(6,2),(( SELECT COUNT(*)
							    FROM Polling_Station AS PS1
									 JOIN Vote AS V1 ON V1.PS_ID = PS1.ID
									 JOIN Voter AS VR1 ON VR1.ID = V1.Voter_ID
								WHERE VR1.Sex = 'F' AND PS1.ID = PS.ID ) * 1.0
									/
									(SELECT COUNT(*) 
									 FROM Polling_Station AS PS1
									      JOIN Vote AS V1 ON V1.PS_ID = PS1.ID
								     WHERE PS.ID = PS1.ID ) * 1.0) * 100) AS [Women Participation Percentage]

FROM    Polling_Station AS PS 
	    JOIN Vote AS V ON PS.ID = V.PS_ID 
		JOIN Voter AS VR ON V.Voter_ID = VR.ID
