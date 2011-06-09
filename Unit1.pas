unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, ExtCtrls, Stacks;

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
    procedure Button1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    k: integer;             {������� ���������� �������}
    board: TBoard;          {���������� �����, ��� �������� � ������ Stacks}
    S: pStack;              {���������� ��������� �� ����. ��� �������� � ������ Stacks}
    CurrQueen: byte;        {������� ������������� �����}
    itr: byte;              {����������-�������� (����� ��� ������ ����� ��������� ������ �����)}
    CurrAction: TQueenAction;   {��������, ����������� � ������ ������}
    FirstIteration: boolean;    {����, ����������� - ����� �� ��������� ����������� �������� - ������ �� ��� �����������}
    function GetFreeBoard: TBoard;      {������� ���������� ��������� ������ �����}
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
var
  i,j: byte;
  c: char;
begin
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
end;

function TForm1.GetFreeBoard: TBoard;
var
  i,j: byte;
  b: TBoard;
begin
  for i:= 1 to BoardSize do
    for J:= 1 to BoardSize do
      b[i,j]:=cFree;
  result:=b;
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
    LogMemo.Lines.Add(Format('%d solutions',[k]));
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  FirstIteration:=True;
  k:=0;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  if IterateS then
  begin
    LogMemo.Lines.Add('EndCycle');
    LogMemo.Lines.Add(Format('%d solutions',[k]));
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
{���������, ����������� ���� ��� ������������� ����������� �� ������
 � ����� backtracking-pascal, � ����� btr.pas ��������� ���������, �����������
 ������� �������� ���� ���������.

 ���������� True, ���� ���� ��������}
//����������� ��������� � �������������� ������� ����� ����� ����������
var
	copy: TBoard;
begin
  LogMemo.Lines.Add('<Iteration>');
	if FirstIteration then
	begin
    LogMemo.Lines.Add('It''s a First Iteration');
    CreateStack(S);
    PushStack(S, 1, GetFreeBoard);
    CurrAction:=GetBoard;
    FirstIteration:=False;
	end;
	
	case CurrAction of
		GetBoard:
			begin
        LogMemo.Lines.Add('Getting board from Stack');
				if S=nil then
				begin
          LogMemo.Lines.Add('quiting from cycle');
					result:=True;
					exit;
				end;
				PopStack(S, currQueen, board);
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
          inc(k);
          currAction:=GetBoard;
				end
				else
					currAction:=FindPlaceToNewQueen;
			end;

		FindPlaceToNewQueen:
			begin
        LogMemo.Lines.Add('Finding new place for the '+inttostr(CurrQueen)+'th queen');
				if board[currQueen, itr] = cFree then
				begin
          LogMemo.Lines.Add('Found place. Adding it to the Queue');
					copy:=board;
					SetQueenOnBoard(copy, currQueen, itr);
          //{}DrawBoard(copy);
					PushStack(S, CurrQueen + 1, copy);
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

end.