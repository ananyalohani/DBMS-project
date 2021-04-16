USE SPECTRUM;

LOAD DATA LOCAL INFILE '/Users/lohanis/Desktop/DBMS-project/data/authors.csv' 
INTO TABLE Authors FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' 
IGNORE 1 ROWS (AuthorID, AuthorName, Age, Affiliation, Nationality, Email, Present);

LOAD DATA LOCAL INFILE '/Users/lohanis/Desktop/DBMS-project/data/maintrack_papers.csv'
INTO TABLE MainTrackPapers FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n'
IGNORE 1 ROWS (PaperID, Title);

LOAD DATA LOCAL INFILE '/Users/lohanis/Desktop/DBMS-project/data/workshops.csv' 
INTO TABLE Workshops FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' 
IGNORE 1 ROWS (WorkshopID, WName);

LOAD DATA LOCAL INFILE '/Users/lohanis/Desktop/DBMS-project/data/wkshp_papers.csv' 
INTO TABLE WorkshopPapers FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' 
IGNORE 1 ROWS (WPaperID, Title, WorkshopID);

LOAD DATA LOCAL INFILE '/Users/lohanis/Desktop/DBMS-project/data/organizers.csv' 
INTO TABLE Organizers FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' 
IGNORE 1 ROWS (OrganizerID, OrgName, Age, Affiliation, OrgRole, PhoneNumber, Email, Nationality);


LOAD DATA LOCAL INFILE '/Users/lohanis/Desktop/DBMS-project/data/workshop_organizers.csv' 
INTO TABLE WorkshopOrganizers FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' 
IGNORE 1 ROWS (WOID, WOName, Affiliation, Email, @vAuthorID, @vOrganizerID)
SET
AuthorID = NULLIF(@vAuthorID, 0),
OrganizerID = NULLIF(@vOrganizerID, 0);

LOAD DATA LOCAL INFILE '/Users/lohanis/Desktop/DBMS-project/data/volunteers.csv' 
INTO TABLE Volunteers FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' 
IGNORE 1 ROWS (VolunteerID, VolunteerName, Affiliation, Age, Country, Email, PhoneNumber, @vWOID)
SET
WOID = NULLIF(@vWOID, 0);

LOAD DATA LOCAL INFILE '/Users/lohanis/Desktop/DBMS-project/data/awards.csv' 
INTO TABLE Awards FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' 
IGNORE 1 ROWS (AwardID, AwardName, @vPaperID, @vWPaperID)
SET
PaperID = NULLIF(@vPaperID, 0),
WPaperID = NULLIF(@vWPaperID, 0);

LOAD DATA LOCAL INFILE '/Users/lohanis/Desktop/DBMS-project/data/external_attendees.csv' 
INTO TABLE ExternalAttendees FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' 
IGNORE 1 ROWS (AttendeeID, AttendeeName, Age, Affiliation, Email, Present, Country);

LOAD DATA LOCAL INFILE '/Users/lohanis/Desktop/DBMS-project/data/tutorials.csv' 
INTO TABLE Tutorials FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' 
IGNORE 1 ROWS (TutorialID, Topic, TutDate, Timing);

LOAD DATA LOCAL INFILE '/Users/lohanis/Desktop/DBMS-project/data/tutors.csv'
INTO TABLE Tutors FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n'
IGNORE 1 ROWS (TutorID, TutorName, Age, Affiliation, Email, Nationality, @vAuthorID, @vTutorialID)
SET 
AuthorID = NULLIF(@vAuthorID, 0),
TutorialID = NULLIF(@vTutorialID, 0);

LOAD DATA LOCAL INFILE '/Users/lohanis/Desktop/DBMS-project/data/maintrack_authors.csv' 
INTO TABLE MainTrackAuthors FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' 
IGNORE 1 ROWS (AuthorID, PaperID);

LOAD DATA LOCAL INFILE '/Users/lohanis/Desktop/DBMS-project/data/wkshp_paper_authors.csv' 
INTO TABLE WkshpPaperAuthors FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' 
IGNORE 1 ROWS (AuthorID, WPaperID);

LOAD DATA LOCAL INFILE '/Users/lohanis/Desktop/DBMS-project/data/volunteers_to_organizers.csv' 
INTO TABLE VolunteerReportsToOrganizers FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' 
IGNORE 1 ROWS (VolunteerID, OrganizerID);

LOAD DATA LOCAL INFILE '/Users/lohanis/Desktop/DBMS-project/data/authors_attends_tut.csv' 
INTO TABLE AuthorAttendsTutorial FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' 
IGNORE 1 ROWS (TutorialID, AuthorID, Present);

LOAD DATA LOCAL INFILE '/Users/lohanis/Desktop/DBMS-project/data/wo_to_wkshp.csv' 
INTO TABLE WorkOrgOrganizesWorkshop FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' 
IGNORE 1 ROWS (WOID, WorkshopID);

LOAD DATA LOCAL INFILE '/Users/lohanis/Desktop/DBMS-project/data/attendees_to_tuts.csv' 
INTO TABLE AttendeeAttendsTutorial FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' 
IGNORE 1 ROWS (TutorialID, AttendeeID, Present);