CREATE DATABASE Spectrum;
USE Spectrum;

CREATE TABLE Authors(
  AuthorID INT auto_increment, 
  AuthorName TEXT NOT NULL, 
  Age INT NOT NULL, 
  Nationality TEXT NOT NULL, 
  Email TEXT NOT NULL,
  Present CHAR NOT NULL,
  Affiliation TEXT NOT NULL,
  PRIMARY KEY(AuthorID),
  CHECK(Age > 0)
);

CREATE TABLE Organizers(
  OrganizerID INT auto_increment,
  OrgName TEXT NOT NULL,
  Age INT NOT NULL,
  Affiliation TEXT NOT NULL,
  OrgRole TEXT NOT NULL,
  PhoneNumber TEXT NOT NULL,
  Email TEXT NOT NULL,
  Nationality TEXT NOT NULL,CHECK(Age > 0),
  PRIMARY KEY(OrganizerID)
);

CREATE TABLE Workshops(
  WorkshopID INT auto_increment,
  WName TEXT NOT NULL, 
  PRIMARY KEY(WorkshopID)
);

CREATE TABLE Tutorials(
  TutorialID INT auto_increment, 
  Topic TEXT NOT NULL, 
  TutDate DATE NOT NULL, 
  Timing TIME NOT NULL, 
  PRIMARY KEY (TutorialID)
);

CREATE TABLE ExternalAttendees(
  AttendeeID INT auto_increment, 
  AttendeeName TEXT NOT NULL,
  Age INT NOT NULL,
  CHECK(Age > 0),
  Affiliation TEXT NOT NULL,
  Email TEXT NOT NULL,
  Present CHAR NOT NULL,
  Country TEXT NOT NULL,
  PRIMARY KEY(AttendeeID)
);

CREATE TABLE AuthorAttendsTutorial(
  TutorialID INT NOT NULL,
  AuthorID INT NOT NULL,
  Present CHAR NOT NULL,
  FOREIGN KEY(TutorialID) REFERENCES Tutorials(TutorialID) on delete cascade,
  FOREIGN KEY (AuthorID) REFERENCES Authors(AuthorID) on delete cascade
);

CREATE TABLE MainTrackPapers (
  PaperID INT auto_increment, 
  Title TEXT NOT NULL,
  PRIMARY KEY(PaperID)
);

CREATE TABLE WorkshopPapers (
  WPaperID INT auto_increment, 
  Title TEXT NOT NULL,
  WorkshopID INT NOT NULL,
  FOREIGN KEY (WorkshopID) REFERENCES Workshops(WorkshopID) on delete cascade,
  PRIMARY KEY(WPaperID)
);

CREATE TABLE WorkshopOrganizers(
  WOID INT auto_increment, 
  WOName TEXT NOT NULL, 
  Affiliation TEXT NOT NULL, 
  Email TEXT NOT NULL, 
  AuthorID INT,
  OrganizerID INT,
  PRIMARY KEY(WOID),
  FOREIGN KEY (OrganizerID) REFERENCES Organizers(OrganizerID) on delete cascade,
  FOREIGN KEY (AuthorID) REFERENCES Authors(AuthorID) on delete cascade
);

CREATE TABLE Volunteers(
  VolunteerID INT auto_increment,
  VolunteerName TEXT NOT NULL, 
  Affiliation TEXT NOT NULL, 
  Age INT NOT NULL, 
  Country TEXT NOT NULL, 
  Email TEXT NOT NULL,
  PhoneNumber TEXT,
  WOID INT,
  FOREIGN KEY (WOID) REFERENCES WorkshopOrganizers(WOID) on delete cascade,
  PRIMARY KEY(VolunteerID),
  CHECK(Age > 0)
);

CREATE TABLE MainTrackAuthors(
  AuthorID INT not null,
  PaperID INT not null,
  FOREIGN KEY (AuthorID) REFERENCES Authors(AuthorID) on delete cascade,
  FOREIGN KEY (PaperID) REFERENCES MainTrackPapers(PaperID) on delete cascade
);

CREATE TABLE WkshpPaperAuthors(
  AuthorID INT not null,
  WPaperID INT not null,
  FOREIGN KEY (AuthorID) REFERENCES Authors(AuthorID) on delete cascade,
  FOREIGN KEY (WPaperID) REFERENCES WorkshopPapers(WPaperID) on delete cascade
);

CREATE TABLE Awards(
  AwardID INT auto_increment, 
  AwardName TEXT NOT NULL, 
  PRIMARY KEY(AwardID),
  PaperID INT,
  WPaperID INT,
  FOREIGN KEY (PaperID) REFERENCES MainTrackPapers(PaperID) on delete cascade,
  FOREIGN KEY (WPaperID) REFERENCES WorkshopPapers(WPaperID) on delete cascade
);

CREATE TABLE Tutors(
  TutorID INT auto_increment, 
  TutorName TEXT NOT NULL, 
  Age INT NOT NULL,
  CHECK(Age > 0),
  Affiliation TEXT NOT NULL, 
  Email TEXT NOT NULL, 
  Nationality TEXT NOT NULL, 
  PRIMARY KEY (TutorID),
  AuthorID INT,
  TutorialID INT,
  FOREIGN KEY (TutorialID) REFERENCES Tutorials(TutorialID) on delete cascade,
  FOREIGN KEY (AuthorID) REFERENCES Authors(AuthorID) on delete cascade
);

CREATE TABLE AttendeeAttendsTutorial(
  TutorialID INT NOT NULL,
  AttendeeID INT NOT NULL,
  Present CHAR NOT NULL,
  FOREIGN KEY (TutorialID) REFERENCES Tutorials(TutorialID) on delete cascade,
  FOREIGN KEY (AttendeeID) REFERENCES ExternalAttendees(AttendeeID) on delete cascade
);

CREATE TABLE VolunteerReportsToOrganizers(
  VolunteerID INT NOT NULL,
  OrganizerID INT NOT NULL,
  FOREIGN KEY (VolunteerID) REFERENCES Volunteers(VolunteerID) on delete cascade,
  FOREIGN KEY (OrganizerID) REFERENCES Organizers(OrganizerID) on delete cascade
);

CREATE TABLE WorkOrgOrganizesWorkshop(
  WOID INT NOT NULL,
  WorkshopID INT NOT NULL,
  FOREIGN KEY (WOID) REFERENCES WorkshopOrganizers(WOID) on delete cascade,
  FOREIGN KEY (WorkshopID) REFERENCES Workshops(WorkshopID) on delete cascade
);