-- 0d EK MATCHING the BROKEN (N=6,899 on 6/3/2019) - "ANY ROW w/ a Bldg-Name"
SELECT PRLog.[Seq ID], PRLog.LoginDate, PRLog.[Major Project #], PRLog.ProjectName, PRLog.[Building Name], PRLog.[Number Levels], PRLog.[Construction Type], PRLog.[Occupancy Classification], PRLog.[Building Generator], PRLog.[Fire Sprinkler System], PRLog.[Fire Alarm System], (SELECT [Sequence ID] FROM [UCSF Building List] WHERE [Sequence ID] = PRLog.[Building Name];) AS BL_SeqID, (SELECT [Construction Type] FROM [UCSF Building List] WHERE [Sequence ID] = PRLog.[Building Name];) AS BL_ConstrType, (SELECT [Number Levels] FROM [UCSF Building List] WHERE [Sequence ID] = PRLog.[Building Name];) AS BL_NumLev, (SELECT [Occupancy Classification] FROM [UCSF Building List] WHERE [Sequence ID] = PRLog.[Building Name];) AS BL_OccClass, (SELECT [Fire Alarm System] FROM [UCSF Building List] WHERE [Sequence ID] = PRLog.[Building Name];) AS BL_FA, (SELECT [Building Generator] FROM [UCSF Building List] WHERE [Sequence ID] = PRLog.[Building Name];) AS BL_Gen, (SELECT [Fire Sprinkler System] FROM [UCSF Building List] WHERE [Sequence ID] = PRLog.[Building Name];) AS BL_FS
FROM [Plan Review Log] AS PRLog
WHERE (((PRLog.[Building Name]) Is Not Null))
ORDER BY PRLog.[Building Name], PRLog.LoginDate;


-- 0dii EK Surely MATCHING the BROKEN (n=5,183 on 6/3/2019; n=5,162 on ??) - ANY ROW w/ JUST NUMBERS in 
SELECT PRLog.[Major Project #], PRLog.ProjectName, PRLog.[Building Name], PRLog.[Construction Type], PRLog.[Number Levels], PRLog.[Occupancy Classification], PRLog.[Building Generator], PRLog.[Fire Sprinkler System], PRLog.[Fire Alarm System], (SELECT [Sequence ID] FROM [UCSF Building List] WHERE [Sequence ID] = PRLog.[Building Name];) AS BL_SeqID, (SELECT [Construction Type] FROM [UCSF Building List] WHERE [Sequence ID] = PRLog.[Building Name];) AS BL_ConstrType, (SELECT [Number Levels] FROM [UCSF Building List] WHERE [Sequence ID] = PRLog.[Building Name];) AS BL_NumLev, (SELECT [Occupancy Classification] FROM [UCSF Building List] WHERE [Sequence ID] = PRLog.[Building Name];) AS BL_OccClass, (SELECT [Fire Alarm System] FROM [UCSF Building List] WHERE [Sequence ID] = PRLog.[Building Name];) AS BL_FA, (SELECT [Building Generator] FROM [UCSF Building List] WHERE [Sequence ID] = PRLog.[Building Name];) AS BL_Gen, (SELECT [Fire Sprinkler System] FROM [UCSF Building List] WHERE [Sequence ID] = PRLog.[Building Name];) AS BL_FS
FROM [Plan Review Log] AS PRLog
WHERE (	((PRLog.[Construction Type]) Like "[0-9]*" 
			And (PRLog.[Construction Type])<>"1-B") 
		And (PRLog.[Building Name] Is Not Null) 
		And ((PRLog.[Construction Type]=PRLog.[Number Levels]) 
			And (PRLog.[Occupancy Classification]=PRLog.[Number Levels])));



-- 0din EK OCCAM (n=5,183 on 6/3/2019; n=5,162 on ??)
SELECT PRLog.[Seq ID], PRLog.[Major Project #], PRLog.ProjectName, PRLog.[Building Name], (SELECT [Sequence ID] FROM [UCSF Building List] WHERE [Sequence ID] = PRLog.[Building Name];) AS BL_SeqID, PRLog.[Construction Type], PRLog.[Number Levels], PRLog.[Occupancy Classification], PRLog.[Building Generator], PRLog.[Fire Sprinkler System], PRLog.[Fire Alarm System]
FROM [Plan Review Log] AS PRLog
WHERE (((PRLog.[Building Name]) Is Not Null) 
		AND ((PRLog.[Construction Type]) Like "[0-9]*" 
				And (PRLog.[Construction Type])<>"1-B" 
				And (PRLog.[Construction Type])=[PRLog].[Number Levels]) 
		AND ((PRLog.[Occupancy Classification])=[PRLog].[Number Levels]));


-- 0din PRIME (n=4,951 on 6/3/2019; n = 4,930 on ??)
SELECT PRLog.[Seq ID], PRLog.[Major Project #], PRLog.ProjectName, PRLog.[Building Name], (SELECT [Sequence ID] FROM [UCSF Building List] WHERE [Sequence ID] = PRLog.[Building Name];) AS BL_SeqID, PRLog.[Construction Type], PRLog.[Number Levels], PRLog.[Occupancy Classification], PRLog.[Building Generator], PRLog.[Fire Sprinkler System], PRLog.[Fire Alarm System]
FROM [Plan Review Log] AS PRLog
WHERE (((PRLog.[Building Name]) Is Not Null) 
		AND ((PRLog.[Construction Type]) Like "[0-9]*" 
				And (PRLog.[Construction Type])<>"1-B" 
				And (PRLog.[Construction Type])=[PRLog].[Number Levels])
		AND ((PRLog.[Occupancy Classification])=[PRLog].[Number Levels])
		AND ((PRLog.[Number Levels])=CStr([PRLog].[Building Name])));
