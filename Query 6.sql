/* Get the list of Bookstores with each non-refunded item's price, and item quantity bought in Aug 2022 and stores it as a view */
WITH BOOKSTORE_SALES AS
(
	SELECT BOOKSTORE_ID, SUM(ITEM_PRICE*ITEM_QTY) AS Revenue
	FROM (
		SELECT I.BOOKSTORE_ID, I.ITEM_PRICE, I.ITEM_QTY
		FROM ITEMS_IN_ORDERS AS I,
			(/* Select orders that were made in Aug 2022*/
			SELECT ORDER_ID
			FROM ORDERS
			WHERE Month(ORDERS.Date_Time)= '8' AND Year(ORDERS.Date_Time) = '2022'
			) AS O,
			(/* Remove those items that are returned, assumes that returned items purchased in August 2022 are not part of the revenue calculation*/
			SELECT DISTINCT ITEM_ID, STOCK_ID, ORDER_ID
			FROM ITEMS_IN_ORDERS_STATUS
			WHERE STATE != 'returned'
			) AS S
		WHERE O.ORDER_ID = I.ORDER_ID 
			AND I.ORDER_ID = S.ORDER_ID
			AND I.ITEM_ID = S.ITEM_ID
			AND I.STOCK_ID = S.STOCK_ID
		) AS ITEMS_SOLD_BY_BOOKSTORE
	GROUP BY BOOKSTORE_ID
)

SELECT *
FROM BOOKSTORE_SALES
WHERE Revenue IN (SELECT MAX(Revenue)
				  FROM BOOKSTORE_SALES)


