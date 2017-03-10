unit fs0;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, StdCtrls;
procedure FindFiles(FilesList: TStringList; StartDir, FileMask: string);
procedure FillListBox(s : string; l : StdCtrls.TListBox);
procedure FileCopy(const FSrc, FDst: string);
implementation

// Recursive procedure to build a list of files
procedure FindFiles(FilesList: TStringList; StartDir, FileMask: string);
var
  SR: TSearchRec;
  DirList: TStringList;
  IsFound: Boolean;
 // i: integer;
begin
  if StartDir[length(StartDir)] <> '/' {'\'}{ DirectorySeparator} then
    StartDir := StartDir + {'\'} {'/'}DirectorySeparator;

  { Build a list of the files in directory StartDir
     (not the directories!)                         }

  IsFound :=
    FindFirst(StartDir+FileMask, (faAnyFile and faDirectory), SR) = 0;
  while IsFound do begin
    FilesList.Add({StartDir +} SR.Name);
    IsFound := FindNext(SR) = 0;
  end;
  FindClose(SR);

  // Build a list of subdirectories
 { DirList := TStringList.Create;
  IsFound := FindFirst(StartDir+'*', faAnyFile, SR) = 0;
  while IsFound do begin
    if ((SR.Attr and faDirectory) <> 0) and
         (SR.Name[1] <> '.') then
      DirList.Add(StartDir + SR.Name);
    IsFound := FindNext(SR) = 0;
  end;
  FindClose(SR);

  // Scan the list of subdirectories
  for i := 0 to DirList.Count - 1 do
    FindFiles(FilesList, DirList[i], FileMask);

  DirList.Free;}
end; //FindFiles

procedure FillListBox(s : string; l : TListBox);
var
  FilesList: TStringList;
begin
  FilesList := TStringList.Create;
  try
    FindFiles(FilesList, s, '*');
    l.Items.Assign(FilesList);
    //LabelCount.Caption := 'Files found: ' + IntToStr(FilesList.Count);
  finally
    FilesList.Free;
  end;
end;// FillListBox;

procedure FileCopy(const FSrc, FDst: string);
var
  sStream,
  dStream: TFileStream;
begin
  sStream := TFileStream.Create(FSrc, fmOpenRead);
  try
    dStream := TFileStream.Create(FDst, fmCreate);
    try
      {Forget about block reads and writes, just copy
       the whole darn thing.}
      dStream.CopyFrom(sStream, 0);
    finally
      dStream.Free;
    end;
  finally
    sStream.Free;
  end;
end; //FileCopy
end.

