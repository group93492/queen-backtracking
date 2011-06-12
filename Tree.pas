unit Tree;

interface

uses
  Types, SysUtils;

const

  Start: TPoint = (x: 20; y: 20);
  LineWidth = 35;
  LineHeight = 50;
  UnitRadius = 3;
  TextDistance = 7;

procedure Draw (level, pos: shortint);
procedure ImageInit;
function fact (value: byte): cardinal;
  
implementation

uses
  Unit1;

function fact2 (value: byte): cardinal;
begin
  if value = 0 then
  begin
    Result:= 0;
    Exit;
  end;
  if value = 1 then
    Result:= 1
  else
    Result:= value * fact2 (value - 1);
end;

function fact (value: byte): cardinal;
var
  itr, max: shortint;
begin
  if value = 0 then
  begin
    Result:= 0;
    Exit;
  end;
  Result:= 1;
  max:= boardsize;
  for itr:= 1 to value do
  begin
    Result:= Result * max;
    dec (max);
  end;
end;

procedure ImageInit;
begin
  Unit1.Form1.Image.Height:= (BoardSize + 1) * LineHeight + Start.Y;
  Unit1.Form1.Image.Width:= fact (BoardSize) * LineWidth + Start.X;
end;
  
procedure Draw (level, pos: shortint);
var
  X, Y, prevpos: shortint;
  PrevCoord, CurrCoord: TPoint;
begin
  CurrCoord.X:= ((fact (BoardSize) - fact (level)) div 2 + pos) * LineWidth;
  CurrCoord.Y:= Start.Y + level * LineHeight;
  prevpos:= (pos - 1) div (BoardSize - level + 1) + 1;
  Dec (level);
  PrevCoord.X:= ((fact (BoardSize) - fact (level)) div 2 + prevpos) * LineWidth;
  if level = 0 then
    dec (PrevCoord.X, LineWidth div 2);
  PrevCoord.Y:= Start.Y + level * LineHeight;
  while pos > (BoardSize - level + 2) do
    pos:= pos - (BoardSize - level + 2);
  Unit1.Form1.Image.Canvas.MoveTo (PrevCoord.X, PrevCoord.Y);
  Unit1.Form1.Image.Canvas.LineTo (CurrCoord.X, CurrCoord.Y);
  Unit1.Form1.Image.Canvas.Ellipse (CurrCoord.X - UnitRadius, CurrCoord.Y - UnitRadius, CurrCoord.X + UnitRadius, CurrCoord.Y + UnitRadius);
  Unit1.Form1.Image.Canvas.TextOut (CurrCoord.X + TextDistance, CurrCoord.Y, '(' + IntToStr (level + 1) + ', ' + IntToStr (pos) + ')');
end;

end.
