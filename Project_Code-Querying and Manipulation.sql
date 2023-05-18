--1. Which materials are currently available in the library?
SELECT * 
FROM Material 
WHERE Material_ID NOT IN 
    (SELECT Material_ID 
     FROM Borrow 
     WHERE Return_Date IS NULL);

--2. Which materials are currently overdue? Suppose today is 04/01/2023, and show the borrow date and due date of each material
SELECT *
FROM Material
WHERE Material_ID IN (
    SELECT Material_ID
    FROM Borrow
    WHERE Due_Date < '2023-04-01' AND Return_Date IS NULL
);

--3. What are the top 10 most borrowed materials in the library? Show the title of each material and order them based on their available counts
SELECT Material.Title, COUNT(*) AS Borrow_Count 
FROM Borrow 
JOIN Material ON Borrow.Material_ID = Material.Material_ID 
WHERE Borrow.Return_Date IS NOT NULL 
GROUP BY Material.Title 
ORDER BY COUNT(*) DESC 
LIMIT 10;

--4. How many books has the author Lucas Piki written?
SELECT COUNT(*) as Book_Count
FROM Material
JOIN Authorship ON Material.Material_ID = Authorship.Material_ID
JOIN Author ON Authorship.Author_ID = Author.Author_ID
WHERE Author.Name = 'Lucas Piki';

--5. How many books were written by two or more authors?
SELECT COUNT(*) as Book_Count
FROM (
    SELECT Material.Material_ID, COUNT(*) as Author_Count
    FROM Material
    JOIN Authorship ON Material.Material_ID = Authorship.Material_ID
    GROUP BY Material.Material_ID
) as Book_Author_Count
WHERE Book_Author_Count.Author_Count >= 2 AND EXISTS (
    SELECT *
    FROM Material
    WHERE Material.Material_ID = Book_Author_Count.Material_ID
);

--6. What are the most popular genres in the library?
SELECT Genre.Name, COUNT(*) as Borrow_Count
FROM Material
JOIN Genre ON Material.Genre_ID = Genre.Genre_ID
JOIN Borrow ON Material.Material_ID = Borrow.Material_ID
WHERE Borrow.Return_Date IS NOT NULL
GROUP BY Genre.Genre_ID
ORDER BY Borrow_Count DESC;

--7. How many materials have been borrowed from 09/2020-10/2020?
SELECT COUNT(*) as Total_Borrows 
FROM Borrow
WHERE Borrow_Date BETWEEN '2020-09-01' AND '2020-10-31';  

--8. How do you update the “Harry Potter and the Philosopher's Stone” when it is returned on 04/01/2023?
UPDATE Borrow
SET Return_Date = '2023-04-01'
WHERE Material_ID = (
 SELECT Material_ID 
 FROM Material 
 WHERE Title = 'Harry Potter and the Philosopher''s Stone')
AND Return_Date IS NOT NULL;

--9. How do you delete the member Emily Miller and all her related records from the database?
DELETE FROM Borrow
WHERE Member_ID = (
    SELECT Member_ID
    FROM Member
    WHERE Name = 'Emily Miller'
);

DELETE FROM Member
WHERE Name = 'Emily Miller';

--10. How do you add the following material to the database?
--Title: New book
--Date: 2020-08-01
--Catalog: E-Books
--Genre: Mystery & Thriller
--Author: Lucas Pipi

INSERT INTO Material (Material_ID, Title, Publication_Date, Catalog_ID, Genre_ID)
VALUES (32, 'New book', '2020-08-01', 3, (
SELECT Genre_ID
FROM Genre
WHERE Name = 'Mystery & Thriller'
));

INSERT INTO Authorship (Authorship_ID, Author_ID, Material_ID)
VALUES (34, 20, 32
); 
