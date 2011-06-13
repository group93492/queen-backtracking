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
       CurrAbsBoardPos: integer; //текущее положение ферз€ в строке применительно к отрисовке
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
	{создание пустого стека}
	begin
    if top <> nil then
      ClearStack (top)
    else
  		top:= nil;
	end;
	
	procedure PushStack(var top: pStack; x: byte; board: TBoard; CurrAbsBoardPos: integer);
	{добавление элемента в верх стека}
	var
		temp: pStack;
	begin
		new (temp);				{выдел€ем пам€ть дл€ нового элемента}
		temp^.x:= x;		{присваиваем элементу информацию}
		temp^.board:= board;
    temp^.CurrAbsBoardPos:= CurrAbsBoardPos;
		temp^.next:= top;		{"ставим" новый элемент в верх стека}
		top:= temp;					{сохран€ем стек с новым элементом}
	end;
		
	procedure PopStack(var top: pStack; var x: byte; var board: TBoard; var CurrAbsBoardPos: integer);
	{изъ€тие элемента из вершины стека}
	var
		temp: pStack;
	begin
		if top <> nil then			{если стек не пуст, то}
		begin
			temp:= top^.next;	{сохран€ем стек, начина€ со второго элемента от вершины}
			x:= top^.x;				{считываем информацию}
      CurrAbsBoardPos:= top^.CurrAbsBoardPos;
			board:= top^.board;
			dispose (top);			{очищаем пам€ть от первого элемента}
			top:= temp;				{записываем новый стек в top}
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
