VERSION 5.00
Object = "{5E9E78A0-531B-11CF-91F6-C2863C385E30}#1.0#0"; "msflxgrd.ocx"
Begin VB.Form fMarketDepth 
   Caption         =   "Market Depth"
   ClientHeight    =   5535
   ClientLeft      =   375
   ClientTop       =   510
   ClientWidth     =   5145
   LinkTopic       =   "Form1"
   ScaleHeight     =   5535
   ScaleWidth      =   5145
   Begin MSFlexGridLib.MSFlexGrid DOMGrid 
      Height          =   5295
      Left            =   120
      TabIndex        =   0
      Top             =   120
      Width           =   4935
      _ExtentX        =   8705
      _ExtentY        =   9340
      _Version        =   393216
      AllowUserResizing=   1
   End
End
Attribute VB_Name = "fMarketDepth"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Implements IListener

Private mContract As Contract
Private mInitialPrice As Double
Private mPriceIncrement As Double
Private mNumberOfRows As Long
Private mNumberOfVisibleRows As Long
Private mBasePrice As Double
Private mCeilingPrice As Double

Private mAskPrices() As Double
Private mMaxAskPricesIndex As Long
Private mBidPrices() As Double
Private mMaxBidPricesIndex As Long

Private mCurrentLast As Double

Private mHalted As Boolean

Private mFormatString As String

Private Enum DOMColumns
    PriceLeft
    bidSize
    LastSize
    askSize
    PriceRight
End Enum

Private Enum GridColours
    BGDefault = &HE1F4FD
    BGBid = &HD6C6F2
    BGAsk = &HFAE968
    BGLast = &HC1F7CA
End Enum

Private Sub DOMGrid_Click()
DOMGrid.row = 1
DOMGrid.col = 0
End Sub

Private Sub Form_Initialize()
InitCommonControls
End Sub

Private Sub Form_Load()

ReDim mAskPrices(20) As Double
ReDim mBidPrices(20) As Double

Me.Left = Screen.width - Me.width
Me.Top = Screen.Height - Me.Height

DOMGrid.AllowUserResizing = flexResizeColumns
DOMGrid.BackColorFixed = vbButtonFace
DOMGrid.BackColorSel = GridColours.BGDefault
DOMGrid.BackColor = GridColours.BGDefault
DOMGrid.ForeColorSel = DOMGrid.ForeColor
DOMGrid.Rows = 1
DOMGrid.Cols = 5
DOMGrid.FixedCols = 0
DOMGrid.FixedRows = 0
DOMGrid.ScrollTrack = True
DOMGrid.FocusRect = flexFocusNone

setCellContents 0, DOMColumns.PriceLeft, "Price"
DOMGrid.ColWidth(DOMColumns.PriceLeft) = 24 * DOMGrid.width / 100
DOMGrid.ColAlignment(DOMColumns.PriceLeft) = flexAlignRightCenter

setCellContents 0, DOMColumns.bidSize, "Bids"
DOMGrid.ColWidth(DOMColumns.bidSize) = 14 * DOMGrid.width / 100
DOMGrid.ColAlignment(DOMColumns.bidSize) = flexAlignCenterCenter

setCellContents 0, DOMColumns.LastSize, "Last"
DOMGrid.ColWidth(DOMColumns.LastSize) = 14 * DOMGrid.width / 100
DOMGrid.ColAlignment(DOMColumns.LastSize) = flexAlignCenterCenter

setCellContents 0, DOMColumns.askSize, "Asks"
DOMGrid.ColWidth(DOMColumns.askSize) = 14 * DOMGrid.width / 100
DOMGrid.ColAlignment(DOMColumns.askSize) = flexAlignCenterCenter

setCellContents 0, DOMColumns.PriceRight, "Price"
DOMGrid.ColWidth(DOMColumns.PriceRight) = 24 * DOMGrid.width / 100
DOMGrid.ColAlignment(DOMColumns.PriceRight) = flexAlignLeftCenter

End Sub

Private Sub IListener_notify(ByVal valueType As Long, ByVal data As Variant, ByVal timestamp As Date)
Select Case valueType
Case TradeBuildListenValueTypes.ValueTypeTradeBuildMarketdepth
    Dim mdInfo As TickerListenMDData
    mdInfo = data
    If mdInfo.price = 0 And mdInfo.size = 0 Then
        ' this is a reset notification
        reset
    ElseIf mdInfo.size = 0 Then
        clearDOMCell timestamp, mdInfo.side, mdInfo.price
    Else
        setDOMCell timestamp, mdInfo.side, mdInfo.price, mdInfo.size
    End If
End Select

End Sub

Public Property Let Contract(ByVal value As Contract)
Set mContract = value
Me.Caption = "Market depth for " & _
            mContract.specifier.localSymbol & _
            " on " & _
            mContract.specifier.exchange
'mPriceIncrement = IIf(mContract.specifier.currencyCode = "GBP", 100 * mContract.minimumTick, mContract.minimumTick)
mPriceIncrement = mContract.minimumTick
'If mPriceIncrement < 0.01 Then mPriceIncrement = 0.01
End Property

Public Property Let initialPrice(ByVal value As Double)
If mInitialPrice <> 0 Then Exit Property
mInitialPrice = value
setupRows
End Property

Public Property Let numberOfRows(ByVal value As Long)
If mNumberOfRows <> 0 Then Exit Property
mNumberOfRows = value
setupRows
End Property

Public Property Let numberOfVisibleRows(ByVal value As Long)
If mNumberOfVisibleRows <> 0 Then Exit Property
mNumberOfVisibleRows = value
setupRows
End Property


Private Function calcRowNumber(ByVal price As Double) As Long
calcRowNumber = ((mCeilingPrice - price) / mPriceIncrement) + 1
End Function

Private Sub centreRow(ByVal price As Double)
DOMGrid.TopRow = calcRowNumber(price) - Int(mNumberOfVisibleRows / 2)
End Sub

Private Sub checkEnoughRows(ByVal price As Double)
Dim i As Long
Dim rowprice As Double

If price = 0 Then Exit Sub

If (price - mBasePrice) / mPriceIncrement <= 5 Then
    ' add some new list entries at the start
    Do
        For i = 1 To Int(mNumberOfVisibleRows / 2)
            rowprice = mBasePrice - (i * mPriceIncrement)
            DOMGrid.AddItem ""
            setCellContents DOMGrid.Rows - 1, DOMColumns.PriceLeft, Format(rowprice, mFormatString)
            setCellContents DOMGrid.Rows - 1, DOMColumns.PriceRight, Format(rowprice, mFormatString)
        Next
        mBasePrice = rowprice
    Loop Until (price - mBasePrice) / mPriceIncrement > 5
    
    DOMGrid.col = DOMColumns.PriceLeft
    DOMGrid.Sort = flexSortNumericDescending
    centreRow IIf(mCurrentLast <> 0, mCurrentLast, (mCeilingPrice + mBasePrice) / 2)
    
End If

If (mCeilingPrice - price) / mPriceIncrement <= 5 Then
    ' add some new list entries at the end
    Do
        For i = 1 To Int(mNumberOfVisibleRows / 2)
            rowprice = mCeilingPrice + (i * mPriceIncrement)
            DOMGrid.AddItem ""
            setCellContents DOMGrid.Rows - 1, DOMColumns.PriceLeft, Format(rowprice, mFormatString)
            setCellContents DOMGrid.Rows - 1, DOMColumns.PriceRight, Format(rowprice, mFormatString)
        Next
        mCeilingPrice = rowprice
    Loop Until (mCeilingPrice - price) / mPriceIncrement > 5

    DOMGrid.col = DOMColumns.PriceLeft
    DOMGrid.Sort = flexSortNumericDescending
    centreRow IIf(mCurrentLast <> 0, mCurrentLast, (mCeilingPrice + mBasePrice) / 2)

End If

End Sub

Private Sub clearDisplay(ByVal side As DOMSides, ByVal price As Double)
checkEnoughRows price
Select Case side
Case DOMSides.DOMAsk
    setCellContents calcRowNumber(price), DOMColumns.askSize, ""
Case DOMSides.DOMBid
    setCellContents calcRowNumber(price), DOMColumns.bidSize, ""
Case DOMSides.DOMLast
    setCellContents calcRowNumber(price), DOMColumns.LastSize, ""
End Select
End Sub

Public Sub clearDOMCell( _
                ByVal timestamp As Date, _
                ByVal side As DOMSides, _
                ByVal price As Double)
clearDisplay side, price
End Sub

Private Sub setCellContents(ByVal row As Long, ByVal col As Long, ByVal value As String)
Dim currVal As String

currVal = DOMGrid.TextMatrix(row, col)

If (currVal <> "" And value = "") Or _
    (currVal = "" And value <> "") _
Then
    If row <> 0 Then
        DOMGrid.row = row
        DOMGrid.col = col
        If value = "" Then
            DOMGrid.CellBackColor = GridColours.BGDefault
        Else
            Select Case col
            Case DOMColumns.bidSize
                DOMGrid.CellBackColor = GridColours.BGBid
            Case DOMColumns.LastSize
                DOMGrid.CellBackColor = GridColours.BGLast
                DOMGrid.CellFontBold = True
            Case DOMColumns.askSize
                DOMGrid.CellBackColor = GridColours.BGAsk
            Case Else
                DOMGrid.CellBackColor = GridColours.BGDefault
            End Select
        End If
        DOMGrid.row = 1
        DOMGrid.col = 0
    End If
End If
DOMGrid.TextMatrix(row, col) = value
End Sub

Public Sub reset()
mHalted = True
DOMGrid.Clear
Me.Caption = "Market depth data halted"
ReDim mAskPrices(20) As Double
ReDim mBidPrices(20) As Double

mInitialPrice = mCurrentLast

mMaxAskPricesIndex = 0
mMaxBidPricesIndex = 0

mCurrentLast = 0#

setupRows
End Sub


Public Sub setDOMCell( _
                ByVal timestamp As Date, _
                ByVal side As DOMSides, _
                ByVal price As Double, _
                ByVal size As Long)
If mHalted Then
    mHalted = False
    Me.Caption = "Market depth for " & _
                mContract.specifier.localSymbol & _
                " on " & _
                mContract.specifier.exchange
End If
setDisplay side, price, size
End Sub
                
Private Sub setDisplay(ByVal side As DOMSides, ByVal price As Double, ByVal size As Long)
checkEnoughRows price
Select Case side
Case DOMSides.DOMAsk
    setCellContents calcRowNumber(price), DOMColumns.askSize, size
Case DOMSides.DOMBid
    setCellContents calcRowNumber(price), DOMColumns.bidSize, size
Case DOMSides.DOMLast
    setCellContents calcRowNumber(price), DOMColumns.LastSize, size
    mCurrentLast = price
End Select
End Sub

Private Sub setupRows()
Dim i As Long
Dim price As Double
Dim currentListHeight  As Long
Dim currentGridHeight  As Long

If mInitialPrice = 0 Or _
    mNumberOfRows = 0 Or _
    mNumberOfVisibleRows = 0 Or _
    mPriceIncrement = 0 _
Then Exit Sub

mBasePrice = mInitialPrice - (mPriceIncrement * Int(mNumberOfRows / 2))

If mContract.NumberOfDecimals = 0 Then
    mFormatString = "0"
Else
    mFormatString = "0." & String(mContract.NumberOfDecimals, "0")
End If

For i = 0 To mNumberOfRows - 1
    price = mBasePrice + (i * mPriceIncrement)
    DOMGrid.AddItem ""
    setCellContents i + 1, DOMColumns.PriceLeft, Format(price, mFormatString)
    setCellContents i + 1, DOMColumns.PriceRight, Format(price, mFormatString)
    
Next
mCeilingPrice = price

DOMGrid.FixedRows = 1

DOMGrid.col = DOMColumns.PriceLeft
DOMGrid.Sort = flexSortNumericDescending

currentGridHeight = DOMGrid.Height
DOMGrid.Height = (mNumberOfVisibleRows + 1) * DOMGrid.RowHeight(0)
Me.Height = Me.Height + DOMGrid.Height - currentGridHeight

centreRow mInitialPrice

End Sub

