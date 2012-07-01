unit typeDefBase;

{������ �������� ������.}

interface

uses
  SysUtils,
  Classes;
//  Windows;

type
  TAppItem = class
    private
      _id       :   string;
      _name     :   string;

    public
//      destructor Destroy();

    published
      property id   : string  read _id    write _id;
      property name : string  read _name  write _name;

  end;

type
  TAppFileBase  = class
    protected
      _fileName           : string;       // ��� �����
      _fileArray          : TBytes;       // �������� ������, ��������� �� ����������� �����
      _fileStrList        : TStringList;  // ��������� ������, ���������� �� ��������� �������
      _firstByteFromArray : Byte;         // ������ ���� ��������� �������

    public
      constructor Create(str: string); overload; virtual; abstract;
      constructor Create(); overload; virtual; abstract;
      destructor Destroy; override;
      procedure CreateFileArray(); virtual;
      procedure CreateListFromArray(); virtual; abstract;

    published
      property fileStrList: TStringList read _fileStrList;
  end;


implementation
//*********   TAppItem    *******
//*******************************





//********* TAppFileBase  *******
//*******************************

// ����������� ������� ������-����, ����� ������� ������ ������.
destructor TAppFileBase.Destroy;
begin
  FreeAndNil(_fileStrList);
  inherited;
end;

// ��������� �������� ��������� ���� � ������ pArr ���� TBytes �
// ���������� ��� ����� ��������.
procedure TAppFileBase.CreateFileArray();
var
  pFS: TFileStream;
begin
  pFS := TFileStream.Create(_fileName, fmOpenRead);
  try
    SetLength(_fileArray, pFS.Size);
    pFS.ReadBuffer(Pointer(_fileArray)^, Length(_fileArray));
  finally
    pFS.Free;
  end;
end;



end.
