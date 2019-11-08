VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "OrderUtilsEnums"
Attribute VB_GlobalNameSpace = True
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
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

Public Enum BracketOrderChangeTypes
    BracketOrderCreated = 1
    BracketOrderCompleted
    BracketOrderSelfCancelled
    BracketOrderEntryOrderChanged
    BracketOrderEntryOrderFilled
    BracketOrderStopLossOrderChanged
    BracketOrderStopLossOrderFilled
    BracketOrderTargetOrderChanged
    BracketOrderTargetOrderFilled
    BracketOrderCloseoutOrderCreated
    BracketOrderCloseoutOrderChanged
    BracketOrderCloseoutOrderFilled
    BracketOrderSizeChanged
    BracketOrderStateChanged
    BracketOrderChangesPending
    BracketOrderChangesApplied
    BracketOrderChangesCancelled
    BracketOrderPositionCloseoutNotified
End Enum

Public Enum BracketOrderRoles
    BracketOrderRoleNone = 0
    BracketOrderRoleEntry = 1
    BracketOrderRoleStopLoss
    BracketOrderRoleTarget
    BracketOrderRoleCloseout
End Enum

Public Enum BracketOrderStates
    BracketOrderStateCreated = 1   ' indicates that the bracket order has been created but none of the orders have yet been placed
    BracketOrderStateSubmitted     ' indicates that all the orders in the bracket order have been placed
    BracketOrderStateCancelling    ' indicates that the bracket order is in the process of being cancelled
    BracketOrderStateClosingOut    ' indicates that the bracket order is being closed out. (When a bracket order has been closed out, there are no outstanding orders and no net Size - note that this may require a closeout order to be placed to negate any existing Size
    BracketOrderStateClosed        ' indicates that all orders have been completed
    BracketOrderStateAwaitingOtherOrderCancel  ' indicates that a cancellation notification for either the stop-loss order or the target order, when both exist, has been received
End Enum

Public Enum OrderActions
    OrderActionNone = 0
    OrderActionBuy = 1
    OrderActionSell = 2
End Enum

Public Enum OrderAttributes
    OrderAttOpenClose = 1
    OrderAttOrigin = 2
    OrderAttOriginatorRef = 4
    OrderAttBlockOrder = 8
    OrderAttSweepToFill = &H10&
    OrderAttDisplaySize = &H20&
    OrderAttIgnoreRTH = &H40&
    OrderAttHidden = &H80&
    OrderAttDiscretionaryAmount = &H100&
    OrderAttGoodAfterTime = &H200&
    OrderAttGoodTillDate = &H400&
    'OrderAttRTHOnly = &H800&
    OrderAttRule80A = &H1000&
    OrderAttSettlingFirm = &H2000&
    OrderAttAllOrNone = &H4000&
    OrderAttMinimumQuantity = &H8000&
    OrderAttPercentOffset = &H10000
    OrderAttETradeOnly = &H20000
    OrderAttFirmQuoteOnly = &H40000
    OrderAttNBBOPriceCap = &H80000
    OrderAttOverrideConstraints = &H100000
    OrderAttAction = &H200000
    OrderAttLimitPrice = &H400000
    OrderAttOrderType = &H800000
    OrderAttQuantity = &H1000000
    OrderAttTimeInForce = &H2000000
    OrderAttTriggerPrice = &H4000000
    OrderAttGoodAfterTimeTZ = &H8000000
    OrderAttGoodTillDateTZ = &H10000000
    OrderAttStopTriggerMethod = &H20000000
End Enum

Public Enum OrderOrigins
    OriginCustomer = 0
    OriginFirm = 1
End Enum

''
'
'
' @param OrderStatusCreated
'   The order has been created but not yet transmitted to the broker
'
' @param OrderStatusRejected
'   The order has been transmitted to the broker but has been rejected
'   by the broker for some reason.
'
' @param OrderStatusPendingSubmit
'   The order has been transmitted to the broker, but no confirmation has
'   yet been received that it has been accepted.
'
' @param OrderStatusPreSubmitted
'   The order has been accepted by the broker, but the conditions for it
'   to be activated have not yet been met.
'
' @param OrderStatusSubmitted
'   The order has been activated at the order destination.
'
' @param OrderStatusFilled
'   The order has been completely filled.
'
' @param OrderStatusCancelling
'   A request to cancel the order has been sent, but confirmation of
'   the cancel has not yet been received.
'
' @param OrderStatusCancelled
'   The order has been cancelled.
'
'@/
'
Public Enum OrderStatuses
    OrderStatusCreated = 0
    OrderStatusRejected = 1
    OrderStatusPendingSubmit = 2
    OrderStatusPreSubmitted = 3
    OrderStatusSubmitted = 4
    OrderStatusFilled = 5
    OrderStatusCancelling = 6
    OrderStatusCancelled = 7
End Enum

Public Enum OrderContextChangeTypes
    OrderContextReadyStateChanged = 1
    OrderContextActiveStateChanged
End Enum

Public Enum OrderStopTriggerMethods
    OrderStopTriggerNone = 0
    OrderStopTriggerDefault = 1
    OrderStopTriggerDoubleBidAsk = 2
    OrderStopTriggerLast = 4
    OrderStopTriggerDoubleLast = 8
    OrderStopTriggerBidAsk = 16
    OrderStopTriggerLastOrBidAsk = 32
    OrderStopTriggerMidPoint = 64
End Enum

Public Enum OrderSubmitterCapabilities
    OrderSubmitterCapabilityNone = 0
    OrderSubmitterCapabilityCanStageOrders = 1
End Enum

Public Enum OrderSubmitterStates
    OrderSubmitterStateReady = 1
    OrderSubmitterStateNotReady
End Enum

Public Enum OrderTIFs
    OrderTIFNone = 0
    OrderTIFDay = 1
    OrderTIFGoodTillCancelled = 2
    OrderTIFImmediateOrCancel = 4
End Enum

Public Enum OrderTypes
    OrderTypeNone = 0
    OrderTypeMarket = 1
    OrderTypeMarketIfTouched = 2
    OrderTypeMarketOnClose = 4
    OrderTypeMarketOnOpen = 8
    OrderTypeMarketToLimit = &H10&
    OrderTypeLimit = &H20&
    OrderTypeLimitIfTouched = &H40&
    OrderTypeLimitOnClose = &H80&
    OrderTypeLimitOnOpen = &H100&
    OrderTypeStop = &H200&
    OrderTypeStopLimit = &H400&
    OrderTypeTrail = &H8000&
    OrderTypeTrailLimit = &H10000
    OrderTypePeggedToMarket = &H20000
    OrderTypeMarketWithProtection = &H40000
    OrderTypePeggedToPrimary = &H80000
    OrderTypeRelative = &H100000
End Enum

Public Enum PositionManagerChangeTypes
    PositionSizeChanged
    ProviderReadinessChanged
    PositionClosed
    PositionCloseFailed
End Enum

Public Enum PositionTypes
    PositionTypeLive = 1
    PositionTypeSimulated = 2
    PositionTypeAll = 3
End Enum

Public Enum PriceOffsetTypes
    PriceOffsetTypeNone = 0
    PriceOffsetTypeIncrement
    PriceOffsetTypeNumberOfTicks
    PriceOffsetTypeBidAskPercent
    PriceOffsetTypePercent
End Enum

Public Enum PriceValueTypes
    PriceValueTypeNone = 0
    PriceValueTypeValue
    PriceValueTypeAsk
    PriceValueTypeBid
    PriceValueTypeLast
    PriceValueTypeEntry
End Enum

Public Enum ProfitChangeTypes
    ProfitChangeProfitThresholdExceeded
    ProfitChangeLossThresholdExceeded
    ProfitChangeDrawdownThresholdExceeded
End Enum

Public Enum ProfitTypes
    ProfitTypeProfit = 1&
    ProfitTypeMaxProfit = 2&
    ProfitTypeMaxLoss = 4&
    ProfitTypeDrawdown = 8&
    ProfitTypeSessionProfit = &H10&
    ProfitTypeSessionMaxProfit = &H20&
    ProfitTypeSessionMaxLoss = &H40&
    ProfitTypeSessionDrawdown = &H80&
    ProfitTypeTradeProfit = &H100&
    ProfitTypeTradeMaxProfit = &H200&
    ProfitTypeTradeMaxLoss = &H400&
    ProfitTypeTradeDrawdown = &H800&
End Enum

'@================================================================================
' Types
'@================================================================================

'@================================================================================
' Constants
'@================================================================================

Private Const ModuleName                            As String = "OrderUtilsEnums"

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

'@================================================================================
' Helper Functions
'@================================================================================



