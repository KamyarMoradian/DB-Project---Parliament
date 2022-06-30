create procedure Province_AvgAge @province int
as
select Province.ID as Province_ID,avg(Voter.Age)AS averageAge
from Voter
join Vote on Voter.ID = Vote.Voter_ID
join Polling_Station on Vote.PS_ID = Polling_Station.ID
join Constituency on Polling_Station.C_ID = Constituency.ID
join Province on Constituency.P_ID = Province.ID
where Province.ID = @province
group by Province.ID
go


exec Province_AvgAge @province = 6
exec Province_AvgAge @province = 7
exec Province_AvgAge @province = 2
exec Province_AvgAge @province = 9