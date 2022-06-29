SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Description:	Inserting values inside VoidedPollingStation after deleting it from PollingStation table
-- =============================================
CREATE TRIGGER trg_AddVoidedPollingStation_OnDeletePollingStation
   ON Polling_Station
   AFTER DELETE
AS 
BEGIN
	SET NOCOUNT ON;

    INSERT INTO Voided_PollingStation
	SELECT *
	FROM Deleted
END
GO