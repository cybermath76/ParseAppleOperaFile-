program AppOperaParser;

uses
  Forms,
  mainUnit in 'mainUnit.pas' {Form1},
  typeDefBase in 'typeDefBase.pas',
  typeDefSucc in 'typeDefSucc.pas',
  operations in 'operations.pas',
  header in 'header.pas',
  typeDefGen in 'typeDefGen.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
