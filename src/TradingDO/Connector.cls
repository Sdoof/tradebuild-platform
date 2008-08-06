VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "Connector"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
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

Event Connected( _
                ByVal pConnection As connection)

Event ConnectFailed( _
                ByVal errorCode As Long, _
                ByVal errorDesc As String)

'@================================================================================
' Enums
'@================================================================================

'@================================================================================
' Types
'@================================================================================

'@================================================================================
' Constants
'@================================================================================

Private Const ProjectName                   As String = "TradingDO26"
Private Const ModuleName                    As String = "Connector"

'@================================================================================
' Member variables
'@================================================================================

Private mDB                                 As TradingDB

Private WithEvents mConnection              As ADODB.connection
Attribute mConnection.VB_VarHelpID = -1
Private mConnected                          As Boolean

' need the following because sometimes when running async under heavy load,
' ADO appears not to notify the connection completion event. So need to retry
' the connection if we don't get the event within a certain time.
Private WithEvents mConnectionTimer         As IntervalTimer
Attribute mConnectionTimer.VB_VarHelpID = -1

Private mCursorlocation                     As CursorLocationEnum
Private mOptions                            As ConnectOptionEnum

'@================================================================================
' Class Event Handlers
'@================================================================================

Private Sub Class_Terminate()
If Not mConnection Is Nothing Then
    If mConnection.State = adStateOpen Then
        mConnection.Close
    Else
        mConnection.cancel
    End If
End If
End Sub

'@================================================================================
' XXXX Interface Members
'@================================================================================

'@===============================================================================
' mConnection Event Handlers
'@===============================================================================

Private Sub mConnection_ConnectComplete(ByVal pError As ADODB.Error, adStatus As ADODB.EventStatusEnum, ByVal pConnection As ADODB.connection)
If Not mConnectionTimer Is Nothing Then mConnectionTimer.StopTimer
If adStatus = EventStatusEnum.adStatusErrorsOccurred Then
    gLogger.Log LogLevelDetail, "Connector: connection error occurred" & vbCrLf & _
                                gGenerateErrorMessage(pError) & _
                                gGenerateConnectionErrorMessages(pConnection)
    RaiseEvent ConnectFailed(pError.Number, _
                            ModuleName & ": connection error " & vbCrLf & _
                            gGenerateErrorMessage(pError) & _
                            gGenerateConnectionErrorMessages(pConnection))
Else
    mConnected = True
    RaiseEvent Connected(mConnection)
End If


End Sub

Private Sub mConnection_InfoMessage(ByVal pError As ADODB.Error, adStatus As ADODB.EventStatusEnum, ByVal pConnection As ADODB.connection)
gLogger.Log LogLevelDetail, "Connector: InfoMessage event received" & vbCrLf & _
                            gGenerateErrorMessage(pError) & _
                            gGenerateConnectionErrorMessages(pConnection)
End Sub

'@===============================================================================
' mConnectionTimer Event Handlers
'@===============================================================================

Private Sub mConnectionTimer_TimerExpired()
Debug.Print "BarWriter: Connect timed out - reconnecting"
gLogger.Log LogLevelDetail, "Connector: connect timed out - reconnecting"
If mConnection.State = adStateOpen Then
    mConnection.Close
Else
    mConnection.cancel
End If
connectToDB
End Sub

'@================================================================================
' Properties
'@================================================================================

Public Property Get connection() As ADODB.connection
If Not mConnected Then
    Err.Raise ErrorCodes.ErrIllegalStateException, _
            ProjectName & "." & ModuleName & ":" & "connection", _
            "Connection not yet established or connection failed"
End If

Set connection = mConnection
End Property

'@================================================================================
' Methods
'@================================================================================

Public Sub connect()
connectToDB
End Sub

Friend Sub initialise( _
                ByVal db As TradingDB, _
                ByVal cursorlocation As CursorLocationEnum, _
                ByVal Options As ConnectOptionEnum)
Set mDB = db
mCursorlocation = cursorlocation
mOptions = Options
End Sub

'@================================================================================
' Helper Functions
'@================================================================================

Private Sub connectToDB()
If Not mConnection Is Nothing Then
    If mConnection.State = adStateOpen Then
        mConnection.Close
    Else
        mConnection.cancel
    End If
    Set mConnection = Nothing
End If

Set mConnection = New ADODB.connection

mConnection.cursorlocation = mCursorlocation
mConnection.Open mDB.connectionString, , , mOptions

If mOptions = adAsyncConnect Then
    Set mConnectionTimer = CreateIntervalTimer(ConnectCompletionTimeoutMillisecs, ExpiryTimeUnitMilliseconds)
    mConnectionTimer.StartTimer
End If
End Sub
