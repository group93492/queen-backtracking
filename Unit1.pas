unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, ExtCtrls, Queues, Jpeg;

const
  _CellWidth = 60;
  _CellHeight = 60;

type
  TQueenAction = (GetBoard, CheckingIfSolution, FindPlaceToNewQueen);

  TForm1 = class(TForm)
    LogMemo: TMemo;
    BoardGrid: TStringGrid;
    Button1: TButton;
    Timer1: TTimer;
    Button2: TButton;
    Button3: TButton;
    Label1: TLabel;
    Label2: TLabel;
    BoardPanel: TPanel;
    procedure Button1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    VisualBoard: array[1..BoardSize,1..BoardSize] of TImage;
    SolutionCounter: integer;             {������� ���������� �������}
    board: TBoard;          {���������� �����, ��� �������� � ������ Stacks}
    Queue: PQueue;              {���������� ��������� �� ����. ��� �������� � ������ Stacks}
    CurrQueen: byte;        {������� ������������� �����}
    itr: byte;              {����������-�������� (����� ��� ������ ����� ��������� ������ �����)}
    CurrAction: TQueenAction;   {��������, ����������� � ������ ������}
    FirstIteration: boolean;    {����, ����������� - ����� �� ��������� ����������� �������� - ������ �� ��� �����������}
    function ClearBoard: TBoard;      {������� ������� �����}
    procedure SetQueenOnBoard(var a: TBoard; x,y: byte);        {��������� �������� ����� �� ����� � ��������� (x;y) � �������� ������ �����, ����������� �� ������ ����� �����}
    procedure DrawBoard(board: TBoard);                         {������� ��������� ����� � Grid}
    function IterateS: boolean;                                 {���������� ���� �������� ���������}
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

{ TForm1 }

procedure TForm1.DrawBoard(board: TBoard);
const
  GlyphDir = 'glyph\';
var
  i,j: byte;
  BlackCell: byte;
  FileName: string;
  c: char;
begin
  {output board into stringgrid}
  for j:=1 to BoardSize do
    for i:=1 to BoardSize do
    begin
      case board[j,i] of
        cQueen: c:='Q';
        cFree: c:='_';
        cUnderAttack: c:='*';
        else c:='O';
      end;
      BoardGrid.Cells[i-1, j-1]:=c;
    end;

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

function TForm1.ClearBoard: TBoard;
var
  i,j: byte;
  board: TBoard;
begin
  for i:= 1 to BoardSize do
    for J:= 1 to BoardSize do
      board[i,j]:=cFree;
  result:=board;
end;


procedure TForm1.SetQueenOnBoard(var a: TBoard; x, y: byte);
 {x, y � ���������� ������� �����}
var
	i, j:integer;
begin
	for i:= 1 to BoardSize do
  begin
		a[x,i]:=cUnderAttack; {�������� ������ � �������, ��� ����� ������ ������������ ����� ��� ���� ����}
		a[i,y]:=cUnderAttack;
	end;
	i:=x-1;     {��������� � ����� ������� ������ �� ��������� �� (x;y)}
  j:=y-1;
	while (i<>0) and (j<>0) do
	begin
		a[i,j]:=cUnderAttack;   {�������� ��������� ����� � ����� �� (x,y) }
		dec(i);
		dec(j);
  end;
	i:=x+1;      {��������� � ������ ������ ������ �� ��������� �� (x,y)}
	j:=y+1;
	while (i<>BoardSize+1) and (j<>BoardSize+1) do
  begin
		a[i,j]:=cUnderAttack;    {�������� ��������� ������ ���� �� (x,y) }
		inc(i);
		inc(j);
  end;
	i:=x-1;      {��������� � ������ ������� ������}
	j:=y+1;
	while (i<>0) and (j<>BoardSize+1) do
  begin
		a[i,j]:=cUnderAttack;    {�������� ��������� ������ ����� �� (x,y)}
		dec(i);
		inc(j);
  end;
	i:=x+1;   {��������� � ����� ������ ������ �� (x,y)}
	j:=y-1;
	while (i<>BoardSize+1) and (j<>0) do
  begin
		a[i,j]:=cUnderAttack;    {�������� ��������� ����� ���� �� (x,y)}
		inc(i);
		dec(j);
  end;
	a[x,y]:=cQueen;    {�������� "�����" ������ (x,y)}
end;




procedure TForm1.Button1Click(Sender: TObject);
begin
  timer1.enabled:= not Timer1.Enabled;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  if IterateS then
  begin
    timer1.enabled:=False;
    LogMemo.Lines.Add('EndCycle');
    LogMemo.Lines.Add(Format('%d solutions',[SolutionCounter]));
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  i,j: byte;
begin
  FirstIteration:=True;
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
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  if IterateS then
  begin
    LogMemo.Lines.Add('EndCycle');
    LogMemo.Lines.Add(Format('%d solutions',[SolutionCounter]));
  end;
end;

procedure TForm1.Button3Click(Sender: TObject);
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

function TForm1.IterateS: boolean;
{���������, ����������� ���� ��� ������������� ����������� � ��������.
 � ����� backtracking-pascal, � ����� btr.pas ��������� ���������, �����������
 ������� �������� ���� ���������.

 ���������� True, ���� ���� ��������}
var
	copy: TBoard;
begin
  LogMemo.Lines.Add('<Iteration>');
	if FirstIteration then
	begin
    LogMemo.Lines.Add('It''s a First Iteration');
    CreateQueue(Queue);
    PushQueue(Queue, 1, ClearBoard);
    CurrAction:=GetBoard;
    FirstIteration:=False;
	end;
	
	case CurrAction of
		GetBoard:
			begin
        LogMemo.Lines.Add('Getting board from Stack');
				if Queue=nil then
				begin
          LogMemo.Lines.Add('quiting from cycle');
					result:=True;
					exit;
				end;
				PopQueue(Queue, currQueen, board);
        DrawBoard(board);            //�������������� ������ ������
				currAction:=CheckingIfSolution;
				itr:=1;
			end;
		
		CheckingIfSolution:
			begin
        LogMemo.Lines.Add('checking if new solution');
				if currQueen = BoardSize+1 then	{we have a new solution, lets remind about it}
				begin
					LogMemo.Lines.Add('we fucking have new solution');
          timer1.Enabled:=False; //��������� ������ ��� ���������� �������
          inc(SolutionCounter);
          currAction:=GetBoard;
				end
				else
					currAction:=FindPlaceToNewQueen;
			end;

		FindPlaceToNewQueen:
			begin {what about skiping this part in timer and just show a free place to set?}
        LogMemo.Lines.Add('Finding new place for the '+inttostr(CurrQueen)+'th queen');
				if board[currQueen, itr] = cFree then
				begin
          LogMemo.Lines.Add('Found place. Adding it to the Queue');
					copy:=board;
					SetQueenOnBoard(copy, currQueen, itr);
          //{}DrawBoard(copy);
					PushQueue(Queue, CurrQueen + 1, copy);
				end;
				if itr=BoardSize then
					CurrAction:=GetBoard
				else
					inc(itr);
			end;
	end;

	//write_board;
  //DrawBoard(board);
  LogMemo.Lines.Add('</Iteration>');
  result:=False;
end;

procedure TForm1.FormDestroy(Sender: TObject);
var
  i,j: byte;
begin
  for i:=1 to BoardSize do
    for j:=1 to BoardSize do
      VisualBoard[i,j].Free;
end;

end.
