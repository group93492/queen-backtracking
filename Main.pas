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
    SolutionCounter: integer;             {������� ���������� �������}
    board: TBoard;          {���������� �����, ��� �������� � ������ Stacks}
    Stack: PStack;              {���������� ��������� �� ����. ��� �������� � ������ Stacks}
    CurrQueen: byte;        {������� ������������� �����}
    itr, QueenHereCounter: byte;              {����������-�������� (����� ��� ������ ����� ��������� ������ �����)}
    PrevAbsBoardPos: integer; //������� ����������� ����� �� ���������� ����� (����� ��� ������)
    CurrAction: TQueenAction;   {��������, ����������� � ������ ������}
    FirstIteration: boolean;    {����, ����������� - ����� �� ��������� ����������� �������� - ������ �� ��� �����������}
    StopIfFoundSolution: boolean;
    function ClearBoard: TBoard;      {������� ������� �����}
    procedure SetQueenOnBoard(var a: TBoard; x,y: byte);        {��������� �������� ����� �� ����� � ��������� (x;y) � �������� ������ �����, ����������� �� ������ ����� �����}
    procedure DrawBoard(board: TBoard);                         {������� ��������� ����� � Grid}
    function IterateS: boolean;                                 {���������� ���� �������� ���������}
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
//������������ ���������� ����. �����-��������.
//�� ��� �������� :3
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
      case board[j,i] of    {����� ���� ������� board[i,j] - �� ��������� ����� ����� ������������� �� ��������}
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
    LogMemo.Lines.Add('���� ��������.');
    LogMemo.Lines.Add(Format('������� %d �������(�)',[SolutionCounter]));
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
    LogMemo.Lines.Add('���� ��������.');
    LogMemo.Lines.Add(Format('������� %d �������(�)',[SolutionCounter]));
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
  LogMemo.Lines.Add('���� ��������.');
  LogMemo.Lines.Add(Format('������� %d �������(�)',[SolutionCounter]));
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
{���������, ����������� ���� ��� ������������� ����������� �� ������.
 � ����� backtracking-pascal, � ����� btr.pas ��������� ���������, �����������
 ������� �������� ���� ���������.

 ���������� True, ���� ���� ��������}
const
  chars= 'ABCDEFGHIJ';
var
	copy: TBoard;
begin
  LogMemo.Lines.Add('<������ ��������.>');
	if FirstIteration then
	begin
    LogMemo.Lines.Add ('��� ������ ��������.');
    LogMemo.Lines.Add('��������� � ���� ������ �����������');
    CreateStack (Stack);
    PrevAbsBoardPos:= 1;
    PushStack (Stack, 1, ClearBoard, PrevAbsBoardPos);
    CurrAction:= GetBoard;
    FirstIteration:= False;
    QueenHereCounter:= 0; //���������� ����� �����, ������� ����� ��������� �� ������� ������
    DrawUnit (1, 1, PrevAbsBoardPos, 1);
	end;

	case CurrAction of
		GetBoard:
			begin
        LogMemo.Lines.Add('�������� ������� ����������� �� �����.');
				if Stack = nil then
				begin
          LogMemo.Lines.Add('���� ����, ���� �����������.');
					result:=True;
					exit;
				end;
				PopStack (Stack, currQueen, board, PrevAbsBoardPos);
        DrawBoard(board);            //�������������� ������ ������
				CurrAction:= CheckingIfSolution;
				itr:= BoardSize;
			end;

		CheckingIfSolution:
			begin
        LogMemo.Lines.Add ('���������, �������� �� ������� ����������� ������� ��������.');
				if CurrQueen = BoardSize + 1 then	{we got a new solution, lets remind about it}
				begin
					LogMemo.Lines.Add ('�������� ��������, � ��� ���� �������.');
          WriteSolutionIntoList (board);
          MarkGoodThread (CurrQueen - 1, PrevAbsBoardPos);
          if StopIfFoundSolution then
            StopTimer; //��������� ������ ��� ���������� �������
          Inc (SolutionCounter);
          CurrAction:= GetBoard;
				end
				else
        begin
					CurrAction:= FindPlaceToNewQueen;
          LogMemo.Lines.Add (Format('������� ������� ��� ����� ����� %d.',[CurrQueen]));
        end;
			end;

		FindPlaceToNewQueen:
			begin {what about skiping this part in timer and just show a free place to set?}
        //LogMemo.Lines.Add (Format('������� ������� ��� ����� ����� %d.',[CurrQueen]));
				if board[currQueen, itr] = cFree then
				begin
          LogMemo.Lines.Add (Format('����� ����� ��������� �� ������� %s%d.',[chars[itr],BoardSize - currQueen + 1]));
          LogMemo.Lines.Add('��������� ��� � ����������� � ��������� ����������� � ����.');
					copy:= board;
					SetQueenOnBoard (copy, currQueen, itr);
          //{}DrawBoard(copy);
          Inc (QueenHereCounter);
					PushStack (Stack, CurrQueen + 1, copy, CurrAbsBoardPos (CurrQueen, QueenHereCounter, PrevAbsBoardPos));

          DrawUnit (CurrQueen, QueenHereCounter, PrevAbsBoardPos, itr);
				end
        else
          LogMemo.Lines.Add (Format('������ ������� ����� �� ������� %s%d.',[chars[itr],BoardSize - currQueen + 1]));
				if itr = 1 then
        begin
          LogMemo.Lines.Add('����� ������� ��� ������ ����� ��������.');
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
  LogMemo.Lines.Add ('<����� ��������.>');
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
  button1.Caption:='���������� �������������� ����������';
  Timer1.enabled:= True;
end;

procedure TQueenForm.StopTimer;
begin
  button1.Caption:='��������� �������������� ����������';
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
