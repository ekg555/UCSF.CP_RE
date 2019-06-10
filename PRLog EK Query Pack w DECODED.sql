-- ==========================================================================================
--		SELECT QUERIES
-- ==========================================================================================

-- 0 EK VERIFIED PDATES
SELECT DISTINCT [EK COMPILED PERMIT DATES].[PROJ #], [EK COMPILED PERMIT DATES].[PERMIT #], [EK COMPILED PERMIT DATES].[PERMIT DATE]
FROM [EK COMPILED PERMIT DATES];

-- 0a EK CO UPDATE Check AFTER
SELECT PRLOG.[Major Project #], CO_UPD.Certificate, PRLOG.CO, PRLOG.[CO Date], CO_UPD.CO, CO_UPD.[CO Date], PRLOG.[Seq ID], CO_UPD.[Seq ID], [PRLOG].[Major Project #] & " " & [PRLOG].[Type of Dwgs] & " (" & [PRLOG].[Status] & " " & [PRLOG].[Review Completion Date] & ")" AS Row_Digest
FROM [Plan Review Log] AS PRLOG, [CO_UPDATE 3-8-19] AS CO_UPD
WHERE (((PRLOG.[Major Project #]) In ('M3604','M2680A','M2680B','C198287','CFHH1680','M3623','C183582','15-832','M6630','M2657','M2680D','M0445','07-428','08-427','M6462','2007.04','M6456','M6405','2008.06','09-524','W18970','W22125','M2631','M2637','15-831','2016.08','M2632','M2629','M6653','2016.55','C433923','M6675','16-901A','08-410','08-469','10-610','2006.01.1')) And ((PRLOG.[Type of Dwgs])=CO_UPD.[Type of Dwgs]) And ((PRLOG.ProjectName)=CO_UPD.ProjectName))
ORDER BY PRLOG.[Major Project #], [PRLOG].[Major Project #] & " " & [PRLOG].[Type of Dwgs] & " (" & [PRLOG].[Status] & " " & [PRLOG].[Review Completion Date] & ")";

-- 0bi EK Apprd w NO DATE
SELECT PRLog.[Seq ID], PRLog.[Major Project #], PRLog.ProjectName, PRLog.[Type of Dwgs] & ' (' & PRLog.Status & ': ' & PRLog.[Review Completion Date] & ')' AS [Type of Drwgs], PRLog.[Review Completion Date], PRLog.Status, PRLog.[Cancelled/Closed], PRLog.LoginDate, PRLog.[Review Started], PRLog.[CO Date]
FROM [Plan Review Log] AS PRLog
WHERE (((PRLog.[Review Completion Date]) Is Null) And ((PRLog.Status) Is Not Null));

-- 0bii EK COMPLETE DATE w NO STATUS
SELECT PRLog.[Seq ID], PRLog.[Major Project #], PRLog.ProjectName, PRLog.[Type of Dwgs] & ' (' & PRLog.Status & ': ' & PRLog.[Review Completion Date] & ')' AS [Type of Drwgs], PRLog.[Review Completion Date], PRLog.Status, PRLog.[Cancelled/Closed], PRLog.LoginDate, PRLog.[Review Started], PRLog.[CO Date]
FROM [Plan Review Log] AS PRLog
WHERE (((PRLog.[Review Completion Date]) Is Null) And ((PRLog.Status) Is Not Null));

-- 0c EK ZOMBIE Proj Seeker
SELECT [Plan Review Log].[Seq ID], [Plan Review Log].[Major Project #], [Plan Review Log].ProjectName, [Type of Dwgs] & " (" & [Status] & ": " & [Review Completion Date] & ")" AS [Type of Drwgs], [Plan Review Log].LoginDate, [Plan Review Log].[CO Date], [Plan Review Log].[Plan Review #] & " / " & [Field Inspect #] AS [PR_FI_#]
FROM [Plan Review Log]
WHERE ((([Plan Review Log].LoginDate)>[CO Date]) AND (([Plan Review Log].[Type of Dwgs]) Not Like '*As*Built*'))
ORDER BY [Plan Review Log].[Major Project #], [Plan Review Log].ProjectName, [Type of Dwgs] & " (" & [Status] & ": " & [Review Completion Date] & ")", [Plan Review Log].LoginDate;

-- 0d EK CNO (UCSF BLDG LIST)
SELECT [UCSF Building List].[Sequence ID], [UCSF Building List].[Building Name], [UCSF Building List].[Construction Type], [UCSF Building List].[Number Levels], [UCSF Building List].[Occupancy Classification]
FROM [UCSF Building List]
ORDER BY [UCSF Building List].[Sequence ID];

-- 0din EK CNO (PR Log - CNO ALL SAME)
SELECT PRLog.[Seq ID], PRLog.LoginDate, PRLog.[Major Project #], PRLog.ProjectName, PRLog.[Building Name], (SELECT [Sequence ID] FROM [UCSF Building List] WHERE [Sequence ID] = PRLog.[Building Name];) AS BL_SeqID, PRLog.[Construction Type], PRLog.[Number Levels], PRLog.[Occupancy Classification], PRLog.[Building Generator], PRLog.[Fire Sprinkler System], PRLog.[Fire Alarm System]
FROM [Plan Review Log] AS PRLog
WHERE (((PRLog.[Building Name]) Is Not Null) And ((PRLog.[Construction Type]) Like "[0-9]*" And (PRLog.[Construction Type])<>"1-B" And (PRLog.[Construction Type])=PRLog.[Number Levels]) And ((PRLog.[Occupancy Classification])=PRLog.[Number Levels]))
ORDER BY PRLog.LoginDate, PRLog.[Building Name];

-- 0din EK CNO (PR Log - CNO DIFFERS)
SELECT PRLog.[Seq ID], PRLog.[Major Project #], PRLog.ProjectName, PRLog.[Building Name], (SELECT [Sequence ID] FROM [UCSF Building List] WHERE [Sequence ID] = PRLog.[Building Name];) AS BL_SeqID, PRLog.[Construction Type], PRLog.[Number Levels], PRLog.[Occupancy Classification], PRLog.[Building Generator], PRLog.[Fire Sprinkler System], PRLog.[Fire Alarm System], PRLog.LoginDate
FROM [Plan Review Log] AS PRLog
WHERE (((PRLog.[Building Name]) Is Not Null) AND ((PRLog.[Construction Type]) Like "[0-9]*" And (PRLog.[Construction Type])<>"1-B" And ((PRLog.[Construction Type])<>[PRLog].[Number Levels] Or (PRLog.[Construction Type])<>[PRLog].[Occupancy Classification])))
ORDER BY PRLog.[Building Name], PRLog.LoginDate;

-- 0din EK Exposit
SELECT PRLog.[Seq ID], PRLog.[Building Name], PRLog.[Construction Type], PRLog.[Number Levels], PRLog.[Occupancy Classification], (SELECT [Sequence ID] FROM [UCSF Building List] WHERE [UCSF Building List].[Sequence ID]=PRLog.[Building Name];) AS BList_SeqID
FROM [Plan Review Log] AS PRLog
ORDER BY PRLog.[Building Name] DESC;

-- 0dx EK the BLDGLESS BROKEN
SELECT PRLog.[Seq ID], PRLog.[Major Project #], PRLog.ProjectName, PRLog.[Building Name], PRLog.[Construction Type], PRLog.[Number Levels], PRLog.[Occupancy Classification], PRLog.[Building Generator], PRLog.[Fire Sprinkler System], PRLog.[Fire Alarm System], (SELECT [Sequence ID] FROM [UCSF Building List] WHERE [Sequence ID] = PRLog.[Building Name];) AS BL_SeqID, (SELECT [Construction Type] FROM [UCSF Building List] WHERE [Sequence ID] = PRLog.[Building Name];) AS BL_ConstrType, (SELECT [Number Levels] FROM [UCSF Building List] WHERE [Sequence ID] = PRLog.[Building Name];) AS BL_NumLev, (SELECT [Occupancy Classification] FROM [UCSF Building List] WHERE [Sequence ID] = PRLog.[Building Name];) AS BL_OccClass, (SELECT [Fire Alarm System] FROM [UCSF Building List] WHERE [Sequence ID] = PRLog.[Building Name];) AS BL_FA, (SELECT [Building Generator] FROM [UCSF Building List] WHERE [Sequence ID] = PRLog.[Building Name];) AS BL_Gen, (SELECT [Fire Sprinkler System] FROM [UCSF Building List] WHERE [Sequence ID] = PRLog.[Building Name];) AS BL_FS
FROM [Plan Review Log] AS PRLog
WHERE (((PRLog.[Building Name]) Is Null));

-- 1 EK ID Doc
SELECT [Plan Review Log].[Seq ID], [Plan Review Log].[Major Project #], [Plan Review Log].ProjectName, [Plan Review Log].Status, [Plan Review Log].[Permit Date], [Type of Dwgs] & ' (' & [Status] & ': ' & [Review Completion Date] & ')' AS [Type of Drawing], [Plan Review Log].[CO Date], [Plan Review Log].[Drawings Received], [Plan Review Log].[Review Started], [Plan Review Log].[Review Completion Date], [Plan Review Log].[100%CD Date], [Plan Review Log].Notes, [Plan Review Log].[Plan Review #], [Plan Review Log].[Field Inspect #], [Plan Review Log].LoginDate, [Plan Review Log].Reviewer, [Plan Review Log].[Building Name], [Plan Review Log].[Cancelled/Closed], [Plan Review Log].[Permit Number]
FROM [Plan Review Log];

-- EK CHECK HYPERLINKS
SELECT PTABLE.FILENAME, HyperlinkPart([FILENAME],0) AS Display, HyperlinkPart([FILENAME],1) AS Name, HyperlinkPart([FILENAME],2) AS Addr, HyperlinkPart([FILENAME],3) AS SubAddr, HyperlinkPart([FILENAME],4) AS ScreenTip
FROM [EK COMPILED PERMIT DATES] AS PTABLE;

-- EK CO PastDUE
SELECT DISTINCT [Plan Review Log].[Major Project #], [Plan Review Log].[TCO Date], [Plan Review Log].[CO Due Date], [Plan Review Log].[CO Date]
FROM [Plan Review Log]
WHERE ((([Plan Review Log].[CO Due Date]) Is Not Null) AND (([Plan Review Log].[CO Date]) Is Null)) OR ((([Plan Review Log].[TCO Date]) Is Not Null) AND (([Plan Review Log].[CO Date]) Is Null));

-- EK DATES CHECK
SELECT PRLog.[Seq ID], PRLog.LoginDate, PRLog.[Construct Start], PRLog.[Construct Finish], PRLog.[Review Completion Date], PRLog.[Review Started], PRLog.[Review Due Date], PRLog.[100%CD Date], PRLog.[Permit Date], PRLog.[CO Date], PRLog.[TCO Date], PRLog.[CO Due Date], PRLog.[Drawings Received], PRLog.[Pre-Const Date], [PRLog].[Major Project #] & " " & [ProjectName] & " -- " & [Type of Dwgs] & " (" & [Status] & ": " & [Review Completion Date] & ")" AS REVIEW
FROM [Plan Review Log] AS PRLog;

-- EK PDt EQL 100CDDt
SELECT DISTINCT PRLog.[Major Project #], PRLog.ProjectName, PRLog.[100%CD Date], PRLog.[Permit Date], PRLog.[Permit Number]
FROM [Plan Review Log] AS PRLog, [EK COMPILED PERMIT DATES] AS PTable
WHERE (((PRLog.[100%CD Date])=([PRLog].[Permit Date])));

-- EK PERMIT DATE CHECK (ONLY MISMATCHES)
SELECT PRLog.[Seq ID], PRLog.[Major Project #], PRLog.ProjectName, PRLog.[Type of Dwgs], PRLog.[Permit Number], PRLog.[Permit Date] AS [PRLOG_PMT-DT], PTable.FILENAME, PTable.[PERMIT DATE] AS [TRUE_PMT-DT], PTable.NOTES AS PT_NOTES
FROM [Plan Review Log] AS PRLog LEFT JOIN [EK COMPILED PERMIT DATES] AS PTable ON PRLog.[Permit Number] = PTable.[Permit #]
WHERE (((PRLog.[Permit Date])<>[PTable].[PERMIT DATE]))
ORDER BY PRLog.[Major Project #], PRLog.[Seq ID];


-- EK PERMIT DATE CHECK (ALL ROWS)
SELECT PRLog.[Seq ID], PRLog.[Major Project #], PRLog.ProjectName, PRLog.[Type of Dwgs], PRLog.[Permit Number], PRLog.[Permit Date] AS [PRLOG_PMT-DT], PTable.[Permit #], PTable.FILENAME, PTable.[PERMIT DATE] AS [TRUE_PMT-DT], PTable.NOTES AS PT_NOTES
FROM [Plan Review Log] AS PRLog LEFT JOIN [EK COMPILED PERMIT DATES] AS PTable ON PRLog.[Permit Number] = PTable.[Permit #]
ORDER BY PRLog.[Major Project #], PRLog.[Seq ID];


-- ==========================================================================================
--		UPDATE QUERIES
-- ==========================================================================================

-- EK CO UPDATE v2
UPDATE [Plan Review Log] AS PRLOG, [CO_UPDATE 3-8-19] AS CO_UPD SET PRLOG.CO = [CO_UPD]![CO], PRLOG.[CO Date] = [CO_UPD]![CO Date]
WHERE (((PRLOG.[Major Project #]) In ('M3604','M2680A','M2680B','C198287','CFHH1680','M3623','C183582','15-832','M6630','M2657','M2680D','M0445','07-428','08-427','M6462','2007.04','M6456','M6405','2008.06','09-524','W18970','W22125','M2631','M2637','15-831','2016.08','M2632','M2629','M6653','2016.55','C433923','M6675','16-901A','08-410','08-469','10-610','2006.01.1')) AND ((PRLOG.[Type of Dwgs])=[CO_UPD].[Type of Dwgs]) AND ((PRLOG.ProjectName)=[CO_UPD].[ProjectName]));

-- EK UPDATE LINKS
UPDATE Table1 SET Table1.LINK = [FILENAME] & "#" & [PATH] & [FILENAME];
