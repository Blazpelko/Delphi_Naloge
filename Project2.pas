unit Project2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Xml.xmldom, Xml.XMLIntf, Xml.XMLDoc,
  Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    XMLDocument1: TXMLDocument;
    OpenDialog1: TOpenDialog;
    Button3: TButton;
    procedure Button1Click(Sender: TObject);
    //Declared function
    function  GetChlds(input:IXMLNode;temp:String):String;
    procedure Button3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  out:String;
  I:Integer;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
end;


//Opening with dialog
procedure TForm1.Button3Click(Sender: TObject);
var
  LDocument: IXMLDocument;
  LNodeDocument, LNode: IXMLNode;
  NodeName:String;
  PathName:String;
begin
  //Koda za nalaganje datoteke
  if OpenDialog1.Execute then
    if FileExists(OpenDialog1.FileName) then
      begin
        PathName:=OpenDialog1.FileName;
      end
    else
      raise Exception.Create('File does not exist.');

  //Po?istimo memo
  Memo1.Clear();
  //Preberemo dokument
  LDocument := TXMLDocument.Create(nil);
  LDocument.LoadFromFile(PathName);

  //Node document
  LNodeDocument := LDocument.ChildNodes[1];
  //LNode:=LNodeDocument.ChildNodes.Get(0);

  GetChlds(LNodeDocument,NodeName);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Memo1.Clear();
end;

{Rekurzivna funkcija za izpis}
function TForm1.GetChlds(input:IXMLNode;temp:String):String;
  var
  t:IXMLNode;
  trenutni:Integer;
  begin;
  //?e node nima sinov->izpisemo vsebino
  if(input.IsTextElement) then
    begin
      Memo1.Lines.Add(temp+input.NodeName+': '+input.Text);
    end
  else
    begin;
      //Shranimo ime noda
      temp:=temp+input.NodeName+'-';
      for trenutni := 0 to input.ChildNodes.Count-1 do
          begin
          t:=input.ChildNodes.Get(trenutni);
          GetChlds(t,temp);
        end;
      end
    end;

end.
