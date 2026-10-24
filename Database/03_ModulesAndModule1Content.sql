/* =====================================================================
   CodeFusion — Modules + Enhanced Lessons migration (Stage 2-4)
   Run this ONCE against your existing CodeFusionDB.
   Per your confirmation: clears existing LessonProgress/Bookmark(Lesson)/
   StudentNote(lesson-linked)/Lesson test data only — does NOT touch
   Student, Admin, Employee, Quiz, Result, or general (non-lesson) notes.
   Does NOT drop the database. Does NOT touch any other table's data.
   ===================================================================== */
USE CodeFusionDB;
GO
SET NOCOUNT ON;

PRINT '--- Clearing old lesson-linked test data (Module/Lesson structure is changing) ---';
DELETE FROM StudentNote WHERE LessonID IS NOT NULL;
DELETE FROM Bookmark WHERE ItemType = 'Lesson';
DELETE FROM LessonProgress;
DELETE FROM Lesson;
DELETE FROM Module;
GO

-- ---------- Module table (new) ----------
IF OBJECT_ID('dbo.Module', 'U') IS NULL
BEGIN
    CREATE TABLE Module (
        ModuleID      INT IDENTITY(1,1) PRIMARY KEY,
        ModuleTitle   NVARCHAR(150)  NOT NULL,
        Description   NVARCHAR(500)  NULL,
        ModuleOrder   INT            NOT NULL DEFAULT 0,
        IsActive      BIT            NOT NULL DEFAULT 1,
        CreatedDate   DATETIME       NOT NULL DEFAULT GETDATE()
    );
    PRINT '--- Module table created ---';
END
GO

-- ---------- Lesson table: restructure (old ModuleNumber -> ModuleID FK + new fields) ----------
IF COL_LENGTH('dbo.Lesson', 'ModuleNumber') IS NOT NULL
    ALTER TABLE Lesson DROP COLUMN ModuleNumber;
GO
IF COL_LENGTH('dbo.Lesson', 'ModuleID') IS NULL
    ALTER TABLE Lesson ADD ModuleID INT NOT NULL CONSTRAINT FK_Lesson_Module FOREIGN KEY REFERENCES Module(ModuleID);
GO
IF COL_LENGTH('dbo.Lesson', 'ShortDescription') IS NULL
    ALTER TABLE Lesson ADD ShortDescription NVARCHAR(300) NULL;
IF COL_LENGTH('dbo.Lesson', 'LearningObjectives') IS NULL
    ALTER TABLE Lesson ADD LearningObjectives NVARCHAR(MAX) NULL;
IF COL_LENGTH('dbo.Lesson', 'CodeExplanation') IS NULL
    ALTER TABLE Lesson ADD CodeExplanation NVARCHAR(MAX) NULL;
IF COL_LENGTH('dbo.Lesson', 'RealWorldUse') IS NULL
    ALTER TABLE Lesson ADD RealWorldUse NVARCHAR(MAX) NULL;
IF COL_LENGTH('dbo.Lesson', 'CommonMistakes') IS NULL
    ALTER TABLE Lesson ADD CommonMistakes NVARCHAR(MAX) NULL;
IF COL_LENGTH('dbo.Lesson', 'Troubleshooting') IS NULL
    ALTER TABLE Lesson ADD Troubleshooting NVARCHAR(MAX) NULL;
IF COL_LENGTH('dbo.Lesson', 'CodeLanguage') IS NULL
    ALTER TABLE Lesson ADD CodeLanguage NVARCHAR(20) NOT NULL DEFAULT 'CSharp';
IF COL_LENGTH('dbo.Lesson', 'CreatedDate') IS NULL
    ALTER TABLE Lesson ADD CreatedDate DATETIME NOT NULL DEFAULT GETDATE();
GO
PRINT '--- Lesson table restructured with new fields ---';
GO

-- ---------- LessonQuizQuestion (new — lightweight mini-quiz per lesson) ----------
IF OBJECT_ID('dbo.LessonQuizQuestion', 'U') IS NULL
BEGIN
    CREATE TABLE LessonQuizQuestion (
        LessonQuizQuestionID INT IDENTITY(1,1) PRIMARY KEY,
        LessonID        INT NOT NULL FOREIGN KEY REFERENCES Lesson(LessonID) ON DELETE CASCADE,
        QuestionText    NVARCHAR(500) NOT NULL,
        OptionA         NVARCHAR(300) NOT NULL,
        OptionB         NVARCHAR(300) NOT NULL,
        OptionC         NVARCHAR(300) NOT NULL,
        OptionD         NVARCHAR(300) NOT NULL,
        CorrectOption   CHAR(1)       NOT NULL,
        DisplayOrder    INT           NOT NULL DEFAULT 0
    );
    PRINT '--- LessonQuizQuestion table created ---';
END
GO

-- ---------- Challenge: extend with Category + PreventionTip (reusing existing Debug Lab table) ----------
IF COL_LENGTH('dbo.Challenge', 'Category') IS NULL
    ALTER TABLE Challenge ADD Category NVARCHAR(40) NULL;
IF COL_LENGTH('dbo.Challenge', 'PreventionTip') IS NULL
    ALTER TABLE Challenge ADD PreventionTip NVARCHAR(500) NULL;
GO
-- Backfill category on the 3 existing seed challenges so old data stays meaningful
UPDATE Challenge SET Category = 'C# Error' WHERE ChallengeType = 'FindError' AND Category IS NULL;
UPDATE Challenge SET Category = 'C# Error' WHERE ChallengeType = 'CompleteCode' AND Category IS NULL;
UPDATE Challenge SET Category = 'SQL Error' WHERE ChallengeType = 'FixCode' AND Category IS NULL;
PRINT '--- Challenge table extended with Category/PreventionTip ---';
GO

-- ---------- Seed the 5 modules (titles/descriptions per spec) ----------
INSERT INTO Module (ModuleTitle, Description, ModuleOrder, IsActive) VALUES
(N'ASP.NET Web Forms Fundamentals', N'What ASP.NET is, how .aspx pages and code-behind work, the page life cycle, Master Pages, and server vs client processing.', 1, 1),
(N'ASP.NET Controls and Events', N'Every core Web Forms control — Label, TextBox, Button, CheckBox, DropDownList, Calendar, GridView, FileUpload — plus validation controls and event handling.', 2, 1),
(N'Database, SQL and Data Storage', N'How ASP.NET talks to SQL Server: connection strings, ADO.NET, and writing SELECT/INSERT/UPDATE/DELETE queries safely with parameters.', 3, 1),
(N'Database Applications and CRUD', N'Building a complete database-driven Web Forms application: data binding, GridView, and full Create/Read/Update/Delete using the 3-tier architecture.', 4, 1),
(N'Debugging Lab and ASP.NET Project', N'Understanding and fixing common C#, ASP.NET, SQL, connection, Web.config and control/event errors — the CodeFusion Debug Lab.', 5, 1);
GO

PRINT '--- 5 modules seeded ---';
GO

-- =====================================================================
-- MODULE 1 — full lesson content (6 lessons)
-- =====================================================================
DECLARE @Mod1 INT = (SELECT ModuleID FROM Module WHERE ModuleOrder = 1);
INSERT INTO Lesson
    (ModuleID, Title, ShortDescription, LearningObjectives, Explanation, Syntax, CodeExample, CodeExplanation,
     ExpectedOutput, RealWorldUse, CommonMistakes, Troubleshooting, PracticeTask, KeyPoints, CodeLanguage, DisplayOrder, IsPublished)
VALUES
-- Lesson 1
(@Mod1,
 N'Introduction to ASP.NET and Web Forms',
 N'What ASP.NET is, why Web Forms exists, and how a request becomes a web page.',
 N'Explain what ASP.NET is in your own words|Describe the difference between a static HTML page and a dynamic ASP.NET page|Identify the role of IIS/IIS Express in running a Web Forms site|Explain why Web Forms uses a page-and-control model',
 N'ASP.NET is a server-side web framework from Microsoft. "Server-side" means the real work — reading a database, checking who is logged in, deciding what to show — happens on a computer called the server, not inside the visitor''s browser. The browser just displays the finished HTML that the server sends back.

ASP.NET Web Forms is one way of building ASP.NET applications. It was designed to feel familiar to developers who came from desktop application development (like Windows Forms): you drag controls onto a page, double-click a button, and write the code that runs when it''s clicked. Every Web Forms page is really two files working together: an .aspx file that holds the visual layout (similar to HTML), and a .aspx.cs file — called the code-behind — that holds the C# logic.

When someone visits a Web Forms page, here is what actually happens: their browser sends a request to the web server (IIS or, during development, IIS Express). The server finds the matching .aspx page, runs its code-behind, builds a complete HTML page as a result, and sends that HTML back to the browser. The browser never sees your C# code — it only ever receives plain HTML, CSS and JavaScript. This is the core idea of "server-side rendering" that the rest of this module builds on.',
 N'N/A — this lesson is conceptual, not syntax-based.',
 N'// Every Web Forms page has this shape in its code-behind file:
public partial class Default : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        // Code here runs on the server, every time this page is requested.
    }
}',
 N'Line 1: "public partial class Default" declares the class for this page. "partial" means the rest of this class is auto-generated by ASP.NET from the .aspx markup — you only see your half.|Line 1 (continued): ": System.Web.UI.Page" means this class inherits from the built-in Page class, which gives you things like Response, Request, and Session.|Line 3: "Page_Load" is a method ASP.NET calls automatically every time the page is requested — you do not call it yourself.|Line 3 (continued): "object sender, EventArgs e" is the standard signature every page/control event in Web Forms follows.',
 N'Nothing visible changes yet — this lesson has no control on the page. The point is understanding that Page_Load silently runs on the server before any HTML reaches your browser.',
 N'Every real ASP.NET Web Forms site you will ever build — including the rest of CodeFusion itself — follows this exact request-response pattern: browser asks, server runs code, server replies with HTML.',
 N'Thinking the C# code "runs in the browser" like JavaScript does — it never does. It always runs on the server first.|Expecting to see your C# source if you view the page''s source in the browser — you will only ever see the final HTML.',
 N'If a page shows a blank browser tab, check the Visual Studio Output window — the server-side code may have thrown an exception before it could send any HTML back.|If changes to your code-behind don''t seem to appear, make sure you saved the file and that the project rebuilt (check the status bar says "Build succeeded").',
 N'Open any .aspx.cs file in this project (for example Default.aspx.cs) and find its Page_Load method. Write one sentence, in your own words, explaining when that method runs.',
 N'ASP.NET is a server-side framework|The browser only ever receives finished HTML|Every Web Forms page has an .aspx file and a .aspx.cs code-behind file|Page_Load runs automatically on every request',
 N'N/A', 1, 1),

-- Lesson 2
(@Mod1,
 N'ASP.NET Web Forms Project Structure',
 N'A tour of the folders and files that make up a Web Forms Website project, using CodeFusion itself as the example.',
 N'Identify the purpose of App_Code, Web.config, and Global.asax|Explain why App_Code can be referenced from any page without an explicit reference|Locate the connection string in a real project',
 N'A Web Forms "Website" project (the kind CodeFusion is) has a predictable folder layout. Understanding it means you can navigate any ASP.NET Web Forms project confidently, not just this one.

At the root you''ll find Web.config — the single most important configuration file in the project. It holds the database connection string, session settings, and custom error pages. Next to it is Global.asax, which contains application-wide event handlers like Application_Start (runs once when the site first starts) and Session_Start (runs once per new visitor).

The App_Code folder is special: any .cs file placed inside it is automatically compiled and made available to every page in the project, with no manual "Add Reference" step required. This is where CodeFusion keeps its Data Access Layer (DAL), Business Logic Layer (BLL), and Entities — the classes that talk to the database and enforce business rules, kept separate from the pages themselves.

Everywhere else — Student/, Admin/, Practice/ — are just ordinary folders holding .aspx and .aspx.cs page pairs, organized by feature area. There is nothing magic about these folder names; they exist purely to keep related pages together.',
 N'N/A — this lesson is conceptual.',
 N'<!-- Web.config excerpt -->
<connectionStrings>
  <add name="CodeFusionDB"
       connectionString="Server=(localdb)\MSSQLLocalDB;Database=CodeFusionDB;..."
       providerName="System.Data.SqlClient" />
</connectionStrings>',
 N'Line 1: <connectionStrings> is the section every page''s database code reads from indirectly, via ConfigurationManager.|Line 2: The name="CodeFusionDB" attribute is the key your C# code uses to look this connection string up — see DBHelper.cs in App_Code/DAL.|Line 3: The connectionString value tells ADO.NET which server and database to connect to.',
 N'This is configuration, not runtime output — there is nothing to "run" for this lesson.',
 N'Keeping configuration (like the connection string) in one central file means you can move a project from a development database to a production one by editing a single line, without touching any C# code.',
 N'Putting a .cs file with page-specific logic inside App_Code "to make it easier to find" — App_Code is for shared, reusable classes only, not individual page logic.|Hardcoding a connection string inside a page instead of reading it from Web.config.',
 N'If a page can''t find a class from App_Code, make sure the file is actually inside the App_Code folder (not a subfolder named something else) and that its namespace matches what your page''s "using" statement expects.',
 N'Open Web.config in this project and find the connectionStrings section. Write down the value of the "name" attribute — that is the exact string used everywhere in the code to request this connection.',
 N'Web.config holds configuration, not code|Global.asax holds application-wide startup events|App_Code classes are available everywhere automatically|Folders like Student/ and Admin/ are just organizational, not functional', N'ASPX', 2, 1),

-- Lesson 3
(@Mod1,
 N'ASPX Page and Code-Behind',
 N'How the .aspx markup file and its .aspx.cs code-behind file connect to each other.',
 N'Explain the role of the @ Page directive|Explain how a control''s ID in markup connects to code-behind|Write a minimal Label + Button example from scratch',
 N'Every .aspx file starts with a special line called the @ Page directive. It tells ASP.NET which code-behind class this markup belongs to, using the Inherits attribute, and which physical file that class lives in, using the CodeFile attribute. Without a correct, matching @ Page directive, a page simply will not compile.

Inside the markup, any HTML-like tag that includes runat="server" becomes a server control — an object ASP.NET creates on the server and lets your C# code interact with, by its ID. For example, <asp:Label ID="lblMessage" runat="server" /> becomes a field in your code-behind called lblMessage, of type Label, that you can read or write just like any other C# object.

This is the fundamental connection the whole module is building toward: markup declares what controls exist and what they look like; code-behind decides what they say and do. Change the Text property of lblMessage in code, and the actual HTML ASP.NET sends to the browser changes to match.',
 N'<%@ Page Language="C#" CodeFile="PageName.aspx.cs" Inherits="ClassName" %>

<asp:ControlType ID="uniqueId" runat="server" />',
 N'<!-- Default.aspx -->
<asp:Label ID="lblMessage" runat="server" Text="Not set yet" />
<asp:Button ID="btnShow" runat="server" Text="Show Message" OnClick="btnShow_Click" />

// Default.aspx.cs
protected void btnShow_Click(object sender, EventArgs e)
{
    lblMessage.Text = "Hello from code-behind!";
}',
 N'Markup line 1: ID="lblMessage" is how this exact Label is referred to in code-behind — it must be unique on the page.|Markup line 2: OnClick="btnShow_Click" tells ASP.NET which C# method to call when this button is clicked.|Code-behind: "lblMessage.Text = ..." directly changes what the Label will display, using the ID from markup as the variable name.',
 N'Before clicking the button: the label shows "Not set yet". After clicking: the page posts back to the server, btnShow_Click runs, and the label now shows "Hello from code-behind!" — with no full page reload feeling, even though technically a full postback happened.',
 N'This Label + Button pattern — read something, show feedback — is the basis of almost every interactive feature in CodeFusion, from the Arithmetic Lab calculators to the CRUD Lab''s save confirmation.',
 N'Forgetting runat="server" on a control — without it, ASP.NET treats the tag as plain, inert HTML and your code-behind will fail to compile because the field doesn''t exist.|Using two controls with the same ID on one page — ASP.NET will not allow this.|Forgetting to wire OnClick in markup, then wondering why clicking the button "does nothing" even though the method exists in code-behind.',
 N'If code-behind shows an error like "The name ''lblMessage'' does not exist in the current context," check for a missing runat="server" or a typo in the ID.|If clicking a button seems to do nothing, confirm OnClick="methodName" is actually present on the <asp:Button> tag.',
 N'Add a new Label and Button pair to a scratch page (or read Practice/ControlsLab.aspx for a working example already in this project) and make clicking the button change the Label''s text to your own name.',
 N'@ Page directive connects markup to its code-behind class|runat="server" turns an HTML-like tag into a usable server control|A control''s ID becomes its variable name in code-behind|Changing a control''s property in code changes the HTML sent to the browser', N'ASPX', 3, 1),

-- Lesson 4
(@Mod1,
 N'Page Life Cycle and Page Events',
 N'The sequence of events ASP.NET fires for every single page request, and why IsPostBack matters so much.',
 N'List the main page life cycle events in order|Explain the difference between the first load of a page and a postback|Correctly use if (!IsPostBack) to avoid repeating setup logic',
 N'Every time a Web Forms page is requested, ASP.NET runs through a fixed sequence of events, in the same order, every single time. The ones you will use constantly are: Page_Init (controls are created but not yet usable), Page_Load (the page and its controls are fully ready — this is where almost all your code goes), control event handlers like a Button''s Click (fired after Page_Load, if this request was caused by that control), and Page_PreRender (your last chance to change anything before ASP.NET converts the page into HTML).

The single most important concept in this lesson is the difference between the first time a page loads and every subsequent postback. A "postback" happens whenever the same page submits itself back to the server — clicking a Button, for instance. Page_Load runs on both the first visit and every postback. If you put code in Page_Load that, say, loads a dropdown list''s options from the database, and you don''t guard it, that dropdown gets reloaded and reset on every single click of every single button on the page — wiping out whatever the user had selected.

The fix is the IsPostBack property. if (!IsPostBack) { ... } means "only run this code the very first time the page loads, never again on a postback." You will see this exact pattern in nearly every page of this project.',
 N'protected void Page_Load(object sender, EventArgs e)
{
    if (!IsPostBack)
    {
        // Runs only on first load
    }
}',
 N'protected void Page_Load(object sender, EventArgs e)
{
    if (!IsPostBack)
    {
        ddlCountry.DataSource = GetCountries();
        ddlCountry.DataBind();
    }
}

protected void btnSubmit_Click(object sender, EventArgs e)
{
    lblResult.Text = "You chose: " + ddlCountry.SelectedValue;
}',
 N'Line 3: "if (!IsPostBack)" checks whether this request is the page''s very first load.|Line 5-6: The dropdown is only filled with data on that first load — never again.|btnSubmit_Click: This runs after Page_Load on every click, and correctly reads whatever the user had selected, because the dropdown was never reset.',
 N'First visit: the dropdown fills with countries. User selects one and clicks Submit: Page_Load runs again (but skips the dropdown-filling code because IsPostBack is now true), then btnSubmit_Click runs and shows the correct selection.',
 N'Every dropdown, every GridView, and every form on CodeFusion that needs to "remember" what a user picked relies on this exact IsPostBack pattern — including the CRUD Lab and DropDownList Lab you''ll use later in this course.',
 N'Forgetting the IsPostBack check entirely, which silently resets dropdowns and other data-bound controls on every single postback.|Putting the IsPostBack check around code that should actually run every time, like updating a results Label.',
 N'If a dropdown always jumps back to its first option after you click a button, that''s almost always a missing IsPostBack check.|If a Label never updates after clicking a button, check that the button''s click handler logic is not accidentally wrapped inside if (!IsPostBack) as well — it should not be.',
 N'Open Practice/DropDownLab.aspx.cs in this project and find where IsPostBack is checked. Explain in one sentence why the cascading Country/State/City dropdowns would break without it.',
 N'Page_Load fires on every single request, first load and postback alike|IsPostBack tells you whether this is the first load or a postback|Use if (!IsPostBack) to run setup code only once|Control event handlers (like Click) run after Page_Load', N'CSharp', 4, 1),

-- Lesson 5
(@Mod1,
 N'Master Pages and Site Navigation',
 N'How one shared layout (header, nav, footer) gets reused across every page on the site.',
 N'Explain the relationship between a .Master file and the pages that use it|Identify a ContentPlaceHolder and explain its purpose|Locate CodeFusion''s own Site.Master file',
 N'Without Master Pages, you would have to copy-paste your navigation bar, logo, and footer into every single .aspx file — and if you ever wanted to change the logo, you''d need to edit every page by hand. A Master Page solves this: it''s a single .Master file that defines the shared layout once, with one or more ContentPlaceHolder controls marking the spots where each individual page''s unique content should go.

Every content page then declares MasterPageFile="~/Site.Master" in its own @ Page directive, and wraps its unique markup inside an <asp:Content> tag that targets a specific ContentPlaceHolder by ID. ASP.NET combines the two automatically at runtime: the Master Page''s shared HTML, with each page''s own content slotted into the right place.

CodeFusion itself uses exactly this pattern. Site.Master contains the top navigation bar, the logo, and the footer — look at nearly any student-facing page in this project and you''ll see MasterPageFile="~/Site.Master" in its @ Page directive. The Admin section even has its own separate master page, Admin/Admin.Master, with different navigation links appropriate for administrators.',
 N'<%@ Page MasterPageFile="~/Site.Master" ... %>
<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <!-- this page''s unique content -->
</asp:Content>',
 N'<!-- Inside Site.Master -->
<asp:ContentPlaceHolder ID="MainContent" runat="server" />

<!-- Inside Default.aspx -->
<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <h1>Welcome to CodeFusion</h1>
</asp:Content>',
 N'Master Page line: <asp:ContentPlaceHolder ID="MainContent" .../> marks exactly where page-specific content will be inserted.|Content page line: ContentPlaceHolderID="MainContent" must match that ID exactly, or ASP.NET won''t know where this content belongs.|The <h1> inside the Content tag is the only part that changes from page to page — everything else (nav, footer) comes from the Master Page automatically.',
 N'The browser receives one single, combined HTML page: Site.Master''s navigation and footer, wrapping around Default.aspx''s own "Welcome to CodeFusion" heading, as if it had all been written in one file.',
 N'Every page you have clicked through in this entire CodeFusion project — Dashboard, Roadmap, Practice Lab, Quiz Arena — shares the exact same header and footer purely because they all point at the same Site.Master file.',
 N'Spelling ContentPlaceHolderID differently than the Master Page''s actual ContentPlaceHolder ID (even a capitalization mismatch can cause issues).|Forgetting MasterPageFile in a new page''s @ Page directive, resulting in a page with no shared navigation at all.',
 N'If a new page looks "naked" with no navigation bar, check its @ Page directive for a missing or misspelled MasterPageFile attribute.|If you get a parser error mentioning ContentPlaceHolder, double-check the ID in your <asp:Content> tag matches one that actually exists in the Master Page.',
 N'Open Site.Master in this project and find its ContentPlaceHolder ID. Then open any student-facing .aspx page and confirm its <asp:Content> tag targets that same ID.',
 N'A Master Page defines shared layout once|ContentPlaceHolder marks where page-specific content is inserted|Content pages reference the Master Page via MasterPageFile|CodeFusion uses separate Master Pages for students and admins', N'ASPX', 5, 1),

-- Lesson 6
(@Mod1,
 N'Server-Side vs Client-Side Processing',
 N'Where your code actually runs — and why that matters for security, performance, and what the user sees.',
 N'Classify a given task as server-side or client-side|Explain why server-side validation is still required even when client-side validation exists|Describe what a "postback" costs in terms of performance',
 N'"Server-side" means code that runs on the web server — your C# code-behind, your SQL queries, your business logic in the BLL. The visitor''s browser never sees this code; it only ever receives the finished HTML result. "Client-side" means code that runs inside the visitor''s own browser — plain JavaScript, and the lightweight JavaScript that ASP.NET''s validator controls automatically generate for instant, no-reload feedback.

Here is the critical security lesson: client-side code can always be bypassed. A user can disable JavaScript, or use browser developer tools to submit a request directly, skipping your client-side validation entirely. This is exactly why every validator in this project — RequiredFieldValidator, RegularExpressionValidator, and so on — automatically also re-runs its check on the server, and why your code-behind should always check Page.IsValid before acting on submitted data, even though the same validators already ran instantly in the browser.

There is also a performance angle. Every postback — every Button click, every AutoPostBack dropdown — sends a request all the way to the server and back, which takes time and bandwidth. Small, purely cosmetic interactions (like showing/hiding a tooltip) are usually better handled with plain client-side JavaScript, reserving postbacks for things that genuinely need the server, like saving to a database.',
 N'N/A — this lesson is conceptual.',
 N'<!-- Client-side validation happens instantly in the browser -->
<asp:RequiredFieldValidator ControlToValidate="txtEmail" runat="server" ErrorMessage="Required" />

// But code-behind must check it again on the server:
protected void btnSubmit_Click(object sender, EventArgs e)
{
    if (!Page.IsValid) return; // never trust the client alone
    // ... safe to proceed
}',
 N'Markup line: This validator generates JavaScript automatically, so the browser shows an error instantly, with no round trip to the server.|Code-behind line 1: "if (!Page.IsValid) return;" re-checks every validator''s result on the server — this is what actually protects your data.|Code-behind line 2: Only code after this check should ever touch the database or BLL, because only then do you know the submitted data is genuinely valid.',
 N'With JavaScript enabled: leaving Email empty and clicking Submit shows an instant red error, with no page reload. With JavaScript disabled (simulating a bypass attempt): the page posts back to the server, and Page.IsValid correctly still catches the problem there.',
 N'Every form in CodeFusion that uses validators — Register, the CRUD Lab, the Validation Lab — relies on this exact client-plus-server pairing: instant feedback for honest users, real protection against anyone who bypasses the browser.',
 N'Trusting client-side (JavaScript) validation alone and skipping the Page.IsValid check in code-behind — this is a real security hole, not just a style preference.|Assuming disabling a Submit button in JavaScript actually prevents the form from being submitted some other way — it does not.',
 N'If invalid data somehow makes it into the database despite having validators on the form, the almost-certain cause is a missing "if (!Page.IsValid) return;" at the top of the Click handler.|If validators don''t show any error messages at all, confirm a ValidationSummary or individual validator Display property is actually set to show something.',
 N'Open Practice/ValidationLab.aspx.cs in this project and find the line that checks Page.IsValid. Explain, in your own words, what would happen if that single line were deleted.',
 N'Server-side code is never visible to the browser|Client-side JavaScript can always be bypassed|Always re-check Page.IsValid on the server, even with client-side validators present|Postbacks cost a round trip to the server — use them only when genuinely needed', N'CSharp', 6, 1);

PRINT '--- Module 1: 6 lessons inserted ---';
GO

-- ---------- Mini quiz questions (3-5 per lesson, Module 1 only) ----------
DECLARE @L1 INT = (SELECT LessonID FROM Lesson WHERE Title = N'Introduction to ASP.NET and Web Forms');
DECLARE @L2 INT = (SELECT LessonID FROM Lesson WHERE Title = N'ASP.NET Web Forms Project Structure');
DECLARE @L3 INT = (SELECT LessonID FROM Lesson WHERE Title = N'ASPX Page and Code-Behind');
DECLARE @L4 INT = (SELECT LessonID FROM Lesson WHERE Title = N'Page Life Cycle and Page Events');
DECLARE @L5 INT = (SELECT LessonID FROM Lesson WHERE Title = N'Master Pages and Site Navigation');
DECLARE @L6 INT = (SELECT LessonID FROM Lesson WHERE Title = N'Server-Side vs Client-Side Processing');

INSERT INTO LessonQuizQuestion (LessonID, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, DisplayOrder) VALUES
(@L1, N'Where does ASP.NET C# code actually execute?', N'In the browser', N'On the web server', N'In the database', N'In Visual Studio only', 'B', 1),
(@L1, N'What does the browser receive from an ASP.NET page?', N'Raw C# source code', N'Compiled .dll files', N'Finished HTML', N'The .aspx file directly', 'C', 2),
(@L1, N'Which file holds the C# logic for a Web Forms page?', N'The .aspx file', N'The .aspx.cs code-behind file', N'Web.config', N'Global.asax', 'B', 3),

(@L2, N'Which file holds the database connection string?', N'Global.asax', N'Web.config', N'Site.Master', N'Default.aspx', 'B', 1),
(@L2, N'What is special about the App_Code folder?', N'It only holds images', N'Its classes are available to every page automatically', N'It requires a separate project reference', N'It is only used by the Admin panel', 'B', 2),
(@L2, N'Which event in Global.asax runs once per new visitor?', N'Application_Start', N'Page_Load', N'Session_Start', N'Server_Init', 'C', 3),

(@L3, N'What makes an HTML-like tag into a usable server control?', N'Giving it a class attribute', N'Adding runat="server"', N'Putting it inside a <div>', N'Naming it in lowercase', 'B', 1),
(@L3, N'In <asp:Label ID="lblMsg" runat="server" />, what does "lblMsg" become in code-behind?', N'A CSS class', N'A JavaScript function', N'A C# field/variable name', N'A database column', 'C', 2),
(@L3, N'What attribute of the @ Page directive names the code-behind class?', N'CodeFile', N'Inherits', N'MasterPageFile', N'Language', 'B', 3),

(@L4, N'What does IsPostBack tell you?', N'Whether the database connection succeeded', N'Whether this is the first load or a later postback', N'Whether a validator passed', N'Whether the user is an admin', 'B', 1),
(@L4, N'Why wrap dropdown-filling code in if (!IsPostBack)?', N'To make the page load faster only', N'To avoid resetting the dropdown''s selection on every postback', N'Because it is required syntax', N'To hide the dropdown from guests', 'B', 2),
(@L4, N'Which event fires first in the page life cycle?', N'Page_PreRender', N'A button''s Click event', N'Page_Load', N'Page_Unload', 'C', 3),

(@L5, N'What does a ContentPlaceHolder mark?', N'A place where CSS is loaded', N'Where a content page''s unique markup gets inserted', N'A database table', N'A JavaScript function', N'B', 1),
(@L5, N'Which attribute connects a content page to its Master Page?', N'Inherits', N'CodeFile', N'MasterPageFile', N'ContentPlaceHolderID', 'C', 2),
(@L5, N'Why use a Master Page instead of copy-pasting navigation into every file?', N'It is required by IIS', N'So shared layout only needs to be edited in one place', N'It makes pages load without a server', N'It replaces the need for CSS', 'B', 3),

(@L6, N'Why can client-side validation always be bypassed?', N'It only runs on Tuesdays', N'JavaScript can be disabled or requests sent directly', N'It is not real code', N'It only checks spelling', 'B', 1),
(@L6, N'What should code-behind check before acting on submitted form data?', N'Request.Browser', N'Page.IsValid', N'Session.Timeout', N'Server.MachineName', 'B', 2),
(@L6, N'What is a "postback"?', N'A database backup', N'The page submitting itself back to the server', N'A type of validator', N'An error message', 'B', 3);

PRINT '--- Module 1: mini quiz questions inserted ---';
GO

-- ---------- Verification ----------
DECLARE @VerificationMod1 INT;

SELECT @VerificationMod1 = ModuleID
FROM Module
WHERE ModuleOrder = 1;

SELECT
    (SELECT COUNT(*) FROM Module) AS ModuleCount,
    (SELECT COUNT(*) FROM Lesson) AS LessonCount,
    (SELECT COUNT(*) FROM Lesson WHERE ModuleID = @VerificationMod1) AS Module1LessonCount,
    (SELECT COUNT(*) FROM LessonQuizQuestion) AS MiniQuizQuestionCount,
    (SELECT COUNT(*)
     FROM INFORMATION_SCHEMA.COLUMNS
     WHERE TABLE_NAME = 'Challenge'
       AND COLUMN_NAME IN ('Category','PreventionTip')) AS ChallengeNewColumns;
GO