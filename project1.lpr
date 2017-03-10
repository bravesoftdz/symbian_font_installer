program project1;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, Unit1;

{$R *.res}

begin
  Application.Title:='Armenian fonts installer for Symbian by hy-AM.org';
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

