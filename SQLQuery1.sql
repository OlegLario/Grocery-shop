﻿if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('"Order"') and o.name = 'FK_ORDER_REFERENCE_CUSTOMER')
alter table "Order"
   drop constraint FK_ORDER_REFERENCE_CUSTOMER
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('OrderItem') and o.name = 'FK_ORDERITE_REFERENCE_ORDER')
alter table OrderItem
   drop constraint FK_ORDERITE_REFERENCE_ORDER
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('OrderItem') and o.name = 'FK_ORDERITE_REFERENCE_PRODUCT')
alter table OrderItem
   drop constraint FK_ORDERITE_REFERENCE_PRODUCT
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('Product') and o.name = 'FK_PRODUCT_REFERENCE_SUPPLIER')
alter table Product
   drop constraint FK_PRODUCT_REFERENCE_SUPPLIER
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('Customer')
            and   name  = 'IndexCustomerName'
            and   indid > 0
            and   indid < 255)
   drop index Customer.IndexCustomerName
go

if exists (select 1
            from  sysobjects
           where  id = object_id('Customer')
            and   type = 'U')
   drop table Customer
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('"Order"')
            and   name  = 'IndexOrderOrderDate'
            and   indid > 0
            and   indid < 255)
   drop index "Order".IndexOrderOrderDate
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('"Order"')
            and   name  = 'IndexOrderCustomerId'
            and   indid > 0
            and   indid < 255)
   drop index "Order".IndexOrderCustomerId
go

if exists (select 1
            from  sysobjects
           where  id = object_id('"Order"')
            and   type = 'U')
   drop table "Order"
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('OrderItem')
            and   name  = 'IndexOrderItemProductId'
            and   indid > 0
            and   indid < 255)
   drop index OrderItem.IndexOrderItemProductId
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('OrderItem')
            and   name  = 'IndexOrderItemOrderId'
            and   indid > 0
            and   indid < 255)
   drop index OrderItem.IndexOrderItemOrderId
go

if exists (select 1
            from  sysobjects
           where  id = object_id('OrderItem')
            and   type = 'U')
   drop table OrderItem
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('Product')
            and   name  = 'IndexProductName'
            and   indid > 0
            and   indid < 255)
   drop index Product.IndexProductName
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('Product')
            and   name  = 'IndexProductSupplierId'
            and   indid > 0
            and   indid < 255)
   drop index Product.IndexProductSupplierId
go

if exists (select 1
            from  sysobjects
           where  id = object_id('Product')
            and   type = 'U')
   drop table Product
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('Supplier')
            and   name  = 'IndexSupplierCountry'
            and   indid > 0
            and   indid < 255)
   drop index Supplier.IndexSupplierCountry
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('Supplier')
            and   name  = 'IndexSupplierName'
            and   indid > 0
            and   indid < 255)
   drop index Supplier.IndexSupplierName
go

if exists (select 1
            from  sysobjects
           where  id = object_id('Supplier')
            and   type = 'U')
   drop table Supplier
go

/*==============================================================*/
/* Table: Customer                                              */
/*==============================================================*/
create table Customer (
   Id                   int                  identity,
   FirstName            nvarchar(40)         not null,
   LastName             nvarchar(40)         not null,
   City                 nvarchar(40)         null,
   Country              nvarchar(40)         null,
   Phone                nvarchar(20)         null,
   constraint PK_CUSTOMER primary key (Id)
)
go

/*==============================================================*/
/* Index: IndexCustomerName                                     */
/*==============================================================*/
create index IndexCustomerName on Customer (
LastName ASC,
FirstName ASC
)
go

/*==============================================================*/
/* Table: "Order"                                               */
/*==============================================================*/
create table "Order" (
   Id                   int                  identity,
   OrderDate            datetime             not null default getdate(),
   OrderNumber          nvarchar(10)         null,
   CustomerId           int                  not null,
   TotalAmount          decimal(12,2)        null default 0,
   constraint PK_ORDER primary key (Id)
)
go

/*==============================================================*/
/* Index: IndexOrderCustomerId                                  */
/*==============================================================*/
create index IndexOrderCustomerId on "Order" (
CustomerId ASC
)
go

/*==============================================================*/
/* Index: IndexOrderOrderDate                                   */
/*==============================================================*/
create index IndexOrderOrderDate on "Order" (
OrderDate ASC
)
go

/*==============================================================*/
/* Table: OrderItem                                             */
/*==============================================================*/
create table OrderItem (
   Id                   int                  identity,
   OrderId              int                  not null,
   ProductId            int                  not null,
   UnitPrice            decimal(12,2)        not null default 0,
   Quantity             int                  not null default 1,
   constraint PK_ORDERITEM primary key (Id)
)
go

/*==============================================================*/
/* Index: IndexOrderItemOrderId                                 */
/*==============================================================*/
create index IndexOrderItemOrderId on OrderItem (
OrderId ASC
)
go

/*==============================================================*/
/* Index: IndexOrderItemProductId                               */
/*==============================================================*/
create index IndexOrderItemProductId on OrderItem (
ProductId ASC
)
go

/*==============================================================*/
/* Table: Product                                               */
/*==============================================================*/
create table Product (
   Id                   int                  identity,
   ProductName          nvarchar(50)         not null,
   SupplierId           int                  not null,
   UnitPrice            decimal(12,2)        null default 0,
   Package              nvarchar(30)         null,
   IsDiscontinued       bit                  not null default 0,
   constraint PK_PRODUCT primary key (Id)
)
go

/*==============================================================*/
/* Index: IndexProductSupplierId                                */
/*==============================================================*/
create index IndexProductSupplierId on Product (
SupplierId ASC
)
go

/*==============================================================*/
/* Index: IndexProductName                                      */
/*==============================================================*/
create index IndexProductName on Product (
ProductName ASC
)
go

/*==============================================================*/
/* Table: Supplier                                              */
/*==============================================================*/
create table Supplier (
   Id                   int                  identity,
   CompanyName          nvarchar(40)         not null,
   ContactName          nvarchar(50)         null,
   ContactTitle         nvarchar(40)         null,
   City                 nvarchar(40)         null,
   Country              nvarchar(40)         null,
   Phone                nvarchar(30)         null,
   Fax                  nvarchar(30)         null,
   constraint PK_SUPPLIER primary key (Id)
)
go

/*==============================================================*/
/* Index: IndexSupplierName                                     */
/*==============================================================*/
create index IndexSupplierName on Supplier (
CompanyName ASC
)
go

/*==============================================================*/
/* Index: IndexSupplierCountry                                  */
/*==============================================================*/
create index IndexSupplierCountry on Supplier (
Country ASC
)
go

alter table "Order"
   add constraint FK_ORDER_REFERENCE_CUSTOMER foreign key (CustomerId)
      references Customer (Id)
go

alter table OrderItem
   add constraint FK_ORDERITE_REFERENCE_ORDER foreign key (OrderId)
      references "Order" (Id)
go

alter table OrderItem
   add constraint FK_ORDERITE_REFERENCE_PRODUCT foreign key (ProductId)
      references Product (Id)
go

alter table Product
   add constraint FK_PRODUCT_REFERENCE_SUPPLIER foreign key (SupplierId)
      references Supplier (Id)
go

SET IDENTITY_INSERT Customer ON
INSERT INTO [Customer] ([Id],[FirstName],[LastName],[City],[Country],[Phone])VALUES(1,'Maria','Anders','Berlin','Germany','030-0074321')
INSERT INTO [Customer] ([Id],[FirstName],[LastName],[City],[Country],[Phone])VALUES(2,'Ana','Trujillo','México D.F.','Mexico','(5) 555-4729')
INSERT INTO [Customer] ([Id],[FirstName],[LastName],[City],[Country],[Phone])VALUES(3,'Antonio','Moreno','México D.F.','Mexico','(5) 555-3932')
INSERT INTO [Customer] ([Id],[FirstName],[LastName],[City],[Country],[Phone])VALUES(4,'Thomas','Hardy','London','UK','(171) 555-7788')
INSERT INTO [Customer] ([Id],[FirstName],[LastName],[City],[Country],[Phone])VALUES(5,'Christina','Berglund','Luleå','Sweden','0921-12 34 65')
INSERT INTO [Customer] ([Id],[FirstName],[LastName],[City],[Country],[Phone])VALUES(6,'Hanna','Moos','Mannheim','Germany','0621-08460')
INSERT INTO [Customer] ([Id],[FirstName],[LastName],[City],[Country],[Phone])VALUES(7,'Frédérique','Citeaux','Strasbourg','France','88.60.15.31')
INSERT INTO [Customer] ([Id],[FirstName],[LastName],[City],[Country],[Phone])VALUES(8,'Martín','Sommer','Madrid','Spain','(91) 555 22 82')
INSERT INTO [Customer] ([Id],[FirstName],[LastName],[City],[Country],[Phone])VALUES(9,'Laurence','Lebihan','Marseille','France','91.24.45.40')
INSERT INTO [Customer] ([Id],[FirstName],[LastName],[City],[Country],[Phone])VALUES(10,'Elizabeth','Lincoln','Tsawassen','Canada','(604) 555-4729')
INSERT INTO [Customer] ([Id],[FirstName],[LastName],[City],[Country],[Phone])VALUES(11,'Victoria','Ashworth','London','UK','(171) 555-1212')
INSERT INTO [Customer] ([Id],[FirstName],[LastName],[City],[Country],[Phone])VALUES(12,'Patricio','Simpson','Buenos Aires','Argentina','(1) 135-5555')
INSERT INTO [Customer] ([Id],[FirstName],[LastName],[City],[Country],[Phone])VALUES(13,'Francisco','Chang','México D.F.','Mexico','(5) 555-3392')
INSERT INTO [Customer] ([Id],[FirstName],[LastName],[City],[Country],[Phone])VALUES(14,'Yang','Wang','Bern','Switzerland','0452-076545')
INSERT INTO [Customer] ([Id],[FirstName],[LastName],[City],[Country],[Phone])VALUES(15,'Pedro','Afonso','Sao Paulo','Brazil','(11) 555-7647')
INSERT INTO [Customer] ([Id],[FirstName],[LastName],[City],[Country],[Phone])VALUES(16,'Elizabeth','Brown','London','UK','(171) 555-2282')
INSERT INTO [Customer] ([Id],[FirstName],[LastName],[City],[Country],[Phone])VALUES(17,'Sven','Ottlieb','Aachen','Germany','0241-039123')
INSERT INTO [Customer] ([Id],[FirstName],[LastName],[City],[Country],[Phone])VALUES(18,'Janine','Labrune','Nantes','France','40.67.88.88')
INSERT INTO [Customer] ([Id],[FirstName],[LastName],[City],[Country],[Phone])VALUES(19,'Ann','Devon','London','UK','(171) 555-0297')
INSERT INTO [Customer] ([Id],[FirstName],[LastName],[City],[Country],[Phone])VALUES(20,'Roland','Mendel','Graz','Austria','7675-3425')
INSERT INTO [Customer] ([Id],[FirstName],[LastName],[City],[Country],[Phone])VALUES(21,'Aria','Cruz','Sao Paulo','Brazil','(11) 555-9857')
INSERT INTO [Customer] ([Id],[FirstName],[LastName],[City],[Country],[Phone])VALUES(22,'Diego','Roel','Madrid','Spain','(91) 555 94 44')
INSERT INTO [Customer] ([Id],[FirstName],[LastName],[City],[Country],[Phone])VALUES(23,'Martine','Rancé','Lille','France','20.16.10.16')
INSERT INTO [Customer] ([Id],[FirstName],[LastName],[City],[Country],[Phone])VALUES(24,'Maria','Larsson','Bräcke','Sweden','0695-34 67 21')
INSERT INTO [Customer] ([Id],[FirstName],[LastName],[City],[Country],[Phone])VALUES(25,'Peter','Franken','München','Germany','089-0877310')
INSERT INTO [Customer] ([Id],[FirstName],[LastName],[City],[Country],[Phone])VALUES(26,'Carine','Schmitt','Nantes','France','40.32.21.21')
INSERT INTO [Customer] ([Id],[FirstName],[LastName],[City],[Country],[Phone])VALUES(27,'Paolo','Accorti','Torino','Italy','011-4988260')
INSERT INTO [Customer] ([Id],[FirstName],[LastName],[City],[Country],[Phone])VALUES(28,'Lino','Rodriguez','Lisboa','Portugal','(1) 354-2534')
INSERT INTO [Customer] ([Id],[FirstName],[LastName],[City],[Country],[Phone])VALUES(29,'Eduardo','Saavedra','Barcelona','Spain','(93) 203 4560')
INSERT INTO [Customer] ([Id],[FirstName],[LastName],[City],[Country],[Phone])VALUES(30,'José','Pedro Freyre','Sevilla','Spain','(95) 555 82 82')
INSERT INTO [Customer] ([Id],[FirstName],[LastName],[City],[Country],[Phone])VALUES(31,'André','Fonseca','Campinas','Brazil','(11) 555-9482')
INSERT INTO [Customer] ([Id],[FirstName],[LastName],[City],[Country],[Phone])VALUES(32,'Howard','Snyder','Eugene','USA','(503) 555-7555')
INSERT INTO [Customer] ([Id],[FirstName],[LastName],[City],[Country],[Phone])VALUES(33,'Manuel','Pereira','Caracas','Venezuela','(2) 283-2951')
INSERT INTO [Customer] ([Id],[FirstName],[LastName],[City],[Country],[Phone])VALUES(34,'Mario','Pontes','Rio de Janeiro','Brazil','(21) 555-0091')
INSERT INTO [Customer] ([Id],[FirstName],[LastName],[City],[Country],[Phone])VALUES(35,'Carlos','Hernández','San Cristóbal','Venezuela','(5) 555-1340')
INSERT INTO [Customer] ([Id],[FirstName],[LastName],[City],[Country],[Phone])VALUES(36,'Yoshi','Latimer','Elgin','USA','(503) 555-6874')
INSERT INTO [Customer] ([Id],[FirstName],[LastName],[City],[Country],[Phone])VALUES(37,'Patricia','McKenna','Cork','Ireland','2967 542')
INSERT INTO [Customer] ([Id],[FirstName],[LastName],[City],[Country],[Phone])VALUES(38,'Helen','Bennett','Cowes','UK','(198) 555-8888')
INSERT INTO [Customer] ([Id],[FirstName],[LastName],[City],[Country],[Phone])VALUES(39,'Philip','Cramer','Brandenburg','Germany','0555-09876')
INSERT INTO [Customer] ([Id],[FirstName],[LastName],[City],[Country],[Phone])VALUES(40,'Daniel','Tonini','Versailles','France','30.59.84.10')
INSERT INTO [Customer] ([Id],[FirstName],[LastName],[City],[Country],[Phone])VALUES(41,'Annette','Roulet','Toulouse','France','61.77.61.10')
INSERT INTO [Customer] ([Id],[FirstName],[LastName],[City],[Country],[Phone])VALUES(42,'Yoshi','Tannamuri','Vancouver','Canada','(604) 555-3392')
INSERT INTO [Customer] ([Id],[FirstName],[LastName],[City],[Country],[Phone])VALUES(43,'John','Steel','Walla Walla','USA','(509) 555-7969')
INSERT INTO [Customer] ([Id],[FirstName],[LastName],[City],[Country],[Phone])VALUES(44,'Renate','Messner','Frankfurt a.M.','Germany','069-0245984')
INSERT INTO [Customer] ([Id],[FirstName],[LastName],[City],[Country],[Phone])VALUES(45,'Jaime','Yorres','San Francisco','USA','(415) 555-5938')
INSERT INTO [Customer] ([Id],[FirstName],[LastName],[City],[Country],[Phone])VALUES(46,'Carlos','González','Barquisimeto','Venezuela','(9) 331-6954')
INSERT INTO [Customer] ([Id],[FirstName],[LastName],[City],[Country],[Phone])VALUES(47,'Felipe','Izquierdo','I. de Margarita','Venezuela','(8) 34-56-12')
INSERT INTO [Customer] ([Id],[FirstName],[LastName],[City],[Country],[Phone])VALUES(48,'Fran','Wilson','Portland','USA','(503) 555-9573')
INSERT INTO [Customer] ([Id],[FirstName],[LastName],[City],[Country],[Phone])VALUES(49,'Giovanni','Rovelli','Bergamo','Italy','035-640230')
INSERT INTO [Customer] ([Id],[FirstName],[LastName],[City],[Country],[Phone])VALUES(50,'Catherine','Dewey','Bruxelles','Belgium','(02) 201 24 67')
INSERT INTO [Customer] ([Id],[FirstName],[LastName],[City],[Country],[Phone])VALUES(51,'Jean','Fresnière','Montréal','Canada','(514) 555-8054')
INSERT INTO [Customer] ([Id],[FirstName],[LastName],[City],[Country],[Phone])VALUES(52,'Alexander','Feuer','Leipzig','Germany','0342-023176')
INSERT INTO [Customer] ([Id],[FirstName],[LastName],[City],[Country],[Phone])VALUES(53,'Simon','Crowther','London','UK','(171) 555-7733')
INSERT INTO [Customer] ([Id],[FirstName],[LastName],[City],[Country],[Phone])VALUES(54,'Yvonne','Moncada','Buenos Aires','Argentina','(1) 135-5333')
INSERT INTO [Customer] ([Id],[FirstName],[LastName],[City],[Country],[Phone])VALUES(55,'Rene','Phillips','Anchorage','USA','(907) 555-7584')
INSERT INTO [Customer] ([Id],[FirstName],[LastName],[City],[Country],[Phone])VALUES(56,'Henriette','Pfalzheim','Köln','Germany','0221-0644327')
INSERT INTO [Customer] ([Id],[FirstName],[LastName],[City],[Country],[Phone])VALUES(57,'Marie','Bertrand','Paris','France','(1) 42.34.22.66')
INSERT INTO [Customer] ([Id],[FirstName],[LastName],[City],[Country],[Phone])VALUES(58,'Guillermo','Fernández','México D.F.','Mexico','(5) 552-3745')
INSERT INTO [Customer] ([Id],[FirstName],[LastName],[City],[Country],[Phone])VALUES(59,'Georg','Pipps','Salzburg','Austria','6562-9722')
INSERT INTO [Customer] ([Id],[FirstName],[LastName],[City],[Country],[Phone])VALUES(60,'Isabel','de Castro','Lisboa','Portugal','(1) 356-5634')
INSERT INTO [Customer] ([Id],[FirstName],[LastName],[City],[Country],[Phone])VALUES(61,'Bernardo','Batista','Rio de Janeiro','Brazil','(21) 555-4252')
INSERT INTO [Customer] ([Id],[FirstName],[LastName],[City],[Country],[Phone])VALUES(62,'Lúcia','Carvalho','Sao Paulo','Brazil','(11) 555-1189')
INSERT INTO [Customer] ([Id],[FirstName],[LastName],[City],[Country],[Phone])VALUES(63,'Horst','Kloss','Cunewalde','Germany','0372-035188')
INSERT INTO [Customer] ([Id],[FirstName],[LastName],[City],[Country],[Phone])VALUES(64,'Sergio','Gutiérrez','Buenos Aires','Argentina','(1) 123-5555')
INSERT INTO [Customer] ([Id],[FirstName],[LastName],[City],[Country],[Phone])VALUES(65,'Paula','Wilson','Albuquerque','USA','(505) 555-5939')
INSERT INTO [Customer] ([Id],[FirstName],[LastName],[City],[Country],[Phone])VALUES(66,'Maurizio','Moroni','Reggio Emilia','Italy','0522-556721')
INSERT INTO [Customer] ([Id],[FirstName],[LastName],[City],[Country],[Phone])VALUES(67,'Janete','Limeira','Rio de Janeiro','Brazil','(21) 555-3412')
INSERT INTO [Customer] ([Id],[FirstName],[LastName],[City],[Country],[Phone])VALUES(68,'Michael','Holz','Genève','Switzerland','0897-034214')
INSERT INTO [Customer] ([Id],[FirstName],[LastName],[City],[Country],[Phone])VALUES(69,'Alejandra','Camino','Madrid','Spain','(91) 745 6200')
INSERT INTO [Customer] ([Id],[FirstName],[LastName],[City],[Country],[Phone])VALUES(70,'Jonas','Bergulfsen','Stavern','Norway','07-98 92 35')
INSERT INTO [Customer] ([Id],[FirstName],[LastName],[City],[Country],[Phone])VALUES(71,'Jose','Pavarotti','Boise','USA','(208) 555-8097')
INSERT INTO [Customer] ([Id],[FirstName],[LastName],[City],[Country],[Phone])VALUES(72,'Hari','Kumar','London','UK','(171) 555-1717')
INSERT INTO [Customer] ([Id],[FirstName],[LastName],[City],[Country],[Phone])VALUES(73,'Jytte','Petersen','Kobenhavn','Denmark','31 12 34 56')
INSERT INTO [Customer] ([Id],[FirstName],[LastName],[City],[Country],[Phone])VALUES(74,'Dominique','Perrier','Paris','France','(1) 47.55.60.10')
INSERT INTO [Customer] ([Id],[FirstName],[LastName],[City],[Country],[Phone])VALUES(75,'Art','Braunschweiger','Lander','USA','(307) 555-4680')
INSERT INTO [Customer] ([Id],[FirstName],[LastName],[City],[Country],[Phone])VALUES(76,'Pascale','Cartrain','Charleroi','Belgium','(071) 23 67 22 20')
INSERT INTO [Customer] ([Id],[FirstName],[LastName],[City],[Country],[Phone])VALUES(77,'Liz','Nixon','Portland','USA','(503) 555-3612')
INSERT INTO [Customer] ([Id],[FirstName],[LastName],[City],[Country],[Phone])VALUES(78,'Liu','Wong','Butte','USA','(406) 555-5834')
INSERT INTO [Customer] ([Id],[FirstName],[LastName],[City],[Country],[Phone])VALUES(79,'Karin','Josephs','Münster','Germany','0251-031259')
INSERT INTO [Customer] ([Id],[FirstName],[LastName],[City],[Country],[Phone])VALUES(80,'Miguel','Angel Paolino','México D.F.','Mexico','(5) 555-2933')
INSERT INTO [Customer] ([Id],[FirstName],[LastName],[City],[Country],[Phone])VALUES(81,'Anabela','Domingues','Sao Paulo','Brazil','(11) 555-2167')
INSERT INTO [Customer] ([Id],[FirstName],[LastName],[City],[Country],[Phone])VALUES(82,'Helvetius','Nagy','Kirkland','USA','(206) 555-8257')
INSERT INTO [Customer] ([Id],[FirstName],[LastName],[City],[Country],[Phone])VALUES(83,'Palle','Ibsen','Århus','Denmark','86 21 32 43')
INSERT INTO [Customer] ([Id],[FirstName],[LastName],[City],[Country],[Phone])VALUES(84,'Mary','Saveley','Lyon','France','78.32.54.86')
INSERT INTO [Customer] ([Id],[FirstName],[LastName],[City],[Country],[Phone])VALUES(85,'Paul','Henriot','Reims','France','26.47.15.10')
INSERT INTO [Customer] ([Id],[FirstName],[LastName],[City],[Country],[Phone])VALUES(86,'Rita','Müller','Stuttgart','Germany','0711-020361')
INSERT INTO [Customer] ([Id],[FirstName],[LastName],[City],[Country],[Phone])VALUES(87,'Pirkko','Koskitalo','Oulu','Finland','981-443655')
INSERT INTO [Customer] ([Id],[FirstName],[LastName],[City],[Country],[Phone])VALUES(88,'Paula','Parente','Resende','Brazil','(14) 555-8122')
INSERT INTO [Customer] ([Id],[FirstName],[LastName],[City],[Country],[Phone])VALUES(89,'Karl','Jablonski','Seattle','USA','(206) 555-4112')
INSERT INTO [Customer] ([Id],[FirstName],[LastName],[City],[Country],[Phone])VALUES(90,'Matti','Karttunen','Helsinki','Finland','90-224 8858')
INSERT INTO [Customer] ([Id],[FirstName],[LastName],[City],[Country],[Phone])VALUES(91,'Zbyszek','Piestrzeniewicz','Warszawa','Poland','(26) 642-7012')
SET IDENTITY_INSERT Customer OFF
SET IDENTITY_INSERT Supplier ON
INSERT INTO [Supplier] ([Id],[CompanyName],[ContactName],[City],[Country],[Phone],[Fax])VALUES(1,'Exotic Liquids','Charlotte Cooper','London','UK','(171) 555-2222',NULL)
INSERT INTO [Supplier] ([Id],[CompanyName],[ContactName],[City],[Country],[Phone],[Fax])VALUES(2,'New Orleans Cajun Delights','Shelley Burke','New Orleans','USA','(100) 555-4822',NULL)
INSERT INTO [Supplier] ([Id],[CompanyName],[ContactName],[City],[Country],[Phone],[Fax])VALUES(3,'Grandma Kelly''s Homestead','Regina Murphy','Ann Arbor','USA','(313) 555-5735','(313) 555-3349')
INSERT INTO [Supplier] ([Id],[CompanyName],[ContactName],[City],[Country],[Phone],[Fax])VALUES(4,'Tokyo Traders','Yoshi Nagase','Tokyo','Japan','(03) 3555-5011',NULL)
INSERT INTO [Supplier] ([Id],[CompanyName],[ContactName],[City],[Country],[Phone],[Fax])VALUES(5,'Cooperativa de Quesos ''Las Cabras''','Antonio del Valle Saavedra','Oviedo','Spain','(98) 598 76 54',NULL)
INSERT INTO [Supplier] ([Id],[CompanyName],[ContactName],[City],[Country],[Phone],[Fax])VALUES(6,'Mayumi''s','Mayumi Ohno','Osaka','Japan','(06) 431-7877',NULL)
INSERT INTO [Supplier] ([Id],[CompanyName],[ContactName],[City],[Country],[Phone],[Fax])VALUES(7,'Pavlova, Ltd.','Ian Devling','Melbourne','Australia','(03) 444-2343','(03) 444-6588')
INSERT INTO [Supplier] ([Id],[CompanyName],[ContactName],[City],[Country],[Phone],[Fax])VALUES(8,'Specialty Biscuits, Ltd.','Peter Wilson','Manchester','UK','(161) 555-4448',NULL)
INSERT INTO [Supplier] ([Id],[CompanyName],[ContactName],[City],[Country],[Phone],[Fax])VALUES(9,'PB Knäckebröd AB','Lars Peterson','Göteborg','Sweden','031-987 65 43','031-987 65 91')
INSERT INTO [Supplier] ([Id],[CompanyName],[ContactName],[City],[Country],[Phone],[Fax])VALUES(10,'Refrescos Americanas LTDA','Carlos Diaz','Sao Paulo','Brazil','(11) 555 4640',NULL)
INSERT INTO [Supplier] ([Id],[CompanyName],[ContactName],[City],[Country],[Phone],[Fax])VALUES(11,'Heli Süßwaren GmbH & Co. KG','Petra Winkler','Berlin','Germany','(010) 9984510',NULL)
INSERT INTO [Supplier] ([Id],[CompanyName],[ContactName],[City],[Country],[Phone],[Fax])VALUES(12,'Plutzer Lebensmittelgroßmärkte AG','Martin Bein','Frankfurt','Germany','(069) 992755',NULL)
INSERT INTO [Supplier] ([Id],[CompanyName],[ContactName],[City],[Country],[Phone],[Fax])VALUES(13,'Nord-Ost-Fisch Handelsgesellschaft mbH','Sven Petersen','Cuxhaven','Germany','(04721) 8713','(04721) 8714')
INSERT INTO [Supplier] ([Id],[CompanyName],[ContactName],[City],[Country],[Phone],[Fax])VALUES(14,'Formaggi Fortini s.r.l.','Elio Rossi','Ravenna','Italy','(0544) 60323','(0544) 60603')
INSERT INTO [Supplier] ([Id],[CompanyName],[ContactName],[City],[Country],[Phone],[Fax])VALUES(15,'Norske Meierier','Beate Vileid','Sandvika','Norway','(0)2-953010',NULL)
INSERT INTO [Supplier] ([Id],[CompanyName],[ContactName],[City],[Country],[Phone],[Fax])VALUES(16,'Bigfoot Breweries','Cheryl Saylor','Bend','USA','(503) 555-9931',NULL)
INSERT INTO [Supplier] ([Id],[CompanyName],[ContactName],[City],[Country],[Phone],[Fax])VALUES(17,'Svensk Sjöföda AB','Michael Björn','Stockholm','Sweden','08-123 45 67',NULL)
INSERT INTO [Supplier] ([Id],[CompanyName],[ContactName],[City],[Country],[Phone],[Fax])VALUES(18,'Aux joyeux ecclésiastiques','Guylène Nodier','Paris','France','(1) 03.83.00.68','(1) 03.83.00.62')
INSERT INTO [Supplier] ([Id],[CompanyName],[ContactName],[City],[Country],[Phone],[Fax])VALUES(19,'New England Seafood Cannery','Robb Merchant','Boston','USA','(617) 555-3267','(617) 555-3389')
INSERT INTO [Supplier] ([Id],[CompanyName],[ContactName],[City],[Country],[Phone],[Fax])VALUES(20,'Leka Trading','Chandra Leka','Singapore','Singapore','555-8787',NULL)
INSERT INTO [Supplier] ([Id],[CompanyName],[ContactName],[City],[Country],[Phone],[Fax])VALUES(21,'Lyngbysild','Niels Petersen','Lyngby','Denmark','43844108','43844115')
INSERT INTO [Supplier] ([Id],[CompanyName],[ContactName],[City],[Country],[Phone],[Fax])VALUES(22,'Zaanse Snoepfabriek','Dirk Luchte','Zaandam','Netherlands','(12345) 1212','(12345) 1210')
INSERT INTO [Supplier] ([Id],[CompanyName],[ContactName],[City],[Country],[Phone],[Fax])VALUES(23,'Karkki Oy','Anne Heikkonen','Lappeenranta','Finland','(953) 10956',NULL)
INSERT INTO [Supplier] ([Id],[CompanyName],[ContactName],[City],[Country],[Phone],[Fax])VALUES(24,'G''day, Mate','Wendy Mackenzie','Sydney','Australia','(02) 555-5914','(02) 555-4873')
INSERT INTO [Supplier] ([Id],[CompanyName],[ContactName],[City],[Country],[Phone],[Fax])VALUES(25,'Ma Maison','Jean-Guy Lauzon','Montréal','Canada','(514) 555-9022',NULL)
INSERT INTO [Supplier] ([Id],[CompanyName],[ContactName],[City],[Country],[Phone],[Fax])VALUES(26,'Pasta Buttini s.r.l.','Giovanni Giudici','Salerno','Italy','(089) 6547665','(089) 6547667')
INSERT INTO [Supplier] ([Id],[CompanyName],[ContactName],[City],[Country],[Phone],[Fax])VALUES(27,'Escargots Nouveaux','Marie Delamare','Montceau','France','85.57.00.07',NULL)
INSERT INTO [Supplier] ([Id],[CompanyName],[ContactName],[City],[Country],[Phone],[Fax])VALUES(28,'Gai pâturage','Eliane Noz','Annecy','France','38.76.98.06','38.76.98.58')
INSERT INTO [Supplier] ([Id],[CompanyName],[ContactName],[City],[Country],[Phone],[Fax])VALUES(29,'Forêts d''érables','Chantal Goulet','Ste-Hyacinthe','Canada','(514) 555-2955','(514) 555-2921')
SET IDENTITY_INSERT Supplier OFF
SET IDENTITY_INSERT Product ON
INSERT INTO [Product] ([Id],[ProductName],[SupplierId],[UnitPrice],[Package],[IsDiscontinued])VALUES(1,'Chai',1,18.00,'10 boxes x 20 bags',0)
INSERT INTO [Product] ([Id],[ProductName],[SupplierId],[UnitPrice],[Package],[IsDiscontinued])VALUES(2,'Chang',1,19.00,'24 - 12 oz bottles',0)
INSERT INTO [Product] ([Id],[ProductName],[SupplierId],[UnitPrice],[Package],[IsDiscontinued])VALUES(3,'Aniseed Syrup',1,10.00,'12 - 550 ml bottles',0)
INSERT INTO [Product] ([Id],[ProductName],[SupplierId],[UnitPrice],[Package],[IsDiscontinued])VALUES(4,'Chef Anton''s Cajun Seasoning',2,22.00,'48 - 6 oz jars',0)
INSERT INTO [Product] ([Id],[ProductName],[SupplierId],[UnitPrice],[Package],[IsDiscontinued])VALUES(5,'Chef Anton''s Gumbo Mix',2,21.35,'36 boxes',1)
INSERT INTO [Product] ([Id],[ProductName],[SupplierId],[UnitPrice],[Package],[IsDiscontinued])VALUES(6,'Grandma''s Boysenberry Spread',3,25.00,'12 - 8 oz jars',0)
INSERT INTO [Product] ([Id],[ProductName],[SupplierId],[UnitPrice],[Package],[IsDiscontinued])VALUES(7,'Uncle Bob''s Organic Dried Pears',3,30.00,'12 - 1 lb pkgs.',0)
INSERT INTO [Product] ([Id],[ProductName],[SupplierId],[UnitPrice],[Package],[IsDiscontinued])VALUES(8,'Northwoods Cranberry Sauce',3,40.00,'12 - 12 oz jars',0)
INSERT INTO [Product] ([Id],[ProductName],[SupplierId],[UnitPrice],[Package],[IsDiscontinued])VALUES(9,'Mishi Kobe Niku',4,97.00,'18 - 500 g pkgs.',1)
INSERT INTO [Product] ([Id],[ProductName],[SupplierId],[UnitPrice],[Package],[IsDiscontinued])VALUES(10,'Ikura',4,31.00,'12 - 200 ml jars',0)
INSERT INTO [Product] ([Id],[ProductName],[SupplierId],[UnitPrice],[Package],[IsDiscontinued])VALUES(11,'Queso Cabrales',5,21.00,'1 kg pkg.',0)
INSERT INTO [Product] ([Id],[ProductName],[SupplierId],[UnitPrice],[Package],[IsDiscontinued])VALUES(12,'Queso Manchego La Pastora',5,38.00,'10 - 500 g pkgs.',0)
INSERT INTO [Product] ([Id],[ProductName],[SupplierId],[UnitPrice],[Package],[IsDiscontinued])VALUES(13,'Konbu',6,6.00,'2 kg box',0)
INSERT INTO [Product] ([Id],[ProductName],[SupplierId],[UnitPrice],[Package],[IsDiscontinued])VALUES(14,'Tofu',6,23.25,'40 - 100 g pkgs.',0)
INSERT INTO [Product] ([Id],[ProductName],[SupplierId],[UnitPrice],[Package],[IsDiscontinued])VALUES(15,'Genen Shouyu',6,15.50,'24 - 250 ml bottles',0)
INSERT INTO [Product] ([Id],[ProductName],[SupplierId],[UnitPrice],[Package],[IsDiscontinued])VALUES(16,'Pavlova',7,17.45,'32 - 500 g boxes',0)
INSERT INTO [Product] ([Id],[ProductName],[SupplierId],[UnitPrice],[Package],[IsDiscontinued])VALUES(17,'Alice Mutton',7,39.00,'20 - 1 kg tins',1)
INSERT INTO [Product] ([Id],[ProductName],[SupplierId],[UnitPrice],[Package],[IsDiscontinued])VALUES(18,'Carnarvon Tigers',7,62.50,'16 kg pkg.',0)
INSERT INTO [Product] ([Id],[ProductName],[SupplierId],[UnitPrice],[Package],[IsDiscontinued])VALUES(19,'Teatime Chocolate Biscuits',8,9.20,'10 boxes x 12 pieces',0)
INSERT INTO [Product] ([Id],[ProductName],[SupplierId],[UnitPrice],[Package],[IsDiscontinued])VALUES(20,'Sir Rodney''s Marmalade',8,81.00,'30 gift boxes',0)
INSERT INTO [Product] ([Id],[ProductName],[SupplierId],[UnitPrice],[Package],[IsDiscontinued])VALUES(21,'Sir Rodney''s Scones',8,10.00,'24 pkgs. x 4 pieces',0)
INSERT INTO [Product] ([Id],[ProductName],[SupplierId],[UnitPrice],[Package],[IsDiscontinued])VALUES(22,'Gustaf''s Knäckebröd',9,21.00,'24 - 500 g pkgs.',0)
INSERT INTO [Product] ([Id],[ProductName],[SupplierId],[UnitPrice],[Package],[IsDiscontinued])VALUES(23,'Tunnbröd',9,9.00,'12 - 250 g pkgs.',0)
INSERT INTO [Product] ([Id],[ProductName],[SupplierId],[UnitPrice],[Package],[IsDiscontinued])VALUES(24,'Guaraná Fantástica',10,4.50,'12 - 355 ml cans',1)
INSERT INTO [Product] ([Id],[ProductName],[SupplierId],[UnitPrice],[Package],[IsDiscontinued])VALUES(25,'NuNuCa Nuß-Nougat-Creme',11,14.00,'20 - 450 g glasses',0)
INSERT INTO [Product] ([Id],[ProductName],[SupplierId],[UnitPrice],[Package],[IsDiscontinued])VALUES(26,'Gumbär Gummibärchen',11,31.23,'100 - 250 g bags',0)
INSERT INTO [Product] ([Id],[ProductName],[SupplierId],[UnitPrice],[Package],[IsDiscontinued])VALUES(27,'Schoggi Schokolade',11,43.90,'100 - 100 g pieces',0)
INSERT INTO [Product] ([Id],[ProductName],[SupplierId],[UnitPrice],[Package],[IsDiscontinued])VALUES(28,'Rössle Sauerkraut',12,45.60,'25 - 825 g cans',1)
INSERT INTO [Product] ([Id],[ProductName],[SupplierId],[UnitPrice],[Package],[IsDiscontinued])VALUES(29,'Thüringer Rostbratwurst',12,123.79,'50 bags x 30 sausgs.',1)
INSERT INTO [Product] ([Id],[ProductName],[SupplierId],[UnitPrice],[Package],[IsDiscontinued])VALUES(30,'Nord-Ost Matjeshering',13,25.89,'10 - 200 g glasses',0)
INSERT INTO [Product] ([Id],[ProductName],[SupplierId],[UnitPrice],[Package],[IsDiscontinued])VALUES(31,'Gorgonzola Telino',14,12.50,'12 - 100 g pkgs',0)
INSERT INTO [Product] ([Id],[ProductName],[SupplierId],[UnitPrice],[Package],[IsDiscontinued])VALUES(32,'Mascarpone Fabioli',14,32.00,'24 - 200 g pkgs.',0)
INSERT INTO [Product] ([Id],[ProductName],[SupplierId],[UnitPrice],[Package],[IsDiscontinued])VALUES(33,'Geitost',15,2.50,'500 g',0)
INSERT INTO [Product] ([Id],[ProductName],[SupplierId],[UnitPrice],[Package],[IsDiscontinued])VALUES(34,'Sasquatch Ale',16,14.00,'24 - 12 oz bottles',0)
INSERT INTO [Product] ([Id],[ProductName],[SupplierId],[UnitPrice],[Package],[IsDiscontinued])VALUES(35,'Steeleye Stout',16,18.00,'24 - 12 oz bottles',0)
INSERT INTO [Product] ([Id],[ProductName],[SupplierId],[UnitPrice],[Package],[IsDiscontinued])VALUES(36,'Inlagd Sill',17,19.00,'24 - 250 g  jars',0)
INSERT INTO [Product] ([Id],[ProductName],[SupplierId],[UnitPrice],[Package],[IsDiscontinued])VALUES(37,'Gravad lax',17,26.00,'12 - 500 g pkgs.',0)
INSERT INTO [Product] ([Id],[ProductName],[SupplierId],[UnitPrice],[Package],[IsDiscontinued])VALUES(38,'Côte de Blaye',18,263.50,'12 - 75 cl bottles',0)
INSERT INTO [Product] ([Id],[ProductName],[SupplierId],[UnitPrice],[Package],[IsDiscontinued])VALUES(39,'Chartreuse verte',18,18.00,'750 cc per bottle',0)
INSERT INTO [Product] ([Id],[ProductName],[SupplierId],[UnitPrice],[Package],[IsDiscontinued])VALUES(40,'Boston Crab Meat',19,18.40,'24 - 4 oz tins',0)
INSERT INTO [Product] ([Id],[ProductName],[SupplierId],[UnitPrice],[Package],[IsDiscontinued])VALUES(41,'Jack''s New England Clam Chowder',19,9.65,'12 - 12 oz cans',0)
INSERT INTO [Product] ([Id],[ProductName],[SupplierId],[UnitPrice],[Package],[IsDiscontinued])VALUES(42,'Singaporean Hokkien Fried Mee',20,14.00,'32 - 1 kg pkgs.',1)
INSERT INTO [Product] ([Id],[ProductName],[SupplierId],[UnitPrice],[Package],[IsDiscontinued])VALUES(43,'Ipoh Coffee',20,46.00,'16 - 500 g tins',0)
INSERT INTO [Product] ([Id],[ProductName],[SupplierId],[UnitPrice],[Package],[IsDiscontinued])VALUES(44,'Gula Malacca',20,19.45,'20 - 2 kg bags',0)
INSERT INTO [Product] ([Id],[ProductName],[SupplierId],[UnitPrice],[Package],[IsDiscontinued])VALUES(45,'Rogede sild',21,9.50,'1k pkg.',0)
INSERT INTO [Product] ([Id],[ProductName],[SupplierId],[UnitPrice],[Package],[IsDiscontinued])VALUES(46,'Spegesild',21,12.00,'4 - 450 g glasses',0)
INSERT INTO [Product] ([Id],[ProductName],[SupplierId],[UnitPrice],[Package],[IsDiscontinued])VALUES(47,'Zaanse koeken',22,9.50,'10 - 4 oz boxes',0)
INSERT INTO [Product] ([Id],[ProductName],[SupplierId],[UnitPrice],[Package],[IsDiscontinued])VALUES(48,'Chocolade',22,12.75,'10 pkgs.',0)
INSERT INTO [Product] ([Id],[ProductName],[SupplierId],[UnitPrice],[Package],[IsDiscontinued])VALUES(49,'Maxilaku',23,20.00,'24 - 50 g pkgs.',0)
INSERT INTO [Product] ([Id],[ProductName],[SupplierId],[UnitPrice],[Package],[IsDiscontinued])VALUES(50,'Valkoinen suklaa',23,16.25,'12 - 100 g bars',0)
INSERT INTO [Product] ([Id],[ProductName],[SupplierId],[UnitPrice],[Package],[IsDiscontinued])VALUES(51,'Manjimup Dried Apples',24,53.00,'50 - 300 g pkgs.',0)
INSERT INTO [Product] ([Id],[ProductName],[SupplierId],[UnitPrice],[Package],[IsDiscontinued])VALUES(52,'Filo Mix',24,7.00,'16 - 2 kg boxes',0)
INSERT INTO [Product] ([Id],[ProductName],[SupplierId],[UnitPrice],[Package],[IsDiscontinued])VALUES(53,'Perth Pasties',24,32.80,'48 pieces',1)
INSERT INTO [Product] ([Id],[ProductName],[SupplierId],[UnitPrice],[Package],[IsDiscontinued])VALUES(54,'Tourtière',25,7.45,'16 pies',0)
INSERT INTO [Product] ([Id],[ProductName],[SupplierId],[UnitPrice],[Package],[IsDiscontinued])VALUES(55,'Pâté chinois',25,24.00,'24 boxes x 2 pies',0)
INSERT INTO [Product] ([Id],[ProductName],[SupplierId],[UnitPrice],[Package],[IsDiscontinued])VALUES(56,'Gnocchi di nonna Alice',26,38.00,'24 - 250 g pkgs.',0)
INSERT INTO [Product] ([Id],[ProductName],[SupplierId],[UnitPrice],[Package],[IsDiscontinued])VALUES(57,'Ravioli Angelo',26,19.50,'24 - 250 g pkgs.',0)
INSERT INTO [Product] ([Id],[ProductName],[SupplierId],[UnitPrice],[Package],[IsDiscontinued])VALUES(58,'Escargots de Bourgogne',27,13.25,'24 pieces',0)
INSERT INTO [Product] ([Id],[ProductName],[SupplierId],[UnitPrice],[Package],[IsDiscontinued])VALUES(59,'Raclette Courdavault',28,55.00,'5 kg pkg.',0)
INSERT INTO [Product] ([Id],[ProductName],[SupplierId],[UnitPrice],[Package],[IsDiscontinued])VALUES(60,'Camembert Pierrot',28,34.00,'15 - 300 g rounds',0)
INSERT INTO [Product] ([Id],[ProductName],[SupplierId],[UnitPrice],[Package],[IsDiscontinued])VALUES(61,'Sirop d''érable',29,28.50,'24 - 500 ml bottles',0)
INSERT INTO [Product] ([Id],[ProductName],[SupplierId],[UnitPrice],[Package],[IsDiscontinued])VALUES(62,'Tarte au sucre',29,49.30,'48 pies',0)
INSERT INTO [Product] ([Id],[ProductName],[SupplierId],[UnitPrice],[Package],[IsDiscontinued])VALUES(63,'Vegie-spread',7,43.90,'15 - 625 g jars',0)
INSERT INTO [Product] ([Id],[ProductName],[SupplierId],[UnitPrice],[Package],[IsDiscontinued])VALUES(64,'Wimmers gute Semmelknödel',12,33.25,'20 bags x 4 pieces',0)
INSERT INTO [Product] ([Id],[ProductName],[SupplierId],[UnitPrice],[Package],[IsDiscontinued])VALUES(65,'Louisiana Fiery Hot Pepper Sauce',2,21.05,'32 - 8 oz bottles',0)
INSERT INTO [Product] ([Id],[ProductName],[SupplierId],[UnitPrice],[Package],[IsDiscontinued])VALUES(66,'Louisiana Hot Spiced Okra',2,17.00,'24 - 8 oz jars',0)
INSERT INTO [Product] ([Id],[ProductName],[SupplierId],[UnitPrice],[Package],[IsDiscontinued])VALUES(67,'Laughing Lumberjack Lager',16,14.00,'24 - 12 oz bottles',0)
INSERT INTO [Product] ([Id],[ProductName],[SupplierId],[UnitPrice],[Package],[IsDiscontinued])VALUES(68,'Scottish Longbreads',8,12.50,'10 boxes x 8 pieces',0)
INSERT INTO [Product] ([Id],[ProductName],[SupplierId],[UnitPrice],[Package],[IsDiscontinued])VALUES(69,'Gudbrandsdalsost',15,36.00,'10 kg pkg.',0)
INSERT INTO [Product] ([Id],[ProductName],[SupplierId],[UnitPrice],[Package],[IsDiscontinued])VALUES(70,'Outback Lager',7,15.00,'24 - 355 ml bottles',0)
INSERT INTO [Product] ([Id],[ProductName],[SupplierId],[UnitPrice],[Package],[IsDiscontinued])VALUES(71,'Flotemysost',15,21.50,'10 - 500 g pkgs.',0)
INSERT INTO [Product] ([Id],[ProductName],[SupplierId],[UnitPrice],[Package],[IsDiscontinued])VALUES(72,'Mozzarella di Giovanni',14,34.80,'24 - 200 g pkgs.',0)
INSERT INTO [Product] ([Id],[ProductName],[SupplierId],[UnitPrice],[Package],[IsDiscontinued])VALUES(73,'Röd Kaviar',17,15.00,'24 - 150 g jars',0)
INSERT INTO [Product] ([Id],[ProductName],[SupplierId],[UnitPrice],[Package],[IsDiscontinued])VALUES(74,'Longlife Tofu',4,10.00,'5 kg pkg.',0)
INSERT INTO [Product] ([Id],[ProductName],[SupplierId],[UnitPrice],[Package],[IsDiscontinued])VALUES(75,'Rhönbräu Klosterbier',12,7.75,'24 - 0.5 l bottles',0)
INSERT INTO [Product] ([Id],[ProductName],[SupplierId],[UnitPrice],[Package],[IsDiscontinued])VALUES(76,'Lakkalikööri',23,18.00,'500 ml',0)
INSERT INTO [Product] ([Id],[ProductName],[SupplierId],[UnitPrice],[Package],[IsDiscontinued])VALUES(77,'Original Frankfurter grüne Soße',12,13.00,'12 boxes',0)
INSERT INTO [Product] ([Id],[ProductName],[SupplierId],[UnitPrice],[Package],[IsDiscontinued])VALUES(78,'Stroopwafels',22,9.75,'24 pieces',0)
SET IDENTITY_INSERT Product OFF
SET IDENTITY_INSERT [Order] ON
INSERT INTO [Order] ([Id],[OrderDate],[CustomerId],[TotalAmount],[OrderNumber])VALUES(1,'Jul  4 2012 12:00:00:000AM',85,440.00,'542378')
INSERT INTO [Order] ([Id],[OrderDate],[CustomerId],[TotalAmount],[OrderNumber])VALUES(2,'Jul  5 2012 12:00:00:000AM',79,1863.40,'542379')
INSERT INTO [Order] ([Id],[OrderDate],[CustomerId],[TotalAmount],[OrderNumber])VALUES(3,'Jul  8 2012 12:00:00:000AM',34,1813.00,'542380')
INSERT INTO [Order] ([Id],[OrderDate],[CustomerId],[TotalAmount],[OrderNumber])VALUES(4,'Jul  8 2012 12:00:00:000AM',84,670.80,'542381')
INSERT INTO [Order] ([Id],[OrderDate],[CustomerId],[TotalAmount],[OrderNumber])VALUES(5,'Jul  9 2012 12:00:00:000AM',76,3730.00,'542382')
INSERT INTO [Order] ([Id],[OrderDate],[CustomerId],[TotalAmount],[OrderNumber])VALUES(6,'Jul 10 2012 12:00:00:000AM',34,1444.80,'542383')
INSERT INTO [Order] ([Id],[OrderDate],[CustomerId],[TotalAmount],[OrderNumber])VALUES(7,'Jul 11 2012 12:00:00:000AM',14,625.20,'542384')
INSERT INTO [Order] ([Id],[OrderDate],[CustomerId],[TotalAmount],[OrderNumber])VALUES(8,'Jul 12 2012 12:00:00:000AM',68,2490.50,'542385')
INSERT INTO [Order] ([Id],[OrderDate],[CustomerId],[TotalAmount],[OrderNumber])VALUES(9,'Jul 15 2012 12:00:00:000AM',88,517.80,'542386')
INSERT INTO [Order] ([Id],[OrderDate],[CustomerId],[TotalAmount],[OrderNumber])VALUES(10,'Jul 16 2012 12:00:00:000AM',35,1119.90,'542387')
INSERT INTO [Order] ([Id],[OrderDate],[CustomerId],[TotalAmount],[OrderNumber])VALUES(11,'Jul 17 2012 12:00:00:000AM',20,2018.60,'542388')
INSERT INTO [Order] ([Id],[OrderDate],[CustomerId],[TotalAmount],[OrderNumber])VALUES(12,'Jul 18 2012 12:00:00:000AM',13,100.80,'542389')
INSERT INTO [Order] ([Id],[OrderDate],[CustomerId],[TotalAmount],[OrderNumber])VALUES(13,'Jul 19 2012 12:00:00:000AM',56,1746.20,'542390')
INSERT INTO [Order] ([Id],[OrderDate],[CustomerId],[TotalAmount],[OrderNumber])VALUES(14,'Jul 19 2012 12:00:00:000AM',61,448.00,'542391')
INSERT INTO [Order] ([Id],[OrderDate],[CustomerId],[TotalAmount],[OrderNumber])VALUES(15,'Jul 22 2012 12:00:00:000AM',65,624.80,'542392')
INSERT INTO [Order] ([Id],[OrderDate],[CustomerId],[TotalAmount],[OrderNumber])VALUES(16,'Jul 23 2012 12:00:00:000AM',20,2464.80,'542393')
INSERT INTO [Order] ([Id],[OrderDate],[CustomerId],[TotalAmount],[OrderNumber])VALUES(17,'Jul 24 2012 12:00:00:000AM',24,724.50,'542394')
INSERT INTO [Order] ([Id],[OrderDate],[CustomerId],[TotalAmount],[OrderNumber])VALUES(18,'Jul 25 2012 12:00:00:000AM',7,1176.00,'542395')
INSERT INTO [Order] ([Id],[OrderDate],[CustomerId],[TotalAmount],[OrderNumber])VALUES(19,'Jul 26 2012 12:00:00:000AM',87,364.80,'542396')
INSERT INTO [Order] ([Id],[OrderDate],[CustomerId],[TotalAmount],[OrderNumber])VALUES(20,'Jul 29 2012 12:00:00:000AM',25,4031.00,'542397')
INSERT INTO [Order] ([Id],[OrderDate],[CustomerId],[TotalAmount],[OrderNumber])VALUES(21,'Jul 30 2012 12:00:00:000AM',33,1101.20,'542398')
INSERT INTO [Order] ([Id],[OrderDate],[CustomerId],[TotalAmount],[OrderNumber])VALUES(22,'Jul 31 2012 12:00:00:000AM',89,676.00,'542399')
INSERT INTO [Order] ([Id],[OrderDate],[CustomerId],[TotalAmount],[OrderNumber])VALUES(23,'Aug  1 2012 12:00:00:000AM',87,1376.00,'542400')
INSERT INTO [Order] ([Id],[OrderDate],[CustomerId],[TotalAmount],[OrderNumber])VALUES(24,'Aug  1 2012 12:00:00:000AM',75,48.00,'542401')
INSERT INTO [Order] ([Id],[OrderDate],[CustomerId],[TotalAmount],[OrderNumber])VALUES(25,'Aug  2 2012 12:00:00:000AM',65,1456.00,'542402')
INSERT INTO [Order] ([Id],[OrderDate],[CustomerId],[TotalAmount],[OrderNumber])VALUES(26,'Aug  5 2012 12:00:00:000AM',63,2142.40,'542403')
INSERT INTO [Order] ([Id],[OrderDate],[CustomerId],[TotalAmount],[OrderNumber])VALUES(27,'Aug  6 2012 12:00:00:000AM',85,538.60,'542404')
INSERT INTO [Order] ([Id],[OrderDate],[CustomerId],[TotalAmount],[OrderNumber])VALUES(28,'Aug  7 2012 12:00:00:000AM',49,307.20,'542405')
INSERT INTO [Order] ([Id],[OrderDate],[CustomerId],[TotalAmount],[OrderNumber])VALUES(29,'Aug  8 2012 12:00:00:000AM',80,420.00,'542406')
INSERT INTO [Order] ([Id],[OrderDate],[CustomerId],[TotalAmount],[OrderNumber])VALUES(30,'Aug  9 2012 12:00:00:000AM',52,1200.80,'542407')
INSERT INTO [Order] ([Id],[OrderDate],[CustomerId],[TotalAmount],[OrderNumber])VALUES(31,'Aug 12 2012 12:00:00:000AM',5,1488.80,'542408')
INSERT INTO [Order] ([Id],[OrderDate],[CustomerId],[TotalAmount],[OrderNumber])VALUES(32,'Aug 13 2012 12:00:00:000AM',44,468.00,'542409')
INSERT INTO [Order] ([Id],[OrderDate],[CustomerId],[TotalAmount],[OrderNumber])VALUES(33,'Aug 14 2012 12:00:00:000AM',5,613.20,'542410')
INSERT INTO [Order] ([Id],[OrderDate],[CustomerId],[TotalAmount],[OrderNumber])VALUES(34,'Aug 14 2012 12:00:00:000AM',69,86.50,'542411')
INSERT INTO [Order] ([Id],[OrderDate],[CustomerId],[TotalAmount],[OrderNumber])VALUES(35,'Aug 15 2012 12:00:00:000AM',69,155.40,'542412')
INSERT INTO [Order] ([Id],[OrderDate],[CustomerId],[TotalAmount],[OrderNumber])VALUES(36,'Aug 16 2012 12:00:00:000AM',46,1414.80,'542413')
INSERT INTO [Order] ([Id],[OrderDate],[CustomerId],[TotalAmount],[OrderNumber])VALUES(37,'Aug 19 2012 12:00:00:000AM',44,1452.00,'542414')
INSERT INTO [Order] ([Id],[OrderDate],[CustomerId],[TotalAmount],[OrderNumber])VALUES(38,'Aug 20 2012 12:00:00:000AM',63,2179.20,'542415')
INSERT INTO [Order] ([Id],[OrderDate],[CustomerId],[TotalAmount],[OrderNumber])VALUES(39,'Aug 21 2012 12:00:00:000AM',63,3016.00,'542416')
INSERT INTO [Order] ([Id],[OrderDate],[CustomerId],[TotalAmount],[OrderNumber])VALUES(40,'Aug 22 2012 12:00:00:000AM',67,924.00,'542417')
INSERT INTO [Order] ([Id],[OrderDate],[CustomerId],[TotalAmount],[OrderNumber])VALUES(41,'Aug 23 2012 12:00:00:000AM',66,89.00,'542418')
INSERT INTO [Order] ([Id],[OrderDate],[CustomerId],[TotalAmount],[OrderNumber])VALUES(42,'Aug 26 2012 12:00:00:000AM',11,479.40,'542419')
INSERT INTO [Order] ([Id],[OrderDate],[CustomerId],[TotalAmount],[OrderNumber])VALUES(43,'Aug 27 2012 12:00:00:000AM',15,2169.00,'542420')
INSERT INTO [Order] ([Id],[OrderDate],[CustomerId],[TotalAmount],[OrderNumber])VALUES(44,'Aug 27 2012 12:00:00:000AM',61,552.80,'542421')
INSERT INTO [Order] ([Id],[OrderDate],[CustomerId],[TotalAmount],[OrderNumber])VALUES(45,'Aug 28 2012 12:00:00:000AM',81,1296.00,'542422')
INSERT INTO [Order] ([Id],[OrderDate],[CustomerId],[TotalAmount],[OrderNumber])VALUES(46,'Aug 29 2012 12:00:00:000AM',80,848.70,'542423')
INSERT INTO [Order] ([Id],[OrderDate],[CustomerId],[TotalAmount],[OrderNumber])VALUES(47,'Aug 30 2012 12:00:00:000AM',65,1887.60,'542424')
INSERT INTO [Order] ([Id],[OrderDate],[CustomerId],[TotalAmount],[OrderNumber])VALUES(48,'Sep  2 2012 12:00:00:000AM',85,121.60,'542425')
INSERT INTO [Order] ([Id],[OrderDate],[CustomerId],[TotalAmount],[OrderNumber])VALUES(49,'Sep  3 2012 12:00:00:000AM',46,1050.60,'542426')
INSERT INTO [Order] ([Id],[OrderDate],[CustomerId],[TotalAmount],[OrderNumber])VALUES(50,'Sep  4 2012 12:00:00:000AM',7,1420.00,'542427')
INSERT INTO [Order] ([Id],[OrderDate],[CustomerId],[TotalAmount],[OrderNumber])VALUES(51,'Sep  5 2012 12:00:00:000AM',37,3127.00,'542428')
INSERT INTO [Order] ([Id],[OrderDate],[CustomerId],[TotalAmount],[OrderNumber])VALUES(52,'Sep  6 2012 12:00:00:000AM',67,349.50,'542429')
INSERT INTO [Order] ([Id],[OrderDate],[CustomerId],[TotalAmount],[OrderNumber])VALUES(53,'Sep  9 2012 12:00:00:000AM',49,608.00,'542430')
INSERT INTO [Order] ([Id],[OrderDate],[CustomerId],[TotalAmount],[OrderNumber])VALUES(54,'Sep  9 2012 12:00:00:000AM',86,755.00,'542431')
INSERT INTO [Order] ([Id],[OrderDate],[CustomerId],[TotalAmount],[OrderNumber])VALUES(55,'Sep 10 2012 12:00:00:000AM',76,2708.80,'542432')
INSERT INTO [Order] ([Id],[OrderDate],[CustomerId],[TotalAmount],[OrderNumber])VALUES(56,'Sep 11 2012 12:00:00:000AM',30,1242.00,'542433')
INSERT INTO [Order] ([Id],[OrderDate],[CustomerId],[TotalAmount],[OrderNumber])VALUES(57,'Sep 12 2012 12:00:00:000AM',80,954.40,'542434')
INSERT INTO [Order] ([Id],[OrderDate],[CustomerId],[TotalAmount],[OrderNumber])VALUES(58,'Sep 13 2012 12:00:00:000AM',55,4157.00,'542435')
INSERT INTO [Order] ([Id],[OrderDate],[CustomerId],[TotalAmount],[OrderNumber])VALUES(59,'Sep 16 2012 12:00:00:000AM',69,498.50,'542436')
INSERT INTO [Order] ([Id],[OrderDate],[CustomerId],[TotalAmount],[OrderNumber])VALUES(60,'Sep 17 2012 12:00:00:000AM',48,424.00,'542437')
INSERT INTO [Order] ([Id],[OrderDate],[CustomerId],[TotalAmount],[OrderNumber])VALUES(61,'Sep 18 2012 12:00:00:000AM',2,88.80,'542438')
INSERT INTO [Order] ([Id],[OrderDate],[CustomerId],[TotalAmount],[OrderNumber])VALUES(62,'Sep 19 2012 12:00:00:000AM',37,1762.00,'542439')
INSERT INTO [Order] ([Id],[OrderDate],[CustomerId],[TotalAmount],[OrderNumber])VALUES(63,'Sep 20 2012 12:00:00:000AM',77,336.00,'542440')
INSERT INTO [Order] ([Id],[OrderDate],[CustomerId],[TotalAmount],[OrderNumber])VALUES(64,'Sep 20 2012 12:00:00:000AM',18,268.80,'542441')
INSERT INTO [Order] ([Id],[OrderDate],[CustomerId],[TotalAmount],[OrderNumber])VALUES(65,'Sep 23 2012 12:00:00:000AM',86,1614.80,'542442')
INSERT INTO [Order] ([Id],[OrderDate],[CustomerId],[TotalAmount],[OrderNumber])VALUES(66,'Sep 24 2012 12:00:00:000AM',63,182.40,'542443')
INSERT INTO [Order] ([Id],[OrderDate],[CustomerId],[TotalAmount],[OrderNumber])VALUES(67,'Sep 25 2012 12:00:00:000AM',65,2327.00,'542444')
INSERT INTO [Order] ([Id],[OrderDate],[CustomerId],[TotalAmount],[OrderNumber])VALUES(68,'Sep 26 2012 12:00:00:000AM',38,516.80,'542445')
INSERT INTO [Order] ([Id],[OrderDate],[CustomerId],[TotalAmount],[OrderNumber])VALUES(69,'Sep 27 2012 12:00:00:000AM',65,2835.00,'542446')
INSERT INTO [Order] ([Id],[OrderDate],[CustomerId],[TotalAmount],[OrderNumber])VALUES(70,'Sep 30 2012 12:00:00:000AM',48,288.00,'542447')
INSERT INTO [Order] ([Id],[OrderDate],[CustomerId],[TotalAmount],[OrderNumber])VALUES(71,'Oct  1 2012 12:00:00:000AM',38,240.40,'542448')
INSERT INTO [Order] ([Id],[OrderDate],[CustomerId],[TotalAmount],[OrderNumber])VALUES(72,'Oct  2 2012 12:00:00:000AM',80,1191.20,'542449')
INSERT INTO [Order] ([Id],[OrderDate],[CustomerId],[TotalAmount],[OrderNumber])VALUES(73,'Oct  3 2012 12:00:00:000AM',87,516.00,'542450')
INSERT INTO [Order] ([Id],[OrderDate],[CustomerId],[TotalAmount],[OrderNumber])VALUES(74,'Oct  3 2012 12:00:00:000AM',38,144.00,'542451')
INSERT INTO [Order] ([Id],[OrderDate],[CustomerId],[TotalAmount],[OrderNumber])VALUES(75,'Oct  4 2012 12:00:00:000AM',58,112.00,'542452')
INSERT INTO [Order] ([Id],[OrderDate],[CustomerId],[TotalAmount],[OrderNumber])VALUES(76,'Oct  7 2012 12:00:00:000AM',39,164.40,'542453')
INSERT INTO [Order] ([Id],[OrderDate],[CustomerId],[TotalAmount],[OrderNumber])VALUES(77,'Oct  8 2012 12:00:00:000AM',71,6155.90,'542454')
INSERT INTO [Order] ([Id],[OrderDate],[CustomerId],[TotalAmount],[OrderNumber])VALUES(78,'Oct  9 2012 12:00:00:000AM',39,1497.00,'542455')
INSERT INTO [Order] ([Id],[OrderDate],[CustomerId],[TotalAmount],[OrderNumber])VALUES(79,'Oct 10 2012 12:00:00:000AM',8,982.00,'542456')
INSERT INTO [Order] ([Id],[OrderDate],[CustomerId],[TotalAmount],[OrderNumber])VALUES(80,'Oct 11 2012 12:00:00:000AM',24,2262.50,'542457')