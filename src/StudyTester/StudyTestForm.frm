VERSION 5.00
Object = "{5E9E78A0-531B-11CF-91F6-C2863C385E30}#1.0#0"; "msflxgrd.ocx"
Object = "{BDC217C8-ED16-11CD-956C-0000C04E4C0A}#1.1#0"; "TABCTL32.OCX"
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "COMDLG32.OCX"
Object = "{6F9EA9CF-F55B-4AFA-8431-9ECC5BED8D43}#124.0#0"; "StudiesUI2-6.ocx"
Object = "{74951842-2BEF-4829-A34F-DC7795A37167}#110.0#0"; "ChartSkil2-6.ocx"
Begin VB.Form StudyTestForm 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "TradeBuild Study Test Harness v2.6"
   ClientHeight    =   10365
   ClientLeft      =   5070
   ClientTop       =   3540
   ClientWidth     =   12840
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   10365
   ScaleWidth      =   12840
   Begin VB.CommandButton TestButton 
      Caption         =   "Test"
      Enabled         =   0   'False
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   12
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   735
      Left            =   11640
      TabIndex        =   11
      ToolTipText     =   "Test the study"
      Top             =   120
      Width           =   1095
   End
   Begin TabDlg.SSTab SSTab1 
      Height          =   9255
      Left            =   120
      TabIndex        =   12
      Top             =   960
      Width           =   12615
      _ExtentX        =   22251
      _ExtentY        =   16325
      _Version        =   393216
      TabHeight       =   520
      BackColor       =   2
      TabCaption(0)   =   "&Test data and results"
      TabPicture(0)   =   "StudyTestForm.frx":0000
      Tab(0).ControlEnabled=   -1  'True
      Tab(0).Control(0)=   "Label4"
      Tab(0).Control(0).Enabled=   0   'False
      Tab(0).Control(1)=   "Label13"
      Tab(0).Control(1).Enabled=   0   'False
      Tab(0).Control(2)=   "TestDataGrid"
      Tab(0).Control(2).Enabled=   0   'False
      Tab(0).Control(3)=   "TestDataFilenameText"
      Tab(0).Control(3).Enabled=   0   'False
      Tab(0).Control(4)=   "FindFileButton"
      Tab(0).Control(4).Enabled=   0   'False
      Tab(0).Control(5)=   "MinimumPriceTickText"
      Tab(0).Control(5).Enabled=   0   'False
      Tab(0).ControlCount=   6
      TabCaption(1)   =   "Study setup"
      TabPicture(1)   =   "StudyTestForm.frx":001C
      Tab(1).ControlEnabled=   0   'False
      Tab(1).Control(0)=   "StudyConfigurer1"
      Tab(1).Control(1)=   "SetStudyLibraryButton"
      Tab(1).Control(2)=   "RemoveLibButton"
      Tab(1).Control(3)=   "StudyLibraryList"
      Tab(1).Control(4)=   "AddLibButton"
      Tab(1).Control(5)=   "LibToAddText"
      Tab(1).Control(6)=   "StudyLibraryClassNameText"
      Tab(1).Control(7)=   "StudiesCombo"
      Tab(1).Control(8)=   "Label19"
      Tab(1).Control(9)=   "Label1"
      Tab(1).Control(10)=   "Label3"
      Tab(1).Control(11)=   "Label2"
      Tab(1).ControlCount=   12
      TabCaption(2)   =   "&Chart"
      TabPicture(2)   =   "StudyTestForm.frx":0038
      Tab(2).ControlEnabled=   0   'False
      Tab(2).Control(0)=   "Chart1"
      Tab(2).Control(0).Enabled=   0   'False
      Tab(2).ControlCount=   1
      Begin ChartSkil26.Chart Chart1 
         Height          =   8775
         Left            =   -74880
         TabIndex        =   20
         Top             =   360
         Width           =   12375
         _ExtentX        =   21828
         _ExtentY        =   15478
         ChartBackColor  =   6566450
      End
      Begin StudiesUI26.StudyConfigurer StudyConfigurer1 
         Height          =   5655
         Left            =   -74760
         TabIndex        =   19
         Top             =   3480
         Width           =   12255
         _ExtentX        =   21616
         _ExtentY        =   9975
      End
      Begin VB.TextBox MinimumPriceTickText 
         Height          =   285
         Left            =   9480
         TabIndex        =   2
         Text            =   "0.0"
         Top             =   840
         Width           =   1335
      End
      Begin VB.CommandButton SetStudyLibraryButton 
         Caption         =   "Set"
         Enabled         =   0   'False
         Height          =   375
         Left            =   -68640
         TabIndex        =   4
         ToolTipText     =   "Click to load your service provider"
         Top             =   540
         Width           =   855
      End
      Begin VB.CommandButton RemoveLibButton 
         Caption         =   "Remove"
         Enabled         =   0   'False
         Height          =   375
         Left            =   -68640
         TabIndex        =   9
         ToolTipText     =   "Remove the selected service provider from the list"
         Top             =   2340
         Width           =   855
      End
      Begin VB.ListBox StudyLibraryList 
         Height          =   840
         ItemData        =   "StudyTestForm.frx":0054
         Left            =   -72600
         List            =   "StudyTestForm.frx":0056
         TabIndex        =   8
         ToolTipText     =   "Lists all studies service providers you need (except the built-in studies service provider)"
         Top             =   2340
         Width           =   3975
      End
      Begin VB.CommandButton AddLibButton 
         Caption         =   "Add"
         Enabled         =   0   'False
         Height          =   375
         Left            =   -68640
         TabIndex        =   7
         ToolTipText     =   "Add this service provider to the list"
         Top             =   1860
         Width           =   855
      End
      Begin VB.TextBox LibToAddText 
         Height          =   285
         Left            =   -72600
         TabIndex        =   6
         ToolTipText     =   "Enter the program id of any other studies service provider your service provider needs"
         Top             =   1860
         Width           =   3975
      End
      Begin VB.TextBox StudyLibraryClassNameText 
         Height          =   285
         Left            =   -72600
         TabIndex        =   3
         ToolTipText     =   "Enter your service provider's program id in the form project.class"
         Top             =   540
         Width           =   3975
      End
      Begin VB.ComboBox StudiesCombo 
         Enabled         =   0   'False
         Height          =   315
         Left            =   -72600
         TabIndex        =   5
         ToolTipText     =   "Select the study to test"
         Top             =   1020
         Width           =   3975
      End
      Begin VB.CommandButton FindFileButton 
         Caption         =   "..."
         Height          =   285
         Left            =   6720
         TabIndex        =   1
         ToolTipText     =   "Click to browse for the test data file"
         Top             =   840
         Width           =   375
      End
      Begin VB.TextBox TestDataFilenameText 
         Height          =   285
         Left            =   120
         Locked          =   -1  'True
         TabIndex        =   0
         ToolTipText     =   "The file that contains the test data"
         Top             =   840
         Width           =   6615
      End
      Begin MSFlexGridLib.MSFlexGrid TestDataGrid 
         Height          =   7935
         Left            =   120
         TabIndex        =   13
         TabStop         =   0   'False
         Top             =   1260
         Width           =   12375
         _ExtentX        =   21828
         _ExtentY        =   13996
         _Version        =   393216
         Cols            =   6
         FixedCols       =   0
         BackColorBkg    =   -2147483636
         Appearance      =   0
      End
      Begin VB.Label Label13 
         Alignment       =   1  'Right Justify
         Caption         =   "Minimum price tick"
         Height          =   255
         Left            =   7920
         TabIndex        =   18
         Top             =   840
         Width           =   1455
      End
      Begin VB.Label Label19 
         Caption         =   "Configure the study - selected output values will appear both on the chart and in the grid"
         Height          =   375
         Left            =   -74760
         TabIndex        =   10
         Top             =   3240
         Width           =   11655
      End
      Begin VB.Label Label1 
         Caption         =   "Other study libraries to include"
         Height          =   615
         Left            =   -74760
         TabIndex        =   17
         Top             =   1860
         Width           =   2055
      End
      Begin VB.Label Label4 
         Caption         =   "Test data file"
         Height          =   255
         Left            =   120
         TabIndex        =   16
         Top             =   540
         Width           =   1455
      End
      Begin VB.Label Label3 
         Caption         =   "Program id for Study Library under test"
         Height          =   375
         Left            =   -74760
         TabIndex        =   15
         Top             =   540
         Width           =   2175
      End
      Begin VB.Label Label2 
         Caption         =   "Study to test"
         Height          =   375
         Left            =   -74760
         TabIndex        =   14
         Top             =   1080
         Width           =   1695
      End
   End
   Begin MSComDlg.CommonDialog CommonDialog1 
      Left            =   0
      Top             =   0
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
   End
End
Attribute VB_Name = "StudyTestForm"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

'================================================================================
' Description
'================================================================================
'
'

'================================================================================
' Interfaces
'================================================================================

                                    
'================================================================================
' Events
'================================================================================

'================================================================================
' Constants
'================================================================================

Private Const CellBackColorOdd As Long = &HF8F8F8
Private Const CellBackColorEven As Long = &HEEEEEE

Private Const PriceRegionName As String = "$price"
Private Const VolumeRegionName As String = "$volume"

Private Const TestDataGridRowsInitial As Long = 50
Private Const TestDataGridRowsIncrement As Long = 25

Private Const InputValuePrice As String = "Price"
Private Const InputValueVolume As String = "Total volume"

'================================================================================
' Enums
'================================================================================

Private Enum TestDataFileColumns
    timestamp
    OpenValue
    HighValue
    LowValue
    CloseValue
    Volume
End Enum

Private Enum TestDataGridColumns
    timestamp
    OpenValue
    HighValue
    LowValue
    CloseValue
    Volume
    StudyValue1
End Enum

' Character widths of the TestDataGrid columns
Private Enum TestDataGridColumnWidths
    TimeStampWidth = 19
    openValueWidth = 9
    highValueWidth = 9
    lowValueWidth = 9
    closeValueWidth = 9
    volumeWidth = 9
    StudyValue1Width = 20
End Enum

'================================================================================
' Types
'================================================================================

'================================================================================
' External function declarations
'================================================================================

'================================================================================
' Member variables
'================================================================================

Private mLetterWidth As Single
Private mDigitWidth As Single

Private mStudyParams As Parameters

Private mIsDataLoaded As Boolean
Private mIsStudySet As Boolean

Private mName As String

'Private mStudyLibrary As StudyLibrary

Private mStudyDefinition As StudyDefinition

Private mChartManager As ChartManager
Private mStudyManager As StudyManager
Private mSourceStudy As study
Private mBarsStudy As study
Private mInitialStudyConfigs As StudyConfigurations

Private mPriceInputHandle As Long
Private mVolumeInputHandle As Long

Private mPeriodLength As Long
Private mPeriodUnits As TimePeriodUnits

'================================================================================
' Form Event Handlers
'================================================================================

Private Sub Form_Initialize()
InitCommonControls  ' enables WinXP look and feel
InitialiseTWUtilities
End Sub

Private Sub Form_Load()
Dim widthString As String

mName = "TradeBuild Study Test Harness"

widthString = "ABCDEFGH IJKLMNOP QRST UVWX YZ"
mLetterWidth = Me.TextWidth(widthString) / Len(widthString)
widthString = ".0123456789"
mDigitWidth = Me.TextWidth(widthString) / Len(widthString)

setupTestDataGrid

AddStudyLibrary "CmnStudiesLib26.StudyLib", True

' need to do this in case the user sets up his Study Library and study
' before loading the test data
setupInitialStudies

End Sub

Private Sub Form_Terminate()
TerminateTWUtilities
End Sub

'================================================================================
' Control Event Handlers
'================================================================================

Private Sub AddLibButton_Click()
StudyLibraryList.AddItem LibToAddText
StudyLibraryList.ListIndex = StudyLibraryList.ListCount - 1
LibToAddText = ""
End Sub

Private Sub FindFileButton_Click()

CommonDialog1.CancelError = True
On Error GoTo err

CommonDialog1.MaxFileSize = 32767
CommonDialog1.DialogTitle = "Open test data file"
CommonDialog1.Filter = "TradeBuild bar data files (*.tbd)|*.tbd"
CommonDialog1.FilterIndex = 1
CommonDialog1.Flags = cdlOFNFileMustExist + _
                    cdlOFNLongNames + _
                    cdlOFNPathMustExist + _
                    cdlOFNExplorer + _
                    cdlOFNReadOnly
CommonDialog1.ShowOpen

TestDataFilenameText = CommonDialog1.FileName

LoadData

err:
End Sub

Private Sub MinimumPriceTickText_KeyPress(KeyAscii As Integer)
If KeyAscii = vbKeyBack Or KeyAscii = vbKeyReturn Then Exit Sub
If Not IsNumeric(MinimumPriceTickText & Chr(KeyAscii)) Then KeyAscii = 0
End Sub

Private Sub RemoveLibButton_Click()
StudyLibraryList.RemoveItem StudyLibraryList.ListIndex
RemoveLibButton.Enabled = False
End Sub

Private Sub StudyLibraryClassNameText_Change()
If StudyLibraryClassNameText = "" Then
    SetStudyLibraryButton.Enabled = False
Else
    SetStudyLibraryButton.Enabled = True
End If
End Sub

Private Sub SetStudyLibraryButton_Click()
Dim availableStudies() As String
Dim lStudyLibrary As StudyLibrary
Dim i As Long

StudiesCombo.Clear
StudyConfigurer1.Clear
Set mStudyDefinition = Nothing
mIsStudySet = False
TestButton.Enabled = False
TestDataGrid.Cols = TestDataGridColumns.StudyValue1

If StudyLibraryClassNameText = "" Then
    StudiesCombo.Enabled = False
    Exit Sub
End If

RemoveAllStudyLibraries
On Error Resume Next
Set lStudyLibrary = AddStudyLibrary(StudyLibraryClassNameText, True)
On Error GoTo 0
If lStudyLibrary Is Nothing Then
    StudiesCombo.Enabled = False
    MsgBox StudyLibraryClassNameText & " is not a valid Study Library"
    Exit Sub
End If

StudiesCombo.Enabled = True
availableStudies = lStudyLibrary.GetImplementedStudyNames
For i = 0 To UBound(availableStudies)
    StudiesCombo.AddItem availableStudies(i)
Next

End Sub

Private Sub StudyLibraryList_Click()
If StudyLibraryList.ListIndex = -1 Then
    RemoveLibButton.Enabled = False
Else
    RemoveLibButton.Enabled = True
End If
End Sub

Private Sub LibToAddText_Change()
If LibToAddText = "" Then
    AddLibButton.Enabled = False
Else
    AddLibButton.Enabled = True
End If
End Sub

Private Sub StudiesCombo_Click()
Dim regionNames(1) As String

addStudyLibraries

setupInitialStudies
                    
Set mStudyParams = GetStudyDefaultParameters(StudiesCombo)

regionNames(0) = PriceRegionName
regionNames(1) = VolumeRegionName

Set mStudyDefinition = GetStudyDefinition(StudiesCombo)

StudyConfigurer1.Initialise Chart1, _
                            mStudyDefinition, _
                            "", _
                            regionNames, _
                            mInitialStudyConfigs, _
                            Nothing, _
                            mStudyParams, _
                            False
mIsStudySet = True
If mIsDataLoaded Then TestButton.Enabled = True
End Sub

Private Sub TestButton_Click()
Dim i As Long
Dim when As String
Dim volumeThisBar As Long
Dim timestamp As Date
Dim testStudy As study
Dim testStudyConfig As StudyConfiguration
Dim accumVolume As Long
Dim addTestStudyToSource As Boolean
Dim regionNames(1) As String

On Error GoTo err
Screen.MousePointer = MousePointerConstants.vbArrowHourglass

when = "adding study libraries"
addStudyLibraries

Set testStudyConfig = StudyConfigurer1.StudyConfiguration
If testStudyConfig.UnderlyingStudy Is mSourceStudy Then
    addTestStudyToSource = True
End If

when = "creating the study to be tested"

setupInitialStudies

If addTestStudyToSource Then
    testStudyConfig.UnderlyingStudy = mSourceStudy
Else
    testStudyConfig.UnderlyingStudy = mBarsStudy
End If

Set testStudy = mChartManager.AddStudyConfiguration(testStudyConfig)
mChartManager.StartStudy testStudy

' now re-setup the study configurer so that only current
' objects are referenced
regionNames(0) = PriceRegionName
regionNames(1) = VolumeRegionName
StudyConfigurer1.Initialise Chart1, _
                            mStudyDefinition, _
                            "", _
                            regionNames, _
                            mInitialStudyConfigs, _
                            testStudyConfig, _
                            mStudyParams, _
                            False

when = "setting up the Study Value grid"
setupStudyValueGridColumns testStudyConfig

Chart1.DisableDrawing
For i = 1 To TestDataGrid.Rows
    TestDataGrid.row = i
    TestDataGrid.Col = TestDataGridColumns.timestamp
    If TestDataGrid.Text = "" Then Exit For
    timestamp = CDate(TestDataGrid.Text)
    
    If TestDataGrid.TextMatrix(i, TestDataGridColumns.Volume) <> "" Then
        volumeThisBar = CLng(TestDataGrid.TextMatrix(i, TestDataGridColumns.Volume))
    Else
        volumeThisBar = 0
    End If
    
    when = "notifying open value for bar " & i
    mStudyManager.NotifyInput _
                    mPriceInputHandle, _
                    CDbl(TestDataGrid.TextMatrix(i, TestDataGridColumns.OpenValue)), _
                    timestamp

    If volumeThisBar <> 0 Then
        when = "notifying volume at open for bar " & i
        accumVolume = accumVolume + Int(volumeThisBar / 4)
        mStudyManager.NotifyInput _
                        mVolumeInputHandle, _
                        accumVolume, _
                        timestamp
    End If
            
    when = "notifying high value for bar " & i
    mStudyManager.NotifyInput _
                    mPriceInputHandle, _
                    CDbl(TestDataGrid.TextMatrix(i, TestDataGridColumns.HighValue)), _
                    timestamp

    If volumeThisBar <> 0 Then
        when = "notifying volume at high for bar " & i
        accumVolume = accumVolume + Int(volumeThisBar / 4)
        mStudyManager.NotifyInput _
                        mVolumeInputHandle, _
                        accumVolume, _
                        timestamp
    End If
            
    when = "notifying low value for bar " & i
    mStudyManager.NotifyInput _
                    mPriceInputHandle, _
                    CDbl(TestDataGrid.TextMatrix(i, TestDataGridColumns.LowValue)), _
                    timestamp

    If volumeThisBar <> 0 Then
        when = "notifying volume at low for bar " & i
        accumVolume = accumVolume + Int(volumeThisBar / 4)
        mStudyManager.NotifyInput _
                        mVolumeInputHandle, _
                        accumVolume, _
                        timestamp
    End If
            
    when = "notifying close value for bar " & i
    mStudyManager.NotifyInput _
                    mPriceInputHandle, _
                    CDbl(TestDataGrid.TextMatrix(i, TestDataGridColumns.CloseValue)), _
                    timestamp

    If volumeThisBar <> 0 Then
        when = "notifying volume at low for bar " & i
        accumVolume = accumVolume + volumeThisBar - 3 * Int(volumeThisBar / 4)
        mStudyManager.NotifyInput _
                        mVolumeInputHandle, _
                        accumVolume, _
                        timestamp
    End If
    
    processStudyValues testStudy, testStudyConfig, i, when
Next

Chart1.EnableDrawing

setTestDataGridRowBackColors 1

Screen.MousePointer = MousePointerConstants.vbDefault
Exit Sub

err:
setTestDataGridRowBackColors 1

Do Until Chart1.IsDrawingEnabled
    Chart1.EnableDrawing
Loop

MsgBox "Error " & err.Number & _
        " when " & when & _
        ": " & err.Description & _
        IIf(err.Source <> "", ": " & err.Source, "")
Screen.MousePointer = MousePointerConstants.vbDefault
End Sub

'================================================================================
' XXXX Event Handlers
'================================================================================

'================================================================================
' Properties
'================================================================================

'================================================================================
' Methods
'================================================================================

'================================================================================
' Helper Functions
'================================================================================

Private Sub addStudyLibraries()
Dim i As Long

RemoveAllStudyLibraries

AddStudyLibrary "CmnStudiesLib26.StudyLib", True

For i = 0 To StudyLibraryList.ListCount - 1
    AddStudyLibrary StudyLibraryList.List(i), True
Next

If StrComp(StudyLibraryClassNameText, "CmnStudiesLib26.StudyLib", vbTextCompare) <> 0 Then
    If StudyLibraryClassNameText <> "" Then AddStudyLibrary StudyLibraryClassNameText, True
End If
End Sub

Private Function createBarsStudyConfig() As StudyConfiguration
Dim studyDef As StudyDefinition
ReDim inputValueNames(1) As String
Dim params As New Parameters
Dim studyValueConfig As StudyValueConfiguration
Dim barsStyle As BarStyle
Dim volumeStyle As DataPointStyle

Set studyDef = GetStudyDefinition("Constant time bars")

Set createBarsStudyConfig = New StudyConfiguration
createBarsStudyConfig.ChartRegionName = PriceRegionName
inputValueNames(0) = InputValuePrice
inputValueNames(1) = InputValueVolume
createBarsStudyConfig.inputValueNames = inputValueNames
createBarsStudyConfig.Name = studyDef.Name
params.SetParameterValue "Bar length", 1
params.SetParameterValue "Time units", "Minutes"
createBarsStudyConfig.Parameters = params
'createBarsStudyConfig.StudyDefinition = studyDef

Set studyValueConfig = createBarsStudyConfig.StudyValueConfigurations.Add("Bar")
studyValueConfig.ChartRegionName = PriceRegionName
studyValueConfig.IncludeInChart = True
studyValueConfig.Layer = 200
Set barsStyle = New BarStyle
barsStyle.OutlineThickness = 1
barsStyle.Thickness = 2
barsStyle.Width = 0.6
barsStyle.DisplayMode = BarDisplayModeCandlestick
barsStyle.DownColor = &H43FC2
barsStyle.SolidUpBody = True
barsStyle.TailThickness = 1
barsStyle.UpColor = &H1D9311
studyValueConfig.BarStyle = barsStyle

Set studyValueConfig = createBarsStudyConfig.StudyValueConfigurations.Add("Volume")
studyValueConfig.ChartRegionName = VolumeRegionName
studyValueConfig.IncludeInChart = True
Set volumeStyle = New DataPointStyle
volumeStyle.DownColor = vbRed
volumeStyle.UpColor = vbGreen
volumeStyle.DisplayMode = DataPointDisplayModeHistogram
volumeStyle.HistogramBarWidth = 0.7
volumeStyle.IncludeInAutoscale = True
volumeStyle.LineThickness = 1
studyValueConfig.DataPointStyle = volumeStyle
End Function

Private Sub determinePeriodParameters()
Dim fso As FileSystemObject
Dim ts As TextStream
Dim row As Long
Dim timestamp1 As Date
Dim timestamp2 As Date
Dim rec As String
Dim tokens() As String

Set fso = New FileSystemObject
Set ts = fso.OpenTextFile(TestDataFilenameText, ForReading)

Do While Not ts.AtEndOfStream
    rec = ts.ReadLine
    If rec <> "" And Left$(rec, 2) <> "//" Then
        row = row + 1
        tokens = Split(rec, ",")
        
        If row = 1 Then
            timestamp1 = CDate(tokens(TestDataFileColumns.timestamp))
        Else
            timestamp2 = CDate(tokens(TestDataFileColumns.timestamp))
            
            mPeriodUnits = TimePeriodSecond
            mPeriodLength = DateDiff("s", timestamp1, timestamp2)
            If mPeriodLength < 60 Then Exit Sub
            
            mPeriodUnits = TimePeriodMinute
            mPeriodLength = DateDiff("n", timestamp1, timestamp2)
            If mPeriodLength < 60 Then Exit Sub
            
            mPeriodUnits = TimePeriodHour
            mPeriodLength = DateDiff("h", timestamp1, timestamp2)
            If mPeriodLength < 24 Then Exit Sub
            
            mPeriodUnits = TimePeriodDay
            mPeriodLength = DateDiff("d", timestamp1, timestamp2)
            If mPeriodLength < 5 Then Exit Sub
            
            mPeriodUnits = TimePeriodWeek
            mPeriodLength = DateDiff("ww", timestamp1, timestamp2)
            If mPeriodLength < 5 Then Exit Sub
            
            mPeriodUnits = TimePeriodMonth
            mPeriodLength = DateDiff("m", timestamp1, timestamp2)
            If mPeriodLength < 12 Then Exit Sub
            
            mPeriodUnits = TimePeriodYear
            mPeriodLength = DateDiff("yyyy", timestamp1, timestamp2)
            Exit Sub
            
        End If
    End If
Loop
End Sub

Private Sub initialiseChart()
Dim regionStyle As ChartRegionStyle
Dim priceRegion As ChartRegion
Dim volumeRegion As ChartRegion


Chart1.DisableDrawing

Chart1.ClearChart
Chart1.ChartBackColor = vbWhite
Chart1.PointerStyle = PointerCrosshairs
Chart1.HorizontalScrollBarVisible = True
Chart1.BarTimePeriod = GetTimePeriod(mPeriodLength, mPeriodUnits)

Set regionStyle = New ChartRegionStyle

Set priceRegion = Chart1.Regions.Add(100, 25, regionStyle, , PriceRegionName)
priceRegion.GridlineSpacingY = 2
priceRegion.HasGrid = True
priceRegion.Title.Text = TestDataFilenameText
priceRegion.Title.Color = vbBlue

Set volumeRegion = Chart1.Regions.Add(20, , regionStyle, , VolumeRegionName)
volumeRegion.GridlineSpacingY = 0.8
volumeRegion.MinimumHeight = 10
volumeRegion.IntegerYScale = True
volumeRegion.HasGrid = True
volumeRegion.Title.Text = "Volume"
volumeRegion.Title.Color = vbBlue

Chart1.EnableDrawing
End Sub

Private Sub LoadData()
Dim fso As FileSystemObject
Dim ts As TextStream
Dim rec As String
Dim tokens() As String
Dim row As Long
Dim accumVolume As Long
Dim timestamp As Date
Dim analyzer As DataAnalyzer
Dim price As Double

On Error GoTo err

mIsDataLoaded = False
TestButton.Enabled = False

Screen.MousePointer = MousePointerConstants.vbArrowHourglass

TestDataGrid.Clear
setupTestDataGrid
TestDataGrid.Refresh
TestDataGrid.Redraw = False

addStudyLibraries

determinePeriodParameters

setupInitialStudies

Set fso = New FileSystemObject
Set ts = fso.OpenTextFile(TestDataFilenameText, ForReading)

Chart1.DisableDrawing

Set analyzer = New DataAnalyzer

Do While Not ts.AtEndOfStream
    rec = ts.ReadLine
    If rec <> "" And Left$(rec, 2) <> "//" Then
        row = row + 1
        tokens = Split(rec, ",")
        
        'update the chart
        
        timestamp = CDate(tokens(TestDataFileColumns.timestamp))
        
        price = CDbl(tokens(TestDataFileColumns.OpenValue))
        mStudyManager.NotifyInput mPriceInputHandle, _
                        price, _
                        timestamp
        analyzer.addDataValue price
        
        price = CDbl(tokens(TestDataFileColumns.HighValue))
        mStudyManager.NotifyInput mPriceInputHandle, _
                        price, _
                        timestamp
        analyzer.addDataValue price
        
        price = CDbl(tokens(TestDataFileColumns.LowValue))
        mStudyManager.NotifyInput mPriceInputHandle, _
                        price, _
                        timestamp
        analyzer.addDataValue price
        
        price = CDbl(tokens(TestDataFileColumns.CloseValue))
        mStudyManager.NotifyInput mPriceInputHandle, _
                        price, _
                        timestamp
        analyzer.addDataValue price
        
        If tokens(TestDataFileColumns.Volume) <> "" Then
            accumVolume = accumVolume + CLng(tokens(TestDataFileColumns.Volume))
            mChartManager.NotifyInput mVolumeInputHandle, _
                        accumVolume, _
                        timestamp
        End If
        
        'update the grid
        If row > TestDataGrid.Rows - 1 Then TestDataGrid.Rows = TestDataGrid.Rows + TestDataGridRowsIncrement
        TestDataGrid.row = row
        TestDataGrid.Col = TestDataGridColumns.timestamp
        TestDataGrid.Text = CDate(tokens(TestDataFileColumns.timestamp))
        TestDataGrid.Col = TestDataGridColumns.OpenValue
        TestDataGrid.Text = CDbl(tokens(TestDataFileColumns.OpenValue))
        TestDataGrid.Col = TestDataGridColumns.HighValue
        TestDataGrid.Text = CDbl(tokens(TestDataFileColumns.HighValue))
        TestDataGrid.Col = TestDataGridColumns.LowValue
        TestDataGrid.Text = CDbl(tokens(TestDataFileColumns.LowValue))
        TestDataGrid.Col = TestDataGridColumns.CloseValue
        TestDataGrid.Text = CDbl(tokens(TestDataFileColumns.CloseValue))
        If tokens(TestDataFileColumns.Volume) <> "" Then
            TestDataGrid.Col = TestDataGridColumns.Volume
            TestDataGrid.Text = CLng(tokens(TestDataFileColumns.Volume))
        End If
    End If
    
Loop

TestDataGrid.Redraw = True
setTestDataGridRowBackColors 1
Chart1.EnableDrawing

analyzer.analyze
MinimumPriceTickText = Format(analyzer.minimumDifference, "0.00000")

Screen.MousePointer = MousePointerConstants.vbDefault

mIsDataLoaded = True
If mIsStudySet Then TestButton.Enabled = True

Exit Sub

err:
TestDataGrid.Redraw = True
setTestDataGridRowBackColors 1
Chart1.EnableDrawing

Screen.MousePointer = MousePointerConstants.vbDefault

MsgBox "Can't load data file: " & TestDataFilenameText & vbCrLf & _
        "Error " & err.Number & ": " & err.Description
End Sub

Private Sub processStudyValues( _
                ByVal study As study, _
                ByVal studyConfig As StudyConfiguration, _
                ByVal row As Long, _
                ByRef when As String)
Dim svd As StudyValueDefinition
Dim svc As StudyValueConfiguration
Dim lStudyValue As SValue
Dim i As Long
Dim j As Long
Dim lLine As StudyLine
Dim lBar As timeframeutils26.Bar
Dim lText As StudyText

For i = 1 To studyConfig.StudyValueConfigurations.Count
    Set svc = studyConfig.StudyValueConfigurations.Item(i)
    If svc.IncludeInChart Then
        Set svd = studyConfig.study.StudyDefinition.StudyValueDefinitions.Item(svc.ValueName)
        when = "getting value for " & svc.ValueName & " for bar " & row
        lStudyValue = study.GetStudyValue(svc.ValueName, 0)
        
        Select Case svd.ValueMode
        Case ValueModeNone
            TestDataGrid.TextMatrix(row, TestDataGridColumns.StudyValue1 + j) = lStudyValue.value
        Case ValueModeLine
            Set lLine = lStudyValue.value
            If Not lLine Is Nothing Then
                TestDataGrid.TextMatrix(row, TestDataGridColumns.StudyValue1 + j) = _
                        "(" & lLine.Point1.x & "," & lLine.Point1.y & ")-" & _
                        "(" & lLine.Point2.x & "," & lLine.Point2.y & ")"
            End If
        Case ValueModeBar
            Set lBar = lStudyValue.value
            If Not lBar Is Nothing Then
                TestDataGrid.TextMatrix(row, TestDataGridColumns.StudyValue1 + j) = _
                        lBar.OpenValue & "," & _
                        lBar.HighValue & "," & _
                        lBar.LowValue & "," & _
                        lBar.CloseValue
            End If
        Case ValueModeText
            Set lText = lStudyValue.value
            If Not lText Is Nothing Then
                TestDataGrid.TextMatrix(row, TestDataGridColumns.StudyValue1 + j) = _
                        "(" & lText.Position.x & "," & lText.Position.y & ")," & _
                        """" & lText.Text & """"
            End If
        End Select
        
        j = j + 1
    End If
Next

End Sub

Private Sub setTestDataGridRowBackColors( _
                ByVal startingIndex As Long)
Dim i As Long

TestDataGrid.Redraw = False

For i = startingIndex To TestDataGrid.Rows - 1
    TestDataGrid.row = i
    TestDataGrid.Col = 0
    TestDataGrid.RowSel = i
    TestDataGrid.ColSel = TestDataGrid.Cols - 1
    TestDataGrid.CellBackColor = IIf(i Mod 2 = 0, CellBackColorEven, CellBackColorOdd)
    
Next

TestDataGrid.Redraw = True
End Sub

Private Sub setupInitialStudies()
Dim studyConfig As StudyConfiguration

Set mStudyManager = New StudyManager
Set mChartManager = CreateChartManager(mStudyManager, Chart1)

initialiseChart

Set mSourceStudy = mStudyManager.AddSource(IIf(TestDataFilenameText = "", _
                                                "Test data", _
                                                TestDataFilenameText))

mPriceInputHandle = mStudyManager.AddInput(mSourceStudy, _
                        InputValuePrice, _
                        "Price", _
                        InputTypeReal, _
                        True, _
                        MinimumPriceTickText)
mChartManager.SetInputRegion mPriceInputHandle, PriceRegionName

mVolumeInputHandle = mStudyManager.AddInput(mSourceStudy, _
                        InputValueVolume, _
                        "Volume", _
                        InputTypeInteger, _
                        False, _
                        1)
mChartManager.SetInputRegion mVolumeInputHandle, VolumeRegionName

Set studyConfig = createBarsStudyConfig
studyConfig.UnderlyingStudy = mSourceStudy
Set mBarsStudy = mStudyManager.AddStudy(studyConfig.Name, mSourceStudy, studyConfig.inputValueNames, studyConfig.Parameters, studyConfig.StudyLibraryName)
studyConfig.study = mBarsStudy
mChartManager.StartStudy mBarsStudy

mChartManager.BaseStudyConfiguration = studyConfig

Set mInitialStudyConfigs = New StudyConfigurations
mInitialStudyConfigs.Add mChartManager.BaseStudyConfiguration
End Sub

Private Sub setupStudyValueGridColumns( _
                ByVal studyConfig As StudyConfiguration)
Dim svd As StudyValueDefinition
Dim svc As StudyValueConfiguration
Dim i As Long
Dim j As Long

' remove any existing study value columns
TestDataGrid.Cols = TestDataGridColumns.StudyValue1

For i = 1 To studyConfig.StudyValueConfigurations.Count
    Set svc = studyConfig.StudyValueConfigurations.Item(i)
    If svc.IncludeInChart Then
        Set svd = studyConfig.study.StudyDefinition.StudyValueDefinitions.Item(svc.ValueName)
        setupTestDataGridColumn TestDataGridColumns.StudyValue1 + j, _
                                TestDataGridColumnWidths.StudyValue1Width, _
                                svd.Name, _
                                IIf(svd.valueType = ValueTypeString, True, False), _
                                IIf(svd.valueType = ValueTypeString, AlignmentSettings.flexAlignLeftCenter, AlignmentSettings.flexAlignRightCenter)
        j = j + 1
    End If
Next

End Sub

Private Sub setupTestDataGrid()

With TestDataGrid
    .AllowBigSelection = True
    .AllowUserResizing = flexResizeBoth
    .FillStyle = flexFillRepeat
    .FocusRect = flexFocusNone
    .HighLight = flexHighlightNever
    
    .Cols = TestDataGridColumns.StudyValue1
    .Rows = TestDataGridRowsInitial
    .FixedRows = 1
    .FixedCols = 0
End With
    
setupTestDataGridColumn TestDataGridColumns.timestamp, TestDataGridColumnWidths.TimeStampWidth, "Timestamp", False, AlignmentSettings.flexAlignLeftCenter
setupTestDataGridColumn TestDataGridColumns.OpenValue, TestDataGridColumnWidths.openValueWidth, "Open", False, AlignmentSettings.flexAlignRightCenter
setupTestDataGridColumn TestDataGridColumns.HighValue, TestDataGridColumnWidths.highValueWidth, "High", False, AlignmentSettings.flexAlignRightCenter
setupTestDataGridColumn TestDataGridColumns.LowValue, TestDataGridColumnWidths.lowValueWidth, "Low", False, AlignmentSettings.flexAlignRightCenter
setupTestDataGridColumn TestDataGridColumns.CloseValue, TestDataGridColumnWidths.closeValueWidth, "Close", False, AlignmentSettings.flexAlignRightCenter
setupTestDataGridColumn TestDataGridColumns.Volume, TestDataGridColumnWidths.volumeWidth, "Volume", False, AlignmentSettings.flexAlignRightCenter

setTestDataGridRowBackColors 1
End Sub

Private Sub setupTestDataGridColumn( _
                ByVal columnNumber As Long, _
                ByVal columnWidth As Single, _
                ByVal columnHeader As String, _
                ByVal isLetters As Boolean, _
                ByVal align As AlignmentSettings)
    
Dim lColumnWidth As Long

With TestDataGrid
    If (columnNumber + 1) > .Cols Then
        .Cols = columnNumber + 1
        .ColWidth(columnNumber) = 0
    End If
    
    If isLetters Then
        lColumnWidth = mLetterWidth * columnWidth
    Else
        lColumnWidth = mDigitWidth * columnWidth
    End If
    
    .ColWidth(columnNumber) = lColumnWidth
    
    .ColAlignment(columnNumber) = align
    .TextMatrix(0, columnNumber) = columnHeader
End With
End Sub
                

