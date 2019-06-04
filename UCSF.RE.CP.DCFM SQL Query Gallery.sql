-- THIS IS JUST A GALLERY of SQL CODE During a Stint @ the Designated Campus Fire Marshal Unit
-- UNDER UCSF / (RE/CP | BLDG) unsure what - seemed like things were in flux - sign of the reaper.


-- APPEND QUERIES --
--=========================================================================

--EK APPEND SHEET2
INSERT INTO [Plan Review Log] ( [Field Submittal], [Office Submittal], [Triage Review], [Offsite Archive], [Drawings Received], [Soft Copy], [Code Cycle], LoginDate, [UCSF Dept], [Responsible Design], [Building Name], [Major Project #], ProjectName, [Plan Review #], [Field Inspect #], [Sq Ft], ProjectManager, [Type of Dwgs], AMOC, [Drawing Company], Address, City, State, PhoneNumber, [Review Completion Date], [Review Started], [Review Due Date], Reviewer, Status, [100% CD Approved], [100%CD Date], [Permit Date], [Permit Number], [Permit Copy], Notes, [FM Drawing Copy], [Rack #], [Field Inspector], IOR, GC, [Pre-Const Date], [Construct Start], [Construct Finish], NOC, [TCO/CO Status], TCO, [TCO Date], [CO Due Date], CO, [CO Date], [Occup Class], [Haz Mat List], [Active Construction], [Construction Type], [Number Levels], [Occupancy Classification], [Building Generator], [Fire Sprinkler System], [Fire Alarm System], [Cancelled/Closed] )
SELECT [EK Sheet2].[Field Submittal] AS Expr1, [EK Sheet2].[Office Submittal] AS Expr2, [EK Sheet2].[Triage Review] AS Expr3, [EK Sheet2].[Offsite Archive] AS Expr4, [EK Sheet2].[Drawings Received] AS Expr5, [EK Sheet2].[Soft Copy] AS Expr6, [EK Sheet2].[Code Cycle] AS Expr7, [EK Sheet2].LoginDate AS Expr8, [EK Sheet2].[UCSF Dept] AS Expr9, [EK Sheet2].[Responsible Design] AS Expr10, [EK Sheet2].[Building Name] AS Expr11, [EK Sheet2].[Major Project #] AS Expr12, [EK Sheet2].ProjectName AS Expr13, [EK Sheet2].[Plan Review #] AS Expr14, [EK Sheet2].[Field Inspect #] AS Expr15, [EK Sheet2].[Sq Ft] AS Expr16, [EK Sheet2].ProjectManager AS Expr17, [EK Sheet2].[Type of Dwgs] AS Expr18, [EK Sheet2].AMOC AS Expr19, [EK Sheet2].[Drawing Company] AS Expr20, [EK Sheet2].Address AS Expr21, [EK Sheet2].City AS Expr22, [EK Sheet2].State AS Expr23, [EK Sheet2].PhoneNumber AS Expr24, [EK Sheet2].[Review Completion Date] AS Expr25, [EK Sheet2].[Review Started] AS Expr26, [EK Sheet2].[Review Due Date] AS Expr27, [EK Sheet2].Reviewer AS Expr28, [EK Sheet2].Status AS Expr29, [EK Sheet2].[100% CD Approved] AS Expr30, [EK Sheet2].[100%CD Date] AS Expr31, [EK Sheet2].[Permit Date] AS Expr32, [EK Sheet2].[Permit Number] AS Expr33, [EK Sheet2].[Permit Copy] AS Expr34, [EK Sheet2].Notes AS Expr35, [EK Sheet2].[FM Drawing Copy] AS Expr36, [EK Sheet2].[Rack #] AS Expr37, [EK Sheet2].[Field Inspector] AS Expr38, [EK Sheet2].IOR AS Expr39, [EK Sheet2].GC AS Expr40, [EK Sheet2].[Pre-Const Date] AS Expr41, [EK Sheet2].[Construct Start] AS Expr42, [EK Sheet2].[Construct Finish] AS Expr43, [EK Sheet2].NOC AS Expr44, [EK Sheet2].[TCO/CO Status] AS Expr45, [EK Sheet2].TCO AS Expr46, [EK Sheet2].[TCO Date] AS Expr47, [EK Sheet2].[CO Due Date] AS Expr48, [EK Sheet2].CO AS Expr49, [EK Sheet2].[CO Date] AS Expr50, [EK Sheet2].[Occup Class] AS Expr51, [EK Sheet2].[Haz Mat List] AS Expr52, [EK Sheet2].[Active Construction] AS Expr53, [EK Sheet2].[Construction Type] AS Expr54, [EK Sheet2].[Number Levels] AS Expr55, [EK Sheet2].[Occupancy Classification] AS Expr56, [EK Sheet2].[Building Generator] AS Expr57, [EK Sheet2].[Fire Sprinkler System] AS Expr58, [EK Sheet2].[Fire Alarm System] AS Expr59, [EK Sheet2].[Cancelled/Closed] AS Expr60
FROM [EK Sheet2]
ORDER BY [EK Sheet2].[Major Project #], [EK Sheet2].ProjectName, [EK Sheet2].[Type of Dwgs];


-- SELECT QUERIES --
--=========================================================================

--0 EK VERIFIED PDATES
SELECT DISTINCT [EK COMPILED PERMIT DATES].[PROJ #] AS Expr1, [EK COMPILED PERMIT DATES].[PERMIT #] AS Expr2, [EK COMPILED PERMIT DATES].[PERMIT DATE] AS Expr3
FROM [EK COMPILED PERMIT DATES];


--0a EK CO UPDATE Check AFTER
SELECT PRLOG.[Major Project #], CO_UPD.Certificate, PRLOG.CO, PRLOG.[CO Date], CO_UPD.CO, CO_UPD.[CO Date], PRLOG.[Seq ID], CO_UPD.[Seq ID], [PRLOG].[Major Project #] & " " & [PRLOG].[Type of Dwgs] & " (" & [PRLOG].[Status] & " " & [PRLOG].[Review Completion Date] & ")" AS Row_Digest
FROM [Plan Review Log] AS PRLOG, [CO_UPDATE 3-8-19] AS CO_UPD
WHERE (((PRLOG.[Major Project #]) In ('M3604','M2680A','M2680B','C198287','CFHH1680','M3623','C183582','15-832','M6630','M2657','M2680D','M0445','07-428','08-427','M6462','2007.04','M6456','M6405','2008.06','09-524','W18970','W22125','M2631','M2637','15-831','2016.08','M2632','M2629','M6653','2016.55','C433923','M6675','16-901A','08-410','08-469','10-610','2006.01.1')) And ((PRLOG.[Type of Dwgs])=CO_UPD.[Type of Dwgs]) And ((PRLOG.ProjectName)=CO_UPD.ProjectName))
ORDER BY PRLOG.[Major Project #], [PRLOG].[Major Project #] & " " & [PRLOG].[Type of Dwgs] & " (" & [PRLOG].[Status] & " " & [PRLOG].[Review Completion Date] & ")";

--0bi EK Apprd w NO DATE
SELECT PRLog.[Seq ID], PRLog.[Major Project #], PRLog.ProjectName, PRLog.[Type of Dwgs] & ' (' & PRLog.Status & ': ' & PRLog.[Review Completion Date] & ')' AS [Type of Drwgs], PRLog.[Review Completion Date], PRLog.Status, PRLog.[Cancelled/Closed], PRLog.LoginDate, PRLog.[Review Started], PRLog.[CO Date]
FROM [Plan Review Log] AS PRLog
WHERE (((PRLog.[Review Completion Date]) Is Null) And ((PRLog.Status) Is Not Null));

--0bii EK COMPLETE DATE w NO STATUS
SELECT [Plan Review Log].[Seq ID], [Plan Review Log].[Major Project #], [Plan Review Log].ProjectName, [Plan Review Log].[Type of Dwgs] & ' (' & [Plan Review Log].[Status] & ': ' & [Plan Review Log].[Review Completion Date] & ')' AS [Type of Drwgs], [Plan Review Log].[Review Completion Date], [Plan Review Log].Status, [Plan Review Log].[Cancelled/Closed], [Plan Review Log].LoginDate, [Plan Review Log].[Review Started], [Plan Review Log].[CO Date]
FROM [Plan Review Log]
WHERE ((([Plan Review Log].[Review Completion Date]) Is Not Null) AND (([Plan Review Log].Status) Is Null))
ORDER BY [Plan Review Log].[Review Completion Date] DESC , [Plan Review Log].LoginDate DESC , [Plan Review Log].[Major Project #], [Plan Review Log].ProjectName;

--0c EK ZOMBIE Proj Seeker
SELECT [Plan Review Log].[Seq ID], [Plan Review Log].[Major Project #], [Plan Review Log].ProjectName, [Type of Dwgs] & " (" & [Status] & ": " & [Review Completion Date] & ")" AS [Type of Drwgs], [Plan Review Log].LoginDate, [Plan Review Log].[CO Date], [Plan Review Log].[Plan Review #] & " / " & [Field Inspect #] AS [PR_FI_#]
FROM [Plan Review Log]
WHERE ((([Plan Review Log].LoginDate)>[CO Date]) AND (([Plan Review Log].[Type of Dwgs]) Not Like '*As*Built*'))
ORDER BY [Plan Review Log].[Major Project #], [Plan Review Log].ProjectName, [Type of Dwgs] & " (" & [Status] & ": " & [Review Completion Date] & ")", [Plan Review Log].LoginDate;


--0din SERIES -- DECODING auf der rechten Seite
--=========================================================================

--0d EK CNO EVIL (BLDG LIST)
SELECT [UCSF Building List].[Sequence ID] AS Expr1, [UCSF Building List].[Building Name] AS Expr2, [UCSF Building List].[Construction Type] AS Expr3, [UCSF Building List].[Number Levels] AS Expr4, [UCSF Building List].[Occupancy Classification] AS Expr5
FROM [UCSF Building List]
ORDER BY [UCSF Building List].[Sequence ID];

--0d EK MATCHING the BROKEN
SELECT PRLog.[Seq ID], PRLog.LoginDate, PRLog.[Major Project #], PRLog.ProjectName, PRLog.[Building Name], PRLog.[Number Levels], PRLog.[Construction Type], PRLog.[Occupancy Classification], PRLog.[Building Generator], PRLog.[Fire Sprinkler System], PRLog.[Fire Alarm System], (SELECT [Sequence ID] FROM [UCSF Building List] WHERE [Sequence ID] = PRLog.[Building Name];) AS BL_SeqID, (SELECT [Construction Type] FROM [UCSF Building List] WHERE [Sequence ID] = PRLog.[Building Name];) AS BL_ConstrType, (SELECT [Number Levels] FROM [UCSF Building List] WHERE [Sequence ID] = PRLog.[Building Name];) AS BL_NumLev, (SELECT [Occupancy Classification] FROM [UCSF Building List] WHERE [Sequence ID] = PRLog.[Building Name];) AS BL_OccClass, (SELECT [Fire Alarm System] FROM [UCSF Building List] WHERE [Sequence ID] = PRLog.[Building Name];) AS BL_FA, (SELECT [Building Generator] FROM [UCSF Building List] WHERE [Sequence ID] = PRLog.[Building Name];) AS BL_Gen, (SELECT [Fire Sprinkler System] FROM [UCSF Building List] WHERE [Sequence ID] = PRLog.[Building Name];) AS BL_FS
FROM [Plan Review Log] AS PRLog
ORDER BY PRLog.[Building Name], PRLog.LoginDate;

--0dii EK Surely MATCHING the BROKEN
SELECT PRLog.[Major Project #], PRLog.ProjectName, PRLog.[Building Name], PRLog.[Construction Type], PRLog.[Number Levels], PRLog.[Occupancy Classification], PRLog.[Building Generator], PRLog.[Fire Sprinkler System], PRLog.[Fire Alarm System], (SELECT [Sequence ID] FROM [UCSF Building List] WHERE [Sequence ID] = PRLog.[Building Name];) AS BL_SeqID, (SELECT [Construction Type] FROM [UCSF Building List] WHERE [Sequence ID] = PRLog.[Building Name];) AS BL_ConstrType, (SELECT [Number Levels] FROM [UCSF Building List] WHERE [Sequence ID] = PRLog.[Building Name];) AS BL_NumLev, (SELECT [Occupancy Classification] FROM [UCSF Building List] WHERE [Sequence ID] = PRLog.[Building Name];) AS BL_OccClass, (SELECT [Fire Alarm System] FROM [UCSF Building List] WHERE [Sequence ID] = PRLog.[Building Name];) AS BL_FA, (SELECT [Building Generator] FROM [UCSF Building List] WHERE [Sequence ID] = PRLog.[Building Name];) AS BL_Gen, (SELECT [Fire Sprinkler System] FROM [UCSF Building List] WHERE [Sequence ID] = PRLog.[Building Name];) AS BL_FS
FROM [Plan Review Log] AS PRLog
WHERE (((PRLog.[Construction Type]) Like "[0-9]*" And (PRLog.[Construction Type])<>"1-B") And (PRLog.[Building Name] Is Not Null) And ((PRLog.[Construction Type]=PRLog.[Number Levels]) And (PRLog.[Occupancy Classification]=PRLog.[Number Levels])));

--0din EK OCCAM Surely MATCHING the BROKEN
SELECT PRLog.[Seq ID], PRLog.[Major Project #], PRLog.ProjectName, PRLog.[Building Name], (SELECT [Sequence ID] FROM [UCSF Building List] WHERE [Sequence ID] = PRLog.[Building Name];) AS BL_SeqID, PRLog.[Construction Type], PRLog.[Number Levels], PRLog.[Occupancy Classification], PRLog.[Building Generator], PRLog.[Fire Sprinkler System], PRLog.[Fire Alarm System]
FROM [Plan Review Log] AS PRLog
WHERE (((PRLog.[Building Name]) Is Not Null) AND ((PRLog.[Construction Type]) Like "[0-9]*" And (PRLog.[Construction Type])<>"1-B" And (PRLog.[Construction Type])=[PRLog].[Number Levels]) AND ((PRLog.[Occupancy Classification])=[PRLog].[Number Levels]));

--0din EK PRIME Surely MATCHING the BROKEN
SELECT PRLog.[Seq ID], PRLog.[Major Project #], PRLog.ProjectName, PRLog.[Building Name], (SELECT [Sequence ID] FROM [UCSF Building List] WHERE [Sequence ID] = PRLog.[Building Name];) AS BL_SeqID, PRLog.[Construction Type], PRLog.[Number Levels], PRLog.[Occupancy Classification], PRLog.[Building Generator], PRLog.[Fire Sprinkler System], PRLog.[Fire Alarm System]
FROM [Plan Review Log] AS PRLog
WHERE (((PRLog.[Building Name]) Is Not Null) AND ((PRLog.[Construction Type]) Like "[0-9]*" And (PRLog.[Construction Type])<>"1-B" And (PRLog.[Construction Type])=[PRLog].[Number Levels]) AND ((PRLog.[Number Levels])=CStr([PRLog].[Building Name])) AND ((PRLog.[Occupancy Classification])=[PRLog].[Number Levels]));

--0dx EK the BLDGLESS BROKEN
SELECT PRLog.[Seq ID], PRLog.[Major Project #], PRLog.ProjectName, PRLog.[Building Name], PRLog.[Construction Type], PRLog.[Number Levels], PRLog.[Occupancy Classification], PRLog.[Building Generator], PRLog.[Fire Sprinkler System], PRLog.[Fire Alarm System], (SELECT [Sequence ID] FROM [UCSF Building List] WHERE [Sequence ID] = PRLog.[Building Name];) AS BL_SeqID, (SELECT [Construction Type] FROM [UCSF Building List] WHERE [Sequence ID] = PRLog.[Building Name];) AS BL_ConstrType, (SELECT [Number Levels] FROM [UCSF Building List] WHERE [Sequence ID] = PRLog.[Building Name];) AS BL_NumLev, (SELECT [Occupancy Classification] FROM [UCSF Building List] WHERE [Sequence ID] = PRLog.[Building Name];) AS BL_OccClass, (SELECT [Fire Alarm System] FROM [UCSF Building List] WHERE [Sequence ID] = PRLog.[Building Name];) AS BL_FA, (SELECT [Building Generator] FROM [UCSF Building List] WHERE [Sequence ID] = PRLog.[Building Name];) AS BL_Gen, (SELECT [Fire Sprinkler System] FROM [UCSF Building List] WHERE [Sequence ID] = PRLog.[Building Name];) AS BL_FS
FROM [Plan Review Log] AS PRLog
WHERE (((PRLog.[Building Name]) Is Null));

--=========================================================================

--1 EK ID Doc
SELECT [Plan Review Log].[Seq ID], [Plan Review Log].[Major Project #], [Plan Review Log].ProjectName, [Plan Review Log].Status, [Plan Review Log].[Permit Date], [Type of Dwgs] & ' (' & [Status] & ': ' & [Review Completion Date] & ')' AS [Type of Drawing], [Plan Review Log].[CO Date], [Plan Review Log].[Drawings Received], [Plan Review Log].[Review Started], [Plan Review Log].[Review Completion Date], [Plan Review Log].[100%CD Date], [Plan Review Log].Notes, [Plan Review Log].[Plan Review #], [Plan Review Log].[Field Inspect #], [Plan Review Log].LoginDate, [Plan Review Log].Reviewer, [Plan Review Log].[Building Name], [Plan Review Log].[Cancelled/Closed], [Plan Review Log].[Permit Number]
FROM [Plan Review Log];

--EK CHECK HYPERLINKS
SELECT PTABLE.FILENAME, HyperlinkPart([FILENAME],0) AS Display, HyperlinkPart([FILENAME],1) AS Name, HyperlinkPart([FILENAME],2) AS Addr, HyperlinkPart([FILENAME],3) AS SubAddr, HyperlinkPart([FILENAME],4) AS ScreenTip
FROM [EK COMPILED PERMIT DATES] AS PTABLE;

--EK CO PastDUE
SELECT DISTINCT [Plan Review Log].[Major Project #], [Plan Review Log].[TCO Date], [Plan Review Log].[CO Due Date], [Plan Review Log].[CO Date]
FROM [Plan Review Log]
WHERE ((([Plan Review Log].[CO Due Date]) Is Not Null) AND (([Plan Review Log].[CO Date]) Is Null)) OR ((([Plan Review Log].[TCO Date]) Is Not Null) AND (([Plan Review Log].[CO Date]) Is Null));

--EK DATES CHECK
SELECT PRLog.[Seq ID], PRLog.LoginDate, PRLog.[Construct Start], PRLog.[Construct Finish], PRLog.[Review Completion Date], PRLog.[Review Started], PRLog.[Review Due Date], PRLog.[100%CD Date], PRLog.[Permit Date], PRLog.[CO Date], PRLog.[TCO Date], PRLog.[CO Due Date], PRLog.[Drawings Received], PRLog.[Pre-Const Date], [PRLog].[Major Project #] & " " & [ProjectName] & " -- " & [Type of Dwgs] & " (" & [Status] & ": " & [Review Completion Date] & ")" AS REVIEW
FROM [Plan Review Log] AS PRLog;

--EK PDt EQL 100CDDt
SELECT DISTINCT PRLog.[Major Project #], PRLog.ProjectName, PRLog.[100%CD Date], PRLog.[Permit Date], PRLog.[Permit Number]
FROM [Plan Review Log] AS PRLog, [EK COMPILED PERMIT DATES] AS PTable
WHERE (((PRLog.[100%CD Date])=([PRLog].[Permit Date])));


--EK PERMIT DATE (MISMATCH) CHECK
SELECT PRLog.[Seq ID], PRLog.[Major Project #], PRLog.ProjectName, PRLog.[Type of Dwgs], PRLog.[Permit Number], PRLog.[Permit Date] AS [PRLOG_PMT-DT], PTable.[Permit #], PTable.FILENAME, PTable.[PERMIT DATE], PTable.NOTES AS PT_NOTES
FROM [Plan Review Log] AS PRLog LEFT JOIN [EK COMPILED PERMIT DATES] AS PTable ON PRLog.[Permit Number] = PTable.[Permit #]
WHERE (((PRLog.[Permit Date])<>[PTable].[PERMIT DATE]));

--EK PERMIT DATE CHECK
SELECT PRLog.[Seq ID], PRLog.[Major Project #], PRLog.ProjectName, PRLog.[Type of Dwgs], PRLog.[Permit Number], PRLog.[Permit Date] AS [PRLOG_PMT-DT], PTable.[Permit #], PTable.FILENAME, PTable.[PERMIT DATE], PTable.NOTES AS PT_NOTES
FROM [Plan Review Log] AS PRLog LEFT JOIN [EK COMPILED PERMIT DATES] AS PTable ON PRLog.[Permit Number] = PTable.[Permit #];

-- UPDATE QUERIES --
--=========================================================================
--EK CO UPDATE v2
UPDATE [Plan Review Log] AS PRLOG, [CO_UPDATE 3-8-19] AS CO_UPD SET PRLOG.CO = [CO_UPD]![CO], PRLOG.[CO Date] = [CO_UPD]![CO Date]
WHERE (((PRLOG.[Major Project #]) In ('M3604','M2680A','M2680B','C198287','CFHH1680','M3623','C183582','15-832','M6630','M2657','M2680D','M0445','07-428','08-427','M6462','2007.04','M6456','M6405','2008.06','09-524','W18970','W22125','M2631','M2637','15-831','2016.08','M2632','M2629','M6653','2016.55','C433923','M6675','16-901A','08-410','08-469','10-610','2006.01.1')) AND ((PRLOG.[Type of Dwgs])=[CO_UPD].[Type of Dwgs]) AND ((PRLOG.ProjectName)=[CO_UPD].[ProjectName]));

--EK CO UPDATE v2 (with NO SIGNers)
UPDATE [Plan Review Log] AS PRLOG, [CO_UPDATE 3-8-19] AS CO_UPD SET PRLOG.CO = [CO_UPD]![CO], PRLOG.[CO Date] = [CO_UPD]![CO Date]
WHERE (((PRLOG.[Major Project #]) In ('M3604','M2680A','M2680B','C198287','CFHH1680','M3623','C183582','15-832','M6630','M2657','M2680D','M0445','07-428','08-427','M6462','2007.04','M6456','M6405','2008.06','09-524','DC-646','W18970','W22125','M2631','M2637','15-831','2016.08','M2632','M2629','M6653','2016.55','M6677','C433923','M6675','W45850','16-901A','08-410','08-469','10-610','2006.01.1')) AND ((PRLOG.[Type of Dwgs])=[CO_UPD].[Type of Dwgs]) AND ((PRLOG.ProjectName)=[CO_UPD].[ProjectName]));

--EK UPDATE LINKS
UPDATE Table1 SET Table1.LINK = [FILENAME] & "#" & [PATH] & [FILENAME];
