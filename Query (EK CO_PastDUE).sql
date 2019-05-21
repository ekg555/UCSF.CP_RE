SELECT DISTINCT [Plan Review Log].[Major Project #], [Plan Review Log].[TCO Date], [Plan Review Log].[CO Due Date], [Plan Review Log].[CO Date]
FROM [Plan Review Log]
WHERE ((([Plan Review Log].[CO Due Date]) Is Not Null) AND (([Plan Review Log].[CO Date]) Is Null)) OR ((([Plan Review Log].[TCO Date]) Is Not Null) AND (([Plan Review Log].[CO Date]) Is Null));
