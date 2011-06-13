unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, ExtCtrls, Stacks, Jpeg, Tree;

const
  _CellWidth = 60;
  _CellHeight = 60;
  BoardSize = 5;

type
  TQueenAction = (GetBoard, CheckingIfSolution, FindPlaceToNewQueen);

  TQueenForm = class(TForm)
    LogMemo: TMemo;
    Button1: TButton;
    Timer1: TTimer;
    Button2: TButton;
    Button3: TButton;
    Label1: TLabel;
    BoardPanel: TPanel;
    ScrollBox1: TScrollBox;
    Image: TImage;
    StopCheckBox: TCheckBox;
    SolutionsList: TListBox;
    Button4: TButton;
    Label2: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure StopCheckBoxClick(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    VisualBoard: array[1..BoardSize,1..BoardSize] of TImage;
    SolutionCounter: integer;             {счЄтчик количества решений}
    board: TBoard;          {собственно доска, тип объ€влен в модуле Stacks}
    Stack: PStack;              {собственно указатель на стек. тип объ€влен в модуле Stacks}
    CurrQueen: byte;        {текущий расставл€емый ферзь}
    itr, QueenHereCounter: byte;              {переменна€-итератор (нужна дл€ поиска места установки нового ферз€)}
    PrevAbsBoardPos: integer; //позици€ предыдущего ферз€ на предыдущей линии (нужно дл€ дерева)
    CurrAction: TQueenAction;   {действие, выполн€емой в данный момент}
    FirstIteration: boolean;    {флаг, указывающий - будет ли следующа€ выполн€ема€ итераци€ - первой во всЄм бектрекинге}
    StopIfFoundSolution: boolean;
    function ClearBoard: TBoard;      {функци€ очищает доску}
    procedure SetQueenOnBoard(var a: TBoard; x,y: byte);        {процедура помещает ферз€ на доску в коодинаты (x;y) и помечает клетки доски, наход€щиес€ по ударом этого ферз€}
    procedure DrawBoard(board: TBoard);                         {вывести состо€ние доски в Grid}
    function IterateS: boolean;                                 {собственно сама ключева€ процедура}
    procedure WriteSolutionIntoList(board: TBoard);
  public
    { Public declarations }
  end;

var
  QueenForm: TQueenForm;

implementation

{$R *.dfm}

{ TQueenForm }

procedure TQueenForm.DrawBoard(board: TBoard);
const
  GlyphDir = 'glyph\';
var
  i,j: byte;
  BlackCell: byte;
  FileName: string;
begin
  {output board into BoardPanel}
  for i:=1 to BoardSize do
    for j:=1 to BoardSize do
    begin
      BlackCell:= ((i+j) mod 2);
      case board[i,j] of
        cQueen: FileName:= Format('queen-%d.jpg',[BlackCell]);
        cFree: FileName:= Format('free-%d.jpg',[BlackCell]);
        cUnderAttack: FileName:= Format('underattack-%d.jpg',[BlackCell]);
      end;
      VisualBoard[i,j].Picture.LoadFromFile(GlyphDir + FileName);
    end;
end;

function TQueenForm.ClearBoard: TBoard;
var
  i,j: byte;
  board: TBoard;
begin
  for i:= 1 to BoardSize do
    for J:= 1 to BoardSize do
      board[i,j]:=cFree;
  result:=board;
end;


procedure TQueenForm.SetQueenOnBoard(var a: TBoard; x, y: byte);
 {x, y Ч координаты вставки ферз€}
var
	i, j:integer;
begin
	for i:= 1 to BoardSize do
  begin
		a[x,i]:=cUnderAttack; {помечаем строку и столбец, где будет сто€ть ново€вленный ферзь как Ђпод боемї}
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
		a[i,j]:=cUnderAttack;    {почемаем диагональ слева вниз от (x,y)}
		inc(i);
		dec(j);
  end;
	a[x,y]:=cQueen;    {помечаем "‘ерзЄм" клетку (x,y)}
end;




procedure TQueenForm.Button1Click(Sender: TObject);
begin
  if timer1.Enabled then
    button1.Caption:='запустить выполнение итераций  по таймеру'
  else
    button1.Caption:='остановить выполнение итераций  по таймеру';
  timer1.enabled:= not Timer1.Enabled;
end;

procedure TQueenForm.Timer1Timer(Sender: TObject);
begin
  if IterateS then
  begin
    timer1.enabled:=False;
    LogMemo.Lines.Add('EndCycle');
    LogMemo.Lines.Add(Format('%d solutions',[SolutionCounter]));
  end;
end;

procedure TQueenForm.FormCreate(Sender: TObject);
var
  i,j: byte;
begin
  FirstIteration:=True;
  StopIfFoundSolution:= True;
  SolutionCounter:=0;
  BoardPanel.Width:= BoardSize * _CellWidth;
  BoardPanel.Height:= BoardSize * _CellHeight;
  for i:=1 to BoardSize do
    for j:=1 to BoardSize do
      begin
        VisualBoard[i,j]:=TImage.Create(self);
        with VisualBoard[i,j] do
        begin
          Parent:=BoardPanel;
          Left:= (j-1)*_CellWidth;
          Top:= (i-1)*_CellHeight;
          Width:= _CellWidth;
          Height:= _CellHeight;
          AutoSize:= True;
        end;
      end;
  Tree.ImageInit;
end;

procedure TQueenForm.Button2Click(Sender: TObject);
begin
  if IterateS then
  begin
    LogMemo.Lines.Add('EndCycle');
    LogMemo.Lines.Add(Format('%d solutions',[SolutionCounter]));
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
      application.ProcessMessages;
    end;
end;

function TQueenForm.IterateS: boolean;
{процедура, выполн€юща€ один шаг итерационного бектрекинга со стеком.
 ¬ папке backtracking-pascal, в файле btr.pas расписаны процедуры, послужившие
 основой создани€ этой процедуры.

 возвращает True, если цикл завершЄн}
var
	copy: TBoard;
begin
  LogMemo.Lines.Add('<Iteration>');
	if FirstIteration then
	begin
    LogMemo.Lines.Add ('It''s a First Iteration');
    CreateStack (Stack);
    PrevAbsBoardPos:= 1;
    PushStack (Stack, 1, ClearBoard, PrevAbsBoardPos);
    CurrAction:= GetBoard;
    FirstIteration:= False;
    QueenHereCounter:= 0; //пор€дковый номер фезр€, который можно поставить на текущей строке
    DrawUnit (1, 1, PrevAbsBoardPos, 1);
	end;
	
	case CurrAction of
		GetBoard:
			begin
        LogMemo.Lines.Add('Getting board from Stack');
				if Stack = nil then
				begin
          LogMemo.Lines.Add('quiting from cycle');
					result:=True;
					exit;
				end;
				PopStack (Stack, currQueen, board, PrevAbsBoardPos);
        DrawBoard(board);            //необ€зательна€ строка кажись
				CurrAction:= CheckingIfSolution;
				itr:= 1;
			end;
		
		CheckingIfSolution:
			begin
        LogMemo.Lines.Add ('checking if a new solution');
				if currQueen = BoardSize + 1 then	{we got a new solution, lets remind about it}
				begin
					LogMemo.Lines.Add ('we fucking got a new solution');
          WriteSolutionIntoList (board);
          if StopIfFoundSolution then
            timer1.Enabled:= False; //выключить таймер при нахождении решени€
          Inc (SolutionCounter);
          CurrAction:= GetBoard;
				end
				else
					CurrAction:= FindPlaceToNewQueen;
			end;

		FindPlaceToNewQueen:
			begin {what about skiping this part in timer and just show a free place to set?}
        LogMemo.Lines.Add('Finding new place for the ' + inttostr (CurrQueen) + 'th queen');
				if board[currQueen, itr] = cFree then
				begin
          LogMemo.Lines.Add ('Found place. Adding it to the Queue');
					copy:= board;
					SetQueenOnBoard (copy, currQueen, itr);
          //{}DrawBoard(copy);
          Inc (QueenHereCounter);
					PushStack (Stack, CurrQueen + 1, copy, CurrAbsBoardPos (CurrQueen, QueenHereCounter, PrevAbsBoardPos));
          DrawUnit (CurrQueen, QueenHereCounter, PrevAbsBoardPos, itr); 
				end;
				if itr = BoardSize then
        begin
					CurrAction:= GetBoard;
          QueenHereCounter:= 0;
        end
				else
					inc(itr);
			end;
	end;

	//write_board;
  //DrawBoard(board);
  LogMemo.Lines.Add('</Iteration>');
  result:=False;
end;

procedure TQueenForm.FormDestroy(Sender: TObject);
var
  i,j: byte;
begin
  for i:=1 to BoardSize do
    for j:=1 to BoardSize do
      VisualBoard[i,j].Free;
end;

procedure TQueenForm.StopCheckBoxClick(Sender: TObject);
begin
  StopIfFoundSolution:=StopCheckBox.Checked;
end;

procedure TQueenForm.Button4Click(Sender: TObject);
begin
  FirstIteration:=True;
  board:= ClearBoard;
  DrawBoard(board);
  SolutionsList.Clear;
end;

procedure TQueenForm.WriteSolutionIntoList(board: TBoard);
const
  chars: array[1..10] of char = ('a','b','c','d','e','f','g','h','j','k');
var
  i,j: byte;
  Solution: string;
begin
  for j:=1 to BoardSize do
    for i:=1 to BoardSize do
      if board[i,j]=cQueen then
        solution:=solution + chars[j] + inttostr(BoardSize - i + 1) + ' ';
  SolutionsList.Items.Add(Solution);
end;

end.
