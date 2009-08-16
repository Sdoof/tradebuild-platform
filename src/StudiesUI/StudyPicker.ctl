VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCTL.OCX"
Begin VB.UserControl StudyPicker 
   ClientHeight    =   4335
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   8655
   ScaleHeight     =   4335
   ScaleWidth      =   8655
   Begin MSComctlLib.TreeView ChartStudiesTree 
      Height          =   2535
      Left            =   3840
      TabIndex        =   9
      Top             =   360
      Width           =   4695
      _ExtentX        =   8281
      _ExtentY        =   4471
      _Version        =   393217
      HideSelection   =   0   'False
      LabelEdit       =   1
      SingleSel       =   -1  'True
      Appearance      =   0
   End
   Begin VB.ListBox StudyList 
      Height          =   2595
      ItemData        =   "StudyPicker.ctx":0000
      Left            =   120
      List            =   "StudyPicker.ctx":0002
      TabIndex        =   5
      Top             =   360
      Width           =   3135
   End
   Begin VB.TextBox DescriptionText 
      Height          =   735
      Left            =   120
      Locked          =   -1  'True
      MultiLine       =   -1  'True
      ScrollBars      =   2  'Vertical
      TabIndex        =   4
      TabStop         =   0   'False
      Top             =   3480
      Width           =   8415
   End
   Begin VB.CommandButton AddButton 
      Caption         =   ">"
      Enabled         =   0   'False
      Height          =   375
      Left            =   3360
      TabIndex        =   3
      ToolTipText     =   "Add study to chart"
      Top             =   1080
      Width           =   375
   End
   Begin VB.CommandButton ConfigureButton 
      Caption         =   "Co&nfigure"
      Enabled         =   0   'False
      Height          =   375
      Left            =   2160
      TabIndex        =   2
      ToolTipText     =   "Configure selected study"
      Top             =   3000
      Width           =   1095
   End
   Begin VB.CommandButton RemoveButton 
      Caption         =   "<"
      Enabled         =   0   'False
      Height          =   375
      Left            =   3360
      TabIndex        =   1
      ToolTipText     =   "Remove study from chart"
      Top             =   1560
      Width           =   375
   End
   Begin VB.CommandButton ChangeButton 
      Caption         =   "Change"
      Enabled         =   0   'False
      Height          =   375
      Left            =   7440
      TabIndex        =   0
      ToolTipText     =   "Change selected study's configuration"
      Top             =   3000
      Width           =   1095
   End
   Begin VB.Label Label1 
      Caption         =   "Available studies"
      Height          =   255
      Left            =   240
      TabIndex        =   8
      Top             =   120
      Width           =   1455
   End
   Begin VB.Label Label2 
      Caption         =   "Description"
      Height          =   255
      Left            =   240
      TabIndex        =   7
      Top             =   3240
      Width           =   1455
   End
   Begin VB.Label Label3 
      Caption         =   "Studies in chart"
      Height          =   255
      Left            =   3960
      TabIndex        =   6
      Top             =   120
      Width           =   1695
   End
End
Attribute VB_Name = "StudyPicker"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
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

'@================================================================================
' Enums
'@================================================================================

'@================================================================================
' Types
'@================================================================================


'@================================================================================
' Member variables
'@================================================================================

Private WithEvents mChartManager As ChartManager
Attribute mChartManager.VB_VarHelpID = -1
Private mChart As ChartController

Private mAvailableStudies() As StudyListEntry

Private mConfigForm As fStudyConfigurer
Attribute mConfigForm.VB_VarHelpID = -1

'@================================================================================
' UserControl Event Handlers
'@================================================================================

Private Sub UserControl_Initialize()
InitCommonControls
SendMessage StudyList.hWnd, LB_SETHORZEXTENT, 1000, 0
SendMessage ChartStudiesTree.hWnd, LB_SETHORZEXTENT, 1000, 0
End Sub

'@================================================================================
' Control Event Handlers
'@================================================================================

Private Sub AddButton_Click()
Dim slName As String
Dim defaultStudyConfig As StudyConfiguration
Dim studyConfig As StudyConfiguration

slName = mAvailableStudies(StudyList.ListIndex).StudyLibrary
Set defaultStudyConfig = GetDefaultStudyConfiguration(mAvailableStudies(StudyList.ListIndex).name, slName)

If Not defaultStudyConfig Is Nothing Then
    addStudyToChart defaultStudyConfig
Else
    Set studyConfig = showConfigForm(mAvailableStudies(StudyList.ListIndex).name, _
                mAvailableStudies(StudyList.ListIndex).StudyLibrary, _
                defaultStudyConfig)
    If studyConfig Is Nothing Then Exit Sub
    addStudyToChart studyConfig
End If

End Sub

Private Sub ChangeButton_Click()
Dim studyConfig As StudyConfiguration
Dim newStudyConfig As StudyConfiguration

Set studyConfig = mChartManager.GetStudyConfig(ChartStudiesTree.SelectedItem.Key)

' NB: the following line displays a modal form, so we can remove the existing
' study and deal with any related studies after it
Set newStudyConfig = showConfigForm(studyConfig.name, _
                studyConfig.StudyLibraryName, _
                studyConfig)
If Not newStudyConfig Is Nothing Then
    
    If studyConfig.Study Is mChartManager.BaseStudy Then
        newStudyConfig.Study = studyConfig.Study
        mChartManager.BaseStudyConfiguration = newStudyConfig
    Else
        ReplaceStudyInChart studyConfig, newStudyConfig
    End If
    
    RemoveButton.Enabled = False
    ChangeButton.Enabled = False
    DescriptionText = ""
End If

End Sub

Private Sub ChartStudiesTree_Click()
Dim studyDef As StudyDefinition
Dim studyConfig As StudyConfiguration

If ChartStudiesTree.SelectedItem Is Nothing Then
    RemoveButton.Enabled = False
    ChangeButton.Enabled = False
Else
    ChartStudiesTree.SelectedItem.Expanded = True
    Set studyConfig = mChartManager.GetStudyConfig(ChartStudiesTree.SelectedItem.Key)
    Set studyDef = GetStudyDefinition( _
                            studyConfig.name, _
                            studyConfig.StudyLibraryName)
    If Not studyDef Is Nothing Then
        StudyList.ListIndex = -1
        AddButton.Enabled = False
        ConfigureButton.Enabled = False
        
        DescriptionText.text = studyDef.Description
        RemoveButton.Enabled = Not (studyConfig.Study Is mChartManager.BaseStudy)
        ChangeButton.Enabled = True
    End If
End If
End Sub

Private Sub ConfigureButton_Click()
Dim studyConfig As StudyConfiguration

Set studyConfig = showConfigForm(mAvailableStudies(StudyList.ListIndex).name, _
                mAvailableStudies(StudyList.ListIndex).StudyLibrary, _
                GetDefaultStudyConfiguration(mAvailableStudies(StudyList.ListIndex).name, _
                                            mAvailableStudies(StudyList.ListIndex).StudyLibrary))
If studyConfig Is Nothing Then Exit Sub
addStudyToChart studyConfig
End Sub

Private Sub RemoveButton_Click()
Dim studyConfig As StudyConfiguration
Set studyConfig = mChartManager.GetStudyConfig(ChartStudiesTree.SelectedItem.Key)
mChartManager.RemoveStudyConfiguration studyConfig
RemoveButton.Enabled = False
ChangeButton.Enabled = False
End Sub

Private Sub StudyList_Click()
Dim studyDef As StudyDefinition
Dim slName As String

If mChartManager Is Nothing Then Exit Sub

If StudyList.ListIndex <> -1 Then
    RemoveButton.Enabled = False
    ChangeButton.Enabled = False
    
    AddButton.Enabled = True
    ConfigureButton.Enabled = True
    slName = mAvailableStudies(StudyList.ListIndex).StudyLibrary
    Set studyDef = GetStudyDefinition( _
                            mAvailableStudies(StudyList.ListIndex).name, _
                            slName)
    DescriptionText.text = studyDef.Description
Else
    AddButton.Enabled = False
    ConfigureButton.Enabled = False
End If
End Sub

'@================================================================================
' mChartManager Event Handlers
'@================================================================================

Private Sub mChartManager_StudyAdded( _
                ByVal studyConfig As ChartUtils26.StudyConfiguration)
Dim parentNode As Node
If Not studyConfig.UnderlyingStudy Is Nothing Then
    On Error Resume Next
    Set parentNode = ChartStudiesTree.Nodes.item(studyConfig.UnderlyingStudy.Id)
    On Error GoTo 0
End If
If parentNode Is Nothing Then
    ChartStudiesTree.Nodes.Add , _
                                TreeRelationshipConstants.tvwChild, _
                                studyConfig.Study.Id, _
                                studyConfig.Study.InstanceName
Else
    ChartStudiesTree.Nodes.Add parentNode, _
                                TreeRelationshipConstants.tvwChild, _
                                studyConfig.Study.Id, _
                                studyConfig.Study.InstanceName
    parentNode.Expanded = True
End If
End Sub

Private Sub mChartManager_StudyRemoved( _
                ByVal studyConfig As ChartUtils26.StudyConfiguration)
On Error Resume Next
ChartStudiesTree.Nodes.Remove studyConfig.Study.Id
End Sub

'@================================================================================
' Properties
'@================================================================================

'@================================================================================
' Methods
'@================================================================================

Public Sub Initialise( _
                ByVal pChartManager As ChartManager)
Dim i As Long
Dim itemText As String
Dim lLogger As Logger

Set lLogger = GetLogger("diag.tradebuild.studiesui")
lLogger.Log LogLevelMediumDetail, "Initialise"

Set mChartManager = pChartManager

DescriptionText = ""
ChartStudiesTree.Nodes.Clear
If Not mChartManager Is Nothing Then
    Set mChart = mChartManager.Chart
    addEntryToChartStudiesTree mChartManager.BaseStudyConfiguration, Nothing
Else
    lLogger.Log LogLevelMediumDetail, "Chart manager is Nothing"
End If

StudyList.Clear
mAvailableStudies = AvailableStudies

For i = 0 To UBound(mAvailableStudies)
    itemText = mAvailableStudies(i).name & "  (" & mAvailableStudies(i).StudyLibrary & ")"
    StudyList.AddItem itemText
Next

AddButton.Enabled = False
ConfigureButton.Enabled = False
RemoveButton.Enabled = False
ChangeButton.Enabled = False

End Sub

'@================================================================================
' Helper Functions
'@================================================================================

Private Sub addEntryToChartStudiesTree( _
                ByVal studyConfig As StudyConfiguration, _
                ByVal parentStudyConfig As StudyConfiguration)
Dim parentNode As Node
Dim childStudyConfig As StudyConfiguration

If studyConfig Is Nothing Then Exit Sub

If Not parentStudyConfig Is Nothing Then Set parentNode = ChartStudiesTree.Nodes.item(parentStudyConfig.Study.Id)
If parentNode Is Nothing Then
    ChartStudiesTree.Nodes.Add , _
                                TreeRelationshipConstants.tvwChild, _
                                studyConfig.Study.Id, _
                                studyConfig.Study.InstanceName
Else
    ChartStudiesTree.Nodes.Add parentNode, _
                                TreeRelationshipConstants.tvwChild, _
                                studyConfig.Study.Id, _
                                studyConfig.Study.InstanceName
    parentNode.Expanded = True
End If
For Each childStudyConfig In studyConfig.StudyConfigurations
    addEntryToChartStudiesTree childStudyConfig, studyConfig
Next
End Sub

Private Sub addStudyToChart(ByVal studyConfig As StudyConfiguration)
On Error GoTo Err
mChartManager.AddStudyConfiguration studyConfig
mChartManager.StartStudy studyConfig.Study
Exit Sub

Err:
Initialise Nothing
End Sub

Private Sub ReplaceStudyInChart( _
                ByVal oldStudyConfig As StudyConfiguration, _
                ByVal newStudyConfig As StudyConfiguration)
On Error GoTo Err
mChartManager.ReplaceStudyConfiguration oldStudyConfig, newStudyConfig
Exit Sub

Err:
Initialise Nothing
End Sub

'/**
'   Returns the required studyConfiguration if the config form is not cancelled by the user
'*/
Private Function showConfigForm( _
                ByVal studyName As String, _
                ByVal slName As String, _
                ByVal defaultConfiguration As StudyConfiguration) As StudyConfiguration

Dim noParameterModification  As Boolean

If mConfigForm Is Nothing Then Set mConfigForm = New fStudyConfigurer

If Not defaultConfiguration Is Nothing Then
    If Not mChartManager.BaseStudy Is Nothing Then
        If defaultConfiguration.Study Is mChartManager.BaseStudy Then noParameterModification = True
    End If
End If

mConfigForm.Initialise mChartManager.Chart, _
                        GetStudyDefinition(studyName, slName), _
                        slName, _
                        mChartManager.regionNames, _
                        mChartManager.BaseStudyConfiguration, _
                        defaultConfiguration, _
                        GetStudyDefaultParameters(studyName, slName), _
                        noParameterModification
mConfigForm.Show vbModal, Me
If Not mConfigForm.Cancelled Then Set showConfigForm = mConfigForm.StudyConfiguration
End Function





