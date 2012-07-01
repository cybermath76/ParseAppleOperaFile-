{
  ���������� - ������ KR v1.03.
  ���� ���������� ����� - ����������� ����� �������� � ����� ���
  �������.
}

unit mainUnit;

interface

uses
  Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, StdCtrls, typeDefBase, typeDefSucc, ComCtrls, operations,
  TypInfo, typeDefGen;

type
  TForm1 = class(TForm)
    mm1: TMainMenu;
    File1: TMenuItem;
    Operations1: TMenuItem;
    About1: TMenuItem;
    Open1: TMenuItem;
    Save1: TMenuItem;
    N1: TMenuItem;
    Exit1: TMenuItem;
    dlgOpen1: TOpenDialog;
    btn1: TButton;
    tv1: TTreeView;
    mmo1: TMemo;
    edt1: TEdit;
    grp1: TGroupBox;
    lbl1: TLabel;
    lbl2: TLabel;
    edt2: TEdit;
    grp2: TGroupBox;
    Multiload1: TMenuItem;
    Multisave1: TMenuItem;
    procedure Open1Click(Sender: TObject);
    procedure btn1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure tv1Changing(Sender: TObject; Node: TTreeNode;
      var AllowChange: Boolean);
    procedure FormDestroy(Sender: TObject);
    procedure Multiload1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  fileName: string; // ��� ��������� �����
  fobjBM: TAppFileArrayBM;
  fobjJrnl: TAppFileArrayJrnl;
  fns: TStringList; // ������ ������. (��� ������������� ��������� ������)
  MultiFileArr: TArrAppBaseFile;

implementation

uses header;

{$R *.dfm}

procedure TForm1.btn1Click(Sender: TObject);
begin
  if fileName = '' then
  begin
    ShowMessage('���� �� ������.'); // file1032258    file516462
    Exit;
  end;


  if tv1.Items.Count <> 0 then
    FreeAndNil(fobjBM);

  if mmo1.Lines.Count <> 0 then
    FreeAndNil(fobjJrnl);

  // ������� ������ ������ ���� ���������� �����.
  // ����, ������������ � ���� - ���� ��������. �� ��������� - ������.
  if CheckFileType(fileName) = 48 then
  begin
    tv1.Items.Clear;
    TItemOperation.CreateObject<TAppFileArrayBM>(fobjBM);
    try
      CreateTreeView(fobjBM, fobjBM.fileStrList, 0);
    finally
      // FreeAndNil(fobjBM);
    end;
  end
  else
  begin
    TItemOperation.CreateObject<TAppFileArrayJrnl>(fobjJrnl);
    try
      // ������� ��������� �������. ��������!!!
      mmo1.Text := '';
      mmo1.Text := fobjJrnl.fileStrList.Text;
    finally
      // FreeAndNil(fobjJrnl);
    end;
  end;
  fileName := '';
end;

procedure TForm1.Exit1Click(Sender: TObject);
begin
  Form1.Close;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  // ������� �� �����.
  TErase.Erase<TAppFileArrayBM>(fobjBM);
  TErase.Erase<TAppFileArrayJrnl>(fobjJrnl);
  TErase.Erase<TArrAppBaseFile>(MultiFileArr);
end;

procedure TForm1.Multiload1Click(Sender: TObject);
var
  i: Integer;
  fobjBMt: TAppFileArrayBM;
  fobjJrnlt: TAppFileArrayJrnl;
begin
  // �������� ������ ������ ��� �������� ������� ������.
  fns := TStringList.Create;
  if dlgOpen1.Execute then
    fns.Text := dlgOpen1.Files.Text;

  // ���� ������ ������� �� ����� ���� ��� ������, ��� �� ���
  // �������� ��� ���������, � ������ ����� �������� ������, ����
  // �������� ������.

//  if Length(MultiFileArr) <> 0 then
    TErase.Erase<TArrAppBaseFile>(MultiFileArr);
//  else
    SetLength(MultiFileArr, fns.Count);

  for i := 0 to High(MultiFileArr) do
  begin
    if CheckFileType(fns.Strings[i]) = 48 then
    begin
      TItemOperation.CreateArrayOfBaseClass<TArrAppBaseFile, TAppFileArrayBM>
        (MultiFileArr, fobjBMt, i, fns.Strings[i]);
      try
        CreateTreeView(fobjBMt, MultiFileArr[i].fileStrList, 0);
      finally
        // FreeAndNil(fobjBM);
      end;
    end
    else
    begin
      TItemOperation.CreateArrayOfBaseClass<TArrAppBaseFile, TAppFileArrayJrnl>
        (MultiFileArr, fobjJrnlt, i, fns.Strings[i]);
      try
        mmo1.Text := '';
        mmo1.Text := fobjJrnlt.fileStrList.Text;
      finally
        // FreeAndNil(fobjBM);
      end;
    end;

  end;
  FreeAndNil(fns);
end;

procedure TForm1.Open1Click(Sender: TObject);
begin
  if dlgOpen1.Execute then
    fileName := dlgOpen1.fileName;
end;

procedure TForm1.tv1Changing(Sender: TObject; Node: TTreeNode;
  var AllowChange: Boolean);
begin

  if Node = nil then
    Exit;
  if Node.Data = nil then
    Exit
  else
    edt1.Text := TAppBookMarks(Node.Data).id;
  edt2.Text := TAppBookMarks(Node.Data).url;
end;

initialization

ReportMemoryLeaksOnShutdown := True;

finalization

// ************************************************************

end.
