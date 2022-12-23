program PListaDuplamenteEncadeadas;

uses
  Vcl.Forms,
  EstruturaListaLinearDinamica in 'EstruturaListaLinearDinamica.pas',
  unit_CadastroAlunos in 'unit_CadastroAlunos.pas' {frm_CadastroAlunos};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(Tfrm_CadastroAlunos, frm_CadastroAlunos);
  Application.Run;
end.
