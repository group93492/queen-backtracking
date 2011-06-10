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
	{создание пустого стека}
	begin
		top:=nil;
	end;
	
	procedure PushStack(var top: pStack; x: byte; board: TBoard);
	{добавление элемента в верх стека}
	var
		temp: pStack;
	begin
		new(temp);				{выдел€ем пам€ть дл€ нового элемента}
		temp^.x:=x;		{присваиваем элементу информацию}
		temp^.board:=board;
		temp^.next:=top;		{"ставим" новый элемент в верх стека}
		top:=temp;					{сохран€ем стек с новым элементом}
	end;
		
	procedure PopStack(var top: pStack; var x: byte; var board: TBoard);
	{изъ€тие элемента из вершины стека}
	var
		temp: pStack;
	begin
		if top<>nil then			{если стек не пуст, то}
		begin
			temp:=top^.next;	{сохран€ем стек, начина€ со второго элемента}
			x:=top^.x;				{считываем информацию}
			board:=top^.board;
			dispose(top);			{очищаем пам€ть от первого элемента}
			top:=temp;				{записываем новый стек в top}
		end;
	end;

	
end.
