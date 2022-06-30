select Constituency.ID as Constituency_ID,Candidate.ID as candidate_Id,Candidate.F_Votes_no,Candidate.S_votes_no,Candidate.F_Votes_no + Candidate.S_votes_no as total
from Candidate
join Constituency on Candidate.CO_ID = Constituency.ID
order by Constituency.ID,total