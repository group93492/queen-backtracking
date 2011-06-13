unit Tree;

interface

uses
  Types, SysUtils, Stacks;

const

  Start: TPoint = (x: 300; y: 20);
  LineWidth = 35;
  LineHeight = 50;
  UnitRadius = 3;
  TextDistance = 3;

procedure DrawUnit (CurrLevel, CurrBoardCount, PrevAbsBoardPos, CurrBoardPos: integer);
function CurrAbsBoardPos (CurrLevel, CurrBoardPos, PrevAbsBoardPos: integer): integer;
procedure ImageInit;
  
implementation

uses
  Main, Graphics;

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
  for itr:= 2 to value do
  begin
    Result:= Result * Max;
    if Max > 1 then
      Dec (Max);
  end;
end;

procedure ImageInit;
begin
  with Main.QueenForm.Image do
  begin
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
var                                        
  PrevCoord, CurrCoord: TPoint;
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
    TextOut (CurrCoord.X + TextDistance, CurrCoord.Y, '(' + IntToStr (CurrLevel + 1) + ', ' + IntToStr (CurrBoardPos) + ')');
  end;
end;

end.
