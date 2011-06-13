program Project1;

uses
  Forms,
  Main in 'Main.pas' {QueenForm},
  Tree in 'Tree.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TQueenForm, QueenForm);
  Application.Run;
end.
