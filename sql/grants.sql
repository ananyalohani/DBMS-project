CREATE USER 'Organizer'@'localhost';
CREATE USER 'Author'@'localhost';
CREATE USER 'WorkOrg'@'localhost';
CREATE USER 'Tutor'@'localhost';
CREATE USER 'Volunteer'@'localhost';
CREATE USER 'Attendee'@'localhost';

-- organizer
GRANT ALL
ON *.*
TO 'Organizer'@'localhost';

-- author
GRANT SELECT
ON Vw_MainTrackAwards
TO 'Author'@'localhost';

GRANT SELECT
ON Vw_MainTrackAuthors
TO 'Author'@'localhost';

GRANT SELECT
ON Vw_WorkshopAuthors
TO 'Author'@'localhost';

GRANT SELECT
ON Organizers
TO 'Author'@'localhost';

GRANT SELECT
ON Vw_WorkshopAwards
TO 'Author'@'localhost'

-- workshop organizer
GRANT SELECT
ON Vw_WorkshopAwards
TO 'WorkOrg'@'localhost';

GRANT SELECT
ON Vw_WorkOrg_Workshops
TO 'WorkOrg'@'localhost';

GRANT SELECT
ON Vw_WorkOrg_Volunteers
TO 'WorkOrg'@'localhost';

GRANT SELECT
ON Vw_WorkOrg_Organizers
TO 'WorkOrg'@'localhost';

-- tutor
GRANT SELECT 
ON Vw_Tutors_Tutorials
TO 'Tutor'@'localhost';

GRANT SELECT 
ON Vw_TutorialTimings
TO 'Tutor'@'localhost';

-- volunteer
GRANT SELECT 
ON Vw_Volunteers_WorkOrg
TO 'Volunteer'@'localhost';

GRANT SELECT 
ON Vw_Volunteers_Organizers
TO 'Volunteer'@'localhost';

-- attendee
GRANT SELECT 
ON Vw_TutorialTimings
TO 'Attendee'@'localhost';