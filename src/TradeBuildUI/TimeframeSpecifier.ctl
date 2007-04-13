VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCTL.OCX"
Begin VB.UserControl TimeframeSpecifier 
   BackStyle       =   0  'Transparent
   ClientHeight    =   750
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   2295
   ScaleHeight     =   750
   ScaleWidth      =   2295
   Begin MSComctlLib.ImageCombo TimeframeUnitsCombo 
      Height          =   330
      Left            =   840
      TabIndex        =   3
      Top             =   360
      Width           =   1335
      _ExtentX        =   2355
      _ExtentY        =   582
      _Version        =   393216
      ForeColor       =   -2147483640
      BackColor       =   -2147483643
      Locked          =   -1  'True
   End
   Begin VB.TextBox TimeframeLengthText 
      Height          =   285
      Left            =   840
      TabIndex        =   0
      Top             =   0
      Width           =   1335
   End
   Begin VB.Label LengthLabel 
      Caption         =   "Length"
      Height          =   255
      Left            =   0
      TabIndex        =   2
      Top             =   0
      Width           =   855
   End
   Begin VB.Label UnitsLabel 
      Caption         =   "Units"
      Height          =   255
      Left            =   0
      TabIndex        =   1
      Top             =   360
      Width           =   855
   End
End
Attribute VB_Name = "TimeframeSpecifier"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

''
' Description here
'
' @remarks
' @see
'
'@/

'@================================================================================
' Interfaces
'@================================================================================

'@================================================================================
' Events
'@================================================================================

Event Change()

'@================================================================================
' Enums
'@================================================================================

'@================================================================================
' Types
'@================================================================================

'@================================================================================
' Constants
'@================================================================================

Private Const ProjectName                               As String = "TradeBuildUI25"
Private Const ModuleName                                As String = "TimeFrameSpecifier"

Private Const PropNameBackColor                         As String = "BackColor"
Private Const PropNameDefaultLength                     As String = "DefaultLength"
Private Const PropNameDefaultUnits                      As String = "DefaultUnits"
Private Const PropNameEnabled                           As String = "Enabled"
Private Const PropNameForeColor                         As String = "ForeColor"

Private Const PropDfltBackColor                         As Long = vbWindowBackground
Private Const PropDfltDefaultLength                     As Long = 5
Private Const PropDfltDefaultUnits                      As Long = TimePeriodUnits.TimePeriodMinute
Private Const PropDfltEnabled                           As Boolean = True
Private Const PropDfltForeColor                         As Long = vbWindowText

'@================================================================================
' Member variables
'@================================================================================

Private mTB As tradeBuildAPI

Private mDefaultUnits As TimePeriodUnits

'@================================================================================
' Class Event Handlers
'@================================================================================

Private Sub UserControl_InitProperties()
On Error Resume Next

backColor = PropDfltBackColor
DefaultLength = PropDfltDefaultLength
DefaultUnits = PropDfltDefaultUnits
Enabled = PropDfltEnabled
foreColor = PropDfltForeColor
End Sub

Private Sub UserControl_ReadProperties(PropBag As PropertyBag)

On Error Resume Next

backColor = PropBag.ReadProperty(PropNameBackColor, PropDfltBackColor)
If Err.Number <> 0 Then
    backColor = PropDfltBackColor
    Err.clear
End If

DefaultLength = PropBag.ReadProperty(PropNameDefaultLength, PropDfltDefaultLength)
If Err.Number <> 0 Then
    DefaultLength = PropDfltDefaultLength
    Err.clear
End If

DefaultUnits = PropBag.ReadProperty(PropNameDefaultUnits, PropDfltDefaultUnits)
If Err.Number <> 0 Then
    DefaultUnits = PropDfltDefaultUnits
    Err.clear
End If

Enabled = PropBag.ReadProperty(PropNameEnabled, PropDfltEnabled)
If Err.Number <> 0 Then
    Enabled = PropDfltEnabled
    Err.clear
End If

foreColor = PropBag.ReadProperty(PropNameForeColor, PropDfltForeColor)
If Err.Number <> 0 Then
    backColor = PropDfltForeColor
    Err.clear
End If

End Sub

Private Sub UserControl_Resize()
Dim controlWidth

If UserControl.Width < 1710 Then UserControl.Width = 1710
If UserControl.Height < 2 * 315 Then UserControl.Height = 2 * 315

controlWidth = UserControl.Width - LengthLabel.Width

LengthLabel.Top = 0
TimeframeLengthText.Top = 0
TimeframeLengthText.Left = LengthLabel.Width
TimeframeLengthText.Width = controlWidth

UnitsLabel.Top = UserControl.Height - TimeframeUnitsCombo.Height
TimeframeUnitsCombo.Top = UnitsLabel.Top
TimeframeUnitsCombo.Left = LengthLabel.Width
TimeframeUnitsCombo.Width = controlWidth
End Sub

Private Sub UserControl_WriteProperties(PropBag As PropertyBag)
PropBag.WriteProperty PropNameBackColor, backColor, PropDfltBackColor
PropBag.WriteProperty PropNameDefaultLength, DefaultLength, PropDfltDefaultLength
PropBag.WriteProperty PropNameDefaultUnits, DefaultUnits, PropDfltDefaultUnits
PropBag.WriteProperty PropNameEnabled, Enabled, PropDfltEnabled
PropBag.WriteProperty PropNameForeColor, foreColor, PropDfltForeColor
End Sub

'@================================================================================
' XXXX Interface Members
'@================================================================================

'@================================================================================
' Control Event Handlers
'@================================================================================

Private Sub TimeframeLengthText_Change()
RaiseEvent Change
End Sub

Private Sub TimeframeLengthText_KeyPress(KeyAscii As Integer)
Dim l As Long

On Error GoTo Err

If KeyAscii = vbKeyBack Then Exit Sub
If KeyAscii = vbKeyTab Then Exit Sub
If KeyAscii = vbKeyLeft Then Exit Sub
If KeyAscii = vbKeyRight Then Exit Sub

If Chr(KeyAscii) < "0" Or Chr(KeyAscii) > "9" Then KeyAscii = 0: Exit Sub
l = CLng(TimeframeLengthText & Chr(KeyAscii))
Exit Sub

Err:
KeyAscii = 0
End Sub

Private Sub TimeframeUnitsCombo_Change()
RaiseEvent Change
End Sub

Private Sub TimeframeUnitsCombo_Click()
RaiseEvent Change
End Sub

'@================================================================================
' XXXX Event Handlers
'@================================================================================

'@================================================================================
' Properties
'@================================================================================

Public Property Let backColor( _
                ByVal value As OLE_COLOR)
TimeframeLengthText.backColor = value
TimeframeUnitsCombo.backColor = value
End Property

Public Property Get backColor() As OLE_COLOR
backColor = TimeframeUnitsCombo.backColor
End Property

Public Property Let DefaultLength( _
                ByVal value As Long)
If value <= 0 Then
    Err.Raise ErrorCodes.ErrIllegalArgumentException, _
            ProjectName & "." & ModuleName & ":" & "DefaultLength", _
            "Value must be greater than zero"
End If
TimeframeLengthText = value
End Property

Public Property Get DefaultLength() As Long
DefaultLength = TimeframeLengthText
End Property

Public Property Let DefaultUnits( _
                ByVal value As TimePeriodUnits)
mDefaultUnits = value
End Property

Public Property Get DefaultUnits() As TimePeriodUnits
DefaultUnits = mDefaultUnits
End Property

Public Property Get Enabled() As Boolean
Enabled = UserControl.Enabled
End Property

Public Property Let Enabled(ByVal value As Boolean)
UserControl.Enabled = value
TimeframeLengthText.Enabled = value
TimeframeUnitsCombo.Enabled = value
PropertyChanged PropNameEnabled
End Property

Public Property Let foreColor( _
                ByVal value As OLE_COLOR)
TimeframeLengthText.foreColor = value
TimeframeUnitsCombo.foreColor = value
End Property

Public Property Get foreColor() As OLE_COLOR
foreColor = TimeframeUnitsCombo.foreColor
End Property

Public Property Get isTimeframeValid() As Boolean
If mTB Is Nothing Then
    Err.Raise ErrorCodes.ErrIllegalStateException, _
            ProjectName & "." & ModuleName & ":" & "isTimeframeValid", _
            "No reference to TradeBuildAPI supplied yet"
End If

If TimeframeLengthText = "" Then Exit Function

If mTB.IsSupportedHistoricalDataPeriod(CLng(TimeframeLengthText), _
                                        TimePeriodUnitsFromString(TimeframeUnitsCombo.Text)) Then isTimeframeValid = True
End Property

Public Property Get timeframeDesignator() As TimePeriod
If mTB Is Nothing Then
    Err.Raise ErrorCodes.ErrIllegalStateException, _
            ProjectName & "." & ModuleName & ":" & "timeframeDesignator", _
            "No reference to TradeBuildAPI supplied yet"
End If

timeframeDesignator.length = TimeframeLengthText
timeframeDesignator.units = TimePeriodUnitsFromString(TimeframeUnitsCombo.selectedItem.Text)
End Property

Public Property Let tradeBuildAPI( _
                ByVal tb As tradeBuildAPI)
Set mTB = tb
setupTimeframeUnitsCombo
End Property
                
'@================================================================================
' Methods
'@================================================================================

Public Sub initialise( _
                ByVal length As Long, _
                ByVal units As TimePeriodUnits)
TimeframeLengthText = length
mDefaultUnits = units
If Not mTB Is Nothing Then
    setUnitsSelection mDefaultUnits
End If
End Sub

'@================================================================================
' Helper Functions
'@================================================================================

Private Sub addItem( _
                ByVal value As TimePeriodUnits)
Dim s As String
s = TimePeriodUnitsToString(value)
If mTB.IsSupportedHistoricalDataPeriod(0, value) Then TimeframeUnitsCombo.ComboItems.add , s, s
End Sub

Private Function setUnitsSelection( _
                ByVal value As TimePeriodUnits) As Boolean
If mTB.IsSupportedHistoricalDataPeriod(0, value) Then
    TimeframeUnitsCombo.ComboItems.item(TimePeriodUnitsToString(value)).Selected = True
    setUnitsSelection = True
End If
End Function

Private Sub setupTimeframeUnitsCombo()
addItem TimePeriodSecond
addItem TimePeriodMinute
addItem TimePeriodHour
addItem TimePeriodDay
addItem TimePeriodWeek
addItem TimePeriodMonth
addItem TimePeriodYear
addItem TimePeriodVolume
addItem TimePeriodTickVolume
addItem TimePeriodTickMovement
If setUnitsSelection(mDefaultUnits) Then
ElseIf setUnitsSelection(TimePeriodMinute) Then
ElseIf setUnitsSelection(TimePeriodHour) Then
ElseIf setUnitsSelection(TimePeriodDay) Then
ElseIf setUnitsSelection(TimePeriodWeek) Then
ElseIf setUnitsSelection(TimePeriodMonth) Then
Else
    setUnitsSelection (TimePeriodYear)
End If

End Sub
