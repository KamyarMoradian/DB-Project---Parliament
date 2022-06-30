declare @num1 float
set @num1 = 
(select Count(t1.ID)
from (
select Candidate.ID, Candidate.F_Votes_no + Candidate.S_votes_no as majmoo
from Candidate
where  Candidate.F_Votes_no + Candidate.S_votes_no < 10 
)as t1)

--print @num1

declare @num2 float
set @num2 =
(select Count(t2.ID)
from(
select Candidate.ID, Candidate.F_Votes_no + Candidate.S_votes_no as majmoo
from Candidate
)as t2)

--print @num2

print (@num1 / @num2)*100


create procedure Candidate_Percentage @filter int
as

declare @num1 float
set @num1 = 
(select Count(t1.ID)
from (
select Candidate.ID, Candidate.F_Votes_no + Candidate.S_votes_no as total
from Candidate
where  Candidate.F_Votes_no + Candidate.S_votes_no < @filter 
)as t1)

--print @num1

declare @num2 float
set @num2 =
(select Count(t2.ID)
from(
select Candidate.ID, Candidate.F_Votes_no + Candidate.S_votes_no as total
from Candidate
)as t2)

--print @num2

print (@num1 / @num2)*100
go

exec Candidate_Percentage @filter = 10
exec Candidate_Percentage @filter = 7

exec Candidate_Percentage @filter = 2000
exec Candidate_Percentage @filter = 1000