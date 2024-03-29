**LIGHT PROPAGATION IN PHOTONIC CRYSTALS

2.1. DEPENDENCE OF REFLECTION COEFFICIENT (R) FROM THE NUMBER OF LAYERS 2(N+1)

Option Explicit

Private Sub CalculateOutputButton_Click()
  Dim i As Integer, n As Integer
  Dim r As Double, a As Double, b As Double, c1 As Double, c2 As Double
  Dim beginning As Integer, ending As Integer, step As Integer
  Dim row As Long, FromRow As Long, FromColumn As Long
  Dim LowerIndex As Double, HigherIndex As Double
  
  beginning = Range("beginning").Value
  ending = Range("ending").Value
  step = Range("step").Value
  FromRow = Range("OutputN").row
  FromColumn = Range("OutputN").Column
  LowerIndex = Range("LowerIndex").Value
  HigherIndex = Range("HigherIndex").Value
  
  row = FromRow
  For n = beginning To ending Step step
    row = row + 1
    a = HigherIndex / LowerIndex
    a = a * a
    b = 1
    For i = 1 To n
      b = b * a
    Next i
    b = b * HigherIndex * HigherIndex
    c1 = 1 - b
    c2 = 1 + b
    r = c1 / c2
    r = r * r
    Cells(row, FromColumn).Value = n
    Cells(row, FromColumn + 1).Value = 2 * n + 1
    Cells(row, FromColumn + 2).Value = r
  Next n
End Sub


** 2.2. ESTIMATING THE ACCEPTABILITY OF APPROXIMATION OF
DEPENDENCE OF RELATIVE BANDGAP WIDTH FROM REFLECTION AT INTERFACE OF TWO LAYERS WITHIN A PAIR

Option Explicit

Private Sub CalculateOutputButton_Click()
  Dim r As Double, beginning As Double, ending As Double, step As Double
  Dim arcsinr As Double, RelError As Double
  Dim row As Long, FromRow As Long, FromColumn As Long
  
  beginning = Range("beginning").Value
  ending = Range("ending").Value
  step = Range("step").Value
  FromRow = Range("OutputArcsin").row
  FromColumn = Range("OutputArcsin").Column
  
  row = FromRow
  For r = beginning To ending Step step
    row = row + 1
    
    arcsinr = WorksheetFunction.Asin(r)
    RelError = (arcsinr - r) / arcsinr
    If RelError < 0 Then RelError = -RelError
    
    Cells(row, FromColumn).Value = arcsinr
    Cells(row, FromColumn + 1).Value = r
    Cells(row, FromColumn + 2).Value = RelError * 100
  Next r
End Sub
