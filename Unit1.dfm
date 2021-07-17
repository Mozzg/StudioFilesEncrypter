object Form1: TForm1
  Left = 290
  Top = 115
  BorderStyle = bsSingle
  Caption = 'Encrypter'
  ClientHeight = 469
  ClientWidth = 625
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 264
    Top = 56
    Width = 97
    Height = 25
    Caption = 'Select directory'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Edit1: TEdit
    Left = 8
    Top = 24
    Width = 609
    Height = 21
    Enabled = False
    TabOrder = 1
  end
  object Button2: TButton
    Left = 152
    Top = 88
    Width = 153
    Height = 49
    Caption = 'Encrypt all'
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    OnClick = Button2Click
  end
  object Memo1: TMemo
    Left = 8
    Top = 144
    Width = 609
    Height = 313
    ScrollBars = ssBoth
    TabOrder = 3
  end
  object Memo2: TMemo
    Left = 480
    Top = 8
    Width = 129
    Height = 65
    TabOrder = 4
    Visible = False
  end
  object Button3: TButton
    Left = 320
    Top = 88
    Width = 153
    Height = 49
    Caption = 'Encrypt many'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 5
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 536
    Top = 112
    Width = 75
    Height = 25
    Caption = 'Save'
    TabOrder = 6
    Visible = False
    OnClick = Button4Click
  end
  object DCP_rijndael1: TDCP_rijndael
    Id = 9
    Algorithm = 'Rijndael'
    MaxKeySize = 256
    BlockSize = 128
    Left = 8
    Top = 65528
  end
  object DCP_sha5121: TDCP_sha512
    Id = 30
    Algorithm = 'SHA512'
    HashSize = 512
    Left = 40
    Top = 65528
  end
  object OpenDialog1: TOpenDialog
    Filter = 'All Files (*.*)|*.*'
    Left = 24
    Top = 48
  end
end
