VERSION 5.00
Object = "{464F646E-C78A-4AAC-AC11-FBC7E41F58BB}#105.0#0"; "StudiesUI27.ocx"
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
   Begin StudiesUI27.StudyPicker StudyPicker1 
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

Friend Sub Initialise( _
                ByVal pChartManager As ChartManager, _
                ByVal title As String)
Const ProcName As String = "initialise"

On Error GoTo Err

StudyPicker1.Initialise pChartManager
Me.caption = title

Exit Sub

Err:
gHandleUnexpectedError ProcName, ModuleName
End Sub

'@================================================================================
' Helper Functions
'@================================================================================


