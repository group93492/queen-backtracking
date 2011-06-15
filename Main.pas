unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, ExtCtrls, Stacks, Jpeg, Tree, Spin;

const
  _CellWidth = 60;
  _CellHeight = 60;
  _IndentLeft  = 15;
  _IndentTop  = 15;
  defBoardSize = 5;

type
  TQueenAction = (GetBoard, CheckingIfSolution, FindPlaceToNewQueen);

  TQueenForm = class(TForm)
    LogMemo: TMemo;
    Button1: TButton;
    Timer1: TTimer;
    Button2: TButton;
    Button3: TButton;
    Label1: TLabel;
    ScrollBox: TScrollBox;
    Image: TImage;
    StopCheckBox: TCheckBox;
    SolutionsList: TListBox;
    ResetButton: TButton;
    Label2: TLabel;
    VisualBoard: TImage;
    BoardSizeEdit: TSpinEdit;
    Label3: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure StopCheckBoxClick(Sender: TObject);
    procedure ResetButtonClick(Sender: TObject);
    procedure StartTimer;
    procedure StopTimer;
    procedure BoardSizeEditChange(Sender: TObject);
    procedure BoardSizeEditKeyPress(Sender: TObject; var Key: Char);
  private
    SolutionCounter: integer;             {счётчик количества решений}
    board: TBoard;          {собственно доска, тип объявлен в модуле Stacks}
    Stack: PStack;              {собственно указатель на стек. тип объявлен в модуле Stacks}
    CurrQueen: byte;        {текущий расставляемый ферзь}
    itr, QueenHereCounter: byte;              {переменная-итератор (нужна для поиска места установки нового ферзя)}
    PrevAbsBoardPos: integer; //позиция предыдущего ферзя на предыдущей линии (нужно для дерева)
    CurrAction: TQueenAction;   {действие, выполняемой в данный момент}
    FirstIteration: boolean;    {флаг, указывающий - будет ли следующая выполняемая итерация - первой во всём бектрекинге}
    StopIfFoundSolution: boolean;
    function ClearBoard: TBoard;      {функция очищает доску}
    procedure SetQueenOnBoard(var a: TBoard; x,y: byte);        {процедура помещает ферзя на доску в коодинаты (x;y) и помечает клетки доски, находящиеся по ударом этого ферзя}
    procedure DrawBoard(board: TBoard);                         {вывести состояние доски в Grid}
    function IterateS: boolean;                                 {собственно сама ключевая процедура}
    procedure WriteSolutionIntoList(board: TBoard);
    procedure SetBoardSize(Value: byte);
  public
    { Public declarations }
  end;

var
  QueenForm: TQueenForm;
  BoardSize: byte;

implementation

{$R *.dfm}

{ TQueenForm }

procedure ClearCanvas(Canvas: TCanvas);
var
  o_brush,o_pen: TColor;
begin
  o_brush:=Canvas.Brush.Color;
  o_pen:=Canvas.Pen.Color;
  Canvas.Pen.Color:=clWhite;
  Canvas.Brush.Color:=clWhite;
  Canvas.Rectangle(Canvas.ClipRect);
  Canvas.Pen.Color:=o_pen;
  Canvas.Brush.Color:=o_brush;
end;


procedure TQueenForm.DrawBoard(board: TBoard);
//быдлорисовка шахматного поля. быдло-пребыдло.
//но мне нравится :3
const
  GlyphDir = 'glyph\';
  chars = 'ABCDEFGHIJ';
var
  i,j: byte;
  BlackCell: boolean;
  FileName: string;
  TempBMP: TBitmap;
begin
  {output board into VisualBoard - TImage}
  TempBMP:=TBitmap.Create;
  VisualBoard.Picture:= nil;
  VisualBoard.Width:= BoardSize * _CellWidth + _IndentLeft;
  VisualBoard.Height:= BoardSize  * _CellHeight + _IndentTop;
 // ClearCanvas(VisualBoard.Canvas);
  BlackCell:=False;
  //draw cells of board
  for i:=1 to BoardSize do
  begin
    for j:=1 to BoardSize do
    begin
      case board[j,i] of    {ктати если сделать board[i,j] - то визуально ферзи будут расставляться по столбцам}
        cQueen: FileName:= Format('queen-%d.bmp',[ord(BlackCell)]);
        cFree: FileName:= Format('free-%d.bmp',[ord(BlackCell)]);
        cUnderAttack: FileName:= Format('underattack-%d.bmp',[ord(BlackCell)]);
      end;
      TempBMP.LoadFromFile(GlyphDir + FileName);
     { VisualBoard.Canvas.CopyRect(rect(i*_CellWidth, j*_CellHeight, (i+1)*_CellWidth, (j+1)*_CellHeight),
                                  TempBMP.Canvas,
                                  rect(0, 0, _CellWidth, _CellHeight)
                                  );                              }
      BitBlt(VisualBoard.Canvas.Handle,
             _IndentLeft + (i-1)*_CellWidth, _IndentTop + (j-1)*_CellHeight,
             _CellWidth, _CellHeight,
             TempBMP.Canvas.Handle,
             0, 0, SRCCOPY);
      BlackCell:= not BlackCell;
    end;
    if (BoardSize mod 2) = 0 then
      BlackCell:=not BlackCell;
  end;

  //draw captions for rows and columns
  for i:=1 to BoardSize do
  begin
    With VisualBoard.Canvas do
    begin
      Font.Size:= 9;
      Font.Style:=Font.Style + [fsBold];
      TextOut(_IndentLeft + (i-1)*_CellWidth + (_CellWidth - TextWidth(chars[i])) div 2,
              (_IndentTop - TextHeight(chars[i])) div 2,
              chars[i]
              );          {columns}
      TextOut((_IndentLeft - TextWidth(inttostr(BoardSize - i + 1))) div 2,
              _IndentTop + (i-1)*_CellHeight + (_CellHeight - TextHeight(inttostr(BoardSize - i + 1))) div 2,
              inttostr(BoardSize - i + 1)
              );           {rows}
    end;
  end;
  TempBMP.Free;
end;

function TQueenForm.ClearBoard: TBoard;
var
  i,j: byte;
  board: TBoard;
begin
  for i:= 1 to BoardSize do
    for J:= 1 to BoardSize do
      board[i,j]:= cFree;
  Result:= board;
end;


procedure TQueenForm.SetQueenOnBoard(var a: TBoard; x, y: byte);
 {x, y — координаты вставки ферзя}
var
	i, j:integer;
begin
	for i:= 1 to BoardSize do
  begin
		a[x,i]:=cUnderAttack; {помечаем строку и столбец, где будет стоять новоявленный ферзь как «под боем»}
		a[i,y]:=cUnderAttack;
	end;
	i:=x-1;     {переходим в левую верхнюю клетку по диагонали от (x;y)}
  j:=y-1;
	while (i<>0) and (j<>0) do
	begin
		a[i,j]:=cUnderAttack;   {помечаем диагональ слева и вверх от (x,y) }
		dec(i);
		dec(j);
  end;
	i:=x+1;      {переходим в правую нижнюю клетку по диагонали от (x,y)}
	j:=y+1;
	while (i<>BoardSize+1) and (j<>BoardSize+1) do
  begin
		a[i,j]:=cUnderAttack;    {помечаем диагональ справа вниз от (x,y) }
		inc(i);
		inc(j);
  end;
	i:=x-1;      {переходим в правую верхнюю клетку}
	j:=y+1;
	while (i<>0) and (j<>BoardSize+1) do
  begin
		a[i,j]:=cUnderAttack;    {помечаем диагональ справа вверх от (x,y)}
		dec(i);
		inc(j);
  end;
	i:=x+1;   {переходим в левую нижнюю клетку от (x,y)}
	j:=y-1;
	while (i<>BoardSize+1) and (j<>0) do
  begin
		a[i,j]:=cUnderAttack;    {помечаем диагональ слева вниз от (x,y)}
		inc(i);
		dec(j);
  end;
	a[x,y]:=cQueen;    {помечаем "ферзём" клетку (x,y)}
end;




procedure TQueenForm.Button1Click(Sender: TObject);
begin
  if timer1.Enabled then
    StopTimer
  else
    StartTimer;
end;

procedure TQueenForm.Timer1Timer(Sender: TObject);
begin
  if IterateS then
  begin
    StopTimer;
    LogMemo.Lines.Add('Цикл завершён.');
    LogMemo.Lines.Add(Format('Найдено %d решений(я)',[SolutionCounter]));
  end;
end;

procedure TQueenForm.FormCreate(Sender: TObject);
begin
  FirstIteration:=True;
  StopIfFoundSolution:= True;
  SolutionCounter:=0;
  BoardSizeEdit.MaxValue:= Stacks.maxBoardSize;
  BoardSizeEdit.Value:= defBoardSize;
  BoardSize:= defBoardSize;
  board:= ClearBoard;
  DrawBoard (board);
  Tree.ImageInit;
  Application.HintPause:=50;
  Application.HintHidePause:=5000;
end;

procedure TQueenForm.Button2Click(Sender: TObject);
begin
  if IterateS then
  begin
    LogMemo.Lines.Add('Цикл завершён.');
    LogMemo.Lines.Add(Format('Найдено %d решений(я)',[SolutionCounter]));
  end;
end;

procedure TQueenForm.Button3Click(Sender: TObject);
var
  c: boolean;
begin
  c:=False;
  while not c do
  begin
    c:=IterateS;
    Application.ProcessMessages;
  end;
  LogMemo.Lines.Add('Цикл завершён.');
  LogMemo.Lines.Add(Format('Найдено %d решений(я)',[SolutionCounter]));
end;

procedure TQueenForm.SetBoardSize (Value: byte);
begin
  Main.BoardSize:= Value;
  Tree.ImageInit;
  QueenForm.ResetButtonClick (Self);
  if not FirstIteration then
    FirstIteration:= True;
  board:= ClearBoard;
  DrawBoard (board);
end;

function TQueenForm.IterateS: boolean;
{процедура, выполняющая один шаг итерационного бектрекинга со стеком.
 В папке backtracking-pascal, в файле btr.pas расписаны процедуры, послужившие
 основой создания этой процедуры.

 возвращает True, если цикл завершён}
const
  chars= 'ABCDEFGHIJ';
var
	copy: TBoard;
begin
  LogMemo.Lines.Add('<Начало итерации.>');
	if FirstIteration then
	begin
    LogMemo.Lines.Add ('Это первая итерация.');
    LogMemo.Lines.Add('Добавляем в стек пустую расстановку');
    CreateStack (Stack);
    PrevAbsBoardPos:= 1;
    PushStack (Stack, 1, ClearBoard, PrevAbsBoardPos);
    CurrAction:= GetBoard;
    FirstIteration:= False;
    QueenHereCounter:= 0; //порядковый номер фезря, который можно поставить на текущей строке
    DrawUnit (1, 1, PrevAbsBoardPos, 1);
	end;

	case CurrAction of
		GetBoard:
			begin
        LogMemo.Lines.Add('Получаем текущую расстановку из стека.');
				if Stack = nil then
				begin
          LogMemo.Lines.Add('Стек пуст, цикл завершается.');
					result:=True;
					exit;
				end;
				PopStack (Stack, currQueen, board, PrevAbsBoardPos);
        DrawBoard(board);            //необязательная строка кажись
				CurrAction:= CheckingIfSolution;
				itr:= BoardSize;
			end;

		CheckingIfSolution:
			begin
        LogMemo.Lines.Add ('Проверяем, является ли текущая расстановка готовым решением.');
				if CurrQueen = BoardSize + 1 then	{we got a new solution, lets remind about it}
				begin
					LogMemo.Lines.Add ('Проверка пройдена, у нас есть решение.');
          WriteSolutionIntoList (board);
          MarkGoodThread (CurrQueen - 1, PrevAbsBoardPos);
          if StopIfFoundSolution then
            StopTimer; //выключить таймер при нахождении решения
          Inc (SolutionCounter);
          CurrAction:= GetBoard;
				end
				else
        begin
					CurrAction:= FindPlaceToNewQueen;
          LogMemo.Lines.Add (Format('Находим позицию для ферзя номер %d.',[CurrQueen]));
        end;
			end;

		FindPlaceToNewQueen:
			begin {what about skiping this part in timer and just show a free place to set?}
        //LogMemo.Lines.Add (Format('Находим позицию для ферзя номер %d.',[CurrQueen]));
				if board[currQueen, itr] = cFree then
				begin
          LogMemo.Lines.Add (Format('Ферзя можно поставить на позицию %s%d.',[chars[itr],BoardSize - currQueen + 1]));
          LogMemo.Lines.Add('Добавляем его в расстановку и добавляем расстановку в стек.');
					copy:= board;
					SetQueenOnBoard (copy, currQueen, itr);
          //{}DrawBoard(copy);
          Inc (QueenHereCounter);
					PushStack (Stack, CurrQueen + 1, copy, CurrAbsBoardPos (CurrQueen, QueenHereCounter, PrevAbsBoardPos));

          DrawUnit (CurrQueen, QueenHereCounter, PrevAbsBoardPos, itr);
				end
        else
          LogMemo.Lines.Add (Format('Нельзя ставить ферзя на позицию %s%d.',[chars[itr],BoardSize - currQueen + 1]));
				if itr = 1 then
        begin
          LogMemo.Lines.Add('Поиск позиции для нового ферзя завершён.');
					CurrAction:= GetBoard;
          if QueenHereCounter = 0 then
            MarkBadThread (CurrQueen - 1, PrevAbsBoardPos);
          QueenHereCounter:= 0;
        end
				else
				  Dec(itr);
			end;
	end;

  //DrawBoard(board);
  LogMemo.Lines.Add ('<Конец итерации.>');
  result:= False;
end;

procedure TQueenForm.StopCheckBoxClick(Sender: TObject);
begin
  StopIfFoundSolution:=StopCheckBox.Checked;
end;

procedure TQueenForm.ResetButtonClick (Sender: TObject);
begin
  StopTimer;
  FirstIteration:= True;
  SolutionCounter:=0;
  board:= ClearBoard;
  DrawBoard (board);
  SolutionsList.Clear;
  ClearStack (Stack);
  Tree.ClearTree;
end;

procedure TQueenForm.WriteSolutionIntoList(board: TBoard);
const
  chars= 'ABCDEFGHIJ';
var
  i,j: byte;
  Solution: string;
begin
  for i:=1 to BoardSize do
    for j:=1 to BoardSize do
      if board[i,j]= cQueen then
        Solution:= Solution + chars[j] + IntToStr (BoardSize - i + 1) + ' ';
  SolutionsList.Items.Add (Solution);
end;

procedure TQueenForm.StartTimer;
begin
  button1.Caption:='Остановить автоматическое выполнение';
  Timer1.enabled:= True;
end;

procedure TQueenForm.StopTimer;
begin
  button1.Caption:='Запустить автоматическое выполнение';
  Timer1.enabled:= False;
end;

procedure TQueenForm.BoardSizeEditChange(Sender: TObject);
begin
  SetBoardSize (BoardSizeEdit.Value);
end;

procedure TQueenForm.BoardSizeEditKeyPress(Sender: TObject; var Key: Char);
begin
  Key:=#0;
end;

end.
