/* Combine both books and magazines into one view for easier access to all publication titles */
WITH combined AS 
(
	SELECT Pub_ID, title
	FROM BOOKS
	UNION
	SELECT Pub_ID, title
	FROM MAGAZINES
)

SELECT s.Pub_ID, title, COUNT(*) AS nBookstores
FROM SIB_1 AS s
	INNER JOIN combined 
ON s.Pub_ID = combined.Pub_ID
WHERE s.Pub_ID IN
	(
		SELECT PUBLICATION.Pub_ID
		FROM combined 
			INNER JOIN PUBLICATION ON combined.Pub_ID = PUBLICATION.Pub_ID
		WHERE Publisher = 'Nanyang Publisher Company'
	)
GROUP BY s.Pub_ID, title