unit Projekt1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, IdIOHandler, IdIOHandlerSocket,
  IdIOHandlerStack, IdBaseComponent, IdTCPClient, IdComponent,Data.Bind.Components,
  Data.Bind.ObjectScope,ActiveX,  Vcl.OleCtrls,
  IdTCPConnection, Vcl.StdCtrls, IdHTTP, SHDocVw, IdSSL, IdSSLOpenSSL;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    IdHTTP1: TIdHTTP;
    IdSSLIOHandlerSocketOpenSSL1: TIdSSLIOHandlerSocketOpenSSL;
    Button1: TButton;
    Button2: TButton;
    WebBrowser1: TWebBrowser;
    Memo2: TMemo;
    SaveDialog1: TSaveDialog;
    procedure Button1Click(Sender: TObject);
    Function  GetTags():String;
    procedure SplitText(const aDelimiter,s: String; aList: TStringList);
    procedure FormCreate(Sender: TObject);
    Function FindUrl(name:String;st:Integer):String;
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  s: string;
  strArray  : TStringList;
  html:String;
  indkes:Integer;
implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  link:String;
  i:Integer;
  vnesenaBeseda:String;
  tab:TStringList;
  begin

  tab:=TStringList.Create;

  for i := indkes to  Memo2.Lines.Count-1 do
  begin;
    SplitText(',',Memo2.Lines[i],tab);
    if  tab.Count=1 then
    begin
      link:=FindUrl(tab[0],1);
      Memo1.Lines.Add(link);
      end
    else
    begin
    //?e je zaporedna ?tevilka manj?a od 5 nadaljuj
    if StrToIntDef(tab[1],0)<=5 then
      begin
        link:=FindUrl(tab[0],StrToIntDef(tab[1],0));
        //?e se slu?ajno zgodi da je zadetkov manj od izbranje ?tevilke o tem obvestimo uporabnika
        if CompareStr(link,'Ni zadetka s to zaporedno ?tevilko')=0 then
          begin
          Memo1.Lines.Add('Ni zadetka za: '+Memo2.Lines[i]+'. Vnesite ?tevilko manj?o od '+tab[1]);
          indkes:=indkes+1;
          end
        else
         begin
         Memo1.Lines.Add(link);
         indkes:=indkes+1;
         end;
      end
    else
    //?e je zaporedna ?tevilka ve?ja od 5 ne izpi?i ni?
      begin
        indkes:=indkes+1;
      end;
    end;

  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  //Shranimo vsebino v datotekos
  if SaveDialog1.Execute then
    if FileExists(SaveDialog1.FileName) then
      { If it exists, raise an exception. }
      raise Exception.Create('File already exists. Cannot overwrite.')
    else
      { Otherwise, save the memo box lines into the file. }
      Memo1.Lines.SaveToFile(SaveDialog1.FileName);

end;

Function TForm1.FindUrl(name:String;st:Integer):String;

  //Procedura ki sem jo na?el na internetu->https://delphidabbler.github.io/delphi-tips/tips/72.html
   procedure Pause(const ADelay: LongWord);
  var
    StartTC: DWORD;
    CurrentTC: Int64;
  begin
    StartTC := GetTickCount;
    repeat
      Application.ProcessMessages;
      CurrentTC := GetTickCount;
      if CurrentTC < StartTC then
        // tick count has wrapped around: adjust it
        CurrentTC := CurrentTC + High(DWORD);
    until CurrentTC - StartTC >= ADelay;
  end;

var
  indeks:Integer;
  str2  : TStringList;
  str3  : TStringList;
begin;
  WebBrowser1.Navigate('https://www.google.com/search?q='+name);

  //Ustvarimo delay(po?akamo da se stran nalo?i)
  while WebBrowser1.ReadyState <> READYSTATE_COMPLETE do
    Pause(5);

  //Ko se stran nalo?i prebermo podatke
  html:=GetTags();

  //Iz podatkov izluscimo url spletne strani
  strArray:=TStringList.Create;
  SplitText('<div class="g">',html,strArray);

  str2:=TStringList.Create;
  str3:=TStringList.Create;

   if strArray.Count>st then
    begin
      SplitText('<a href=',strArray[st],str2);
      SplitText('"',str2[1],str3);
      Result:=str3[1];
      end
    else
      Result:='Ni zadetka s to zaporedno ?tevilko';
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
Memo1.Clear();
Memo2.Clear();
indkes:=0;
end;

Function  TForm1.GetTags():String;
var
  LStream: TStringStream;
  Stream : IStream;
  LPersistStreamInit : IPersistStreamInit;
  res:String;
begin
  if not Assigned(WebBrowser1.Document) then exit;
  LStream := TStringStream.Create('');
  try
    LPersistStreamInit := WebBrowser1.Document as IPersistStreamInit;
    Stream := TStreamAdapter.Create(LStream,soReference);
    LPersistStreamInit.Save(Stream,true);
    res := LStream.DataString;
  finally
    LStream.Free();
   end;
  Result:=res;
  end;


  procedure TForm1.SplitText(const aDelimiter,s: String; aList: TStringList);
begin
  aList.LineBreak := aDelimiter;
  aList.Text := s;
end;
end.
