/* =====================================================================
   CodeFusion — Module 2 content: ASP.NET Controls and Events (7 lessons)
   Run this ONCE against your existing CodeFusionDB.
   ===================================================================== */
USE CodeFusionDB;
GO
SET NOCOUNT ON;

DECLARE @Mod2 INT = (SELECT ModuleID FROM Module WHERE ModuleOrder = 2);

INSERT INTO Lesson
    (ModuleID, Title, ShortDescription, LearningObjectives, Explanation, Syntax, CodeExample, CodeExplanation,
     ExpectedOutput, RealWorldUse, CommonMistakes, Troubleshooting, PracticeTask, KeyPoints, CodeLanguage, DisplayOrder, IsPublished)
VALUES
-- Lesson 7
(@Mod2,
 N'Label and TextBox Controls',
 N'The two most-used controls in Web Forms: displaying text, and letting the user type text.',
 N'Create a Label and set its Text property from code|Create a TextBox and read what the user typed|Explain when to use TextMode="Password" or TextMode="MultiLine"',
 N'A Label displays text on the page that the user cannot edit — you use it to show messages, results, or instructions. A TextBox is the opposite: it is an editable field the user types into. Both are among the simplest server controls, but together they form the basis of almost every form in this project.

A Label''s most important property is Text — whatever string you assign to it in code-behind becomes what the browser displays. A TextBox''s most important property is also Text, but in the other direction: it holds whatever the user has typed, and your code-behind reads it after a postback.

TextBox has a TextMode property that changes its behavior: the default "SingleLine" gives a normal one-line input, "Password" masks what is typed (used for the Login and Register pages in this project), and "MultiLine" turns it into a resizable text area, useful for longer input like a note or a description.',
 N'<asp:Label ID="lblMessage" runat="server" Text="..." />
<asp:TextBox ID="txtInput" runat="server" TextMode="SingleLine" />',
 N'<asp:TextBox ID="txtName" runat="server" CssClass="cf-input" placeholder="Your name" />
<asp:Button ID="btnGreet" runat="server" Text="Greet me" OnClick="btnGreet_Click" />
<asp:Label ID="lblGreeting" runat="server" />

// Code-behind
protected void btnGreet_Click(object sender, EventArgs e)
{
    lblGreeting.Text = "Hello, " + txtName.Text + "!";
}',
 N'Markup: txtName is a normal TextBox; btnGreet is a Button whose click runs server-side code.|Code-behind line: "txtName.Text" reads whatever the user typed into the box.|Code-behind line: "lblGreeting.Text = ..." changes what the Label displays, by building a new string.',
 N'Typing "Aarav" and clicking the button makes the Label show "Hello, Aarav!" — with no page refresh feeling, even though a full postback happened behind the scenes.',
 N'Every form in CodeFusion — Register, Login, the Arithmetic Lab, the CRUD Lab — is built from exactly this Label-and-TextBox pairing, just repeated many times with different logic attached.',
 N'Forgetting that TextBox.Text is always a string — if you need a number, you must parse it (for example with double.Parse or Convert.ToInt32) before doing math with it.|Setting a Label''s Text once in markup and expecting it to "update itself" — it only changes when your code-behind explicitly sets it again.',
 N'If a TextBox appears empty after a postback when it shouldn''t be, check whether something is resetting it unconditionally in Page_Load instead of inside if (!IsPostBack).|If math on a TextBox value throws a FormatException, the user probably typed something non-numeric — validate before parsing.',
 N'Open Practice/ArithmeticLab.aspx in this project and find any one calculator. Identify which TextBox holds the input and which Label (or Literal) shows the result.',
 N'Label displays read-only text, set via its Text property|TextBox accepts user input, read via its Text property|TextMode controls single-line, password, or multi-line behavior|TextBox.Text is always a string — parse it before doing math', N'ASPX', 1, 1),

-- Lesson 8
(@Mod2,
 N'Button Control and Click Event',
 N'How a Button triggers server-side code, and the difference between Button, LinkButton, and ImageButton.',
 N'Wire a Button''s OnClick to a code-behind method|Explain what a postback is in terms of a Button click|Choose between Button, LinkButton, and ImageButton appropriately',
 N'A Button is the control that actually causes most of the interaction in a Web Forms page. Clicking it submits the page back to the server (a postback), and ASP.NET runs whichever method you named in its OnClick attribute.

ASP.NET actually gives you three visually different flavors of the same idea: asp:Button renders as an HTML <input type="submit">, asp:LinkButton renders as a clickable hyperlink that still causes a full postback (used for "Edit" and "Delete" links in GridViews throughout this project), and asp:ImageButton does the same but renders as a clickable image. All three fire a Click event in exactly the same way — only their visual appearance differs.

One subtlety worth knowing: a Button inside a GridView or Repeater template usually uses CommandName and CommandArgument instead of a direct OnClick, so a single handler can tell which row''s button was actually clicked. You will see this pattern in the CRUD Lab''s Edit/Delete links.',
 N'<asp:Button ID="btnName" runat="server" Text="Click Me" OnClick="btnName_Click" />',
 N'<asp:Button ID="btnSave" runat="server" Text="Save" OnClick="btnSave_Click" />

// Code-behind
protected void btnSave_Click(object sender, EventArgs e)
{
    lblStatus.Text = "Saved at " + DateTime.Now.ToString("HH:mm:ss");
}',
 N'Markup: OnClick="btnSave_Click" tells ASP.NET exactly which method to call when this specific button causes a postback.|Code-behind: "object sender" is the control that raised the event — here, it would be btnSave itself, though it is rarely used directly in simple handlers.|Code-behind: DateTime.Now.ToString("HH:mm:ss") formats the current server time as hours:minutes:seconds.',
 N'Each click shows an updated timestamp in lblStatus, proving a fresh postback and a fresh run of the server-side method happened.',
 N'Every "Save", "Submit", "Add", and "Delete" action anywhere in CodeFusion — the CRUD Lab, Debug Lab, Admin panel — is a Button or LinkButton wired exactly this way.',
 N'Forgetting OnClick entirely, so clicking the button causes a postback but nothing in your code-behind actually runs.|Using CausesValidation="false" by accident on a button that should trigger page validators (or forgetting to set it on one, like a "Cancel" button, that shouldn''t).',
 N'If a button click seems to "do nothing," check for a missing or misspelled OnClick attribute first.|If a "Cancel" button is unexpectedly blocked by validation errors, add CausesValidation="false" to it — it still causes a postback, just skips validator checks.',
 N'Open Practice/CrudLab.aspx.cs in this project and find btnSave_Click. Identify how it decides whether to insert a new record or update an existing one.',
 N'Button, LinkButton and ImageButton all fire Click, just with different visual rendering|OnClick names the code-behind method that runs on click|CommandName/CommandArgument let one handler serve many rows (GridView, Repeater)|CausesValidation="false" skips validator checks for that specific button', N'ASPX', 2, 1),

-- Lesson 9
(@Mod2,
 N'CheckBox and RadioButton',
 N'Capturing yes/no choices with CheckBox, and single-choice-from-a-set with RadioButton and RadioButtonList.',
 N'Read a CheckBox''s Checked property in code-behind|Group RadioButtons so only one can be selected at a time|Choose between individual RadioButtons and a RadioButtonList',
 N'A CheckBox represents a simple true/false choice — "Subscribe to updates," for example. Its Checked property is a bool: true if ticked, false if not. You read it in code-behind exactly like any other property.

A RadioButton represents one option within a set of mutually exclusive choices — only one can be selected at a time. To make a group of RadioButtons behave this way, they all need the same GroupName. In practice, ASP.NET gives you an easier way to manage this: RadioButtonList, which holds a collection of ListItems and automatically groups them, exposing a single SelectedValue property instead of checking each RadioButton individually.

Use CheckBox for independent yes/no settings, and RadioButtonList when the user must pick exactly one option out of several (like choosing a skill level: Beginner, Intermediate, Advanced).',
 N'<asp:CheckBox ID="chkName" runat="server" Text="..." />

<asp:RadioButtonList ID="rblName" runat="server">
    <asp:ListItem Text="..." Value="..." />
</asp:RadioButtonList>',
 N'<asp:CheckBox ID="chkSubscribe" runat="server" Text="Subscribe to updates" />
<asp:RadioButtonList ID="rblLevel" runat="server">
    <asp:ListItem Text="Beginner" Value="Beginner" Selected="True" />
    <asp:ListItem Text="Advanced" Value="Advanced" />
</asp:RadioButtonList>

// Code-behind
protected void btnSubmit_Click(object sender, EventArgs e)
{
    bool subscribed = chkSubscribe.Checked;
    string level = rblLevel.SelectedValue;
}',
 N'Markup: Selected="True" on a ListItem sets the default selection before the user interacts with the page.|Code-behind line 1: "chkSubscribe.Checked" is a plain bool — true if ticked.|Code-behind line 2: "rblLevel.SelectedValue" returns the Value of whichever ListItem the user picked, as a string.',
 N'With nothing changed, the result is "Not subscribed" and "Beginner" (the default). Ticking the checkbox and picking "Advanced," then submitting, reflects both new choices in code.',
 N'The Controls Lab in this project demonstrates exactly this CheckBox/RadioButtonList pairing live, and the CRUD Lab''s Department dropdown uses the same SelectedValue pattern you just learned, just on a different control.',
 N'Forgetting to give multiple individual RadioButton controls the same GroupName — without it, every RadioButton can be selected independently, defeating the point.|Reading .Text instead of .SelectedValue on a RadioButtonList when you actually wanted the underlying Value, not the display label.',
 N'If RadioButtons don''t behave as mutually exclusive, check that they all share one GroupName — or switch to RadioButtonList, which handles this automatically.|If SelectedValue comes back empty, confirm at least one ListItem has Selected="True" or that the user actually picked an option before postback.',
 N'Open Practice/ControlsLab.aspx in this project and find the CheckBox and RadioButtonList demo. Read btnCheckDemo_Click in its code-behind and explain what each line reads.',
 N'CheckBox.Checked is a simple bool|RadioButtonList groups choices automatically and exposes SelectedValue|Individual RadioButtons need a shared GroupName to behave as one group|Use CheckBox for independent yes/no, RadioButtonList for pick-exactly-one', N'ASPX', 3, 1),

-- Lesson 10
(@Mod2,
 N'DropDownList and ListBox',
 N'Single-select and multi-select lists, and the DataSource/DataBind pattern used to fill them from code.',
 N'Fill a DropDownList from a C# list using DataSource and DataBind|Read a DropDownList''s SelectedValue|Read multiple selections from a ListBox with SelectionMode="Multiple"',
 N'DropDownList shows a compact, single-select list that expands when clicked — ideal when you have more options than comfortably fit as RadioButtons. ListBox is similar but can show several options at once and, with SelectionMode="Multiple", allow the user to select more than one.

Both controls can be filled two ways: declaratively, by listing <asp:ListItem> elements directly in markup (fine for options that never change, like a difficulty level), or dynamically from code, using DataSource and DataBind() (necessary when the options come from a database or a list that can change, like a dropdown of countries).

The dynamic pattern is: set theControl.DataSource to any collection (a List<string>, a DataTable, and so on), optionally set DataTextField/DataValueField if binding complex objects, then call theControl.DataBind() to actually render the items.',
 N'ddl.DataSource = someList;
ddl.DataBind();

listBox.SelectionMode = ListSelectionMode.Multiple;',
 N'protected void Page_Load(object sender, EventArgs e)
{
    if (!IsPostBack)
    {
        string[] topics = { "ASP.NET", "C#", "SQL" };
        ddlTopic.DataSource = topics;
        ddlTopic.DataBind();
    }
}',
 N'Line 3: "if (!IsPostBack)" ensures the dropdown is only filled once, on first load — the Page Life Cycle lesson from Module 1 explains exactly why this matters.|Line 5: "ddlTopic.DataSource = topics;" tells the control where its items should come from — nothing visible happens yet.|Line 6: "ddlTopic.DataBind();" is what actually generates the <asp:ListItem> elements and renders them to the browser.',
 N'The dropdown opens showing ASP.NET, C#, and SQL as its three options, in that exact order, because that is the order of the string array.',
 N'The DropDownList and ListBox demo in this project''s Controls Lab binds both from the exact same array, side by side, so you can directly compare single-select vs multi-select behavior.',
 N'Calling DataBind() without first setting DataSource — nothing renders, and no error is thrown, which can make the mistake confusing to spot.|Re-binding a dropdown on every postback (forgetting the IsPostBack check) — this silently resets whatever the user had selected.',
 N'If a dropdown renders completely empty, check that DataSource was actually set to something non-null before DataBind() was called.|If a dropdown''s selection keeps resetting after every button click, that is almost always a missing IsPostBack guard.',
 N'Open Practice/ControlsLab.aspx.cs and find where ddlTopic and lbxTopics are both bound from the same topics array. Explain, in your own words, why both can share one array but produce different-looking controls.',
 N'DataSource + DataBind() is the standard pattern for filling a list from code|Static options can instead be written directly as ListItem elements in markup|SelectionMode="Multiple" turns a ListBox into a multi-select control|Always guard dynamic binding with if (!IsPostBack)', N'CSharp', 4, 1),

-- Lesson 11
(@Mod2,
 N'Calendar and FileUpload Controls',
 N'Letting a user pick a date, and letting a user choose a file from their computer.',
 N'Read the selected date from a Calendar control|Check whether a FileUpload control actually has a file before using it|Explain why file uploads need extra validation',
 N'The Calendar control renders a full month-view date picker. When the user clicks a date, it fires a SelectionChanged event, and your code-behind can read SelectedDate to get a normal C# DateTime value — ready to use in comparisons, formatting, or saving to a database.

FileUpload lets the user browse their own computer and choose a file to send to the server. Unlike most controls, you should never assume a file was actually chosen — always check the HasFile property first. If it is true, PostedFile gives you details like FileName and ContentLength (the size in bytes), and SaveAs(path) writes the file to disk on the server.

File uploads deserve extra caution: never trust the file extension or name blindly. In this project, the Admin Materials page checks that an uploaded file actually ends in ".pdf" before accepting it, and saves it under a randomly generated name rather than trusting whatever name the user''s browser sent, to avoid overwriting existing files or being tricked by a malicious filename.',
 N'<asp:Calendar ID="cal" runat="server" OnSelectionChanged="cal_SelectionChanged" />
<asp:FileUpload ID="fu" runat="server" />',
 N'protected void cal_SelectionChanged(object sender, EventArgs e)
{
    lblDate.Text = cal.SelectedDate.ToString("dddd, MMMM d, yyyy");
}

protected void btnUpload_Click(object sender, EventArgs e)
{
    if (fu.HasFile)
    {
        lblFile.Text = fu.FileName + " (" + fu.PostedFile.ContentLength + " bytes)";
    }
}',
 N'Calendar handler: "cal.SelectedDate" is a real DateTime — ToString("dddd, MMMM d, yyyy") formats it as a readable full date.|Upload handler line 1: "if (fu.HasFile)" is a mandatory check — skipping it risks a null reference if no file was chosen.|Upload handler line 2: "fu.PostedFile.ContentLength" reports the file size in bytes, useful for showing the user or enforcing a size limit.',
 N'Clicking a date on the calendar instantly shows something like "Tuesday, March 4, 2026" in the label. Choosing a file and clicking Upload shows its name and size, without actually saving anything in this simple demo.',
 N'This project''s Controls Lab has a live Calendar and FileUpload demo, and the Admin Materials page uses the real, safer version of file upload — with extension checking and a randomly generated filename — that this lesson''s common-mistakes section describes.',
 N'Using fu.PostedFile without checking fu.HasFile first — if no file was chosen, this throws a null reference exception.|Trusting an uploaded file''s name or extension as proof of its actual content — a file renamed to "report.pdf" is not guaranteed to actually be a PDF.',
 N'If a file upload page crashes immediately after clicking Upload with nothing selected, check for a missing HasFile guard.|If a Calendar''s SelectionChanged event never seems to fire, confirm OnSelectionChanged is actually wired in markup.',
 N'Open Practice/ControlsLab.aspx.cs and find btnUploadDemo_Click. Identify the exact line that protects against a null reference when no file is selected.',
 N'Calendar.SelectedDate gives you a real DateTime|Always check FileUpload.HasFile before touching PostedFile|PostedFile.ContentLength reports file size in bytes|Never trust an uploaded file''s name or extension without validating it', N'CSharp', 5, 1),

-- Lesson 12
(@Mod2,
 N'GridView Control',
 N'Displaying a table of data from code, the backbone of every list view in this project.',
 N'Bind a GridView to a DataTable or List<T>|Explain AutoGenerateColumns vs explicit BoundField/TemplateField columns|Read which row a button in a GridView row was clicked on',
 N'GridView renders a collection of data as an HTML table, one row per item, with one column per field you choose to show. It is the single most important control for any "list of records" screen — and every GridView in this project, from the CRUD Lab''s employee list to the Admin panel''s student list, follows the same pattern.

Like DropDownList, GridView is normally filled with DataSource and DataBind(). You can let it build columns automatically (AutoGenerateColumns="true", quick for prototypes) or define them explicitly inside a <Columns> block using BoundField (a simple read-only column bound to one property) and TemplateField (a fully custom column, often holding buttons for Edit/Delete).

When a GridView row has a button, that button typically uses CommandName and CommandArgument (often set to the row''s ID) rather than a direct OnClick, because one shared RowCommand event handler on the GridView itself can then tell exactly which row''s button was clicked, by reading e.CommandArgument.',
 N'<asp:GridView ID="gv" runat="server" AutoGenerateColumns="false" OnRowCommand="gv_RowCommand">
    <Columns>
        <asp:BoundField DataField="Name" HeaderText="Name" />
        <asp:TemplateField>
            <ItemTemplate>
                <asp:LinkButton CommandName="Edit" CommandArgument=''<%# Eval("Id") %>'' runat="server" Text="Edit" />
            </ItemTemplate>
        </asp:TemplateField>
    </Columns>
</asp:GridView>',
 N'gv.DataSource = EmployeeBLL.GetAll();
gv.DataBind();

protected void gv_RowCommand(object sender, GridViewCommandEventArgs e)
{
    if (e.CommandName == "Edit")
    {
        int id = Convert.ToInt32(e.CommandArgument);
    }
}',
 N'Line 1: "gv.DataSource = EmployeeBLL.GetAll();" assigns a List<Employee> from the Business Logic Layer as the source — the GridView does not care where the data came from, only that it is a collection.|Line 2: "gv.DataBind();" renders one table row per item in that list.|RowCommand: "e.CommandArgument" carries whatever value was set in markup''s CommandArgument — here, the clicked row''s Employee ID.',
 N'A table appears with one row per employee, Name in one column and an "Edit" link in another. Clicking Edit on any row fires RowCommand once, with that specific row''s ID available in e.CommandArgument.',
 N'This exact BoundField + TemplateField + RowCommand pattern is used, almost unchanged, throughout this project: the Employee CRUD Lab, Admin Students page, Admin Lessons page, and Quiz History all display their records this way.',
 N'Forgetting DataBind() after setting DataSource — the GridView silently stays empty.|Using OnClick directly on a button inside a GridView template when you actually need to know which row it came from — CommandName/CommandArgument with RowCommand is almost always the right tool for that.',
 N'If a GridView shows no rows despite having data, confirm DataBind() was actually called, and check its EmptyDataTemplate isn''t masking a genuine binding problem.|If RowCommand never fires, check the button''s CommandName is set and the GridView itself has OnRowCommand wired.',
 N'Open Practice/CrudLab.aspx.cs and find gvEmployees_RowCommand. Identify how it tells apart an "edit" click from a "delete" click on the same GridView.',
 N'GridView turns any collection into an HTML table via DataSource + DataBind()|BoundField is a simple read-only column; TemplateField is fully custom|CommandName/CommandArgument + RowCommand is the standard way to handle per-row buttons|The same GridView pattern repeats throughout real ASP.NET applications', N'ASPX', 6, 1),

-- Lesson 13
(@Mod2,
 N'ASP.NET Validation Controls and Events',
 N'The six built-in validators that check form input automatically, on both the browser and the server.',
 N'Attach a RequiredFieldValidator to a TextBox|Explain the difference between client-side and server-side validation (recap from Module 1)|Write a simple CustomValidator with server-side logic',
 N'ASP.NET ships six validator controls that each check one specific kind of rule, and — this is the important part — automatically generate client-side JavaScript for instant feedback while also re-checking the same rule on the server during postback, with no extra code from you.

RequiredFieldValidator checks a field isn''t empty. CompareValidator checks a field against another field''s value (confirm-password) or a fixed value. RangeValidator checks a number or date falls between two bounds. RegularExpressionValidator checks a field matches a pattern (like an email format). CustomValidator lets you write your own rule in a server-side method when none of the built-in ones fit — useful for things like "this number must be even." ValidationSummary collects every validator''s error message on the page into one tidy list.

Every validator needs ControlToValidate (which control it checks) and an ErrorMessage. Critically — and this connects directly back to Module 1''s lesson on server vs client processing — your code-behind should always check Page.IsValid before acting on submitted data, because client-side validation alone can always be bypassed.',
 N'<asp:RequiredFieldValidator ControlToValidate="txtName" ErrorMessage="Required" runat="server" />',
 N'<asp:TextBox ID="txtAge" runat="server" />
<asp:CustomValidator ID="cvEven" runat="server" ControlToValidate="txtAge"
    OnServerValidate="cvEven_ServerValidate" ErrorMessage="Must be even" />

// Code-behind
protected void cvEven_ServerValidate(object source, ServerValidateEventArgs args)
{
    int number;
    args.IsValid = int.TryParse(args.Value, out number) && number % 2 == 0;
}

protected void btnSubmit_Click(object sender, EventArgs e)
{
    if (!Page.IsValid) return;
}',
 N'Markup: OnServerValidate names the method that supplies this validator''s custom rule — none of the five built-in validators can check "is this number even."|Code-behind line: "args.Value" is the submitted text, as a string; it must be parsed before checking it mathematically.|Code-behind line: "args.IsValid = ..." is what actually tells ASP.NET whether this field passed or failed.',
 N'Typing an odd number and submitting shows "Must be even" instantly (client-side), and if JavaScript were disabled, the exact same check would still correctly block submission on the server.',
 N'The Validation Lab in this project puts all six validators on a single form so you can trigger each one directly, and the exact "if (!Page.IsValid) return;" pattern shown here appears at the top of nearly every form-handling method across CodeFusion.',
 N'Forgetting the server-side "if (!Page.IsValid) return;" check, trusting the client-side JavaScript alone — this is a real security gap, not just a style issue.|Giving two different validators on the same page the same ID, or forgetting ControlToValidate, which leaves the validator orphaned and non-functional.',
 N'If invalid data makes it through despite validators being present on the form, the almost-certain cause is a missing Page.IsValid check in code-behind.|If a validator never shows an error, confirm ControlToValidate points at the correct control ID and that the control actually has Display set to something visible.',
 N'Open Practice/ValidationLab.aspx.cs and find cvEven_ServerValidate. Explain, in one sentence, what makes this validator different from the five built-in ones used elsewhere on that same page.',
 N'All six validators generate client-side JavaScript automatically, for instant feedback|Every validator also re-runs its check on the server during postback|CustomValidator is for rules none of the built-in validators cover|Always check Page.IsValid in code-behind before acting on submitted data', N'CSharp', 7, 1);

PRINT '--- Module 2: 7 lessons inserted ---';
GO

-- ---------- Mini quiz questions (3 per lesson) ----------
DECLARE @L7 INT  = (SELECT LessonID FROM Lesson WHERE Title = N'Label and TextBox Controls');
DECLARE @L8 INT  = (SELECT LessonID FROM Lesson WHERE Title = N'Button Control and Click Event');
DECLARE @L9 INT  = (SELECT LessonID FROM Lesson WHERE Title = N'CheckBox and RadioButton');
DECLARE @L10 INT = (SELECT LessonID FROM Lesson WHERE Title = N'DropDownList and ListBox');
DECLARE @L11 INT = (SELECT LessonID FROM Lesson WHERE Title = N'Calendar and FileUpload Controls');
DECLARE @L12 INT = (SELECT LessonID FROM Lesson WHERE Title = N'GridView Control');
DECLARE @L13 INT = (SELECT LessonID FROM Lesson WHERE Title = N'ASP.NET Validation Controls and Events');

INSERT INTO LessonQuizQuestion (LessonID, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, DisplayOrder) VALUES
(@L7, N'Which property holds what a user typed into a TextBox?', N'Value', N'Text', N'Content', N'Input', 'B', 1),
(@L7, N'Which TextMode masks the characters typed?', N'MultiLine', N'SingleLine', N'Password', N'Hidden', 'C', 2),
(@L7, N'What type is TextBox.Text always?', N'int', N'string', N'bool', N'DateTime', 'B', 3),

(@L8, N'What does clicking a Button cause?', N'A page postback', N'An instant SQL query', N'A new browser tab', N'A CSS reload', 'A', 1),
(@L8, N'Which attribute names the code-behind method to run on click?', N'OnClick', N'OnLoad', N'CommandName', N'runat', 'A', 2),
(@L8, N'What pattern is used so one handler can serve many GridView rows?', N'OnClick alone', N'CommandName and CommandArgument', N'TextMode', N'ValidationGroup', 'B', 3),

(@L9, N'What type is CheckBox.Checked?', N'string', N'int', N'bool', N'DateTime', 'C', 1),
(@L9, N'What makes several RadioButtons behave as one mutually-exclusive group?', N'Same ID', N'Same GroupName', N'Same CssClass', N'Same Text', 'B', 2),
(@L9, N'Which control is best for "pick exactly one from several options"?', N'CheckBox', N'RadioButtonList', N'Label', N'FileUpload', 'B', 3),

(@L10, N'What two steps fill a DropDownList from code?', N'Text and Value', N'DataSource and DataBind()', N'Checked and Enabled', N'Items and Count', 'B', 1),
(@L10, N'What enables multi-select on a ListBox?', N'AutoPostBack="true"', N'SelectionMode="Multiple"', N'TextMode="MultiLine"', N'Rows="4"', 'B', 2),
(@L10, N'Why guard dynamic binding with if (!IsPostBack)?', N'It is required syntax', N'To avoid resetting the user''s selection on every postback', N'To make the page load faster only', N'It has no real effect', 'B', 3),

(@L11, N'What type is Calendar.SelectedDate?', N'string', N'DateTime', N'int', N'bool', 'B', 1),
(@L11, N'What must you check before using FileUpload.PostedFile?', N'HasFile', N'IsValid', N'IsPostBack', N'Checked', 'A', 2),
(@L11, N'What does PostedFile.ContentLength report?', N'The file name', N'The file size in bytes', N'The file extension', N'The upload date', 'B', 3),

(@L12, N'What two steps fill a GridView from code?', N'Checked and Enabled', N'DataSource and DataBind()', N'Text and Value', N'HasFile and FileName', 'B', 1),
(@L12, N'Which column type is fully custom, e.g. holding buttons?', N'BoundField', N'TemplateField', N'HeaderField', N'AutoField', 'B', 2),
(@L12, N'What is the standard way to handle a per-row button click in a GridView?', N'OnClick directly on the button', N'CommandName/CommandArgument with RowCommand', N'A separate page per row', N'JavaScript only', 'B', 3),

(@L13, N'Which validator checks a field isn''t empty?', N'CompareValidator', N'RequiredFieldValidator', N'RangeValidator', N'CustomValidator', 'B', 1),
(@L13, N'Which validator would you use for "must be an even number"?', N'RegularExpressionValidator', N'RangeValidator', N'CustomValidator', N'CompareValidator', 'C', 2),
(@L13, N'What should code-behind always check before acting on submitted data?', N'Request.Browser', N'Page.IsValid', N'Session.Timeout', N'Server.MachineName', 'B', 3);

PRINT '--- Module 2: mini quiz questions inserted ---';
GO

-- ---------- Verification ----------
SELECT
    (SELECT COUNT(*) FROM Lesson WHERE ModuleID = @Mod2) AS Module2LessonCount,
    (SELECT COUNT(*) FROM LessonQuizQuestion WHERE LessonID IN (SELECT LessonID FROM Lesson WHERE ModuleID = @Mod2)) AS Module2QuizQuestionCount,
    (SELECT COUNT(*) FROM Lesson) AS TotalLessonCount;
GO