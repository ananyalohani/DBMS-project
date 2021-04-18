CREATE INDEX Authors_AuthorID_Affiliation_idx
ON Authors(AuthorID, Affiliation);

CREATE INDEX WkshpPaperAuthors_AuthorID_idx
ON WkshpPaperAuthors(AuthorID);

CREATE INDEX WkshpPaperAuthors_WPaperID_idx
ON WkshpPaperAuthors(WPaperID);

CREATE INDEX Awards_PaperID_idx
ON Awards(PaperID);

CREATE INDEX Awards_WPaperID_idx
ON Awards(WPaperID);

CREATE INDEX VolunteerReportsToOrganizers_VolunteerID_idx
ON VolunteerReportsToOrganizers(VolunteerID);

CREATE INDEX VolunteerReportsToOrganizers_OrganizerID_idx
ON VolunteerReportsToOrganizers(OrganizerID);

CREATE INDEX Volunteers_WOID_idx
ON Volunteers(WOID);

CREATE INDEX AttendeeAttendsTutorial_TutorialID_idx
ON AttendeeAttendsTutorial(TutorialID);

CREATE INDEX MainTrackAuthors_PaperID_idx
ON MainTrackAuthors(PaperID);

CREATE INDEX MainTrackAuthors_AuthorID_idx
ON MainTrackAuthors(AuthorID);

CREATE INDEX Tutors_TutorialID_idx
ON Tutors(TutorialID);

CREATE INDEX Organizers_OrganizerID_OrgRole_idx
ON Organizers(OrgRole);

CREATE INDEX WorkshopOrganizers_OrganizerID_idx
ON WorkshopOrganizer(OrganizerID);

CREATE INDEX WorkOrgOrganizesWorkshop_WorkshopID_idx
ON WorkOrgOrganizesWorkshop(WorkshopID);
