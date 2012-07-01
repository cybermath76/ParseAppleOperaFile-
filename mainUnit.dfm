object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Opera Mini B-J Parser'
  ClientHeight = 704
  ClientWidth = 812
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = mm1
  OldCreateOrder = False
  OnDestroy = FormDestroy
  PixelsPerInch = 120
  TextHeight = 16
  object btn1: TButton
    Left = 384
    Top = 656
    Width = 75
    Height = 25
    Caption = 'Parse'
    TabOrder = 0
    OnClick = btn1Click
  end
  object grp1: TGroupBox
    Left = 8
    Top = 8
    Width = 329
    Height = 617
    Caption = #1044#1077#1088#1077#1074#1086' '#1079#1072#1082#1083#1072#1076#1086#1082
    TabOrder = 1
    object lbl1: TLabel
      Left = 10
      Top = 471
      Width = 16
      Height = 18
      Caption = 'ID'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object lbl2: TLabel
      Left = 10
      Top = 545
      Width = 26
      Height = 18
      Caption = 'URL'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object tv1: TTreeView
      Left = 10
      Top = 24
      Width = 303
      Height = 425
      Indent = 19
      TabOrder = 0
      OnChanging = tv1Changing
    end
    object edt1: TEdit
      Left = 10
      Top = 493
      Width = 303
      Height = 24
      TabOrder = 1
    end
    object edt2: TEdit
      Left = 10
      Top = 569
      Width = 303
      Height = 24
      TabOrder = 2
    end
  end
  object grp2: TGroupBox
    Left = 368
    Top = 8
    Width = 433
    Height = 617
    Caption = #1046#1091#1088#1085#1072#1083
    TabOrder = 2
    object mmo1: TMemo
      Left = 16
      Top = 24
      Width = 409
      Height = 569
      ScrollBars = ssBoth
      TabOrder = 0
    end
  end
  object mm1: TMainMenu
    Left = 632
    Top = 65528
    object File1: TMenuItem
      Caption = 'File'
      object Open1: TMenuItem
        Caption = 'Open'
        OnClick = Open1Click
      end
      object Save1: TMenuItem
        Caption = 'Save'
        Enabled = False
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Exit1: TMenuItem
        Caption = 'Exit'
        OnClick = Exit1Click
      end
    end
    object Operations1: TMenuItem
      Caption = 'Operations'
      object Multiload1: TMenuItem
        Caption = 'Multi load'
        OnClick = Multiload1Click
      end
      object Multisave1: TMenuItem
        Caption = 'Multi save'
        Enabled = False
      end
    end
    object About1: TMenuItem
      Caption = 'About'
    end
  end
  object dlgOpen1: TOpenDialog
    InitialDir = './'
    Options = [ofHideReadOnly, ofAllowMultiSelect, ofEnableSizing]
    Left = 696
  end
end
