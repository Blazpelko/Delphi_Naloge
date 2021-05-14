object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 662
  ClientWidth = 630
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Memo1: TMemo
    Left = 8
    Top = 8
    Width = 497
    Height = 648
    Lines.Strings = (
      'Memo1')
    ScrollBars = ssBoth
    TabOrder = 0
  end
  object Button3: TButton
    Left = 513
    Top = 8
    Width = 112
    Height = 41
    Caption = 'Izberi XML datoteko'
    TabOrder = 1
    OnClick = Button3Click
  end
  object XMLDocument1: TXMLDocument
    Left = 528
    Top = 608
  end
  object OpenDialog1: TOpenDialog
    FileName = 'C:\Users\pelko\Programiranje\Delphi\TestnaNaloga1.xml'
    Left = 576
    Top = 608
  end
end
