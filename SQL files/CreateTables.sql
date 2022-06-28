--CREATE DATABASE Parlimant
--GO

--USE Parlimant
--GO

CREATE TABLE Candidate_List
(
	ID				INT				PRIMARY KEY,
	Candidate_SSN	CHAR(10)		NOT NULL,
	Vote_ID			INT				NOT NULL,
	UNIQUE (Candidate_SSn, Vote_ID),
	FOREIGN KEY (Candidate_SSN) REFERENCES Candidate(SSN)
		ON DELETE CASCADE,
	FOREIGN KEY (Vote_ID) REFERENCES Vote(ID)
		ON DELETE CASCADE
);

-- add a check to check only one of is_frist_rd and is_second_rd, are set true.
CREATE TABLE Vote
(
	ID				INT					PRIMARY KEY,
	Voter_SSN		CHAR(10)			NOT NULL,
	PS_ID			INT					NOT NULL,
	VoteDate		DATETIME2(0)		NOT NULL,
	is_Fist_RD		BIT					NOT NULL,
	is_Second_RD	BIT					NOT NULL,
	UNIQUE (Voter_SSN, PS_ID), -- check if it is necessary to contain ID or not.
	FOREIGN KEY (Voter_SSN) REFERENCES Candidate(SSN)
		ON DELETE CASCADE,
	FOREIGN KEY (PS_ID) REFERENCES Polling_Station(ID)
		ON DELETE CASCADE

);

-- deleted city_village attribute. because it can be inside Address.
-- F_Vites_no and S_votes_no, should be evalued using trigger on Vote table.
CREATE TABLE Polling_Station
(
	ID					INT					PRIMARY KEY,
	C_Name				VARCHAR(50)			NOT NULL,
	[Address]			VARCHAR(max)		NOT NULL,
	F_Votes_no			INT,
	S_Votes_no			INT,
	FOREIGN KEY (C_Name) REFERENCES Constituency(C_Name)
		ON DELETE CASCADE
);

-- Just one of the has_f_Rd_vote and has_s_rd_vote shold be set as true.
-- changed name of voter_ssn to ssn.
CREATE TABLE Voter
(
	SSN					CHAR(10)			PRIMARY KEY,
	Sex					CHAR(1)				NOT NULL, -- check to be chosen from M and F
	Age					INT					NOT NULL,
	Has_F_RD_Vote		BIT					NOT NULL,
	Has_S_RD_Vote		BIT					NOT NULL,
);

-- religion --> check to be chosen among a number of verified religions
-- sex --> check to be chosen from M and F
-- political_fiction --> check not to have the invalid data.
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
		ON DELETE CASCADE
);

CREATE TABLE Degree
(
	ID					INT					PRIMARY KEY,
	Degree_Name			VARCHAR(50)			NOT NULL,
	Candidate_SSN		CHAR(10)			NOT NULL,
	UNIQUE(Degree_Name, Candidate_SSN),
	FOREIGN KEY (Candidate_SSN) REFERENCES Candidate (SSN)
		ON DELETE CASCADE
);

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

-- F_Votes_no and S_votes_no, should be evalued using trigger on Constituency table.
CREATE TABLE Province
(
	Province_Name		VARCHAR(50)			PRIMARY KEY,
	Voter_Population	INT					NOT NULL,
	F_Votes_no			INT					DEFAULT(0),
	S_Votes_no			INT					DEFAULT(0)
);