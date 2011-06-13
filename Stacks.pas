unit stacks;

interface
 
 const
	BoardSize = 5;

 type
	TCell = (cQueen, cUnderAttack, cFree);
	TBoard = array[1..BoardSize,1..BoardSize] of TCell;
	pStack=^TStack;	
	TStack = record
       x: byte;
       CurrAbsBoardPos: integer; //������� ��������� ����� � ������ ������������� � ���������
       board: TBoard;
       next:pStack;
	end;
	
	procedure CreateStack (var top:pStack);
  procedure ClearStack (var top: PStack);
	procedure PushStack (var top: pStack; x: byte; board: TBoard; CurrAbsBoardPos: integer);
  procedure PopStack (var top: pStack; var x: byte; var board: TBoard; var CurrAbsBoardPos: integer);
	//function StackElements (var top: pStack): integer;

implementation
	
	procedure CreateStack(var top: pStack);
	{�������� ������� �����}
	begin
    if top <> nil then
      ClearStack (top)
    else
  		top:= nil;
	end;
	
	procedure PushStack(var top: pStack; x: byte; board: TBoard; CurrAbsBoardPos: integer);
	{���������� �������� � ���� �����}
	var
		temp: pStack;
	begin
		new (temp);				{�������� ������ ��� ������ ��������}
		temp^.x:= x;		{����������� �������� ����������}
		temp^.board:= board;
    temp^.CurrAbsBoardPos:= CurrAbsBoardPos;
		temp^.next:= top;		{"������" ����� ������� � ���� �����}
		top:= temp;					{��������� ���� � ����� ���������}
	end;
		
	procedure PopStack(var top: pStack; var x: byte; var board: TBoard; var CurrAbsBoardPos: integer);
	{������� �������� �� ������� �����}
	var
		temp: pStack;
	begin
		if top <> nil then			{���� ���� �� ����, ��}
		begin
			temp:= top^.next;	{��������� ����, ������� �� ������� �������� �� �������}
			x:= top^.x;				{��������� ����������}
      CurrAbsBoardPos:= top^.CurrAbsBoardPos;
			board:= top^.board;
			dispose (top);			{������� ������ �� ������� ��������}
			top:= temp;				{���������� ����� ���� � top}
		end;
	end;

  procedure ClearStack (var top: PStack);
  var
    temp: PStack;
  begin
    while top <> nil do
    begin
      temp:= top;
      top:= top^.next;
      dispose (temp);
    end;
  end;

	
end.
