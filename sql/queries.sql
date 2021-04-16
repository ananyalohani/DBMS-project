SELECT DISTINCT MainTrackAuthors.PaperID, Title from Authors
JOIN MainTrackAuthors
ON Authors.AuthorID = MainTrackAuthors.AuthorID 
JOIN MainTrackPapers 
ON MainTrackAuthors.PaperID = MainTrackPapers.PaperID 
WHERE Authors.Affiliation IN 
(
	SELECT Affiliation from Authors
	WHERE AuthorID = 200003
);

SELECT DISTINCT Authors.AuthorID, AuthorName from Authors
JOIN MainTrackAuthors
ON Authors.AuthorID = MainTrackAuthors.AuthorID
JOIN Awards
ON Awards.PaperID = MainTrackAuthors.PaperID
JOIN WorkshopPapers
ON Awards.WPaperID = Awards.WPaperID
WHERE Authors.AuthorID = 200015;

SELECT * from Authors 
WHERE AuthorID IN
(
	(
		SELECT DISTINCT AuthorID from Authors
		JOIN MainTrackAuthors
		ON Authors.AuthorID = MainTrackAuthors.AuthorID
		JOIN Awards
		ON Awards.PaperID = MainTrackAuthors.PaperID
	)
	UNION ALL
	(
		SELECT DISTINCT AuthorID from Authors
		JOIN WkshpPaperAuthors
		ON Authors.AuthorID = WkshpPaperAuthors.AuthorID
		JOIN Awards
		ON Awards.WPaperID = WkshpPaperAuthors.WPaperID
	)
)
AND AuthorID <> 200008;

SELECT AuthorID, PaperID, WPaperID from Authors, Awards
WHERE AuthorID IN
(
	SELECT DISTINCT Authors.AuthorID from Authors, MainTrackAuthors, Awards
	WHERE Authors.AuthorID = MainTrackAuthors.AuthorID
	AND Awards.PaperID = MainTrackAuthors.PaperID
)
OR AuthorID IN
(
	SELECT DISTINCT Authors.AuthorID from Authors, WkshpPaperAuthors, Awards
	WHERE Authors.AuthorID = WkshpPaperAuthors.AuthorID
	AND Awards.WPaperID = WkshpPaperAuthors.WPaperID
)
AND AuthorID = 200008;

SELECT Organizers.OrganizerID, OrgName from Organizers
JOIN VolunteerReportsToOrganizers
ON Organizers.OrganizerID = VolunteerReportsToOrganizers.OrganizerID
JOIN Volunteers 
ON Volunteers.VolunteerID = VolunteerReportsToOrganizers.VolunteerID
WHERE Volunteers.VolunteerID = 700006;

-- fellow volunteers that I report to
SELECT DISTINCT Volunteers.VolunteerID, VolunteerName from Volunteers
JOIN VolunteerReportsToOrganizers
ON Volunteers.VolunteerID = VolunteerReportsToOrganizers.VolunteerID
JOIN Organizers 
ON Organizers.OrganizerID = VolunteerReportsToOrganizers.OrganizerID
WHERE Organizers.OrganizerID IN
(
	SELECT Organizers.OrganizerID from Organizers
	JOIN VolunteerReportsToOrganizers
	ON Organizers.OrganizerID = VolunteerReportsToOrganizers.OrganizerID
	JOIN Volunteers 
	ON Volunteers.VolunteerID = VolunteerReportsToOrganizers.VolunteerID
	WHERE Volunteers.VolunteerID = 700006
) 
AND Volunteers.VolunteerID <> 700006;

-- fellow main track authors
CREATE VIEW FellowMainTrackAuthors AS
SELECT DISTINCT AuthorID from MainTrackAuthors
JOIN MainTrackPapers
ON MainTrackAuthors.PaperID = MainTrackPapers.PaperID 
WHERE MainTrackAuthors.PaperID IN
(
	SELECT DISTINCT PaperID FROM MainTrackAuthors
	WHERE AuthorID = 200008
)
AND AuthorID <> 200008;

-- fellow workshop authors
CREATE VIEW FellowWorkshopAuthors AS
SELECT DISTINCT AuthorID from WkshpPaperAuthors
JOIN WorkshopPapers
ON WkshpPaperAuthors.WPaperID = WorkshopPapers.WPaperID 
WHERE WkshpPaperAuthors.WPaperID IN
(
	SELECT DISTINCT WPaperID FROM WkshpPaperAuthors
	WHERE AuthorID = 200008
)
AND AuthorID <> 200008;

-- main track authors who won awards
CREATE VIEW MainTrackAwards AS
SELECT AuthorID, AwardName from Awards
JOIN MainTrackAuthors
ON MainTrackAuthors.PaperID = Awards.PaperID;

-- wkshp paper authors who won awards
CREATE VIEW WorkshopAwards AS
SELECT AuthorID, AwardName from Awards
JOIN WkshpPaperAuthors
ON Awards.WPaperID = WkshpPaperAuthors.WPaperID;

-- fellow authors who won awards
SELECT MainTrackAwards.AuthorID, AuthorName, AwardName FROM MainTrackAwards 
JOIN FellowMainTrackAuthors 
ON FellowMainTrackAuthors.AuthorID = MainTrackAwards.AuthorID
JOIN Authors 
ON MainTrackAwards.AuthorID = Authors.AuthorID
UNION
SELECT WorkshopAwards.AuthorID, AuthorName, AwardName FROM WorkshopAwards 
JOIN FellowWorkshopAuthors 
ON FellowWorkshopAuthors.AuthorID = WorkshopAwards.AuthorID
JOIN Authors 
ON WorkshopAwards.AuthorID = Authors.AuthorID;

SELECT Organizers.OrganizerID, OrgName from Organizers
JOIN VolunteerReportsToOrganizers
ON Organizers.OrganizerID = VolunteerReportsToOrganizers.OrganizerID
JOIN Volunteers 
ON Volunteers.VolunteerID = VolunteerReportsToOrganizers.VolunteerID
WHERE Volunteers.VolunteerID = 700006;


SELECT DISTINCT Authors.AuthorID, AwardName from Authors
JOIN MainTrackAuthors
ON Authors.AuthorID = MainTrackAuthors.AuthorID
JOIN WkshpPaperAuthors
ON Authors.AuthorID = WkshpPaperAuthors.AuthorID
JOIN Awards
ON Awards.PaperID = MainTrackAuthors.PaperID 
AND Awards.WPaperID = WkshpPaperAuthors.WPaperID		
WHERE (Authors.AuthorID IN
(
	SELECT DISTINCT Authors.AuthorID from Authors, MainTrackAuthors, Awards
	WHERE Authors.AuthorID = MainTrackAuthors.AuthorID
	AND Awards.PaperID = MainTrackAuthors.PaperID
)
OR Authors.AuthorID IN
(
	SELECT DISTINCT Authors.AuthorID from Authors, WkshpPaperAuthors, Awards
	WHERE Authors.AuthorID = WkshpPaperAuthors.AuthorID
	AND Awards.WPaperID = WkshpPaperAuthors.WPaperID
))
AND (Authors.AuthorID IN 
(
	SELECT DISTINCT Authors.AuthorID from MainTrackAuthors where PaperID in (select PaperID from MainTrackAuthors where Authors.AuthorID = 200008)
)
OR Authors.AuthorID IN 
(
	SELECT DISTINCT Authors.AuthorID from WkshpPaperAuthors where WPaperID in (select WPaperID from WkshpPaperAuthors where Authors.AuthorID = 200008)
))
AND Authors.AuthorID <> 200008;



select (MainTrackPapers.PaperID, Title, Affiliation) from MainTrackPapers
join MainTrackAuthors on
MainTrackPapers.PaperID = MainTrackAuthors.PaperID
join Authors on
Authors.AuthorID = MainTrackAuthors.AuthorID;