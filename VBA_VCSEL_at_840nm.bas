**VCSEL (VERTICAL-CAVITY-SURFACE-EMITTING-LASER) FOR EMISSION OF LIGHT AT 840 NM, WITH THE UPPER AND LOWER DBR’S (=DISTRIBUTED BRAGG REFLECTORS) HAVING REFLECTIVITIES 98% AND 99.9%

Option Explicit

Sub CalculateOutput()
  '¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤ Definitions of variables ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  Dim i As Long, n As Long
  Dim a As Double, b As Double, c As Double
  
  Dim RefractiveIndexOfLayerA As Double, RefractiveIndexOfLayerB As Double
  Dim ThicknessOfLayerA_nanometers As Double
  Dim NumberOfLayerPairs_UpperDBR As Long, NumberOfLayerPairs_LowerDBR As Long
  
  Dim ThicknessOfLayerB_nanometers As Double, _
      ReflectivityOfDBR_UpperDBR As Double, ReflectivityOfDBR_LowerDBR As Double
  Dim LamdaZero As Double, BandwidthAroundLamdaZero As Double
  Dim RefractiveIndexContrast As Double
  '¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤ End of definitions of variables ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  
  '¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤ Clearing the output ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  Range("tb").Value = ""         'Thickness (nm) of the layer b
  Range("Rf").Value = ""         'Reflectivity of the UPPER DBR 
 Range("rfl").Value = ""        'Reflectivity of the LOWER DBR
 Range("LamdaZero").Value = ""  'Centre wavelength of the 1st photonic bandgap
                                 ' = Bragg wavelength = working wavelength of laser
  Range("Bw").Value = ""         'Bandwidth of the 1st photonic bandgap
  Range("Ric").Value = ""        'Refractive index contrast
  '¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤ The output was cleared ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  
  '¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤ Getting the input data ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  RefractiveIndexOfLayerA = Range("na").Value
  RefractiveIndexOfLayerB = Range("nb").Value
  ThicknessOfLayerA_nanometers = Range("ta").Value
  NumberOfLayerPairs_UpperDBR = Range("np").Value
  NumberOfLayerPairs_LowerDBR = Range("npl").Value
  '¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤ The input data was got ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  
  '¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤ Computing the output data ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  On Error GoTo WRONG_DATA
  
  '===================== Computng the Thickness (nm) of the layer b ===================
  'Because the aim is that the laser will emit light at Bragg wavelength with
  '        maximum intensity which requires the optical thicknesses of the layers
  '        to be equal to a quarter of the Bragg wavelength (LamdaZero),
  '        so the optical thicknesses of all the layers must be equal, which means that
  '        the optical thickness of the first layer in a pair of layers
  '        must be equal to the optical thickness of the second layer in this pair:
  '                ThicknessOfLayerA_nanometers * RefractiveIndexOfLayerA =
  '                ThicknessOfLayerB_nanometers * RefractiveIndexOfLayerB
  'Therefore:
  
  ThicknessOfLayerB_nanometers = _
  ThicknessOfLayerA_nanometers * RefractiveIndexOfLayerA / RefractiveIndexOfLayerB
  '===================== Thickness (nm) of the layer b was computed ===================
  
  '==================== Computing of Reflectivity of the UPPER DBR ====================
  n = 2 * NumberOfLayerPairs_UpperDBR
  
  a = 1
  For i = 1 To n
    a = a * RefractiveIndexOfLayerA
  Next i
  
  b = 1
  For i = 1 To n
    b = b * RefractiveIndexOfLayerB
  Next i
  
  c = (a - b) / (a + b)
  ReflectivityOfDBR_UpperDBR = c * c
  '=================== Reflectivity of the UPPER DBR was computed =====================
  
  '==================== Computing of Reflectivity of the LOWER DBR ====================
  n = 2 * NumberOfLayerPairs_LowerDBR
  
  a = 1
  For i = 1 To n
    a = a * RefractiveIndexOfLayerA
  Next i
  
  b = 1
  For i = 1 To n
    b = b * RefractiveIndexOfLayerB
  Next i
  
  c = (a - b) / (a + b)
  ReflectivityOfDBR_LowerDBR = c * c
  '=================== Reflectivity of the LOWER DBR was computed =====================
  
  '============ Computing the Centre wavelength of the 1st photonic bandgap ===========
  '             1st photonic bandgap = Bragg wavelength = peak reflectance =
  '             representative wavelength for GaAs quantum well emitter
  '             (which is used, for example, in short-range fibre communications)
  
  a = RefractiveIndexOfLayerA * ThicknessOfLayerA_nanometers
  b = RefractiveIndexOfLayerB * ThicknessOfLayerB_nanometers
  
  LamdaZero = 2 * (a + b)
  '============ Centre wavelength of the 1st photonic bandgap was computed ============
    
  '======================= Computing the Refractive index contrast ====================
  a = RefractiveIndexOfLayerA - RefractiveIndexOfLayerB
  a = a / (RefractiveIndexOfLayerA + RefractiveIndexOfLayerB)
  If a < 0 Then a = -a
  RefractiveIndexContrast = a
  '====================== Refractive index contrast was computed ======================
  
  '================== Computing Bandwidth of the 1st photonic bandgap =================
  a = 4 * LamdaZero / WorksheetFunction.Pi()
  BandwidthAroundLamdaZero = a * WorksheetFunction.Asin(RefractiveIndexContrast)
  '================= Bandwidth of the 1st photonic bandgap was computed ===============
  
  GoTo OUTPUT_COMPUTED
  
WRONG_DATA:
  MsgBox "Wrong input data!", vbCritical, "Calculate Output"
  Exit Sub
  
OUTPUT_COMPUTED:
  '¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤ The output data was computed ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  
  '¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤ Presenting the output data ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  Range("tb").Value = ThicknessOfLayerB_nanometers
  Range("Rf").Value = ReflectivityOfDBR_UpperDBR
  Range("rfl").Value = ReflectivityOfDBR_LowerDBR
  Range("LamdaZero").Value = LamdaZero
  Range("Bw").Value = BandwidthAroundLamdaZero
  Range("Ric").Value = RefractiveIndexContrast
  '¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤ The output data was presented ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
End Sub






Sub GenerateInputForMatlabProgram()
  Dim i As Long, j As Long, a As Double, s As String
  Dim NumberOfPairsInOneBraggReflector_UpperDBR As Long
  Dim NumberOfPairsInOneBraggReflector_LowerDBR As Long
  Dim ThicknessOfLayerA As String, RefractiveIndexOfLayerA As String
  Dim ThicknessOfLayerB As String, RefractiveIndexOfLayerB As String
  
  '¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤ Getting the input data ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  NumberOfPairsInOneBraggReflector_UpperDBR = Worksheets("Sheet1").Range("np").Value
  NumberOfPairsInOneBraggReflector_LowerDBR = Worksheets("Sheet1").Range("npl").Value
  
  s = Worksheets("Sheet1").Range("ta").Value
  s = FormatNumber(s, 2):  s = Replace$(s, ",", ".")
  ThicknessOfLayerA = s
  
  s = Worksheets("Sheet1").Range("na").Value
  s = FormatNumber(s, 2):  s = Replace$(s, ",", ".")
  RefractiveIndexOfLayerA = s
  
  s = Worksheets("Sheet1").Range("tb").Value
  s = FormatNumber(s, 2):  s = Replace$(s, ",", ".")
  ThicknessOfLayerB = s

  s = Worksheets("Sheet1").Range("nb").Value
  s = FormatNumber(s, 2):  s = Replace$(s, ",", ".")
  RefractiveIndexOfLayerB = s
  '¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤ The input data was got ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  
  Open ThisWorkbook.Path & "\MATLAB\InputDataForMatlabProgram.dat" For Output As #1
  j = 0
  
  '¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤ The upper Bragg reflector ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  For i = 1 To NumberOfPairsInOneBraggReflector_UpperDBR
    j = j + 1
    s = j & vbTab & ThicknessOfLayerA & vbTab & RefractiveIndexOfLayerA
    Print #1, s
    j = j + 1
    
    If i = NumberOfPairsInOneBraggReflector_UpperDBR Then
      a = CDbl(ThicknessOfLayerB)
      a = a * 2
      s = CStr(a):  s = FormatNumber(s, 2):  s = Replace$(s, ",", ".")
    Else
      s = ThicknessOfLayerB
    End If
    
    s = j & vbTab & s & vbTab & RefractiveIndexOfLayerB
    Print #1, s
  Next i
  '¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤ End of the upper Bragg reflector ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  
  '¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤ The lower Bragg reflector ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  For i = 1 To NumberOfPairsInOneBraggReflector_LowerDBR
    j = j + 1
    s = j & vbTab & ThicknessOfLayerA & vbTab & RefractiveIndexOfLayerA
    Print #1, s
    
    j = j + 1
    s = j & vbTab & ThicknessOfLayerB & vbTab & RefractiveIndexOfLayerB
    Print #1, s
  Next i
  '¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤ End of the lower Bragg reflector ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  
  Close #1
End Sub


*TOPIC 2. LIGHT PROPAGATION IN PHOTONIC CRYSTALS

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


