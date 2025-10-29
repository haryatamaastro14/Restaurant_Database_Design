-- 1. DDL - CREATE TABLE

--Customer
CREATE TABLE Customer (
    idcustomer   NUMBER(10) CONSTRAINT id_customer_pk PRIMARY KEY,
    customerName VARCHAR2(50) CONSTRAINT customer_name_nn NOT NULL,
    gender       VARCHAR2(10) CONSTRAINT customer_gender_nn NOT NULL,
    email        VARCHAR2(50),
    password     VARCHAR2(50) CONSTRAINT customer_password_nn NOT NULL,
    phoneNumber  VARCHAR2(13),
    customerdob  DATE,
    CONSTRAINT customer_gender_ck CHECK (gender in ('Male', 'Female')),
    CONSTRAINT customer_email_ck CHECK (REGEXP_LIKE(email, '^[A-Za-z0-9]+@gmail\.com$')),
    CONSTRAINT customer_phonenumber_ck CHECK (length(phoneNumber) between 10 and 13)
);
--Staff
CREATE TABLE Staff (
    idStaff   NUMBER(10) CONSTRAINT id_staff_pk PRIMARY KEY,
    staffName VARCHAR2(255) CONSTRAINT staff_name_nn NOT NULL,
    gender    VARCHAR2(10) CONSTRAINT staff_gender_nn NOT NULL,
    phoneNumber VARCHAR2(15) CONSTRAINT phone_number_nn NOT NULL,
    email VARCHAR2(255) CONSTRAINT staff_email_nn NOT NULL,
    password VARCHAR2(255) CONSTRAINT staff_password_nn NOT NULL,
    position VARCHAR2(50) CONSTRAINT staff_position_nn NOT NULL,
    CONSTRAINT staff_gender_ck CHECK (gender in ('Male', 'Female')),
    CONSTRAINT staff_email_ck CHECK (REGEXP_LIKE(email, '^[A-Za-z0-9]+@gmail\.com$')),
    CONSTRAINT staff_phonenumber_ck CHECK (length(phoneNumber) between 10 and 13)
);
--FullTime
CREATE TABLE FullTime (
    idStaff NUMBER(10) CONSTRAINT PK_FullTime PRIMARY KEY,
    monthlySalary INT CONSTRAINT NN_P_MonthlySalary NOT NULL,
    CONSTRAINT Fulltime_idStaff_FK FOREIGN KEY (idStaff) REFERENCES Staff(idStaff)
);
--PartTime
CREATE TABLE PartTime (
    idStaff NUMBER(10) CONSTRAINT PK_PartTime PRIMARY KEY,
    hourPaid INT CONSTRAINT NN_P_HourPaid NOT NULL,
    CONSTRAINT Parttime_idStaff_FK FOREIGN KEY (idStaff) REFERENCES Staff(idStaff)
);
--Menu
CREATE TABLE Menu (
    idMenu NUMBER(10),
    menuName VARCHAR(255) CONSTRAINT menu_menuName_NN NOT NULL,
    stock NUMBER,
    price NUMBER CONSTRAINT menu_price_NN NOT NULL,
    CONSTRAINT menu_idMenu_pk PRIMARY KEY (idMenu)
);
--Food
CREATE TABLE Food (
    idMenu NUMBER(10),
    isVegetarian VARCHAR2(5) CONSTRAINT food_isVegetarian_NN NOT NULL,
    CONSTRAINT food_idMenu_PK PRIMARY KEY (idMenu),
    CONSTRAINT food_idMenu_FK FOREIGN KEY (idMenu) REFERENCES Menu(idMenu),
    CONSTRAINT food_isVegetarian_YES CHECK (REGEXP_LIKE (isVegetarian, '^(yes|no)$'))
);
--Drink
CREATE TABLE Drink (
    idMenU NUMBER(10),
    drinkTemp VARCHAR(30) CONSTRAINT drink_drinkTemp_nn NOT NULL,
    CONSTRAINT drink_idMenu_pk PRIMARY KEY (idMenu),
    CONSTRAINT drink_idMenu_fk FOREIGN KEY (idMenu) REFERENCES Menu(idMenu)
);
--"ORDER"
CREATE TABLE "ORDER" (
    idOrder NUMBER(10),
    orderDate DATE CONSTRAINT order_orderDate_nn NOT NULL,
    status VARCHAR2(15),
    idStaff NUMBER(10),
    idCustomer NUMBER(10),
    CONSTRAINT order_idOrder_pk PRIMARY KEY(idOrder),
    CONSTRAINT order_idStaff_fk FOREIGN KEY (idStaff) REFERENCES Staff(idStaff),
    CONSTRAINT order_idCustomer_fk FOREIGN KEY (idCustomer) REFERENCES Customer(idCustomer)
);
--OrderDetail
CREATE TABLE OrderDetail (
    idOrder NUMBER,
    idMenu NUMBER,
    quantity NUMBER NOT NULL,
    CONSTRAINT order_detail_pk PRIMARY KEY (idOrder, idMenu),
    CONSTRAINT orderdetail_idOrder_fk FOREIGN KEY (idOrder) REFERENCES "ORDER"(idOrder),
    CONSTRAINT orderdetail_idMenu_fk FOREIGN KEY (idMenu) REFERENCES Menu(idMenu)
);
--TakeAway
CREATE TABLE TakeAway (
    idOrder NUMBER(10) CONSTRAINT PK_TakeAway PRIMARY KEY,
    pickUpTime TIMESTAMP CONSTRAINT NN_P_PickUpTime NOT NULL,
    CONSTRAINT TakeAway_idOrder_FK FOREIGN KEY (idOrder) REFERENCES "ORDER"(idOrder)
);
--DineIn
CREATE TABLE DineIn (
    idOrder NUMBER(10) CONSTRAINT PK_DineIn PRIMARY KEY,
    tableNumber NUMBER(10) CONSTRAINT NN_P_TableNumber NOT NULL,
    CONSTRAINT DineIn_idOrder_FK FOREIGN KEY (idOrder) REFERENCES "ORDER"(idOrder)
);
--Supplier
CREATE TABLE Supplier (
    idSupplier NUMBER(10) CONSTRAINT id_supplier_pk PRIMARY KEY,
    supplierName VARCHAR2(255) CONSTRAINT supplier_name_nn NOT NULL,
    address VARCHAR2(255) CONSTRAINT supplier_address_nn NOT NULL,
    phoneNumber VARCHAR2(13) CONSTRAINT supplier_phoneNumber_nn NOT NULL,
    email VARCHAR(255) CONSTRAINT supplier_email_nn NOT NULL,
    CONSTRAINT supplier_phoneNumber_ck CHECK(length(phoneNumber) between 10 and 13),
    CONSTRAINT supplier_email_ck CHECK(REGEXP_LIKE(email, '^[A-Za-z0-9]+@gmail\.com$'))
);
--RawMaterialType
CREATE TABLE RawMaterialType (
    idRawMaterialType NUMBER(10) CONSTRAINT PK_RawMaterialType PRIMARY KEY,
    typeName VARCHAR2(100) CONSTRAINT NN_RMT_TypeName NOT NULL,
    CONSTRAINT CK_RMT_TypeName_REGEX CHECK (REGEXP_LIKE(typeName, '^[A-Za-z ]+$'))
);
--RawMaterial
CREATE TABLE RawMaterial (    
    idRawMaterial NUMBER(10) CONSTRAINT PK_RawMaterial PRIMARY KEY,    
    name VARCHAR2(100) CONSTRAINT NN_RM_Name NOT NULL,    
    stock NUMBER(10) CONSTRAINT NN_RM_Stock NOT NULL,    
    status VARCHAR2(50) CONSTRAINT NN_RM_Status NOT NULL,    
    idRawMaterialType NUMBER(10) CONSTRAINT NN_RM_RMT_FK NOT NULL,    
    CONSTRAINT FK_RM_RMT FOREIGN KEY (idRawMaterialType) REFERENCES RawMaterialType(idRawMaterialType),    
    CONSTRAINT CK_RM_Status_IN CHECK (status IN ('Available', 'Low Stock', 'Out of Stock')),    
    CONSTRAINT CK_RM_Name_REGEX CHECK (REGEXP_LIKE(name, '^[A-Za-z0-9\s\-]+$'))
);
--Procurement
CREATE TABLE Procurement (    
    idProcurement NUMBER(10) CONSTRAINT PK_Procurement PRIMARY KEY,    
    procurementDate DATE CONSTRAINT NN_P_ProcurementDate NOT NULL,    
    status VARCHAR2(255) CONSTRAINT NN_P_Status NOT NULL,    
    idStaff NUMBER(10) CONSTRAINT NN_P_Staff_FK NOT NULL,    
    idSupplier NUMBER(10) CONSTRAINT NN_P_Supplier_FK NOT NULL,    
    CONSTRAINT FK_P_Staff FOREIGN KEY (idStaff) REFERENCES Staff(idStaff),
    CONSTRAINT FK_P_Supplier FOREIGN KEY (idSupplier) REFERENCES Supplier(idSupplier),    
    CONSTRAINT CK_P_Status CHECK (status IN ('pending', 'approved', 'rejected'))
);
--ProcurementDetail
CREATE TABLE ProcurementDetail (    
    idProcurement NUMBER(10) CONSTRAINT NN_PD_idProcurement NOT NULL,    
    idRawMaterial NUMBER(10) CONSTRAINT NN_PD_idRawMaterial NOT NULL, 
    quantity NUMBER(5) CONSTRAINT NN_PD_Quantity NOT NULL, 
    CONSTRAINT PK_ProcurementDetail PRIMARY KEY (idProcurement, idRawMaterial),    
    CONSTRAINT FK_PD_Procurement FOREIGN KEY (idProcurement) REFERENCES Procurement(idProcurement),    
    CONSTRAINT FK_PD_RawMaterial FOREIGN KEY (idRawMaterial) REFERENCES RawMaterial(idRawMaterial), 
    CONSTRAINT CK_PD_Quantity CHECK (quantity > 0)
);

-- 2. Sequence dan Index

--Customer
CREATE SEQUENCE idCustomer_seq
INCREMENT BY 1
START WITH 1
NOCACHE NOCYCLE;

CREATE INDEX IDX_Customer_Name
ON Customer(CustomerName);

--Staff
CREATE SEQUENCE idStaff_seq
INCREMENT BY 1
START WITH 1
NOCACHE NOCYCLE;

CREATE INDEX IDX_Staff_Position
ON Staff(Position);

--Order
CREATE SEQUENCE idOrder_seq
INCREMENT BY 1
START WITH 1
NOCACHE NOCYCLE;

CREATE INDEX IDX_Order_Status
ON "Order"(status);

--Menu
CREATE SEQUENCE idMenu_seq
INCREMENT BY 1
START WITH 1
NOCACHE NOCYCLE;

CREATE INDEX IDX_Menu_Stock
ON Menu(Stock);

--Supplier
CREATE SEQUENCE idStaff_seq
INCREMENT BY 1
START WITH 1
NOCACHE NOCYCLE;

CREATE INDEX IDX_Supplier_supplierName
ON Supplier(supplierName);

--RawMaterial
CREATE SEQUENCE idRawMaterial_seq
INCREMENT BY 1
START WITH 1
NOCACHE NOCYCLE;

CREATE INDEX IDX_RawMaterial_Name
ON RawMaterial(name);

--RawMaterialType
CREATE SEQUENCE idRawMaterialType_seq
INCREMENT BY 1
START WITH 1
NOCACHE NOCYCLE;

CREATE INDEX IDX_RawMaterialType_typeName
ON RawMaterialType(typeName);

--Procurement
CREATE SEQUENCE idProcurement_seq
INCREMENT BY 1
START WITH 1
NOCACHE NOCYCLE;

CREATE INDEX IDX_procurement_status
ON Procurement(status);

-- 3. DML - INSERT

--Customer
INSERT INTO Customer (idCustomer, customerName, gender, email, password, phoneNumber, customerDOB)
VALUES (idCustomer_seq.NEXTVAL, 'Budiman', 'Male', 'budiman123@gmail.com', 'budiman123', '081234567890', TO_DATE('1999-01-01', 'YYYY-MM-DD'));
INSERT INTO Customer (idCustomer, customerName, gender, email, password, phoneNumber, customerDOB)
VALUES (idCustomer_seq.NEXTVAL, 'Asep', 'Male', 'asep123@gmail.com', 'asep321', '081432567098', TO_DATE('2002-03-06', 'YYYY-MM-DD'));
INSERT INTO Customer (idCustomer, customerName, gender, email, password, phoneNumber, customerDOB)
VALUES (idCustomer_seq.NEXTVAL, 'Joko', 'Male', 'joko321@gmail.com', '123joko', '081936257908', TO_DATE('2000-08-09', 'YYYY-MM-DD'));

--Staff
INSERT INTO Staff (idStaff, staffName, gender, phoneNumber, email, password, position)
VALUES (idStaff_seq.NEXTVAL, 'Asep', 'Male', '891237849203', 'asep123@gmail.com', 'pw123', 'Cashier');
INSERT INTO Staff (idStaff, staffName, gender, phoneNumber, email, password, position)
VALUES (idStaff_seq.NEXTVAL, 'Marcelino', 'Male', '895125567891', 'marcelino@gmail.com', 'pw124', 'Chef');
INSERT INTO Staff (idStaff, staffName, gender, phoneNumber, email, password, position)
VALUES (idStaff_seq.NEXTVAL, 'Tiara', 'Male', '896743280129', 'tiara@gmail.com', 'pw125', 'Waiter');
INSERT INTO Staff (idStaff, staffName, gender, phoneNumber, email, password, position)
VALUES (idStaff_seq.NEXTVAL, 'Upin', 'Male', '89123887272', 'ipin@gmail.com', 'pw999', 'Chef');
INSERT INTO Staff (idStaff, staffName, gender, phoneNumber, email, password, position)
VALUES (idStaff_seq.NEXTVAL, 'Lisa', 'Female', '821673499800', 'lisa@gmail.com', 'pw800', 'Waiter');
INSERT INTO Staff (idStaff, staffName, gender, phoneNumber, email, password, position)
VALUES (idStaff_seq.NEXTVAL, 'Samsoedin', 'Male', '892123566672', 'soe@gmail.com', 'pw111', 'Purchasing Staff');

--FullTime
INSERT INTO FullTime (idStaff, monthlySalary) VALUES (1, 7500000);
INSERT INTO FullTime (idStaff, monthlySalary) VALUES (2, 7500000);
INSERT INTO FullTime (idStaff, monthlySalary) VALUES (3, 10000000);

--PartTime
INSERT INTO PartTime (idStaff, hourPaid) VALUES (4, 30000);
INSERT INTO PartTime (idStaff, hourPaid) VALUES (5, 30000);
INSERT INTO PartTime (idStaff, hourPaid) VALUES (6, 40000);

--SUpplier
INSERT INTO Supplier (idSupplier, supplierName, address, phoneNumber, email)
VALUES (idSupplier_seq.NEXTVAL, 'PT.Anggrek Jaya', 'Jl. Warna 10', '89566773420', 'anggrekjaya@gmail.com');
INSERT INTO Supplier (idSupplier, supplierName, address, phoneNumber, email)
VALUES (idSupplier_seq.NEXTVAL, 'PT.Kijang Satu', 'Jl. Barito 2', '89544553756', 'kijangsatu@gmail.com');
INSERT INTO Supplier (idSupplier, supplierName, address, phoneNumber, email)
VALUES (idSupplier_seq.NEXTVAL, 'PT.Cipta Bambu', 'Jl. in Aja 7', '89510932609', 'ciptabambu@gmail.com');

--Menu
INSERT INTO Menu (idMenu, menuName, stock, price)
VALUES (idMenu_seq.NEXTVAL, 'Nasi Goreng', 24, 20000);
INSERT INTO Menu (idMenu, menuName, stock, price)
VALUES (idMenu_seq.NEXTVAL, 'Mi Goreng', 44, 18000);
INSERT INTO Menu (idMenu, menuName, stock, price)
VALUES (idMenu_seq.NEXTVAL, 'Capcay Sayur', 14, 20000);
INSERT INTO Menu (idMenu, menuName, stock, price)
VALUES (idMenu_seq.NEXTVAL, 'Teh Manis Hangat', 25, 3000);
INSERT INTO Menu (idMenu, menuName, stock, price)
VALUES (idMenu_seq.NEXTVAL, 'Teh Manis Dinginr', 25, 4000);
INSERT INTO Menu (idMenu, menuName, stock, price)
VALUES (idMenu_seq.NEXTVAL, 'Hot Coffee Latte', 15, 5000);

--Food
INSERT INTO Food (idMenu, isVegetarian) VALUES (1, 'no');
INSERT INTO Food (idMenu, isVegetarian) VALUES (2, 'no');
INSERT INTO Food (idMenu, isVegetarian) VALUES (3, 'yes');

--Drink
INSERT INTO Drink (idMenu, drinkTemp) VALUES (4, 'Hot')
INSERT INTO Drink (idMenu, drinkTemp) Values (5, 'Cold')
INSERT INTO Drink (idMenu, drinkTemp) Values (6, 'Hot')

--Order
INSERT INTO "Order" (idOrder, orderDate, status, idStaff, idCustomer)
VALUES (idOrder_seq.NEXTVAL, TO_ORDER('2025-06-01', 'YYYY-MM-DD'), 'Done', 1, 1);
INSERT INTO "Order" (idOrder, orderDate, status, idStaff, idCustomer)
VALUES (idOrder_seq.NEXTVAL, TO_ORDER('2025-06-01', 'YYYY-MM-DD'), 'Done', 3, 2);
INSERT INTO "Order" (idOrder, orderDate, status, idStaff, idCustomer)
VALUES (idOrder_seq.NEXTVAL, TO_ORDER('2025-06-01', 'YYYY-MM-DD'), 'Done', 5, 3);
INSERT INTO "Order" (idOrder, orderDate, status, idStaff, idCustomer)
VALUES (idOrder_seq.NEXTVAL, TO_ORDER('2025-06-01', 'YYYY-MM-DD'), 'Done', 1, 3);
INSERT INTO "Order" (idOrder, orderDate, status, idStaff, idCustomer)
VALUES (idOrder_seq.NEXTVAL, TO_ORDER('2025-06-01', 'YYYY-MM-DD'), 'Done', 3, 1);
INSERT INTO "Order" (idOrder, orderDate, status, idStaff, idCustomer)
VALUES (idOrder_seq.NEXTVAL, TO_ORDER('2025-06-01', 'YYYY-MM-DD'), 'Done', 5, 2);

--OrderDetail
INSERT INTO OrderDetail (idOrder, idMenu, quantity) VALUES (1, 2, 1);
INSERT INTO OrderDetail (idOrder, idMenu, quantity) VALUES (2, 1, 2);
INSERT INTO OrderDetail (idOrder, idMenu, quantity) VALUES (3, 4, 4);
INSERT INTO OrderDetail (idOrder, idMenu, quantity) VALUES (4, 5, 3);
INSERT INTO OrderDetail (idOrder, idMenu, quantity) VALUES (5, 3, 2);
INSERT INTO OrderDetail (idOrder, idMenu, quantity) VALUES (6, 2, 1);

--TakeAway
INSERT INTO TakeAway (idOrder, pickUpTime)
VALUES (4, TO_TIMESTAMP('2025-06-01 14:30:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO TakeAway (idOrder, pickUpTime)
VALUES (5, TO_TIMESTAMP('2025-06-01 16:52:25', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO TakeAway (idOrder, pickUpTime)
VALUES (6, TO_TIMESTAMP('2025-06-03 08:13:40', 'YYYY-MM-DD HH24:MI:SS'));

--DineIn
INSERT INTO DineIn(idOrder, tableNumber) VALUES (1, '02');
INSERT INTO DineIn(idOrder, tableNumber) VALUES (2, '05');
INSERT INTO DineIn(idOrder, tableNumber) VALUES (3, '01');

--RawMaterialType
INSERT INTO RawMaterialType (idRawMaterialTy[e, typeName)
VALUES (idRawMaterialType_seq.NEXTVAL, 'Meat');
INSERT INTO RawMaterialType (idRawMaterialTy[e, typeName)
VALUES (idRawMaterialType_seq.NEXTVAL, 'Seasoning');
INSERT INTO RawMaterialType (idRawMaterialTy[e, typeName)
VALUES (idRawMaterialType_seq.NEXTVAL, 'Vegetable');

--RawMaterial
INSERT INTO RawMaterial (idRawMaterial, name, stock, status, idRawMaterialType)
VALUES (idRawMaterial_seq.NEXTVAL, 'Chicken', 53, 'Available', 1);
INSERT INTO RawMaterial (idRawMaterial, name, stock, status, idRawMaterialType)
VALUES (idRawMaterial_seq.NEXTVAL, 'Salt', 0, 'Out of Stock', 2);
INSERT INTO RawMaterial (idRawMaterial, name, stock, status, idRawMaterialType)
VALUES (idRawMaterial_seq.NEXTVAL, 'Broccoli', 80, 'Available', 3);

--Procurement
INSERT INTO Procurement (idProcurement, procurementDate, status, idStaff, idSupplier)
VALUES (idProcurement_seq.NEXTVAL, TO_DATE('2025-05-01', 'YYYY-MM-DD'), 'approved', 2, 1);
INSERT INTO Procurement (idProcurement, procurementDate, status, idStaff, idSupplier)
VALUES (idProcurement_seq.NEXTVAL, TO_DATE('2025-05-03', 'YYYY-MM-DD'), 'rejected', 1, 3);
INSERT INTO Procurement (idProcurement, procurementDate, status, idStaff, idSupplier)
VALUES (idProcurement_seq.NEXTVAL, TO_DATE('2025-05-04', 'YYYY-MM-DD'), 'pending', 2, 2);

--ProcurementDetail
INSERT INTO ProcurementDetail (idProcurement, idRawMaterial, quantity)
VALUES (1, 1, 4);
INSERT INTO ProcurementDetail (idProcurement, idRawMaterial, quantity)
VALUES (2, 3, 2);
INSERT INTO ProcurementDetail (idProcurement, idRawMaterial, quantity)
VALUES (3, 1, 2);

-- 4. Simple View
CREATE VIEW view_Staff_Male AS
SELECT * FROM Staff
WHERE gender = 'Male'
WITH CHECK OPTION;

-- 5. Outer Join dan Set Operator

--Outer Join
CREATE OR REPLACE VIEW vw_staff_procurement_outer_join AS
SELECT
    s.idStaff,
    s.staffName,
    COUNT(p.idProcurement) AS "Procurement Handled"
FROM
    staff s
LEFT OUTER JOIN
    procurement p ON s.idStaff = p.idStaff
GROUP BY
    s.idStaff, s.staffName;

--Set Operator
CREATE OR REPLACE VIEW vw_staff_procurement_set_operator AS
SELECT
    s.idStaff,
    s.staffName,
    COUNT(p.idProcurement) AS "Procurement Handled"
FROM staff s
JOIN procurement p ON S.idStaff = p.idStaff
GROUP BY s.idStaff, s.staffName
UNION
SELECT
    s.idStaff,
    s.staffName,
    0 AS "Procurement Handled"
FROM staff se
WHERE NOT EXISTS (
    SELECT * FROM procurement p WHERE p.idStaff = s.idStaff
)

--View Sub Query dan Set Operator

--Sub Query
CREATE VIEW View_Low_Supply_Items AS
SELECT * FROM Menu WHERE Stock <
(SELECT AVG (Stock) FROM Menu)

--Set Operator
CREATE VIEW Unassigned_Staff
AS
SELECT * FROM Staff
WHERE idStaff NOT IN (
    SELECT DISTINCT idStaff FROM "Order"
    WHERE idStaff IS NOT NULL
)