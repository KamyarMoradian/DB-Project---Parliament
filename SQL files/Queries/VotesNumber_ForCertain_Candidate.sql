alter procedure VotesNumber_Certain_Candidate @Id int
as

select Candidate.ID,Candidate.First_Name + ' ' + Candidate.Last_Name as fullName,Candidate.F_Votes_no,Candidate.S_votes_no
from Candidate
where Candidate.ID = @Id
go

exec VotesNumber_Certain_Candidate @Id = 15;
exec VotesNumber_Certain_Candidate @Id = 8;