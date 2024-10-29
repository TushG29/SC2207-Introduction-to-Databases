/* Gets all the publication details. ID, Month and Year Published, and the total item quantity ordered for that publication per month*/
/* Aggregation */
WITH GROUPED_PUBLICATIONS_2 AS
(
	SELECT Pub_ID, month, year, SUM(ITEM_Qty) AS Times
	FROM (
		SELECT P.Pub_ID, O.month, O.year, I.ITEM_Qty
		FROM (
			SELECT ORDER_ID, Month(Date_time) as month, Year(Date_time) as year 
			FROM ORDERS
			) AS O,
			ITEMS_IN_ORDERS AS I,
			SIB_1 AS S, 
			PUBLICATION AS P
		WHERE O.ORDER_ID = I.ORDER_ID 
			AND I.STOCK_ID = S.STOCK_ID 
			AND I.BOOKSTORE_ID = S.BOOKSTORE_ID 
			AND S.Pub_ID = P.Pub_ID) AS X
	GROUP BY Pub_ID, month, year
)

/* Publications that are increasingly being purchased at least 3 months */
SELECT P.Pub_ID
FROM (
	SELECT X.Pub_ID
	FROM GROUPED_PUBLICATIONS_2 AS X
		JOIN GROUPED_PUBLICATIONS_2 AS Y
		ON X.Pub_ID = Y.Pub_ID 
			AND (
			(X.month < 12 AND (X.month + 1) = Y.month AND X.year = Y.year)
			/* accounts for publications that made be increasingly purchased over months that transition into the new year */
			OR (X.month = 12 AND Y.month = 1 AND (X.year + 1) = Y.year))
			AND X.Times < Y.Times
		JOIN GROUPED_PUBLICATIONS_2 AS Z
		ON Y.Pub_ID = Z.Pub_ID 
			AND ((Y.month < 12 AND (Y.month + 1) = Z.month AND Y.year = Z.year) 
			/* accounts for publications that made be increasingly purchased over months that transition into the new year */
			OR (Y.month = 12 AND Z.month = 1 AND (Y.year + 1) = Z.year)) 
			AND Y.Times < Z.Times
	) AS B,
	PUBLICATION AS P
WHERE P.Pub_ID = B.Pub_ID



