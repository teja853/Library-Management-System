-- 1. Insert Sample Data
INSERT INTO Category(Category_ID, Category_Name, Description) VALUES 
(1, 'Fiction', 'Fictional novels and literature'), 
(2, 'Science', 'Scientific journals and textbooks'), 
(3, 'Technology', 'Computer science and software engineering'); 

INSERT INTO Publisher (Publisher_ID, Publisher_Name, Email, Phone, Address) VALUES 
(1, 'Pearson Education', 'contact@pearson.com', '9876543220', 'Delhi'), 
(2, 'Scribner', 'info@scribner.com', '9876543221', 'Mumbai');

INSERT INTO Author (Author_ID, Author_Name, Email, Phone, Address) VALUES 
(1, 'Abraham Silberschatz', 'silberschatz@gmail.com', '9876543230', 'Kolkata'), 
(2, 'F. Scott Fitzgerald', 'fitzgerald@gmail.com', '9876543231', 'Delhi'); 

INSERT INTO Librarian (Librarian_ID, Name, Email, Phone, Salary) VALUES 
(1, 'Suresh Kumar', 'suresh@library.com', '9876543240', 45000.00), 
(2, 'Anita Sharma', 'anita@library.com', '9876543241', 48000.00); 

INSERT INTO Member(Member_ID, Name, Email, Phone, Address) VALUES 
(1, 'Rishi', 'rishi@gmail.com', '9876543210', 'Hyderabad'), 
(2, 'Nandu', 'nandu@gmail.com', '9876543211', 'Vijayawada'), 
(3, 'Priya', 'priya@gmail.com', '9876543212', 'Chennai'), 
(4, 'Kiran', 'kiran@gmail.com', '9876543213', 'Bangalore'); 

INSERT INTO Book (Book_ID, Title, ISBN, Price, Category_ID, Publisher_ID) VALUES 
(1, 'Database System Concepts', '9780073523323', 650.00, 3, 1), 
(2, 'The Great Gatsby', '9780743273565', 350.00, 1, 2); 

INSERT INTO Writes (Book_ID, Author_ID) VALUES (1, 1), (2, 2); 

INSERT INTO Transaction (Transaction_ID, Issue_Date, Return_Date, Member_ID, Librarian_ID) VALUES 
(1, '2026-09-01', '2026-09-15', 1, 1), 
(2, '2026-09-05', NULL, 2, 2); 

INSERT INTO Transaction_Book (Transaction_ID, Book_ID) VALUES (1, 1), (2, 2); 

INSERT INTO Fine (Fine_ID, Amount, Fine_Date, Payment_Status, Transaction_ID) VALUES 
(1, 50.00, '2026-09-16', 'Pending', 1);

-- 2. Advanced Queries and Views
CREATE VIEW Active_Overdue_Loans AS
SELECT 
    m.Name AS Member_Name,
    b.Title AS Book_Title,
    t.Issue_Date,
    DATE_ADD(t.Issue_Date, INTERVAL 14 DAY) AS Due_Date,
    DATEDIFF(CURRENT_DATE, DATE_ADD(t.Issue_Date, INTERVAL 14 DAY)) * 5 AS Calculated_Fine
FROM Transaction t
JOIN Member m ON t.Member_ID = m.Member_ID
JOIN Transaction_Book tb ON t.Transaction_ID = tb.Transaction_ID
JOIN Book b ON tb.Book_ID = b.Book_ID
WHERE t.Return_Date IS NULL;

SELECT 
    c.Category_Name, 
    COUNT(b.Book_ID) AS Total_Books
FROM Category c
LEFT JOIN Book b ON c.Category_ID = b.Category_ID
GROUP BY c.Category_Name;

SELECT 
    Name, 
    Email 
FROM Member 
WHERE Member_ID IN (
    SELECT t.Member_ID 
    FROM Transaction t
    JOIN Fine f ON t.Transaction_ID = f.Transaction_ID
    WHERE f.Payment_Status = 'Pending'
);
