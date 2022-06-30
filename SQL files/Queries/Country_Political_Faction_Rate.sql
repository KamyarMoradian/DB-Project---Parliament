select distinct Candidate.Political_Faction,Sum(Candidate.F_Votes_no + Candidate.S_votes_no) as total
from Candidate
where Candidate.Political_Faction in ('I','A','O','E')
group by Candidate.Political_Faction
order by total desc