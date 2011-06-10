unit stacks;

interface
 
 const
	BoardSize = 8;

 type
	TCell = (cQueen, cUnderAttack, cFree);
	TBoard = array[1..BoardSize,1..BoardSize] of TCell;
	pStack=^TStack;	
	TStack = record
       x: byte;
       board: TBoard;
       next:pStack;
	end;
	
	procedure CreateStack(var top:pStack);
	procedure PushStack(var top: pStack; x: byte; board: TBoard);
	procedure PopStack(var top: pStack; var x: byte; var board: TBoard);
	//function StackElements(var top: pStack): integer;

implementation
	
	procedure CreateStack(var top: pStack);
	{�������� ������� �����}
	begin
		top:=nil;
	end;
	
	procedure PushStack(var top: pStack; x: byte; board: TBoard);
	{���������� �������� � ���� �����}
	var
		temp: pStack;
	begin
		new(temp);				{�������� ������ ��� ������ ��������}
		temp^.x:=x;		{����������� �������� ����������}
		temp^.board:=board;
		temp^.next:=top;		{"������" ����� ������� � ���� �����}
		top:=temp;					{��������� ���� � ����� ���������}
	end;
		
	procedure PopStack(var top: pStack; var x: byte; var board: TBoard);
	{������� �������� �� ������� �����}
	var
		temp: pStack;
	begin
		if top<>nil then			{���� ���� �� ����, ��}
		begin
			temp:=top^.next;	{��������� ����, ������� �� ������� ��������}
			x:=top^.x;				{��������� ����������}
			board:=top^.board;
			dispose(top);			{������� ������ �� ������� ��������}
			top:=temp;				{���������� ����� ���� � top}
		end;
	end;

	
end.
