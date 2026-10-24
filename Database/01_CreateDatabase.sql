/* =====================================================================
   CodeFusion — Database Schema
   Run this against SQL Server (SSMS or sqlcmd) before running the site.
   ===================================================================== */

IF DB_ID('CodeFusionDB') IS NULL
    CREATE DATABASE CodeFusionDB;
GO
USE CodeFusionDB;
GO

/* ---------------- Admin ---------------- */
CREATE TABLE Admin (
    AdminID        INT IDENTITY(1,1) PRIMARY KEY,
    FullName       NVARCHAR(100)   NOT NULL,
    Email          NVARCHAR(150)   NOT NULL UNIQUE,
    PasswordHash   NVARCHAR(256)   NOT NULL,
    CreatedOn      DATETIME        NOT NULL DEFAULT GETDATE()
);
GO

/* ---------------- Student ---------------- */
CREATE TABLE Student (
    StudentID      INT IDENTITY(1,1) PRIMARY KEY,
    FullName       NVARCHAR(100)   NOT NULL,
    Email          NVARCHAR(150)   NOT NULL UNIQUE,
    PasswordHash   NVARCHAR(256)   NOT NULL,
    XP             INT             NOT NULL DEFAULT 0,
    Level          INT             NOT NULL DEFAULT 1,
    StreakDays     INT             NOT NULL DEFAULT 0,
    LastActiveDate DATE            NULL,
    IsActive       BIT             NOT NULL DEFAULT 1,
    CreatedOn      DATETIME        NOT NULL DEFAULT GETDATE()
);
GO

/* ---------------- Lesson (12 roadmap modules, ordered lessons) ---------------- */
CREATE TABLE Lesson (
    LessonID       INT IDENTITY(1,1) PRIMARY KEY,
    ModuleNumber   INT             NOT NULL,
    Title          NVARCHAR(150)   NOT NULL,
    Explanation    NVARCHAR(MAX)   NULL,
    Syntax         NVARCHAR(MAX)   NULL,
    CodeExample    NVARCHAR(MAX)   NULL,
    ExpectedOutput NVARCHAR(MAX)   NULL,
    KeyPoints      NVARCHAR(MAX)   NULL,
    PracticeTask   NVARCHAR(MAX)   NULL,
    DisplayOrder   INT             NOT NULL DEFAULT 0,
    IsPublished    BIT             NOT NULL DEFAULT 1
);
GO

CREATE TABLE LessonProgress (
    LessonProgressID INT IDENTITY(1,1) PRIMARY KEY,
    StudentID       INT NOT NULL FOREIGN KEY REFERENCES Student(StudentID) ON DELETE CASCADE,
    LessonID        INT NOT NULL FOREIGN KEY REFERENCES Lesson(LessonID),
    IsCompleted     BIT NOT NULL DEFAULT 0,
    CompletedOn     DATETIME NULL,
    CONSTRAINT UQ_Student_Lesson UNIQUE (StudentID, LessonID)
);
GO

/* ---------------- Material ---------------- */
CREATE TABLE Material (
    MaterialID     INT IDENTITY(1,1) PRIMARY KEY,
    Title          NVARCHAR(150)   NOT NULL,
    Description    NVARCHAR(500)   NULL,
    Topic          NVARCHAR(100)   NOT NULL,
    MaterialType   NVARCHAR(20)    NOT NULL DEFAULT 'PDF',
    FilePath       NVARCHAR(300)   NULL,
    TextContent    NVARCHAR(MAX)   NULL,
    UploadedOn     DATETIME        NOT NULL DEFAULT GETDATE()
);
GO

/* ---------------- Quiz / Question / Result ---------------- */
CREATE TABLE Quiz (
    QuizID         INT IDENTITY(1,1) PRIMARY KEY,
    Title          NVARCHAR(150)   NOT NULL,
    QuizType       NVARCHAR(30)    NOT NULL DEFAULT 'Topic',
    Topic          NVARCHAR(100)   NULL,
    TimeLimitMin   INT             NOT NULL DEFAULT 10,
    TotalMarks     INT             NOT NULL DEFAULT 0,
    IsActive       BIT             NOT NULL DEFAULT 1
);
GO

CREATE TABLE Question (
    QuestionID     INT IDENTITY(1,1) PRIMARY KEY,
    QuizID         INT NOT NULL FOREIGN KEY REFERENCES Quiz(QuizID) ON DELETE CASCADE,
    QuestionText   NVARCHAR(500)   NOT NULL,
    OptionA        NVARCHAR(300)   NOT NULL,
    OptionB        NVARCHAR(300)   NOT NULL,
    OptionC        NVARCHAR(300)   NOT NULL,
    OptionD        NVARCHAR(300)   NOT NULL,
    CorrectOption  CHAR(1)         NOT NULL,
    Marks          INT             NOT NULL DEFAULT 1
);
GO

CREATE TABLE Result (
    ResultID       INT IDENTITY(1,1) PRIMARY KEY,
    StudentID      INT NOT NULL FOREIGN KEY REFERENCES Student(StudentID) ON DELETE CASCADE,
    QuizID         INT NOT NULL FOREIGN KEY REFERENCES Quiz(QuizID),
    Score          INT NOT NULL,
    TotalMarks     INT NOT NULL,
    CorrectCount   INT NOT NULL,
    IncorrectCount INT NOT NULL,
    TimeTakenSec   INT NOT NULL,
    AttemptedOn    DATETIME NOT NULL DEFAULT GETDATE()
);
GO

/* ---------------- Employee (CRUD Lab) ---------------- */
CREATE TABLE Employee (
    EmployeeID     INT IDENTITY(1,1) PRIMARY KEY,
    Name           NVARCHAR(100)   NOT NULL,
    Email          NVARCHAR(150)   NOT NULL,
    Department     NVARCHAR(100)   NOT NULL,
    Salary         DECIMAL(10,2)   NOT NULL
);
GO

/* ---------------- Challenge / ChallengeAttempt (Debug Lab) ---------------- */
CREATE TABLE Challenge (
    ChallengeID    INT IDENTITY(1,1) PRIMARY KEY,
    ChallengeType  NVARCHAR(30)    NOT NULL,
    Difficulty     NVARCHAR(10)    NOT NULL,
    Question       NVARCHAR(500)   NOT NULL,
    CodeSnippet    NVARCHAR(MAX)   NOT NULL,
    Answer         NVARCHAR(MAX)   NOT NULL,
    Hint1          NVARCHAR(300)   NULL,
    Hint2          NVARCHAR(300)   NULL,
    Solution       NVARCHAR(MAX)   NOT NULL,
    XPReward       INT             NOT NULL DEFAULT 20
);
GO

CREATE TABLE ChallengeAttempt (
    AttemptID      INT IDENTITY(1,1) PRIMARY KEY,
    StudentID      INT NOT NULL FOREIGN KEY REFERENCES Student(StudentID) ON DELETE CASCADE,
    ChallengeID    INT NOT NULL FOREIGN KEY REFERENCES Challenge(ChallengeID),
    IsCorrect      BIT NOT NULL DEFAULT 0,
    HintsUsed      INT NOT NULL DEFAULT 0,
    XPEarned       INT NOT NULL DEFAULT 0,
    AttemptedOn    DATETIME NOT NULL DEFAULT GETDATE()
);
GO

/* ---------------- Achievement / StudentAchievement ---------------- */
CREATE TABLE Achievement (
    AchievementID  INT IDENTITY(1,1) PRIMARY KEY,
    Title          NVARCHAR(100)   NOT NULL,
    Description    NVARCHAR(300)   NOT NULL,
    IconClass      NVARCHAR(50)    NOT NULL
);
GO

CREATE TABLE StudentAchievement (
    StudentAchievementID INT IDENTITY(1,1) PRIMARY KEY,
    StudentID      INT NOT NULL FOREIGN KEY REFERENCES Student(StudentID) ON DELETE CASCADE,
    AchievementID  INT NOT NULL FOREIGN KEY REFERENCES Achievement(AchievementID),
    EarnedOn       DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT UQ_Student_Achievement UNIQUE (StudentID, AchievementID)
);
GO

/* ---------------- Bookmark ---------------- */
CREATE TABLE Bookmark (
    BookmarkID     INT IDENTITY(1,1) PRIMARY KEY,
    StudentID      INT NOT NULL FOREIGN KEY REFERENCES Student(StudentID) ON DELETE CASCADE,
    ItemType       NVARCHAR(30)    NOT NULL,
    ItemID         INT NOT NULL,
    Title          NVARCHAR(200)   NOT NULL,
    CreatedOn      DATETIME NOT NULL DEFAULT GETDATE()
);
GO

/* ---------------- StudentNote ---------------- */
CREATE TABLE StudentNote (
    NoteID         INT IDENTITY(1,1) PRIMARY KEY,
    StudentID      INT NOT NULL FOREIGN KEY REFERENCES Student(StudentID) ON DELETE CASCADE,
    LessonID       INT NULL FOREIGN KEY REFERENCES Lesson(LessonID),
    NoteText       NVARCHAR(MAX)   NOT NULL,
    CreatedOn      DATETIME NOT NULL DEFAULT GETDATE(),
    UpdatedOn      DATETIME NULL
);
GO

PRINT 'CodeFusionDB schema created successfully.';
