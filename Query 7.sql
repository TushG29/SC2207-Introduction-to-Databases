WITH combined AS 
(
	SELECT Pub_ID, title
	FROM BOOKS
	UNION
	SELECT Pub_ID, title
	FROM MAGAZINES
),
mostcomplains AS 
(
	SELECT c.CID
    FROM CUSTOMERS c
    JOIN COMPLAINTS co ON c.CID = co.CID
    GROUP BY c.CID
    HAVING COUNT(*) = (
        SELECT MAX(count_per)
        FROM (
            SELECT COUNT(*) AS count_per
            FROM COMPLAINTS 
            GROUP BY CID)
        AS count_per
    )
)

SELECT DISTINCT c.CID, c.NAME, combined.Pub_ID, combined.title, iio.ITEM_PRICE
FROM CUSTOMERS c
	JOIN COMPLAINTS co ON c.CID = co.CID
	JOIN ORDERS o ON o.CID = c.CID
	JOIN ITEMS_IN_ORDERS iio ON iio.ORDER_ID = o.ORDER_ID 
	JOIN SIB_2 s ON s.Stock_ID = iio.STOCK_ID AND iio.BOOKSTORE_ID=s.BOOKSTORE_ID
	JOIN SIB_1 s1 ON s1.BOOKSTORE_ID = s.BOOKSTORE_ID AND s1.Stock_ID = s.Stock_ID
	JOIN PUBLICATION p ON p.Pub_ID = s1.Pub_ID
	JOIN combined ON p.Pub_ID = combined.Pub_ID
WHERE c.CID IN (
	SELECT CID 
	FROM mostcomplains)
AND iio.ITEM_PRICE = (
	SELECT MAX(iio2.ITEM_PRICE)
	FROM ITEMS_IN_ORDERS iio2
	JOIN ORDERS o2 ON o2.ORDER_ID = iio2.ORDER_ID
	WHERE o2.CID = c.CID
	)
ORDER BY ITEM_PRICE DESC