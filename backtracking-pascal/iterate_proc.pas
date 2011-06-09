program iterate_proc;
{никоим образом не программа, просто набросок(полупсевдокод, лол) процедуры, выполняющей шаг расстановки ферзей
* бэктрекингом}

uses crt;

type
	TQueenAction = (GetBoard, CheckingIfSolution, FindPlaceToNewQueen);

var
	currQueen, itr : byte;
	Q: pQueue;
	FirstIteration: boolean;
	CurrAction: TQueenAction;
	board: TBoard;

function Iterate: boolean;
var
	copy: TBoard;
begin
	if FirstIteration then
	begin
{}		itr:=1;
{}		CurrQueen:=1;
		CreateQueue(Q);
		PushQueue(Q, 1, GetFreeBoard());
		FirstIteration:=False;
	end;
	
	case CurrAction of
		GetBoard:
			begin
				if Q=nil then
				begin
					Iterate:=True;
					exit;
				end;
				PopQueue(Q, currQueen, board);
				currAction:=CheckingIfSolution;
				itr:=1;
			end;
		
		CheckingIfSolution:
			begin
				if currQueen = N+1 then	{we have a new solution, lets remind about it}
				begin
					writeln('new solution');
					//blah-blah
				end
				else
					currAction:=FindPlaceToNewQueen;			
			end;
		
		FindPlaceToNewQueen:
			begin
				if board[currQueen, itr] = cFree then
				begin
					copy:=board;
					SetQueenOnBoard(copy, currQueen, itr);
					PushQueue(Q, CurrQueen + 1, copy);
				end;
				if itr=N then
					CurrAction:=GetBoard
				else
					inc(itr);
			end;
	end;
			
	{отрисовка текущего положения дел}
	//write_board;
	Iterate:=False;
end;
	

BEGIN
	FirstIteration:=True;
	
	
	
	
END.

