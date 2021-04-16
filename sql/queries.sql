-- declare all server variables
DECLARE @AuthorID INT;
DECLARE @OrganizerID INT;
DECLARE @VolunteerID INT;
DECLARE @TutorID INT;
DECLARE @WorkOrgID INT;

-- papers published from author's affiliation
-- references @AuthorID
SET @AuthorID = 200003;

SELECT DISTINCT MainTrackAuthors.PaperID, Title
FROM Authors
JOIN MainTrackAuthors
ON Authors.AuthorID = MainTrackAuthors.AuthorID 
JOIN MainTrackPapers 
ON MainTrackAuthors.PaperID = MainTrackPapers.PaperID 
WHERE Authors.Affiliation IN 
(
  SELECT Affiliation 
  FROM Authors
  WHERE AuthorID = @AuthorID
);

-- fellow authors who won awards
-- references @AuthorID
SET @AuthorID = 200008;

SELECT Vw_MainTrackAwards.AuthorID, AuthorName, AwardName
FROM Vw_MainTrackAwards 
JOIN MainTrackAuthors
ON MainTrackAuthors.AuthorID = Vw_MainTrackAwards.AuthorID
JOIN MainTrackPapers
ON MainTrackAuthors.PaperID = MainTrackPapers.PaperID 
JOIN Authors 
ON Vw_MainTrackAwards.AuthorID = Authors.AuthorID
WHERE MainTrackAuthors.PaperID IN
(
  SELECT DISTINCT PaperID
  FROM MainTrackAuthors
  WHERE MainTrackAuthors.AuthorID = @AuthorID
)
AND Authors.AuthorID <> @AuthorID
UNION
SELECT Vw_WorkshopAwards.AuthorID, AuthorName, AwardName
FROM Vw_WorkshopAwards 
JOIN WkshpPaperAuthors
ON WkshpPaperAuthors.AuthorID = Vw_WorkshopAwards.AuthorID
JOIN WorkshopPapers
ON WkshpPaperAuthors.WPaperID = WorkshopPapers.WPaperID 
JOIN Authors 
ON Vw_WorkshopAwards.AuthorID = Authors.AuthorID
WHERE WkshpPaperAuthors.WPaperID IN
(
  SELECT DISTINCT WPaperID
  FROM WkshpPaperAuthors
  WHERE WkshpPaperAuthors.AuthorID = @AuthorID
)
AND Authors.AuthorID <> @AuthorID;

-- organizers that the volunteer reports to
-- references @VolunteerID;
SET @VolunteerID = 700006;

SELECT OrganizerID, OrgName
FROM Vw_Volunteers_Organizers
WHERE VolunteerID = @VolunteerID;

-- fellow volunteers (based on common organizer)
-- references @VolunteerID;
SET @VolunteerID = 700006;

SELECT DISTINCT VolunteerID, Name
FROM Vw_Volunteers_Organizers
WHERE OrganizerID IN
(
  SELECT Organizers.OrganizerID
  FROM Organizers
  JOIN VolunteerReportsToOrganizers
  ON Organizers.OrganizerID = VolunteerReportsToOrganizers.OrganizerID
  JOIN Volunteers 
  ON Volunteers.VolunteerID = VolunteerReportsToOrganizers.VolunteerID
  WHERE Volunteers.VolunteerID = @VolunteerID
) 
AND VolunteerID <> @VolunteerID;

-- volunteers reporting to organizer
-- references @OrganizerID
SET @OrganizerID = 500007;

SELECT VolunteerID, VolunteerName
FROM Vw_Organizers_Volunteers
WHERE OrganizerID = @OrganizerID;

-- workshop organizers reporting to organizer
-- references @OrganizerID
SET @OrganizerID = 500004;

SELECT WOID, WOName
FROM Vw_Organizers_WorkOrg
WHERE OrganizerID = @OrganizerID;

-- fellow organizer (based on common role)
-- references @OrganizerID
SET @OrganizerID = 500007;

SELECT OrganizerID, OrgName
FROM Organizers
WHERE OrganizerID <> @OrganizerID 
AND OrgRole IN
(
  SELECT OrgRole
  FROM Organizers
  WHERE OrganizerID = @OrganizerID
);

-- number of people registered for tutor's talks 
-- references @TutorID
SET @TutorID = 800004;

SELECT COUNT(*) as NumberOfAttendees
FROM AttendeeAttendsTutorial
WHERE TutorialID IN
(
  SELECT TutorialID
  FROM tutors
  WHERE TutorID = @TutorID
);

-- names of attendees in tutor's tutorial who are authors
-- references @TutorID
SET @TutorID = 800004;

SELECT DISTINCT AuthorID, AuthorName
FROM Authors
WHERE AuthorID IN
(
  SELECT AuthorID
  FROM AuthorAttendsTutorial
  WHERE TutorialID IN
  (
    SELECT TutorialID
    FROM tutors
    WHERE TutorID = @TutorID
  )
);

-- tutorial details
SELECT * FROM Vw_TutorialTimings;

-- contact details of volunteers
SELECT VolunteerID, VolunteerName, Email, PhoneNumber
FROM Volunteers;

-- contact details of organizers
SELECT OrganizerID, OrgName, Email, PhoneNumber
FROM Organizers;

-- papers that won awards in workshop organizer's workshop
-- references @WorkOrgID
SET @WorkOrgID = 400004;

SELECT Awards.WPaperID, Title, AwardName as Award
FROM Awards
JOIN WorkshopPapers
ON Awards.WPaperID = WorkshopPapers.WPaperID
JOIN WorkOrgOrganizesWorkshop
ON WorkOrgOrganizesWorkshop.WorkshopID = WorkshopPapers.WorkshopID
WHERE WOID = @WorkOrgID;

-- volunteers in workshop organizer's workshop
SET @WorkOrgID = 400005;

SELECT VolunteerID, VolunteerName
FROM Vw_WorkOrg_Volunteers
WHERE WOID = @WorkOrgID;
