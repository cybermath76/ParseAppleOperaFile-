unit typeDefBase;

{Модуль базового класса.}

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
      _fileName           : string;       // Имя файла
      _fileArray          : TBytes;       // Байтовый массив, считанный из вызываемого файла
      _fileStrList        : TStringList;  // Строковый список, полученный из байтового массива
      _firstByteFromArray : Byte;         // Первый байт байтового массива

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

// Обязательно очищаем объект-поле, иначе получим утечку памяти.
destructor TAppFileBase.Destroy;
begin
  FreeAndNil(_fileStrList);
  inherited;
end;

// Процедура побайтно считывает файл в массив pArr типа TBytes и
// возвращает его через параметр.
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
