program btr;
{программа содержит процедуры  расстановки ферзей бектрекингом
* рекурсивную(Set_F)
* итерационную(со стеком) Set_F_iter_stack
* итерационную(с очередью) Set_F_iter_queue
* 
}
 
uses
	Crt, Queues{, Stacks};
	  
VAR
	board: TBoard;   	
	{матрица, описывающая положение шахматной доски}
	i,j:integer;
	k:longint;
  
PROCEDURE Fill_F(x,y:integer; var a: TBoard);   
 {x, y*— координаты вставки ферзя}
var
	i, j:integer;
begin
	for i:= 1 to BoardSize do
    begin
		a[x,i]:=cUnderAttack; {строка, где будет стоять ферзь*—«под боем»}
		a[i,y]:=cUnderAttack;     {столбец, где будет стоять ферзь*—«под боем»}
	end;
	i:=x-1;     {переходим в левую верхнюю клетку по диагонали} j:=y-1;     {от (x,y)}
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
		a[i,j]:=cUnderAttack;    {помечаем диагональ справа и вниз от (x,y) }
		inc(i);
		inc(j);
    end;
	i:=x-1;      {переходим в правую верхнюю клетку}
	j:=y+1;
	while (i<>0) and (j<>BoardSize+1) do
    begin
		a[i,j]:=cUnderAttack;    {помечаем диагональ справа и вверх от (x,y)}
		dec(i);
		inc(j);
    end;
	i:=x+1;   {переходим в левую нижнюю клетку от (x,y)}
	j:=y-1;
	while (i<>BoardSize+1) and (j<>0) do
    begin
		a[i,j]:=cUnderAttack;    {помечаем диагональ слева и вниз от (x,y)}
		inc(i);
		dec(j);
    end;
	a[x,y]:=cQueen;    {ставим ферзя на место (x,y)}
end;

procedure write_board(board: TBoard);
var
	i,j: byte;
begin
	for i:=1 to BoardSize do       {выводим матрицу расстановки}
		begin
			for j:=1 to BoardSize do
				case board[i,j] of
					cFree: write(' ');
					cUnderAttack: write('*');
					cQueen: write('Q');
				end;
			writeln;
		end;	
	writeln;
end;

PROCEDURE Set_F(x:integer; a:TBoard); 
{рекурсивный бектрекинг}
{x*— строка, куда добавляем ферзя}
var
	i:integer;
	b:TBoard;
begin
	write_board(a);
	if x=BoardSize+1 then     {если все ферзи расставлены}
    begin
		//writeln(k+1,').');
		//write_board(a);
		//readln;
		writeln('it was a solution');
		readln;
		inc(k)      {наращиваем счетчик вариантов расстановки}
	end
	else        {в противном случае}
		for i:= 1 to BoardSize do       {ищем в строке}
			if a[x,i]=cFree then      {первую свободную и не подударную клетку}
			begin
				b:=a;        {копируем матрицу a в матрицу b}
				Fill_F(x,i,b);  {устанавливаем ферзя в i-й столбец строки x}
				Set_F(x+1,b);      {вызываем процедуру вставки ферзя в следующую x+1-ю строку измененной матрицы b}
			end;
end;


{procedure SET_F_iter_stack(startBoard:TBoard);
var
	Stack: pStack;
	x: byte;			
	i: byte;
	b,copy: TBoard;
begin
	CreateStack(Stack);
	PushStack(Stack, 1,startBoard);
	while Stack<>nil do
	begin
		//writeln('stackiteration');
		PopStack(Stack, x, b);
	//	write_board(b);
		if x=N+1 then     
		begin
			writeln(k+1,'.');
			write_board(b);
			readln;
			inc(k)      
		end
		else       
			for i:=1 to N do       
				if b[x,i]=cFree then     
				begin
					copy:=b;
					Fill_F(x,i,copy);  
					PushStack(Stack, x+1, copy);
				end;	
	end;
end;}

procedure SET_F_iter_queue(startBoard:TBoard);
var
	Queue: pQueue;	
	x: byte;			{x*— строка, куда добавляем ферзя}
	i: byte;
	b,c: TBoard;
begin
	CreateQueue(Queue);
	PushQueue(Queue, 1,startBoard);
	while Queue<>nil do
	begin
		PopQueue(Queue, x, b);
		if x=BoardSize+1 then     {если все ферзи расставлены}
		begin
			writeln(k+1,'.');
			write_board(b);
			readln;
			inc(k)      {наращиваем счетчик вариантов расстановки}
		end
		else        {в противном случае}
			for i:=1 to BoardSize do       {ищем в строке}
				if b[x,i]=cFree then      {первую свободную клетку}
				begin
					c:=b;
					Fill_F(x,i,c);  {устанавливаем ферзя в i-й столбец строки x}
					PushQueue(Queue, x+1, c);
				end;	
	end;
end;



BEGIN
	writeln('N=',BoardSize);
	k:=0;      {количество вариантов расстановок равно 0}
	for i:= 1 to BoardSize do
		for J:= 1 to BoardSize do
			board[i,j]:=cFree;       {все клетки матрицы свободны}
	//Set_F(1,board);        {вызываем рекурсивную процедуру установки ферзя (сначала устанавливаем первого ферзя на свободную доску)}
	//Set_F_iter_stack(board);		{итерационный бектрекинг(со стеком)}
	Set_F_iter_queue(board);		{итерационный бектрекинг, но с очередью}
	writeln(k);    {выводим ответ*— число вариантов расстановки}
	readln;
END.
