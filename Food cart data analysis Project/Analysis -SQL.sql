--BEGIN

USE seafoodkart;

--END

SELECT * FROM campaign_identifier AS C;
SELECT * FROM event_identifier AS EI;
SELECT * FROM events AS E;
SELECT * FROM page_heirarchy AS P;
SELECT * FROM users AS U;

--Digital Analysis--

--Q  1--BEGIN 

SELECT COUNT(DISTINCT(U.user_id)) AS NUM_OF_USERS FROM users AS U;

--END

--Q  2--BEGIN

SELECT F.user_id , COUNT(F.cookie_id) AS AVG_COOKIE FROM final_raw_data AS F
GROUP BY F.user_id
ORDER BY F.user_id ASC;

--END

--Q 3--BEGIN

SELECT F.user_id, MONTH(F.event_time) AS MONTH_, COUNT(F.visit_id) AS COUNT_VISIT FROM final_raw_data AS F
GROUP BY F.user_id , F.event_time
ORDER BY COUNT_VISIT DESC;


--END

--Q  4--BEGIN

SELECT F.user_id, MONTH(F.event_time) AS MONTH_, COUNT(F.visit_id) AS COUNT_VISIT FROM final_raw_data AS F
GROUP BY F.user_id , F.event_time
ORDER BY COUNT_VISIT DESC;

--END

-- Q 5 --BEGIN
SELECT (
        SUM(CASE WHEN F.event_name = 'PURCHASE' THEN 1 ELSE 0 END)*100/COUNT(*)) AS VISIT_PERC
		FROM final_raw_data AS F;
	

--END

--Q 6--BEGIN

SELECT TOP 1 F.event_name, (
        SUM(CASE WHEN F.event_name = 'PAGE VIEW' THEN 1 ELSE 0 END)*100/COUNT(*)) AS VISIT_PERC
FROM final_raw_data AS F
GROUP BY F.event_name
ORDER BY VISIT_PERC DESC;

--END

--Q  7--BEGIN

SELECT TOP 3 F.page_name, COUNT(F.event_name) AS NUM_OF_VIEWS FROM final_raw_data AS F
WHERE F.event_name = 'PAGE VIEW'
GROUP BY F.page_name
ORDER BY NUM_OF_VIEWS DESC;

--END

--Q 8--BEGIN

SELECT P.product_category, P.COUNT_VIEW AS NUM_VIWES,
P.COUNT_ADD_CART AS NUM_CART_ADDS FROM product_category_level_summary AS P;

--END

--Q--9--BEGIN

SELECT TOP 3 F.products, COUNT(F.event_name) AS PURCHASE FROM final_raw_data AS F 
WHERE F.event_name = 'PURCHASE'
GROUP BY F.products
ORDER BY PURCHASE DESC;

--END

--PRODUCT FUNNEL ANALYSIS--


--Q--10--BEGIN

--PRODUCT_LEVEL_SUMMARY
SELECT TOP 1 P.product_id,  P.COUNT_VIEW AS MOST_VIEWS FROM product_level_summary AS P 
GROUP BY P.product_id, P.COUNT_VIEW
ORDER BY MOST_VIEWS DESC 
SELECT TOP 1 P.product_id, 
P.COUNT_ADD_CART AS MOST_CART_ADD FROM product_level_summary AS P
GROUP BY P.product_id, P.COUNT_ADD_CART
ORDER BY MOST_CART_ADD DESC 
SELECT TOP 1 P.product_id, 
P.COUNT_PURCHASE AS MOST_PURCHASE FROM product_level_summary AS P
GROUP BY P.product_id, P.COUNT_PURCHASE
ORDER BY MOST_PURCHASE DESC;

 ---PRODUCT_CAT_LEVEL_SUMMARY
 SELECT TOP 1 P.product_category,  P.COUNT_VIEW AS MOST_VIEWS FROM product_category_level_summary AS P 
GROUP BY P.product_category, P.COUNT_VIEW
ORDER BY MOST_VIEWS DESC 
SELECT TOP 1 P.product_category, 
P.COUNT_ADD_CART AS MOST_CART_ADD FROM product_category_level_summary AS P
GROUP BY P.product_category, P.COUNT_ADD_CART
ORDER BY MOST_CART_ADD DESC 
SELECT TOP 1 P.product_category, 
P.COUNT_PURCHASE AS MOST_PURCHASE FROM product_category_level_summary AS P
GROUP BY P.product_category, P.COUNT_PURCHASE
ORDER BY MOST_PURCHASE DESC;
 




--Q  11--BEGIN

--PRODUCT_LEVEL_SUMMARY
SELECT TOP 1 P.PRODUCT_ID  , P.COUNT_ABAND  AS MOST_ABAND FROM product_level_summary AS P
GROUP BY P.product_id, P.COUNT_ABAND
ORDER BY MOST_ABAND DESC;

--PRODUCT_CAT_LEVEL_SUMMARY
SELECT TOP 1 P.product_category  , P.COUNT_ABAND  AS MOST_ABAND FROM product_category_level_summary AS P
GROUP BY P.product_category, P.COUNT_ABAND
ORDER BY MOST_ABAND DESC;

--END

--Q 12--BEGIN

--product_level_summary
SELECT top 1 P.product_id, SUM(P.COUNT_PURCHASE)*100/ SUM(P.COUNT_VIEW)  AS view_to_purchase_perc
FROM product_level_summary AS P
GROUP BY P.product_id
ORDER BY view_to_purchase_perc DESC;

--product_cat_level_summary
SELECT top 1 P.product_category, SUM(P.COUNT_PURCHASE)*100/ SUM(P.COUNT_VIEW)  AS view_to_purchase_perc
FROM product_category_level_summary AS P
GROUP BY P.product_category
ORDER BY view_to_purchase_perc DESC;

--END


--Q 13 --BEGIN

--PRODUCT_LEVEL_SUMMARY
SELECT A.SUM_ADD_CART*100/A.SUM_COUNT_VIEW AS AVG_CON_RATE FROM (
SELECT AVG(P.COUNT_ADD_CART) AS SUM_ADD_CART, AVG(P.COUNT_VIEW) AS SUM_COUNT_VIEW FROM
product_level_summary AS P)AS A;

--PRODUCT_CAT_LEVEL_SUMMARY
SELECT A.SUM_ADD_CART*100/A.SUM_COUNT_VIEW AS AVG_CON_RATE FROM (
SELECT AVG(P.COUNT_ADD_CART) AS SUM_ADD_CART, AVG(P.COUNT_VIEW) AS SUM_COUNT_VIEW FROM
product_category_level_summary AS P)AS A;

--END

--Q 14--BEGIN

--PRODUCT_LEVEL_SUMMARY
SELECT A.SUM_PURCHASE*100/A.SUM_CART AS AVG_CON_RATE FROM(
SELECT AVG(P.COUNT_ADD_CART) AS SUM_CART, AVG(P.COUNT_PURCHASE)
AS SUM_PURCHASE FROM product_level_summary AS P) AS A;

--PRODUCT_CAT_LAVEL_SUMMARY
SELECT A.SUM_PURCHASE*100/A.SUM_CART AS AVG_CON_RATE FROM(
SELECT AVG(P.COUNT_ADD_CART) AS SUM_CART, AVG(P.COUNT_PURCHASE) 
AS SUM_PURCHASE FROM product_category_level_summary AS P) AS A;

--END--


--CAMPAIGN ANALYSIS---

--Q 15 --BEGIN

SELECT V.user_id, V.Campaign_name, 
SUM(CASE WHEN V.impression= 0 THEN 1 END) AS COUNT__OF_NOT_RECEIVED_IMPR,
SUM(CASE WHEN V.impression = 1 THEN 1 END )AS COUNT_RECEIVED_IMPR
FROM visit_summary AS V
GROUP BY V.user_id, V.Campaign_name
ORDER BY V.user_id;

--END

--Q 16 ---BEGIN




