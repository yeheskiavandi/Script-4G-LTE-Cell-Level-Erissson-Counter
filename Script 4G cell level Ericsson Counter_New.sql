/****** Script for SelectTopNRows command from SSMS  ******/
SELECT [EutranCellFDD]
      ,[ERBS]
      ,[SiteName]
      --,[MONTH]
      ,[DATE_ID]
      --,[INSERT_DATE]
      ,[HOUR_ID]   
      ,[LNetworkElementAvailability] =( 100*((3600- case when ((pmCellDowntimeAuto)+(pmCellDowntimeMan)) > 3600 then 3600 else ((pmCellDowntimeAuto)+(pmCellDowntimeMan)) end)/3600))
      ,[LSessionSetupSuccessRateSSSR]=100 
         * ( (pmRrcConnEstabSucc) / nullif( isnull((pmRrcConnEstabAtt),0) - isnull((pmRrcConnEstabAttReatt),0) ,0) ) 
         * ( (pmErabEstabSuccInit) / nullif( (pmErabEstabAttInit),0) ) 
         * ( (pmS1SigConnEstabSucc) / nullif( (pmS1SigConnEstabAtt),0) )
      ,[LERABDropRate] =100 
         * ( isnull((pmErabRelAbnormalEnbAct),0) + isnull((pmErabRelAbnormalMmeAct),0) ) 
         / nullif( isnull((pmErabRelAbnormalEnb),0) + isnull((pmErabRelNormalEnb) ,0) + isnull((pmErabRelMme),0) ,0)
      ,[LPDCPCellThroughputDLMbps]=(pmPdcpVolDlDrb) / nullif( (pmSchedActivityCellDl) ,0)
      ,[LPDCPCellThroughputULMbps]=(pmPdcpVolUlDrb) / nullif( (pmSchedActivityCellUl) ,0)
      ,[LDLUserThroughputMbps]=( isnull((pmPdcpVolDlDrb),0) - isnull((pmPdcpVolDlDrbLastTTI),0) ) / nullif( (pmUeThpTimeDl) ,0)
      ,[LULUserThroughputMbps]=(pmUeThpVolUl) / nullif( (pmUeThpTimeUl) ,0)
      ,[LHOSuccessRateIntraFrequency]=100 * ( (pmCellHoExeSuccLteIntraF) / nullif( (pmCellHoExeAttLteIntraF) ,0) ) * ( (pmCellHoPrepSuccLteIntraF) / nullif( (pmCellHoPrepAttLteIntraF), 0) )
	  ,[LHOSuccessRateInterFrequency]=100 * ( (pmCellHoExeSuccLteInterF) / nullif( (pmCellHoExeAttLteInterF) ,0) ) * ( (pmCellHoPrepSuccLteInterF) / nullif( (pmCellHoPrepAttLteInterF) ,0) )
	  ,[LHOSuccessRateInterRAT]=100 * ( (pmHoPrepSucc) / nullif( (pmHoPrepAtt) ,0) ) * ( (pmHoExeSucc) / nullif( (pmHoExeAtt) ,0) )
	  ,	'RABSetupSuccessRate'='NULL'
	  ,[LDLTrafficVolumeGB]=((pmPdcpVolDlDrb) / 1000) / 8000
      ,[LULTrafficVolumeGB]=((pmPdcpVolUlDrb) / 1000) / 8000
      ,[LMAXSimultaneousRRCConnectedUEs]=pmRrcConnMax
	  ,[LDLLatencyms]=(pmPdcpLatTimeDl) / nullif( (pmPdcpLatPktTransDl) ,0)     
      ,[LDLResourceBlockUtilizingRate]=100 * (pmPrbUsedDlFirstTrans) * ( 1 + ( (pmPrbUsedDlReTrans) / nullif( (pmPrbUsedDlFirstTrans) ,0) ) ) / nullif ( (pmPrbAvailDl) ,0)
      ,[LULResourceBlockUtilizingRate]=100 * (pmPrbUsedUlDtch) / nullif( (pmPrbAvailUl) ,0)
      ,[TotalTrafficVolumeGB] =( ((pmPdcpVolDlDrb) / 1000) / 8000) + (((pmPdcpVolUlDrb) / 1000) / 8000)
    --,[LVoiceCSFBCallSetupSuccessRate]=100*((pmUeCtxtRelCsfbWcdma)/nullif((pmUeCtxtEstabAttCsfb)+ isnull((pmUeCtxtModAttCsfb),0),0))

     
  FROM [MEUtranEricssonCounter].[dbo].[MCellHourCounter]
  where date_id > '20230120'
  and [EutranCellFDD] in(
'YG4G18_4531863E_4',
'YG4G18_4532016E_4',
'YG4G18_4532342E_14_M',
'YG4G18_4532332E_14',
'YG4G18_4532253E_15_M',
'YG4G18_4531785E_5',
'YG4G18_4531859E_5',
'YG4G18_4532238E_14'

)

  order by DATE_ID,HOUR_ID