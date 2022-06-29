USE Parlimant
GO

IF OBJECT_ID('trg_CheckPresenceOfVoteID_OnCandidateListInsert') IS NOT NULL
	DROP TRIGGER dbo.trg_CheckPresenceOfVoteID_OnCandidateListInsert;
GO
IF OBJECT_ID('trg_CheckPresenceOfCandidateID_OnCandidateListInsert') IS NOT NULL
	DROP TRIGGER dbo.trg_CheckPresenceOfCandidateID_OnCandidateListInsert;
GO
IF OBJECT_ID('trg_ReduceVotes_OnPollingStationDelete') IS NOT NULL
	DROP TRIGGER dbo.trg_ReduceVotes_OnPollingStationDelete;
GO
IF OBJECT_ID('trg_ReduceVotes_OnCandidateDelete') IS NOT NULL
	DROP TRIGGER dbo.trg_ReduceVotes_OnCandidateDelete;
GO
IF OBJECT_ID('trg_AddVoteToProvince_OnConstituencyUpdate') IS NOT NULL
	DROP TRIGGER dbo.trg_AddVoteToProvince_OnConstituencyUpdate;
GO
IF OBJECT_ID('trg_AddVoteToConstituecy_OnCandidateUpdate') IS NOT NULL
	DROP TRIGGER dbo.trg_AddVoteToConstituecy_OnCandidateUpdate;
GO
IF OBJECT_ID('trg_AddVoteToPollingStation_OnCanidateListInsert') IS NOT NULL
	DROP TRIGGER dbo.trg_AddVoteToPollingStation_OnCanidateListInsert;
GO
IF OBJECT_ID('trg_AddVoteToCandidate_OnCandidateListInsert') IS NOT NULL
	DROP TRIGGER dbo.trg_AddVoteToCandidate_OnCandidateListInsert;
GO
IF OBJECT_ID('trg_DeleteCandidateList_OnDeleteVote') IS NOT NULL
	DROP TRIGGER dbo.trg_DeleteCandidateList_OnDeleteVote;
GO
IF OBJECT_ID('trg_DeleteCandidateList_OnDeleteCandidate') IS NOT NULL
	DROP TRIGGER dbo.trg_DeleteCandidateList_OnDeleteCandidate;
GO
IF OBJECT_ID('trg_AddQuittedCandidate_OnDeleteCandidate') IS NOT NULL
	DROP TRIGGER dbo.trg_AddQuittedCandidate_OnDeleteCandidate;
GO
IF OBJECT_ID('trg_AddVoidedPollingStation_OnDeletePollingStation') IS NOT NULL
	DROP TRIGGER dbo.trg_AddVoidedPollingStation_OnDeletePollingStation;
GO