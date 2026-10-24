/* =====================================================================
   CodeFusion — BULLETPROOF FULL RESET
   Run this ENTIRE file in one go against (localdb)\MSSQLLocalDB.

   What makes this version different: it generates a brand-new, unique
   physical file name for the database every time it runs, so it can
   NEVER collide with an old orphaned .mdf file again. It also cleans
   up any of the 15 CodeFusion tables if they were accidentally created
   directly inside the "master" system database by a previous failed run.
   ===================================================================== */

SET NOCOUNT ON;

-- ---------- STEP 0: Defensive cleanup — remove stray tables from master ----------
-- (These should never live in master. If an earlier run landed them here
--  by mistake, this removes them safely before we do anything else.)
USE master;
GO
IF OBJECT_ID('dbo.StudentNote', 'U') IS NOT NULL DROP TABLE dbo.StudentNote;
IF OBJECT_ID('dbo.Bookmark', 'U') IS NOT NULL DROP TABLE dbo.Bookmark;
IF OBJECT_ID('dbo.StudentAchievement', 'U') IS NOT NULL DROP TABLE dbo.StudentAchievement;
IF OBJECT_ID('dbo.Achievement', 'U') IS NOT NULL DROP TABLE dbo.Achievement;
IF OBJECT_ID('dbo.ChallengeAttempt', 'U') IS NOT NULL DROP TABLE dbo.ChallengeAttempt;
IF OBJECT_ID('dbo.Challenge', 'U') IS NOT NULL DROP TABLE dbo.Challenge;
IF OBJECT_ID('dbo.Employee', 'U') IS NOT NULL DROP TABLE dbo.Employee;
IF OBJECT_ID('dbo.Result', 'U') IS NOT NULL DROP TABLE dbo.Result;
IF OBJECT_ID('dbo.Question', 'U') IS NOT NULL DROP TABLE dbo.Question;
IF OBJECT_ID('dbo.Quiz', 'U') IS NOT NULL DROP TABLE dbo.Quiz;
IF OBJECT_ID('dbo.Material', 'U') IS NOT NULL DROP TABLE dbo.Material;
IF OBJECT_ID('dbo.LessonProgress', 'U') IS NOT NULL DROP TABLE dbo.LessonProgress;
IF OBJECT_ID('dbo.Lesson', 'U') IS NOT NULL DROP TABLE dbo.Lesson;
IF OBJECT_ID('dbo.Student', 'U') IS NOT NULL DROP TABLE dbo.Student;
IF OBJECT_ID('dbo.Admin', 'U') IS NOT NULL DROP TABLE dbo.Admin;
PRINT '--- Step 0 done: master cleaned of any stray CodeFusion tables ---';
GO

-- ---------- STEP 1: Drop existing CodeFusionDB database if the catalog knows about one ----------
USE master;
GO
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'CodeFusionDB')
BEGIN
    ALTER DATABASE CodeFusionDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE CodeFusionDB;
    PRINT '--- Step 1 done: old CodeFusionDB catalog entry dropped ---';
END
ELSE
BEGIN
    PRINT '--- Step 1 done: no existing CodeFusionDB catalog entry found ---';
END
GO

-- ---------- STEP 2: Create CodeFusionDB with a GUARANTEED-UNIQUE file name ----------
-- This sidesteps the "file already exists" problem permanently: even if an
-- old orphaned .mdf is still sitting on disk somewhere, this creates a
-- brand-new file every time, so there is never a collision to worry about.
DECLARE @dataDir NVARCHAR(260);
SELECT @dataDir = LEFT(physical_name, LEN(physical_name) - CHARINDEX('\', REVERSE(physical_name)) + 1)
FROM sys.master_files WHERE database_id = DB_ID('master') AND file_id = 1;

DECLARE @suffix NVARCHAR(30) = REPLACE(REPLACE(REPLACE(CONVERT(NVARCHAR(30), GETDATE(), 120), '-', ''), ':', ''), ' ', '_');
DECLARE @mdfPath NVARCHAR(400) = @dataDir + N'CodeFusionDB_' + @suffix + N'.mdf';
DECLARE @ldfPath NVARCHAR(400) = @dataDir + N'CodeFusionDB_' + @suffix + N'_log.ldf';

DECLARE @createSql NVARCHAR(MAX) = N'
CREATE DATABASE CodeFusionDB
ON PRIMARY (NAME = N''CodeFusionDB'', FILENAME = N''' + @mdfPath + N''')
LOG ON (NAME = N''CodeFusionDB_log'', FILENAME = N''' + @ldfPath + N''');';

EXEC sp_executesql @createSql;

PRINT '--- Step 2 done: CodeFusionDB created at: ' + @mdfPath + ' ---';
GO

-- ---------- STEP 3: Confirm we are actually inside CodeFusionDB before continuing ----------
-- If this fails, the script stops here instead of silently creating tables
-- in the wrong place again.
USE CodeFusionDB;
GO
IF DB_NAME() <> 'CodeFusionDB'
BEGIN
    RAISERROR('STOPPING: still not connected to CodeFusionDB. Do not continue.', 20, 1) WITH LOG;
END
PRINT '--- Step 3 confirmed: now inside database: ' + DB_NAME() + ' ---';
GO

-- ---------- STEP 4: Create all tables ----------
CREATE TABLE Admin (
    AdminID        INT IDENTITY(1,1) PRIMARY KEY,
    FullName       NVARCHAR(100)   NOT NULL,
    Email          NVARCHAR(150)   NOT NULL UNIQUE,
    PasswordHash   NVARCHAR(256)   NOT NULL,
    CreatedOn      DATETIME        NOT NULL DEFAULT GETDATE()
);
GO

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

CREATE TABLE Employee (
    EmployeeID     INT IDENTITY(1,1) PRIMARY KEY,
    Name           NVARCHAR(100)   NOT NULL,
    Email          NVARCHAR(150)   NOT NULL,
    Department     NVARCHAR(100)   NOT NULL,
    Salary         DECIMAL(10,2)   NOT NULL
);
GO

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

CREATE TABLE Bookmark (
    BookmarkID     INT IDENTITY(1,1) PRIMARY KEY,
    StudentID      INT NOT NULL FOREIGN KEY REFERENCES Student(StudentID) ON DELETE CASCADE,
    ItemType       NVARCHAR(30)    NOT NULL,
    ItemID         INT NOT NULL,
    Title          NVARCHAR(200)   NOT NULL,
    CreatedOn      DATETIME NOT NULL DEFAULT GETDATE()
);
GO

CREATE TABLE StudentNote (
    NoteID         INT IDENTITY(1,1) PRIMARY KEY,
    StudentID      INT NOT NULL FOREIGN KEY REFERENCES Student(StudentID) ON DELETE CASCADE,
    LessonID       INT NULL FOREIGN KEY REFERENCES Lesson(LessonID),
    NoteText       NVARCHAR(MAX)   NOT NULL,
    CreatedOn      DATETIME NOT NULL DEFAULT GETDATE(),
    UpdatedOn      DATETIME NULL
);
GO

PRINT '--- Step 4 done: all 15 tables created inside CodeFusionDB ---';
GO

-- ---------- STEP 5: Seed data ----------
USE CodeFusionDB;
GO

INSERT INTO Lesson (ModuleNumber, Title, Explanation, Syntax, CodeExample, ExpectedOutput, KeyPoints, PracticeTask, DisplayOrder) VALUES
(1,  N'Introduction to ASP.NET', N'ASP.NET is a server-side framework by Microsoft for building dynamic web applications using .NET languages such as C#.',
    N'N/A', N'// A page life-cycle event
protected void Page_Load(object sender, EventArgs e) { }',
    N'Page renders in the browser as HTML.',
    N'ASP.NET runs on the server|Pages compile to HTML before reaching the browser|Supports C# and VB.NET',
    N'List three things ASP.NET can build that plain HTML cannot.', 1),
(2,  N'ASP.NET Web Forms', N'Web Forms uses a page-and-control model similar to desktop development, with a code-behind file per page.',
    N'<asp:Control runat="server" />', N'<asp:Label ID="lblMsg" runat="server" Text="Hello" />',
    N'Renders a span with the text Hello.',
    N'.aspx = markup|.aspx.cs = code-behind|ViewState persists control values', N'Create a page with a Label and a Button.', 2),
(3,  N'C# Fundamentals', N'Core C# concepts: variables, data types, conditionals, loops and methods used throughout the site.',
    N'type name = value;', N'int x = 10;
if (x > 5) { Response.Write("Big"); }',
    N'Prints Big to the response.',
    N'C# is statically typed|Use var for inferred types|Methods return a type or void', N'Write a method that returns the larger of two numbers.', 3),
(4,  N'ASP.NET Server Controls', N'Server controls like TextBox, Button and GridView run on the server and maintain state via ViewState.',
    N'<asp:TextBox ID="txtName" runat="server" />', N'string name = txtName.Text;',
    N'Reads the value typed into the textbox.',
    N'Controls must have runat="server"|IDs are used to access controls in code-behind', N'Bind a TextBox value to a Label on button click.', 4),
(5,  N'Events and Event Handling', N'Web Forms follows an event-driven model: button clicks, page load and selection changes raise server-side events.',
    N'protected void ctrl_Event(object sender, EventArgs e)', N'protected void btnSubmit_Click(object sender, EventArgs e) { lblResult.Text = "Clicked!"; }',
    N'Label updates after the button is clicked.',
    N'Page_Load runs on every postback|IsPostBack distinguishes first load from postback', N'Handle a DropDownList SelectedIndexChanged event.', 5),
(6,  N'Validation Controls', N'ASP.NET ships built-in validators for required fields, ranges, comparisons, regex patterns and custom rules.',
    N'<asp:RequiredFieldValidator ControlToValidate="txtName" ... />', N'<asp:RequiredFieldValidator ControlToValidate="txtEmail" ErrorMessage="Required" runat="server" />',
    N'Blocks postback and shows the error message if the field is empty.',
    N'Validators run client-side and server-side|Always check Page.IsValid in code-behind too', N'Add a RegularExpressionValidator for an email field.', 6),
(7,  N'DropDownList and Data Binding', N'DropDownList controls can bind to static items or to database results, and can cascade based on selection.',
    N'ddl.DataSource = data; ddl.DataBind();', N'ddlState.DataSource = GetStates(countryId);
ddlState.DataBind();',
    N'State dropdown repopulates for the selected country.',
    N'DataTextField / DataValueField map columns to display/value|AutoPostBack=true enables cascading', N'Build a Country to State cascading dropdown.', 7),
(8,  N'State Management', N'ASP.NET offers ViewState, Session, Cookies, Query String and Application state to persist data across requests.',
    N'Session["Key"] = value;', N'Session["StudentID"] = student.StudentID;',
    N'Value is available on subsequent requests for that user.',
    N'Session state is per-user|ViewState is per-page|Cookies persist on the client', N'Store the logged-in user in Session and read it on another page.', 8),
(9,  N'SQL Server Connectivity', N'ADO.NET (SqlConnection, SqlCommand) connects ASP.NET applications to SQL Server using parameterized queries.',
    N'SqlCommand cmd = new SqlCommand(sql, conn);', N'cmd.Parameters.AddWithValue("@Id", id);',
    N'Query executes safely without SQL injection risk.',
    N'Always use parameters, never string-concatenate input|Wrap connections in using blocks', N'Write a parameterized SELECT for a single student by ID.', 9),
(10, N'CRUD Operations', N'Create, Read, Update and Delete are the four core database operations exposed through a 3-tier architecture.',
    N'INSERT / SELECT / UPDATE / DELETE', N'INSERT INTO Employee (Name, Email, Department, Salary) VALUES (@Name, @Email, @Dept, @Salary);',
    N'A new row appears in the Employee table.',
    N'Keep SQL in the Data Access Layer|Business Logic Layer validates before calling DAL', N'Implement Update for the Employee table.', 10),
(11, N'Mini Project', N'Combine controls, validation, data binding and CRUD into one small working feature.',
    N'N/A', N'// Employee Management mini project ties together GridView + CRUD + validation',
    N'A working Employee manager page.',
    N'Reuse what you learned in modules 1-10', N'Extend the Employee CRUD Lab with a search box.', 11),
(12, N'Final Assessment', N'A comprehensive mock test covering every roadmap module.',
    N'N/A', N'N/A', N'A scored result with topic-wise breakdown.',
    N'Review weak topics from Progress Analytics before attempting', N'Attempt the Final Mock Test in Quiz Arena.', 12);
GO

INSERT INTO Achievement (Title, Description, IconClass) VALUES
(N'First Step', N'Complete your first lesson.', N'fa-solid fa-shoe-prints'),
(N'Control Explorer', N'Try every control in the Controls Lab.', N'fa-solid fa-sliders'),
(N'Calculator Master', N'Complete every Arithmetic Lab exercise.', N'fa-solid fa-calculator'),
(N'Validation Hero', N'Complete the Validation Lab.', N'fa-solid fa-shield-halved'),
(N'Database Builder', N'Complete all four CRUD operations.', N'fa-solid fa-database'),
(N'Bug Hunter', N'Solve 5 Debug Lab challenges.', N'fa-solid fa-bug'),
(N'Quiz Warrior', N'Attempt 10 quizzes.', N'fa-solid fa-swords'),
(N'Perfect Score', N'Score 100% on any quiz.', N'fa-solid fa-star'),
(N'ASP.NET Explorer', N'Complete 6 roadmap modules.', N'fa-solid fa-compass'),
(N'ASP.NET Master', N'Complete all 12 roadmap modules.', N'fa-solid fa-crown');
GO

INSERT INTO Quiz (Title, QuizType, Topic, TimeLimitMin, TotalMarks) VALUES
(N'ASP.NET Basics - Quick Quiz', N'Quick', N'ASP.NET Basics', 5, 5);
GO
DECLARE @QuizId INT = SCOPE_IDENTITY();

INSERT INTO Question (QuizID, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Marks) VALUES
(@QuizId, N'Which attribute makes an HTML control run on the server?', N'server="true"', N'runat="server"', N'asp:server', N'isServer="1"', 'B', 1),
(@QuizId, N'Which file typically contains the C# code for a Web Form?', N'.aspx', N'.master', N'.aspx.cs', N'.config', 'C', 1),
(@QuizId, N'Which object stores data for a single user across multiple pages?', N'ViewState', N'Session', N'Application', N'Cache', 'B', 1),
(@QuizId, N'Which validator ensures a value falls between two numbers?', N'RequiredFieldValidator', N'CompareValidator', N'RangeValidator', N'CustomValidator', 'C', 1),
(@QuizId, N'Which method binds a DataTable to a GridView?', N'Bind()', N'DataBind()', N'Render()', N'Load()', 'B', 1);
GO

INSERT INTO Challenge (ChallengeType, Difficulty, Question, CodeSnippet, Answer, Hint1, Hint2, Solution, XPReward) VALUES
(N'FindError', N'Easy',
 N'Why does this code fail to compile?',
 N'protected void btnSave_Click(object sender, EventArgs e)
{
    string name = txtName.Text
    lblOutput.Text = name;
}',
 N'Missing semicolon after txtName.Text',
 N'Check the end of the first statement inside the method.',
 N'C# statements must end with a semicolon.',
 N'protected void btnSave_Click(object sender, EventArgs e)
{
    string name = txtName.Text;
    lblOutput.Text = name;
}', 15),
(N'CompleteCode', N'Medium',
 N'Complete the code so the label shows the sum of two textbox values.',
 N'int a = Convert.ToInt32(txtA.Text);
int b = Convert.ToInt32(txtB.Text);
lblResult.Text = ____.ToString();',
 N'(a + b)',
 N'You already parsed a and b - combine them.',
 N'Use the + operator between the two int variables.',
 N'int a = Convert.ToInt32(txtA.Text);
int b = Convert.ToInt32(txtB.Text);
lblResult.Text = (a + b).ToString();', 20),
(N'FixCode', N'Hard',
 N'This SQL query is vulnerable. Fix it using a parameterized query.',
 N'string sql = "SELECT * FROM Student WHERE Email = ''" + email + "''";
SqlCommand cmd = new SqlCommand(sql, conn);',
 N'Use @Email parameter instead of string concatenation',
 N'String concatenation with user input is the core problem here.',
 N'Replace the literal with a parameter placeholder, then add it via cmd.Parameters.',
 N'string sql = "SELECT * FROM Student WHERE Email = @Email";
SqlCommand cmd = new SqlCommand(sql, conn);
cmd.Parameters.AddWithValue("@Email", email);', 30);
GO

INSERT INTO Employee (Name, Email, Department, Salary) VALUES
(N'Aarav Shah', N'aarav.shah@example.com', N'Engineering', 45000.00),
(N'Priya Mehta', N'priya.mehta@example.com', N'Design', 38000.00),
(N'Rohan Patel', N'rohan.patel@example.com', N'QA', 32000.00);
GO

PRINT '--- Step 5 done: seed data inserted ---';
GO

-- ---------- STEP 6: VERIFICATION — look at THIS results grid ----------
-- Expect exactly: CurrentDatabase=CodeFusionDB, TableCount=15, LessonCount=12,
-- LessonColumnCount=11, HasExpectedOutput=1, HasKeyPoints=1, StrayTablesInMaster=0
SELECT
    DB_NAME() AS CurrentDatabase,
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE = 'BASE TABLE')            AS TableCount,
    (SELECT COUNT(*) FROM Lesson)                                                                AS LessonCount,
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Lesson')                 AS LessonColumnCount,
    (SELECT CASE WHEN EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_NAME='Lesson' AND COLUMN_NAME='ExpectedOutput') THEN 1 ELSE 0 END)            AS HasExpectedOutput,
    (SELECT CASE WHEN EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_NAME='Lesson' AND COLUMN_NAME='KeyPoints') THEN 1 ELSE 0 END)                  AS HasKeyPoints,
    (SELECT COUNT(*) FROM master.sys.tables WHERE name IN
        ('Admin','Student','Lesson','LessonProgress','Material','Quiz','Question','Result',
         'Employee','Challenge','ChallengeAttempt','Achievement','StudentAchievement','Bookmark','StudentNote')) AS StrayTablesInMaster;
GO
