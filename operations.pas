unit operations;

{ Модуль содержит некоторые функции/процедуры, необходимые для работы. }

interface

uses
//  SysUtils,
  Classes,
  ComCtrls,
//  Windows,
  typeDefSucc;

procedure CreateTreeView(pObjBM: TAppFileArrayBM; pt: TStringList;
  index: Integer);

implementation

uses mainUnit, header;

procedure InsertDataToNode(var pW: TTreeNode; ppobjBM: TAppFileArrayBM;
  ptBM: TAppBookMarks; ppt: TStringList; iNumber: Integer);
var
  tarr: TBMArray;
  urlPos: Integer;
begin
  urlPos := 0;
  tarr := ppobjBM.bookMarksArr; // При массиве fobjBM - этой переменной нет
  SetLength(tarr, Length(tarr) + 1);
  ptBM := TAppBookMarks.Create;
  ptBM.id := ppt.Strings[iNumber];
  ptBM.name := ppt.Strings[iNumber + 1];
  if IsStringURL(ppt.Strings[iNumber + 2], urlPos) then
    ptBM.url := (Copy(ppt.Strings[iNumber + 2], urlPos,
      Length(ppt.Strings[iNumber + 2])));
  pW.Data := ptBM;
  tarr[ High(tarr)] := ptBM;
  ppobjBM.bookMarksArr := tarr;
end;

procedure CreateTreeView(pObjBM: TAppFileArrayBM; pt: TStringList;
  index: Integer);
var
  i, j: Integer;
  aa: array of Integer;
  arrNum: Integer;
  mark: Integer;
  tempTN, w: TTreeNode;
  xCount: Integer;
  ts: string;
  tBM: TAppBookMarks;
  tarr: TBMArray;
begin
  arrNum := 0;
  xCount := 0;
  mark := -1;
  i := 0;
  j := 0;
  while i <= pt.Count - 5 do
  begin
    if IsStringID(pt.Strings[i]) and IsStringID(pt.Strings[i + 1]) then
    begin
      Inc(xCount);
      Inc(i);
      Continue;
    end
    else
    begin
      if xCount <> 0 then
      begin
        SetLength(aa, Length(aa) + 1);
        aa[arrNum] := xCount;
        Inc(arrNum);
        xCount := 0;
      end;
    end;
    Inc(i);
  end;

  i := 0;
  arrNum := 0;

  Form1.tv1.Select(Form1.tv1.Items.Add(Form1.tv1.Selected, 'Bookmarks'));

  while i <= pt.Count - 5 do
  begin
    if IsStringID(pt.Strings[i]) and IsStringID(pt.Strings[i + 1]) then
    begin
      repeat
        Form1.tv1.Select(Form1.tv1.Selected.Parent);
        Inc(j);
      until j >= aa[arrNum];

      j := 0;
      i := i + aa[arrNum];
      Inc(arrNum);
      mark := -1;
      Continue;
    end
    else
    begin
      if IsStringID(pt.Strings[i]) and (mark = -1) then
      begin
        if IsBookmark(pt, i) then
        begin
          ts := pt.Strings[i + 1];
          w := Form1.tv1.Items.Add(Form1.tv1.Selected, pt.Strings[i + 1]);
          Form1.tv1.Select(w);
          InsertDataToNode(w, pObjBM, tBM, pt, i);
          Inc(i, 2);
        end
        else
        begin
          ts := pt.Strings[i + 1];
          w := Form1.tv1.Items.AddChild(Form1.tv1.Selected, pt.Strings[i + 1]);
          Form1.tv1.Select(w);
          InsertDataToNode(w, pObjBM, tBM, pt, i);
          // Form1.tv1.Select(Form1.tv1.Items.GetFirstNode);
          mark := 1;
        end;

      end
      else if IsStringID(pt.Strings[i]) and (mark = 1) then
      begin
        if IsBookmark(pt, i) then
        begin
          if tempTN <> nil then // иначе y = 0
            Form1.tv1.Select(tempTN);
          ts := pt.Strings[i + 1];
          w := Form1.tv1.Items.AddChild(Form1.tv1.Selected, pt.Strings[i + 1]);
          Form1.tv1.Select(w);
          InsertDataToNode(w, pObjBM, tBM, pt, i);
          Inc(i, 2);
        end

        else
        begin
          ts := pt.Strings[i + 1];
          tempTN := Form1.tv1.Items.AddChild(Form1.tv1.Selected,
            pt.Strings[i + 1]);
          tarr := pObjBM.bookMarksArr;
          SetLength(tarr, Length(tarr) + 1);

          tBM := TAppBookMarks.Create;
          tBM.id := pt.Strings[i];
          tBM.name := pt.Strings[i + 1];
          tempTN.Data := tBM;
          tarr[ High(tarr)] := tBM;
          // SetLength(fobjBM.bookMarksArr, Length(fobjBM.bookMarksArr)+1);
          pObjBM.bookMarksArr := tarr;
          // FreeAndNil(tBM);
        end;
      end;
      // FreeAndNil(tBM);
      Inc(i);
    end;
  end;
end;

end.
