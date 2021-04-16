-- main track authors who won awards
CREATE VIEW Vw_MainTrackAwards AS
SELECT AuthorID, AwardName
FROM Awards
JOIN MainTrackAuthors
ON MainTrackAuthors.PaperID = Awards.PaperID;

-- wkshp paper authors who won awards
CREATE VIEW Vw_WorkshopAwards AS
SELECT AuthorID, AwardName
FROM Awards
JOIN WkshpPaperAuthors
ON Awards.WPaperID = WkshpPaperAuthors.WPaperID;

-- authors and the main track papers they published
CREATE VIEW Vw_MainTrackAuthors AS
SELECT Authors.AuthorID, AuthorName AS Name, Nationality, Affiliation, MainTrackPapers.PaperID, Title
FROM Authors
JOIN MainTrackAuthors
ON Authors.AuthorID = MainTrackAuthors.AuthorID
JOIN MainTrackPapers
ON MainTrackPapers.PaperID = MainTrackAuthors.PaperID;

-- authors and the workshop papers they published
CREATE VIEW Vw_WorkshopAuthors AS
SELECT Authors.AuthorID, AuthorName AS Name, Nationality, Affiliation, WorkshopPapers.WPaperID, Title, WorkshopID
FROM Authors
JOIN WkshpPaperAuthors
ON Authors.AuthorID = WkshpPaperAuthors.AuthorID
JOIN WorkshopPapers
ON WorkshopPapers.WPaperID = WkshpPaperAuthors.WPaperID;

-- workshops and the workshop organizers
CREATE VIEW Vw_WorkOrg_Workshops AS
SELECT WorkshopOrganizers.WOID, WOName AS Name, Affiliation, Workshops.WorkshopID, WName AS WorkshopName
FROM WorkshopOrganizers
JOIN WorkOrgOrganizesWorkshop
ON WorkOrgOrganizesWorkshop.WOID = WorkshopOrganizers.WOID
JOIN Workshops
ON WorkOrgOrganizesWorkshop.WorkshopID = Workshops.WorkshopID;

-- workshop organizers and the volunteers
CREATE VIEW Vw_WorkOrg_Volunteers AS
SELECT WorkshopOrganizers.WOID, WOName AS Name, VolunteerID, VolunteerName, Volunteers.Email, PhoneNumber
FROM WorkshopOrganizers
JOIN Volunteers 
ON WorkshopOrganizers.WOID = Volunteers.WOID;

-- workshop organizers and the organizers
CREATE VIEW Vw_WorkOrg_Organizers AS
SELECT WOID, WOName AS Name, Organizers.OrganizerID, OrgName AS OrganizerName, Organizers.Email, Organizers.PhoneNumber
FROM WorkshopOrganizers
JOIN Organizers
ON Organizers.OrganizerID = WorkshopOrganizers.OrganizerID;

-- volunteers and the workshop organizers
CREATE VIEW Vw_Volunteers_WorkOrg AS
SELECT VolunteerID, VolunteerName AS Name, WorkshopOrganizers.WOID, WOName AS WorkOrgName, WorkshopOrganizers.Email
FROM Volunteers
JOIN WorkshopOrganizers
ON Volunteers.WOID = WorkshopOrganizers.WOID;

-- volunteers and the organizers
CREATE VIEW Vw_Volunteers_Organizers AS
SELECT Volunteers.VolunteerID, VolunteerName AS Name, Organizers.OrganizerID, OrgName, Organizers.Email, Organizers.PhoneNumber
FROM Volunteers
JOIN VolunteerReportsToOrganizers
ON Volunteers.VolunteerID = VolunteerReportsToOrganizers.VolunteerID
JOIN Organizers
ON Organizers.OrganizerID = VolunteerReportsToOrganizers.OrganizerID;

-- organizers and the volunteers
CREATE VIEW Vw_Organizers_Volunteers AS
SELECT Organizers.OrganizerID, OrgName AS Name, Volunteers.VolunteerID, VolunteerName, Volunteers.Email, Volunteers.PhoneNumber
FROM Volunteers
JOIN VolunteerReportsToOrganizers
ON Volunteers.VolunteerID = VolunteerReportsToOrganizers.VolunteerID
JOIN Organizers
ON Organizers.OrganizerID = VolunteerReportsToOrganizers.OrganizerID;

-- organizers and the workshop organizers
CREATE VIEW Vw_Organizers_WorkOrg AS
SELECT Organizers.OrganizerID, OrgName AS Name, WorkshopOrganizers.WOID, WOName, WorkshopOrganizers.Email
FROM WorkshopOrganizers
JOIN Organizers
ON Organizers.OrganizerID = WorkshopOrganizers.OrganizerID;

-- tutorials and the tutors
CREATE VIEW Vw_Tutors_Tutorials AS
SELECT TutorID, TutorName AS Tutor, Nationality, Affiliation, Tutorials.TutorialID, Topic
FROM Tutors
JOIN Tutorials
ON Tutors.TutorialID = Tutorials.TutorialID;

-- tutorial timings
CREATE VIEW Vw_TutorialTimings AS
SELECT Tutorials.TutorialID, Topic, TutDate AS Date, Timing AS Time, TutorName AS Tutor
FROM Tutorials
JOIN Tutors
ON Tutors.TutorialID = Tutorials.TutorialID;
