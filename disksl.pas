unit DisksL;

{$mode objfpc}{$H+}

interface
uses Classes;
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
type tab = record
     dev, mpoint : string;
end;
type tabarr = array of tab;

function GetRemovableDrives : DskArr;
function GetDrives : DskArr;
function DskArr2StringList(const arr : DskArr) : TStringList;

implementation
uses strutils, sysutils, baseunix;
function DskArr2StringList(const arr : DskArr) : TStringList;
var i : integer;
begin
  result := TStringList.Create;
  for i := 0 to high(arr) do begin
     result.Add(arr[i].name);
  end;
end;

function GetMountedDrives() : tabarr;
const mtab = '/etc/mtab';
var tabs: tabarr;
f : System.TextFile;
s0, s1, s2 : String;
i : integer;
begin
i := 0;
setlength(tabs, i);
System.Assign(f, mtab);
System.Reset(f);
repeat
   ReadLn (f, s0);
   s1 := strutils.ExtractWord(1, s0, [' ']);
   s2 := strutils.LeftStr(s1, 7);
   if s2 = '/dev/sd' then begin
      inc(i);
      setlength(tabs, i);
      tabs[i-1].dev:= s1;
      s2 := strutils.ExtractWord(2, s0, [' ']);
      tabs[i-1].mpoint:= s2;
   end;
until System.EOF(f);
result := tabs;
end;     //GetMountedDrives


function GetDrives() : DskArr;
var
//  f : System.TextFile;
  j : integer;
//  s0, s1: string;
  disks : DskArr;
  tabs : tabarr;
begin
{  System.Assign(f, partitions);
  System.Reset(f);
  j := 0;
  setlength (disks,j);
  repeat
    readln(f, s0);
    s1 := strutils.ExtractWord(4, s0, [' ']);
    if ((s1<>'') and (s1[1] = 's') and (s1[2] = 'd')) then begin
       inc(j);
       setlength(disks, j);
       disks[j-1].name:= s1;
       disks[j-1].kindstr:= 'UNKNOWN';
       disks[j-1].kind:= DRIVE_UNKNOWN;
    end; //if
  until System.EOF(f);}
  tabs := GetMountedDrives;
  for j := 0 to HIGH (tabs) do begin
     setlength (disks, j+1);
     disks[j].kindstr:= 'UNKNOWN';
     disks[j].kind:= DRIVE_UNKNOWN;
     disks[j].name:= tabs[j].mpoint;
  end;
  result := disks;
end;         //GetDrives

function GetRemovableDrives : DskArr;
const path='/dev/disk/by-id/';
pattern ='usb*';
//pattern = '';
var
  Srec : TSearchRec;
  Err : Integer;
  s0, s1, s2: String;
  j, i : integer;
  disks : DskArr;
  tabs : tabarr;
begin
   j := 0;
   setlength (disks, j);
   tabs := GetMountedDrives;
   Err := sysutils.FindFirst(path + pattern, faSymLink, Srec);
   while Err = 0 do begin
     // if ((Srec.Name <> '.') and (Srec.name <> '..')) then begin
     // if (Srec.Attr and faSymLink) = faSymLink then begin
          //s0 := Srec.Name;
          s0 := baseunix.fpReadLink(path + Srec.Name);
          for i := 0 to HIGH(tabs) do begin
             s1 := strutils.ExtractWord(2, tabs[i].dev, [' ', '/']);
             s2 := strutils.ExtractWord(3, s0, [' ', '/']);
             if s1 = s2 then begin
                //s3 := path + s0;
                inc(j);
                setlength (disks, j);
                disks[j-1].name:= tabs[i].mpoint;
                disks[j-1].kind := DRIVE_REMOVABLE;
                disks[j-1].kindstr:= 'REMOVABLE DISK';
             end; //if
          end;

     // end;
    //  end;
      Err := SysUtils.FindNext(Srec);
   end;
   SysUtils.FindClose(Srec);
   result := disks;
end; //GetRemovableDrives

end.

