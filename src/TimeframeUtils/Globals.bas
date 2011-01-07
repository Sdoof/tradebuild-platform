Attribute VB_Name = "Globals"
Option Explicit

'@================================================================================
' Description
'@================================================================================
'
'

'@================================================================================
' Interfaces
'@================================================================================

'@================================================================================
' Events
'@================================================================================

'@================================================================================
' Constants
'@================================================================================

Public Const ProjectName                        As String = "TimeframeUtils26"
Private Const ModuleName                As String = "Globals"

Public Const OneMicroSecond As Double = 1.15740740740741E-11
Public Const OneSecond As Double = 1 / 86400
Public Const OneMinute As Double = 1 / 1440
Public Const OneHour As Double = 1 / 24

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
' Member variables
'@================================================================================

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

Public Property Get gErrorLogger() As Logger
Static lLogger As Logger
If lLogger Is Nothing Then Set lLogger = GetLogger("error")
Set gErrorLogger = lLogger
End Property

Public Property Get gLogger() As Logger
Static lLogger As Logger
If lLogger Is Nothing Then Set lLogger = GetLogger("log")
Set gLogger = lLogger
End Property

'@================================================================================
' Methods
'@================================================================================

Public Function gBarEndTime( _
                ByVal Timestamp As Date, _
                ByVal BarTimePeriod As TimePeriod, _
                ByVal SessionStartTime As Date, _
                ByVal SessionEndTime As Date) As Date
Dim StartTime As Date
Const ProcName As String = "gBarEndTime"
Dim failpoint As String
On Error GoTo Err

StartTime = gBarStartTime( _
                Timestamp, _
                BarTimePeriod, _
                SessionStartTime)
Select Case BarTimePeriod.Units
Case TimePeriodSecond
    gBarEndTime = StartTime + (BarTimePeriod.Length / 86400) - OneMicroSecond
Case TimePeriodMinute
    gBarEndTime = StartTime + (BarTimePeriod.Length / 1440) - OneMicroSecond
Case TimePeriodHour
    gBarEndTime = StartTime + (BarTimePeriod.Length / 24) - OneMicroSecond
Case TimePeriodDay
    gBarEndTime = WorkingDayDate(WorkingDayNumber(StartTime) + BarTimePeriod.Length, StartTime)
Case TimePeriodWeek
    gBarEndTime = StartTime + 7 * BarTimePeriod.Length
Case TimePeriodMonth
    gBarEndTime = DateAdd("m", BarTimePeriod.Length, StartTime)
Case TimePeriodYear
    gBarEndTime = DateAdd("yyyy", BarTimePeriod.Length, StartTime)
Case TimePeriodVolume, _
        TimePeriodTickVolume, _
        TimePeriodTickMovement
    gBarEndTime = Timestamp
End Select

Dim sessStart As Date
Dim sessEnd As Date

calcSessionTimesHelper StartTime, SessionStartTime, SessionEndTime, sessStart, sessEnd

If StartTime < sessStart And gBarEndTime > sessStart Then
    gBarEndTime = Int(gBarEndTime) + SessionStartTime
End If

Exit Function

Err:
gHandleUnexpectedError pReRaise:=True, pLog:=False, pProcedureName:=ProcName, pModuleName:=ModuleName, pFailpoint:=failpoint
End Function

Public Function gBarStartTime( _
                ByVal Timestamp As Date, _
                ByVal BarTimePeriod As TimePeriod, _
                ByVal SessionStartTime As Date) As Date

' minutes from midnight to start of sesssion
Dim sessionOffset           As Long
Dim theDate                 As Long
Dim theTime                 As Double
Dim theTimeMins             As Long
Dim theTimeSecs             As Long

Const ProcName As String = "gBarStartTime"
Dim failpoint As String
On Error GoTo Err

sessionOffset = Int(1440 * (SessionStartTime + OneMicroSecond - Int(SessionStartTime)))

theDate = Int(CDbl(Timestamp))
' NB: don't use TimeValue to get the time, as VB rounds it to
' the nearest second
theTime = CDbl(Timestamp + OneMicroSecond) - theDate

Select Case BarTimePeriod.Units
Case TimePeriodSecond
    theTimeSecs = Fix(theTime * 86400) ' seconds since midnight
    If theTimeSecs < sessionOffset * 60 Then
        theDate = theDate - 1
        theTimeSecs = theTimeSecs + 86400
    End If
    gBarStartTime = theDate + _
                (BarTimePeriod.Length * Int((theTimeSecs - sessionOffset * 60) / BarTimePeriod.Length) + _
                    sessionOffset * 60) / 86400
Case TimePeriodMinute
    theTimeMins = Fix(theTime * 1440) ' minutes since midnight
    If theTimeMins < sessionOffset Then
        theDate = theDate - 1
        theTimeMins = theTimeMins + 1440
    End If
    gBarStartTime = theDate + _
                (BarTimePeriod.Length * Int((theTimeMins - sessionOffset) / BarTimePeriod.Length) + _
                    sessionOffset) / 1440
Case TimePeriodHour
    theTimeMins = Fix(theTime * 1440) ' minutes since midnight
    If theTimeMins < sessionOffset Then
        theDate = theDate - 1
        theTimeMins = theTimeMins + 1440
    End If
    gBarStartTime = theDate + _
                (60 * BarTimePeriod.Length * Int((theTimeMins - sessionOffset) / (60 * BarTimePeriod.Length)) + _
                    sessionOffset) / 1440
Case TimePeriodDay
    Dim workingDayNum As Long
    If theTime < SessionStartTime Then
        theDate = theDate - 1
    End If
    
    If BarTimePeriod.Length = 1 Then
        gBarStartTime = theDate + SessionStartTime
    Else
        workingDayNum = WorkingDayNumber(theDate)
        
        gBarStartTime = WorkingDayDate(1 + BarTimePeriod.Length * Int((workingDayNum - 1) / BarTimePeriod.Length), _
                                        theDate) + SessionStartTime
    End If
Case TimePeriodWeek
    Dim weekNum As Long
    
    weekNum = DatePart("ww", theDate, vbMonday, vbFirstFullWeek)
    If weekNum >= 52 And Month(theDate) = 1 Then
        ' this must be part of the final week of the previous year
        theDate = DateAdd("yyyy", -1, theDate)
    End If
    gBarStartTime = WeekStartDateFromWeekNumber(1 + BarTimePeriod.Length * Int((weekNum - 1) / BarTimePeriod.Length), _
                                    theDate) + SessionStartTime

Case TimePeriodMonth
    Dim monthNum As Long
    
    monthNum = Month(theDate)
    gBarStartTime = MonthStartDateFromMonthNumber(1 + BarTimePeriod.Length * Int((monthNum - 1) / BarTimePeriod.Length), _
                                    theDate) + SessionStartTime
Case TimePeriodYear
    gBarStartTime = DateSerial(1900 + BarTimePeriod.Length * Int((Year(theDate) - 1900) / BarTimePeriod.Length), 1, 1)
Case TimePeriodVolume, _
        TimePeriodTickVolume, _
        TimePeriodTickMovement
    gBarStartTime = Timestamp
End Select

Exit Function

Err:
gHandleUnexpectedError pReRaise:=True, pLog:=False, pProcedureName:=ProcName, pModuleName:=ModuleName, pFailpoint:=failpoint

End Function

Public Function gCalcBarLength( _
                ByVal BarTimePeriod As TimePeriod) As Date
Const ProcName As String = "gCalcBarLength"
Dim failpoint As String
On Error GoTo Err

Select Case BarTimePeriod.Units
Case TimePeriodSecond
    gCalcBarLength = BarTimePeriod.Length * OneSecond
Case TimePeriodMinute
    gCalcBarLength = BarTimePeriod.Length * OneMinute
Case TimePeriodHour
    gCalcBarLength = BarTimePeriod.Length * OneHour
Case TimePeriodDay
    gCalcBarLength = BarTimePeriod.Length
End Select

Exit Function

Err:
gHandleUnexpectedError pReRaise:=True, pLog:=False, pProcedureName:=ProcName, pModuleName:=ModuleName, pFailpoint:=failpoint
End Function

Public Function gCalcNumberOfBarsInSession( _
                ByVal BarTimePeriod As TimePeriod, _
                ByVal SessionStartTime As Date, _
                ByVal SessionEndTime As Date) As Long

Const ProcName As String = "gCalcNumberOfBarsInSession"
Dim failpoint As String
On Error GoTo Err

If SessionEndTime > SessionStartTime Then
    gCalcNumberOfBarsInSession = -Int(-(SessionEndTime - SessionStartTime) / gCalcBarLength(BarTimePeriod))
Else
    gCalcNumberOfBarsInSession = -Int(-(1 + SessionEndTime - SessionStartTime) / gCalcBarLength(BarTimePeriod))
End If

Exit Function

Err:
gHandleUnexpectedError pReRaise:=True, pLog:=False, pProcedureName:=ProcName, pModuleName:=ModuleName, pFailpoint:=failpoint
End Function

Public Function gCalcOffsetBarStartTime( _
                ByVal Timestamp As Date, _
                ByVal BarTimePeriod As TimePeriod, _
                ByVal offset As Long, _
                ByVal SessionStartTime As Date, _
                ByVal SessionEndTime As Date) As Date
Dim lSessTimes As SessionTimes
Dim datumBarStart As Date
Dim proposedStart As Date
Dim remainingOffset As Long
Dim BarsFromSessStart As Long
Dim BarsToSessEnd As Long
Dim i As Long
Dim BarLengthDays As Date
Dim numBarsInSession As Long

Const ProcName As String = "gCalcOffsetBarStartTime"
Dim failpoint As String
On Error GoTo Err

Select Case BarTimePeriod.Units
Case TimePeriodSecond
Case TimePeriodMinute
Case TimePeriodHour
Case TimePeriodDay
    gCalcOffsetBarStartTime = calcOffsetDailyBarStartTime( _
                                                    Timestamp, _
                                                    BarTimePeriod.Length, _
                                                    offset, _
                                                    SessionStartTime)
    Exit Function
Case TimePeriodWeek
    gCalcOffsetBarStartTime = calcOffsetWeeklyBarStartTime( _
                                                    Timestamp, _
                                                    BarTimePeriod.Length, _
                                                    offset, _
                                                    SessionStartTime)
    Exit Function
Case TimePeriodMonth
    gCalcOffsetBarStartTime = calcOffsetMonthlyBarStartTime( _
                                                    Timestamp, _
                                                    BarTimePeriod.Length, _
                                                    offset, _
                                                    SessionStartTime)
    Exit Function
Case TimePeriodYear
    gCalcOffsetBarStartTime = calcOffsetYearlyBarStartTime( _
                                                    Timestamp, _
                                                    BarTimePeriod.Length, _
                                                    offset, _
                                                    SessionStartTime)
    Exit Function
End Select

BarLengthDays = gCalcBarLength(BarTimePeriod) + OneMicroSecond

numBarsInSession = gCalcNumberOfBarsInSession(BarTimePeriod, SessionStartTime, SessionEndTime)

datumBarStart = gBarStartTime(Timestamp, BarTimePeriod, SessionStartTime)

lSessTimes = gCalcSessionTimes(Timestamp, _
                    SessionStartTime, _
                    SessionEndTime)

If offset > 0 Then
    
    If datumBarStart < lSessTimes.StartTime Then
        ' specified Timestamp was between sessions
        datumBarStart = lSessTimes.StartTime
        offset = offset - 1
    End If
    
    BarsToSessEnd = Round((lSessTimes.EndTime - datumBarStart) / BarLengthDays, 0)
    If BarsToSessEnd >= offset Then
        ' all required Bars are in this session
        proposedStart = datumBarStart + offset * BarLengthDays
    Else
        remainingOffset = offset - BarsToSessEnd
        proposedStart = datumBarStart + BarsToSessEnd * BarLengthDays
        Do While remainingOffset > 0
            i = 1
            Do
                i = 1 + 1
                lSessTimes = gCalcSessionTimes(proposedStart + i, _
                                    SessionStartTime, _
                                    SessionEndTime)
            Loop Until lSessTimes.StartTime > proposedStart
            
            If numBarsInSession >= remainingOffset Then
                proposedStart = lSessTimes.StartTime + remainingOffset * BarLengthDays
                remainingOffset = 0
            Else
                proposedStart = lSessTimes.EndTime
                remainingOffset = remainingOffset - numBarsInSession
            End If
        Loop
    End If
Else
    offset = -offset

    If datumBarStart < lSessTimes.StartTime Then
        ' specified Timestamp was between sessions
        datumBarStart = lSessTimes.StartTime
    End If
    
    proposedStart = lSessTimes.StartTime
    BarsFromSessStart = Round((datumBarStart - lSessTimes.StartTime) / BarLengthDays, 0)
    If BarsFromSessStart >= offset Then
        ' all required Bars are in this session
        'proposedStart = datumBarStart - offset * BarLengthDays
        proposedStart = lSessTimes.StartTime + (BarsFromSessStart - offset) * BarLengthDays
    Else
        remainingOffset = offset - BarsFromSessStart
        proposedStart = lSessTimes.StartTime
        Do While remainingOffset > 0
            lSessTimes = gCalcSessionTimes(proposedStart - 1, _
                                SessionStartTime, _
                                SessionEndTime)
            
            If numBarsInSession >= remainingOffset Then
                proposedStart = lSessTimes.StartTime + (numBarsInSession - remainingOffset) * BarLengthDays
                remainingOffset = 0
            Else
                proposedStart = lSessTimes.StartTime
                remainingOffset = remainingOffset - numBarsInSession
            End If
        Loop
    End If
End If

gCalcOffsetBarStartTime = gBarStartTime(proposedStart, _
                                        BarTimePeriod, _
                                        SessionStartTime)


Exit Function

Err:
gHandleUnexpectedError pReRaise:=True, pLog:=False, pProcedureName:=ProcName, pModuleName:=ModuleName, pFailpoint:=failpoint

End Function

Public Function gCalcOffsetSessionTimes( _
                ByVal Timestamp As Date, _
                ByVal offset As Long, _
                ByVal StartTime As Date, _
                ByVal EndTime As Date) As SessionTimes
Const ProcName As String = "gCalcOffsetSessionTimes"
Dim failpoint As String
On Error GoTo Err

Dim datumSessionTimes As SessionTimes
Dim targetWorkingDayNum As Long

datumSessionTimes = gCalcSessionTimes(Timestamp, StartTime, EndTime)

targetWorkingDayNum = WorkingDayNumber(datumSessionTimes.StartTime) + offset

gCalcOffsetSessionTimes = gCalcSessionTimes(WorkingDayDate(targetWorkingDayNum, datumSessionTimes.StartTime), _
                                            StartTime, _
                                            EndTime)

Exit Function

Err:
gHandleUnexpectedError pReRaise:=True, pLog:=False, pProcedureName:=ProcName, pModuleName:=ModuleName, pFailpoint:=failpoint
                
End Function

' !!!!!!!!!!!!!!!!!!!!!!!!!!!
' calcSessionTimes needs to be amended
' to take acCount of holidays
Public Function gCalcSessionTimes( _
                ByVal Timestamp As Date, _
                ByVal StartTime As Date, _
                ByVal EndTime As Date) As SessionTimes
Dim weekday As Long

Const ProcName As String = "gCalcSessionTimes"
Dim failpoint As String
On Error GoTo Err

calcSessionTimesHelper Timestamp, _
                        StartTime, _
                        EndTime, _
                        gCalcSessionTimes.StartTime, _
                        gCalcSessionTimes.EndTime

weekday = DatePart("w", gCalcSessionTimes.StartTime)
If StartTime > EndTime Then
    ' session DOES span midnight
    If weekday = vbFriday Then
        gCalcSessionTimes.StartTime = gCalcSessionTimes.StartTime + 2
        gCalcSessionTimes.EndTime = gCalcSessionTimes.EndTime + 2
    ElseIf weekday = vbSaturday Then
        gCalcSessionTimes.StartTime = gCalcSessionTimes.StartTime + 1
        gCalcSessionTimes.EndTime = gCalcSessionTimes.EndTime + 1
    End If
Else
    ' session doesn't span midnight or 24-hour session or no session times known
    If weekday = vbSunday Then
        gCalcSessionTimes.StartTime = gCalcSessionTimes.StartTime - 2
        gCalcSessionTimes.EndTime = gCalcSessionTimes.EndTime - 2
    ElseIf weekday = vbSaturday Then
        gCalcSessionTimes.StartTime = gCalcSessionTimes.StartTime - 1
        gCalcSessionTimes.EndTime = gCalcSessionTimes.EndTime - 1
    End If
End If

Exit Function

Err:
gHandleUnexpectedError pReRaise:=True, pLog:=False, pProcedureName:=ProcName, pModuleName:=ModuleName, pFailpoint:=failpoint

End Function

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

Public Function gNormaliseTime( _
            ByVal Timestamp As Date) As Date
gNormaliseTime = Timestamp - Int(Timestamp)
End Function

Public Sub gSetVariant(ByRef pTarget As Variant, ByRef pSource As Variant)
If IsObject(pSource) Then
    Set pTarget = pSource
Else
    pTarget = pSource
End If
End Sub

'@================================================================================
' Helper Functions
'@================================================================================

Private Function calcOffsetDailyBarStartTime( _
                ByVal Timestamp As Date, _
                ByVal BarLength As Long, _
                ByVal offset As Long, _
                ByVal SessionStartTime As Date) As Date
Dim datumBarStart As Date
Dim targetWorkingDayNum As Long

Const ProcName As String = "calcOffsetDailyBarStartTime"
Dim failpoint As String
On Error GoTo Err

datumBarStart = gBarStartTime(Timestamp, GetTimePeriod(BarLength, TimePeriodDay), SessionStartTime)

targetWorkingDayNum = WorkingDayNumber(datumBarStart) + offset * BarLength

calcOffsetDailyBarStartTime = WorkingDayDate(targetWorkingDayNum, datumBarStart)

Exit Function

Err:
gHandleUnexpectedError pReRaise:=True, pLog:=False, pProcedureName:=ProcName, pModuleName:=ModuleName, pFailpoint:=failpoint
End Function

Private Function calcOffsetMonthlyBarStartTime( _
                ByVal Timestamp As Date, _
                ByVal BarLength As Long, _
                ByVal offset As Long, _
                ByVal SessionStartTime As Date) As Date
Dim datumBarStart As Date

Const ProcName As String = "calcOffsetMonthlyBarStartTime"
Dim failpoint As String
On Error GoTo Err

datumBarStart = gBarStartTime(Timestamp, GetTimePeriod(BarLength, TimePeriodMonth), SessionStartTime)

calcOffsetMonthlyBarStartTime = DateAdd("m", offset * BarLength, datumBarStart)

Exit Function

Err:
gHandleUnexpectedError pReRaise:=True, pLog:=False, pProcedureName:=ProcName, pModuleName:=ModuleName, pFailpoint:=failpoint
End Function

Private Function calcOffsetWeeklyBarStartTime( _
                ByVal Timestamp As Date, _
                ByVal BarLength As Long, _
                ByVal offset As Long, _
                ByVal SessionStartTime As Date) As Date
Dim datumBarStart As Date
Dim datumWeekNumber As Long
Dim yearStart As Date
Dim yearEnd As Date
Dim yearEndWeekNumber As Long
Dim proposedWeekNumber As Long

Const ProcName As String = "calcOffsetWeeklyBarStartTime"
Dim failpoint As String
On Error GoTo Err

datumBarStart = gBarStartTime(Timestamp, GetTimePeriod(BarLength, TimePeriodWeek), SessionStartTime)
datumWeekNumber = DatePart("ww", datumBarStart, vbMonday, vbFirstFullWeek)

yearStart = DateAdd("d", 1 - DatePart("y", datumBarStart), datumBarStart)
yearEnd = DateAdd("yyyy", 1, yearStart - 1)
yearEndWeekNumber = DatePart("ww", yearEnd, vbMonday, vbFirstFullWeek)

proposedWeekNumber = datumWeekNumber + offset * BarLength

Do While proposedWeekNumber < 1 Or proposedWeekNumber > yearEndWeekNumber
    If proposedWeekNumber < 1 Then
        offset = offset + Int(datumWeekNumber / BarLength) + 1
        yearEnd = yearStart - 1
        yearStart = DateAdd("yyyy", -1, yearStart)
        yearEndWeekNumber = DatePart("ww", yearEnd, vbMonday, vbFirstFullWeek)
        datumBarStart = gBarStartTime(yearEnd, GetTimePeriod(BarLength, TimePeriodWeek), SessionStartTime)
        datumWeekNumber = DatePart("ww", datumBarStart, vbMonday, vbFirstFullWeek)
        
        proposedWeekNumber = datumWeekNumber + offset * BarLength
        
    ElseIf proposedWeekNumber > yearEndWeekNumber Then
        offset = offset - Int(yearEndWeekNumber - datumWeekNumber) / BarLength - 1
        yearStart = yearEnd + 1
        yearEnd = DateAdd("yyyy", 1, yearEnd)
        yearEndWeekNumber = DatePart("ww", yearEnd, vbMonday, vbFirstFullWeek)
        'datumBarStart = gCalcWeekStartDate(1, yearStart)
        'datumWeekNumber = DatePart("ww", datumBarStart, vbMonday, vbFirstFullWeek)
        datumWeekNumber = 1
        
        proposedWeekNumber = datumWeekNumber + offset * BarLength
        
    End If
    
Loop

calcOffsetWeeklyBarStartTime = WeekStartDateFromWeekNumber(proposedWeekNumber, yearStart)

Exit Function

Err:
gHandleUnexpectedError pReRaise:=True, pLog:=False, pProcedureName:=ProcName, pModuleName:=ModuleName, pFailpoint:=failpoint
End Function


Private Function calcOffsetYearlyBarStartTime( _
                ByVal Timestamp As Date, _
                ByVal BarLength As Long, _
                ByVal offset As Long, _
                ByVal SessionStartTime As Date) As Date
Dim datumBarStart As Date

Const ProcName As String = "calcOffsetYearlyBarStartTime"
Dim failpoint As String
On Error GoTo Err

datumBarStart = gBarStartTime(Timestamp, GetTimePeriod(BarLength, TimePeriodYear), SessionStartTime)

calcOffsetYearlyBarStartTime = DateAdd("yyyy", offset * BarLength, datumBarStart)

Exit Function

Err:
gHandleUnexpectedError pReRaise:=True, pLog:=False, pProcedureName:=ProcName, pModuleName:=ModuleName, pFailpoint:=failpoint
End Function

Private Sub calcSessionTimesHelper( _
                ByVal Timestamp As Date, _
                ByVal StartTime As Date, _
                ByVal EndTime As Date, _
                ByRef SessionStartTime As Date, _
                ByRef SessionEndTime As Date)
Dim referenceDate As Date
Dim referenceTime As Date

Const ProcName As String = "calcSessionTimesHelper"
Dim failpoint As String
On Error GoTo Err

referenceDate = DateValue(Timestamp)
referenceTime = TimeValue(Timestamp)

If referenceTime < StartTime Then
    SessionStartTime = referenceDate - 1 + StartTime
    SessionEndTime = referenceDate - 1 + EndTime
Else
    SessionStartTime = referenceDate + StartTime
    SessionEndTime = referenceDate + EndTime
End If

'If startTime < endTime Then
'    ' session doesn't span midnight
'    If referenceTime < endTime Then
'        SessionStartTime = referenceDate + startTime
'        SessionEndTime = referenceDate + endTime
'    Else
'        SessionStartTime = referenceDate + 1 + startTime
'        SessionEndTime = referenceDate + 1 + endTime
'    End If
'ElseIf startTime > endTime Then
'    ' session spans midnight
'    If referenceTime >= endTime Then
'        SessionStartTime = referenceDate + startTime
'        SessionEndTime = referenceDate + 1 + endTime
'    Else
'        SessionStartTime = referenceDate - 1 + startTime
'        SessionEndTime = referenceDate + endTime
'    End If
'Else
'    ' this instrument trades 24hrs, or the caller doesn't know
'    ' the session start and end times
'    SessionStartTime = referenceDate
'    SessionEndTime = referenceDate + 1
'End If

Exit Sub

Err:
gHandleUnexpectedError pReRaise:=True, pLog:=False, pProcedureName:=ProcName, pModuleName:=ModuleName, pFailpoint:=failpoint

End Sub

