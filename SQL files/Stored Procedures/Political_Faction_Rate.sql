create procedure Political_Faction_Rate_InProvince @province int
as
select Province.ID as province_ID,Province.Province_Name,Candidate.Political_Faction,sum(Candidate.F_Votes_no + Candidate.S_votes_no) as total
from Candidate
join Constituency on Candidate.CO_ID = Constituency.ID
join Province on Constituency.P_ID = Province.ID
where Province.ID = @province
group by Candidate.Political_Faction,Province.ID,Province.Province_Name
order by total desc
go

exec Political_Faction_Rate_InProvince @province = 2
exec Political_Faction_Rate_InProvince @province = 9
exec Political_Faction_Rate_InProvince @province = 6
exec Political_Faction_Rate_InProvince @province = 3






alter procedure Political_Faction_Rate_InConstituency @Consistuency int
as
select Constituency.ID as Constituency_ID,Constituency.C_Name,Candidate.Political_Faction,sum(Candidate.F_Votes_no + Candidate.S_votes_no) as total
from Candidate
join Constituency on Candidate.CO_ID = Constituency.ID
where Constituency.ID = @Consistuency
group by Candidate.Political_Faction,Constituency.ID,Constituency.C_Name
order by total desc
go

exec Political_Faction_Rate_InConstituency @Consistuency = 2
exec Political_Faction_Rate_InConstituency @Consistuency = 9
exec Political_Faction_Rate_InConstituency @Consistuency = 6
exec Political_Faction_Rate_InConstituency @Consistuency = 3