SELECT COUNT(*) AS EmptyOrNullCount
FROM dbo.electricityPrices
WHERE (DateAvg IS NULL OR DateAvg = '')
   OR (PriceAvg IS NULL OR PriceAvg = '')
   OR (DateMin IS NULL OR DateMin = '')
   OR (PriceMin IS NULL OR PriceMin = '');

SELECT COUNT(*) AS PriceAvgNullCount
FROM dbo.electricityPrices
WHERE PriceAvg IS NULL OR PriceAvg = '';

SELECT COUNT(*) AS DateMinNullCount
FROM dbo.electricityPrices
WHERE DateMin IS NULL OR DateMin = '';

SELECT COUNT(*) AS PriceMinNullCount
FROM dbo.electricityPrices
WHERE PriceMin IS NULL OR PriceMin = '';



SELECT 'DateAvg' AS ColumnName, COUNT(*) AS EmptyCount
FROM dbo.electricityPrices
WHERE DateAvg IS NULL OR DateAvg = ''
UNION
SELECT 'PriceAvg' AS ColumnName, COUNT(*) AS EmptyCount
FROM dbo.electricityPrices
WHERE PriceAvg IS NULL OR PriceAvg = ''
UNION
SELECT 'DateMin' AS ColumnName, COUNT(*) AS EmptyCount
FROM dbo.electricityPrices
WHERE DateMin IS NULL OR DateMin = ''
UNION
SELECT 'PriceMin' AS ColumnName, COUNT(*) AS EmptyCount
FROM dbo.electricityPrices
WHERE PriceMin IS NULL OR PriceMin = '';

