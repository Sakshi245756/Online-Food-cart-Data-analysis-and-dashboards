-- Q 1-- BEGIN

CREATE DATABASE seafoodkart;

--end

--BEGIN

USE seafoodkart;

--end

-- Q 2-- BEGIN

SELECT * FROM campaign_identifier AS C;
SELECT * FROM event_identifier AS EI;
SELECT * FROM events AS E;
SELECT * FROM page_heirarchy AS P;
SELECT * FROM users AS U;

SELECT TOP 1 * FROM campaign_identifier AS C;
SELECT TOP 1 * FROM event_identifier AS EI;
SELECT TOP 1 * FROM events AS E;
SELECT TOP 1 * FROM page_heirarchy AS P;
SELECT TOP 1 * FROM users AS U;

--END

--Q 3-- BEGIN
 
 --a--
ALTER TABLE users
ALTER COLUMN START_DATE DATE;

--b--
ALTER TABLE events
ALTER COLUMN EVENT_TIME DATETIME;

--c--
ALTER TABLE campaign_identifier
ALTER COLUMN START_DATE DATE;

ALTER TABLE campaign_identifier
ALTER COLUMN END_DATE DATE;

--END 

-- Q 4 --BEGIN

SELECT * FROM (
              SELECT 'campaign_identifier' AS TABLE_NAME, 
              COUNT(*) AS NO_OF_RECORDS FROM campaign_identifier UNION ALL
              SELECT 'event_identifier' AS TABLE_NAME,
			  COUNT(*) AS NO_OF_RECORDS FROM event_identifier UNION ALL
              SELECT 'events' AS TABLE_NAME, 
			  COUNT(*) AS NO_OF_RECORDS FROM events UNION ALL
              SELECT 'page_heirarchy' as TABLE_NAME,
			  COUNT(*) AS NO_OF_RECORDS FROM page_heirarchy UNION ALL
              SELECT 'users' AS TABLE_NAME,
			  COUNT(*) AS NO_OF_RECORDS FROM users
			  ) AS A;

--END

-- Q 5 --BEGIN

SELECT * INTO final_raw_data FROM (
                                  SELECT * FROM (
                                  SELECT E.*,EI.event_name, P.page_name, P.product_category, P.product_id, U.user_id,
                                  U.start_date, C.campaign_id, C.campaign_name, C.end_date, C.products
                                  FROM events AS E
                                  left JOIN event_identifier AS EI
                                  ON E.event_type= EI.event_type
                                  left JOIN page_heirarchy AS P
                                  ON E.page_id= P.page_id
                                  LEFT JOIN users AS U
                                  ON E.cookie_id= U.cookie_id
                                  LEFT JOIN campaign_identifier AS C
                                  ON U.start_date = C.start_date
) AS A
) AS B;


--END 

--Q 6--BEGIN


SELECT * INTO product_level_summary FROM (
                                          SELECT F.product_id,
                                          SUM(CASE WHEN F.event_name= 'Page View' THEN 1 ELSE 0 END) AS COUNT_VIEW,
                                          SUM(CASE WHEN F.event_name= 'Add to Cart' THEN 1 ELSE 0 END) AS COUNT_ADD_CART,
                                          SUM(CASE WHEN F.event_name= 'Purchase' THEN 1 ELSE 0 END) AS COUNT_PURCHASE,
                                          SUM(CASE WHEN F.event_name= 'Add to Cart'
										  AND F.event_name <> 'Purchase' THEN 1 ELSE 0 END) AS COUNT_ABAND
                                          FROM final_raw_data AS F 
                                          GROUP BY F.product_id
)AS A;


--END 

--Q 7--BEGIN

SELECT * INTO product_category_level_summary FROM ( 
                                                   SELECT  F.product_category,
                                                   SUM(CASE WHEN F.event_name= 'PAGE VIEW' THEN 1 ELSE 0 END) AS COUNT_VIEW,
                                                   SUM(CASE WHEN F.event_name= 'PURCHASE' THEN 1  ELSE 0 END) AS COUNT_PURCHASE,
                                                   SUM(CASE WHEN F.event_name= 'ADD TO CART'
												   AND F.event_name <> 'PURCHASED' THEN 1  ELSE 0 END) AS COUNT_ABAND
                                                   FROM final_raw_data AS F 
                                                   GROUP BY F.product_category
)AS A;
 

--END

--Q 8--BEGIN


SELECT * INTO visit_summary from (
                               SELECT F.user_id, F.visit_id, MIN(F.event_name) AS visit_start_time,
                               MAX (F.campaign_name) AS Campaign_name, STRING_AGG(F.visit_id,',')
							   WITHIN GROUP (ORDER BY F.sequence_number) as cart_products,
                               SUM(CASE WHEN F.event_name='AD IMPRESSION' THEN 1 ELSE 0 END) AS impression,
                               SUM(CASE WHEN F.event_name='AD CLICK' THEN 1 ELSE 0 END) AS click,
                               SUM(CASE WHEN F.event_name='PAGE VIEW' THEN 1 ELSE 0 END) AS page_view,
                               SUM(CASE WHEN F.event_name='PURCHASE' THEN 1 ELSE 0 END) AS purchase,
                               SUM(CASE WHEN F.event_name='ADD TO CART' THEN 1 ELSE 0 END) AS cart_adds
							   FROM final_raw_data AS F
                               WHERE F.event_name ='ADD TO CART' OR F.event_name = 'AD IMPRESSION' OR F.event_name = 'AD CLICK'
                               OR F.event_name = 'PAGE VIEW' OR F.event_name = 'PURCHASE'
                               GROUP BY F.user_id, F.visit_id 
)AS A
ORDER BY user_id ASC ;

--END
