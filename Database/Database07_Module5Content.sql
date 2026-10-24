/* =====================================================================
   CodeFusion — Module 5 content: Debugging Lab and ASP.NET Project
   7 lessons + 21 mini-quiz questions + 12 Debug Lab challenges.
   Run this ONCE against your existing CodeFusionDB.
   ===================================================================== */
USE CodeFusionDB;
GO
SET NOCOUNT ON;

DECLARE @Mod5 INT = (SELECT ModuleID FROM Module WHERE ModuleOrder = 5);

INSERT INTO Lesson
    (ModuleID, Title, ShortDescription, LearningObjectives, Explanation, Syntax, CodeExample, CodeExplanation,
     ExpectedOutput, RealWorldUse, CommonMistakes, Troubleshooting, PracticeTask, KeyPoints, CodeLanguage, DisplayOrder, IsPublished)
VALUES
-- Lesson 27
(@Mod5,
 N'Understanding Common C# Errors',
 N'Telling compile errors, runtime exceptions and logic errors apart, and reading the message each one gives you.',
 N'Explain the difference between compile-time, runtime and logic errors|Read an error code, message and line number in the Visual Studio Error List|Recognise and fix a missing semicolon, a FormatException and a NullReferenceException',
 N'Every programmer meets errors daily, and the skill that separates beginners from confident developers is not avoiding errors but reading them. C# errors fall into three families.

A compile-time error is found by the compiler before the program runs. The build fails and Visual Studio lists each problem in the Error List with a code such as CS1002, a description, the file and the line number. Typical causes are a missing semicolon, a misspelt name, or assigning a value of the wrong type. Every compile-time error must be fixed before the site will run.

A runtime error, called an exception, happens while the program is running. The code compiled, but something went wrong when it executed: converting text that is not a number, using a value that is null, or reading past the end of a list. ASP.NET shows a yellow error page, or Visual Studio stops on the failing line and shows the exception type and message.

A logic error produces no message at all. The code runs but gives the wrong answer, for example using + instead of -. These are found by testing with known values and by stepping through the code with breakpoints.

To read an error, start with the exception type or error code, then the message, then the line number. The reported line is where the problem was detected, and the real mistake can be just above it; a missing semicolon is often reported on the following line. The most common ones are: CS1002 (semicolon expected), CS0103 (the name does not exist in the current context, caused by a typo, an undeclared variable or a control without runat=server), CS0029 (cannot implicitly convert one type to another, for example string to int), NullReferenceException (a variable that is null was used), FormatException (text could not be parsed as a number) and IndexOutOfRangeException (an index beyond the end of a list, or a column name that is not in the result).',
 N'Exception type: message -- at File.aspx.cs: line N
Compile error: CS#### description (File, Line)',
 N'// 1. Compile error CS1002: semicolon expected
string name = txtName.Text      // missing semicolon

// 2. Runtime error: FormatException when the text is not a number
int age = int.Parse("abc");

// Safer version
int age;
if (!int.TryParse(txtAge.Text, out age))
{
    lblMessage.Text = "Please enter a whole number.";
    return;
}

// 3. Runtime error: NullReferenceException when the session is empty
string studentName = Session["StudentName"].ToString();

// Safer version
object value = Session["StudentName"];
string studentName = (value == null) ? "Guest" : value.ToString();',
 N'Case 1: the compiler stops the build because the statement has no semicolon; add the semicolon and the error disappears.|Case 2: int.Parse throws a FormatException for text such as abc because it cannot become a number.|The safer version uses int.TryParse, which returns false instead of throwing, so the page can show a friendly message.|Case 3: Session["StudentName"] is null when nobody has logged in, and calling ToString on null throws a NullReferenceException.|The safer version checks for null first and uses a default value.',
 N'The compile error appears in the Error List before the site runs. The two runtime examples throw exceptions only when executed with bad input, and the safer versions instead show a message or a default value and the page keeps working.',
 N'Real applications must cope with unexpected input every day: empty boxes, text where numbers were expected, expired sessions. CodeFusion uses TryParse, null checks and friendly error pages so users never see a crash.',
 N'Reading only the last line of an error and ignoring the exception type and message, which carry the real clue.|Fixing the reported line when the actual mistake is on the line above it.',
 N'If the Error List shows many errors, fix the first one and rebuild; one mistake such as a missing brace can cause a long list of follow-on errors.|If you get NullReferenceException, find which variable on that line could be null and decide whether it needs a check or a value.',
 N'Open the Debug Lab in CodeFusion and attempt the first C# Error challenge. Before revealing the solution, write down which of the three error families it belongs to.',
 N'Compile-time errors stop the build; runtime errors are exceptions; logic errors give wrong answers silently|Read the error type, then the message, then the line number|The real mistake can be on the line before the reported one|Use TryParse and null checks to handle bad input gracefully', N'CSharp', 1, 1),

-- Lesson 28
(@Mod5,
 N'Understanding ASP.NET Web Forms Errors',
 N'Reading the yellow error page, and fixing the markup and page-structure errors that are specific to Web Forms.',
 N'Identify the parts of the ASP.NET error page|Fix a ContentPlaceHolder mismatch and a control that is missing runat=server|Explain how to view full error details while developing',
 N'Web Forms adds its own kinds of errors on top of ordinary C# errors, because a page is made of markup plus code-behind that must agree with each other. When something is wrong, ASP.NET shows the yellow error page, which has a fixed layout: a title with the error type, a short description, the exception details, the source error with the failing line highlighted, the source file and line number, and the stack trace listing the methods that were running. Read from the top: the title and details tell you what, and the highlighted source tells you where.

Parser errors come from the markup. They appear when the .aspx file itself cannot be understood: a misspelt attribute, an unknown tag, a ContentPlaceHolderID that does not exist in the master page, or an Inherits value that does not match the class name in code-behind.

Compile errors in code-behind often mean the markup and the code disagree. The classic example: your code uses lblMessage, but in the markup the element has no runat="server", so ASP.NET treats it as plain HTML, no field is created, and the compiler reports that the name does not exist in the current context. Other common mistakes are two controls with the same ID, a server control placed outside the form tag, and a method named in OnClick that does not exist.

While developing, the friendly error page can hide these messages. Web.config contains customErrors mode="On", which shows visitors a safe page. On your own machine you can temporarily switch it to Off (or RemoteOnly) to see the full details, then switch it back before sharing the site. Never leave detailed errors visible on a live site, because they can reveal file paths and code.',
 N'<asp:Content ContentPlaceHolderID="IdThatExistsInTheMasterPage" runat="server">
<asp:Label ID="uniqueId" runat="server" />',
 N'<!-- Parser error: Cannot find ContentPlaceHolder ''MainContents'' in the master page -->
<asp:Content ID="Content2" ContentPlaceHolderID="MainContents" runat="server">

<!-- Fixed: matches the ID in Site.Master -->
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

<!-- Code-behind cannot find the control -->
<span id="lblMsg">Hello</span>
lblMsg.Text = "Done";          // CS0103: the name does not exist in the current context

<!-- Fixed: add runat="server" and use a server control -->
<asp:Label ID="lblMsg" runat="server" Text="Hello" />',
 N'The first Content tag names a placeholder that the master page does not have, so ASP.NET cannot decide where to put the content and reports a parser error.|The fix is to copy the exact ID from the ContentPlaceHolder in Site.Master.|The span has an id but no runat="server", so it is plain HTML and no lblMsg field exists for the code-behind.|The compiler therefore reports CS0103 on the line that uses lblMsg.|Replacing it with an asp:Label that has runat="server" creates the field and the code compiles.',
 N'Before the fixes, the page shows a yellow parser or compile error that names the problem and the line. After the fixes, the page loads normally and the label text can be changed from code-behind.',
 N'When you add a new page to CodeFusion and see a parser error, it is almost always one of these: a wrong placeholder ID, a missing runat="server", or an Inherits value that differs from the class name.',
 N'Forgetting runat="server" on a control that code-behind needs.|Copying a page and forgetting to rename the class in both the Inherits attribute and the code-behind file.',
 N'If you see Cannot find ContentPlaceHolder, compare the ID in your Content tag with the one in the master page, character by character.|If you see Could not load type, the Inherits value does not match the class name in the code-behind file.|If you see a message that a control must be placed inside a form tag with runat=server, move the control inside the form of the master page.',
 N'Deliberately change the ContentPlaceHolderID on a scratch page, load it, and read the error page. Identify the title, the highlighted source line and the file name, then fix it.',
 N'The yellow error page shows the error type, the failing line and the stack trace|Parser errors come from markup; compile errors come from code that disagrees with the markup|A control used in code-behind needs runat="server"|Turn detailed errors on only while developing', N'ASPX', 2, 1),

-- Lesson 29
(@Mod5,
 N'SQL Query Errors',
 N'Reading the messages SQL Server returns for a bad query, and fixing the most common ones.',
 N'Recognise the messages for a wrong column, wrong table, syntax error and missing parameter|Explain what a constraint violation message means|Fix a query that joins user input into the SQL text',
 N'When a query is wrong, SQL Server refuses to run it and returns a message that ADO.NET raises as a SqlException. The message is usually very specific, so read it carefully before changing anything.

Invalid column name: the column you named is not in the table, often a spelling mistake. Check the real names in SQL Server Object Explorer. Invalid object name: the table (or view) does not exist in the database you are connected to, either because of a spelling mistake such as Students instead of Student, or because you are connected to the wrong database. Incorrect syntax near: the SQL itself is malformed, such as an extra comma before FROM, a missing keyword or an unclosed bracket; the word named in the message is where SQL Server got confused, so the mistake is at or just before it.

Must declare the scalar variable: the SQL uses a parameter such as @Id but the C# code never added it with cmd.Parameters. Conversion failed: a value could not be turned into the column type, for example text where a number is required. String or binary data would be truncated: the value is longer than the column allows.

Constraint errors protect your data. Violation of UNIQUE KEY constraint means you tried to insert a value that already exists in a unique column, such as a duplicate email. The INSERT statement conflicted with the FOREIGN KEY constraint means the ID you supplied does not exist in the parent table.

Finally, the most serious SQL mistake is not an error message at all: building the query by joining user input into the text, as in "... WHERE Email = " + email. It may work in testing, but it allows SQL injection. Always use parameters.',
 N'SELECT columns FROM Table WHERE column = @Parameter;',
 N'-- Invalid column name ''FullNme''
SELECT FullNme FROM Student;
-- Fixed
SELECT FullName FROM Student;

-- Invalid object name ''Students''
SELECT * FROM Students;
-- Fixed
SELECT * FROM Student;

-- Incorrect syntax near the keyword ''FROM'' (extra comma)
SELECT FullName, FROM Student;
-- Fixed
SELECT FullName FROM Student;

// Unsafe: user input joined into the SQL text
SqlCommand cmd = new SqlCommand("SELECT * FROM Student WHERE Email = " + email, con);

// Safe: a parameter
SqlCommand cmd = new SqlCommand("SELECT * FROM Student WHERE Email = @Email", con);
cmd.Parameters.AddWithValue("@Email", email);',
 N'FullNme does not exist, so SQL Server reports Invalid column name; the fix is the correct spelling FullName.|Students does not exist because the table is called Student, so SQL Server reports Invalid object name.|The comma before FROM promises another column that never arrives, so SQL Server reports incorrect syntax near FROM.|The unsafe C# line puts the value straight into the SQL text, which is both a bug waiting to happen and a security hole.|The safe version uses the @Email placeholder and sends the value separately with AddWithValue.',
 N'Each broken statement fails with a clear SqlException message. The fixed statements return the expected rows, and the parameterised C# version works for any email, including one containing an apostrophe.',
 N'Almost every database-driven page eventually shows one of these messages while it is being built. Reading them correctly turns a long guessing session into a one-minute fix, and CodeFusion hides them from users behind a friendly error page.',
 N'Guessing at the cause instead of reading the exact message.|Joining user input into the SQL text because it seems to work in a quick test.',
 N'If you see Invalid column name or Invalid object name, open SQL Server Object Explorer and compare the names with the real table.|If you see Must declare the scalar variable, make sure every @name in the SQL has a matching cmd.Parameters.AddWithValue in the C# code.|If you see a UNIQUE KEY violation, check whether that value already exists in the table.',
 N'Open SQL Server Object Explorer, create a new query and run each broken statement above. Match every error message with its cause, then run the corrected version.',
 N'SQL Server messages are specific, so read them before changing code|Invalid column and invalid object names are usually spelling or wrong-database problems|Constraint messages protect your data|Always use parameters, never join user input into SQL', N'SQL', 3, 1),

-- Lesson 30
(@Mod5,
 N'Database Connection Errors',
 N'Why an application cannot reach its database, and how to tell a connection problem from a query problem.',
 N'Distinguish a connection error from a query error|Fix a connection that was never opened and a missing connection string name|Explain what Cannot open database requested by the login means',
 N'A connection error means the application never reached the database at all, so the SQL was never even tried. Recognising this saves a lot of time, because the fix is in the connection, not in the query.

Cannot open database requested by the login: SQL Server was reached, but the database named in the connection string does not exist on that server, or your account may not open it. The usual cause is that the database scripts were not run, or were run against a different server instance. A network-related or instance-specific error: SQL Server or LocalDB itself could not be found, because it is not running or the Server value is misspelt. Login failed for user: the credentials or Windows account were rejected.

Some connection problems come from the C# code rather than the settings. ExecuteScalar (or ExecuteReader, or ExecuteNonQuery) requires an open and available Connection means you created the command but forgot con.Open(). A NullReferenceException on the line that reads ConfigurationManager.ConnectionStrings["Name"] means that name does not exist in Web.config, because the key in the code and the name in the file differ.

A useful method is to test the connection on its own: open SQL Server Object Explorer, expand the server named in the connection string and check that the database and its tables are there. If you can see them there, compare the Server and Database values in Web.config with what you see. If your machine has more than one LocalDB instance, make sure the scripts and the connection string use the same one.

Remember also that connections must be closed. Always create them in using blocks so they are released even when an error occurs; leaked connections eventually make a site slow or unresponsive.',
 N'Server=(localdb)\MSSQLLocalDB;Database=CodeFusionDB;Trusted_Connection=True;',
 N'// Error: ExecuteScalar requires an open and available Connection
using (SqlConnection con = DBHelper.GetConnection())
using (SqlCommand cmd = new SqlCommand("SELECT COUNT(*) FROM Student", con))
{
    int total = Convert.ToInt32(cmd.ExecuteScalar());   // con.Open() was forgotten
}

// Fixed
using (SqlConnection con = DBHelper.GetConnection())
using (SqlCommand cmd = new SqlCommand("SELECT COUNT(*) FROM Student", con))
{
    con.Open();
    int total = Convert.ToInt32(cmd.ExecuteScalar());
}

// Error: NullReferenceException - the name does not exist in Web.config
string cs = ConfigurationManager.ConnectionStrings["CodeFusion"].ConnectionString;

// Fixed: use the exact name from Web.config
string cs = ConfigurationManager.ConnectionStrings["CodeFusionDB"].ConnectionString;',
 N'The first block creates the connection and command but never opens the connection, so executing the command fails with the open-connection message.|The fix is a single con.Open() call just before executing.|The using blocks make sure the connection is closed afterwards, even if an error happens.|ConnectionStrings["CodeFusion"] returns null because Web.config names the setting CodeFusionDB, so reading .ConnectionString on null throws.|Using the exact name from Web.config fixes it.',
 N'Before the fixes, the first block throws an InvalidOperationException about the connection and the second throws a NullReferenceException. After the fixes the count is returned and the connection string is found.',
 N'When you move CodeFusion to another computer, the most common first problem is a connection error: a different server instance name, or a database that has not been created yet. Knowing the three messages above lets you fix it in minutes.',
 N'Fixing the SQL when the real problem is that the database cannot be reached.|Having two LocalDB instances and running the database scripts against the one that is not named in Web.config.',
 N'If you see Cannot open database, confirm in SQL Server Object Explorer that the database exists on the same server named in Web.config.|If you see a network-related or instance-specific error, check that the Server value is spelt correctly and that SQL Server or LocalDB is available.|If you see a NullReferenceException on ConnectionStrings, compare the name in the code with the name attribute in Web.config.',
 N'Open Web.config, write down the Server and Database values, then find the same server and database in SQL Server Object Explorer and confirm that the Student table is there and contains rows.',
 N'A connection error means the database was never reached|Cannot open database usually means the database or server instance is wrong|Always call con.Open() before executing a command|The name used in code must match the name in Web.config exactly', N'CSharp', 4, 1),

-- Lesson 31
(@Mod5,
 N'Web.config and Configuration Errors',
 N'How a small mistake in the configuration file can stop the whole site, and how to read the error it gives.',
 N'Explain why Web.config must be well-formed XML|Recognise the error caused by a setting in the wrong Web.config|Use customErrors and debug settings sensibly',
 N'Web.config is an XML file, and XML is strict. Every opening tag must be closed, every attribute value must be in quotes, and tags must be nested correctly. A single missing slash can make the whole application fail, not just one page, because ASP.NET reads Web.config before it runs anything. The error page is a Configuration Error and names the line number inside Web.config, so go straight to that line and look at the line above it too.

Typical XML mistakes are an add element that is not closed with a slash, a missing quotation mark, a section that is not properly closed, or text pasted in from a web page with curly quotation marks instead of straight ones.

Some settings may only appear in the Web.config at the root of the application. If you place a setting such as sessionState inside a Web.config in a subfolder, ASP.NET reports that it is an error to use a section registered as allowDefinition=MachineToApplication beyond application level. The fix is to remove it from the subfolder file and keep it only in the root. This also happens when Visual Studio opens a folder one level too high or too low, so that the real Web.config is not at the root of the site.

Two settings are worth understanding. compilation debug should be true while developing, so Visual Studio can step through your code, and false when the site is published, because debug mode is slower. customErrors controls what visitors see: On shows the friendly error page and hides details, Off shows full details, and RemoteOnly shows details only on the local machine. Use On for anything other than your own development, so file paths and code are never exposed.',
 N'<configuration>
  <connectionStrings> ... </connectionStrings>
  <system.web>
    <compilation debug="true" />
    <customErrors mode="On" />
  </system.web>
</configuration>',
 N'<!-- Malformed XML: the add tag is not closed -->
<appSettings>
  <add key="MaterialsUploadPath" value="~/Uploads/Materials/" >
</appSettings>

<!-- Fixed: self-closing add element -->
<appSettings>
  <add key="MaterialsUploadPath" value="~/Uploads/Materials/" />
</appSettings>

<!-- Wrong: sessionState inside Admin/Web.config (a subfolder) -->
<system.web>
  <sessionState mode="InProc" timeout="60" />
</system.web>

<!-- Fix: delete it from the subfolder file and keep it only in the root Web.config -->',
 N'The first add tag lacks the closing slash, so the XML is malformed and ASP.NET cannot even start the site.|Adding the slash before the closing angle bracket makes the element self-closing and the file valid again.|The sessionState section may only be defined at the application root, so placing it in a subfolder Web.config triggers the beyond application level error.|The fix is to keep a single sessionState setting in the root Web.config and remove the copy from the subfolder.',
 N'With the malformed tag, every page shows a Configuration Error naming the line in Web.config. After the fix the site starts normally. The subfolder error disappears once the setting is removed from the subfolder file.',
 N'Web.config problems appear right after copying a project, editing settings by hand, or opening a project at the wrong folder level. Knowing that these errors name a line in Web.config tells you to look there first.',
 N'Editing Web.config and forgetting to close a tag or a quotation mark.|Leaving customErrors Off or debug set to true when the site is shown to other people.',
 N'If every page fails with a Configuration Error, open Web.config at the line shown in the message and check the tags and quotation marks.|If you see the allowDefinition=MachineToApplication message, look for a second Web.config in a subfolder, or check you opened the website at the correct folder level.|If you cannot see the real error because the friendly page appears, temporarily set customErrors to Off on your own machine only.',
 N'Make a copy of Web.config, deliberately remove the slash from one add element, load the site and read the error, then restore the copy.',
 N'Web.config is strict XML; one unclosed tag stops the whole site|Some sections may only appear in the root Web.config|debug is for development and customErrors protects visitors|Always keep a backup before editing Web.config', N'ASPX', 5, 1),

-- Lesson 32
(@Mod5,
 N'Control and Event Handling Errors',
 N'Why a button does nothing, a dropdown resets, or a control cannot be found, and how to fix each.',
 N'Diagnose a button that does nothing and a dropdown that resets|Explain why a ListItem cannot contain a data-binding expression|Find a control inside a Repeater with FindControl',
 N'Some of the most frustrating errors produce no error message at all. The page loads, but a control does not behave as expected. These problems almost always come from how events and the page life cycle work together.

A button that does nothing usually has no OnClick attribute, or the OnClick names a method that does not exist or is spelt differently. If the name is wrong ASP.NET reports an error at build time; if the attribute is missing the click only causes a postback and nothing else happens. A handler must have the standard signature: protected void Name(object sender, EventArgs e).

A dropdown that jumps back to its first item, or a list that loses what the user selected, is the IsPostBack problem from Module 1: the code fills the control on every request instead of only on the first one. Wrap the filling code in if (!IsPostBack).

A validation problem can also stop a click: if a validator fails, the click handler runs only if you check Page.IsValid; a Cancel button should use CausesValidation="false" so that it is not blocked by validators.

Data-bound templates have their own restrictions. A ListItem is not a full control, so you cannot write a binding expression such as Text=<%# Eval("OptionA") %> inside it; ASP.NET reports that ListItem does not have a DataBinding event. Instead, leave the list empty in the markup and add the items in code, normally in the Repeater''s ItemDataBound event.

Controls inside a Repeater or GridView template are not available directly by name in code-behind, because there is one copy per row. Use item.FindControl("controlId") on the row, and cast the result to the right type. FindControl returns null if the ID is wrong, so spell it exactly as in the markup.',
 N'<asp:Button ID="btnSave" runat="server" OnClick="btnSave_Click" />
protected void btnSave_Click(object sender, EventArgs e) { }',
 N'<!-- Does nothing: no OnClick -->
<asp:Button ID="btnSave" runat="server" Text="Save" />
<!-- Fixed -->
<asp:Button ID="btnSave" runat="server" Text="Save" OnClick="btnSave_Click" />

// Resets the selection on every postback
protected void Page_Load(object sender, EventArgs e)
{
    ddlCountry.DataSource = LocationData.Countries;
    ddlCountry.DataBind();
}
// Fixed
protected void Page_Load(object sender, EventArgs e)
{
    if (!IsPostBack)
    {
        ddlCountry.DataSource = LocationData.Countries;
        ddlCountry.DataBind();
    }
}

<!-- Build error: ListItem does not have a DataBinding event -->
<asp:ListItem Text=''<%# Eval("OptionA") %>'' Value="A" />

// Fixed: add the items in code
protected void rptQuestions_ItemDataBound(object sender, RepeaterItemEventArgs e)
{
    var question = (QuizQuestion)e.Item.DataItem;
    var rbl = (RadioButtonList)e.Item.FindControl("rblOptions");
    rbl.Items.Add(new ListItem(question.OptionA, "A"));
}',
 N'The first button has a postback but no handler is attached, so the click appears to do nothing.|Adding OnClick connects the click to the method with the same name.|The first Page_Load refills the dropdown on every request, which wipes the user selection before the Click handler can read it.|Wrapping the filling code in if (!IsPostBack) fills it only once.|The ListItem binding expression is not allowed, so the items are added in the ItemDataBound event instead.|FindControl("rblOptions") locates the list for the current row, and the cast tells C# which control type it is.',
 N'After the fixes the button runs its method, the dropdown keeps the chosen country after clicking another button, and the quiz options appear for every question without a build error.',
 N'These exact fixes appeared while building CodeFusion itself: the Quiz page needed its options added in ItemDataBound, and every dropdown in the Practice Lab uses the IsPostBack guard.',
 N'Forgetting OnClick on a button and assuming the method will be found by its name.|Binding a list on every request, so the user choice is lost.',
 N'If a button does nothing, check OnClick first, then check the method name and signature.|If FindControl returns null, check the ID in the markup spelling, capitalisation and which row or item you are searching in.|If a Cancel button is blocked by validation messages, set CausesValidation="false" on it.',
 N'Open Practice/DropDownLab.aspx.cs, remove the IsPostBack check temporarily, and watch what happens when you choose a country. Put the check back afterwards.',
 N'A missing OnClick means the click runs no code|Fill list controls only when !IsPostBack|A ListItem cannot contain a binding expression; add items in code|Use FindControl for controls inside templates, and check the ID', N'CSharp', 6, 1),

-- Lesson 33
(@Mod5,
 N'Complete Debugging Workflow and Mini Project',
 N'A repeatable seven-step method for fixing any error, and a small project to practise it on.',
 N'Apply a seven-step debugging workflow to any error|Handle database errors in the BLL so users see a friendly message|Plan and build a small project that combines every module',
 N'Experienced developers do not fix errors by luck. They follow the same steps every time, and so can you.

Step 1: read the whole error message, including the type, the message and the line number. Step 2: identify the layer where it happened: the markup, the code-behind, the business logic, the database access or the configuration. Step 3: reproduce it, so that you can make it happen again on purpose. Step 4: form a hypothesis, one specific guess about the cause. Step 5: test it with a breakpoint, by looking at variable values, or by running the SQL on its own. Step 6: fix one thing at a time and rebuild. Step 7: re-test, including the features nearby, and note how the mistake could be prevented, for example with a validator, a null check or a parameter.

Breakpoints are the most powerful tool. Click in the grey margin next to a line to set one, run the site in debug mode, and Visual Studio stops on that line so you can hover over variables to see their values and step forward line by line. This turns guessing into looking.

Users must never see raw errors. Catch database exceptions in the Business Logic Layer, record the real details for yourself, and return a short friendly message to the page. CodeFusion does this in AuthBLL.RegisterStudent and elsewhere, and Web.config customErrors shows a safe page for anything that slips through.

Mini project: build a Book Manager that uses everything in this course. Create a Book table with BookID, Title, Author and Price. Write a Book entity, a BookBLL with GetAll, GetById, Search, Create, Update and Delete, and a page with a validated form, a GridView, Edit and Delete buttons with confirmation, and friendly messages. Finish by trying to break it with empty, long and unusual input, and fix whatever you find using the workflow above.',
 N'Read -> Locate the layer -> Reproduce -> Hypothesise -> Test -> Fix one thing -> Re-test and prevent',
 N'// Business logic: never let a raw database error reach the user
public static string RegisterStudent(string name, string email, string password)
{
    try
    {
        // validate the input, hash the password, run a parameterised INSERT
        return string.Empty;
    }
    catch (SqlException)
    {
        // record the real error for developers here, but do not show it to the user
        return "We could not create your account right now. Please try again.";
    }
}

// Page: show only the friendly message
string error = AuthBLL.RegisterStudent(txtName.Text, txtEmail.Text, txtPassword.Text);
if (error != string.Empty)
{
    lblMessage.Text = Server.HtmlEncode(error);
    return;
}',
 N'The try block holds the code that might fail, such as the database INSERT.|The catch block runs only if a SqlException occurs, and returns a short friendly message instead of the exception details.|A comment marks where the real error would be recorded for the developer; the user never sees it.|Returning an empty string means success, so the page can simply check whether the result is empty.|Server.HtmlEncode makes sure the message cannot be interpreted as HTML when it is displayed.',
 N'If the database is unavailable, the user sees We could not create your account right now. Please try again. instead of a yellow error page, and the developer still has the real error to investigate.',
 N'This workflow is how professional developers work every day, and the friendly-message pattern is how real sites avoid exposing their internals. The Book Manager is also a project you can show in a portfolio or demonstration.',
 N'Changing several things at once, so you cannot tell which change fixed the problem.|Showing exception text to users, which confuses them and can reveal details an attacker could use.',
 N'If you are stuck, go back one step: can you reproduce the error every time, and do you know which layer it is in?|If a fix does not work, undo it before trying the next idea, so the code does not become more confusing.|If you cannot find the cause, run the SQL on its own in SQL Server Object Explorer to find out whether the query or the C# is at fault.',
 N'Build the Book Manager described in the lesson. Keep a short log of every error you meet, the cause you found, and the fix, using the seven steps.',
 N'Follow the same seven steps for every error|Set breakpoints and look at real values instead of guessing|Catch database errors in the BLL and return friendly messages|Fix one thing at a time and re-test', N'CSharp', 7, 1);

PRINT '--- Module 5: 7 lessons inserted ---';
GO

-- ---------- Mini quiz questions (3 per lesson) ----------
DECLARE @L27 INT = (SELECT LessonID FROM Lesson WHERE Title = N'Understanding Common C# Errors');
DECLARE @L28 INT = (SELECT LessonID FROM Lesson WHERE Title = N'Understanding ASP.NET Web Forms Errors');
DECLARE @L29 INT = (SELECT LessonID FROM Lesson WHERE Title = N'SQL Query Errors');
DECLARE @L30 INT = (SELECT LessonID FROM Lesson WHERE Title = N'Database Connection Errors');
DECLARE @L31 INT = (SELECT LessonID FROM Lesson WHERE Title = N'Web.config and Configuration Errors');
DECLARE @L32 INT = (SELECT LessonID FROM Lesson WHERE Title = N'Control and Event Handling Errors');
DECLARE @L33 INT = (SELECT LessonID FROM Lesson WHERE Title = N'Complete Debugging Workflow and Mini Project');

INSERT INTO LessonQuizQuestion (LessonID, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, DisplayOrder) VALUES
(@L27, N'Which kind of error stops the project from building?', N'Runtime error', N'Compile-time error', N'Logic error', N'No error does', 'B', 1),
(@L27, N'What does a NullReferenceException mean?', N'Text could not become a number', N'A variable that is null was used', N'The connection was closed', N'A file is missing', 'B', 2),
(@L27, N'Which method converts text to an int without throwing an exception?', N'int.Parse', N'Convert.ToString', N'int.TryParse', N'string.Join', 'C', 3),

(@L28, N'What must a ContentPlaceHolderID in a content page match?', N'The page file name', N'An ID of a ContentPlaceHolder in the master page', N'The class name', N'The connection string', 'B', 1),
(@L28, N'Why might code-behind report that lblMsg does not exist?', N'The control is missing runat="server"', N'The page is too long', N'The database is closed', N'The CSS is missing', 'A', 2),
(@L28, N'How can you see full error details on your own machine?', N'Delete Web.config', N'Temporarily set customErrors to Off', N'Restart the computer', N'Remove the master page', 'B', 3),

(@L29, N'What does Invalid column name usually mean?', N'The column is not in the table, often a spelling mistake', N'The server is switched off', N'The password is wrong', N'The table is full', 'A', 1),
(@L29, N'What does Must declare the scalar variable @Id usually mean?', N'The table is missing', N'The SQL uses a parameter that C# never added', N'The database is read-only', N'The page has no master', 'B', 2),
(@L29, N'What causes Violation of UNIQUE KEY constraint?', N'Deleting a row', N'Inserting a value that already exists in a unique column', N'Sorting results', N'Opening a connection', 'B', 3),

(@L30, N'What does ExecuteScalar requires an open and available Connection mean?', N'The SQL is wrong', N'con.Open() was forgotten', N'The table is missing', N'The server is too old', 'B', 1),
(@L30, N'Why would reading ConnectionStrings["Name"].ConnectionString throw a NullReferenceException?', N'The name does not exist in Web.config', N'The database has no rows', N'The table has no key', N'The page has no label', 'A', 2),
(@L30, N'What does Cannot open database requested by the login usually mean?', N'The database does not exist on that server instance', N'A button has no OnClick', N'A validator failed', N'The CSS file is missing', 'A', 3),

(@L31, N'Which file normally holds the connection string?', N'Site.Master', N'Web.config', N'Default.aspx', N'theme.css', 'B', 1),
(@L31, N'What happens if a tag in Web.config is not closed?', N'Only one page fails', N'The XML is malformed and the whole site fails', N'Nothing at all', N'The database is deleted', 'B', 2),
(@L31, N'Where must the sessionState setting be defined?', N'In every subfolder Web.config', N'Only in the root Web.config', N'In the master page', N'In the CSS file', 'B', 3),

(@L32, N'A button click does nothing and shows no error. What is the likely cause?', N'The OnClick attribute is missing', N'The database is full', N'The CSS is wrong', N'The master page is missing', 'A', 1),
(@L32, N'Why does a dropdown selection reset after every click?', N'It is bound on every request instead of only when !IsPostBack', N'Dropdowns cannot keep values', N'The server is slow', N'The validator is missing', 'A', 2),
(@L32, N'Why can a ListItem not contain a <%# %> binding expression?', N'It is not a full control and has no DataBinding event', N'It is too small', N'Binding is not allowed in ASP.NET', N'It needs a connection string', 'A', 3),

(@L33, N'What is the first step of the debugging workflow?', N'Delete the file', N'Read the whole error message', N'Restart Visual Studio', N'Change several things at once', 'B', 1),
(@L33, N'What should users see when a database error occurs?', N'The raw error text', N'A friendly message', N'The connection string', N'A blank page', 'B', 2),
(@L33, N'What should you do after a fix works?', N'Stop immediately', N'Re-test, including nearby features, and note how to prevent it', N'Delete the project', N'Change Web.config', 'B', 3);

PRINT '--- Module 5: mini quiz questions inserted ---';
GO

-- ---------- Debug Lab challenges: 2 per category (12 total) ----------
INSERT INTO Challenge (ChallengeType, Category, Difficulty, Question, CodeSnippet, Answer, Hint1, Hint2, Solution, PreventionTip, XPReward) VALUES
-- C# Error
(N'FindError', N'C# Error', N'Easy',
 N'This button handler will not compile. What is wrong?',
 N'protected void btnSave_Click(object sender, EventArgs e)
{
    int age = txtAge.Text;
    lblResult.Text = "Age saved: " + age;
}',
 N'txtAge.Text is a string and cannot be assigned to an int without converting it',
 N'Look at the data type on each side of the equals sign.',
 N'TextBox.Text is always a string. It must be converted before it is stored in an int.',
 N'protected void btnSave_Click(object sender, EventArgs e)
{
    int age;
    if (!int.TryParse(txtAge.Text, out age))
    {
        lblResult.Text = "Please enter a whole number.";
        return;
    }
    lblResult.Text = "Age saved: " + age;
}',
 N'Remember that TextBox.Text is always a string. Use int.TryParse so that invalid input gives a friendly message instead of an exception.',
 15),
(N'FixCode', N'C# Error', N'Medium',
 N'Visiting this page without logging in crashes with a NullReferenceException. Fix the code.',
 N'protected void Page_Load(object sender, EventArgs e)
{
    string name = Session["StudentName"].ToString();
    lblWelcome.Text = "Welcome, " + name;
}',
 N'Session["StudentName"] is null when nobody is logged in',
 N'Think about what Session["StudentName"] contains before anyone has logged in.',
 N'Calling a method on null throws the exception. Check for null before using the value.',
 N'protected void Page_Load(object sender, EventArgs e)
{
    object value = Session["StudentName"];
    string name = (value == null) ? "Guest" : value.ToString();
    lblWelcome.Text = "Welcome, " + name;
}',
 N'Values read from Session, query strings and the database can be null. Check for null before calling methods on them.',
 20),
-- ASP.NET Error
(N'FindError', N'ASP.NET Error', N'Easy',
 N'The code-behind reports that lblMsg does not exist in the current context. What is wrong with the markup?',
 N'<!-- Default.aspx -->
<span id="lblMsg">Hello</span>

// Default.aspx.cs
protected void Page_Load(object sender, EventArgs e)
{
    lblMsg.Text = "Done";
}',
 N'The element is plain HTML; it has no runat="server" and is not a server control',
 N'Can code-behind see an ordinary HTML span?',
 N'A control used in code-behind must be a server control with runat="server".',
 N'<asp:Label ID="lblMsg" runat="server" Text="Hello" />',
 N'Any control that code-behind uses needs an ID and runat="server". If the compiler says a name does not exist, check the markup first.',
 15),
(N'FixCode', N'ASP.NET Error', N'Medium',
 N'This content page shows a parser error: Cannot find ContentPlaceHolder ''MainContents'' in the master page. Fix it.',
 N'<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Page.aspx.cs" Inherits="Page" %>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContents" runat="server">
    <h1>Hello</h1>
</asp:Content>',
 N'The ContentPlaceHolderID does not match the ID in Site.Master, which is MainContent',
 N'Compare the ID in this Content tag with the ContentPlaceHolder in Site.Master.',
 N'Look closely at the spelling: the master page ID has no letter s at the end.',
 N'<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h1>Hello</h1>
</asp:Content>',
 N'Copy the placeholder ID from the master page instead of typing it from memory, and compare them character by character.',
 20),
-- SQL Error
(N'FindError', N'SQL Error', N'Easy',
 N'The student is trying to retrieve a student by email. What is wrong with this code?',
 N'SqlCommand cmd = new SqlCommand(
    "SELECT * FROM Student WHERE Email = " + email,
    con);',
 N'The user input is joined directly into the SQL text instead of using a parameter',
 N'Where does the value of email come from, and who controls it?',
 N'Joining user input into SQL text allows SQL injection. Use a parameter placeholder instead.',
 N'SqlCommand cmd = new SqlCommand(
    "SELECT * FROM Student WHERE Email = @Email",
    con);
cmd.Parameters.AddWithValue("@Email", email);',
 N'Never join user input into SQL text. Always use parameters, which send the value separately so it can only ever be treated as data.',
 15),
(N'CompleteCode', N'SQL Error', N'Medium',
 N'Complete the statement so that it changes the salary of only one employee.',
 N'UPDATE Employee
SET Salary = @Salary
____________________;',
 N'WHERE EmployeeID = @Id',
 N'What happens to all the other rows if the statement has nothing to restrict it?',
 N'Use the primary key column in a WHERE clause and pass its value as a parameter.',
 N'UPDATE Employee
SET Salary = @Salary
WHERE EmployeeID = @Id;',
 N'Always write the WHERE clause before you run an UPDATE or DELETE. Without it, every row in the table is changed or removed.',
 20),
-- Database Connection Error
(N'FindError', N'Database Connection Error', N'Medium',
 N'This code throws: ExecuteScalar requires an open and available Connection. What is missing?',
 N'using (SqlConnection con = DBHelper.GetConnection())
using (SqlCommand cmd = new SqlCommand("SELECT COUNT(*) FROM Student", con))
{
    int total = Convert.ToInt32(cmd.ExecuteScalar());
    lblTotal.Text = total.ToString();
}',
 N'con.Open() is never called before executing the command',
 N'Creating a SqlConnection does not contact the database yet.',
 N'The connection must be opened before ExecuteScalar runs.',
 N'using (SqlConnection con = DBHelper.GetConnection())
using (SqlCommand cmd = new SqlCommand("SELECT COUNT(*) FROM Student", con))
{
    con.Open();
    int total = Convert.ToInt32(cmd.ExecuteScalar());
    lblTotal.Text = total.ToString();
}',
 N'Follow the order: create the connection, create the command, open the connection, execute. Keep everything inside using blocks.',
 20),
(N'FixCode', N'Database Connection Error', N'Hard',
 N'This code throws a NullReferenceException on the first line, although Web.config has a connection string named CodeFusionDB. Fix it.',
 N'string cs = ConfigurationManager.ConnectionStrings["CodeFusion"].ConnectionString;
SqlConnection con = new SqlConnection(cs);',
 N'The name in the code does not match the name attribute in Web.config, so the lookup returns null',
 N'ConnectionStrings["..."] returns null when the name is not found.',
 N'Compare the text inside the square brackets with the name attribute in Web.config.',
 N'string cs = ConfigurationManager.ConnectionStrings["CodeFusionDB"].ConnectionString;
SqlConnection con = new SqlConnection(cs);',
 N'Keep the connection string name in one place, such as DBHelper, so it is not retyped in many pages and cannot be spelt differently.',
 30),
-- Web.config Error
(N'FindError', N'Web.config Error', N'Easy',
 N'The whole site shows a Configuration Error after this edit. What is wrong?',
 N'<appSettings>
  <add key="MaterialsUploadPath" value="~/Uploads/Materials/" >
</appSettings>',
 N'The add element is not closed, so the XML is malformed',
 N'XML requires every element to be closed.',
 N'The add element needs a slash before the final angle bracket.',
 N'<appSettings>
  <add key="MaterialsUploadPath" value="~/Uploads/Materials/" />
</appSettings>',
 N'Keep a backup of Web.config before editing it, and check every tag and quotation mark after you change it.',
 15),
(N'FixCode', N'Web.config Error', N'Medium',
 N'The site shows: It is an error to use a section registered as allowDefinition=MachineToApplication beyond application level. The error points to this file, Admin/Web.config. Fix it.',
 N'<!-- Admin/Web.config (a subfolder) -->
<configuration>
  <system.web>
    <sessionState mode="InProc" timeout="60" />
  </system.web>
</configuration>',
 N'sessionState can only be set in the root Web.config, not in a subfolder',
 N'Is this file at the root of the application?',
 N'Some sections are only allowed once, at the application level.',
 N'Remove the sessionState element from Admin/Web.config (delete the file if it contains nothing else) and keep a single sessionState setting in the Web.config at the root of the website.',
 N'Keep one Web.config at the root for application-wide settings, and make sure Visual Studio opens the website at the correct folder level.',
 20),
-- Control/Event Error
(N'FindError', N'Control/Event Error', N'Easy',
 N'Clicking Save reloads the page but nothing is saved, and there is no error message. What is wrong?',
 N'<asp:Button ID="btnSave" runat="server" Text="Save" />

// Code-behind
protected void btnSave_Click(object sender, EventArgs e)
{
    lblStatus.Text = "Saved.";
}',
 N'The button has no OnClick attribute, so the handler is never connected',
 N'How does ASP.NET know which method belongs to this button?',
 N'The markup must name the handler with OnClick.',
 N'<asp:Button ID="btnSave" runat="server" Text="Save" OnClick="btnSave_Click" />',
 N'When a button does nothing and shows no error, check OnClick first, then confirm the method name matches exactly.',
 15),
(N'FixCode', N'Control/Event Error', N'Hard',
 N'This build fails with: ListItem does not have a DataBinding event. Fix it so each option shows the text from the database.',
 N'<asp:RadioButtonList ID="rblOptions" runat="server">
    <asp:ListItem Text=''<%# Eval("OptionA") %>'' Value="A" />
    <asp:ListItem Text=''<%# Eval("OptionB") %>'' Value="B" />
</asp:RadioButtonList>',
 N'ListItem is not a full control, so it cannot use a <%# %> binding expression; the items must be added in code',
 N'Which kind of control is allowed to use <%# %> expressions?',
 N'Leave the list empty in the markup and fill it in the Repeater ItemDataBound event.',
 N'<asp:RadioButtonList ID="rblOptions" runat="server" />

// Code-behind
protected void rptQuestions_ItemDataBound(object sender, RepeaterItemEventArgs e)
{
    var question = (QuizQuestion)e.Item.DataItem;
    var rbl = (RadioButtonList)e.Item.FindControl("rblOptions");
    rbl.Items.Add(new ListItem(question.OptionA, "A"));
    rbl.Items.Add(new ListItem(question.OptionB, "B"));
}',
 N'When list options come from data, bind or add them from code. Binding expressions work only on full controls such as Label, Literal and HiddenField.',
 30);

PRINT '--- Module 5: 12 Debug Lab challenges inserted ---';
GO

-- ---------- Verification (self-contained, no variables carried over GO) ----------
SELECT
    (SELECT COUNT(*) FROM Lesson WHERE ModuleID = (SELECT ModuleID FROM Module WHERE ModuleOrder = 5)) AS Module5LessonCount,
    (SELECT COUNT(*) FROM LessonQuizQuestion WHERE LessonID IN
        (SELECT LessonID FROM Lesson WHERE ModuleID = (SELECT ModuleID FROM Module WHERE ModuleOrder = 5))) AS Module5QuizQuestionCount,
    (SELECT COUNT(*) FROM Lesson) AS TotalLessonCount,
    (SELECT COUNT(*) FROM Challenge) AS TotalChallengeCount,
    (SELECT COUNT(*) FROM Challenge WHERE Category IS NOT NULL) AS ChallengesWithCategory;
GO