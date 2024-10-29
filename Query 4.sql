WITH AvgLatencyEmployee AS (
	SELECT EID, AVG(CAST(DATEDIFF(DAY, c2.Date, c.Date) AS FLOAT)) as AvgLatency
	FROM COMPLAINTS_STATUS AS c
	INNER JOIN COMPLAINTS_STATUS AS c2 ON c.COMPLAINTS_ID=c2.COMPLAINTS_ID AND c2.STATE='being handled'
	INNER JOIN HANDLED ON c.COMPLAINTS_ID=HANDLED.COMPLAINTS_ID
	WHERE c.STATE = 'addressed'
	GROUP BY EID
)

SELECT EID
FROM AvgLatencyEmployee
WHERE AvgLatency = (
	SELECT MIN(AvgLatency)
	FROM AvgLatencyEmployee
	)