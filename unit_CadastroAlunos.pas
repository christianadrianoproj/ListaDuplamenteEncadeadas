unit unit_CadastroAlunos;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, Spin, Vcl.Mask, EstruturaListaLinearDinamica;

type
  Tfrm_CadastroAlunos = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    btAdd: TBitBtn;
    btRetirarPrimeiro: TBitBtn;
    btResultado: TBitBtn;
    btSair: TBitBtn;
    Label1: TLabel;
    edMatricola: TEdit;
    Label2: TLabel;
    edAluno: TEdit;
    Label3: TLabel;
    edCurso: TEdit;
    Label4: TLabel;
    spSemestre: TSpinEdit;
    Label5: TLabel;
    mmValor: TMemo;
    mmFila: TMemo;
    Label6: TLabel;
    rgResultados: TRadioGroup;
    btRetiraUltimo: TBitBtn;
    btRetiraSel: TBitBtn;
    btLimpaLista: TBitBtn;
    procedure btSairClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btAddClick(Sender: TObject);
    procedure btRetirarPrimeiroClick(Sender: TObject);
    procedure btResultadoClick(Sender: TObject);
    procedure rgResultadosClick(Sender: TObject);
    procedure btRetiraUltimoClick(Sender: TObject);
    procedure btRetiraSelClick(Sender: TObject);
    procedure btLimpaListaClick(Sender: TObject);
  private
    Controle: TEstruturaAlunos;

    procedure limparTela;
    function ValidarDados:Boolean;
    procedure inserir();
    procedure retirar(Pimerio,Ultimo,Selecionado: Boolean);
    procedure carregarLista(mostrarPeloUltimoNo: Boolean = False);
    procedure liberarLista;

    procedure buscarNome(sNome:String);
    procedure buscarCurso(sCurso: String);
    procedure buscarCursoSemestre(sCurso: String; iSemestre:Integer);
    procedure buscarValorCurso(sCurso: String);
    procedure buscarMaiorMensalidade;
  public
  end;

var
  frm_CadastroAlunos: Tfrm_CadastroAlunos;

implementation

{$R *.dfm}

procedure Tfrm_CadastroAlunos.btRetiraUltimoClick(Sender: TObject);
begin
  retirar(false, True, false);
  carregarLista;
end;

procedure Tfrm_CadastroAlunos.btRetiraSelClick(Sender: TObject);
begin
  retirar(false, false, true);
  carregarLista;
end;

procedure Tfrm_CadastroAlunos.btAddClick(Sender: TObject);
begin
  inserir;
end;

procedure Tfrm_CadastroAlunos.btLimpaListaClick(Sender: TObject);
begin
  Controle.RemoveTodosAlunos;
  carregarLista;
end;

procedure Tfrm_CadastroAlunos.btResultadoClick(Sender: TObject);
begin
    case (rgResultados.ItemIndex) of
       0: buscarNome(edAluno.Text);
       1: buscarCurso(edCurso.Text);
       2: buscarCursoSemestre(edCurso.Text, StrToInt(spSemestre.Text));
       3: buscarValorCurso(edCurso.Text);
       4: buscarMaiorMensalidade;
       5: carregarLista;
       6: carregarLista(true);
    end;
end;

procedure Tfrm_CadastroAlunos.rgResultadosClick(Sender: TObject);
begin
     if (rgResultados.ItemIndex = 4) then
       buscarMaiorMensalidade
     else
     if (rgResultados.ItemIndex = 5) then
       carregarLista
      else
     if (rgResultados.ItemIndex = 6) then
       carregarLista(true);
end;

procedure Tfrm_CadastroAlunos.btRetirarPrimeiroClick(Sender: TObject);
begin
  retirar(true, false, false);
  carregarLista;
end;

procedure Tfrm_CadastroAlunos.btSairClick(Sender: TObject);
begin
     Application.Terminate;
end;

procedure Tfrm_CadastroAlunos.buscarCurso(sCurso: String);
Begin
  mmFila.Clear;
  mmFila.Lines.AddStrings(Controle.pesquisaCurso(sCurso));
  if mmFila.Lines.Count < 1 then
    Application.MessageBox('Elemento n�o foi encontrado', 'Erro', mb_ok + MB_ICONERROR);
end;

procedure Tfrm_CadastroAlunos.buscarMaiorMensalidade;
begin
  mmFila.Clear;
  mmFila.Lines.AddStrings(Controle.getAlunoComMaiorMensalidade());
end;

procedure Tfrm_CadastroAlunos.buscarValorCurso(sCurso: String);
var
  valor: Real;
begin
  mmFila.Clear;
  valor := Controle.getTotalMensalidadePorCurso(sCurso);
  if (valor = 0) then
    Application.MessageBox('Elemento n�o foi encontrado', 'Erro', mb_ok + MB_ICONERROR)
  else
    mmFila.Text := 'Valor de Mensalidades do curso ' + sCurso + ': ' + FormatFloat('###,##0.00', valor);
end;

procedure Tfrm_CadastroAlunos.buscarCursoSemestre(sCurso: String;  iSemestre: Integer);
begin
  mmFila.Clear;
  mmFila.Lines.AddStrings(Controle.pesquisaCursoSemestre(sCurso, iSemestre));
  if mmFila.Lines.Count < 1 then
     Application.MessageBox('Elemento n�o foi encontrado', 'Erro', mb_ok + MB_ICONERROR);
end;

procedure Tfrm_CadastroAlunos.buscarNome(sNome: String);
begin
  mmFila.Clear;
  mmFila.Lines.AddStrings(Controle.pesquisaNome(sNome));
  if mmFila.Lines.Count < 1 then
     Application.MessageBox('Elemento n�o foi encontrado', 'Erro', mb_ok + MB_ICONERROR);
end;

procedure Tfrm_CadastroAlunos.FormActivate(Sender: TObject);
begin
  limparTela;
  mmFila.Clear;
  edMatricola.SetFocus;
end;

procedure Tfrm_CadastroAlunos.FormCreate(Sender: TObject);
begin
  Controle := TEstruturaAlunos.Create();
end;

procedure Tfrm_CadastroAlunos.FormDestroy(Sender: TObject);
begin
  liberarLista;
end;

procedure Tfrm_CadastroAlunos.inserir();
begin
  if (not ValidarDados) then
    exit;

  Controle.IncluiAluno(edAluno.Text, StrToIntDef(edMatricola.Text,0), edCurso.Text, spSemestre.Value, StrToFloatDef(mmValor.Lines.Text,0));

  mmFila.Clear;
  mmFila.Lines.AddStrings(Controle.carregarAlunos);
  limparTela;
  edMatricola.SetFocus;
end;

procedure Tfrm_CadastroAlunos.carregarLista(mostrarPeloUltimoNo: Boolean = False);
begin
  mmFila.Clear;
  if not mostrarPeloUltimoNo then
    mmFila.Lines.AddStrings(Controle.carregarAlunos)
  else
    mmFila.Lines.AddStrings(Controle.carregarAlunoPeloUltimoNo);
end;

procedure Tfrm_CadastroAlunos.retirar(Pimerio,Ultimo,Selecionado: Boolean);
begin
  if Pimerio then
    Controle.RemoveAlunoPrimeiro();
  if Ultimo then
    Controle.RemoveAlunoUltimo();
  if Selecionado then
    if not Controle.RemoveAluno(Controle.getNoByMatriculaAluno(StrToIntDef(edMatricola.Text,0))) then
      Application.MessageBox(PChar('N�o foi localizado nenhum elemento com a Matricula "'+edMatricola.Text+'".'), 'Erro', mb_ok + MB_ICONERROR);
end;

procedure Tfrm_CadastroAlunos.liberarLista;
begin
  Controle.RemoveTodosAlunos();
end;

procedure Tfrm_CadastroAlunos.limparTela;
begin
  edMatricola.Clear;
  edAluno.Clear;
  edCurso.Clear;
  spSemestre.Text := '1';
  mmValor.Clear;
end;

function Tfrm_CadastroAlunos.ValidarDados: Boolean;
begin
  result := true;

  if (edMatricola.Text = '') then
   begin
        Application.MessageBox('Informe a matr�cula!', 'Erro', mb_ok + MB_ICONERROR);
        edMatricola.SetFocus;
        result := false;
        exit;
   end;

  if (edAluno.Text = '') then
   begin
        Application.MessageBox('Informe o aluno!', 'Erro', mb_ok + MB_ICONERROR);
        edAluno.SetFocus;
        result := false;
        exit;
   end;

  if (edCurso.Text = '') then
   begin
        Application.MessageBox('Informe o curso!', 'Erro', mb_ok + MB_ICONERROR);
        edCurso.SetFocus;
        result := false;
        exit;
   end;

  if (spSemestre.Text = '') then
   begin
        Application.MessageBox('Informe o semestre!', 'Erro', mb_ok + MB_ICONERROR);
        spSemestre.SetFocus;
        result := false;
        exit;
   end;

  if (mmValor.Text = '') then
   begin
        Application.MessageBox('Informe o valor!', 'Erro', mb_ok + MB_ICONERROR);
        mmValor.SetFocus;
        result := false;
        exit;
   end;

  try
    StrToFloat(mmValor.Text);
  except
       on e:Exception do
         begin
              Application.MessageBox('Informe um valor correto!', 'Erro', mb_ok + MB_ICONERROR);
              mmValor.SetFocus;
              result := false;
              exit;
         end;
  end;
end;

end.
