<!-- Always leave the MS logo -->
![](https://github.com/microsoft/sql-server-samples/blob/master/media/solutions-microsoft-logo-small.png)

# Alter a column with dependencies in your SQL Server database with sp_alter_column!

This sample describes how to manage the error message 5074 when you alter a column with dependencies in your SQL Server database!

### Contents

[About this sample](#about-this-sample)<br/>
[Before you begin](#before-you-begin)<br/>
[Case history](#case-history)<br/>
[Run this sample](#run-this-sample)<br/>
[Sample details](#sample-details)<br/>
[Disclaimers](#disclaimers)<br/>
[Related links](#related-links)<br/>

<a name=about-this-sample></a>

## About this sample

- **Applies to:** SQL Server 2012 (or higher)
- **Key features:** Alter a column with dependencies
- **Workload:** [AdventureWorks](https://github.com/Microsoft/sql-server-samples/releases/tag/adventureworks)
- **Programming Language:** T-SQL
- **Authors:** [Sergio Govoni](https://www.linkedin.com/in/sgovoni/) | [Microsoft MVP Profile](https://mvp.microsoft.com/it-it/PublicProfile/4029181?fullName=Sergio%20Govoni) | [Blog](https://segovoni.medium.com/) | [GitHub](https://github.com/segovoni) | [Twitter](https://twitter.com/segovoni)

<a name=before-you-begin></a>

## Before you begin

To run this example, the following basic concepts are required.

Changing the column name is not a trivial operation especially if the column is referenced in Views, Stored Procedures etc. To execute the rename of a column, there is the [sp_rename](https://learn.microsoft.com/sql/relational-databases/system-stored-procedures/sp-rename-transact-sql?WT.mc_id=DP-MVP-4029181) system Stored Procedure, but for changing the data type of the column, if you don't want to use any third-party tools, you have no other option than to manually create a T-SQL script.


**Software prerequisites:**

1. A copy of AdventureWorks sample database on your SQL Server instance!

<a name=case-history></a>

## Case history

It could has happened to you to change the data type or the name of a column and be faced with the [error message 5074](https://learn.microsoft.com/sql/relational-databases/errors-events/database-engine-events-and-errors#errors-5000-to-5999) which indicates that it is impossible to modify the column due to the presence of linked objects such as Primary Keys, Foreign Keys, Indexes, Constraints, Statistics and so on.

This is the error you probably faced on:

```sql
Msg 5074, Level 16, State 1, Line 1135 — The object 'objectname' is dependent on column 'columnname'.

Msg 4922, Level 16, State 9, Line 1135 — ALTER TABLE ALTER COLUMN columnname failed because one or more objects access this column.
```

<a name=run-this-sample></a>

## Run this sample

<!-- Step by step instructions -->

1. Open a query connected to your copy of AdventureWorks database and execute the command `ALTER TABLE [Person].[Person] ALTER COLUMN [FirstName] VARCHAR(100);`
2. See the message error 5074 `The index 'IX_Person_LastName_FirstName_MiddleName' is dependent on column 'FirstName'.`
3. Download sp_alter_column stored procedure from [this GitHub repository](https://github.com/segovoni/sp_alter_column).
4. Install sp_alter_column in your copy of AdventureWorks database
5. Alter the [Person].[Person] column using this command `EXEC sp_alter_column @schemaname='Person', @tablename='Person', @columnname='FirstName', @datatype='VARCHAR(100)', @executionmode=1`;
7. Have fun with sp_alter_column

**The challenge**

Just changing the name is not a trivial operation especially when the column is referenced in others database objects like Views, Indexes, Statistics etc. To rename a column in a table, there is the sp_rename system Stored Procedure, but for changing the data type of the column, if you don’t want to use any third-party tools, you have no other option than to manually write T-SQL code to do that.

**How had you solved the problem?**

Some of you have probably deleted manually the linked objects, next you have changed the data type of the column, the size where expected or the properties and then you have recreated the previously deleted objects manually. You have been very careful to not change the properties of the objects themselves during DROP and CREATE operations.

I faced several times this issue, so I decided to create a stored procedure that is able to compose automatically the appropriate DROP and CREATE commands for each object connected to the column I want to modify. Thus was born the sp_alter_column stored procedure which is now available on GitHub here: [https://github.com/segovoni/sp_alter_column](https://github.com/segovoni/sp_alter_column).

**How the sp_alter_column works**

After the input parameters has been checked, sp_alter_column identifies objects that depend on the column you want to modify and, based on the type of the object, it generates the appropriate DROP and CREATE T-SQL commands for the following execution. All the T-SQL commands composed automatically are stored in a temporary table managed by the stored procedure.

sp_alter_column is able to identify and generate, for the identified objects, the DROP/CREATE commands for the following database objects (which may have dependencies with a column):

- Primary keys
- Foreign keys
- Default constraints
- Unique constraints
- Check constraints
- Indexes
- Statistics
- Views

The parameter executionmode defines the execution mode of the Stored Procedure.

The value Zero (default, preview mode) indicates that DROP/CREATE commands will not have to be applied, they will be only displayed as output. The sp_alter_column will display only the T-SQL commands needed to change the data type of the column or its name. This execution mode is particularly suitable for becoming familiar with the Stored Procedure or when you want to have more control over the commands that will be executed, leaving to the sp_alter_column only the job of generating them.

The value One (executive mode) given to the parameter executionmode indicates to the Stored Procedure that caller wants to apply the T-SQL commands needed to change the data type of the column or its name. Changes will be performed within an explicit transaction; the Commit will be applied at the end of all operations if all of them has been executed successfully. If something goes wrong a `rollback` will be executed.

**How to debug the sp_alter_column stored procedure**

The most important programming languages have debugging tools integrated into the development tool. Debugger usually has a graphic interface that allows you to inspect the variables values and other things at run-time to analyze source code and program flow row-by-row and finally the debugger allows you to manage breakpoints.

Each developer loves debugging tools because they are very useful when a program fails in a calculation or when it runs into an error. Now, think about our Stored Procedure that performs complex operations silently and suppose that it runs into a problem; probably, this question comes to your mind: “Can I debug a Stored Procedure?” and if it is possible, “How can I do that?”

Debugging a stored procedure is possible with Microsoft Visual Studio development tool.

<a name=sample-details></a>

## Sample details

According to the conversion rules between data types described in [this article](https://docs.microsoft.com/sql/t-sql/functions/cast-and-convert-transact-sql?WT.mc_id=DP-MVP-4029181), the sp_alter_column stored procedure allows you to easily modify the data type of a column or its name, enjoy!

<a name=disclaimers></a>

## Disclaimers

The code included in this sample is not intended to be an all-encompassing solution for modifying a column with dependencies in a SQL Server database. This is beyond the scope of this quick start sample. Do not use in production environments until you have tested the solution in your scenario. The author is not responsible for the use of sp_alter_column.

<a name=related-links></a>

## Related Links
<!-- Links to more articles. Remember to delete "en-us" from the link path. -->

For more information:

- [ALTER TABLE](https://learn.microsoft.com/sql/t-sql/statements/alter-table-transact-sql?WT.mc_id=DP-MVP-4029181)
- [sp_rename](https://learn.microsoft.com/sql/relational-databases/system-stored-procedures/sp-rename-transact-sql?WT.mc_id=DP-MVP-4029181)
