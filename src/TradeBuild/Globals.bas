Attribute VB_Name = "Globals"
Option Explicit

'@================================================================================
' Constants
'@================================================================================

Public Const ProjectName                As String = "TradeBuild26"

Private Const ModuleName                As String = "Globals"

Public Const S_OK                           As Long = 0
Public Const NoValidID                      As Long = -1

Public Const DefaultStudyValue              As String = "$default"

Public Const MaxCurrency                    As Currency = 922337203685477.5807@
Public Const MinDouble                      As Double = -(2 - 2 ^ -52) * 2 ^ 1023
Public Const MaxDouble                      As Double = (2 - 2 ^ -52) * 2 ^ 1023

Public Const OneSecond                      As Double = 1.15740740740741E-05
Public Const OneMicroSecond                 As Double = 1.15740740740741E-11

Public Const MultiTaskingTimeQuantumMillisecs As Long = 20

Public Const BidInputName                   As String = "Bid"
Public Const AskInputName                   As String = "Ask"
Public Const OpenInterestInputName          As String = "Open interest"
Public Const TradeInputName                 As String = "Trade"
Public Const TickVolumeInputName            As String = "Tick Volume"
Public Const VolumeInputName                As String = "Total Volume"

Public Const StrOrderTypeNone               As String = ""
Public Const StrOrderTypeMarket             As String = "Market"
Public Const StrOrderTypeMarketClose        As String = "Market on Close"
Public Const StrOrderTypeLimit              As String = "Limit"
Public Const StrOrderTypeLimitClose         As String = "Limit on Close"
Public Const StrOrderTypePegMarket          As String = "Peg to Market"
Public Const StrOrderTypeStop               As String = "Stop"
Public Const StrOrderTypeStopLimit          As String = "Stop Limit"
Public Const StrOrderTypeTrail              As String = "Trailing Stop"
Public Const StrOrderTypeRelative           As String = "Relative"
Public Const StrOrderTypeVWAP               As String = "VWAP"
Public Const StrOrderTypeMarketToLimit      As String = "Market to Limit"
Public Const StrOrderTypeQuote              As String = "Quote"
Public Const StrOrderTypeAutoStop           As String = "Auto Stop"
Public Const StrOrderTypeAutoLimit          As String = "Auto Limit"
Public Const StrOrderTypeAdjust             As String = "Adjust"
Public Const StrOrderTypeAlert              As String = "Alert"
Public Const StrOrderTypeLimitIfTouched     As String = "Limit if Touched"
Public Const StrOrderTypeMarketIfTouched    As String = "Market if Touched"
Public Const StrOrderTypeTrailLimit         As String = "Trail Limit"
Public Const StrOrderTypeMarketWithProtection As String = "Market with Protection"
Public Const StrOrderTypeMarketOnOpen       As String = "Market on Open"
Public Const StrOrderTypeLimitOnOpen        As String = "Limit on Open"
Public Const StrOrderTypePeggedToPrimary    As String = "Pegged to Primary"

Public Const StrOrderActionBuy              As String = "Buy"
Public Const StrOrderActionSell             As String = "Sell"

'@================================================================================
' Enums
'@================================================================================

'@================================================================================
' Types
'@================================================================================

'@================================================================================
' External function declarations
'@================================================================================

'@================================================================================
' Variables
'@================================================================================

Public gTB As TradeBuildAPI

Private mLogTokens(9) As String

'@================================================================================
' Procedures
'@================================================================================

Public Function GApiNotifyCodeToString(value As ApiNotifyCodes) As String
Select Case value
Case ApiNotifyServiceProviderError
    GApiNotifyCodeToString = "ApiNotifyServiceProviderError"
Case ApiNotifyTickfileEmpty
    GApiNotifyCodeToString = "ApiNotifyTickfileEmpty"
Case ApiNotifyTickfileInvalid
    GApiNotifyCodeToString = "ApiNotifyTickfileInvalid"
Case ApiNotifyTickfileVersionNotSupported
    GApiNotifyCodeToString = "ApiNotifyTickfileVersionNotSupported"
Case ApiNotifyTickfileContractDetailsInvalid
    GApiNotifyCodeToString = "ApiNotifyTickfileContractDetailsInvalid"
Case ApiNotifyTickfileNoContractDetails
    GApiNotifyCodeToString = "ApiNotifyTickfileNoContractDetails"
Case ApiNotifyTickfileDataSourceNotResponding
    GApiNotifyCodeToString = "ApiNotifyTickfileDataSourceNotResponding"
Case ApiNotifyTickfileDoesntExist
    GApiNotifyCodeToString = "ApiNotifyTickfileDoesntExist"
Case ApiNOtifyTickfileFormatNotSupported
    GApiNotifyCodeToString = "ApiNOtifyTickfileFormatNotSupported"
Case ApiNotifyTickfileContractSpecifierInvalid
    GApiNotifyCodeToString = "ApiNotifyTickfileContractSpecifierInvalid"
Case ApiNotifyCantWriteToTickfileDataStore
    GApiNotifyCodeToString = "ApiNotifyCantWriteToTickfileDataStore"
Case ApiNotifyRetryingConnectionToTickfileDataSource
    GApiNotifyCodeToString = "ApiNotifyRetryingConnectionToTickfileDataSource"
Case ApiNotifyConnectedToTickfileDataSource
    GApiNotifyCodeToString = "ApiNotifyConnectedToTickfileDataSource"
Case ApiNotifyReconnectingToTickfileDataSource
    GApiNotifyCodeToString = "ApiNotifyReconnectingToTickfileDataSource"
Case ApiNotifyLostConnectionToTickfileDataSource
    GApiNotifyCodeToString = "ApiNotifyLostConnectionToTickfileDataSource"
Case ApiNotifyNoHistoricDataSource
    GApiNotifyCodeToString = "ApiNotifyNoHistoricDataSource"
Case ApiNotifyCantConnectHistoricDataSource
    GApiNotifyCodeToString = "ApiNotifyCantConnectHistoricDataSource"
Case ApiNotifyConnectedToHistoricDataSource
    GApiNotifyCodeToString = "ApiNotifyConnectedToHistoricDataSource"
Case ApiNotifyDisconnectedFromHistoricDataSource
    GApiNotifyCodeToString = "ApiNotifyDisconnectedFromHistoricDataSource"
Case ApiNotifyRetryingConnectionToHistoricDataSource
    GApiNotifyCodeToString = "ApiNotifyRetryingConnectionToHistoricDataSource"
Case ApiNotifyLostConnectionToHistoricDataSource
    GApiNotifyCodeToString = "ApiNotifyLostConnectionToHistoricDataSource"
Case ApiNotifyReconnectingToHistoricDataSource
    GApiNotifyCodeToString = "ApiNotifyReconnectingToHistoricDataSource"
Case ApiNotifyHistoricDataRequestFailed
    GApiNotifyCodeToString = "ApiNotifyHistoricDataRequestFailed"
Case ApiNotifyInvalidRequest
    GApiNotifyCodeToString = "ApiNotifyInvalidRequest"
Case ApiNotifyCantConnectRealtimeDataSource
    GApiNotifyCodeToString = "ApiNotifyCantConnectRealtimeDataSource"
Case ApiNotifyConnectedToRealtimeDataSource
    GApiNotifyCodeToString = "ApiNotifyConnectedToRealtimeDataSource"
Case ApiNotifyLostConnectionToRealtimeDataSource
    GApiNotifyCodeToString = "ApiNotifyLostConnectionToRealtimeDataSource"
Case ApiNotifyNoRealtimeDataSource
    GApiNotifyCodeToString = "ApiNotifyNoRealtimeDataSource"
Case ApiNotifyReconnectingToRealtimeDataSource
    GApiNotifyCodeToString = "ApiNotifyReconnectingToRealtimeDataSource"
Case ApiNotifyDisconnectedFromRealtimeDataSource
    GApiNotifyCodeToString = "ApiNotifyDisconnectedFromRealtimeDataSource"
Case ApiNotifyRealtimeDataRequestFailed
    GApiNotifyCodeToString = "ApiNotifyRealtimeDataRequestFailed"
Case ApiNotifyRealtimeDataSourceNotResponding
    GApiNotifyCodeToString = "ApiNotifyRealtimeDataSourceNotResponding"
Case ApiNotifyCantConnectToBroker
    GApiNotifyCodeToString = "ApiNotifyCantConnectToBroker"
Case ApiNotifyConnectedToBroker
    GApiNotifyCodeToString = "ApiNotifyConnectedToBroker"
Case ApiNotifyRetryConnectToBroker
    GApiNotifyCodeToString = "ApiNotifyRetryConnectToBroker"
Case ApiNotifyLostConnectionToBroker
    GApiNotifyCodeToString = "ApiNotifyLostConnectionToBroker"
Case ApiNotifyReConnectingToBroker
    GApiNotifyCodeToString = "ApiNotifyReConnectingToBroker"
Case ApiNotifyDisconnectedFromBroker
    GApiNotifyCodeToString = "ApiNotifyDisconnectedFromBroker"
Case ApiNotifyNonSpecificNotification
    GApiNotifyCodeToString = "ApiNotifyNonSpecificNotification"
Case ApiNotifyCantWriteToHistoricDataStore
    GApiNotifyCodeToString = "ApiNotifyCantWriteToHistoricDataStore"
Case ApiNotifyTryLater
    GApiNotifyCodeToString = "ApiNotifyTryLater"
Case ApiNotifyCantConnectContractDataSource
    GApiNotifyCodeToString = "ApiNotifyCantConnectContractDataSource"
Case ApiNotifyConnectedToContractDataSource
    GApiNotifyCodeToString = "ApiNotifyConnectedToContractDataSource"
Case ApiNotifyDisconnectedFromContractDataSource
    GApiNotifyCodeToString = "ApiNotifyDisconnectedFromContractDataSource"
Case ApiNotifyLostConnectionToContractDataSource
    GApiNotifyCodeToString = "ApiNotifyLostConnectionToContractDataSource"
Case ApiNotifyReConnectingContractDataSource
    GApiNotifyCodeToString = "ApiNotifyReConnectingContractDataSource"
Case ApiNotifyRetryConnectContractDataSource
    GApiNotifyCodeToString = "ApiNotifyRetryConnectContractDataSource"
End Select
End Function

''
' Converts a member of the EntryOrderTypes enumeration to the equivalent OrderTypes value.
'
' @return           the OrderTypes value corresponding to the parameter
' @param pEntryOrderType the EntryOrderTypes value to be converted
' @ see
'
'@/
Public Function GEntryOrderTypeToOrderType( _
                ByVal pEntryOrderType As EntryOrderTypes) As OrderTypes
Select Case pEntryOrderType
Case EntryOrderTypeMarket
    GEntryOrderTypeToOrderType = OrderTypeMarket
Case EntryOrderTypeMarketOnOpen
    GEntryOrderTypeToOrderType = OrderTypeMarketOnOpen
Case EntryOrderTypeMarketOnClose
    GEntryOrderTypeToOrderType = OrderTypeMarketOnClose
Case EntryOrderTypeMarketIfTouched
    GEntryOrderTypeToOrderType = OrderTypeMarketIfTouched
Case EntryOrderTypeMarketToLimit
    GEntryOrderTypeToOrderType = OrderTypeMarketToLimit
Case EntryOrderTypeBid
    GEntryOrderTypeToOrderType = OrderTypeLimit
Case EntryOrderTypeAsk
    GEntryOrderTypeToOrderType = OrderTypeLimit
Case EntryOrderTypeLast
    GEntryOrderTypeToOrderType = OrderTypeLimit
Case EntryOrderTypeLimit
    GEntryOrderTypeToOrderType = OrderTypeLimit
Case EntryOrderTypeLimitOnOpen
    GEntryOrderTypeToOrderType = OrderTypeLimitOnOpen
Case EntryOrderTypeLimitOnClose
    GEntryOrderTypeToOrderType = OrderTypeLimitOnClose
Case EntryOrderTypeLimitIfTouched
    GEntryOrderTypeToOrderType = OrderTypeLimitIfTouched
Case EntryOrderTypeStop
    GEntryOrderTypeToOrderType = OrderTypeStop
Case EntryOrderTypeStopLimit
    GEntryOrderTypeToOrderType = OrderTypeStopLimit
Case Else
    Err.Raise ErrorCodes.ErrIllegalArgumentException, _
                "TradeBuild26.Module1::gEntryOrderTypeToOrderType", _
                "Invalid entry type"
End Select
End Function

Public Function GEntryOrderTypeToString(ByVal value As EntryOrderTypes) As String
Select Case value
Case EntryOrderTypeMarket
    GEntryOrderTypeToString = "Market"
Case EntryOrderTypeMarketOnOpen
    GEntryOrderTypeToString = "Market on open"
Case EntryOrderTypeMarketOnClose
    GEntryOrderTypeToString = "Market on close"
Case EntryOrderTypeMarketIfTouched
    GEntryOrderTypeToString = "Market if touched"
Case EntryOrderTypeMarketToLimit
    GEntryOrderTypeToString = "Market to limit"
Case EntryOrderTypeBid
    GEntryOrderTypeToString = "Bid price"
Case EntryOrderTypeAsk
    GEntryOrderTypeToString = "Ask price"
Case EntryOrderTypeLast
    GEntryOrderTypeToString = "Last Trade price"
Case EntryOrderTypeLimit
    GEntryOrderTypeToString = "Limit"
Case EntryOrderTypeLimitOnOpen
    GEntryOrderTypeToString = "Limit on open"
Case EntryOrderTypeLimitOnClose
    GEntryOrderTypeToString = "Limit on close"
Case EntryOrderTypeLimitIfTouched
    GEntryOrderTypeToString = "Limit if touched"
Case EntryOrderTypeStop
    GEntryOrderTypeToString = "Stop"
Case EntryOrderTypeStopLimit
    GEntryOrderTypeToString = "Stop limit"
End Select
End Function

Public Function GEntryOrderTypeToShortString(ByVal value As EntryOrderTypes) As String
Select Case value
Case EntryOrderTypeMarket
    GEntryOrderTypeToShortString = "MKT"
Case EntryOrderTypeMarketOnOpen
    GEntryOrderTypeToShortString = "MOO"
Case EntryOrderTypeMarketOnClose
    GEntryOrderTypeToShortString = "MOC"
Case EntryOrderTypeMarketIfTouched
    GEntryOrderTypeToShortString = "MIT"
Case EntryOrderTypeMarketToLimit
    GEntryOrderTypeToShortString = "MTL"
Case EntryOrderTypeBid
    GEntryOrderTypeToShortString = "BID"
Case EntryOrderTypeAsk
    GEntryOrderTypeToShortString = "ASK"
Case EntryOrderTypeLast
    GEntryOrderTypeToShortString = "LAST"
Case EntryOrderTypeLimit
    GEntryOrderTypeToShortString = "LMT"
Case EntryOrderTypeLimitOnOpen
    GEntryOrderTypeToShortString = "LOO"
Case EntryOrderTypeLimitOnClose
    GEntryOrderTypeToShortString = "LOC"
Case EntryOrderTypeLimitIfTouched
    GEntryOrderTypeToShortString = "LIT"
Case EntryOrderTypeStop
    GEntryOrderTypeToShortString = "STP"
Case EntryOrderTypeStopLimit
    GEntryOrderTypeToShortString = "STPLMT"
End Select
End Function

Public Sub GHandleFatalError( _
                ByRef pProcName As String, _
                ByRef pModuleName As String, _
                Optional ByVal pFailpoint As Long)
Dim errNum As Long: errNum = Err.number
Dim errSource As String: errSource = Err.source
Dim errDesc As String: errDesc = Err.Description

On Error GoTo Err

' re-raise the error to get the calling procedure's procName into the source info
HandleUnexpectedError pReRaise:=True, pLog:=True, pProcedureName:=pProcName, pNumber:=errNum, pSource:=errSource, pDescription:=errDesc, pProjectName:=ProjectName, pModuleName:=pModuleName, pFailpoint:=pFailpoint

' NB: will never get to here so no need for Exit Sub

Err:
gTB.NotifyFatalError Err.number, Err.Description, Err.source
End Sub

Public Function GIsValidTIF(ByVal value As OrderTifs) As Boolean
Select Case value
Case TIFDay
    GIsValidTIF = True
Case TIFGoodTillCancelled
    GIsValidTIF = True
Case TIFImmediateOrCancel
    GIsValidTIF = True
Case Else
    GIsValidTIF = False
End Select
End Function

Public Function GLegOpenCloseFromString(ByVal value As String) As LegOpenClose
Select Case UCase$(value)
Case ""
    GLegOpenCloseFromString = LegUnknownPos
Case "SAME"
    GLegOpenCloseFromString = LegSamePos
Case "OPEN"
    GLegOpenCloseFromString = LegOpenPos
Case "CLOSE"
    GLegOpenCloseFromString = LegClosePos
End Select
End Function

Public Function GLegOpenCloseToString(ByVal value As LegOpenClose) As String
Select Case value
Case LegSamePos
    GLegOpenCloseToString = "SAME"
Case LegOpenPos
    GLegOpenCloseToString = "OPEN"
Case LegClosePos
    GLegOpenCloseToString = "CLOSE"
End Select
End Function

Public Function gNotifyExistingCollectionMembers( _
                ByVal pCollection As Variant, _
                ByVal pListener As CollectionChangeListener, _
                ByVal pSource As Object)
Dim lItem As Variant

Const ProcName As String = "gNotifyExistingCollectionMembers"
Dim failpoint As String
On Error GoTo Err

If VarType(pCollection) And vbArray = vbArray Then
    For Each lItem In pCollection
        notifyCollectionMember lItem, pSource, pListener
    Next
ElseIf Not IsObject(pCollection) Then
    Err.Raise ErrorCodes.ErrIllegalArgumentException, _
            ProjectName & "." & ModuleName & ":" & ProcName, _
            "pCollection argument must be an array or a VB6 collection or must implement Enumerable"
ElseIf TypeOf pCollection Is Collection Then
    For Each lItem In pCollection
        notifyCollectionMember lItem, pSource, pListener
    Next
ElseIf TypeOf pCollection Is Enumerable Then
    Dim enColl As Enumerable
    Dim en As Enumerator
    
    Set enColl = pCollection
    Set en = enColl.Enumerator
    
    Do While en.MoveNext
        notifyCollectionMember en.current, pSource, pListener
    Loop
Else
    Err.Raise ErrorCodes.ErrIllegalArgumentException, _
            ProjectName & "." & ModuleName & ":" & ProcName, _
            "pCollection argument must be an array or a VB6 collection or must implement Enumerable"
End If

Exit Function

Err:
HandleUnexpectedError pReRaise:=True, pLog:=False, pProcedureName:=ProcName, pNumber:=Err.number, pSource:=Err.source, pDescription:=Err.Description, pProjectName:=ProjectName, pModuleName:=ModuleName, pFailpoint:=failpoint

End Function

Public Function GOrderActionFromString(ByVal value As String) As OrderActions
Select Case UCase$(value)
Case StrOrderActionBuy
    GOrderActionFromString = ActionBuy
Case StrOrderActionSell
    GOrderActionFromString = ActionSell
End Select
End Function

Public Function GOrderActionToString(ByVal value As OrderActions) As String
Select Case value
Case ActionBuy
    GOrderActionToString = StrOrderActionBuy
Case ActionSell
    GOrderActionToString = StrOrderActionSell
End Select
End Function

Public Function GOrderAttributeToString(ByVal value As OrderAttributes) As String
Select Case value
    Case OrderAttOpenClose
        GOrderAttributeToString = "OpenClose"
    Case OrderAttOrigin
        GOrderAttributeToString = "Origin"
    Case OrderAttOriginatorRef
        GOrderAttributeToString = "OriginatorRef"
    Case OrderAttBlockOrder
        GOrderAttributeToString = "BlockOrder"
    Case OrderAttSweepToFill
        GOrderAttributeToString = "SweepToFill"
    Case OrderAttDisplaySize
        GOrderAttributeToString = "DisplaySize"
    Case OrderAttIgnoreRTH
        GOrderAttributeToString = "IgnoreRTH"
    Case OrderAttHidden
        GOrderAttributeToString = "Hidden"
    Case OrderAttDiscretionaryAmount
        GOrderAttributeToString = "DiscretionaryAmount"
    Case OrderAttGoodAfterTime
        GOrderAttributeToString = "GoodAfterTime"
    Case OrderAttGoodTillDate
        GOrderAttributeToString = "GoodTillDate"
    Case OrderAttRTHOnly
        GOrderAttributeToString = "RTHOnly"
    Case OrderAttRule80A
        GOrderAttributeToString = "Rule80A"
    Case OrderAttSettlingFirm
        GOrderAttributeToString = "SettlingFirm"
    Case OrderAttAllOrNone
        GOrderAttributeToString = "AllOrNone"
    Case OrderAttMinimumQuantity
        GOrderAttributeToString = "MinimumQuantity"
    Case OrderAttPercentOffset
        GOrderAttributeToString = "PercentOffset"
    Case OrderAttETradeOnly
        GOrderAttributeToString = "ETradeOnly"
    Case OrderAttFirmQuoteOnly
        GOrderAttributeToString = "FirmQuoteOnly"
    Case OrderAttNBBOPriceCap
        GOrderAttributeToString = "NBBOPriceCap"
    Case OrderAttOverrideConstraints
        GOrderAttributeToString = "OverrideConstraints"
    Case OrderAttAction
        GOrderAttributeToString = "Action"
    Case OrderAttLimitPrice
        GOrderAttributeToString = "LimitPrice"
    Case OrderAttOrderType
        GOrderAttributeToString = "OrderType"
    Case OrderAttQuantity
        GOrderAttributeToString = "Quantity"
    Case OrderAttTimeInForce
        GOrderAttributeToString = "TimeInForce"
    Case OrderAttTriggerPrice
        GOrderAttributeToString = "TriggerPrice"
    Case OrderAttGoodAfterTimeTZ
        GOrderAttributeToString = "GoodAfterTimeTZ"
    Case OrderAttGoodTillDateTZ
        GOrderAttributeToString = "GoodTillDateTZ"
    Case OrderAttStopTriggerMethod
        GOrderAttributeToString = "StopTriggerMethod"
    Case Else
        GOrderAttributeToString = "***Unknown order attribute***"
End Select
End Function

Public Function GOrderStatusToString(ByVal value As OrderStatuses) As String
Select Case UCase$(value)
Case OrderStatusCreated
    GOrderStatusToString = "Created"
Case OrderStatusRejected
    GOrderStatusToString = "Rejected"
Case OrderStatusPendingSubmit
    GOrderStatusToString = "Pending Submit"
Case OrderStatusPreSubmitted
    GOrderStatusToString = "Presubmitted"
Case OrderStatusSubmitted
    GOrderStatusToString = "Submitted"
Case OrderStatusCancelling
    GOrderStatusToString = "Cancelling"
Case OrderStatusCancelled
    GOrderStatusToString = "Cancelled"
Case OrderStatusFilled
    GOrderStatusToString = "Filled"
End Select
End Function

Public Function GOrderStopTriggerMethodToString(ByVal value As StopTriggerMethods) As String
Select Case value
Case StopTriggerMethods.StopTriggerBidAsk
    GOrderStopTriggerMethodToString = "Bid/Ask"
Case StopTriggerMethods.StopTriggerDefault
    GOrderStopTriggerMethodToString = "Default"
Case StopTriggerMethods.StopTriggerDoubleBidAsk
    GOrderStopTriggerMethodToString = "Double Bid/Ask"
Case StopTriggerMethods.StopTriggerDoubleLast
    GOrderStopTriggerMethodToString = "Double last"
Case StopTriggerMethods.StopTriggerLast
    GOrderStopTriggerMethodToString = "Last"
Case StopTriggerMethods.StopTriggerLastOrBidAsk
    GOrderStopTriggerMethodToString = "Last or Bid/Ask"
Case StopTriggerMethods.StopTriggerMidPoint
    GOrderStopTriggerMethodToString = "Mid-point"
End Select
End Function

Public Function GOrderTIFToString(ByVal value As OrderTifs) As String
Select Case value
Case TIFDay
    GOrderTIFToString = "DAY"
Case TIFGoodTillCancelled
    GOrderTIFToString = "GTC"
Case TIFImmediateOrCancel
    GOrderTIFToString = "IOC"
End Select
End Function

Public Function GOrderTypeToString(ByVal value As OrderTypes) As String
Select Case value
Case OrderTypeNone
    GOrderTypeToString = StrOrderTypeNone
Case OrderTypeMarket
    GOrderTypeToString = StrOrderTypeMarket
Case OrderTypeMarketOnClose
    GOrderTypeToString = StrOrderTypeMarketClose
Case OrderTypeLimit
    GOrderTypeToString = StrOrderTypeLimit
Case OrderTypeLimitOnClose
    GOrderTypeToString = StrOrderTypeLimitClose
Case OrderTypePeggedToMarket
    GOrderTypeToString = StrOrderTypePegMarket
Case OrderTypeStop
    GOrderTypeToString = StrOrderTypeStop
Case OrderTypeStopLimit
    GOrderTypeToString = StrOrderTypeStopLimit
Case OrderTypeTrail
    GOrderTypeToString = StrOrderTypeTrail
Case OrderTypeRelative
    GOrderTypeToString = StrOrderTypeRelative
Case OrderTypeVWAP
    GOrderTypeToString = StrOrderTypeVWAP
Case OrderTypeMarketToLimit
    GOrderTypeToString = StrOrderTypeMarketToLimit
Case OrderTypeQuote
    GOrderTypeToString = StrOrderTypeQuote
Case OrderTypeAdjust
    GOrderTypeToString = StrOrderTypeAdjust
Case OrderTypeAlert
    GOrderTypeToString = StrOrderTypeAlert
Case OrderTypeLimitIfTouched
    GOrderTypeToString = StrOrderTypeLimitIfTouched
Case OrderTypeMarketIfTouched
    GOrderTypeToString = StrOrderTypeMarketIfTouched
Case OrderTypeTrailLimit
    GOrderTypeToString = StrOrderTypeTrailLimit
Case OrderTypeMarketWithProtection
    GOrderTypeToString = StrOrderTypeMarketWithProtection
Case OrderTypeMarketOnOpen
    GOrderTypeToString = StrOrderTypeMarketOnOpen
Case OrderTypeLimitOnOpen
    GOrderTypeToString = StrOrderTypeLimitOnOpen
Case OrderTypePeggedToPrimary
    GOrderTypeToString = StrOrderTypePeggedToPrimary
End Select

End Function

''
' Converts a member of the StopOrderTypes enumeration to the equivalent OrderTypes value.
'
' @return           the OrderTypes value corresponding to the parameter
' @param pStopOrderType the StopOrderTypes value to be converted
'
'@/
Public Function GStopOrderTypeToOrderType( _
                ByVal pStopOrderType As StopOrderTypes) As OrderTypes
Select Case pStopOrderType
Case StopOrderTypeNone
    GStopOrderTypeToOrderType = OrderTypeNone
Case StopOrderTypeStop
    GStopOrderTypeToOrderType = OrderTypeStop
Case StopOrderTypeStopLimit
    GStopOrderTypeToOrderType = OrderTypeStopLimit
Case StopOrderTypeBid
    GStopOrderTypeToOrderType = OrderTypeStop
Case StopOrderTypeAsk
    GStopOrderTypeToOrderType = OrderTypeStop
Case StopOrderTypeLast
    GStopOrderTypeToOrderType = OrderTypeStop
Case StopOrderTypeAuto
    GStopOrderTypeToOrderType = OrderTypeAutoStop
Case Else
    Err.Raise ErrorCodes.ErrIllegalArgumentException, _
                "TradeBuild26.Module1::gStopOrderTypeToOrderType", _
                "Invalid entry type"
End Select
End Function

Public Function GStopOrderTypeToShortString(ByVal value As StopOrderTypes)
Select Case value
Case StopOrderTypeNone
    GStopOrderTypeToShortString = "NONE"
Case StopOrderTypeStop
    GStopOrderTypeToShortString = "STP"
Case StopOrderTypeStopLimit
    GStopOrderTypeToShortString = "STPLMT"
Case StopOrderTypeBid
    GStopOrderTypeToShortString = "BID"
Case StopOrderTypeAsk
    GStopOrderTypeToShortString = "ASK"
Case StopOrderTypeLast
    GStopOrderTypeToShortString = "TRADE"
Case StopOrderTypeAuto
    GStopOrderTypeToShortString = "AUTO"
End Select
End Function

Public Function GStopOrderTypeToString(ByVal value As StopOrderTypes)
Select Case value
Case StopOrderTypeNone
    GStopOrderTypeToString = "None"
Case StopOrderTypeStop
    GStopOrderTypeToString = "Stop"
Case StopOrderTypeStopLimit
    GStopOrderTypeToString = "Stop limit"
Case StopOrderTypeBid
    GStopOrderTypeToString = "Bid price"
Case StopOrderTypeAsk
    GStopOrderTypeToString = "Ask price"
Case StopOrderTypeLast
    GStopOrderTypeToString = "LAST"
Case StopOrderTypeAuto
    GStopOrderTypeToString = "Auto"
End Select
End Function

''
' Converts a member of the TargetOrderTypes enumeration to the equivalent OrderTypes value.
'
' @return           the OrderTypes value corresponding to the parameter
' @param pTargetOrderType the TargetOrderTypes value to be converted
' @ see
'
'@/
Public Function GTargetOrderTypeToOrderType( _
                ByVal pTargetOrderType As TargetOrderTypes) As OrderTypes
Select Case pTargetOrderType
Case TargetOrderTypeNone
    GTargetOrderTypeToOrderType = OrderTypeNone
Case TargetOrderTypeLimit
    GTargetOrderTypeToOrderType = OrderTypeLimit
Case TargetOrderTypeLimitIfTouched
    GTargetOrderTypeToOrderType = OrderTypeLimitIfTouched
Case TargetOrderTypeMarketIfTouched
    GTargetOrderTypeToOrderType = OrderTypeMarketIfTouched
Case TargetOrderTypeBid
    GTargetOrderTypeToOrderType = OrderTypeLimit
Case TargetOrderTypeAsk
    GTargetOrderTypeToOrderType = OrderTypeLimit
Case TargetOrderTypeLast
    GTargetOrderTypeToOrderType = OrderTypeLimit
Case TargetOrderTypeAuto
    GTargetOrderTypeToOrderType = OrderTypeAutoLimit
Case Else
    Err.Raise ErrorCodes.ErrIllegalArgumentException, _
                "TradeBuild26.Module1::gTargetOrderTypeToOrderType", _
                "Invalid entry type"
End Select
End Function

Public Function GTargetOrderTypeToShortString(ByVal value As TargetOrderTypes)
Select Case value
Case TargetOrderTypeNone
    GTargetOrderTypeToShortString = "NONE"
Case TargetOrderTypeLimit
    GTargetOrderTypeToShortString = "LMT"
Case TargetOrderTypeMarketIfTouched
    GTargetOrderTypeToShortString = "MIT"
Case TargetOrderTypeBid
    GTargetOrderTypeToShortString = "BID"
Case TargetOrderTypeAsk
    GTargetOrderTypeToShortString = "ASK"
Case TargetOrderTypeLast
    GTargetOrderTypeToShortString = "LAST"
Case TargetOrderTypeAuto
    GTargetOrderTypeToShortString = "AUTO"
End Select
End Function

Public Function GTargetOrderTypeToString(ByVal value As TargetOrderTypes)
Select Case value
Case TargetOrderTypeNone
    GTargetOrderTypeToString = "None"
Case TargetOrderTypeLimit
    GTargetOrderTypeToString = "Limit"
Case TargetOrderTypeMarketIfTouched
    GTargetOrderTypeToString = "Market if touched"
Case TargetOrderTypeBid
    GTargetOrderTypeToString = "Bid price"
Case TargetOrderTypeAsk
    GTargetOrderTypeToString = "Ask price"
Case TargetOrderTypeLast
    GTargetOrderTypeToString = "Last Trade price"
Case TargetOrderTypeAuto
    GTargetOrderTypeToString = "Auto"
End Select
End Function

Public Function GTickfileSpecifierToString(tfSpec As ITickfileSpecifier) As String
If tfSpec.Filename <> "" Then
    GTickfileSpecifierToString = tfSpec.Filename
Else
    GTickfileSpecifierToString = "Contract: " & _
                                Replace(tfSpec.Contract.specifier.ToString, vbCrLf, "; ") & _
                            ": From: " & FormatDateTime(tfSpec.FromDate, vbGeneralDate) & _
                            " To: " & FormatDateTime(tfSpec.ToDate, vbGeneralDate)
End If
End Function

Public Sub GLog(ByRef pMsg As String, _
                ByRef pProjName As String, _
                ByRef pModName As String, _
                ByRef pProcName As String, _
                Optional ByRef pMsgQualifier As String = vbNullString, _
                Optional ByVal pLogLevel As LogLevels = LogLevelNormal)
If Not GLogLogger.IsLoggable(pLogLevel) Then Exit Sub
mLogTokens(0) = "["
mLogTokens(1) = pProjName
mLogTokens(2) = "."
mLogTokens(3) = pModName
mLogTokens(4) = ":"
mLogTokens(5) = pProcName
mLogTokens(6) = "] "
mLogTokens(7) = pMsg
If Len(pMsgQualifier) <> 0 Then
    mLogTokens(8) = ": "
    mLogTokens(9) = pMsgQualifier
Else
    mLogTokens(8) = vbNullString
    mLogTokens(9) = vbNullString
End If

GLogLogger.Log pLogLevel, Join(mLogTokens, "")
End Sub

Public Property Get GLogLogger() As Logger
Static lLogger As Logger
If lLogger Is Nothing Then
    Set lLogger = GetLogger("tradebuild.log")
End If
Set GLogLogger = lLogger
End Property

Public Sub GLogProfitProfile( _
                ByVal pData As Variant, _
                ByVal pSimulated As Boolean, _
                ByVal pSource As Object, _
                Optional ByVal pLogLevel As LogLevels = LogLevelNormal)
Static lLogger As Logger
Static lLoggerSimulated As Logger
logInfotypeData "ProfitProfile", pData, pSimulated, pSource, pLogLevel, IIf(pSimulated, lLoggerSimulated, lLogger)
End Sub

Public Sub GLogMoneyManagement( _
                ByVal pData As Variant, _
                ByVal pSimulated As Boolean, _
                ByVal pSource As Object, _
                Optional ByVal pLogLevel As LogLevels = LogLevelNormal)
Static lLogger As Logger
Static lLoggerSimulated As Logger
logInfotypeData "MoneyManagement", pData, pSimulated, pSource, pLogLevel, IIf(pSimulated, lLoggerSimulated, lLogger)
End Sub

Public Sub GLogOrderPlexProfileStruct( _
                ByVal pData As Variant, _
                ByVal pSimulated As Boolean, _
                ByVal pSource As Object, _
                Optional ByVal pLogLevel As LogLevels = LogLevelNormal)
Static lLogger As Logger
Static lLoggerSimulated As Logger
logInfotypeData "OrderPlexProfileStruct", pData, pSimulated, pSource, pLogLevel, IIf(pSimulated, lLoggerSimulated, lLogger)
End Sub

Public Sub GLogOrderPlexProfileString( _
                ByVal pData As Variant, _
                ByVal pSimulated As Boolean, _
                ByVal pSource As Object, _
                Optional ByVal pLogLevel As LogLevels = LogLevelNormal)
Static lLogger As Logger
Static lLoggerSimulated As Logger
logInfotypeData "OrderPlexProfileString", pData, pSimulated, pSource, pLogLevel, IIf(pSimulated, lLoggerSimulated, lLogger)
End Sub

Public Sub GLogOrder( _
                ByVal pData As Variant, _
                ByVal pSimulated As Boolean, _
                ByVal pSource As Object, _
                Optional ByVal pLogLevel As LogLevels = LogLevelNormal)
Static lLogger As Logger
Static lLoggerSimulated As Logger
logInfotypeData "Order", pData, pSimulated, pSource, pLogLevel, IIf(pSimulated, lLoggerSimulated, lLogger)
End Sub

Public Sub GLogPosition( _
                ByVal pData As Variant, _
                ByVal pSimulated As Boolean, _
                ByVal pSource As Object, _
                Optional ByVal pLogLevel As LogLevels = LogLevelNormal)
Static lLogger As Logger
Static lLoggerSimulated As Logger
logInfotypeData "Position", pData, pSimulated, pSource, pLogLevel, IIf(pSimulated, lLoggerSimulated, lLogger)
End Sub

Public Sub GLogTradeProfile( _
                ByVal pData As Variant, _
                ByVal pSimulated As Boolean, _
                ByVal pSource As Object, _
                Optional ByVal pLogLevel As LogLevels = LogLevelNormal)
Static lLogger As Logger
Static lLoggerSimulated As Logger
logInfotypeData "TradeProfile", pData, pSimulated, pSource, pLogLevel, IIf(pSimulated, lLoggerSimulated, lLogger)
End Sub

Public Sub GLogProfit( _
                ByVal pData As Variant, _
                ByVal pSimulated As Boolean, _
                ByVal pSource As Object, _
                Optional ByVal pLogLevel As LogLevels = LogLevelNormal)
Static lLogger As Logger
Static lLoggerSimulated As Logger
logInfotypeData "Profit", pData, pSimulated, pSource, pLogLevel, IIf(pSimulated, lLoggerSimulated, lLogger)
End Sub

Public Sub GLogDrawdown( _
                ByVal pData As Variant, _
                ByVal pSimulated As Boolean, _
                ByVal pSource As Object, _
                Optional ByVal pLogLevel As LogLevels = LogLevelNormal)
Static lLogger As Logger
Static lLoggerSimulated As Logger
logInfotypeData "Drawdown", pData, pSimulated, pSource, pLogLevel, IIf(pSimulated, lLoggerSimulated, lLogger)
End Sub

Public Sub GLogMaxProfit( _
                ByVal pData As Variant, _
                ByVal pSimulated As Boolean, _
                ByVal pSource As Object, _
                Optional ByVal pLogLevel As LogLevels = LogLevelNormal)
Static lLogger As Logger
Static lLoggerSimulated As Logger
logInfotypeData "MaxProfit", pData, pSimulated, pSource, pLogLevel, IIf(pSimulated, lLoggerSimulated, lLogger)
End Sub

Public Sub GLogMaxLoss( _
                ByVal pData As Variant, _
                ByVal pSimulated As Boolean, _
                ByVal pSource As Object, _
                Optional ByVal pLogLevel As LogLevels = LogLevelNormal)
Static lLogger As Logger
Static lLoggerSimulated As Logger
logInfotypeData "MaxLoss", pData, pSimulated, pSource, pLogLevel, IIf(pSimulated, lLoggerSimulated, lLogger)
End Sub

Public Sub GLogOrderDetail( _
                ByVal pData As Variant, _
                ByVal pSimulated As Boolean, _
                ByVal pSource As Object, _
                Optional ByVal pLogLevel As LogLevels = LogLevelNormal)
Static lLogger As Logger
Static lLoggerSimulated As Logger
logInfotypeData "OrderDetail", pData, pSimulated, pSource, pLogLevel, IIf(pSimulated, lLoggerSimulated, lLogger)
End Sub

Public Property Get GTracer() As Tracer
Static lTracer As Tracer
If lTracer Is Nothing Then Set lTracer = GetTracer("tradebuild")
Set GTracer = lTracer
End Property

Private Sub logInfotypeData( _
                ByVal pInfotype As String, _
                ByRef pData As Variant, _
                ByVal pSimulated As Boolean, _
                ByVal pSource As Object, _
                ByVal pLogLevel As LogLevels, _
                ByRef pLogger As Logger)
If pLogger Is Nothing Then
    Set pLogger = GetLogger("tradebuild." & pInfotype & IIf(pSimulated, "Simulated", ""))
    pLogger.LogToParent = False
End If
pLogger.Log pLogLevel, pData, pSource
End Sub

Private Sub notifyCollectionMember( _
                ByVal pItem As Variant, _
                ByVal pSource As Object, _
                ByVal pListener As CollectionChangeListener)
Dim ev As CollectionChangeEvent
Set ev.source = pSource
ev.changeType = CollItemAdded

If IsObject(pItem) Then
    Set ev.affectedItem = pItem
Else
    ev.affectedItem = pItem
End If
pListener.Change ev
End Sub
