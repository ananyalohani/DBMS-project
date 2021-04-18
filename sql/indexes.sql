MainTrackAuthors_AuthorID_idx -- 6
WkshpPaperAuthors_AuthorID_idx -- 5
MainTrackAuthors_PaperID_idx -- 5
WkshpPaperAuthors_WPaperID_idx -- 4
Tutors_TutorialID_idx -- 3
WorkOrgOrganizesWorkshop_WorkshopID_idx -- 2
WorkOrgOrganizesWorkshop_WOID_idx -- 2
Volunteers_WOID_idx -- 2
VolunteerReportsToOrganizers_VolunteerID_idx -- 2
VolunteerReportsToOrganizers_OrganizerID_idx -- 2
WorkshopOrganizers_OrganizerID_idx -- 2
Awards_PaperID_idx -- 2
Awards_WPaperID_idx --2
Authors_AuthorID_Affiliation_idx -- 1 (composite)
Organizers_OrganizerID_OrgRole_idx -- 1 (composite)




/* CREATE INDEX AuthorName_idx
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
 */
