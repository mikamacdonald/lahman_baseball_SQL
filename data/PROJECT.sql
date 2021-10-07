-- ###  question 1  ##
--SELECT MAX(yearid), MIN(yearid)
--FROM batting
--1871 -2016 145yrs
--max - min to generate question 1

-- ### question 2 ####
-- SELECT p.namefirst, p.namelast, p.namegiven, p.height, a.g_all, t.name
-- FROM people AS p
-- INNER JOIN appearances as a
-- ON p.playerid = a.playerid
-- INNER JOIN teams as t
-- ON a.teamid = t.teamid
-- ORDER by p.height
-- LIMIT 1

--### question 3 ###
-- SELECT DISTINCT(P.NAMEFIRST),
-- 	P.NAMELAST,
-- 	S.SCHOOLNAME,
-- 	SUM(M.SALARY) OVER(PARTITION BY p.namefirst)
-- FROM PEOPLE AS P
-- INNER JOIN COLLEGEPLAYING AS CP ON P.PLAYERID = CP.PLAYERID
-- INNER JOIN SCHOOLS AS S ON CP.SCHOOLID = S.SCHOOLID
-- INNER JOIN SALARIES AS M ON P.PLAYERID = M.PLAYERID
-- WHERE S.SCHOOLNAME = 'Vanderbilt University'
-- GROUP BY P.NAMEFIRST,
-- 	P.NAMELAST,
-- 	S.SCHOOLNAME,
-- 	M.SALARY
-- ORDER BY sum DESC


--###  question 4 ###
-- WITH fa AS (SELECT yearid,
-- CASE 	WHEN pos = 'OF' THEN 'Outfield'
-- 		WHEN pos IN ('SS','1B','2B', '3B') THEN 'Infield'
-- 		ELSE 'Battery' END AS position
-- FROM fielding
-- WHERE yearid = 2016)
-- SELECT fa.yearid, fa.position, SUM(f.po) AS totalpos
-- FROM fa
-- INNER JOIN fielding AS f
-- ON f.yearid = fa.yearid
-- GROUP BY fa.yearid, fa.position

--### question 5 ###
-- SELECT YEARID / 10 * 10 AS DECADE,
-- 	ROUND(AVG(SOA/G),
-- 		2) AS DECADE_AVERAGE_SOA,ROUND(AVG(HR/G),
-- 		2) AS DECADE_AVERAGE_HR
-- FROM TEAMS
-- WHERE YEARID >= '1920'
-- GROUP BY YEARID / 10 * 10
-- ORDER BY DECADE


--###  question 6 ###
-- select p.playerid, CONCAT(namefirst,' ',namelast) as name, yearid, sb::decimal, cs::decimal, 
-- ROUND(sb::decimal/(cs::decimal+sb::decimal),2)*100
--     as sb_success FROM batting AS b
--  LEFT JOIN people AS p
--   	ON b.playerid = p.playerid
--  WHERE yearid =2016 and SB >20
--  Order by sb_success DESC
--  LIMIT 1

--### question 7  ###  2 parts 
-- SELECT DISTINCT(NAME),
-- 	YEARID AS YEAR,
-- 	WSWIN,
-- 	W,
-- 	L
-- FROM TEAMS
-- WHERE YEARID BETWEEN 1970 AND 2016
-- AND yearid <> 1981
-- 	AND WSWIN = 'Y'
-- 	ORDER BY w
-- 2001 Seattle Mariners (116 wins, no WS)
-- 2006 St. Louis Cardinals (83 wins, yes WS)


-- ### question 8 ###
-- SELECT park, team, (attendance/games) AS avg_attendance
-- FROM homegames
-- WHERE year = '2016'
-- AND games > 10
-- ORDER BY (attendance/games) DESC
-- -- ANSWER1 (highest attendance) =
-- 	-- LA Dodgers (45719)
-- 	-- St. Louis Cardinals (42524)
-- 	-- Toronto Blue Jays (41877)
-- 	-- San Francisco Gians (41546)
-- 	-- Chicago Cubs (39906)
-- SELECT park, team, (attendance/games) AS avg_attendance
-- FROM homegames
-- WHERE year = '2016'
-- AND games > 10
-- ORDER BY (attendance/games)
-- -- Answer2 (lowest attendance)
-- 	-- Tampa Bay Rays (15878)
-- 	-- Oakland Athletics (18784)
-- 	-- Cleveland Indians (19650)
-- 	-- Miami Marlins (21405)
-- 	-- Chicago White Sox (21559)

--### question 9  ###
-- WITH TSA_MANAGER_WINNERS AS
-- 	(SELECT PLAYERID
-- 		FROM AWARDSMANAGERS
-- 		WHERE AWARDID = 'TSN Manager of the Year'
-- 			AND LGID = 'NL' INTERSECT
-- 			SELECT PLAYERID
-- 			FROM AWARDSMANAGERS WHERE AWARDID = 'TSN Manager of the Year'
-- 			AND LGID = 'AL')
-- SELECT DISTINCT(CONCAT(P.NAMEFIRST,' ',P.NAMELAST)) AS NAME,
-- 	AW.YEARID,
-- 	M.TEAMID,
-- 	T.NAME
-- FROM TSA_MANAGER_WINNERS AS AM
-- INNER JOIN PEOPLE AS P ON AM.PLAYERID = P.PLAYERID
-- INNER JOIN AWARDSMANAGERS AW ON AM.PLAYERID = AW.PLAYERID
-- INNER JOIN MANAGERS AS M ON AM.PLAYERID = M.PLAYERID
-- AND AW.YEARID = M.YEARID
-- AND AW.LGID = M.LGID
-- INNER JOIN TEAMS AS T ON M.TEAMID = T.TEAMID
-- AND M.YEARID = T.YEARID
-- AND M.LGID = T.LGID


--### question 10  ###
-- WITH eb AS (SELECT p.namefirst, p.namelast, b.hr AS hr_2016, p.playerid
-- 		FROM batting AS b
-- 		INNER JOIN people AS p
-- 		ON p.playerid = b.playerid
-- 		WHERE debut < '2006-01-01'
-- 		AND hr > 1
-- 		AND yearid = 2016),
-- 	maxi AS (SELECT p.namefirst, p.namelast, max(hr) AS max_hr, p.playerid
-- 		FROM batting AS b
-- 		INNER JOIN people AS p
-- 		ON p.playerid = b.playerid
-- 		WHERE debut < '2006-01-01'
-- 		GROUP BY p.namefirst, p.namelast, p.playerid)
-- SELECT eb.namefirst, eb.namelast, eb.hr_2016
-- FROM eb
-- INNER JOIN maxi
-- ON eb.playerid = maxi.playerid
-- WHERE eb.hr_2016 >= maxi.max_hr
-- GROUP BY eb.namefirst, eb.namelast, eb.hr_2016

--### Question 11  ###
--   with salary_wins as (SELECT DISTINCT s.teamid, s.yearid,t.w, SUM(salary) 
--     		OVER(PARTITION BY t.teamid, t.yearid)::numeric::money as team_salary
--     FROM salaries AS s
--     inner join teams AS t 
--    on s.teamid = t.teamid AND s.yearid = t.yearid AND s.lgid = t.lgid
--   WHERE t.yearid >= 2000 
--   order by yearid , w desc)
  
--   SELECT yearid, CORR(salary_wins.w, salary_wins.team_salary::numeric)
--   from salary_wins
--   group by yearid 
--   order by yearid
  

-- ### question 12  ###

-- WITH corr AS (SELECT t.yearid, t.name, t.w, (attendance/ghome) AS avg_attendance
-- 				FROM teams AS t
-- 				WHERE attendance IS NOT NULL
-- 				AND ghome IS NOT NULL
-- 				GROUP BY t.yearid, t.name, t.w, attendance, ghome
-- 				ORDER BY yearid, name),
-- 	corr2 AS	(SELECT corr.yearid, CORR(corr.w, corr.avg_attendance) AS correlation
-- 				FROM corr
-- 				GROUP BY corr.yearid
-- 				ORDER BY corr.yearid)
-- SELECT AVG(correlation)
-- FROM corr2
-- -- Average correlation over entire dataset: 0.617
-- WITH base AS (SELECT t.yearid, t.name, t.wswin, (attendance/ghome) AS avg_att, LEAD(attendance/ghome) OVER(PARTITION BY name ORDER BY yearid) AS lead_att
-- 				FROM teams AS t
-- 				WHERE attendance IS NOT NULL
-- 				AND ghome IS NOT NULL
-- 				GROUP BY t.yearid, t.name, t.wswin, attendance, ghome
-- 				ORDER BY yearid, name)
-- SELECT b.yearid, b.name, b.wswin, b.avg_att, b.lead_att, b.lead_att - b.avg_att AS att_change
-- FROM base AS b
-- WHERE b.wswin = 'Y'
-- -- Calcuation of attendance change in following year
-- WITH base AS (SELECT t.yearid, t.name, t.wswin, (attendance/ghome) AS avg_att, LEAD(attendance/ghome) OVER(PARTITION BY name ORDER BY yearid) AS lead_att
-- 				FROM teams AS t
-- 				WHERE attendance IS NOT NULL
-- 				AND ghome IS NOT NULL
-- 				GROUP BY t.yearid, t.name, t.wswin, attendance, ghome
-- 				ORDER BY yearid, name),
-- 	change AS (SELECT b.yearid, b.name, b.wswin, b.avg_att, b.lead_att, b.lead_att - b.avg_att AS att_change
-- 				FROM base AS b
-- 				WHERE b.wswin = 'Y')
-- SELECT AVG(c.att_change)
-- FROM change AS c
-- -- Average increase in attendance of 267.05
-- WITH base AS (SELECT t.yearid, t.name, t.divwin, t.wcwin, (attendance/ghome) AS avg_att, LEAD(attendance/ghome) OVER(PARTITION BY name ORDER BY yearid) AS lead_att
-- 				FROM teams AS t
-- 				WHERE attendance IS NOT NULL
-- 				AND ghome IS NOT NULL
-- 				GROUP BY t.yearid, t.name, t.divwin, t.wcwin, attendance, ghome
-- 				ORDER BY yearid, name)
-- SELECT b.yearid, b.name, b.divwin, b.wcwin, b.avg_att, b.lead_att, b.lead_att - b.avg_att AS att_change
-- FROM base AS b
-- WHERE (b.divwin = 'Y' OR b.wcwin= 'Y')
-- -- Change in attendance following wildcard or division win
-- WITH base AS (SELECT t.yearid, t.name, t.divwin, t.wcwin, (attendance/ghome) AS avg_att, LEAD(attendance/ghome) OVER(PARTITION BY name ORDER BY yearid) AS lead_att
-- 				FROM teams AS t
-- 				WHERE attendance IS NOT NULL
-- 				AND ghome IS NOT NULL
-- 				GROUP BY t.yearid, t.name, t.divwin, t.wcwin, attendance, ghome
-- 				ORDER BY yearid, name),
-- 	change AS (SELECT b.yearid, b.name, b.divwin, b.wcwin, b.lead_att, b.lead_att - b.avg_att AS att_change
-- 				FROM base AS b
-- 				WHERE (b.divwin = 'Y' OR b.wcwin= 'Y'))
-- SELECT AVG(c.att_change)
-- FROM change AS c
-- -- Average change in attendance of 561.86

--  ### question 13  ###
-- with cy_young_winner AS (awardid 
-- 						from awardsplayers
-- 						WHERE awardid = 'Cy Young Award') 
SELECT distinct namegiven,player.playerid,pitcher.yearid, throws, awards.awardid
FROM people As player
Inner JOIN pitching As pitcher
ON player.playerid = pitcher.playerid
inner join awardsplayers AS awards 
ON player.playerid = awards.playerid
WHERE awards.awardid = 'Cy Young Award'
Order by namegiven




 
