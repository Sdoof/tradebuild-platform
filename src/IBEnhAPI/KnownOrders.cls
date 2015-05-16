VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "KnownOrders"
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

'@================================================================================
' Enums
'@================================================================================

'@================================================================================
' Types
'@================================================================================

'@================================================================================
' Constants
'@================================================================================

Private Const ModuleName                            As String = "KnownOrders"

'@================================================================================
' Member variables
'@================================================================================

Private mOrders                                     As New EnumerableCollection

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

Friend Sub Add( _
                ByVal pOrder As IOrder, _
                ByVal pOrderSubmitter As OrderSubmitter, _
                ByVal pClientId As Long)
Const ProcName As String = "Add"
On Error GoTo Err

Dim lMapEntry As OrderIdMapEntry

Set lMapEntry.Order = pOrder
Set lMapEntry.OrderSubmitter = pOrderSubmitter
mOrders.Add lMapEntry, generateTwsOrderKey(pOrder.BrokerId, pClientId)

Exit Sub

Err:
If Err.Number = VBErrorCodes.VbErrElementAlreadyExists Then Exit Sub
gHandleUnexpectedError ProcName, ModuleName
End Sub

Friend Sub Cancel( _
                ByVal pBrokerId As String, _
                ByVal pClientId As Long)
Const ProcName As String = "Cancel"
On Error GoTo Err

Dim lKey As String
Dim lMapEntry As OrderIdMapEntry

lKey = generateTwsOrderKey(pBrokerId, pClientId)
lMapEntry = mOrders(lKey)
lMapEntry.Cancelled = True
mOrders.Remove lKey
mOrders.Add lMapEntry, lKey

Exit Sub

Err:
gHandleUnexpectedError ProcName, ModuleName
End Sub

Friend Function Contains( _
                ByVal pBrokerId As String, _
                ByVal pClientId As Long) As Boolean
Const ProcName As String = "Contains"
On Error GoTo Err

Contains = mOrders.Contains(generateTwsOrderKey(pBrokerId, pClientId))

Exit Function

Err:
gHandleUnexpectedError ProcName, ModuleName
End Function

Friend Function GetOrder( _
                ByVal pBrokerId As String, _
                ByVal pClientId As Long) As IOrder
Const ProcName As String = "GetOrder"
On Error GoTo Err

Dim lMapEntry As OrderIdMapEntry

lMapEntry = mOrders(generateTwsOrderKey(pBrokerId, pClientId))
Set GetOrder = lMapEntry.Order

Exit Function

Err:
gHandleUnexpectedError ProcName, ModuleName
End Function

Friend Function GetOrderSubmitter( _
                ByVal pBrokerId As String, _
                ByVal pClientId As Long) As OrderSubmitter
Const ProcName As String = "GetOrderSubmitter"
On Error GoTo Err

Dim lMapEntry As OrderIdMapEntry

lMapEntry = mOrders(generateTwsOrderKey(pBrokerId, pClientId))
Set GetOrderSubmitter = lMapEntry.OrderSubmitter

Exit Function

Err:
gHandleUnexpectedError ProcName, ModuleName
End Function

Friend Function IsCancelled( _
                ByVal pBrokerId As String, _
                ByVal pClientId As Long) As Boolean
Const ProcName As String = "IsCancelled"
On Error GoTo Err

Dim lMapEntry As OrderIdMapEntry

lMapEntry = mOrders(generateTwsOrderKey(pBrokerId, pClientId))
IsCancelled = lMapEntry.Cancelled

Exit Function

Err:
gHandleUnexpectedError ProcName, ModuleName
End Function

'@================================================================================
' Helper Functions
'@================================================================================

Private Function generateTwsOrderKey( _
                ByVal pTwsOrderId As String, _
                ByVal pClientId As Long) As String
generateTwsOrderKey = pClientId & "/" & CStr(pTwsOrderId)
End Function


