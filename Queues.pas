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
	{создание пустой очереди}
	begin
		tail:=nil;
	end;
	
	procedure PushQueue(var tail: pQueue;  x: byte; board: TBoard);
	{добавление элемента в конец очереди}
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
	{удаление элемента из начала очереди}
	{ололо работает? не}
	var
		temp: pQueue;
	begin
		if tail<>nil then
		begin
			{temp:=tail;
			while tail^.next<>nil do
				tail:=tail^.next;
			data:=tail^.data;
			writeln('popping - ',data);
			dispose(tail);
			tail:=temp;		}
			if tail^.next=nil then
			begin
				x:=tail^.x;
				board:=tail^.board;
				dispose(tail);
				tail:=nil;
			end
			else
			begin
				temp:=tail;
				while tail^.next^.next<>nil do
					tail:=tail^.next;
				x:=tail^.next^.x;
				board:=tail^.next^.board;
				tail^.next:=nil;
				tail:=temp;
			end;				
		end;
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
