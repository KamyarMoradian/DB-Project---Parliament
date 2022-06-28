--CREATE DATABASE Parlimant
--GO

USE Parlimant
GO

IF OBJECT_ID('Candidate_List') IS NOT NULL
	DROP TABLE Candidate_List;
GO
IF OBJECT_ID('Vote') IS NOT NULL
	DROP TABLE Vote;
GO
IF OBJECT_ID('Voter') IS NOT NULL
	DROP TABLE Voter;
Go
IF OBJECT_ID('Degree') IS NOT NULL
	DROP TABLE Degree;
GO
IF OBJECT_ID('Candidate') IS NOT NULL
	DROP TABLE Candidate;
GO
IF OBJECT_ID('Polling_Station') IS NOT NULL
	DROP TABLE Polling_Station;
GO
IF OBJECT_ID('Constituency') IS NOT NULL
	DROP TABLE Constituency;
GO
IF OBJECT_ID('Province') IS NOT NULL
	DROP TABLE Province;
GO

-- F_Votes_no and S_votes_no, should be evalued using trigger on Constituency table.
-- add constraint to check voter_population to be more than 100000 --> done
CREATE TABLE Province
(
	Province_Name		VARCHAR(50)			PRIMARY KEY,
	Voter_Population	INT					NOT NULL,
	F_Votes_no			INT					DEFAULT(0),
	S_Votes_no			INT					DEFAULT(0)
);
Go

ALTER TABLE Province
	ADD CONSTRAINT CheckProvincePopulation CHECK (Voter_Population > 100000);
GO

-- F_Votes_no and S_votes_no, should be evalued using trigger on Polling_station table.
CREATE TABLE Constituency
(
	C_Name				VARCHAR(50)			PRIMARY KEY,
	Province_Name		VARCHAR(50)			NOT NULL,
	Center				VARCHAR(50)			NOT NULL,
	F_Votes_no			INT					DEFAULT(0),
	S_Votes_no			INT					DEFAULT(0),
	Elected_no			INT					NOT NULL,
	FOREIGN KEY (Province_Name) REFERENCES Province(Province_Name)
		ON DELETE CASCADE
);
GO


-- deleted city_village attribute. because it can be inside Address.
-- F_Votes_no and S_votes_no, should be evalued using trigger on Vote table.
CREATE TABLE Polling_Station
(
	ID					INT					PRIMARY KEY			IDENTITY(1,1),
	C_Name				VARCHAR(50)			NOT NULL,
	[Address]			VARCHAR(max)		NOT NULL,
	F_Votes_no			INT,
	S_Votes_no			INT,
	FOREIGN KEY (C_Name) REFERENCES Constituency(C_Name)
		ON DELETE CASCADE
);
GO

-- religion --> check to be chosen among a number of verified religions(Islam, Christianity, Judaism, Zoroastrianism) --> done
-- sex --> check to be chosen from M and F --> done
-- political_fiction --> check not to have the invalid data (Eslah Talab, Osoul Gara, Aghaliat Dini, Independent).

-- changes:
-- religion --> make it char(1) --> done
-- religion --> check to be chosen among a number of verified religions(I, C, J, Z) --> done
-- political_fiction --> make it char(1) --> done
-- political_fiction --> change chec constraint to just have data in (E, O, A, I) --> done

CREATE TABLE Candidate
(
	SSN					CHAR(10)			PRIMARY KEY,
	C_Name				VARCHAR(50)			NOT NULL,
	First_Name			VARCHAR(50)			NOT NULL,
	Last_Name			VARCHAR(50)			NOT NULL,
	Birth_Date			DATETIME2(0)		NOT NULL,
	ProfileImage		VARCHAR(max),
	Sex					CHAR(1)				NOT NULL, 
	Religion			VARCHAR(50)			NOT NULL,
	is_Married			BIT					NOT NULL,
	Nationality			VARCHAR(50)			NOT NULL,
	F_Votes_no			INT					DEFAULT(0),
	S_votes_no			INT					DEFAULT(0),
	Political_Faction	VARCHAR(50)			NOT NULL,
	Resume_Desc			VARCHAR(max)		NOT NULL,
	FOREIGN KEY (C_Name) REFERENCES Constituency (C_Name)
		ON DELETE CASCADE,
	CONSTRAINT Check_CandidateSex CHECK (SEX IN ('M', 'F')),
	CONSTRAINT Check_CandidateSSN CHECK (ISNUMERIC(SSN) = 1),
	CONSTRAINT Check_CandidateReligion CHECK (Religion IN ('Islam', 'Christianity', 'Judaism', 'Zoroastrianism')),
	CONSTRAINT Check_CandidatePF CHECK (Political_Faction IN ('Eslah Talab', 'Osoul Gara', 'Aghaliat Dini', 'Independent'))
);
GO

ALTER TABLE Candidate
	DROP CONSTRAINT Check_CandidateReligion;
ALTER TABLE Candidate
	ALTER COLUMN Religion CHAR(1) NOT NULL;
ALTER TABLE Candidate
	ADD CONSTRAINT Check_CandidateReligion CHECK (Religion IN ('I', 'C', 'J', 'Z'));
Go

ALTER TABLE Candidate
	DROP CONSTRAINT Check_CandidatePF;
ALTER TABLE Candidate
	ALTER COLUMN Political_Faction CHAR(1) NOT NULL;
ALTER TABLE Candidate
	ADD CONSTRAINT Check_CandidatePF CHECK (Political_Faction IN ('E', 'O', 'A', 'I'));
GO


-- Just one of the has_f_Rd_vote and has_s_rd_vote shold be set as true. --> done
-- check sex to be chosen from M and F --> done
-- changed name of voter_ssn to ssn.
CREATE TABLE Voter
(
	SSN					CHAR(10)			PRIMARY KEY,
	Sex					CHAR(1)				NOT NULL, 
	Age					INT					NOT NULL,
	Has_F_RD_Vote		BIT					NOT NULL,
	Has_S_RD_Vote		BIT					NOT NULL,
	CONSTRAINT Check_VoterSex CHECK (SEX IN ('M', 'F')),
	CONSTRAINT Check_VoterSSN CHECK (ISNUMERIC(SSN) = 1)
);
GO

ALTER TABLE Voter
	ADD CONSTRAINT Check_hasVoteRD CHECK ((Has_F_RD_Vote = 1 AND Has_S_RD_Vote = 0) OR (Has_F_RD_Vote = 0 AND Has_S_RD_Vote = 1))
Go


-- add a check to check only one of is_frist_rd and is_second_rd, are set true. --> done
CREATE TABLE Vote
(
	ID				INT						PRIMARY KEY			IDENTITY(1,1),
	Voter_SSN		CHAR(10)				NOT NULL,
	PS_ID			INT						NOT NULL,
	VoteDate		DATETIME2(0)			NOT NULL,
	is_First_RD		BIT						NOT NULL,
	is_Second_RD	BIT						NOT NULL,
	UNIQUE (Voter_SSN, PS_ID), -- check if it is necessary to contain ID or not.
	FOREIGN KEY (Voter_SSN) REFERENCES Voter(SSN)
		ON DELETE CASCADE,
	FOREIGN KEY (PS_ID) REFERENCES Polling_Station(ID)
		ON DELETE CASCADE
);
GO

ALTER TABLE Vote
	ADD CONSTRAINT Check_voteRD CHECK ((is_First_RD = 1 AND is_second_RD = 0) OR (is_First_RD = 0 AND is_Second_RD = 1))
GO

CREATE TABLE Degree
(
	ID					INT					PRIMARY KEY			IDENTITY(1,1),
	Degree_Name			VARCHAR(50)			NOT NULL,
	Candidate_SSN		CHAR(10)			NOT NULL,
	UNIQUE(Degree_Name, Candidate_SSN),
	FOREIGN KEY (Candidate_SSN) REFERENCES Candidate (SSN)
		ON DELETE CASCADE
);
GO

CREATE TABLE Candidate_List
(
	ID				INT						PRIMARY KEY			IDENTITY(1,1),
	Candidate_SSN	CHAR(10)				NOT NULL,
	Vote_ID			INT						NOT NULL,
	UNIQUE (Candidate_SSn, Vote_ID),
	FOREIGN KEY (Candidate_SSN) REFERENCES Candidate(SSN)
		ON DELETE CASCADE,
	FOREIGN KEY (Vote_ID) REFERENCES Vote(ID)
		ON DELETE CASCADE
);
GO