library opDLL;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  Project-View Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the BORLNDMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using BORLNDMM.DLL, pass string information
  using PChar or ShortString parameters. }

uses
  SysUtils,
  Classes;

const
  // Sets UnixStartDate to TDateTime of 01/01/1970
  UnixStartDate: TDateTime = 25569; // .1667

function DateTimeToUnix(ConvDate: TDateTime): Longint; stdcall;
begin
  // example: DateTimeToUnix(now);
  Result := Round((ConvDate - UnixStartDate) * 86400);
end;

function UnixToDateTime(USec: Longint): TDateTime; stdcall;
begin
  // Example: UnixToDateTime(1003187418);
  Result := (USec / 86400) + UnixStartDate;
end;

// Проверяем входную строку, является ли она URL-ом
function IsStringURL(_testStr: string): Boolean; overload; stdcall;
var
  position: Integer;
begin
  position := AnsiPos('http://', _testStr);
  if position = 0 then
    Result := False
  else
    Result := True;
end;

function IsStringURL(_testStr: string; var pPos: Integer): Boolean;
  overload; stdcall;
var
  position: Integer;
begin
  position := AnsiPos('http://', _testStr);
  if position = 0 then
    Result := False
  else
    Result := True;
  pPos := position;
end;
// ***************************************************************

// Функция проверяет полученную строку на соответствие ID.
// Я считаю, что номера вида 631856595ECF438FA5E2E3EC35A3C0C0 являются ID-ами.
function IsStringID(pStr: string): Boolean; stdcall;
var
  i: Integer;
  A1: set of Char;
  str: string;
begin
  str := '';
  pStr := TrimLeft(pStr);
  A1 := ['A' .. 'Z', '0' .. '9'];
  for i := 1 to Length(pStr) do
  begin
    if (pStr[i] in A1) then
      str := str + pStr[i]
    else
    begin
      str := '';
      Break;
    end;
  end;
  if Length(str) = 32 then
    Result := True
  else
    Result := False;
end;

function IsStringName(pStr: string): Boolean; stdcall;
var
  A1: set of Char;
  A2: set of Char;
  A3: set of AnsiChar;
  i: Integer;
begin
  pStr := TrimLeft(pStr);
  A1 := ['A' .. 'Z', '0' .. '9'];
  A2 := ['a' .. 'z', 'A' .. 'Z'];
  A3 := ['а' .. 'я', 'А' .. 'Я'];
  for i := 1 to Length(pStr) - 1 do
  begin
    if (pStr[i] in A2) or (not(AnsiChar(pStr[i]) in A3)) or (pStr[i] in A1) then
      Result := True
    else
    begin
      Result := False;
      Break;
    end;
  end;
end;

function IsFolder(ps: TStringList; index: Integer): Boolean; stdcall;
begin
  if (IsStringID(ps.Strings[index])) and (IsStringName(ps.Strings[index + 1]))
    and (IsStringID(ps.Strings[index + 2])) then
    Result := True
  else
    Result := False;
end;

function IsBookmark(ps: TStringList; index: Integer): Boolean; stdcall;
begin
  if (IsStringID(ps.Strings[index])) and
    (IsStringURL(ps.Strings[index + 2])) then
    Result := True
  else
    Result := False;
end;

// *****************************************************************************
// Функция читает первый байт переданого файла.
// Файл, начинающийся с нуля - файл закладок. Всё остальное - журнал.
function CheckFileType(fName: string): Byte; stdcall;
var
  f: TFileStream;
  buf: array [0 .. 5] of Char;
begin
  f := TFileStream.Create(fName, fmOpenRead);
  f.Read(buf, 5);
  f.Free;
  Result := Byte(buf[0]);
end;
// *****************************************************************************


exports
  UnixToDateTime index 10,

  DateTimeToUnix index 11;

exports
  IsStringURL(_testStr: string)name 'isu',

  IsStringURL(_testStr: string; var pPos: Integer)name 'isuEx',

  IsStringID index 30,

  IsStringName index 31,

  IsFolder index 32,

  IsBookmark index 33;

exports
  CheckFileType index 100;

{$R *.res}

begin

end.
