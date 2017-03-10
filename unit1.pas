unit Unit1;
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ComCtrls, ExtCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    CheckBox1: TCheckBox;
    ComboBox1: TComboBox;
    Image1: TImage;
    Image2: TImage;
    ListBox1: TListBox;
    ProgressBar1: TProgressBar;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure CheckBox1Change(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure HyAmClick(Sender: TObject);
    procedure Image2Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  Form1: TForm1; 

implementation
  uses fs0,
    {$ifdef linux}
    D in 'DisksL',
    {$endif}
    {$ifdef windows}
    D in 'Disks',
    {$endif}
      LCLProc, LazHelpHTML, UTF8Process;

  const linktosite = 'http://hy-am.org';
  const linktofund = 'http://www.osi.am';
  const linktohelp = 'http://hy-am.org/docs/armenian-for-symbian.html';
  const msgTitle = 'Armenian fonts installer for Symbian by hy-AM.org';
  const msgInstr = 'Միացրեք հեռախոսը համակարգչին Mass storage ռեժիմով,' + LineEnding +
    'կամ տեղադրեք իր հիշողության քարտը քարտավարի մեջ։' + LineEnding +
    'Ընրեք այն ցանկից, համոզվեք, որ ճիշտ սարքատառ եք ընտրել,' + LineEnding +
    ' և սեղմեք տեղեկայելու կոճակը։';
  const msgChooseDrive = 'Ընտրեք Սիմբիան հեռախոսի սարքատառը';//;'Choose Symbian phone drive';
  const msgError = 'Սխալ';
  const msgChoose_drive_first = 'Խնդրում ենք նախ ցանկից ընտրել Սիմբիան հեռախոսի սարքը։';//'Please, choose Symbian phone drive first';
  const msgInstallFonts = 'Տեղադրել տառատեսակները ընտրված դիսկի վրա';//'Install fonts on selected device';
  const msgAboutDotDotDot = 'Ծրագրի մասին';//'About...';
  const msgHelpCaption = 'Օգնություն';
  const msgShowOnlyRD = 'ցուցադրել միայն հեռացվելի սարքերը'; //;'show only removable drives';
  const msgAbout = 'Հայերեն տառատեսակների տեղադրիչ' + LineEnding +
  'Սիմբիան հեռախոսների համար վ. 1.0 (2011 մարտ 27)' + LineEnding +
LineEnding +
  'Ծրագրավորում՝' + LineEnding +
  'Նորայր Չիլինգարյան և Ալեքսեյ Չալաբյան' + LineEnding +
  'Տառատեսակները՝' + LineEnding +
  'Ռուբեն Թառումյան և Monotype ' + LineEnding + LineEnding +
  'Ծրագրի ֆինանսավորող՝ ' + LineEnding +
  'Բաց Հասարակության հիմնադրամներ – Հայաստան ' + LineEnding + LineEnding +
  'Ծրագիրը տարածվում է GPLv3 թույլատրագրով։';
{
  const msgAbout = 'Հայերեն տառատեսակների տեղադրիչ' + LineEnding +
  'Սիմբիան հեռախոսների համար վ. 1.0' + LineEnding +  LineEnding +
  'Ծրագրավորում՝' + LineEnding +
  'Նորայր Չիլինգարյան և Ալեքսեյ Չալաբյան' + LineEnding +
  'Տառատեսակները՝' + LineEnding +
  'Ռուբեն Թառումեան (Հակոբյան) և Symbian' + LineEnding + LineEnding +
  'Ծրագրի ֆինանսավորող՝ ' + LineEnding +
  'Բաց Հասարակության հիմնադրամներ – Հայաստան ' + LineEnding + LineEnding +
  'Ծրագիրը տարածվում է GPLv3 թույլատրագրով։';
 }
  const msgCongrats = 'Շնորհավորո՛ւմ ենք'; //Congratulations!
  const msgCongratulations =  'Շնորհավորո՛ւմ ենք։ Այժմ ձեր հեռախոսը կարող է հայերեն գրվածքներ ցուցադրել։' + LineEnding +
       'Փոփոխությունները տեսնելու համար, դուք պետք է վերագործարկեք (անջատեք և միացնեք) ձեր հեռախոսը։';
  //'Congratulations! Now you can read Armenian on your device!' + LineEnding +
       //' You need to restart your Symbian device (switch it on and off) in order to enable changes.';  var drive_is_chosen : boolean = false;
 var drive_is_chosen : boolean = false;
{$R *.lfm}

{ TForm1 }

procedure refreshlist;
var list : D.DskArr;
  strlst : TStringList;
begin
//    Edit1.Text:=(Disks.GetFirstCdRomDrive);
//    ComboBox1.Items := Disks.GetDriveList;
if Form1.CheckBox1.Checked then
   begin
   list := D.GetRemovableDrives
   end
else
   begin
   list := D.GetDrives
   end;
strlst := D.DskArr2StringList(list);
Form1.ComboBox1.Items := strlst;
end; //refreshlist

procedure CopyFonts0;
const resource0 =  'Resource';
const fonts0 = 'Fonts';
const localpath0 = 'ttf';
const opera0 = 'System' + DirectorySeparator + 'Apps' + DirectorySeparator + 'OperaMobile' + DirectorySeparator + 'fonts';
const opera1 = 'System' + DirectorySeparator + 'Apps' + DirectorySeparator + 'OperaMobile' + DirectorySeparator + 'fonts2';
const droidlocalpath0 = 'operafonts';
const droidlocalpath1 = 'operafonts2';

var CurDir, s, source0, destination0 : string;
flist, flist2 : TStringList;
i : integer;
begin
   CurDir  := ExtractFilePath(Application.ExeName);

   s := Form1.ComboBox1.Caption + DirectorySeparator + resource0;

   If (not (SysUtils.DirectoryExists(s) )) then begin
       CreateDir(s);
   end;     //if

   s := s + DirectorySeparator + fonts0;

   If (not (SysUtils.DirectoryExists(s) )) then begin
        CreateDir(s);
   end; //if
   source0 := CurDir {+ DirectorySeparator } + localpath0;
   flist := TStringList.Create;
   fs0.FindFiles(flist, source0, '*.ttf');

   Form1.ProgressBar1.Max:= flist.Count -1 ; //number of fonts
   Form1.ProgressBar1.Position := 0;

   for i := 0 to flist.Count -1 do begin
      source0 := CurDir + localpath0 + DirectorySeparator + flist[i];
      destination0 := s + DirectorySeparator + flist[i];
      fs0.FileCopy(source0, destination0);
      Form1.ProgressBar1.Position := Form1.ProgressBar1.Position + 1;
   end;
   flist.free;

  // replacing Opera fonts
  s := Form1.ComboBox1.Caption + DirectorySeparator + opera0;
  if (SysUtils.DirectoryExists(s) ) then begin
       // found Opera Mobile
       source0 := CurDir {+ DirectorySeparator } + droidlocalpath0;
       flist2 := TStringList.Create;
       fs0.FindFiles(flist2, source0, '*.ttf');

       Form1.ProgressBar1.Max:= flist2.Count -1 ; //number of fonts
       Form1.ProgressBar1.Position := 0;

       for i := 0 to flist2.Count -1 do begin
          source0 := CurDir + droidlocalpath0 + DirectorySeparator + flist[i];
          destination0 := s + DirectorySeparator + flist[i];
          fs0.FileCopy(source0, destination0);
          Form1.ProgressBar1.Position := Form1.ProgressBar1.Position + 1;
       end;
       flist2.free;
  end;


  s := Form1.ComboBox1.Caption + DirectorySeparator + opera1;
  if (SysUtils.DirectoryExists(s) ) then begin
       // found Opera Mobile
       source0 := CurDir {+ DirectorySeparator } + droidlocalpath1;
       flist2 := TStringList.Create;
       fs0.FindFiles(flist2, source0, '*.ttf');

       Form1.ProgressBar1.Max:= flist2.Count -1 ; //number of fonts
       Form1.ProgressBar1.Position := 0;

       for i := 0 to flist2.Count -1 do begin
          source0 := CurDir + droidlocalpath1 + DirectorySeparator + flist[i];
          destination0 := s + DirectorySeparator + flist[i];
          fs0.FileCopy(source0, destination0);
          Form1.ProgressBar1.Position := Form1.ProgressBar1.Position + 1;
       end;
       flist2.free;
  end;



  //Dialogs.ShowMessage (msgCongratulations);
  MessageDlg (msgCongrats, msgCongratulations, mtInformation,
                  [mbOK],0);
end; //CopyFonts

procedure WebClick(UrlClick: string);
var
  v: THTMLBrowserHelpViewer;
  BrowserPath, BrowserParams: string;
  p: LongInt;
  URL: String;
  BrowserProcess: TProcessUTF8;
begin
  v:=THTMLBrowserHelpViewer.Create(nil);
  try
    v.FindDefaultBrowser(BrowserPath,BrowserParams);
    debugln(['Path=',BrowserPath,' Params=',BrowserParams]);

    URL:=UrlClick;
    p:=System.Pos('%s', BrowserParams);
    System.Delete(BrowserParams,p,2);
    System.Insert(URL,BrowserParams,p);

    // start browser
    BrowserProcess:=TProcessUTF8.Create(nil);
    try
      BrowserProcess.CommandLine:=BrowserPath+' '+BrowserParams;
      BrowserProcess.Execute;
    finally
      BrowserProcess.Free;
    end;
  finally
    v.Free;
  end;
end; //WebClick

procedure TForm1.Button1Click(Sender: TObject);
begin
//refreshlist;
  if drive_is_chosen = false then begin
       MessageDlg (msgError, msgChoose_drive_first, mtError,
                  [mbOK],0);

  end
 else
  begin
  CopyFonts0;
  end;
end; //button

procedure TForm1.Button2Click(Sender: TObject);
begin
  MessageDlg(msgTitle,msgAbout,mtInformation,[mbOk],0);
end;

procedure TForm1.CheckBox1Change(Sender: TObject);
begin
  refreshlist;
end;

procedure TForm1.ComboBox1Change(Sender: TObject);
begin
  drive_is_chosen := true;
  ListBox1.Clear;
  fs0.FillListBox(ComboBox1.Caption ,ListBox1);
  ListBox1.Sorted:=True;
  ComboBox1.ReadOnly:=True;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Form1.Caption := msgTitle;
  ComboBox1.Caption:= msgChooseDrive;
  Button1.Caption:= msgInstallFonts;
  Button2.Caption:= msgAboutDotDotDot;
  Button3.Caption:= msgHelpCaption;
  CheckBox1.Checked:= true;
  CheckBox1.Caption:= msgShowOnlyRD;
  refreshlist;
end;

procedure TForm1.HyAmClick(Sender: TObject);
begin
WebClick(linktosite)
end; //

procedure TForm1.Image2Click(Sender: TObject);
begin
    WebClick(linktofund);
end;

procedure TForm1.Button3Click(Sender: TObject);

begin
  WebClick(linktohelp);
end; //btn3 click

end.

