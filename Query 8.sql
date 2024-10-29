/* Find top 3 most purchased publications in August 2022. */
/* Aggregation */
WITH GROUPED_PUBLICATIONS AS
(
	SELECT Pub_ID, SUM(ITEM_QTY) AS SoldQuantity
	FROM (
		SELECT P.Pub_ID, I.ITEM_QTY
		FROM (
			SELECT ORDER_ID, Month(Date_time) AS month, Year(Date_time) AS year
			FROM ORDERS
			) AS O, 
			ITEMS_IN_ORDERS AS I,
			SIB_1 AS S, 
			PUBLICATION AS P
		WHERE O.month = '8' 
			AND O.year = '2022'
			AND O.ORDER_ID = I.ORDER_ID 
			AND I.STOCK_ID = S.STOCK_ID
			AND I.BOOKSTORE_ID = S.BOOKSTORE_ID 
			AND S.Pub_ID = P.Pub_ID
		) AS X
	GROUP BY Pub_ID
)

/* Full Query */
SELECT Pub_ID
FROM (/*Gets all publications except those unpurchased in July 2022*/
	SELECT Pub_ID
	FROM PUBLICATION

	EXCEPT

	(/*Finds unpurchased publications in July 2022*/
	SELECT DISTINCT P.Pub_ID
	FROM (
		SELECT ORDER_ID, Month(Date_time) AS month, Year(Date_time) AS year
		FROM ORDERS
		) AS O, 
		ITEMS_IN_ORDERS AS I,
		SIB_1 AS S, 
		PUBLICATION AS P
	WHERE O.month = '7' 
		AND O.year = '2022' 
		AND O.ORDER_ID = I.ORDER_ID
		AND I.STOCK_ID = S.STOCK_ID
		AND I.BOOKSTORE_ID = S.BOOKSTORE_ID
		AND S.Pub_ID = P.Pub_ID)
	) AS UNPURCHASED_PUBLICATIONS

INTERSECT

SELECT X.Pub_ID
FROM PUBLICATION AS X,
	GROUPED_PUBLICATIONS AS Y
WHERE X.Pub_ID = Y.Pub_ID AND Y.SoldQuantity >= (SELECT MIN(Z.SoldQuantity) -- This min would give the third highest sold quantity
												FROM (/* Selects the 3 highest sold quantities from grouped publications */
													 SELECT DISTINCT TOP 3 SoldQuantity 
													 FROM GROUPED_PUBLICATIONS
													 ORDER BY SoldQuantity DESC) AS Z)