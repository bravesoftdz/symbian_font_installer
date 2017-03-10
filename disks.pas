unit Disks;

{$mode objfpc}{$H+}

interface
uses
  Classes, SysUtils, Windows;

const
     DRIVE_REMOVABLE = 2;
     DRIVE_FIXED = 3;
     DRIVE_REMOTE = 4;
     DRIVE_CDROM = 5;
     DRIVE_RAMDISK = 6;
     DRIVE_UNKNOWN = 0;
     DRIVE_NO_ROOT_DIR = 1;


type DiskDrive = record
      name : string;
      kind : integer;
      kindstr : string;
end;
type DskArr = array of DiskDrive;

function GetFirstCdRomDrive: string;
function GetDriveList : TStringlist;
function DskArr2StringList(const arr : DskArr) : TStringList;
function GetRemovableDrives : DskArr;
function GetDrives : DskArr;

implementation

function DskArr2StringList(const arr : DskArr) : TStringList;
var i : integer;
begin
  result := TStringList.Create;
  for i := 0 to high(arr) do begin
     result.Add(arr[i].name);
  end;
end;

function GetDriveTypeAsDiskDrive(sDrvChr: string): DiskDrive;
begin
  result.name:= sDrvChr;
  result.kind := GetDriveType(Pchar(sDrvChr));

  //iDrvType := GetDriveType(Pchar(sDrvChr));

  case result.kind of
    DRIVE_UNKNOWN:      result.kindstr :=  'UNKNOWN';
    DRIVE_NO_ROOT_DIR:  result.kindstr :=  'NO ROOT';
    DRIVE_REMOVABLE:    result.kindstr :=  'REMOVABLE DISK';
    DRIVE_FIXED:        result.kindstr :=  'FIXED DISK';
    DRIVE_REMOTE:       result.kindstr :=  'NETWORK DRIVE';
    DRIVE_CDROM:        result.kindstr :=  'CDROM';
    DRIVE_RAMDISK:      result.kindstr :=  'RAM DISK';
    else                result.kindstr :=  '-';
  end;
end;



function GetDrives() : DskArr;
var
  sDrvChr : string;
  i,j : integer;
  cDrvChr : array[1..255] of char;
  disks : DskArr;
begin
  j := 0;
  setlength (disks,j);
  GetLogicalDriveStrings(255, @cDrvChr);
  i := 1;
  repeat
    sDrvChr := '';
    while (i <= 255) and (cDrvChr[i] <> #00) do
    begin
      sDrvChr := sDrvChr + char(cDrvChr[i]);
      inc(i);
    end;
    inc(i);
    inc(j);
    setlength(disks, j);
    disks[j-1] := GetDriveTypeAsDiskDrive(sDrvChr);
  until length(sDrvChr) = 0;
  setlength(disks, j-1);
  result := disks;
end;

function GetRemovableDrives() : DskArr;
var
  sDrvChr : string;
  i,j : integer;
  cDrvChr : array[1..255] of char;
  disks : DskArr;
begin
  j := 0;
  setlength (disks,j);
  GetLogicalDriveStrings(255, @cDrvChr);
  i := 1;
  repeat
    sDrvChr := '';
    while (i <= 255) and (cDrvChr[i] <> #00) do
    begin
      sDrvChr := sDrvChr + char(cDrvChr[i]);
      inc(i);
    end;
    inc(i);
    if (GetDriveType(Pchar(sDrvChr)) = DRIVE_REMOVABLE) then begin
       inc(j);
       setlength(disks, j);
       disks[j-1] := GetDriveTypeAsDiskDrive(sDrvChr);
    end;
  until length(sDrvChr) = 0;
  result := disks;
end;


function GetFirstCdRomDrive: string;
var
  r: LongWord;

  Drives: array[0..128] of char;
  pDrive: pchar;
begin
  Result := '';
  r := GetLogicalDriveStrings(sizeof(Drives), Drives);
  if r = 0 then exit;
  if r > sizeof(Drives) then
    raise Exception.Create(SysErrorMessage(ERROR_OUTOFMEMORY));

  pDrive := Drives;
  while pDrive^ <> #0 do begin
    if GetDriveType(pDrive) = DRIVE_CDROM then begin
      Result := pDrive;
      exit;
    end;
    inc(pDrive, 4);
  end;
end;


function GetDriveList : TStringlist;
var
  sDrvChr : string;
  i : integer;
  cDrvChr : array[1..255] of char;
  iDrvType : integer;


  function GetDrvType(sDrvChr: string): string;
  begin

    iDrvType := GetDriveType(Pchar(sDrvChr));
    case iDrvType of
      DRIVE_UNKNOWN:      Result := 'UNKNOWN';
      DRIVE_NO_ROOT_DIR:  Result := 'NO ROOT';
      DRIVE_REMOVABLE:    Result := 'REMOVABLE DISK';
      DRIVE_FIXED:        Result := 'FIXED DISK';
      DRIVE_REMOTE:       Result := 'NETWORK DRIVE';
      DRIVE_CDROM:        Result := 'CDROM';
      DRIVE_RAMDISK:      Result := 'RAM DISK';
      else                Result := '-';
    end;
  end;

begin
  GetLogicalDriveStrings(255, @cDrvChr);
  result := TStringList.create;
  i := 1;
  repeat
    sDrvChr := '';
    while (i <= 255) and (cDrvChr[i] <> #00) do
    begin
      sDrvChr := sDrvChr + char(cDrvChr[i]);
      inc(i);
    end;
    inc(i);
    result.add(sDrvChr + ':' + GetDrvType(sDrvChr));
  until length(sDrvChr) = 0;
end;

end.

