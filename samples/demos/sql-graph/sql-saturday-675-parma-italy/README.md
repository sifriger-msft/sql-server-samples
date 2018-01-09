# SQL Server 2017 Graph Database

These demos are related to the session that [Sergio Govoni](https://mvp.microsoft.com/it-it/PublicProfile/4029181?fullName=Sergio%20Govoni) has done at the PASS SQL Saturday 675 in Parma (Italy). For those who don't already know the SQL Saturday events: Since 2007, the PASS SQL Saturday program provides to users around the world the opportunity to organize free training sessions on SQL Server and related technologies. SQL Saturday is an event sponsored by PASS and therefore offers excellent opportunities for training, professional exchange and networking. You can find all details in this page [About PASS SQL Saturday](http://www.sqlsaturday.com/about.aspx).

The demos are based on [WideWorldImporters](https://github.com/Microsoft/sql-server-samples/tree/master/samples/databases/wide-world-importers) sample database.

### Contents

[About this sample](#about-this-sample)<br/>
[Before you begin](#before-you-begin)<br/>
[Run this sample](#run-this-sample)<br/>
[Disclaimers](#disclaimers)<br/>
[Related links](#related-links)<br/>

<a name=about-this-sample></a>

## About this sample

1. **Applies to:**
	- Azure SQL Database v12 (or higher)
	- SQL Server 2017 (or higher)
2. **Demos:**
	- Build and populating nodes and edges tables
        - The new MATCH function
	- Build a recommendation system for sales offers
3. **Workload:**  Queries executed on [WideWorldImporters](https://github.com/Microsoft/sql-server-samples/releases/tag/wide-world-importers-v1.0)
4. **Programming Language:** T-SQL
5. **Authors:** [Sergio Govoni](https://mvp.microsoft.com/it-it/PublicProfile/4029181?fullName=Sergio%20Govoni)

<a name=before-you-begin></a>

## Before you begin

To run these demos, you need the following prerequisites.

**Account and Software prerequisites:**

1. Either
	- Azure SQL Database v12 (or higher)
	- SQL Server 2017 (or higher)
2. SQL Server Management Studio 17.x (or higher)

**Azure prerequisites:**

1. An Azure subscription. If you don't already have an Azure subscription, you can get one for free here: [get Azure free trial](https://azure.microsoft.com/en-us/free/)

2. When your Azure subscription is ready to use, you have to create an Azure SQL Database, to do that, you must have completed the first three steps explained in [Design your first Azure SQL database](https://docs.microsoft.com/en-us/azure/sql-database/sql-database-design-first-database)

<a name=run-this-sample></a>

## Run this sample

### Setup

#### Azure SQL Database Setup

1. Download the **WideWorldImporters-Standard.bacpac** from the WideWorldImporters database [page](https://github.com/Microsoft/sql-server-samples/releases/tag/wide-world-importers-v1.0)

2. Import the **WideWorldImporters-Standard.bacpac** bacpac file to your Azure subscription. This [article](https://www.sqlshack.com/import-sample-bacpac-file-azure-sql-database/) on SQL Shack explains how to import WideWorldImporters database to an Azure SQL Database, anyway, the instructions are valid for any bacpac file

3. Launch SQL Server Management Studio and connect to the newly created WideWorldImporters-Standard database

#### SQL Server Setup

1. Download **WideWorldImporters-Full.bak** from the WideWorldImporters database [page](https://github.com/Microsoft/sql-server-samples/releases/tag/wide-world-importers-v1.0)

2. Launch SQL Server Management Studio, connect to your SQL Server instance (2017) and restore **WideWorldImporters-Full.bak**. For further information about how to restore a database backup using SQL Server Management Studio, you can refer to this article: [Restore a Database Backup Using SSMS](https://docs.microsoft.com/en-us/sql/relational-databases/backup-restore/restore-a-database-backup-using-ssms). Once you have restored the WideWorldImporters database, you can connect it using the **USE** command like this:

```SQL
USE [WideWorldImporters]
```

The purpose of the file **sqlsat675 10 Setup.sql** is to connect the database WideWorldImporters and create two new schema: **Edges** and **Nodes**.


### Create graph objects

The first demo consists in creating graph objects such as Nodes and Edges. This is the purpose of the file **sqlsat675 20 Nodes and Edges.sql**. Let's start with the Node table named **Nodes.Person**. A node table represents an entity in a Graph DB, every time a node is created, in addition to the user defined columns, the SQL Server Engine will create an implicit column named **$node_id** that uniquely identifies a given node in the database, it contains a combination of the **object_id** of the node and an internally bigint stored in an hidden column named **graph_id**.

The following picture shows the CREATE statement with the new DDL extension **AS NODE**, this extension tells to the engine that we want to create an Node table.

![Picture 1](../../../../media/demos/sql-graph/Create%20a%20Node%20Table.png)

Now, it's the time to create the Edge table named **Edges.Friends**. Every Edge represents a relationship in a graph, may or may not have any user defined attributes, Edges are always directed and connected with two nodes. In the first release, constraints are not available on the Edge table, so an Edge table can connect any two nodes on the graph. Every time an Edge table is created, in addition to the user defined columns, the Engine will create three implicit columns:

1. **$edge_id** is a combination of the **object_id** of the Edge and an internally bigint stored in an hidden column named **graph_id**

2. **$from_id** stores the **$node_id** of the node where the Edge starts from

3. **$to_id** stores the **$node_id** of the node at which the Edge ends


The following picture shows the CREATE statement with the new DDL extension **AS EDGE**, this extension tells to the engine that we want to create an Edge table.

![Picture 2](../../../../media/demos/sql-graph/Create%20an%20Edge%20Table.png)

The file **sqlsat675 20 Nodes and Edges.sql** contains the statements to populate the node **Nodes.Person** and the edge **Edges.Friends** starting from the table **Application.People** of WideWorldImporters DB.

The new T-SQL MATCH function allows you to specify the search pattern for a graph schema, it can be used only with graph Node and Edge tables in SELECT statements as a part of the WHERE clause. Based on the node **Nodes.Person** and the edge **Edges.Friends**, the file **sqlsat675 20 Nodes and Edges.sql** contains the following sample query:

1. List of all guys that speak finnish with friends (Pattern: Node > Relationship > Node)

2. List of the top 5 people who have friends that speak Greek in the first and second connections

3. People who have common friends that speak Croatian

The search pattern, provided in the MATCH function, goes through one node to another by an edge, in the direction provided by the arrow. Edge names or aliases are provided inside parenthesis. Node names or aliases appear at the two ends of the arrow.

<a name=disclaimers></a>

## Disclaimers

The code included in this sample is not intended to be a set of best practices on how to build scalable enterprise grade applications. This is beyond the scope of this quick start sample.

<a name=related-links></a>

## Related Links

For more information about Graph DB in SQL Server 2017, see these articles:

1. [Graph processing with SQL Server and Azure SQL Database](https://docs.microsoft.com/en-us/sql/relational-databases/graphs/sql-graph-overview)

2. [SQL Graph Architecture](https://docs.microsoft.com/en-us/sql/relational-databases/graphs/sql-graph-architecture)

3. [Arvind Shyamsundar's Blog](https://blogs.msdn.microsoft.com/arvindsh/)
