SELECT (
		--Case 1: 
			--Start Date < 1 Aug 
			--End Date in August 
		(SELECT COALESCE(SUM(CAST(PRICE AS FLOAT)*(DATEDIFF(Day, '2022-08-01', End_Date)+1)), 0) as price_sum
		FROM PRICE_HISTORY
		WHERE EXISTS (SELECT SIB_1.BOOKSTORE_ID, SIB_1.Stock_ID
					FROM BOOKS JOIN SIB_1 ON BOOKS.Pub_ID = SIB_1.Pub_ID
					WHERE Title = 'Harry Porter Finale' 
						AND PRICE_HISTORY.Bookstore_ID = SIB_1.BOOKSTORE_ID 
						AND PRICE_HISTORY.Stock_ID = SIB_1.Stock_ID)
		AND End_Date BETWEEN '2022-08-01' AND '2022-08-30'
		AND Start_Date <  '2022-08-01')

		+
		--Case 2: 
			--Start Date in August 
			--End Date after august 
		(SELECT COALESCE(SUM(CAST(PRICE AS FLOAT)*(DATEDIFF(Day, Start_Date, '2022-08-31')+1)),0) as price_sum
		FROM PRICE_HISTORY
		WHERE EXISTS (SELECT SIB_1.BOOKSTORE_ID, SIB_1.Stock_ID
					FROM BOOKS JOIN SIB_1 ON BOOKS.Pub_ID = SIB_1.Pub_ID
					WHERE Title = 'Harry Porter Finale' 
						AND PRICE_HISTORY.Bookstore_ID = SIB_1.BOOKSTORE_ID 
						AND PRICE_HISTORY.Stock_ID = SIB_1.Stock_ID)
		AND Start_Date BETWEEN '2022-08-02' AND '2022-08-31'
		AND End_Date > '2022-08-31')

		+
		--Case 3: 
			--Start Date before August
			--End Date after August 
		(SELECT COALESCE(SUM(CAST(PRICE AS FLOAT)*(DATEDIFF(Day, '2022-08-01', '2022-08-31')+1)), 0) as price_sum
		FROM PRICE_HISTORY
		WHERE EXISTS (SELECT SIB_1.BOOKSTORE_ID, SIB_1.Stock_ID
					FROM BOOKS JOIN SIB_1 ON BOOKS.Pub_ID = SIB_1.Pub_ID
					WHERE Title = 'Harry Porter Finale' 
					AND PRICE_HISTORY.Bookstore_ID = SIB_1.BOOKSTORE_ID 
					AND PRICE_HISTORY.Stock_ID = SIB_1.Stock_ID)
		AND Start_Date < '2022-08-01'
		AND End_Date > '2022-08-31')

		+
		--Case 4
			--Start Date In August 
			--End Date in August 
		(SELECT COALESCE(SUM(CAST(PRICE AS FLOAT)*(DATEDIFF(Day, Start_Date, End_Date)+1)), 0) as price_sum
		FROM PRICE_HISTORY
		WHERE EXISTS (SELECT SIB_1.BOOKSTORE_ID, SIB_1.Stock_ID
					FROM BOOKS JOIN SIB_1 ON BOOKS.Pub_ID = SIB_1.Pub_ID
					WHERE Title = 'Harry Porter Finale' 
					AND PRICE_HISTORY.Bookstore_ID = SIB_1.BOOKSTORE_ID 
					AND PRICE_HISTORY.Stock_ID = SIB_1.Stock_ID)
		AND Start_Date BETWEEN '2022-08-01' AND '2022-08-31'
		AND End_Date BETWEEN '2022-08-01' AND '2022-08-31')

)/(31*COUNT(BOOKSTORE_ID)) as average_price
from BOOKS, SIB_1
where title = 'Harry Porter Finale'
	and books.Pub_ID = SIB_1.Pub_ID