CREATE TABLE EMPLOYEES(
	EID INT NOT NULL,
	EMPLOYEE_NAME VARCHAR(MAX) NOT NULL,
	EMPLOYEE_SALARY FLOAT NOT NULL,
	PRIMARY KEY (EID)
);

CREATE TABLE BOOKSTORE(
	ID INT NOT NULL,
	PRIMARY KEY (ID)
);

CREATE TABLE CUSTOMERS(
	CID INT NOT NULL,
	NAME VARCHAR(MAX) NOT NULL,
	PRIMARY KEY (CID)
);

CREATE TABLE ORDERS(
	ORDER_ID INT NOT NULL,
	Date_Time DATE NOT NULL,
	SHIPPING_ADDRESS VARCHAR(200) NOT NULL,
	CID INT NOT NULL,

	PRIMARY KEY (ORDER_ID),
	FOREIGN KEY (CID) REFERENCES CUSTOMERS(CID)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
);

CREATE TABLE PUBLICATION(
	Pub_ID INT NOT NULL,
	Publisher VARCHAR(200) NOT NULL,
	Year INT NOT NULL,
	PRIMARY KEY (Pub_ID)
);

CREATE TABLE COMPLAINTS(
	ID INT NOT NULL,
	Filed_date_time DATE NOT NULL,
	Text VARCHAR(MAX) NOT NULL,
	CID INT NOT NULL,

	PRIMARY KEY (ID),
	FOREIGN KEY (CID) REFERENCES CUSTOMERS(CID)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
);

CREATE TABLE COMPLAINTS_STATUS(
	COMPLAINTS_ID INT NOT NULL,
	Date DATE NOT NULL,
	STATE VARCHAR(200) NOT NULL,

	PRIMARY KEY (Date, COMPLAINTS_ID),
	FOREIGN KEY (COMPLAINTS_ID) REFERENCES COMPLAINTS(ID)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
);

CREATE TABLE COMPLAINTS_ON_BOOKSTORE(
	COMPLAINTS_ID INT NOT NULL,
	BOOKSTORE_ID INT NOT NULL,

	PRIMARY KEY (COMPLAINTS_ID, BOOKSTORE_ID),
	FOREIGN KEY (COMPLAINTS_ID) REFERENCES COMPLAINTS(ID)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	FOREIGN KEY(BOOKSTORE_ID) REFERENCES BOOKSTORE(ID)
);

CREATE TABLE COMPLAINTS_ON_ORDERS(
	COMPLAINTS_ID INT NOT NULL,
	ORDER_ID INT NOT NULL,

	PRIMARY KEY (COMPLAINTS_ID, ORDER_ID),
	FOREIGN KEY (COMPLAINTS_ID) REFERENCES COMPLAINTS(ID)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	FOREIGN KEY(ORDER_ID) REFERENCES ORDERS(ORDER_ID)
);

CREATE TABLE HANDLED(
	COMPLAINTS_ID INT NOT NULL,
	EID INT NOT NULL,
	Handled_date_time DATE

	PRIMARY KEY (COMPLAINTS_ID),
	FOREIGN KEY (COMPLAINTS_ID) REFERENCES COMPLAINTS(ID)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
);

CREATE TABLE SIB_1(
	Pub_ID INT NOT NULL,
	BOOKSTORE_ID INT NOT NULL,
	Stock_ID INT NOT NULL,

	PRIMARY KEY (Pub_ID, BOOKSTORE_ID),
	FOREIGN KEY (Pub_ID) REFERENCES PUBLICATION(Pub_ID)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	FOREIGN KEY (BOOKSTORE_ID) REFERENCES BOOKSTORE(ID)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
);

CREATE TABLE SIB_2(
	Stock_ID INT NOT NULL,
	BOOKSTORE_ID INT NOT NULL,
	Stock_Price INT NOT NULL,
	Stock_Qty INT NOT NULL,

	PRIMARY KEY (Stock_ID, BOOKSTORE_ID),
	FOREIGN KEY (BOOKSTORE_ID) REFERENCES BOOKSTORE(ID)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
);

CREATE TABLE ITEMS_IN_ORDERS(
	ITEM_ID INT NOT NULL,
	STOCK_ID INT NOT NULL,
	ORDER_ID INT NOT NULL,
	BOOKSTORE_ID INT NOT NULL,
	ITEM_PRICE INT NOT NULL,
	ITEM_QTY INT NOT NULL,
	DELIVERY_DATE DATE NOT NULL,

	PRIMARY KEY (ITEM_ID, STOCK_ID, ORDER_ID),
	FOREIGN KEY (STOCK_ID, BOOKSTORE_ID) REFERENCES SIB_2(STOCK_ID, BOOKSTORE_ID)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	FOREIGN KEY (ORDER_ID) REFERENCES ORDERS(ORDER_ID)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
);

CREATE TABLE ITEMS_IN_ORDERS_STATUS(
	Date DATE NOT NULL,
	ITEM_ID INT NOT NULL,
	STOCK_ID INT NOT NULL,
	ORDER_ID INT NOT NULL,
	STATE VARCHAR(200) NOT NULL,
	PRIMARY KEY (Date, ITEM_ID, STOCK_ID, ORDER_ID),
	FOREIGN KEY (ITEM_ID, STOCK_ID, ORDER_ID) REFERENCES ITEMS_IN_ORDERS(ITEM_ID, STOCK_ID, ORDER_ID)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
);

CREATE TABLE FEEDBACK(
	CID INT DEFAULT NULL,
	ITEM_ID INT NOT NULL,
	STOCK_ID INT NOT NULL,
	ORDER_ID INT NOT NULL,
	COMMENT VARCHAR(MAX),
	RATING INT,
	CHECK (RATING < 6 AND RATING > 0),
	PRIMARY KEY (CID, ITEM_ID, STOCK_ID, ORDER_ID),
	FOREIGN KEY (CID) REFERENCES CUSTOMERS(CID)
		ON DELETE SET DEFAULT
		ON UPDATE CASCADE,
	FOREIGN KEY (ITEM_ID, STOCK_ID, ORDER_ID) REFERENCES ITEMS_IN_ORDERS(ITEM_ID, STOCK_ID, ORDER_ID)
);

CREATE TABLE PRICE_HISTORY(
	Stock_ID INT NOT NULL,
	Bookstore_ID INT NOT NULL,
	Price INT NOT NULL,
	Start_Date DATE NOT NULL,
	End_Date DATE NOT NULL,
	PRIMARY KEY (Stock_ID, Bookstore_ID, Price, Start_Date, End_Date),
	FOREIGN KEY (Stock_ID, Bookstore_ID) REFERENCES SIB_2(Stock_ID, Bookstore_ID)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
);

CREATE TABLE BOOKS(
	Pub_ID INT NOT NULL,
	Title VARCHAR(MAX) NOT NULL,

	PRIMARY KEY (Pub_ID),
	FOREIGN KEY (Pub_ID) REFERENCES PUBLICATION (Pub_ID)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
);

CREATE TABLE MAGAZINES(
	Pub_ID INT NOT NULL,
	Issue INT NOT NULL,
	Title VARCHAR(MAX) NOT NULL,

	PRIMARY KEY (Pub_ID),
	FOREIGN KEY (Pub_ID) REFERENCES PUBLICATION (Pub_ID)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
);