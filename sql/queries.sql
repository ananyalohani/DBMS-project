-- declare all server variables
DECLARE @AuthorID INT;
DECLARE @OrganizerID INT;
DECLARE @VolunteerID INT;
DECLARE @TutorID INT;
DECLARE @WorkOrgID INT;

-- === EMBEDDED SQL === --

-- ranking of authors based on number of papers published
SELECT Authors.AuthorID, AuthorName, IFNULL(MainTrackCount,0) AS MainTrackCount, IFNULL(WorkshopPaperCount, 0) AS WorkshopPaperCount, (IFNULL(MainTrackCount,0) + IFNULL(WorkshopPaperCount, 0)) AS TotalPaperCount 
FROM
(
  Authors
  LEFT JOIN
  (
    SELECT AuthorID, count(*) AS MainTrackCount
    FROM MainTrackAuthors 
    group by AuthorID
  ) AS T2
  ON
  Authors.AuthorID = T2.AuthorID
  LEFT JOIN
  (
    SELECT AuthorID, count(*) AS WorkshopPaperCount
    FROM WkshpPaperAuthors
    group by AuthorID
  ) AS T3
  ON
  T2.AuthorID = T3.AuthorID
)
ORDER BY TotalPaperCount desc;

-- number of people registered for each tutorial
Select T3.TutorialID, Topic, (IFNULL(NumberOfAttendees,0) + IFNULL(NumberOfAuthors,0)) AS TotalAttendees
FROM
(
  Select T1.TutorialID,T1.Topic, NumberOfAttendees 
  FROM 
  (
    (
      Select TutorialID, Topic
      FROM Tutorials
    ) AS T1
    LEFT JOIN
    (
      SELECT TutorialID, COUNT(*) AS NumberOfAttendees
      FROM AttendeeAttendsTutorial
      GROUP BY TutorialID
    ) AS T2
    ON
    T1.TutorialID = T2.TutorialID
  )
) AS T3
LEFT JOIN
(
  SELECT TutorialID, COUNT(*) AS NumberOfAuthors
  FROM AuthorAttendsTutorial
  GROUP BY TutorialID
) AS T4
ON
T3.TutorialID = T4.TutorialID;

-- main track, workshop and total papers published according to institution
SELECT T3.Affiliation AS Institution, MainTrackCount, IFNULL(WorkshopPaperCount, 0) AS WorkshopPaperCount, (MainTrackCount + IFNULL(WorkshopPaperCount, 0)) AS TotalPaperCount
FROM 
(
  SELECT T1.Affiliation, IFNULL(MainTrackCount, 0) AS MainTrackCount
  FROM 
  (
    Select Distinct Affiliation 
    FROM Authors
  ) AS T1
  LEFT JOIN
  (
    Select Affiliation, Count(*) AS MainTrackCount 
    FROM 
    (
      Select Distinct Affiliation, PaperID 
      FROM 
      (
        Select Authors.AuthorID, Affiliation, PaperID 
        FROM Authors
        LEFT JOIN
        MainTrackAuthors
        ON Authors.AuthorID = MainTrackAuthors.AuthorID
      ) AS Ta
    ) AS Tb
    GROUP BY Affiliation
  ) AS T2
  ON
  T1.Affiliation = T2.Affiliation
) AS T3
LEFT JOIN
(
  Select Affiliation, Count(*) AS WorkshopPaperCount 
  FROM 
  (
    Select Distinct Affiliation, WPaperID 
    FROM 
    (
      Select Authors.AuthorID, Affiliation, WPaperID 
      FROM Authors
      LEFT JOIN
      WkshpPaperAuthors
      ON Authors.AuthorID = WkshpPaperAuthors.AuthorID
    ) AS Tc
  ) AS Td
  GROUP BY Affiliation
) AS T4
ON T3.Affiliation = T4.Affiliation
ORDER BY TotalPaperCount desc;

-- summary statistics
SELECT *
FROM
(
  SELECT count(*) AS TotalAuthors
  FROM Authors
) AS T1,
(
  SELECT count(*) AS TotalWorkshops
  FROM Workshops
) AS T2,
(
  SELECT count(*) AS MainTrackPaperCount
  FROM MainTrackPapers
) AS T3,
(
  SELECT count(*) AS WorkshopPaperCount
  FROM WorkshopPapers
) AS T4;


-- === VANILLA SQL === --

-- papers published FROM author's affiliation
-- references @AuthorID
SET @AuthorID = 200003;

SELECT DISTINCT MainTrackAuthors.PaperID, Title
FROM (
  SELECT * 
  FROM Authors 
  WHERE Authors.Affiliation IN
  (
    SELECT Affiliation
    FROM Authors
    WHERE AuthorID = @AuthorID
  )
) AS T
JOIN MainTrackAuthors
ON T.AuthorID = MainTrackAuthors.AuthorID
JOIN MainTrackPapers
ON MainTrackAuthors.PaperID = MainTrackPapers.PaperID;

-- fellow authors who won awards
-- references @AuthorID
SET @AuthorID = 200008;

SELECT Vw_MainTrackAwards.AuthorID, AuthorName, AwardName
FROM Vw_MainTrackAwards
JOIN 
(
  SELECT * 
  FROM MainTrackAuthors 
  where PaperID IN 
  (
    SELECT DISTINCT PaperID
    FROM MainTrackAuthors
    WHERE MainTrackAuthors.AuthorID = @AuthorID
  )
) AS T1
ON T1.AuthorID = Vw_MainTrackAwards.AuthorID
JOIN MainTrackPapers
ON T1.PaperID = MainTrackPapers.PaperID
JOIN (
  SELECT * 
  FROM Authors 
  where Authors.AuthorID <> @AuthorID
) AS T2
ON Vw_MainTrackAwards.AuthorID = T2.AuthorID
UNION
SELECT Vw_WorkshopAwards.AuthorID, AuthorName, AwardName
FROM Vw_WorkshopAwards
JOIN 
(
  SELECT * 
  FROM WkshpPaperAuthors
  where WPaperID IN 
  (
    SELECT DISTINCT WPaperID
    FROM WkshpPaperAuthors
    WHERE WkshpPaperAuthors.AuthorID = @AuthorID
  )
) AS T3
ON T3.AuthorID = Vw_WorkshopAwards.AuthorID
JOIN WorkshopPapers
ON T3.WPaperID = WorkshopPapers.WPaperID
JOIN (
  SELECT *
  FROM Authors
  where Authors.AuthorID <> @AuthorID
) AS T4
ON Vw_WorkshopAwards.AuthorID = T4.AuthorID;

-- organizers that the volunteer reports to
-- references @VolunteerID;
SET @VolunteerID = 700006;

SELECT Organizers.OrganizerID, OrgName
FROM 
(
  Select * 
  FROM Volunteers 
  WHERE Volunteers.VolunteerID = @VolunteerID
) AS T1
JOIN VolunteerReportsToOrganizers
ON T1.VolunteerID = VolunteerReportsToOrganizers.VolunteerID
JOIN Organizers
ON Organizers.OrganizerID = VolunteerReportsToOrganizers.OrganizerID;


-- fellow volunteers (based on common organizer)
-- references @VolunteerID;
SET @VolunteerID = 700006;

SELECT DISTINCT T1.VolunteerID, VolunteerName
FROM
(
  Select * 
  FROM Volunteers 
  WHERE Volunteers.VolunteerID <> @VolunteerID
) AS T1
JOIN VolunteerReportsToOrganizers
ON T1.VolunteerID = VolunteerReportsToOrganizers.VolunteerID
JOIN 
(
  Select * 
  FROM Organizers 
  WHERE Organizers.OrganizerID IN
  ( 
    SELECT Organizers.OrganizerID
    FROM Organizers
    JOIN VolunteerReportsToOrganizers
    ON Organizers.OrganizerID = VolunteerReportsToOrganizers.OrganizerID
    JOIN 
    (
      Select *
      FROM Volunteers
      where VolunteerID = @VolunteerID
    ) AS T3
    ON T3.VolunteerID = VolunteerReportsToOrganizers.VolunteerID
  )
) AS T2
ON T2.OrganizerID = VolunteerReportsToOrganizers.OrganizerID;

-- volunteers and workshop organizers reporting to organizer
-- references @OrganizerID
SET @OrganizerID = 500007;

SELECT Volunteers.VolunteerID AS ID, VolunteerName AS Name, ‘Volunteer’ AS Type
FROM Volunteers
JOIN VolunteerReportsToOrganizers
ON Volunteers.VolunteerID = VolunteerReportsToOrganizers.VolunteerID
JOIN 
(
  SELECT *
  FROM Organizers 
  WHERE Organizers.OrganizerID = @OrganizerID
) AS T1
ON T1.OrganizerID = VolunteerReportsToOrganizers.OrganizerID
UNION ALL
SELECT WOID AS ID, WOName AS Name, ‘Workshop Organizer’ AS Type
FROM WorkshopOrganizers
JOIN 
(
  SELECT * 
  FROM Organizers 
  WHERE Organizers.OrganizerID = @OrganizerID
) AS T2
ON T2.OrganizerID = WorkshopOrganizers.OrganizerID;

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

SELECT COUNT(*) AS NumberOfAttendees
FROM AttendeeAttendsTutorial
WHERE TutorialID IN
(
  SELECT TutorialID
  FROM tutors
  WHERE TutorID = @TutorID
);

-- attendees IN tutor's tutorial who are authors
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
SELECT Tutorials.TutorialID, Topic, TutDate AS Date, Timing AS Time, TutorName AS Tutor
FROM Tutorials
JOIN Tutors
ON Tutors.TutorialID = Tutorials.TutorialID;

-- contact details of volunteers and organizers
SELECT VolunteerID AS ID, “Volunteer” AS Type, VolunteerName AS Name, Email, PhoneNumber
FROM Volunteers;
UNION ALL
SELECT OrganizerID AS ID, “Organizer” AS Type, OrgName AS Name, Email, PhoneNumber
FROM Organizers;

-- papers that won awards IN workshop organizer's workshop
-- references @WorkOrgID
SET @WorkOrgID = 400004;

SELECT Awards.WPaperID, Title, AwardName AS Award
FROM Awards
JOIN WorkshopPapers
ON Awards.WPaperID = WorkshopPapers.WPaperID
JOIN 
(
  SELECT * 
  FROM WorkOrgOrganizesWorkshop 
  WHERE WOID = @WorkOrgID
) AS T
ON T.WorkshopID = WorkshopPapers.WorkshopID;

-- volunteers IN workshop organizer's workshop
SET @WorkOrgID = 400005;

SELECT VolunteerID, VolunteerName
FROM WorkshopOrganizers
JOIN Volunteers 
ON Volunteers.WOID = @WorkOrgID;

-- papers which won awards
(
  SELECT AwardName,'MainTrack' AS Category, Title
  FROM Awards
  JOIN MainTrackPapers
  ON Awards.PaperID = MainTrackPapers.PaperID
)
UNION ALL
(
  SELECT AwardName, 'Workshop' AS Category, Title
  FROM Awards
  JOIN WorkshopPapers
  ON Awards.WPaperID = WorkshopPapers.WPaperID
);
