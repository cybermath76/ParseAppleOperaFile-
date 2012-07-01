unit typeDefSucc;

{Модуль реализации классов.}

interface

uses
  SysUtils,
  Classes,
  typeDefBase;

// Класс Закладка
type
  TAppBookMarks = class(TAppItem)
  private
    _url: string;

  public

  published
    property url: string read _url write _url;

  end;

// Класс Журнал
type
  TAppJournal = class(TAppItem)
  private
    _date: Integer;

  public

  published
    property date: Integer read _date write _date;

  end;

// Класс считывает и формирует список из файла журнала
type
  TAppFileArrayJrnl = class(TAppFileBase)
  private

    procedure CreateList(pArr: TBytes; var pList: TStringList);

  public
    constructor Create(str: string); overload;
    constructor Create(); overload;
    destructor Destroy; override;
    procedure CreateFileArray(); override; // - в базовом классе
    procedure CreateListFromArray(); override;
    property fileStrList: TStringList read _fileStrList;
    property fileName: string read _fileName write _fileName;
  end;

type
  TBookmark = record
    id: string;
    name: string;
    url: string;
  end;

type
  TBMArray = array of TAppBookMarks;   //  TBookmark


// Класс считывает и формирует список из файла закладок
type
  TAppFileArrayBM = class(TAppFileArrayJrnl)
  private
    _bookMarksArr: TBMArray;
    procedure CreateList(pArr: TBytes; var pList: TStringList);

  public
    constructor Create(str: string); overload;
    constructor Create(); overload;
    destructor Destroy; override;
    procedure CreateFileArray(); override; // - в базовом классе
    procedure CreateListFromArray(); override; // - в базовом классе

  published
    property fileStrList: TStringList read _fileStrList;
    property fileName: string read _fileName write _fileName;
    property bookMarksArr: TBMArray  read _bookMarksArr write _bookMarksArr;

  end;

type
  TMyFinalArray = array of TAppJournal;

implementation

uses operations, mainUnit, header;

//************** Реализация класса TAppFileArrayJrnl ***********
//**************************************************************
constructor TAppFileArrayJrnl.Create(str: string);
begin
  _fileName:= str;
end;

constructor TAppFileArrayJrnl.Create();
begin
  inherited;
  _fileName:= '';
end;

// Обязательно очищаем объект-поле, иначе получим утечку памяти.
destructor TAppFileArrayJrnl.Destroy;
begin
  FreeAndNil(_fileStrList);
  inherited;
end;

{ Процедура формирует StringList из массива байтов файла.
  Байты со значением большим 32 считаются значащими символами.
  Байты со значением 00 и 01 считаются символами окончания строки и заменяются
  на CR LF.
  Байты со значением 32 - пробел.
}
procedure TAppFileArrayJrnl.CreateListFromArray();
var
  i, j: Integer;
  tempArr: TBytes;
  index: Integer;
begin
  index := -1;
  j := 0;
  i := 0;

  while i < Length(_fileArray) do
  begin

    if (_fileArray[i] = 0) then
    begin
      if index = -1 then
      begin
        SetLength(tempArr, j + 2);
        tempArr[j] := 13;
        tempArr[j + 1] := 10;
        Inc(j, 2);
        index := 1;
        Inc(i);
      end
      else
        Inc(i);
    end
    else if (_fileArray[i] = 32) then
    begin
      SetLength(tempArr, j + 1);
      tempArr[j] := Ord(' ');
      Inc(j);
      index := -1;
      Inc(i);
    end
    else if (_fileArray[i] > 32) then
    begin
      while (_fileArray[i] <> 0) do
      begin
        SetLength(tempArr, j + 1);
        tempArr[j] := _fileArray[i];
        Inc(j);
        index := -1;
        Inc(i);
      end;
    end
    else
      Inc(i);
  end;
  _fileStrList := TStringList.Create;
  CreateList(tempArr, _fileStrList);
end;

procedure TAppFileArrayJrnl.CreateList(pArr: TBytes; var pList: TStringList);
var
  qqq: TStringStream;
  qqqNonModified: TStringList;
  i, j, x: Integer;
  tempPList: TStringList;
  str: Ansistring;
  aa: PAnsiChar;
  tempInt: Ansistring;
  urlPos: Integer;
begin
  qqq := TStringStream.Create;
  qqqNonModified := TStringList.Create;
  try
    qqq.Write(pArr[0], Length(pArr));
    qqqNonModified.Text := qqq.DataString;
    pList.Text := Utf8ToAnsi(qqq.DataString);
    // Utf8ToAnsi       WideCharToMultiByte
  finally
    qqq.Free;
  end;

  for i := 0 to pList.Count - 1 do
    pList.Strings[i] := TrimLeft(pList.Strings[i]);

  tempPList := TStringList.Create;
  i := 0;
  while i < pList.Count - 2 do
  begin
    urlPos:= 0;
    if IsStringURL(pList.Strings[i], urlPos) then
    begin
      tempPList.Add(Copy(pList.Strings[i], urlPos, Length(pList.Strings[i])));
      tempPList.Add(Copy(pList.Strings[i+1], 1, Length(pList.Strings[i+1])-4));

      tempInt := Ansistring(Copy(qqqNonModified.Strings[i+1],
        (Length(qqqNonModified.Strings[i+1]) - 3),
        Length(qqqNonModified.Strings[i+1])));
      aa := @tempInt[1];
      str := '';
      for j := 0 to 3 do
      begin
        x := Ord(aa^);
        if x < 10 then
        begin
          x := Ord(aa^);
          str := str + '0' + IntToHex(x, 1);
        end
        else
          str := str + IntToHex(Ord(aa^), 1);
        Inc(aa, 1);
      end;
      str:= '$' + str;
      tempPList.Add(DateTimeToStr(UnixToDateTime(StrToInt(str))));
    end;
    Inc(i);
  end;
  pList.Text := tempPList.Text;
  FreeAndNil(tempPList);
  FreeAndNil(qqqNonModified);
end;

procedure TAppFileArrayJrnl.CreateFileArray();
begin
  inherited;
end;

//************** Реализация класса TAppFileArrayBM *************
//**************************************************************
constructor TAppFileArrayBM.Create(str: string);
begin
  inherited;
end;

constructor TAppFileArrayBM.Create();
begin
  inherited;
end;

// Обязательно очищаем объект-поле, иначе получим утечку памяти.
destructor TAppFileArrayBM.Destroy;
var
  i: Integer;
begin
  FreeAndNil(_fileStrList);
  for I := 0 to Length(_bookMarksArr) - 1 do
    FreeAndNil(_bookMarksArr[i]);
  inherited;
end;

procedure TAppFileArrayBM.CreateListFromArray();
var
  i, j: Integer;
  tempArr: TBytes;
  index: Integer;
begin
  index := -1;
  j := 0;
  for i := 0 to Length(_fileArray) do
  begin
    if _fileArray[i] > 32 then
    begin
      SetLength(tempArr, j + 1);
      tempArr[j] := _fileArray[i];
      Inc(j);
      index := -1;
    end
    else if (_fileArray[i] = 0) or (_fileArray[i] = 01) then
    begin
      if index = -1 then
      begin
        SetLength(tempArr, j + 2);
        tempArr[j] := 13;
        tempArr[j + 1] := 10;
        Inc(j, 2);
        index := 1;
      end;
    end
    else if (_fileArray[i] = 32) then
    begin
      SetLength(tempArr, j + 1);
      tempArr[j] := Ord(' ');
      Inc(j);
    end;
  end;
  _fileStrList := TStringList.Create;
  CreateList(tempArr, _fileStrList);
end;

procedure TAppFileArrayBM.CreateList(pArr: TBytes; var pList: TStringList);
var
  qqq: TStringStream;
  i: Integer;
  tempPList: TStringList;
begin
  qqq := TStringStream.Create;
  try
    qqq.Write(pArr[0], Length(pArr));
    pList.Text := Utf8ToAnsi(qqq.DataString);
    // Utf8ToAnsi       WideCharToMultiByte
  finally
    qqq.Free;
  end;

  for i := 0 to pList.Count - 1 do
    pList.Strings[i] := TrimLeft(pList.Strings[i]);

  tempPList := TStringList.Create;
  i := 0;
  while i < pList.Count - 2 do
  begin
   if IsFolder(pList, i) then
    begin
      tempPList.Add(pList.Strings[i]);
      tempPList.Add(pList.Strings[i + 1]);
      Inc(i, 2);
    end
    else if IsBookmark(pList, i) then
    begin
      tempPList.Add(pList.Strings[i]);
      tempPList.Add(pList.Strings[i + 1]);
      tempPList.Add(pList.Strings[i + 2]);
      Inc(i, 3);
    end
    else
    if (IsStringID(pList.Strings[i])) then
    begin
      tempPList.Add(pList.Strings[i]);
      Inc(i, 1);
      Continue;
    end
    else
      Inc(i);
  end;
  pList.Text := tempPList.Text;
  FreeAndNil(tempPList);
end;

procedure TAppFileArrayBM.CreateFileArray();
begin
  inherited;
end;


end.
