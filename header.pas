unit header;

{Заголовочный модуль. Содержит функции/процедуры библиотеки oppDll.dll.}

interface

uses
  Classes;


function UnixToDateTime(USec: Longint): TDateTime; stdcall;
  external 'opDll.dll' index 10;
function DateTimeToUnix(ConvDate: TDateTime): Longint; stdcall;
  external 'opDll.dll' index 11;
function IsStringURL(_testStr: string): Boolean; stdcall; overload;
  external 'opDll.dll' name 'isu';
function IsStringURL(_testStr: string; var pPos: Integer): Boolean; stdcall;
  overload; external 'opDll.dll' name 'isuEx';
function IsStringID(pStr: string): Boolean; stdcall; external 'opDll.dll' index 30;
function IsStringName(pStr: string): Boolean; stdcall; external 'opDll.dll' index 31;
function IsFolder(ps: TStringList; index: Integer): Boolean; stdcall; external 'opDll.dll' index 32;
function IsBookmark(ps: TStringList; index: Integer): Boolean; stdcall; external 'opDll.dll' index 33;
function CheckFileType(fName: string): Byte; stdcall; external 'opDll.dll' index 100;


implementation


end.
