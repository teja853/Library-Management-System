CREATE DATABASE LibraryManagementDB;
USE LibraryManagementDB;

CREATE TABLE Category (
    Category_ID INT PRIMARY KEY AUTO_INCREMENT,
    Category_Name VARCHAR(100) NOT NULL UNIQUE,
    Description TEXT
);

CREATE TABLE Publisher (
    Publisher_ID INT PRIMARY KEY AUTO_INCREMENT,
    Publisher_Name VARCHAR(150) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    Phone VARCHAR(20),
    Address TEXT
);

CREATE TABLE Author (
    Author_ID INT PRIMARY KEY AUTO_INCREMENT,
    Author_Name VARCHAR(150) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    Phone VARCHAR(20),
    Address TEXT
);

CREATE TABLE Librarian (
    Librarian_ID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    Phone VARCHAR(20),
    Salary DECIMAL(10, 2) CHECK (Salary >= 0)
);

CREATE TABLE Member (
    Member_ID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    Phone VARCHAR(20) NOT NULL,
    Address TEXT NOT NULL,
    Status VARCHAR(20) DEFAULT 'Active'
);

CREATE TABLE Book (
    Book_ID INT PRIMARY KEY AUTO_INCREMENT,
    Title VARCHAR(255) NOT NULL,
    ISBN VARCHAR(13) NOT NULL UNIQUE,
    Price DECIMAL(10, 2) CHECK (Price >= 0),
    Category_ID INT NOT NULL,
    Publisher_ID INT NOT NULL,
    FOREIGN KEY (Category_ID) REFERENCES Category(Category_ID) ON DELETE CASCADE,
    FOREIGN KEY (Publisher_ID) REFERENCES Publisher(Publisher_ID) ON DELETE CASCADE
);

CREATE TABLE Writes (
    Book_ID INT,
    Author_ID INT,
    PRIMARY KEY (Book_ID, Author_ID),
    FOREIGN KEY (Book_ID) REFERENCES Book(Book_ID) ON DELETE CASCADE,
    FOREIGN KEY (Author_ID) REFERENCES Author(Author_ID) ON DELETE CASCADE
);

CREATE TABLE Transaction (
    Transaction_ID INT PRIMARY KEY AUTO_INCREMENT,
    Issue_Date DATE NOT NULL,
    Return_Date DATE,
    Member_ID INT NOT NULL,
    Librarian_ID INT NOT NULL,
    FOREIGN KEY (Member_ID) REFERENCES Member(Member_ID) ON DELETE CASCADE,
    FOREIGN KEY (Librarian_ID) REFERENCES Librarian(Librarian_ID) ON DELETE CASCADE,
    CONSTRAINT CHK_Dates CHECK (Return_Date IS NULL OR Return_Date >= Issue_Date)
);

CREATE TABLE Transaction_Book (
    Transaction_ID INT,
    Book_ID INT,
    PRIMARY KEY (Transaction_ID, Book_ID),
    FOREIGN KEY (Transaction_ID) REFERENCES Transaction(Transaction_ID) ON DELETE CASCADE,
    FOREIGN KEY (Book_ID) REFERENCES Book(Book_ID) ON DELETE CASCADE
);

CREATE TABLE Fine (
    Fine_ID INT PRIMARY KEY AUTO_INCREMENT,
    Amount DECIMAL(10, 2) NOT NULL CHECK (Amount >= 0),
    Fine_Date DATE NOT NULL,
    Payment_Status VARCHAR(20) DEFAULT 'Pending' CHECK (Payment_Status IN ('Pending', 'Paid', 'Waived')),
    Transaction_ID INT UNIQUE NOT NULL,
    FOREIGN KEY (Transaction_ID) REFERENCES Transaction(Transaction_ID) ON DELETE CASCADE
);
