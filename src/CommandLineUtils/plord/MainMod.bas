Attribute VB_Name = "MainMod"
Option Explicit

''
' Description here
'
'@/

'@================================================================================
' Interfaces
'@================================================================================

'@================================================================================
' Events
'@================================================================================

'@================================================================================
' Enums
'@================================================================================

'@================================================================================
' Types
'@================================================================================

'@================================================================================
' Constants
'@================================================================================

Public Const ProjectName                            As String = "plord27"
Private Const ModuleName                            As String = "MainMod"

Private Const ApiMessageLoggingSwitch               As String = "APIMESSAGELOGGING"
Private Const BatchOrdersSwitch                     As String = "BATCHORDERS"
Private Const LogFileSwitch                         As String = "LOG"
Private Const MonitorSwitch                         As String = "MONITOR"
Private Const ResultsDirSwitch                      As String = "RESULTSDIR"
Private Const RecoveryFileDirSwitch                 As String = "RECOVERYFILEDIR"
Private Const ScopeNameSwitch                       As String = "SCOPENAME"
Private Const SimulateOrdersSwitch                  As String = "SIMULATEORDERS"
Private Const StageOrdersSwitch                     As String = "STAGEORDERS"
Private Const StopAtSwitch                          As String = "STOPAT"
Private Const TwsSwitch                             As String = "TWS"

Public Const CancelAfterSwitch                      As String = "CANCELAFTER"
Public Const CancelPriceSwitch                      As String = "CANCELPRICE"
Public Const DescriptionSwitch                      As String = "DESCRIPTION"
Public Const OffsetSwitch                           As String = "OFFSET"
Public Const IgnoreRTHSwitch                        As String = "IGNORERTH"
Public Const PriceSwitch                            As String = "PRICE"
Public Const ReasonSwitch                           As String = "REASON"
Public Const TIFSwitch                              As String = "TIF"
Public Const TrailBySwitch                          As String = "TRAILBY"
Public Const TrailPercentSwitch                     As String = "TRAILPERCENT"
Public Const TriggerPriceSwitch                     As String = "TRIGGER"
Public Const TriggerPriceSwitch1                    As String = "TRIGGERPRICE"

Public Const CurrencySwitch                         As String = "CURRENCY"
Public Const CurrencySwitch1                        As String = "CURR"
Public Const ExchangeSwitch                         As String = "EXCHANGE"
Public Const ExchangeSwitch1                        As String = "EXCH"
Public Const ExpirySwitch                           As String = "EXPIRY"
Public Const ExpirySwitch1                          As String = "EXP"
Public Const GoodAfterTimeSwitch                    As String = "GOODAFTERTIME"
Public Const GoodTillDateSwitch                     As String = "GOODTILLDATE"
Public Const LocalSymbolSwitch                      As String = "LOCALSYMBOL"
Public Const LocalSymbolSwitch1                     As String = "LOCAL"
Public Const MultiplierSwitch                       As String = "MULTIPLIER"
Public Const MultiplierSwitch1                      As String = "MULT"
Public Const RightSwitch                            As String = "RIGHT"
Public Const SecTypeSwitch                          As String = "SECTYPE"
Public Const SecTypeSwitch1                         As String = "SEC"
Public Const SymbolSwitch                           As String = "SYMBOL"
Public Const SymbolSwitch1                          As String = "SYMB"
Public Const StrikeSwitch                           As String = "STRIKE"
Public Const StrikeSwitch1                          As String = "STR"
Public Const TimezoneSwitch                         As String = "TIMEZONE"

Public Const GroupsSubcommand                       As String = "GROUPS"
Public Const PositionsSubcommand                    As String = "POSITIONS"
Public Const TradesSubcommand                       As String = "TRADES"

Public Const ValueSeparator                         As String = ":"
Public Const SwitchPrefix                           As String = "/"

Private Const All                                   As String = "ALL"
Private Const Default                               As String = "DEFAULT"
Private Const Yes                                   As String = "YES"
Private Const No                                    As String = "NO"

Public Const TickOffsetDesignator                   As String = "T"
Public Const PercentOffsetDesignator                As String = "%"

' Legacy pseudo-order types from early versions
Public Const AskPseudoOrderType                     As String = "ASK"
Public Const BidPseudoOrderType                     As String = "BID"
Public Const LastPseudoOrderType                    As String = "Last"
Public Const AutoPseudoOrderType                    As String = "AUTO"

Private Const DefaultClientId                       As Long = 906564398

Private Const DefaultGroupName                      As String = "$"
Private Const AllGroups                             As String = "ALL"

Private Const DefaultPrompt                         As String = ":"

Private Const CloseoutMarket                        As String = "MKT"
Private Const CloseoutLimit                         As String = "LMT"

'@================================================================================
' Member variables
'@================================================================================

Public gCon                                         As Console

Public gLogToConsole                                As Boolean

' This flag is set when various asynchronous operations are being performed, and
' we' don't want any further user input until we know whether it has succeeded.
Public gInputPaused                                 As Boolean

Public gNumberOfOrdersPlaced                        As Long

Public gPlaceOrdersTask                             As PlaceOrdersTask

Public gBracketOrderListener                        As New BracketOrderListener

Public gCommands                                    As New Commands
Public gCommandListAlways                           As New CommandList
Public gCommandListOrderCreation                    As New CommandList
Public gCommandListOrderSpecification               As New CommandList
Public gCommandListOrderCompletion                  As New CommandList
Public gCommandListGeneral                          As New CommandList


Private mErrorCount                                 As Long

Private mFatalErrorHandler                          As FatalErrorHandler

Private mContractStore                              As IContractStore
Private mMarketDataManager                          As IMarketDataManager

Private mScopeName                                  As String
Private mOrderManager                               As New OrderManager
Private mOrderSubmitterFactory                      As IOrderSubmitterFactory

Private mGroupName                                  As String

Private mStageOrdersDefault                         As Boolean
Private mStageOrders                                As Boolean

Private mContractProcessor                          As ContractProcessor

Private mGroups                                     As New Groups

Private mCommandNumber                              As Long

Private mNextCommands                               As New NextCommands

Private mClp                                        As CommandLineParser

Private mMonitor                                    As Boolean

Private mRecoveryFileDir                            As String

Private mOrderPersistenceDataStore                  As IOrderPersistenceDataStore
Private mOrderRecoveryAgent                         As IOrderRecoveryAgent

Private mConfigStore                                As ConfigurationStore

Private mBatchOrdersDefault                         As Boolean
Private mBatchOrders                                As Boolean

Private mBracketOrderDefinitionInProgress           As Boolean

Private mClientId                                   As Long

'@================================================================================
' Class Event Handlers
'@================================================================================

'@================================================================================
' XXXX Interface Members
'@================================================================================

'@================================================================================
' XXXX Event Handlers
'@================================================================================

'@================================================================================
' Properties
'@================================================================================

Public Property Get gErrorCount() As Long
gErrorCount = mErrorCount
End Property

Public Property Get gLogger() As FormattingLogger
Static sLogger As FormattingLogger
If sLogger Is Nothing Then Set sLogger = CreateFormattingLogger("plord", ProjectName)
Set gLogger = sLogger
End Property

Public Property Get gRegExp() As RegExp
Static lRegexp As RegExp
If lRegexp Is Nothing Then Set lRegexp = New RegExp
Set gRegExp = lRegexp
End Property

'@================================================================================
' Methods
'@================================================================================

Public Function gGenerateContractProcessorName( _
                ByVal pGroupName As String, _
                ByVal pContractSpec As IContractSpecifier) As String
Const PositionManagerNameSeparator As String = "&&"

gGenerateContractProcessorName = UCase$(mGroupName & _
                                        PositionManagerNameSeparator & _
                                        pContractSpec.Key)
End Function

Public Function gGenerateSwitch(ByVal pName As String, ByVal pValue As String) As String
If InStr(1, pValue, " ") <> 0 Then pValue = """" & pValue & """"
gGenerateSwitch = SwitchPrefix & pName & IIf(pValue = "", " ", ValueSeparator & pValue & " ")
End Function

Public Sub gHandleFatalError(ev As ErrorEventData)
On Error Resume Next    ' ignore any further errors that might arise

If gCon Is Nothing Then Exit Sub

gCon.WriteErrorString "Error "
gCon.WriteErrorString CStr(ev.ErrorCode)
gCon.WriteErrorString ": "
gCon.WriteErrorLine ev.ErrorMessage
gCon.WriteErrorLine "At:"
gCon.WriteErrorLine ev.ErrorSource

End Sub

Public Sub gHandleUnexpectedError( _
                ByRef pProcedureName As String, _
                ByRef pModuleName As String, _
                Optional ByRef pFailpoint As String, _
                Optional ByVal pReRaise As Boolean = True, _
                Optional ByVal pLog As Boolean = False, _
                Optional ByVal pErrorNumber As Long, _
                Optional ByRef pErrorDesc As String, _
                Optional ByRef pErrorSource As String)
Dim errSource As String: errSource = IIf(pErrorSource <> "", pErrorSource, Err.Source)
Dim errDesc As String: errDesc = IIf(pErrorDesc <> "", pErrorDesc, Err.Description)
Dim errNum As Long: errNum = IIf(pErrorNumber <> 0, pErrorNumber, Err.Number)

HandleUnexpectedError pProcedureName, ProjectName, pModuleName, pFailpoint, pReRaise, pLog, errNum, errDesc, errSource
End Sub

Public Function gNotifyContractFutureAvailable( _
                ByVal pContractFuture As IFuture) As ContractProcessor
Const ProcName As String = "gNotifyContractAvailable"
On Error GoTo Err

If pContractFuture.IsCancelled Then
    gWriteErrorLine "Contract fetch was cancelled", True
    Exit Function
End If

If pContractFuture.IsFaulted Then
    gWriteErrorLine pContractFuture.ErrorMessage, True
    Exit Function
End If

Assert TypeOf pContractFuture.Value Is IContract, "Unexpected future value"

Dim lContract As IContract
Set lContract = pContractFuture.Value

If IsContractExpired(lContract) Then
    gWriteErrorLine "Contract has expired", True
    Exit Function
End If

' we now have a valid contract, so zero the error count
mErrorCount = 0
    
Dim lContractProcessorName As String
lContractProcessorName = gGenerateContractProcessorName(mGroupName, lContract.Specifier)

Dim lGroupResources As GroupResources
Set lGroupResources = mGroups.Item(mGroupName)

If Not lGroupResources.ContractProcessors.TryItem(lContractProcessorName, mContractProcessor) Then
    Set mContractProcessor = New ContractProcessor
    mContractProcessor.Initialise lContractProcessorName, pContractFuture, mMarketDataManager, mOrderManager, mScopeName, mGroupName, mOrderSubmitterFactory
    lGroupResources.ContractProcessors.Add mContractProcessor, lContractProcessorName
End If

lGroupResources.CurrentContractProcessor = mContractProcessor

Set gNotifyContractFutureAvailable = mContractProcessor

Exit Function

Err:
gHandleUnexpectedError ProcName, ModuleName
End Function

Public Sub gNotifyUnhandledError( _
                ByRef pProcedureName As String, _
                ByRef pModuleName As String, _
                Optional ByRef pFailpoint As String, _
                Optional ByVal pErrorNumber As Long, _
                Optional ByRef pErrorDesc As String, _
                Optional ByRef pErrorSource As String)
Dim errSource As String: errSource = IIf(pErrorSource <> "", pErrorSource, Err.Source)
Dim errDesc As String: errDesc = IIf(pErrorDesc <> "", pErrorDesc, Err.Description)
Dim errNum As Long: errNum = IIf(pErrorNumber <> 0, pErrorNumber, Err.Number)

UnhandledErrorHandler.Notify pProcedureName, pModuleName, ProjectName, pFailpoint, errNum, errDesc, errSource
End Sub

Public Sub gSetValidNextCommands(ParamArray values() As Variant)
ReDim lCommandLists(UBound(values)) As CommandList
Dim i As Long
For i = 0 To UBound(values)
    Set lCommandLists(i) = values(i)
Next
mNextCommands.SetValidNextCommandLists lCommandLists
End Sub

Public Sub gWriteErrorLine( _
                ByVal pMessage As String, _
                Optional ByVal pDontIncrementErrorCount As Boolean = False)
Const ProcName As String = "gWriteErrorLine"

Dim s As String
s = "Error: " & pMessage
gCon.WriteErrorLine s
LogMessage "StdErr: " & s
If Not pDontIncrementErrorCount Then mErrorCount = mErrorCount + 1
End Sub

Public Sub gWriteLineToConsole(ByVal pMessage As String, Optional ByVal pLogit As Boolean)
Const ProcName As String = "gWriteLineToConsole"

If pLogit Then LogMessage "Con: " & pMessage
gCon.WriteLineToConsole pMessage
End Sub

Public Sub gWriteLineToStdOut(ByVal pMessage As String)
Const ProcName As String = "gWriteLineToStdOut"

LogMessage "StdOut: " & pMessage
gCon.WriteLine pMessage
End Sub

Public Sub Main()
Const ProcName As String = "Main"
On Error GoTo Err

Set gCon = GetConsole

If Trim$(Command) = "/?" Or Trim$(Command) = "-?" Then
    showUsage
    Exit Sub
End If

InitialiseTWUtilities

Set mFatalErrorHandler = New FatalErrorHandler
ApplicationGroupName = "TradeWright"
ApplicationName = "plord"
SetupDefaultLogging Command, True, True

Set mConfigStore = gGetConfigStore

logProgramId

setupCommandLists

Set mGroups = New Groups

Set gPlaceOrdersTask = New PlaceOrdersTask
gPlaceOrdersTask.Initialise mGroups
StartTask gPlaceOrdersTask, PriorityNormal

Set mClp = CreateCommandLineParser(Command)

Dim lLogApiMessages As ApiMessageLoggingOptions
Dim lLogRawApiMessages As ApiMessageLoggingOptions
Dim lLogApiMessageStats As Boolean
If Not validateApiMessageLogging( _
                mClp.SwitchValue(ApiMessageLoggingSwitch), _
                lLogApiMessages, _
                lLogRawApiMessages, _
                lLogApiMessageStats) Then
    gWriteLineToConsole "API message logging setting is invalid", True
    Exit Sub
End If

If Not setupTwsApi(mClp.SwitchValue(TwsSwitch), _
                mClp.Switch(SimulateOrdersSwitch), _
                lLogApiMessages, _
                lLogRawApiMessages, _
                lLogApiMessageStats) Then
    showUsage
    Exit Sub
End If

process

Exit Sub

Err:
gNotifyUnhandledError ProcName, ModuleName
End Sub

'@================================================================================
' Helper Functions
'@================================================================================

Private Function getContractName(ByVal pContract As IContract) As String
AssertArgument Not pContract Is Nothing
getContractName = pContract.Specifier.LocalSymbol & "@" & pContract.Specifier.Exchange
End Function

Private Function getInputLine() As String
Const ProcName As String = "getInputLine"
On Error GoTo Err

Do While gInputPaused
    Wait 20
Loop
getInputLine = Trim$(gCon.ReadLine(getPrompt))

Exit Function

Err:
gHandleUnexpectedError ProcName, ModuleName
End Function

Private Function getNumberOfUnprocessedOrders() As Long
Const ProcName As String = "getNumberOfUnprocessedOrders"
On Error GoTo Err

Dim lProcessor As ContractProcessor
Dim lGroupResources As GroupResources
For Each lGroupResources In mGroups
    For Each lProcessor In lGroupResources.ContractProcessors
        getNumberOfUnprocessedOrders = getNumberOfUnprocessedOrders + lProcessor.BracketOrders.Count
    Next
Next

Exit Function

Err:
gHandleUnexpectedError ProcName, ModuleName
End Function

Private Function getPrompt() As String
If mContractProcessor Is Nothing Then
    getPrompt = mGroupName & DefaultPrompt
ElseIf mContractProcessor.Contract Is Nothing Then
    getPrompt = mGroupName & DefaultPrompt
Else
    getPrompt = mGroupName & "!" & _
                getContractName(mContractProcessor.Contract) & _
                DefaultPrompt
End If
End Function

Private Function isGroupValid(ByVal pGroup As String) As Boolean
Const ProcName As String = "isGroupValid"
On Error GoTo Err

gRegExp.Global = True
gRegExp.Pattern = "^(\$|[a-zA-Z0-9][\w-]*)$"
isGroupValid = gRegExp.Test(pGroup)

Exit Function

Err:
gHandleUnexpectedError ProcName, ModuleName
End Function

Private Sub listGroups()
Const ProcName As String = "listGroups"
On Error GoTo Err

Dim lRes As GroupResources
For Each lRes In mGroups
    Dim lGroupName As String: lGroupName = lRes.GroupName
    Dim lContractProcessor As ContractProcessor
    Set lContractProcessor = lRes.CurrentContractProcessor
    
    Dim lContractName As String
    If lContractProcessor Is Nothing Then
        lContractName = ""
    Else
        lContractName = getContractName(lContractProcessor.Contract)
    End If
    gWriteLineToConsole IIf(lGroupName = UCase$(mGroupName), "* ", "  ") & _
                        padStringRight(lGroupName, 20) & _
                        padStringRight(lContractName, 25), _
                        True
Next

Exit Sub

Err:
gHandleUnexpectedError ProcName, ModuleName
End Sub

Private Sub listPositions()
Const ProcName As String = "listPositions"
On Error GoTo Err

Dim lPM As PositionManager
For Each lPM In mOrderManager.PositionManagersLive
    Dim lContract As IContract
    Set lContract = lPM.ContractFuture.Value
    gWriteLineToConsole padStringRight(lPM.GroupName, 15) & " " & _
                        padStringRight(getContractName(lContract), 30) & _
                        " Size=" & padStringleft(lPM.PositionSize & _
                                                "(" & lPM.PendingBuyPositionSize & _
                                                "/" & _
                                                lPM.PendingSellPositionSize & ")", 10) & _
                        " Profit=" & padStringleft(Format(lPM.Profit, "0.00"), 9), _
                        True
Next

Exit Sub

Err:
gHandleUnexpectedError ProcName, ModuleName
End Sub

Private Sub listTrades()
Const ProcName As String = "listTrades"
On Error GoTo Err

Dim lPM As PositionManager
For Each lPM In mOrderManager.PositionManagersLive
    Dim lContract As IContract
    Set lContract = lPM.ContractFuture.Value
    gWriteLineToConsole padStringRight(lPM.GroupName, 15) & " " & _
                        padStringRight(getContractName(lContract), 30), _
                        True
    
    Dim lTrade As Execution
    For Each lTrade In lPM.Executions
        gWriteLineToConsole "  " & FormatTimestamp(lTrade.FillTime, TimestampDateAndTimeISO8601 + TimestampNoMillisecs) & " " & _
                        padStringRight(IIf(lTrade.Action = OrderActionBuy, "BUY", "SELL"), 5) & _
                        padStringleft(lTrade.Quantity, 5) & _
                        padStringleft(FormatPrice(lTrade.Price, lContract.Specifier.SecType, lContract.TickSize), 9) & _
                        padStringRight(" " & lTrade.FillingExchange, 10) & _
                        " " & lTrade.TimezoneName, _
        True
    Next
Next


Exit Sub

Err:
gHandleUnexpectedError ProcName, ModuleName
End Sub

Private Sub logProgramId()
Const ProcName As String = "logProgramId"
On Error GoTo Err

Dim s As String
s = App.ProductName & " V" & App.Major & "." & App.Minor & "." & App.Revision & vbCrLf & _
    App.LegalCopyright
gWriteLineToConsole s, False
s = s & vbCrLf & "Arguments: " & Command
LogMessage s

Exit Sub

Err:
gHandleUnexpectedError ProcName, ModuleName
End Sub

Public Function padStringRight(ByVal pInput As String, ByVal pLength As Long) As String
pInput = Left$(pInput, pLength)
padStringRight = pInput & Space$(pLength - Len(pInput))
End Function

Public Function padStringleft(ByVal pInput As String, ByVal pLength As Long) As String
pInput = Right$(pInput, pLength)
padStringleft = Space$(pLength - Len(pInput)) & pInput
End Function

Private Function parseContractSpec( _
                ByVal pClp As CommandLineParser) As IContractSpecifier
Const ProcName As String = "parseContractSpec"
On Error GoTo Err

If pClp.Arg(0) = "?" Or _
    pClp.Switch("?") Or _
    (pClp.Arg(0) = "" And pClp.NumberOfSwitches = 0) _
Then
    showContractHelp
    Exit Function
End If

Dim validParams As Boolean
validParams = True

Dim lSectypeStr As String: lSectypeStr = pClp.SwitchValue(SecTypeSwitch)
If lSectypeStr = "" Then lSectypeStr = pClp.SwitchValue(SecTypeSwitch1)

Dim lExchange As String: lExchange = pClp.SwitchValue(ExchangeSwitch)
If lExchange = "" Then lExchange = pClp.SwitchValue(ExchangeSwitch1)

Dim lLocalSymbol As String: lLocalSymbol = pClp.SwitchValue(LocalSymbolSwitch)
If lLocalSymbol = "" Then lLocalSymbol = pClp.SwitchValue(LocalSymbolSwitch1)

Dim lSymbol As String: lSymbol = pClp.SwitchValue(SymbolSwitch)
If lSymbol = "" Then lSymbol = pClp.SwitchValue(SymbolSwitch1)

Dim lCurrency As String: lCurrency = pClp.SwitchValue(CurrencySwitch)
If lCurrency = "" Then lCurrency = pClp.SwitchValue(CurrencySwitch1)

Dim lExpiry As String: lExpiry = pClp.SwitchValue(ExpirySwitch)
If lExpiry = "" Then lExpiry = pClp.SwitchValue(ExpirySwitch1)

Dim lMultiplier As String: lMultiplier = pClp.SwitchValue(MultiplierSwitch)
If lMultiplier = "" Then lMultiplier = pClp.SwitchValue(MultiplierSwitch1)
If lMultiplier = "" Then lMultiplier = "1.0"

Dim lStrike As String: lStrike = pClp.SwitchValue(StrikeSwitch)
If lStrike = "" Then lStrike = pClp.SwitchValue(StrikeSwitch1)
If lStrike = "" Then lStrike = "0.0"

Dim lRight As String: lRight = pClp.SwitchValue(RightSwitch)

Dim lSectype As SecurityTypes
lSectype = SecTypeFromString(lSectypeStr)
If lSectypeStr <> "" And lSectype = SecTypeNone Then
    gWriteErrorLine "Invalid Sectype '" & lSectypeStr & "'"
    validParams = False
End If

If lExpiry <> "" Then
    If IsInteger(lExpiry, 0, MaxContractExpiryOffset) Then
    ElseIf IsDate(lExpiry) Then
        lExpiry = Format(CDate(lExpiry), "yyyymmdd")
    ElseIf Len(lExpiry) = 6 Then
        If Not IsDate(Left$(lExpiry, 4) & "/" & Right$(lExpiry, 2) & "/01") Then
            gWriteErrorLine "Invalid Expiry '" & lExpiry & "'"
            validParams = False
        End If
    ElseIf Len(lExpiry) = 8 Then
        If Not IsDate(Left$(lExpiry, 4) & "/" & Mid$(lExpiry, 5, 2) & "/" & Right$(lExpiry, 2)) Then
            gWriteErrorLine "Invalid Expiry '" & lExpiry & "'"
            validParams = False
        End If
    Else
        gWriteErrorLine "Invalid Expiry '" & lExpiry & "'"
        validParams = False
    End If
End If
            
Dim Multiplier As Double
If lMultiplier = "" Then
    Multiplier = 1#
ElseIf IsNumeric(lMultiplier) Then
    Multiplier = CDbl(lMultiplier)
Else
    gWriteErrorLine "Invalid multiplier '" & lMultiplier & "'"
    validParams = False
End If
            
Dim Strike As Double
If lStrike <> "" Then
    If IsNumeric(lStrike) Then
        Strike = CDbl(lStrike)
    Else
        gWriteErrorLine "Invalid strike '" & lStrike & "'"
        validParams = False
    End If
End If

Dim optRight As OptionRights
optRight = OptionRightFromString(lRight)
If lRight <> "" And optRight = OptNone Then
    gWriteErrorLine "Invalid right '" & lRight & "'"
    validParams = False
End If

        
If validParams Then
    Set parseContractSpec = CreateContractSpecifier(lLocalSymbol, _
                                            lSymbol, _
                                            lExchange, _
                                            lSectype, _
                                            lCurrency, _
                                            lExpiry, _
                                            Multiplier, _
                                            Strike, _
                                            optRight)
End If

Exit Function

Err:
If Err.Number = ErrorCodes.ErrIllegalArgumentException Then
    gWriteErrorLine Err.Description
Else
    gHandleUnexpectedError ProcName, ModuleName
End If
End Function

Private Function parseLegacyCloseoutCommand( _
                ByVal pParams As String, _
                ByRef pGroupName As String, _
                ByRef pCloseoutMode As CloseoutModes, _
                ByRef pPriceSspec As PriceSpecifier) As Boolean
Const ProcName As String = "parseLegacyCloseoutCommand"
On Error GoTo Err

gRegExp.Global = False
gRegExp.IgnoreCase = True

Dim p As String: p = _
    "(?:" & _
        "^" & _
        "(?!mkt)(?!lmt)" & _
        "(?:" & _
            "(?: *)|(all|\$)|([a-zA-Z0-9][\w-]*)" & _
        ")" & _
        "(?:" & _
            " +" & _
            "(?:" & _
                "(mkt)|" & _
                "(?:" & _
                    "(lmt)" & _
                    "(?:" & _
                        ":(-)?(\d{1,3})" & _
                    ")?" & _
                ")" & _
            ")" & _
        ")?" & _
        "$" & _
    ")" & _
    "|"
p = p & _
    "(?:" & _
        "^" & _
        " *" & _
        "(?:" & _
            "(mkt)|" & _
            "(?:" & _
                "(lmt)" & _
                "(?:" & _
                    ":(-)?(\d{1,3})" & _
                ")?" & _
            ")" & _
        ")" & _
        "$" & _
    ")"
gRegExp.Pattern = p

Dim lMatches As MatchCollection
Set lMatches = gRegExp.Execute(Trim$(pParams))

If lMatches.Count <> 1 Then
    Exit Function
End If

Dim lMatch As Match: Set lMatch = lMatches(0)


If lMatch.SubMatches(0) = AllGroups Then
    pGroupName = AllGroups
ElseIf lMatch.SubMatches(1) = DefaultGroupName Then
    pGroupName = DefaultGroupName
Else
    pGroupName = UCase$(lMatch.SubMatches(1))
End If
    
Dim lUseLimitOrders As Boolean: lUseLimitOrders = (UCase$(lMatch.SubMatches(3)) = CloseoutLimit Or _
                                                    UCase$(lMatch.SubMatches(7)) = CloseoutLimit)
If lUseLimitOrders Then
    pCloseoutMode = CloseoutModeLimit
Else
    pCloseoutMode = CloseoutModeMarket
End If

Dim lSpreadFactorSign As Long: lSpreadFactorSign = IIf(lMatch.SubMatches(4) = "-" Or lMatch.SubMatches(8) = "-", -1, 1)

Dim lSpreadFactor As Long
If lMatch.SubMatches(5) <> "" Then
    lSpreadFactor = lMatch.SubMatches(5) * lSpreadFactorSign
ElseIf lMatch.SubMatches(9) <> "" Then
    lSpreadFactor = lMatch.SubMatches(9) * lSpreadFactorSign
End If

Set pPriceSspec = NewPriceSpecifier(pPriceType:=PriceValueTypeBidOrAsk, _
                                    pOffset:=lSpreadFactor, _
                                    pOffsetType:=PriceOffsetTypeBidAskPercent)

parseLegacyCloseoutCommand = True

Exit Function

Err:
If Err.Number = ErrorCodes.ErrIllegalArgumentException Then
    gWriteErrorLine Err.Description, True
    Exit Function
End If
gHandleUnexpectedError ProcName, ModuleName
End Function

Private Sub process()
Const ProcName As String = "process"
On Error GoTo Err

If Not setMonitor Then Exit Sub
If Not setStageOrders Then Exit Sub
If Not setBatchOrders Then Exit Sub

setOrderRecovery

gSetValidNextCommands gCommandListAlways, _
                    gCommandListGeneral, _
                    gCommandListOrderCreation

Dim inString As String: inString = getInputLine

Do While inString <> gCon.EofString
    If inString = "" Then
        ' ignore blank lines - and don't write to the log because
        ' the FileAutoReader program sends blank lines very frequently
    ElseIf Left$(inString, 1) = "#" Then
        ' ignore comments except log and write to console
        LogMessage "StdIn: " & inString
        gWriteLineToConsole inString
    Else
        LogMessage "StdIn: " & inString
        If Not processCommand(inString) Then Exit Do
    End If
    
    inString = getInputLine
Loop

If Not mOrderPersistenceDataStore Is Nothing Then mOrderPersistenceDataStore.Finish
Set mOrderPersistenceDataStore = Nothing

gWriteLineToConsole "Exiting", True

Exit Sub

Err:
gHandleUnexpectedError ProcName, ModuleName
End Sub

Private Function processCommand(ByVal pInstring As String) As Boolean
Const ProcName As String = "processCommand"
On Error GoTo Err

Dim lCommandName As String
lCommandName = UCase$(Split(pInstring, " ")(0))

Dim Params As String
Params = Trim$(Right$(pInstring, Len(pInstring) - Len(lCommandName)))

Dim lCommand As Command
Set lCommand = gCommands.ParseCommand(lCommandName)

If lCommand Is gCommands.ExitCommand Then
    processCommand = False
    Exit Function
End If

If lCommand Is gCommands.Help1Command Then
    gCon.WriteLine "Valid commands at this point are: " & mNextCommands.ValidCommandNames
ElseIf lCommand Is gCommands.HelpCommand Then
    showStdInHelp
ElseIf Not mNextCommands.IsCommandValid(lCommand) Then
    gWriteErrorLine "Valid commands at this point are: " & mNextCommands.ValidCommandNames, Not mBracketOrderDefinitionInProgress
ElseIf lCommand Is gCommands.ContractCommand Then
    processContractCommand Params
ElseIf lCommand Is gCommands.BatchOrdersCommand Then
    processBatchOrdersCommand Params
ElseIf lCommand Is gCommands.StageOrdersCommand Then
    processStageOrdersCommand Params
ElseIf lCommand Is gCommands.GroupCommand Then
    processGroupCommand Params
ElseIf lCommand Is gCommands.BuyCommand Then
    setupResultsLogging mClp
    ProcessBuyCommand Params
ElseIf lCommand Is gCommands.BuyAgainCommand Then
    ProcessBuyAgainCommand Params
ElseIf lCommand Is gCommands.SellCommand Then
    setupResultsLogging mClp
    ProcessSellCommand Params
ElseIf lCommand Is gCommands.SellAgainCommand Then
    ProcessSellAgainCommand Params
ElseIf lCommand Is gCommands.BracketCommand Then
    mBracketOrderDefinitionInProgress = True
    mContractProcessor.ProcessBracketCommand Params
ElseIf lCommand Is gCommands.EntryCommand Then
    mContractProcessor.ProcessEntryCommand Params
ElseIf lCommand Is gCommands.StopLossCommand Then
    mContractProcessor.ProcessStopLossCommand Params
ElseIf lCommand Is gCommands.TargetCommand Then
    mContractProcessor.ProcessTargetCommand Params
ElseIf lCommand Is gCommands.QuitCommand Then
    mContractProcessor.ProcessQuitCommand
    mErrorCount = 0
ElseIf lCommand Is gCommands.EndBracketCommand Then
    mBracketOrderDefinitionInProgress = False
    mContractProcessor.ProcessEndBracketCommand
    If mErrorCount = 0 And Not mBatchOrders Then
        setupResultsLogging mClp
        processOrders
    Else
        gWriteLineToConsole mErrorCount & " errors have been found - order will not be placed", True
        mErrorCount = 0
    End If
ElseIf lCommand Is gCommands.EndOrdersCommand Then
    gWriteLineToStdOut lCommandName
    processEndOrdersCommand
ElseIf lCommand Is gCommands.ResetCommand Then
    processResetCommand
ElseIf lCommand Is gCommands.ListCommand Then
    processListCommand Params
ElseIf lCommand Is gCommands.CloseoutCommand Then
    setupResultsLogging mClp
    processCloseoutCommand Params
ElseIf lCommand Is gCommands.QuoteCommand Then
    processQuoteCommand Params
ElseIf lCommand Is gCommands.PurgeCommand Then
    processPurgeCommand Params
Else
    gWriteErrorLine "Invalid command '" & Command & "'", True
End If

processCommand = True

Exit Function

Err:
gHandleUnexpectedError ProcName, ModuleName
End Function

Private Sub processBatchOrdersCommand( _
                ByVal pParams As String)
Select Case UCase$(pParams)
Case Default
    mBatchOrders = mBatchOrdersDefault
Case Yes
    mBatchOrders = True
Case No
    mBatchOrders = False
Case Else
    gWriteErrorLine gCommands.BatchOrdersCommand.Name & " parameter must be either YES or NO or DEFAULT", True
End Select
End Sub

Private Sub ProcessBuyCommand( _
                ByVal pParams As String)
Const ProcName As String = "processBuyCommand"
On Error GoTo Err

processBuyOrSellCommand OrderActionBuy, pParams

Exit Sub

Err:
gHandleUnexpectedError ProcName, ModuleName
End Sub

Private Sub ProcessBuyAgainCommand( _
                ByVal pParams As String)
Const ProcName As String = "ProcessBuyAgainCommand"
On Error GoTo Err

If mContractProcessor Is Nothing Then
    gWriteErrorLine "No Buy command to repeat", True
ElseIf mContractProcessor.LatestBuyCommandParams = "" Then
    gWriteErrorLine "No Buy command to repeat", True
Else
    ProcessBuyCommand mContractProcessor.LatestBuyCommandParams
End If

Exit Sub

Err:
gHandleUnexpectedError ProcName, ModuleName
End Sub

Private Sub processBuyOrSellCommand( _
                ByVal pAction As OrderActions, _
                ByVal pParams As String)
Const ProcName As String = "processBuyOrSellCommand"
On Error GoTo Err

Dim lClp As CommandLineParser: Set lClp = CreateCommandLineParser(pParams)
Dim lArg0 As String: lArg0 = lClp.Arg(0)

If Not IsInteger(lArg0, 1) Then
    ' the first arg is a contract spec
    Dim lContractSpec As IContractSpecifier
    Set lContractSpec = CreateContractSpecifierFromString(lArg0)

    If lContractSpec Is Nothing Then Exit Sub
    
    Dim lData As New BuySellCommandData
    lData.Action = pAction
    lData.Params = Right$(pParams, Len(pParams) - Len(lArg0))
    lData.StageOrders = mStageOrders
    
    Dim lResolver As New ContractResolver
    lResolver.Initialise lContractSpec, mContractStore, lData, mBatchOrders
    
    gInputPaused = True
ElseIf Not mContractProcessor Is Nothing Then
    If pAction = OrderActionBuy Then
        If mContractProcessor.ProcessBuyCommand(pParams) And Not mBatchOrders Then processOrders
    Else
        If mContractProcessor.ProcessSellCommand(pParams) And Not mBatchOrders Then processOrders
    End If
Else
    gWriteErrorLine "No contract has been specified in this group", True
End If

Exit Sub

Err:
gHandleUnexpectedError ProcName, ModuleName
End Sub

Private Sub ProcessSellCommand( _
                ByVal pParams As String)
Const ProcName As String = "processBuyCommand"
On Error GoTo Err

processBuyOrSellCommand OrderActionSell, pParams

Exit Sub

Err:
gHandleUnexpectedError ProcName, ModuleName
End Sub

Private Sub ProcessSellAgainCommand( _
                ByVal pParams As String)
Const ProcName As String = "ProcessSellAgainCommand"
On Error GoTo Err

If mContractProcessor Is Nothing Then
    gWriteErrorLine "No Sell command to repeat", True
ElseIf mContractProcessor.LatestSellCommandParams = "" Then
    gWriteErrorLine "No Sell command to repeat", True
Else
    ProcessSellCommand mContractProcessor.LatestSellCommandParams
End If

Exit Sub

Err:
gHandleUnexpectedError ProcName, ModuleName
End Sub

Private Sub processCloseoutCommand( _
                ByVal pParams As String)
Const ProcName As String = "processCloseoutCommand"
On Error GoTo Err

Dim lLimitOrder As String: lLimitOrder = OrderTypeToShortString(OrderTypeLimit)
Dim lMarketOrder As String: lMarketOrder = OrderTypeToShortString(OrderTypeMarket)

Dim lClp As CommandLineParser: Set lClp = CreateCommandLineParser(pParams)

Dim lGroupName As String
Dim lOrderTypeName As String
Dim lPriceStr As String

Dim lCloseoutMode As CloseoutModes
Dim lPriceSpec As PriceSpecifier

Dim lError As Boolean

If lClp.NumberOfArgs = 3 Then
    lGroupName = lClp.Arg(0)
    lPriceStr = lClp.Arg(2)
    lOrderTypeName = UCase$(lClp.Arg(1))
    If lOrderTypeName = lMarketOrder Then
        lCloseoutMode = CloseoutModeMarket
    ElseIf lOrderTypeName = lLimitOrder Then
        lCloseoutMode = CloseoutModeLimit
    Else
        lError = True
        gWriteErrorLine "Second argument must be either 'MKT' or 'LMT'", True
    End If
ElseIf lClp.NumberOfArgs = 2 Then
    lOrderTypeName = UCase$(lClp.Arg(0))
    If lOrderTypeName = lLimitOrder Then
        lCloseoutMode = CloseoutModeLimit
        lPriceStr = lClp.Arg(1)
    ElseIf lOrderTypeName = lMarketOrder Then
        lCloseoutMode = CloseoutModeMarket
        lPriceStr = lClp.Arg(1)
    ElseIf isGroupValid(lClp.Arg(0)) Then
        lGroupName = lClp.Arg(0)
        lOrderTypeName = UCase$(lClp.Arg(1))
        If lOrderTypeName = lMarketOrder Then
            lCloseoutMode = CloseoutModeMarket
        ElseIf Not parseLegacyCloseoutCommand(pParams, lGroupName, lCloseoutMode, lPriceSpec) Then
            lError = True
            gWriteErrorLine "Syntax error", True
        End If
    ElseIf Not parseLegacyCloseoutCommand(pParams, lGroupName, lCloseoutMode, lPriceSpec) Then
        lError = True
        gWriteErrorLine "Syntax error", True
    End If
ElseIf lClp.NumberOfArgs = 1 Then
    lOrderTypeName = UCase$(lClp.Arg(0))
    If lOrderTypeName = lMarketOrder Then
        lCloseoutMode = CloseoutModeMarket
    ElseIf lOrderTypeName = lLimitOrder Then
        If Not parseLegacyCloseoutCommand(pParams, lGroupName, lCloseoutMode, lPriceSpec) Then
            lError = True
            gWriteErrorLine "Closeout price specification is missing", True
        End If
    ElseIf isGroupValid(lClp.Arg(0)) Then
        lGroupName = lClp.Arg(0)
    ElseIf Not parseLegacyCloseoutCommand(pParams, lGroupName, lCloseoutMode, lPriceSpec) Then
        lError = True
        gWriteErrorLine "Syntax error"
    End If
ElseIf lClp.NumberOfArgs = 0 Then
    lCloseoutMode = CloseoutModeMarket
Else
    lError = True
    gWriteErrorLine "Too many arguments", True
End If

If lGroupName = "" Then
    lGroupName = mGroupName
ElseIf lGroupName <> AllGroups And lGroupName <> DefaultGroupName Then
    If Not isGroupValid(lGroupName) Then
        lError = True
        gWriteErrorLine lGroupName & " is not a valid group name", True
    ElseIf Not mGroups.Contains(lGroupName) Then
        lError = True
        gWriteErrorLine "No such group", True
    End If
End If

If lCloseoutMode = CloseoutModeMarket Then
    If lPriceStr <> "" Then
        lError = True
        gWriteErrorLine "A price specification cannot be supplied for closeout at market"
    End If
ElseIf lPriceStr = "" And lPriceSpec Is Nothing Then
    lError = True
    gWriteErrorLine "Closeout price specification is missing", True
ElseIf Not lPriceSpec Is Nothing Then
ElseIf Not ParsePriceAndOffset(lPriceSpec, lPriceStr, SecTypeNone, 0#, True) Then
    lError = True
    gWriteErrorLine "Invalid price specification", True
End If

If lError Then Exit Sub

Dim lCloseoutProcessor As New CloseoutProcessor
lCloseoutProcessor.Initialise mOrderManager, lCloseoutMode, lPriceSpec

If lGroupName = AllGroups Then
    lCloseoutProcessor.CloseoutAll
ElseIf Not mGroups.Contains(lGroupName) Then
    gWriteErrorLine "No such group", True
Else
    lCloseoutProcessor.CloseoutGroup lGroupName
End If

Exit Sub

Err:
If Err.Number = ErrorCodes.ErrIllegalArgumentException Then
    gWriteErrorLine Err.Description, True
    Exit Sub
End If
gHandleUnexpectedError ProcName, ModuleName
End Sub

Private Sub processContractCommand(ByVal pParams As String)
Const ProcName As String = "processContractCommand"
On Error GoTo Err

If pParams = "" Then Exit Sub

pParams = UCase$(pParams)
If gCommands.HelpCommand.parse(pParams) Or gCommands.Help1Command.parse(pParams) Then
    showContractHelp
    Exit Sub
End If

Dim lClp As CommandLineParser
Set lClp = CreateCommandLineParser(pParams, " ")

Dim lSpecString As String
lSpecString = lClp.Arg(0)

Dim lContractSpec As IContractSpecifier
If lSpecString <> "" Then
    Set lContractSpec = CreateContractSpecifierFromString(lSpecString)
Else
    Set lContractSpec = parseContractSpec(lClp)
End If

If lContractSpec Is Nothing Then
    If Not mContractProcessor Is Nothing Then
        gSetValidNextCommands gCommandListAlways, gCommandListGeneral, gCommandListOrderCreation
    Else
        gSetValidNextCommands gCommandListAlways, gCommandListGeneral
    End If
    Exit Sub
End If

Dim lResolver As New ContractResolver
lResolver.Initialise lContractSpec, mContractStore, Nothing, mBatchOrders

gInputPaused = True

Exit Sub

Err:
If Err.Number = ErrorCodes.ErrIllegalArgumentException Then
    gWriteErrorLine Err.Description, True
Else
    gHandleUnexpectedError ProcName, ModuleName
End If
End Sub

Private Sub processEndOrdersCommand()
Const ProcName As String = "processEndOrdersCommand"
On Error GoTo Err

If mErrorCount <> 0 Then
    gWriteLineToConsole mErrorCount & " errors have been found - no orders will be placed", True
    mErrorCount = 0
    gSetValidNextCommands gCommandListAlways, gCommandListGeneral, gCommandListOrderCreation
    Exit Sub
End If

If getNumberOfUnprocessedOrders = 0 Then
    gWriteLineToConsole "No orders have been defined", True
    Exit Sub
End If

processOrders

Exit Sub

Err:
gHandleUnexpectedError ProcName, ModuleName
End Sub

Private Sub processGroupCommand( _
                ByVal pParams As String)
Dim lClp As CommandLineParser: Set lClp = CreateCommandLineParser(pParams)
Dim lGroupName As String: lGroupName = lClp.Arg(0)
If lGroupName = "" Or lGroupName = DefaultGroupName Then
    mGroupName = DefaultGroupName
ElseIf Not isGroupValid(lGroupName) Then
    gWriteErrorLine "Invalid group name: first character must be letter or digit; remaining characters must be letter, digit, hyphen or underscore", True
    Exit Sub
Else
    mGroupName = lGroupName
End If

Dim lResources As GroupResources
If mGroups.TryItem(UCase$(mGroupName), lResources) Then
    Set mContractProcessor = lResources.CurrentContractProcessor
    mGroupName = lResources.GroupName
Else
    Dim lPMs As PositionManagers: Set lPMs = mOrderManager.GetPositionManagersForGroup(mGroupName)
    
    ' get the 'canonical' group name spelling
    If lPMs.Count <> 0 Then
        Dim en As Enumerator: Set en = lPMs.Enumerator
        en.MoveNext
        Dim lPM As PositionManager: Set lPM = en.Current
        mGroupName = lPM.GroupName
    End If
    mGroups.Add mGroupName
    Set mContractProcessor = Nothing
End If

If lClp.NumberOfArgs > 1 Or lClp.NumberOfSwitches > 0 Then
    Dim lContractArgs As String
    lContractArgs = Trim$(Right$(pParams, Len(pParams) - InStr(1, pParams, " ")))
    processContractCommand lContractArgs
End If

If Not mContractProcessor Is Nothing Then
    gSetValidNextCommands gCommandListAlways, gCommandListGeneral, gCommandListOrderCreation
Else
    gSetValidNextCommands gCommandListAlways, gCommandListGeneral
End If
End Sub

Private Sub processOrders()
Const ProcName As String = "processOrders"
On Error GoTo Err

' To avoid exceeding the API's input message limits, we process orders
' asynchronously with a task

gPlaceOrdersTask.AddContractProcessors mGroups.Item(mGroupName).ContractProcessors, mStageOrders

gSetValidNextCommands gCommandListAlways, gCommandListGeneral, gCommandListOrderCreation

Exit Sub

Err:
gHandleUnexpectedError ProcName, ModuleName
End Sub

Private Sub processListCommand( _
                ByVal pParams As String)
Const ProcName As String = "processListCommand"
On Error GoTo Err

If UCase$(pParams) = GroupsSubcommand Then
    listGroups
ElseIf UCase$(pParams) = PositionsSubcommand Then
    listPositions
ElseIf UCase$(pParams) = TradesSubcommand Then
    listTrades
Else
    gWriteErrorLine gCommands.ListCommand.Name & " parameter must be one of " & GroupsSubcommand & ", " & PositionsSubcommand & " or " & TradesSubcommand, True
End If

Exit Sub

Err:
gHandleUnexpectedError ProcName, ModuleName
End Sub

Private Sub processPurgeCommand( _
                ByVal pParams As String)
Const ProcName As String = "processPurgeCommand"
On Error GoTo Err

Dim lRes As GroupResources

If pParams = "" Then
    gWriteLineToConsole "Purging " & mGroupName
    Set mContractProcessor = Nothing
    purgeGroup mGroupName
    mGroups.Remove mGroupName
    mGroupName = DefaultGroupName
ElseIf UCase$(pParams) = AllGroups Then
    For Each lRes In mGroups
        Dim lGroupName As String: lGroupName = lRes.GroupName
        gWriteLineToConsole "Purging " & lGroupName
        purgeGroup lGroupName
        If lGroupName = mGroupName Then
            mGroupName = DefaultGroupName
            Set mContractProcessor = Nothing
        End If
    Next
    mGroups.Clear
ElseIf isGroupValid(pParams) Then
    If Not mGroups.TryItem(pParams, lRes) Then
        gWriteErrorLine "No such group", True
        Exit Sub
    End If
    gWriteLineToConsole "Purging " & lRes.GroupName
    purgeGroup pParams
    mGroups.Remove pParams
    If UCase$(pParams) = UCase$(mGroupName) Then
        mGroupName = DefaultGroupName
        Set mContractProcessor = Nothing
    End If
Else
    gWriteErrorLine "Invalid group name", True
    Exit Sub
End If

mGroups.Add DefaultGroupName

Exit Sub

Err:
gHandleUnexpectedError ProcName, ModuleName
End Sub

Private Sub processQuoteCommand(ByVal pParams As String)
Const ProcName As String = "processQuoteCommand"
On Error GoTo Err

If pParams = "" Then
    If Not mContractProcessor Is Nothing Then
        gWriteLineToConsole mContractProcessor.ContractName & _
                            ": " & _
                            GetCurrentTickSummary(mContractProcessor.DataSource)
    Else
        gWriteLineToConsole "No current contract"
    End If
Else
    Dim lClp As CommandLineParser
    Set lClp = CreateCommandLineParser(pParams, " ")
    
    Dim lSpecString As String: lSpecString = lClp.Arg(0)
    
    Dim lContractSpec As IContractSpecifier
    If lSpecString <> "" Then
        Set lContractSpec = CreateContractSpecifierFromString(lSpecString)
    Else
        Set lContractSpec = parseContractSpec(lClp)
    End If
    If lContractSpec Is Nothing Then Exit Sub
    
    Dim lQuoteFetcher As New QuoteFetcher
    lQuoteFetcher.FetchQuote lContractSpec, mContractStore, mMarketDataManager
End If

Exit Sub

Err:
If Err.Number = ErrorCodes.ErrIllegalArgumentException Then
    gWriteErrorLine Err.Description, True
Else
    gHandleUnexpectedError ProcName, ModuleName
End If
End Sub

Private Sub processResetCommand()
Set mContractProcessor = Nothing
mStageOrders = mStageOrdersDefault
mBatchOrders = mBatchOrdersDefault
mErrorCount = 0
gSetValidNextCommands gCommandListAlways, gCommandListGeneral
End Sub

Private Sub processStageOrdersCommand( _
                ByVal pParams As String)
Select Case UCase$(pParams)
Case Default
    mStageOrders = mStageOrdersDefault
Case Yes
    If Not (mOrderSubmitterFactory.Capabilities And OrderSubmitterCapabilityCanStageOrders) = OrderSubmitterCapabilityCanStageOrders Then
        gWriteErrorLine gCommands.StageOrdersCommand.Name & " parameter cannot be YES with current configuration", True
        Exit Sub
    End If
    mStageOrders = True
Case No
    mStageOrders = False
Case Else
    gWriteErrorLine gCommands.StageOrdersCommand.Name & " parameter must be either YES or NO or DEFAULT", True
End Select

If mContractProcessor Is Nothing Then
    gSetValidNextCommands gCommandListAlways, gCommandListGeneral
Else
    gSetValidNextCommands gCommandListAlways, gCommandListGeneral, gCommandListOrderCreation
End If
End Sub

Private Sub purgeGroup(ByVal pGroupName As String)
Const ProcName As String = "purgeGroup"
On Error GoTo Err

Dim lRes As GroupResources
Set lRes = mGroups.Item(pGroupName)

lRes.CurrentContractProcessor = Nothing

Dim lOrderPlacer As OrderPlacer
For Each lOrderPlacer In lRes.OrderPlacers
    lOrderPlacer.Finish
    gPlaceOrdersTask.RemoveOrderPlacer lOrderPlacer
Next
lRes.OrderPlacers.Clear

Dim lPM As PositionManager
For Each lPM In mOrderManager.GetPositionManagersForGroup(pGroupName)
    lPM.Purge
Next

Dim lContractProcessor As ContractProcessor
For Each lContractProcessor In lRes.ContractProcessors
    lContractProcessor.Finish
Next
lRes.ContractProcessors.Clear

Exit Sub

Err:
gHandleUnexpectedError ProcName, ModuleName
End Sub

Private Function setBatchOrders() As Boolean
setBatchOrders = True
If mClp.SwitchValue(BatchOrdersSwitch) = "" Then
    mBatchOrdersDefault = False
ElseIf UCase$(mClp.SwitchValue(BatchOrdersSwitch)) = Yes Then
    mBatchOrdersDefault = True
ElseIf UCase$(mClp.SwitchValue(BatchOrdersSwitch)) = No Then
    mBatchOrdersDefault = False
Else
    gWriteErrorLine "The /" & BatchOrdersSwitch & " switch has an invalid value: it must be either YES or NO (not case-sensitive)", True
    setBatchOrders = False
End If
End Function

Private Function setMonitor() As Boolean
setMonitor = True
If Not mClp.Switch(MonitorSwitch) Then
    mMonitor = False
ElseIf mClp.SwitchValue(MonitorSwitch) = "" Then
    mMonitor = True
ElseIf UCase$(mClp.SwitchValue(MonitorSwitch)) = Yes Then
    mMonitor = True
ElseIf UCase$(mClp.SwitchValue(MonitorSwitch)) = No Then
    mMonitor = False
Else
    gWriteErrorLine "The /" & MonitorSwitch & " switch has an invalid value: it must be either YES or NO (not case-sensitive, default is YES)", True
    setMonitor = False
End If
End Function

Private Sub setOrderRecovery()
Const ProcName As String = "setOrderRecovery"
On Error GoTo Err

If Not mClp.Switch(ScopeNameSwitch) Then Exit Sub
mScopeName = mClp.SwitchValue(ScopeNameSwitch)
If mScopeName = "" Then Exit Sub

mGroupName = DefaultGroupName
mGroups.Add DefaultGroupName
mRecoveryFileDir = ApplicationSettingsFolder
If mClp.SwitchValue(RecoveryFileDirSwitch) <> "" Then mRecoveryFileDir = mClp.SwitchValue(RecoveryFileDirSwitch)

If mOrderPersistenceDataStore Is Nothing Then Set mOrderPersistenceDataStore = CreateOrderPersistenceDataStore(mRecoveryFileDir)

Dim lOrderRecoverer As New OrderRecoverer
lOrderRecoverer.RecoverOrders mOrderManager, mScopeName, mOrderPersistenceDataStore, mOrderRecoveryAgent, mMarketDataManager, mOrderSubmitterFactory, mGroups

Exit Sub

Err:
gHandleUnexpectedError ProcName, ModuleName
End Sub

Private Function setStageOrders() As Boolean
setStageOrders = True
If mClp.SwitchValue(StageOrdersSwitch) = "" Then
    mStageOrdersDefault = False
ElseIf UCase$(mClp.SwitchValue(StageOrdersSwitch)) = Yes Then
    If Not (mOrderSubmitterFactory.Capabilities And OrderSubmitterCapabilityCanStageOrders) = OrderSubmitterCapabilityCanStageOrders Then
        gWriteErrorLine "The /" & StageOrdersSwitch & " switch has an invalid value: it cannot be YES with the current configuration", True
        setStageOrders = False
        Exit Function
    End If
    mStageOrdersDefault = True
ElseIf UCase$(mClp.SwitchValue(StageOrdersSwitch)) = No Then
    mStageOrdersDefault = False
Else
    gWriteErrorLine "The /" & StageOrdersSwitch & " switch has an invalid value: it must be either YES or NO (not case-sensitive)", True
    setStageOrders = False
End If
End Function

Private Sub setupCommandLists()
gCommandListAlways.Initialise _
                gCommands.ExitCommand, _
                gCommands.HelpCommand, _
                gCommands.Help1Command, _
                gCommands.ListCommand, _
                gCommands.PurgeCommand, _
                gCommands.QuoteCommand, _
                gCommands.ResetCommand, _
                gCommands.StageOrdersCommand

gCommandListOrderCreation.Initialise _
                gCommands.BracketCommand, _
                gCommands.BuyAgainCommand, _
                gCommands.BuyCommand, _
                gCommands.EndOrdersCommand, _
                gCommands.SellAgainCommand, _
                gCommands.SellCommand

gCommandListOrderSpecification.Initialise _
                gCommands.ContractCommand, _
                gCommands.EntryCommand, _
                gCommands.QuitCommand, _
                gCommands.StopLossCommand, _
                gCommands.TargetCommand

gCommandListOrderCompletion.Initialise _
                gCommands.EndBracketCommand

gCommandListGeneral.Initialise _
                gCommands.CloseoutCommand, _
                gCommands.ContractCommand, _
                gCommands.EndOrdersCommand, _
                gCommands.GroupCommand
End Sub

Private Sub setupResultsLogging(ByVal pClp As CommandLineParser)
Const ProcName As String = "setupResultsLogging"
On Error GoTo Err

Static sSetup As Boolean
If sSetup Then Exit Sub
sSetup = True

Dim lResultsPath As String

If pClp.Switch(ResultsDirSwitch) Then
    If pClp.SwitchValue(ResultsDirSwitch) <> "" Then lResultsPath = pClp.SwitchValue(ResultsDirSwitch)
ElseIf pClp.Switch(LogFileSwitch) Then
    If pClp.SwitchValue(LogFileSwitch) Then
        Dim fso As New FileSystemObject
        lResultsPath = fso.GetParentFolderName(pClp.SwitchValue(LogFileSwitch))
    End If
End If

If lResultsPath = "" Then lResultsPath = ApplicationSettingsFolder & "\Results\"
If Right$(lResultsPath, 1) <> "\" Then lResultsPath = lResultsPath & "\"

Dim lFilenameSuffix As String
lFilenameSuffix = FormatTimestamp(GetTimestamp, TimestampDateOnly + TimestampNoMillisecs)

Dim lLogfile As FileLogListener
Set lLogfile = CreateFileLogListener( _
                    lResultsPath & "Logs\" & _
                        ProjectName & _
                        "(" & mClientId & ")" & _
                        "-" & lFilenameSuffix & _
                        ".log", _
                    includeTimestamp:=True, _
                    includeLogLevel:=False)
GetLogger("log").AddLogListener lLogfile
GetLogger("position.order").AddLogListener lLogfile
GetLogger("position.simulatedorder").AddLogListener lLogfile

If mMonitor Then
    Set lLogfile = CreateFileLogListener( _
                    lResultsPath & "Orders\" & _
                        ProjectName & _
                        "(" & mClientId & ")" & _
                        "-" & lFilenameSuffix & _
                        "-Executions" & _
                        ".log", _
                    includeTimestamp:=False, _
                    includeLogLevel:=False)
    GetLogger("position.orderdetail").AddLogListener lLogfile
    
    Set lLogfile = CreateFileLogListener( _
                    lResultsPath & "Orders\" & _
                        ProjectName & _
                        "(" & mClientId & ")" & _
                        "-" & lFilenameSuffix & _
                        "-BracketOrders" & ".log", _
                    includeTimestamp:=False, _
                    includeLogLevel:=False)
    GetLogger("position.bracketorderprofilestring").AddLogListener lLogfile
End If

Exit Sub

Err:
gHandleUnexpectedError ProcName, ModuleName
End Sub

Private Function setupTwsApi( _
                ByVal SwitchValue As String, _
                ByVal pSimulateOrders As Boolean, _
                ByVal pLogApiMessages As ApiMessageLoggingOptions, _
                ByVal pLogRawApiMessages As ApiMessageLoggingOptions, _
                ByVal pLogApiMessageStats As Boolean) As Boolean
Const ProcName As String = "setupTwsApi"
On Error GoTo Err

Dim lClp As CommandLineParser
Set lClp = CreateCommandLineParser(SwitchValue, ",")

Dim server As String
server = lClp.Arg(0)

Dim port As String
port = lClp.Arg(1)

Dim clientId As String
clientId = lClp.Arg(2)

If port = "" Then
    port = 7496
ElseIf Not IsInteger(port, 0) Then
    gWriteErrorLine "port must be an integer > 0", True
    setupTwsApi = False
End If
    
If clientId = "" Then
    clientId = DefaultClientId
ElseIf Not IsInteger(clientId, 0, 999999999) Then
    gWriteErrorLine "clientId must be an integer >= 0 and <= 999999999", True
    setupTwsApi = False
Else
    mClientId = CLng(clientId)
End If

Dim lTwsClient As Client
Set lTwsClient = GetClient(server, _
                        CLng(port), _
                        mClientId, _
                        pLogApiMessages:=pLogApiMessages, _
                        pLogRawApiMessages:=pLogRawApiMessages, _
                        pLogApiMessageStats:=pLogApiMessageStats)

Set mContractStore = lTwsClient.GetContractStore
Set mMarketDataManager = CreateRealtimeDataManager(lTwsClient.GetMarketDataFactory)
mMarketDataManager.LoadFromConfig gGetMarketDataSourcesConfig(mConfigStore)

Set mOrderRecoveryAgent = lTwsClient

If pSimulateOrders Then
    Set mOrderSubmitterFactory = New SimOrderSubmitterFactory
Else
    Set mOrderSubmitterFactory = lTwsClient
End If
    
setupTwsApi = True

Exit Function

Err:
gHandleUnexpectedError ProcName, ModuleName
End Function

Private Sub showCloseoutHelp()
gWriteLineToConsole "    closeoutcommand  ::= closeout [ <groupname> | ALL ]"
gWriteLineToConsole "                                  [ LMT[:<percentofspread>] ]"
gWriteLineToConsole ""
gWriteLineToConsole "    percentofspread  ::= INTEGER"
gWriteLineToConsole ""
End Sub

Public Sub showContractHelp()
gWriteLineToConsole "    contractcommand  ::= contract <contractspec>EOL"
gWriteLineToConsole ""
gWriteLineToConsole "    contractspec     ::= <localsymbol>[@<exchangename>]"
gWriteLineToConsole "                         | <localsymbol>@SMART/<routinghint>"
gWriteLineToConsole "                         | /<specifier>[;/<specifier>]..."
gWriteLineToConsole "    routinghint ::= STRING"
gWriteLineToConsole "    specifier ::=   local[symbol]:<localsymbol>"
gWriteLineToConsole "                  | symb[ol]:<symbol>"
gWriteLineToConsole "                  | sec[type]:<sectype>"
gWriteLineToConsole "                  | exch[ange]:<exchangename>"
gWriteLineToConsole "                  | curr[ency]:<currencycode>"
gWriteLineToConsole "                  | exp[iry]:<yyyymm> | <yyyymmdd> | <expiryoffset>"
gWriteLineToConsole "                  | mult[iplier]:<multiplier>"
gWriteLineToConsole "                  | str[ike]:<price>"
gWriteLineToConsole "                  | right:CALL|PUT"
gWriteLineToConsole "    localsymbol ::= STRING"
gWriteLineToConsole "    symbol ::= STRING"
gWriteLineToConsole "    sectype ::= STK | FUT | FOP | CASH | OPT"
gWriteLineToConsole "    exchangename ::= STRING"
gWriteLineToConsole "    currencycode ::= USD | EUR | GBP | JPY | CHF | etc"
gWriteLineToConsole "    yyyymm       ::= <yyyy><mm>"
gWriteLineToConsole "    yyyymmdd     ::= <yyyy><mm><dd>"
gWriteLineToConsole "    yyyy         ::= INTEGER(1900..2100)"
gWriteLineToConsole "    mm           ::= INTEGER(01..12)"
gWriteLineToConsole "    dd           ::= INTEGER(01..31)"
gWriteLineToConsole "    expiryoffset ::= INTEGER(0..10)"
End Sub

Private Sub showListHelp()
gWriteLineToConsole "    listcommand  ::= list groups|positions|trades"
End Sub

Private Sub showOrderHelp()
gWriteLineToConsole "    buycommand  ::= buy [<contract>] <quantity> <entryordertype> "
gWriteLineToConsole "                        [<priceoroffset> [<triggerprice]]"
gWriteLineToConsole "                        [<attribute>]... EOL"
gWriteLineToConsole ""
gWriteLineToConsole "    sellcommand ::= sell [<contract>] <quantity> <entryordertype> "
gWriteLineToConsole "                         [<priceoroffset> [<triggerprice]]"
gWriteLineToConsole "                         [<attribute>]... EOL"
gWriteLineToConsole ""
gWriteLineToConsole "    bracketcommand ::= bracket <action> <quantity> [<bracketattr>]... EOL"
gWriteLineToConsole "                       entry <entryordertype> [<orderattr>]...  EOL"
gWriteLineToConsole "                       [stoploss <stoplossorderType> [<orderattr>]...  EOL]"
gWriteLineToConsole "                       [target <targetorderType> [<orderattr>]...  ] EOL"
gWriteLineToConsole "                       endbracket EOL"
gWriteLineToConsole ""
gWriteLineToConsole "    action     ::= buy | sell"
gWriteLineToConsole "    quantity   ::= INTEGER >= 1"
gWriteLineToConsole "    entryordertype  ::=   mkt"
gWriteLineToConsole "                        | lmt"
gWriteLineToConsole "                        | stp"
gWriteLineToConsole "                        | stplmt"
gWriteLineToConsole "                        | mit"
gWriteLineToConsole "                        | lit"
gWriteLineToConsole "                        | moc"
gWriteLineToConsole "                        | loc"
gWriteLineToConsole "                        | trail"
gWriteLineToConsole "                        | traillmt"
gWriteLineToConsole "                        | mtl"
gWriteLineToConsole "                        | moo"
gWriteLineToConsole "                        | loo"
gWriteLineToConsole "                        | bid"
gWriteLineToConsole "                        | ask"
gWriteLineToConsole "                        | last"
gWriteLineToConsole "    stoplossordertype  ::=   mkt"
gWriteLineToConsole "                           | stp"
gWriteLineToConsole "                           | stplmt"
gWriteLineToConsole "                           | auto"
gWriteLineToConsole "                           | trail"
gWriteLineToConsole "                           | traillmt"
gWriteLineToConsole "    targetordertype  ::=   mkt"
gWriteLineToConsole "                         | lmt"
gWriteLineToConsole "                         | mit"
gWriteLineToConsole "                         | lit"
gWriteLineToConsole "                         | auto"
gWriteLineToConsole "    attribute  ::= <bracketattr> | <orderattr>"
gWriteLineToConsole "    bracketattr  ::=  /cancelafter:<canceltime>"
gWriteLineToConsole "                     | /cancelprice:<price>"
gWriteLineToConsole "                     | /description:STRING"
gWriteLineToConsole "                     | /goodaftertime:DATETIME"
gWriteLineToConsole "                     | /goodtilldate:DATETIME"
gWriteLineToConsole "                     | /timezone:TIMEZONENAME"
gWriteLineToConsole "    orderattr  ::=   /price:<price>"
gWriteLineToConsole "                   | /reason:STRING"
gWriteLineToConsole "                   | /trigger[price]:<price>"
gWriteLineToConsole "                   | /trailby:<numberofticks>"
gWriteLineToConsole "                   | /trailpercent:<percentage>"
gWriteLineToConsole "                   | /offset:<points>"
gWriteLineToConsole "                   | /offset:<numberofticks>T"
gWriteLineToConsole "                   | /offset:<bidaskspreadpercent>%"
gWriteLineToConsole "                   | /tif:<tifvalue>"
gWriteLineToConsole "    priceoroffset ::= <price> | <offset>"
gWriteLineToConsole "    price  ::= DOUBLE"
gWriteLineToConsole "    offset ::= DOUBLE"
gWriteLineToConsole "    points ::= DOUBLE"
gWriteLineToConsole "    bidaskspreadpercent ::= [+|-]INTEGEER"
gWriteLineToConsole "    numberofticks  ::= [+|-]INTEGER"
gWriteLineToConsole "    percentage  ::= DOUBLE <= 10.0"
gWriteLineToConsole "    tifvalue  ::=   DAY"
gWriteLineToConsole "                  | GTC"
gWriteLineToConsole "                  | IOC"

End Sub

Private Sub showReverseHelp()
gWriteLineToConsole "    reversecommand   ::= reverse [ <groupname> | ALL ])"
End Sub

Private Sub showStdInHelp()
gWriteLineToConsole "StdIn Format:"
gWriteLineToConsole ""
gWriteLineToConsole "#comment EOL"
gWriteLineToConsole ""
gWriteLineToConsole "[stageorders [yes|no|default] EOL]"
gWriteLineToConsole ""
gWriteLineToConsole "[group [<groupname>] EOL]"
gWriteLineToConsole ""
gWriteLineToConsole "<contractcommand>"
gWriteLineToConsole ""
gWriteLineToConsole "[<buycommand>|<sellcommand>|<bracketcommand>]..."
gWriteLineToConsole ""
gWriteLineToConsole "endorders EOL"
gWriteLineToConsole ""
gWriteLineToConsole "reset EOL"
gWriteLineToConsole ""
gWriteLineToConsole "<listcommand>"
gWriteLineToConsole ""
gWriteLineToConsole "<closeoutcommand>"
gWriteLineToConsole ""
gWriteLineToConsole "<reversecommand>"
gWriteLineToConsole ""
gWriteLineToConsole "quote <contractspecification>"
gWriteLineToConsole ""
gWriteLineToConsole "where"
gWriteLineToConsole ""
showContractHelp
gWriteLineToConsole ""
showOrderHelp
gWriteLineToConsole ""
showListHelp
gWriteLineToConsole ""
showCloseoutHelp
gWriteLineToConsole ""
showReverseHelp
End Sub

Private Sub showStdOutHelp()
gWriteLineToConsole "StdOut Format:"
gWriteLineToConsole ""
gWriteLineToConsole "CONTRACT <contractdetails>"
gWriteLineToConsole "TIME <timestamp>"
gWriteLineToConsole "<orderdetails>"
gWriteLineToConsole "<bracketorderdetails>"
gWriteLineToConsole "ENDORDERS"
gWriteLineToConsole ""
gWriteLineToConsole "  where"
gWriteLineToConsole ""
gWriteLineToConsole "    contractdetails      ::= same format as for contract input"
gWriteLineToConsole "    timestamp            ::= yyyy-mm-dd hh:mm:ss"
gWriteLineToConsole "    orderdetails         ::= Same format as single order input"
gWriteLineToConsole "    bracketorderdetails  ::= Same format as bracket order input"
End Sub

Private Sub showUsage()
gWriteLineToConsole "Usage:"
gWriteLineToConsole "plord27 -tws[:[<twsserver>][,[<port>][,[<clientid>]]]] [-monitor[:[yes|no]]] "
gWriteLineToConsole "       [-resultsdir:<resultspath>] [-stopAt:<hh:mm>] [-log:<logfilepath>]"
gWriteLineToConsole "       [-loglevel:[ I | N | D | M | H }]"
gWriteLineToConsole "       [-stageorders[:[yes|no]]]"
gWriteLineToConsole "       [-simulateorders] [-apimessagelogging:[D|A|N][D|A|N][Y|N]]"
gWriteLineToConsole "       [-scopename:<scope>] [-recoveryfiledir:<recoverypath>]"
gWriteLineToConsole ""
gWriteLineToConsole "  where"
gWriteLineToConsole ""
gWriteLineToConsole "    twsserver  ::= STRING name or IP address of computer where TWS/Gateway"
gWriteLineToConsole "                          is running"
gWriteLineToConsole "    port       ::= INTEGER port to be used for API connection"
gWriteLineToConsole "    clientid   ::= INTEGER client id >=0 to be used for API connection (default"
gWriteLineToConsole "                           value is " & DefaultClientId & ")"
gWriteLineToConsole "    resultspath ::= path to the folder in which results files are to be created"
gWriteLineToConsole "                    (defaults to the logfile path)"
gWriteLineToConsole "    logfilepath ::= path to the folder where the program logfile is to be"
gWriteLineToConsole "                    created"
gWriteLineToConsole "    scope       ::= order recovery scope name"
gWriteLineToConsole "    recoverypath ::= path to the folder in which order recovery files are to"
gWriteLineToConsole "                     be created(defaults to the logfile path)"
gWriteLineToConsole ""
showStdInHelp
gWriteLineToConsole ""
showStdOutHelp
gWriteLineToConsole ""
End Sub

Private Function validateApiMessageLogging( _
                ByVal pApiMessageLogging As String, _
                ByRef pLogApiMessages As ApiMessageLoggingOptions, _
                ByRef pLogRawApiMessages As ApiMessageLoggingOptions, _
                ByRef pLogApiMessageStats As Boolean) As Boolean
Const Always As String = "A"
Const Default As String = "D"
Const No As String = "N"
Const None As String = "N"
Const Yes As String = "Y"

pApiMessageLogging = UCase$(pApiMessageLogging)

validateApiMessageLogging = False
If Len(pApiMessageLogging) = 0 Then pApiMessageLogging = Default & Default & No
If Len(pApiMessageLogging) <> 3 Then Exit Function

Dim s As String
s = Left$(pApiMessageLogging, 1)
If s = None Then
    pLogApiMessages = ApiMessageLoggingOptionNone
ElseIf s = Default Then
    pLogApiMessages = ApiMessageLoggingOptionDefault
ElseIf s = Always Then
    pLogApiMessages = ApiMessageLoggingOptionAlways
Else
    Exit Function
End If

s = Mid(pApiMessageLogging, 2, 1)
If s = None Then
    pLogRawApiMessages = ApiMessageLoggingOptionNone
ElseIf s = Default Then
    pLogRawApiMessages = ApiMessageLoggingOptionDefault
ElseIf s = Always Then
    pLogRawApiMessages = ApiMessageLoggingOptionAlways
Else
    Exit Function
End If

s = Mid(pApiMessageLogging, 3, 1)
If s = No Then
    pLogApiMessageStats = False
ElseIf s = Yes Then
    pLogApiMessageStats = True
Else
    Exit Function
End If

validateApiMessageLogging = True
End Function

