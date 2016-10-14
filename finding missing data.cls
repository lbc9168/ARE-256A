VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "ThisWorkbook"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
Sub Sheet1()

Dim a As Single
Dim c As Single
Dim d As Single
Dim e As Single
Dim m As Single
Dim n As Single

Range("A1").Select

a = 1
c = 3
d = 4
e = 5
m = 2
n = 2

For k = 1 To 3
    
    Do Until Cells(m, a) <> Cells(n, d)
        ActiveCell.Cells(m, c) = Cells(n, e)
        m = m + 1
        n = n + 1
    Loop
    
    m = m + 1
    
    Next k

End Sub
