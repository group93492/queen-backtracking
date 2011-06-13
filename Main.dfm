object QueenForm: TQueenForm
  Left = 192
  Top = 225
  Width = 1181
  Height = 722
  Caption = 'QueenForm'
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
    Left = 792
    Top = 64
    Width = 353
    Height = 13
    Alignment = taCenter
    AutoSize = False
    Caption = #1057#1087#1080#1089#1086#1082' '#1085#1072#1081#1076#1077#1085#1085#1099#1093' '#1088#1077#1096#1077#1085#1080#1081
  end
  object LogMemo: TMemo
    Left = 0
    Top = 478
    Width = 1156
    Height = 220
    Align = alBottom
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object Button1: TButton
    Left = 528
    Top = 64
    Width = 177
    Height = 49
    Caption = #1079#1072#1087#1091#1089#1090#1080#1090#1100' '#1074#1099#1087#1086#1083#1085#1077#1085#1080#1077' '#1080#1090#1077#1088#1072#1094#1080#1081'  '#1087#1086' '#1090#1072#1081#1084#1077#1088#1091
    TabOrder = 1
    WordWrap = True
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 560
    Top = 120
    Width = 113
    Height = 49
    Caption = #1074#1099#1087#1086#1083#1085#1080#1090#1100' '#1086#1076#1085#1091' '#1080#1090#1077#1088#1072#1094#1080#1102
    TabOrder = 2
    WordWrap = True
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 552
    Top = 177
    Width = 123
    Height = 56
    Caption = #1074#1099#1087#1086#1083#1085#1080#1090#1100' '#1080#1090#1077#1088#1072#1094#1080#1080' '#1076#1086' '#1089#1072#1084#1086#1075#1086' '#1082#1086#1085#1094#1072
    TabOrder = 3
    WordWrap = True
    OnClick = Button3Click
  end
  object BoardPanel: TPanel
    Left = 0
    Top = 0
    Width = 465
    Height = 465
    TabOrder = 4
  end
  object ScrollBox: TScrollBox
    Left = 496
    Top = 264
    Width = 286
    Height = 201
    TabOrder = 5
    object Image: TImage
      Left = 5
      Top = 5
      Width = 271
      Height = 186
    end
  end
  object StopCheckBox: TCheckBox
    Left = 752
    Top = 16
    Width = 153
    Height = 33
    Caption = #1054#1089#1090#1072#1085#1072#1074#1083#1080#1074#1072#1090#1100#1089#1103' '#1087#1086#1089#1083#1077' '#1085#1072#1093#1086#1078#1076#1077#1085#1080#1103' '#1088#1077#1096#1077#1085#1080#1103
    Checked = True
    State = cbChecked
    TabOrder = 6
    WordWrap = True
    OnClick = StopCheckBoxClick
  end
  object SolutionsList: TListBox
    Left = 792
    Top = 80
    Width = 353
    Height = 393
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ItemHeight = 16
    ParentFont = False
    TabOrder = 7
  end
  object ResetButton: TButton
    Left = 544
    Top = 8
    Width = 145
    Height = 41
    Caption = #1089#1073#1088#1086#1089#1080#1090#1100' '#1094#1080#1082#1083
    TabOrder = 8
    OnClick = ResetButtonClick
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 50
    OnTimer = Timer1Timer
    Left = 712
    Top = 80
  end
end
