object Form1: TForm1
  Left = 196
  Top = 146
  Width = 1181
  Height = 722
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 4
    Top = 465
    Width = 19
    Height = 13
    Caption = #1051#1086#1075
  end
  object Label2: TLabel
    Left = 104
    Top = 288
    Width = 160
    Height = 52
    Caption = 
      #1055#1086#1083#1077':'#13#10'  "Q" - '#1092#1077#1088#1079#1100#13#10'  "_" - '#1087#1091#1089#1090#1072#1103' '#1082#1083#1077#1090#1082#1072#13#10'  "*" - '#1082#1083#1077#1090#1082#1072' '#1087#1086#1076' ' +
      #1091#1076#1072#1088#1086#1084' '#1092#1077#1088#1079#1103
  end
  object LogMemo: TMemo
    Left = 0
    Top = 481
    Width = 1156
    Height = 220
    Align = alBottom
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object BoardGrid: TStringGrid
    Left = 64
    Top = 24
    Width = 257
    Height = 257
    BorderStyle = bsNone
    ColCount = 8
    DefaultColWidth = 30
    DefaultRowHeight = 30
    FixedCols = 0
    RowCount = 8
    FixedRows = 0
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
  end
  object Button1: TButton
    Left = 352
    Top = 32
    Width = 177
    Height = 49
    Caption = #1079#1072#1087#1091#1089#1090#1080#1090#1100' '#1074#1099#1087#1086#1083#1085#1077#1085#1080#1077' '#1080#1090#1077#1088#1072#1094#1080#1081'  '#1087#1086' '#1090#1072#1081#1084#1077#1088#1091
    TabOrder = 2
    WordWrap = True
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 384
    Top = 88
    Width = 113
    Height = 49
    Caption = #1074#1099#1087#1086#1083#1085#1080#1090#1100' '#1086#1076#1085#1091' '#1080#1090#1077#1088#1072#1094#1080#1102
    TabOrder = 3
    WordWrap = True
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 376
    Top = 145
    Width = 123
    Height = 71
    Caption = #1074#1099#1087#1086#1083#1085#1080#1090#1100' '#1080#1090#1077#1088#1072#1094#1080#1080' '#1076#1086' '#1089#1072#1084#1086#1075#1086' '#1082#1086#1085#1094#1072
    TabOrder = 4
    WordWrap = True
    OnClick = Button3Click
  end
  object BoardPanel: TPanel
    Left = 552
    Top = 16
    Width = 465
    Height = 465
    TabOrder = 5
  end
  object Button4: TButton
    Left = 55
    Top = 400
    Width = 75
    Height = 25
    Caption = 'Button4'
    TabOrder = 6
  end
  object ScrollBox1: TScrollBox
    Left = 285
    Top = 300
    Width = 241
    Height = 141
    TabOrder = 7
    object Image: TImage
      Left = 2
      Top = 0
      Width = 199
      Height = 106
    end
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 100
    OnTimer = Timer1Timer
    Left = 512
    Top = 104
  end
end
