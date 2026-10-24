/* =====================================================================
   CodeFusion — Module 4 content: Database Applications and CRUD (6 lessons)
   Run this ONCE against your existing CodeFusionDB.
   ===================================================================== */
USE CodeFusionDB;
GO
SET NOCOUNT ON;

DECLARE @Mod4 INT = (SELECT ModuleID FROM Module WHERE ModuleOrder = 4);

INSERT INTO Lesson
    (ModuleID, Title, ShortDescription, LearningObjectives, Explanation, Syntax, CodeExample, CodeExplanation,
     ExpectedOutput, RealWorldUse, CommonMistakes, Troubleshooting, PracticeTask, KeyPoints, CodeLanguage, DisplayOrder, IsPublished)
VALUES
-- Lesson 21
(@Mod4,
 N'Data Binding in ASP.NET Web Forms',
 N'How data from C# or SQL Server is attached to controls, and how Eval pulls individual fields into a template.',
 N'Explain what data binding means|Use DataSource and DataBind() to fill a control|Use Eval inside a Repeater template to show individual fields',
 N'Data binding is the process of connecting a source of data (a list, a DataTable, the result of a SQL query) to a control that displays it. Instead of creating one Label per record by hand, you hand the whole collection to a control and let it generate the output.

The basic pattern has two steps. First set the control''s DataSource property to your collection. Then call DataBind(). Nothing is drawn until DataBind() runs; it is the call that actually reads the data and creates the output. You saw this with DropDownList and GridView in Module 2, and the same two steps work for Repeater, ListBox, DataList and others.

Template controls such as Repeater let you write your own HTML for each record. Inside the ItemTemplate you use a binding expression, written as <%# Eval("FieldName") %>. Eval reads the named field from the current record. Binding expressions only produce output after DataBind() has been called, and the field name must match a property of your object or a column of your DataTable exactly.

Two shortcuts are worth remembering. For list controls such as DropDownList, DataTextField and DataValueField choose which field is shown and which is stored. And one restriction: a ListItem (a single option inside a list) cannot contain a binding expression, because it is not a full control. When options must come from data, bind the whole list from code instead of writing <%# %> inside each ListItem.',
 N'control.DataSource = collection;
control.DataBind();

<%# Eval("FieldName") %>',
 N'<asp:Repeater ID="rptEmployees" runat="server">
    <ItemTemplate>
        <div>
            <strong><%# Eval("Name") %></strong> - <%# Eval("Department") %>
        </div>
    </ItemTemplate>
</asp:Repeater>

// Code-behind
protected void Page_Load(object sender, EventArgs e)
{
    if (!IsPostBack)
    {
        rptEmployees.DataSource = EmployeeBLL.GetAll();
        rptEmployees.DataBind();
    }
}',
 N'Markup: the ItemTemplate is repeated once for every item in the data source.|<%# Eval("Name") %> reads the Name property of the current employee; the text inside the quotes must match the property name exactly.|Code-behind: if (!IsPostBack) binds only on first load, so the data is not needlessly reloaded on every postback.|rptEmployees.DataSource = EmployeeBLL.GetAll(); hands the repeater a list of Employee objects from the Business Logic Layer.|rptEmployees.DataBind(); is the call that actually produces the output; before it nothing is shown.',
 N'The page shows one line per employee, for example Aarav Shah - Engineering, then Priya Mehta - Design, in the order the list was returned.',
 N'The Learning page in CodeFusion is a Repeater bound to the list of modules, each showing its title, lesson count and progress bar. Because it is data-bound, adding a module in the Admin panel adds a card with no code change.',
 N'Forgetting DataBind() after setting DataSource, so the control stays empty and no error appears.|Misspelling the field name inside Eval, which throws an error such as DataBinding: does not contain a property with the name.',
 N'If a data-bound control shows nothing, check DataBind() was called and the data source actually contains items.|If you see a message that a type does not contain a property with the name you used in Eval, compare the spelling and capitalisation with the class or column name.',
 N'Open Student/Roadmap.aspx and Student/Roadmap.aspx.cs. Find the Repeater and the line that sets its DataSource, and list three fields the template displays with Eval.',
 N'Data binding connects a collection to a control|Always set DataSource and then call DataBind()|Eval reads one field of the current record inside a template|ListItem elements cannot hold binding expressions, so bind the whole list from code', N'ASPX', 1, 1),

-- Lesson 22
(@Mod4,
 N'GridView with SQL Server',
 N'Following one request from the GridView, through the layers, to SQL Server and back.',
 N'Draw the path data takes from SQL Server to a GridView|Explain the job of the page, the BLL and the DAL|Format GridView columns and show a friendly message when there are no rows',
 N'In a real application the GridView never talks to SQL Server directly. CodeFusion keeps each responsibility in its own layer. The ASP.NET Web Form shows data and responds to clicks. The code-behind decides when to load data. The Business Logic Layer (BLL, for example EmployeeBLL) holds the rules and turns database rows into objects. The Data Access Layer (DAL, DBHelper) is the only place that creates connections and runs SQL. Then comes SQL Server itself.

A request to show employees travels like this: Web Form, then code-behind, then EmployeeBLL.GetAll(), then DBHelper.ExecuteQuery(), then SQL Server. The result travels back up the same way: SQL Server returns rows, DBHelper puts them in a DataTable, EmployeeBLL converts them into a List of Employee objects, and the page assigns that list to the GridView.

This separation has real benefits. Pages stay short and readable. SQL appears in one place. If the database changes, only the BLL and DAL are edited, not every page. And because the BLL checks the data, the rules apply no matter which page calls it.

On the GridView itself, define columns explicitly with BoundField so you control headings and formatting. DataFormatString="{0:C0}" shows a number as currency with no decimals. An EmptyDataTemplate gives a friendly message instead of a blank space when the list is empty.',
 N'Web Form -> Code-behind -> BLL -> DAL (DBHelper) -> SQL Server',
 N'<asp:GridView ID="gvEmployees" runat="server" AutoGenerateColumns="false">
    <Columns>
        <asp:BoundField DataField="Name" HeaderText="Name" />
        <asp:BoundField DataField="Department" HeaderText="Department" />
        <asp:BoundField DataField="Salary" HeaderText="Salary" DataFormatString="{0:C0}" />
    </Columns>
    <EmptyDataTemplate>No employees yet.</EmptyDataTemplate>
</asp:GridView>

// Code-behind
private void BindGrid()
{
    gvEmployees.DataSource = EmployeeBLL.GetAll();
    gvEmployees.DataBind();
}

// BLL
public static List<Employee> GetAll()
{
    DataTable dt = DBHelper.ExecuteQuery(
        "SELECT EmployeeID, Name, Email, Department, Salary FROM Employee ORDER BY EmployeeID DESC");
    // ... convert each DataRow to an Employee and add to a list
}',
 N'AutoGenerateColumns="false" means only the columns you list are shown.|Each BoundField links one column of the grid to one property of Employee through DataField.|DataFormatString="{0:C0}" formats the salary as currency.|BindGrid() is a small helper that the page can call after every change so the grid always shows fresh data.|EmployeeBLL.GetAll() contains the SELECT statement; the page itself contains no SQL.|DBHelper.ExecuteQuery runs the SQL through the shared connection logic and returns a DataTable.',
 N'A table with the headings Name, Department and Salary and one row per employee. Salaries appear formatted as currency, and with no data the message No employees yet. appears instead of an empty table.',
 N'The Employee list in CodeFusion''s CRUD Lab, the Admin student list and the quiz history all use this pattern: a GridView with explicit BoundFields, filled by a BLL method that calls DBHelper.',
 N'Writing SQL directly in the page''s code-behind, which makes the page hard to maintain and the SQL hard to reuse.|Forgetting to call BindGrid() again after an insert, update or delete, so the grid keeps showing old data.',
 N'If the grid still shows old data after a save, call BindGrid() after the change has been saved.|If a column is blank, check the DataField spelling matches the property name of the object being bound.',
 N'Open Practice/CrudLab.aspx.cs and EmployeeBLL.cs. On paper, draw the five steps data takes from SQL Server to gvEmployees, naming the method used at each step.',
 N'The page shows data; the BLL holds rules; the DAL runs SQL|Data travels Web Form, BLL, DAL, SQL Server and back|BoundField gives control over headings and formatting|EmptyDataTemplate gives a friendly message when there are no rows', N'ASPX', 2, 1),

-- Lesson 23
(@Mod4,
 N'Create Operation',
 N'Adding a new record: form, validation, business rules and a parameterised INSERT.',
 N'Build a form with validators that collects the data for a new record|Explain why validation happens both in the page and in the BLL|Run a parameterised INSERT and show a confirmation message',
 N'Create is the C in CRUD: adding a new row to the table. A Create feature always has the same four parts. A form collects the values. Validators check them. A Click handler builds an object and passes it to the BLL. The BLL validates again and runs an INSERT through the DAL.

Validation happens twice on purpose. Validators in the page (RequiredFieldValidator, RegularExpressionValidator, RangeValidator) give instant feedback, and code-behind starts with if (!Page.IsValid) return; so invalid data is never processed. The BLL then checks the same rules again in C#, because other pages or tools might call the BLL, and the BLL must never trust its caller. This is the same server-side principle you met in Module 1.

The INSERT itself is always parameterised. In CodeFusion, DBHelper.ExecuteInsertReturnId adds SELECT CAST(SCOPE_IDENTITY() AS INT) after the INSERT so you also get the new row''s ID back; SCOPE_IDENTITY returns the identity value that was just generated in the current scope.

Give the user clear feedback. After a successful save, show a message, clear the form and rebind the grid. If the BLL returns an error message, show it instead and keep what the user typed so they can fix it.',
 N'INSERT INTO Employee (Name, Email, Department, Salary)
VALUES (@Name, @Email, @Dept, @Salary);',
 N'// Code-behind
protected void btnSave_Click(object sender, EventArgs e)
{
    if (!Page.IsValid) return;

    var emp = new Employee
    {
        Name = txtName.Text.Trim(),
        Email = txtEmail.Text.Trim(),
        Department = ddlDepartment.SelectedValue,
        Salary = decimal.Parse(txtSalary.Text.Trim())
    };

    string error = EmployeeBLL.Create(emp);
    if (error != string.Empty) { lblMessage.Text = error; return; }

    lblMessage.Text = "Employee saved.";
    BindGrid();
}

// BLL
public static string Create(Employee emp)
{
    string error = Validate(emp);
    if (error != string.Empty) return error;

    DBHelper.ExecuteInsertReturnId(
        "INSERT INTO Employee (Name, Email, Department, Salary) VALUES (@Name, @Email, @Dept, @Salary)",
        DBHelper.Param("@Name", emp.Name), DBHelper.Param("@Email", emp.Email),
        DBHelper.Param("@Dept", emp.Department), DBHelper.Param("@Salary", emp.Salary));
    return string.Empty;
}',
 N'if (!Page.IsValid) return; stops processing if any validator on the page failed.|The Employee object is built from the form values; Trim removes accidental spaces.|EmployeeBLL.Create(emp) is the only line that touches data; the page does not know any SQL.|The BLL returns an empty string on success or a friendly message on failure, so the page can show it without handling exceptions.|Validate(emp) re-checks the rules on the server.|DBHelper.Param(...) builds a SqlParameter for each value, so nothing the user typed is ever joined into the SQL text.',
 N'Filling in valid details and clicking Save shows Employee saved. and the new employee appears in the grid. Leaving the email empty or invalid shows an error and nothing is inserted.',
 N'Register, the Admin Add Module and Add Lesson forms, the quiz question form and the CRUD Lab all follow this exact Create pattern: validate, hand an object to the BLL, run a parameterised INSERT, then confirm.',
 N'Relying on page validators only and not validating again in the BLL.|Building the INSERT by joining text from the TextBoxes, which allows SQL injection and breaks on names containing an apostrophe.',
 N'If clicking Save does nothing, a validator is probably failing silently; add a ValidationSummary or check each validator''s error message.|If you see Cannot insert the value NULL into column, a required column was not supplied.',
 N'Open EmployeeBLL.cs and find Validate. List every rule it checks, then try saving an employee in the CRUD Lab that breaks each rule and note the message you get.',
 N'Create adds a new row with INSERT|Validate in the page for speed and again in the BLL for safety|Always pass values as parameters|After saving, show a message and rebind the grid', N'CSharp', 3, 1),

-- Lesson 24
(@Mod4,
 N'Read and Search Operation',
 N'Showing one record by ID, and letting the user search many records with LIKE.',
 N'Fetch a single record by its primary key|Add a search box that filters records using LIKE and a parameter|Show a helpful message when a search finds nothing',
 N'Read is the R in CRUD, and it has two common forms. Reading a list means SELECT without a narrow filter. Reading one record means selecting by primary key, for example SELECT ... FROM Employee WHERE EmployeeID = @Id. The first row of the result (or null if there is none) becomes your object. The CRUD Lab uses this when you click Edit: it reads that one employee and puts the values into the form.

Search lets users narrow a long list. The tool is LIKE with the % wildcard. WHERE Name LIKE @Kw matches any name that fits the pattern, and by building the pattern as "%" + keyword + "%" in C# you match the keyword anywhere in the text. As always the whole pattern is passed as a parameter, never joined into the SQL string.

A good search feature handles three cases. If the box is empty, show everything. If there are matches, show them. If nothing matches, tell the user clearly instead of leaving a blank table. You can search several columns at once by combining conditions with OR.

CodeFusion already uses this pattern: AdminBLL.SearchStudents and MaterialBLL.Search build their SQL based on whether a keyword was entered and pass the pattern as a parameter. Adding a search box to the Employee CRUD Lab uses exactly the same idea.',
 N'SELECT ... FROM Table WHERE KeyColumn = @Id;
SELECT ... FROM Table WHERE Column LIKE @Kw;',
 N'-- SQL
SELECT EmployeeID, Name, Email, Department, Salary
FROM Employee
WHERE Name LIKE @Kw OR Department LIKE @Kw
ORDER BY Name;

// BLL
public static List<Employee> Search(string keyword)
{
    DataTable dt = DBHelper.ExecuteQuery(
        "SELECT EmployeeID, Name, Email, Department, Salary FROM Employee " +
        "WHERE Name LIKE @Kw OR Department LIKE @Kw ORDER BY Name",
        DBHelper.Param("@Kw", "%" + keyword + "%"));
    // ... convert rows to a List<Employee> and return it
}

// Code-behind
protected void btnSearch_Click(object sender, EventArgs e)
{
    var results = EmployeeBLL.Search(txtSearch.Text.Trim());
    gvEmployees.DataSource = results;
    gvEmployees.DataBind();
    lblSearchInfo.Text = results.Count == 0 ? "No employees match your search." : "";
}',
 N'WHERE Name LIKE @Kw OR Department LIKE @Kw matches the keyword in either column.|ORDER BY Name sorts the matches alphabetically.|"%" + keyword + "%" is C# code that builds the pattern; the finished pattern is passed in as the @Kw parameter value.|The Click handler reads the keyword, asks the BLL for matches and rebinds the grid.|The label gives a friendly message when the result list is empty.',
 N'Typing eng and clicking Search shows only employees whose name or department contains eng, such as the Engineering department. Typing something that matches nothing shows the message No employees match your search.',
 N'Every search box you use online works on this idea. In CodeFusion the Admin Students page, the Materials page and the Study Materials filter all search with LIKE and a parameter.',
 N'Joining the keyword into the SQL text instead of passing it as a parameter, which allows SQL injection.|Forgetting the % wildcards, so only exact matches are found.',
 N'If a search finds nothing when it should, check the wildcards were added around the keyword and that the column names are correct.|If searching for an empty box returns nothing, decide whether an empty search should show all records and handle that case explicitly.',
 N'Add a TextBox, a Search button and a Label to the CRUD Lab, write EmployeeBLL.Search as shown, and test it with part of a name and with a word that matches nothing.',
 N'Read can mean one record by ID or many records by search|LIKE with % wildcards searches text|Build the pattern in C# and pass it as a parameter|Always tell the user when nothing was found', N'SQL', 4, 1),

-- Lesson 25
(@Mod4,
 N'Update and Delete Operations',
 N'Editing an existing record and removing one safely, with confirmation and a WHERE on the key.',
 N'Load a selected row into the form for editing using CommandName and CommandArgument|Run a parameterised UPDATE that targets exactly one row|Add a confirmation prompt before DELETE',
 N'Update and Delete complete CRUD. Both act on an existing row, so both must identify it by its primary key. In a GridView each row''s Edit and Delete buttons use CommandName ("EditEmp", "DeleteEmp") and CommandArgument (the EmployeeID). The GridView''s RowCommand event then tells you which button and which row were clicked.

For Edit, the handler reads the record by ID (the Read operation from the previous lesson), copies its values into the form and stores the ID in a HiddenField. The same Save button now means update: if the hidden ID is 0 the handler calls Create, otherwise it calls Update. Changing the button text to Update employee and showing a Cancel button makes this clear to the user.

The UPDATE statement ends with WHERE EmployeeID = @Id. Without WHERE it would change every row. For Delete, also use WHERE EmployeeID = @Id, and ask the user to confirm first. OnClientClick="return confirm(''Delete this employee?'');" shows a browser prompt, and returning false cancels the postback. After either change, rebind the grid and reset the form.

Remember the rows-affected number from ExecuteNonQuery. If an update or delete reports 0 rows, the row no longer exists, perhaps because another user deleted it, and you can tell the user.',
 N'UPDATE Table SET Col = @Value WHERE KeyCol = @Id;
DELETE FROM Table WHERE KeyCol = @Id;',
 N'<asp:LinkButton ID="btnDelete" runat="server" CommandName="DeleteEmp"
    CommandArgument=''<%# Eval("EmployeeID") %>''
    OnClientClick="return confirm(''Delete this employee?'');">Delete</asp:LinkButton>

// Code-behind
protected void gvEmployees_RowCommand(object sender, GridViewCommandEventArgs e)
{
    int id = Convert.ToInt32(e.CommandArgument);

    if (e.CommandName == "EditEmp")
    {
        Employee emp = EmployeeBLL.GetById(id);
        hfEmployeeId.Value = emp.EmployeeID.ToString();
        txtName.Text = emp.Name;
        btnSave.Text = "Update employee";
    }
    else if (e.CommandName == "DeleteEmp")
    {
        EmployeeBLL.Delete(id);
        BindGrid();
    }
}

// DAL call used by the BLL
DBHelper.ExecuteNonQuery(
    "UPDATE Employee SET Name = @Name, Salary = @Salary WHERE EmployeeID = @Id",
    DBHelper.Param("@Name", emp.Name), DBHelper.Param("@Salary", emp.Salary), DBHelper.Param("@Id", emp.EmployeeID));',
 N'CommandName says what to do and CommandArgument says to which row; one RowCommand handler serves every row.|OnClientClick="return confirm(...)" runs in the browser; if the user presses Cancel it returns false and the postback never happens.|Convert.ToInt32(e.CommandArgument) turns the row ID, passed as text, into a number.|For EditEmp the handler loads the record with GetById, fills the form, and stores the ID in a HiddenField so Save knows it is an update.|For DeleteEmp the BLL runs DELETE ... WHERE EmployeeID = @Id and the grid is refreshed.|The UPDATE has a WHERE on the primary key so only that one employee changes.',
 N'Clicking Edit fills the form with that employee and changes the button to Update employee. Saving updates just that row. Clicking Delete asks for confirmation; choosing OK removes the row and the grid refreshes, choosing Cancel does nothing.',
 N'Every Edit and Delete link in CodeFusion, from the CRUD Lab to the Admin pages for students, modules, lessons and quizzes, uses this CommandName, CommandArgument and RowCommand design with a confirmation on delete.',
 N'Forgetting WHERE on UPDATE or DELETE, which changes or deletes every row.|Not storing the ID of the record being edited, so the Save button cannot tell an update from a new record.',
 N'If Edit works but Save creates a new row instead of updating, the hidden ID is not being stored or is not being read in Save.|If Delete runs without asking, check the OnClientClick text includes return before confirm.',
 N'Open CrudLab.aspx and CrudLab.aspx.cs. Trace what happens, line by line, when you click Edit on a row and then click Update, naming where the ID is stored and where UPDATE is run.',
 N'Update and Delete must always target one row by its primary key|CommandName and CommandArgument identify the clicked row|A HiddenField can remember which record is being edited|Confirm before deleting, then refresh the grid', N'CSharp', 5, 1),

-- Lesson 26
(@Mod4,
 N'Complete ASP.NET CRUD Application',
 N'Putting every part together: a full Employee manager with the three-tier architecture.',
 N'List the files and responsibilities in a complete CRUD application|Follow a Save click through every layer|Plan and build a small CRUD page on your own',
 N'You now know every piece of a database-driven Web Forms application. A complete CRUD feature is made from five small parts that work together.

1. The entity (Employee.cs) is a simple class with one property per column. 2. The Data Access Layer (DBHelper.cs) provides ExecuteQuery, ExecuteNonQuery, ExecuteScalar and ExecuteInsertReturnId and is the only code that opens connections. 3. The Business Logic Layer (EmployeeBLL.cs) has GetAll, GetById, Search, Create, Update, Delete and Validate; it contains every rule and every SQL statement for employees. 4. The Web Form (CrudLab.aspx) holds the form with validators, the GridView and the buttons. 5. The code-behind (CrudLab.aspx.cs) connects clicks to BLL calls and refreshes the display.

Follow one Save click: the browser posts the form; validators run; btnSave_Click checks Page.IsValid; it builds an Employee object and calls EmployeeBLL.Create; the BLL validates and calls DBHelper.ExecuteInsertReturnId with a parameterised INSERT; SQL Server stores the row and returns the new ID; control returns to the page, which shows a message and rebinds the grid.

When you build your own CRUD page, follow the same order. Create the table, then the entity, then the BLL methods (test them), then the page. Write the SQL once in the BLL, always with parameters, validate on the server, give friendly messages, never show raw database errors, and keep each layer focused on its own job.',
 N'Table -> Entity -> BLL (rules + SQL) -> DAL (connection) -> Web Form + code-behind',
 N'// The BLL is the heart of the feature
public static class EmployeeBLL
{
    public static List<Employee> GetAll()          { /* SELECT */ }
    public static Employee GetById(int id)          { /* SELECT ... WHERE EmployeeID = @Id */ }
    public static List<Employee> Search(string kw)  { /* SELECT ... LIKE @Kw */ }
    public static string Create(Employee emp)       { /* Validate, INSERT */ }
    public static string Update(Employee emp)       { /* Validate, UPDATE ... WHERE */ }
    public static void Delete(int id)                { /* DELETE ... WHERE */ }
}

// The page only coordinates
protected void btnSave_Click(object sender, EventArgs e)
{
    if (!Page.IsValid) return;
    string error = (hfEmployeeId.Value == "0")
        ? EmployeeBLL.Create(BuildEmployee())
        : EmployeeBLL.Update(BuildEmployee());
    // show message, reset form, BindGrid()
}',
 N'The BLL class lists one method for each CRUD action plus a search, so everything about employees is in one place.|Create and Update return a string: empty for success, or a message to show the user.|Read methods return objects or lists; Delete needs no message because it only needs the ID.|The page contains no SQL, only calls to the BLL and updates to the screen.|The hidden ID value decides whether Save creates a new employee or updates an existing one.|BuildEmployee() is a helper that copies form values into an Employee object so the handler stays short.',
 N'A single page where you can add employees, see them in a grid, search them, edit any row and delete any row, with validation messages, confirmation before deleting and a refreshed grid after every change.',
 N'Almost every business application, from a school register to an online shop, is made of CRUD pages like this. CodeFusion''s Admin panel is a collection of them: modules, lessons, quizzes, questions, challenges, materials and students.',
 N'Putting SQL, validation and display code all in the page, which makes the page long and hard to fix.|Skipping server-side validation or error handling because the form looked fine during a quick test.',
 N'If something fails, find which layer is responsible: the page (events, display), the BLL (rules, SQL) or the DAL (connection). Use breakpoints to see which layer the problem first appears in.|If you see a raw database error, catch it in the BLL and return a friendly message instead.',
 N'Choose a new small entity such as Book (BookID, Title, Author, Price). Write the table, the entity class, a BookBLL with the six methods, and a page with a form and a GridView. Test every operation, including invalid input.',
 N'A complete CRUD feature has a table, an entity, a BLL, a DAL and a page|The BLL holds the rules and the SQL; the page only coordinates|Always validate on the server and use parameters|Show friendly messages, never raw database errors', N'CSharp', 6, 1);

PRINT '--- Module 4: 6 lessons inserted ---';
GO

-- ---------- Mini quiz questions (3 per lesson) ----------
DECLARE @L21 INT = (SELECT LessonID FROM Lesson WHERE Title = N'Data Binding in ASP.NET Web Forms');
DECLARE @L22 INT = (SELECT LessonID FROM Lesson WHERE Title = N'GridView with SQL Server');
DECLARE @L23 INT = (SELECT LessonID FROM Lesson WHERE Title = N'Create Operation');
DECLARE @L24 INT = (SELECT LessonID FROM Lesson WHERE Title = N'Read and Search Operation');
DECLARE @L25 INT = (SELECT LessonID FROM Lesson WHERE Title = N'Update and Delete Operations');
DECLARE @L26 INT = (SELECT LessonID FROM Lesson WHERE Title = N'Complete ASP.NET CRUD Application');

INSERT INTO LessonQuizQuestion (LessonID, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, DisplayOrder) VALUES
(@L21, N'Which call actually displays the data after setting DataSource?', N'Render()', N'DataBind()', N'Load()', N'Refresh()', 'B', 1),
(@L21, N'What does <%# Eval("Name") %> do inside a template?', N'Reads the Name field of the current record', N'Creates a new field', N'Deletes the record', N'Connects to the database', 'A', 2),
(@L21, N'Why can a ListItem not contain a <%# %> binding expression?', N'It is not a full control, so it has no DataBinding event', N'It is too slow', N'It is only for CSS', N'It can, with no limits', 'A', 3),

(@L22, N'Which layer should be the only place that opens database connections?', N'The Web Form', N'The Data Access Layer', N'The GridView', N'The master page', 'B', 1),
(@L22, N'What does AutoGenerateColumns="false" mean?', N'No data is shown', N'Only the columns you define are shown', N'Columns are sorted', N'The grid is read only', 'B', 2),
(@L22, N'What does an EmptyDataTemplate display?', N'A message when there are no rows', N'The first row only', N'The SQL query', N'The connection string', 'A', 3),

(@L23, N'Why validate in both the page and the BLL?', N'It is faster', N'The BLL must not trust its caller, and the page gives instant feedback', N'Validators do not work', N'Only the BLL is allowed to validate', 'B', 1),
(@L23, N'What does SCOPE_IDENTITY() return?', N'The last identity value generated in the current scope', N'The table name', N'The row count', N'The connection string', 'A', 2),
(@L23, N'How must the user''s text reach an INSERT statement?', N'Joined into the SQL text', N'As a parameter', N'Through a Label', N'Through the URL only', 'B', 3),

(@L24, N'Which SQL keyword searches for a text pattern?', N'LIKE', N'ORDER', N'COUNT', N'JOIN', 'A', 1),
(@L24, N'What does % mean in a LIKE pattern?', N'Any run of characters', N'A percentage', N'The end of the query', N'A comment', 'A', 2),
(@L24, N'What should a search do when nothing matches?', N'Show a blank page', N'Show a friendly message', N'Delete the table', N'Restart the page', 'B', 3),

(@L25, N'What must every UPDATE and DELETE include to affect only one row?', N'ORDER BY', N'A WHERE on the primary key', N'LIKE', N'GROUP BY', 'B', 1),
(@L25, N'What does OnClientClick="return confirm(...)" do?', N'Asks the user before the postback happens', N'Runs SQL', N'Deletes the grid', N'Validates the form', 'A', 2),
(@L25, N'Why store the record ID in a HiddenField during editing?', N'So Save knows it is an update of that record', N'To hide the form', N'To make the page faster', N'To encrypt the data', 'A', 3),

(@L26, N'Where should the SQL for employees live?', N'In every page', N'In the BLL, using parameters', N'In the CSS file', N'In the master page', 'B', 1),
(@L26, N'What should the page''s code-behind mainly do in a CRUD page?', N'Run SQL directly', N'Coordinate: call the BLL and update the display', N'Store the database', N'Create tables', 'B', 2),
(@L26, N'What should users see when a database error occurs?', N'The full raw error', N'A friendly message', N'Nothing at all', N'The connection string', 'B', 3);

PRINT '--- Module 4: mini quiz questions inserted ---';
GO

-- ---------- Verification (self-contained) ----------
SELECT
    (SELECT COUNT(*) FROM Lesson WHERE ModuleID = (SELECT ModuleID FROM Module WHERE ModuleOrder = 4)) AS Module4LessonCount,
    (SELECT COUNT(*) FROM LessonQuizQuestion WHERE LessonID IN
        (SELECT LessonID FROM Lesson WHERE ModuleID = (SELECT ModuleID FROM Module WHERE ModuleOrder = 4))) AS Module4QuizQuestionCount,
    (SELECT COUNT(*) FROM Lesson) AS TotalLessonCount;
GO