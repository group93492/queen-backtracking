unit Tree;

interface

uses
  SysUtils{, Stacks};
  
function CurrAbsBoardPos (CurrLevel, CurrBoardPos, PrevAbsBoardPos: integer): integer;
procedure DrawUnit (CurrLevel, CurrBoardCount, PrevAbsBoardPos, CurrBoardPos: integer);
procedure ImageInit;
procedure MarkBadThread (Level, AbsBoardPos: integer);
procedure MarkGoodThread (Level, AbsBoardPos: integer);
procedure ClearTree;
  
implementation

uses
  Main, Graphics, Types;

const
  MaxBoardSizeForTree = 6;
  MarkColor = clGreen;
  NormalColor = clBlack;
  NormalWidth = 1;
  NormalBrushColor = clWhite;
  BadLineColor = clRed;
  BadLineLength = 10;
  BadLineWidth = 3;
  GoodCircleColor = clGreen;
  GoodCircleRadius = 7;
  LineWidth = 35;
  LineHeight = 50;
  UnitRadius = 3;
  TextDistance = 3;
  Start: TPoint = (x: 300; y: 20);

{вычисление максимального количества вариантов, которые могут быть на определённой строке}
function MaxVariants (value: byte): cardinal;
var
  itr, Max: shortint;
begin
  if value = 0 then
  begin
    Result:= 1;
    Exit;
  end;
  Result:= BoardSize;
  if value = 1 then
    Exit;
  Max:= BoardSize - 2;
  if BoardSize < 6 then
  begin
    for itr:= 2 to value do
    begin
      Result:= Result * Max;
      if Max > 1 then
        Dec (Max);
    end;
  end
  else
    for itr:= 2 to value do
      begin
        Result:= Result * Max;
        if Max > 2 then
          Dec (Max);
      end;
end;

function CanDrawTree (BoardSize: shortint): boolean;
begin
  if BoardSize > MaxBoardSizeForTree then
  begin
    Main.QueenForm.Image.Visible:= false;
    Result:= false;
  end
  else
  begin
    Main.QueenForm.Image.Visible:= true;
    Result:= true;
  end;
end;

procedure ClearTree;
begin
  if CanDrawTree (BoardSize) then
    Main.QueenForm.Image.Canvas.FillRect (Main.QueenForm.Image.Canvas.ClipRect);
end; 

procedure ImageInit;
begin
  if CanDrawTree (BoardSize) then
    with Main.QueenForm.Image do
    begin
      Canvas.Brush.Color := clWhite;
      Picture:= nil;
      Height:= (BoardSize + 1) * LineHeight + Start.Y;
      Width:= MaxVariants (BoardSize) * LineWidth + Start.X;
      Canvas.Font.Color:= clBlue;
    end;
end;

function CurrAbsBoardPos (CurrLevel, CurrBoardPos, PrevAbsBoardPos: integer): integer;
begin
  Result:= MaxVariants (CurrLevel) div MaxVariants (CurrLevel - 1) * (PrevAbsBoardPos - 1) + CurrBoardPos;
end;

procedure DrawUnit (CurrLevel, CurrBoardCount, PrevAbsBoardPos, CurrBoardPos: integer);
const
  chars = 'ABCDEFGHIJ';
var
  PrevCoord, CurrCoord: TPoint;
begin
  if CanDrawTree (BoardSize) then
    begin
    CurrCoord.X:= Main.QueenForm.Image.Width div MaxVariants (CurrLevel) * CurrAbsBoardPos (CurrLevel, CurrBoardCount - 1, PrevAbsBoardPos) + 
                  Main.QueenForm.Image.Width div MaxVariants (CurrLevel) div 2;
    CurrCoord.Y:= Start.Y + CurrLevel * LineHeight;
    Dec (CurrLevel); //для вычисления предыдущей координаты
    PrevCoord.X:= Main.QueenForm.Image.Width div MaxVariants (CurrLevel) * (PrevAbsBoardPos - 1) +
    Main.QueenForm.Image.Width div MaxVariants (CurrLevel) div 2;
    PrevCoord.Y:= Start.Y + CurrLevel * LineHeight; 
    with Main.QueenForm.Image.Canvas do
    begin
      MoveTo (PrevCoord.X, PrevCoord.Y);
      LineTo (CurrCoord.X, CurrCoord.Y);
      Ellipse (CurrCoord.X - UnitRadius, CurrCoord.Y - UnitRadius, CurrCoord.X + UnitRadius, CurrCoord.Y + UnitRadius);
      //TextOut (CurrCoord.X + TextDistance, CurrCoord.Y, '(' + IntToStr (CurrLevel + 1) + ', ' + IntToStr (CurrBoardPos) + ')');     //первоначальное именование узлов дерава
      TextOut (CurrCoord.X + TextDistance, CurrCoord.Y, Format('(%s%d)',[chars[CurrBoardPos],BoardSize - CurrLevel]));               //изменено: узел дерева теперь подписан соответствующей постановкой ферзя (B4, A3 etc)
    end;
    with Main.QueenForm.ScrollBox do //показываем изменения в дереве
    begin
      HorzScrollBar.Position:= PrevCoord.X - Width div 2;
      VertScrollBar.Position:= PrevCoord.Y - Height div 2;
    end;
  end;
end;

procedure MarkBadThread (Level, AbsBoardPos: integer);
var
  X, Y: integer;
begin
  if CanDrawTree (BoardSize) then
  begin
    X:= Main.QueenForm.Image.Width div MaxVariants (Level) * (AbsBoardPos - 1) +
        Main.QueenForm.Image.Width div MaxVariants (Level) div 2;
    Y:= Start.Y + Level * LineHeight;
    with Main.QueenForm.Image.Canvas do
    begin
      Pen.Color:= BadLineColor;
      Pen.Width:= BadLineWidth;
      MoveTo (X - BadLineLength div 2, Y - BadLineLength div 2);
      LineTo (X + BadLineLength div 2, Y + BadLineLength div 2);
      MoveTo (X + BadLineLength div 2, Y - BadLineLength div 2);
      LineTo (X - BadLineLength div 2, Y + BadLineLength div 2); 
      Pen.Color:= NormalColor;
      Pen.Width:= NormalWidth;  
    end;
  end;
end;

procedure MarkGoodThread (Level, AbsBoardPos: integer);
var
  X, Y: integer;
begin
  if CanDrawTree (BoardSize) then
  begin
    X:= Main.QueenForm.Image.Width div MaxVariants (Level) * (AbsBoardPos - 1) + 
                  Main.QueenForm.Image.Width div MaxVariants (Level) div 2;
    Y:= Start.Y + Level * LineHeight;
    with Main.QueenForm.Image.Canvas do
    begin
      Pen.Color:= GoodCircleColor;
      Brush.Color:= GoodCircleColor;
      Ellipse (X - GoodCircleRadius, Y - GoodCircleRadius, X + GoodCircleRadius, Y + GoodCircleRadius); 
      Brush.Color:= NormalBrushColor;
      Pen.Color:= NormalColor;
    end;
  end;
end;

{procedure MarkTrueThread (Board: Stacks.TBoard; Color: TColor);
var
  itrCol, itrRow: smallint;
begin
  Main.QueenForm.Image.Canvas.Pen.Color:= MarkColor;
  for itrCol:= 1 to BoardSize do
    for itrRow:= 1 to BoardSize do 
      if Board[itrCol][itrRow] = cQueen then
      begin
        DrawUnit (itrCol,     
      end;
  Main.QueenForm.Image.Canvas.Pen.Color:= NormalColor;
end;}

end.
