unit queues;

interface

const
  BoardSize = 8;

 type
	TCell = (cQueen, cUnderAttack, cFree);
	TBoard = array[1..BoardSize,1..BoardSize] of TCell;
	pQueue = ^Queue;
	Queue = record
		x: byte;
       board: TBoard;
       next:pQueue;
	end;
	
	procedure CreateQueue(var tail: pQueue);
	procedure PushQueue(var tail: pQueue;  x: byte; board: TBoard);
	procedure PopQueue(var tail: pQueue; var  x: byte; var board: TBoard);
	//procedure WriteQueue(tail: pQueue);
	
implementation

	procedure CreateQueue(var tail: pQueue);
	{�������� ������ �������}
	begin
    tail:= nil;
	end;
	
	procedure PushQueue(var tail: pQueue;  x: byte; board: TBoard);
	{���������� �������� � ����� �������}
	var
		temp: pQueue;
	begin
		new(temp);
		temp^.x:=x;
		temp^.board:=board;
		temp^.next:=tail;
		tail:=temp;
	end;
	
	procedure PopQueue(var tail: pQueue; var  x: byte; var board: TBoard);
	{�������� �������� �� ������ �������}
	//����� ��������? �� upd: frmn ��������, ��������
	var
    head: pQueue;
	begin
		if tail = nil then
		  Exit;
    if tail^.next=nil then
    begin
      x:=tail^.x;
      board:=tail^.board;
      dispose(tail);
      tail:=nil;
      Exit;
    end;
    head:= tail;
    while head^.next^.next <> nil do
      head:= head^.next;  
    x:= head^.next^.x;
    board:= head^.next^.board;
    dispose (head^.next);
    head^.next:= nil;			
	end;
		
	{procedure WriteQueue(tail: pQueue);
	var
		temp: pQueue;
	begin
		temp:=tail;
		while temp<>nil do
		begin
			write(temp^.data,'->');
			temp:=temp^.next;
		end;
		writeln;
	end;}


end.
