CREATE INDEX AuthorName_idx
ON Authors (AuthorName);

CREATE INDEX AuthorAffiliation_idx
ON Authors(Affiliation);

CREATE INDEX WkshpPaperAuthors_idx
ON WkshpPaperAuthors (AuthorID);

CREATE INDEX AwardsPaper_idx
ON Awards (PaperID);

CREATE INDEX AwardsWkshpPaper_idx
ON Awards (WPaperID);

CREATE INDEX VolunteerIDReportsToOrganizers_idx
ON VolunteerReportsToOrganizers (VolunteerID);

CREATE INDEX VolunteerReportsToOrganizerID_idx
ON VolunteerReportsToOrganizers (OrganizerID);

CREATE INDEX VolunteersName_idx
ON Volunteers (VolunteerName);

CREATE INDEX AttendeeAttendsTutorialID_idx
ON AttendeeAttendsTutorial (TutorialID);

