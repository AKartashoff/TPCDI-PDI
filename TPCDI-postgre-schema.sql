--CREATE TYPE taxStatus AS Enumeric ('0', '1', '2');

CREATE TABLE DimBroker  ( SK_BrokerID  INTEGER NOT NULL PRIMARY KEY,
							BrokerID  INTEGER NOT NULL,
							ManagerID  INTEGER,
							FirstName       CHAR(50) NOT NULL,
							LastName       CHAR(50) NOT NULL,
							MiddleInitial       CHAR(1),
							Branch       CHAR(50),
							Office       CHAR(50),
							Phone       CHAR(14),
							IsCurrent boolean NOT NULL,
							BatchID INTEGER NOT NULL,
							EffectiveDate date NOT NULL,
							EndDate date NOT NULL							
);

CREATE TABLE DimCustomer  ( SK_CustomerID  INTEGER NOT NULL PRIMARY KEY,
							CustomerID INTEGER NOT NULL,
							TaxID CHAR(20) NOT NULL,
							Status CHAR(10) NOT NULL,
							LastName CHAR(30) NOT NULL,
							FirstName CHAR(30) NOT NULL,
							MiddleInitial CHAR(1),
							Gender CHAR(1),
							Tier Integer,
							DOB date NOT NULL,
							AddressLine1	varchar(80) NOT NULL,
							AddressLine2	varchar(80),
							PostalCode	char(12) NOT NULL,
							City	char(25) NOT NULL,
							StateProv	char(20) NOT NULL,
							Country	char(24),
							Phone1	char(30),
							Phone2	char(30),
							Phone3	char(30),
							Email1	char(50),
							Email2	char(50),
							NationalTaxRateDesc	varchar(50),
							NationalTaxRate	numeric(6,5),
							LocalTaxRateDesc	varchar(50),
							LocalTaxRate	numeric(6,5),
							AgencyID	char(30),
							CreditRating integer,
							NetWorth	numeric(10),
							MarketingNameplate varchar(100),
							IsCurrent boolean NOT NULL,
							BatchID INTEGER NOT NULL,
							EffectiveDate date NOT NULL,
							EndDate date NOT NULL
);

CREATE TABLE DimAccount  ( SK_AccountID  INTEGER NOT NULL PRIMARY KEY,
                            AccountID  INTEGER NOT NULL,
                            SK_BrokerID  INTEGER NOT NULL REFERENCES DimBroker (SK_BrokerID),
                            SK_CustomerID  INTEGER NOT NULL REFERENCES DimCustomer (SK_CustomerID),
                            Status       CHAR(10) NOT NULL,
                            AccountDesc       varchar(50),
                            TaxStatus  INTEGER NOT NULL CHECK (TaxStatus = 0 OR TaxStatus = 1 OR TaxStatus = 2),
                            IsCurrent boolean NOT NULL,
                            BatchID INTEGER NOT NULL,
                            EffectiveDate date NOT NULL,
                            EndDate date NOT NULL
);


CREATE TABLE DimCompany (   SK_CompanyID INTEGER NOT NULL PRIMARY KEY, 
							CompanyID INTEGER NOT NULL,
							Status CHAR(10) Not NULL, 
							Name CHAR(60) Not NULL,
							Industry CHAR(50) Not NULL,
							SPrating CHAR(4),
							isLowGrade BOOLEAN,
							CEO CHAR(100) Not NULL,
							AddressLine1 CHAR(80),
							AddressLine2 CHAR(80),
							PostalCode CHAR(12) Not NULL,
							City CHAR(25) Not NULL,
							StateProv CHAR(20) Not NULL,
							Country CHAR(24),
							Description CHAR(150) Not NULL,
							FoundingDate DATE,
							IsCurrent BOOLEAN Not NULL,
							BatchID numeric(5) Not NULL,
							EffectiveDate DATE Not NULL,
							EndDate DATE Not NULL
);

CREATE TABLE DimDate (  SK_DateID INTEGER Not NULL PRIMARY KEY,
						DateValue DATE Not NULL,
						DateDesc CHAR(20) Not NULL,
						CalendarYearID numeric(4) Not NULL,
						CalendarYearDesc CHAR(20) Not NULL,
						CalendarQtrID numeric(5) Not NULL,
						CalendarQtrDesc CHAR(20) Not NULL,
						CalendarMonthID numeric(6) Not NULL,
						CalendarMonthDesc CHAR(20) Not NULL,
						CalendarWeekID numeric(6) Not NULL,
						CalendarWeekDesc CHAR(20) Not NULL,
						DayOfWeeknumeric numeric(1) Not NULL,
						DayOfWeekDesc CHAR(10) Not NULL,
						FiscalYearID numeric(4) Not NULL,
						FiscalYearDesc CHAR(20) Not NULL,
						FiscalQtrID numeric(5) Not NULL,
						FiscalQtrDesc CHAR(20) Not NULL,
						HolidayFlag BOOLEAN
);

CREATE TABLE DimSecurity( SK_SecurityID INTEGER Not NULL PRIMARY KEY,
							Symbol CHAR(15) Not NULL,
							Issue CHAR(6) Not NULL,
							Status CHAR(10) Not NULL,
							Name CHAR(70) Not NULL,
							ExchangeID CHAR(6) Not NULL,
							SK_CompanyID INTEGER Not NULL REFERENCES DimCompany (SK_CompanyID),
							SharesOutstanding INTEGER Not NULL,
							FirstTrade DATE Not NULL,
							FirstTradeOnExchange DATE Not NULL,
							Dividend INTEGER Not NULL,
							IsCurrent BOOLEAN Not NULL,
							BatchID numeric(5) Not NULL,
							EffectiveDate DATE Not NULL,
							EndDate DATE Not NULL
);

CREATE TABLE DimTime ( SK_TimeID INTEGER Not NULL PRIMARY KEY,
						TimeValue TIME Not NULL,
						HourID numeric(2) Not NULL,
						HourDesc CHAR(20) Not NULL,
						MinuteID numeric(2) Not NULL,
						MinuteDesc CHAR(20) Not NULL,
						SecondID numeric(2) Not NULL,
						SecondDesc CHAR(20) Not NULL,
						MarketHoursFlag BOOLEAN,
						OfficeHoursFlag BOOLEAN
);

CREATE TABLE DimTrade (	TradeID INTEGER Not NULL,
						SK_BrokerID INTEGER REFERENCES DimBroker (SK_BrokerID),
						SK_CreateDateID INTEGER Not NULL REFERENCES DimDate (SK_DateID),
						SK_CreateTimeID INTEGER Not NULL REFERENCES DimTime (SK_TimeID),
						SK_CloseDateID INTEGER REFERENCES DimDate (SK_DateID),
						SK_CloseTimeID INTEGER REFERENCES DimTime (SK_TimeID),
						Status CHAR(10) Not NULL,
						DT_Type CHAR(12) Not NULL,
						CashFlag BOOLEAN Not NULL,
						SK_SecurityID INTEGER Not NULL REFERENCES DimSecurity (SK_SecurityID),
						SK_CompanyID INTEGER Not NULL REFERENCES DimCompany (SK_CompanyID),
						Quantity numeric(6,0) Not NULL,
						BidPrice numeric(8,2) Not NULL,
						SK_CustomerID INTEGER Not NULL REFERENCES DimCustomer (SK_CustomerID),
						SK_AccountID INTEGER Not NULL REFERENCES DimAccount (SK_AccountID),
						ExecutedBy CHAR(64) Not NULL,
						TradePrice numeric(8,2),
						Fee numeric(10,2),
						Commission numeric(10,2),
						Tax numeric(10,2),
						BatchID numeric(5) Not Null
);

CREATE TABLE DImessages ( MessageDateAndTime TIMESTAMP Not NULL,
							BatchID numeric(5) Not NULL,
							MessageSource CHAR(30),
							MessageText CHAR(50) Not NULL,
							MessageType CHAR(12) Not NULL,
							MessageData CHAR(100)
);

CREATE TABLE FactCashBalances ( SK_CustomerID INTEGER Not Null REFERENCES DimCustomer (SK_CustomerID),
								SK_AccountID INTEGER Not Null REFERENCES DimAccount (SK_AccountID),
								SK_DateID INTEGER Not Null REFERENCES DimDate (SK_DateID),
								Cash numeric(15,2) Not Null,
								BatchID numeric(5)
);

CREATE TABLE FactHoldings (	TradeID INTEGER Not NULL,
							CurrentTradeID INTEGER Not Null,
							SK_CustomerID INTEGER Not NULL REFERENCES DimCustomer (SK_CustomerID),
							SK_AccountID INTEGER Not NULL REFERENCES DimAccount (SK_AccountID),
							SK_SecurityID INTEGER Not NULL REFERENCES DimSecurity (SK_SecurityID),
							SK_CompanyID INTEGER Not NULL REFERENCES DimCompany (SK_CompanyID),
							SK_DateID INTEGER Not NULL REFERENCES DimDate (SK_DateID),
							SK_TimeID INTEGER Not NULL REFERENCES DimTime (SK_TimeID),
							CurrentPrice INTEGER CHECK (CurrentPrice > 0) ,
							CurrentHolding numeric(6) Not NULL,
							BatchID numeric(5)
);

CREATE TABLE FactMarketHistory (    SK_SecurityID INTEGER Not Null REFERENCES DimSecurity (SK_SecurityID),
									SK_CompanyID INTEGER Not Null REFERENCES DimCompany (SK_CompanyID),
									SK_DateID INTEGER Not Null REFERENCES DimDate (SK_DateID),
									PERatio numeric(10,2),
									Yield numeric(5,2) Not Null,
									FiftyTwoWeekHigh numeric(8,2) Not Null,
									SK_FiftyTwoWeek INTEGER Not Null,
									FiftyTwoWeekLow numeric(8,2) Not Null,
									SK_FiftyTwoWeekL INTEGER Not Null,
									ClosePrice numeric(8,2) Not Null,
									DayHigh numeric(8,2) Not Null,
									DayLow numeric(8,2) Not Null,
									Volume numeric(12) Not Null,
									BatchID numeric(5)
);

CREATE TABLE FactWatches ( SK_CustomerID INTEGER Not NULL REFERENCES DimCustomer (SK_CustomerID),
							SK_SecurityID INTEGER Not NULL REFERENCES DimSecurity (SK_SecurityID),
							SK_DateID_DatePlaced INTEGER Not NULL REFERENCES DimDate (SK_DateID),
							SK_DateID_DateRemoved INTEGER REFERENCES DimDate (SK_DateID),
							BatchID numeric(5) Not Null 
);

CREATE TABLE Industry ( IN_ID CHAR(2) Not NULL,
						IN_NAME CHAR(50) Not NULL,
						IN_SC_ID CHAR(4) Not NULL
);

CREATE TABLE Financial ( SK_CompanyID INTEGER Not NULL REFERENCES DimCompany (SK_CompanyID),
						FI_YEAR numeric(4) Not NULL,
						FI_QTR numeric(1) Not NULL,
						FI_QTR_START_DATE DATE Not NULL,
						FI_REVENUE numeric(15,2) Not NULL,
						FI_NET_EARN numeric(15,2) Not NULL,
						FI_BASIC_EPS numeric(10,2) Not NULL,
						FI_DILUT_EPS numeric(10,2) Not NULL,
						FI_MARGIN numeric(10,2) Not NULL,
						FI_INVENTORY numeric(15,2) Not NULL,
						FI_ASSETS numeric(15,2) Not NULL,
						FI_LIABILITY numeric(15,2) Not NULL,
						FI_OUT_BASIC numeric(12) Not NULL,
						FI_OUT_DILUT numeric(12) Not NULL
);

CREATE TABLE Prospect ( AgencyID CHAR(30) NOT NULL UNIQUE,  
						SK_RecordDateID INTEGER NOT NULL, 
						SK_UpdateDateID INTEGER NOT NULL REFERENCES DimDate (SK_DateID),
						BatchID numeric(5) NOT NULL,
						IsCustomer BOOLEAN NOT NULL,
						LastName CHAR(30) NOT NULL,
						FirstName CHAR(30) NOT NULL,
						MiddleInitial CHAR(1),
						Gender CHAR(1),
						AddressLine1 CHAR(80),
						AddressLine2 CHAR(80),
						PostalCode CHAR(12),
						City CHAR(25) NOT NULL,
						State CHAR(20) NOT NULL,
						Country CHAR(24),
						Phone CHAR(30), 
						Income numeric(9),
						numericberCars numeric(2), 
						numericberChildren numeric(2), 
						MaritalStatus CHAR(1), 
						Age numeric(3),
						CreditRating numeric(4),
						OwnOrRentFlag CHAR(1), 
						Employer CHAR(30),
						numericberCreditCards numeric(2), 
						NetWorth numeric(12),
						MarketingNameplate CHAR(100)
);

CREATE TABLE StatusType ( ST_ID CHAR(4) Not NULL,
							ST_NAME CHAR(10) Not NULL
);

CREATE TABLE TaxRate ( TX_ID CHAR(4) Not NULL,
						TX_NAME CHAR(50) Not NULL,
						TX_RATE numeric(6,5) Not NULL
);

CREATE TABLE TradeType ( TT_ID CHAR(3) Not NULL,
							TT_NAME CHAR(12) Not NULL,
							TT_IS_SELL numeric(1) Not NULL,
							TT_IS_MRKT numeric(1) Not NULL
);

CREATE TABLE AuditTable ( DataSet CHAR(20) Not Null,
							BatchID numeric(5),
							AT_Date DATE,
							AT_Attribute CHAR(50),
							AT_Value numeric(15),
							DValue numeric(15,5)
);

CREATE INDEX PIndex ON dimtrade (tradeid);
CREATE TABLE dimtradeforexperiment
(
  tradeid integer NOT NULL,
  sk_brokerid integer,
  date_int integer,
  time_int integer,
  status character(10) NOT NULL,
  dt_type character(12) NOT NULL,
  cashflag boolean NOT NULL,
  sk_securityid integer NOT NULL,
  sk_companyid integer NOT NULL,
  quantity numeric(6,0) NOT NULL,
  bidprice numeric(8,2) NOT NULL,
  sk_customerid integer NOT NULL,
  sk_accountid integer NOT NULL,
  executedby character(64) NOT NULL,
  tradeprice numeric(8,2),
  fee numeric(10,2),
  commission numeric(10,2),
  tax numeric(10,2),
  batchid numeric(5,0) NOT NULL,
  th_st_id character(4)
);


