-- 0dii EK Surely MATCHING the BROKEN (n=5,162)
SELECT PRLog.[Major Project #], PRLog.ProjectName, PRLog.[Building Name], PRLog.[Construction Type], PRLog.[Number Levels], PRLog.[Occupancy Classification], PRLog.[Building Generator], PRLog.[Fire Sprinkler System], PRLog.[Fire Alarm System], (SELECT [Sequence ID] FROM [UCSF Building List] WHERE [Sequence ID] = PRLog.[Building Name];) AS BL_SeqID, (SELECT [Construction Type] FROM [UCSF Building List] WHERE [Sequence ID] = PRLog.[Building Name];) AS BL_ConstrType, (SELECT [Number Levels] FROM [UCSF Building List] WHERE [Sequence ID] = PRLog.[Building Name];) AS BL_NumLev, (SELECT [Occupancy Classification] FROM [UCSF Building List] WHERE [Sequence ID] = PRLog.[Building Name];) AS BL_OccClass, (SELECT [Fire Alarm System] FROM [UCSF Building List] WHERE [Sequence ID] = PRLog.[Building Name];) AS BL_FA, (SELECT [Building Generator] FROM [UCSF Building List] WHERE [Sequence ID] = PRLog.[Building Name];) AS BL_Gen, (SELECT [Fire Sprinkler System] FROM [UCSF Building List] WHERE [Sequence ID] = PRLog.[Building Name];) AS BL_FS
FROM [Plan Review Log] AS PRLog
WHERE (	((PRLog.[Construction Type]) Like "[0-9]*" 
			And (PRLog.[Construction Type])<>"1-B") 
		And (PRLog.[Building Name] Is Not Null) 
		And ((PRLog.[Construction Type]=PRLog.[Number Levels]) 
			And (PRLog.[Occupancy Classification]=PRLog.[Number Levels])));



-- 0din EK OCCAM (n = 5,162)
SELECT PRLog.[Seq ID], PRLog.[Major Project #], PRLog.ProjectName, PRLog.[Building Name], (SELECT [Sequence ID] FROM [UCSF Building List] WHERE [Sequence ID] = PRLog.[Building Name];) AS BL_SeqID, PRLog.[Construction Type], PRLog.[Number Levels], PRLog.[Occupancy Classification], PRLog.[Building Generator], PRLog.[Fire Sprinkler System], PRLog.[Fire Alarm System]
FROM [Plan Review Log] AS PRLog
WHERE (((PRLog.[Building Name]) Is Not Null) 
		AND ((PRLog.[Construction Type]) Like "[0-9]*" 
				And (PRLog.[Construction Type])<>"1-B" 
				And (PRLog.[Construction Type])=[PRLog].[Number Levels]) 
		AND ((PRLog.[Occupancy Classification])=[PRLog].[Number Levels]));


-- 0din PRIME (n = 4,930)
SELECT PRLog.[Seq ID], PRLog.[Major Project #], PRLog.ProjectName, PRLog.[Building Name], (SELECT [Sequence ID] FROM [UCSF Building List] WHERE [Sequence ID] = PRLog.[Building Name];) AS BL_SeqID, PRLog.[Construction Type], PRLog.[Number Levels], PRLog.[Occupancy Classification], PRLog.[Building Generator], PRLog.[Fire Sprinkler System], PRLog.[Fire Alarm System]
FROM [Plan Review Log] AS PRLog
WHERE (((PRLog.[Building Name]) Is Not Null) 
		AND ((PRLog.[Construction Type]) Like "[0-9]*" 
				And (PRLog.[Construction Type])<>"1-B" 
				And (PRLog.[Construction Type])=[PRLog].[Number Levels])
		AND ((PRLog.[Occupancy Classification])=[PRLog].[Number Levels])
		AND ((PRLog.[Number Levels])=CStr([PRLog].[Building Name])));
