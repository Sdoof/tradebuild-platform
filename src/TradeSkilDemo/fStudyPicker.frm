VERSION 5.00
Object = "{6F9EA9CF-F55B-4AFA-8431-9ECC5BED8D43}#23.3#0"; "StudiesUI2-6.ocx"
Begin VB.Form fStudyPicker 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Form1"
   ClientHeight    =   4350
   ClientLeft      =   45
   ClientTop       =   435
   ClientWidth     =   8700
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   4350
   ScaleWidth      =   8700
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin StudiesUI26.StudyPicker StudyPicker1 
      Height          =   4335
      Left            =   0
      TabIndex        =   0
      Top             =   0
      Width           =   8655
      _ExtentX        =   15266
      _ExtentY        =   7646
   End
End
Attribute VB_Name = "fStudyPicker"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
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

'@================================================================================
' Enums
'@================================================================================

'@================================================================================
' Types
'@================================================================================

'@================================================================================
' Constants
'@================================================================================

Private Const ProjectName                   As String = "TradeSkilDemo26"
Private Const ModuleName                    As String = "fStudyPicker"

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

'@================================================================================
' Methods
'@================================================================================

Friend Sub initialise( _
                ByVal pChartManager As chartManager, _
                ByVal title As String)
StudyPicker1.initialise pChartManager
Me.caption = title
End Sub

'@================================================================================
' Helper Functions
'@================================================================================

