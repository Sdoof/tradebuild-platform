Attribute VB_Name = "OrderPlexGlobals"
Option Explicit

'================================================================================
' Constants
'================================================================================

'================================================================================
' Enums
'================================================================================

'================================================================================
' Types
'================================================================================

'================================================================================
' Global object references
'================================================================================

'================================================================================
' External function declarations
'================================================================================

'================================================================================
' Variables
'================================================================================

'================================================================================
' Procedures
'================================================================================

Public Function gNextApplicationIndex() As Long
Static lNextApplicationIndex As Long

gNextApplicationIndex = lNextApplicationIndex
lNextApplicationIndex = lNextApplicationIndex + 1
End Function

'================================================================================
' Helper Function
'================================================================================


