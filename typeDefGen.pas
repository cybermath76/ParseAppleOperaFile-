unit typeDefGen;

interface

uses
//  Windows,
  SysUtils,
//  StdCtrls,
  Dialogs,
  typeDefBase,
  typeDefSucc,
//  ComCtrls,
//  operations,
  TypInfo;

  // Класс реализует очистку типов: TArrAppBaseFile, TAppFileArrayBM, TAppFileArrayJrnl
type
  TErase = class(TObject)
  public
    class procedure Erase<T>(var a: T); static;
  end;

type
  TItemOperation = class(TObject)
  public
    class procedure CreateObject<T>(var a: T); static;
    class procedure CreateArrayOfBaseClass<TArr, TItem>(var b: TArr;
      var a: TItem; i: Integer; str: string);static;
    class function IsObjectClear<T>(var a: T): Boolean; static;
  end;

  // Класс, используя возможности RTTI определяет тип объект.
type
  TRTTI = class(TObject)
  public
    class function TypeInfo<T>: PTypeInfo; static;
  end;

type
  TArrAppBaseFile = array of TAppFileBase;

implementation

uses mainUnit;

class procedure TErase.Erase<T>(var a: T);
var
  Info: PTypeInfo;
  i: Integer;
begin
  { Лучше применять второй способ, т.к может попасться тип, не имеющий RTTI,
    например, Pointer }
  // Info := TypeInfo(T);
  Info := TRTTI.TypeInfo<T>;
  if Info = nil then
    Exit;
  if Info.Name = 'TArrAppBaseFile' then
  begin
    for i := Low(MultiFileArr) to High(MultiFileArr) do
      FreeAndNil(MultiFileArr[i]);
    Exit;
  end;

  if TObject(a) <> nil then
    FreeAndNil(a);
end;

class procedure TItemOperation.CreateObject<T>(var a: T);
var
  Info: PTypeInfo;
begin
  { Лучше применять второй способ, т.к может попасться тип, не имеющий RTTI,
    например, Pointer }
  // Info := TypeInfo(T);
  Info := TRTTI.TypeInfo<T>;
  if Info = nil then
    Exit;

  if Info.Name = 'TAppFileArrayBM' then
  begin
    TAppFileArrayBM(a) := TAppFileArrayBM.Create(fileName);
    TAppFileArrayBM(a).CreateFileArray(); // Закладки
    try
      TAppFileArrayBM(a).CreateListFromArray();
    except
      ShowMessage('Ошибка создания TStringListBookMarks');
    end;
  end
  else if Info.Name = 'TAppFileArrayJrnl' then
  begin
    TAppFileArrayJrnl(a) := TAppFileArrayJrnl.Create(fileName);
    TAppFileArrayJrnl(a).CreateFileArray(); // Закладки
    try
      TAppFileArrayJrnl(a).CreateListFromArray();
    except
      ShowMessage('Ошибка создания TStringListJournal');
    end;
  end;
end;

class procedure TItemOperation.CreateArrayOfBaseClass<TArr, TItem>(var b: TArr;
  var a: TItem; i: Integer; str: string);
var
  InfoAr: PTypeInfo;
  InfoIt: PTypeInfo;
  tempArr: TArrAppBaseFile;
  ptr: Pointer;
begin
  InfoAr := TRTTI.TypeInfo<TArr>;
  InfoIt := TRTTI.TypeInfo<TItem>;
  if (InfoAr = nil) or (InfoIt = nil) then
    Exit;

  ptr := @b;
  tempArr := TArrAppBaseFile(ptr^);

  if InfoIt.Name = 'TAppFileArrayBM' then
  begin
    TAppFileArrayBM(a) := TAppFileArrayBM.Create(str);
    tempArr[i] := TAppFileArrayBM(a);
    tempArr[i].CreateFileArray(); // Закладки
    try
      tempArr[i].CreateListFromArray();
    except
      ShowMessage('Ошибка создания TStringListBookMarks');
    end;
  end
  else if InfoIt.Name = 'TAppFileArrayJrnl' then
  begin
    TAppFileArrayJrnl(a) := TAppFileArrayJrnl.Create(str);
    tempArr[i] := TAppFileArrayJrnl(a);
    tempArr[i].CreateFileArray(); // Журнал
    try
      tempArr[i].CreateListFromArray();
    except
      ShowMessage('Ошибка создания TStringListBookMarks');
    end;
  end;
end;

class function TItemOperation.IsObjectClear<T>(var a: T): Boolean;
var
  Info: PTypeInfo;
  tempArr: TArrAppBaseFile;
  ptr: Pointer;
begin
  Result := False;
  Info := TRTTI.TypeInfo<T>;
  if Info.Name = 'TAppFileArrayBM' then
  begin
    if TAppFileArrayBM(a) = nil then
      Result := True;
  end
  else if Info.Name = 'TAppFileArrayJrnl' then
  begin
    if TAppFileArrayJrnl(a) = nil then
      Result := True;
  end
  else if Info.Name = 'TAppFileArrayBM' then
  begin
    ptr := @a;
    tempArr := TArrAppBaseFile(ptr^);
    if Length(tempArr) = 0 then
      Result := True;
  end
end;

class function TRTTI.TypeInfo<T>: PTypeInfo;
begin
  Result := System.TypeInfo(T);
end;



end.
