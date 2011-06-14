object QueenForm: TQueenForm
  Left = 192
  Top = 225
  Width = 1154
  Height = 725
  Caption = 'QueenForm'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
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
    Top = 96
    Width = 313
    Height = 13
    Alignment = taCenter
    AutoSize = False
    Caption = #1057#1087#1080#1089#1086#1082' '#1085#1072#1081#1076#1077#1085#1085#1099#1093' '#1088#1077#1096#1077#1085#1080#1081
  end
  object VisualBoard: TImage
    Left = 0
    Top = 0
    Width = 465
    Height = 449
  end
  object LogMemo: TMemo
    Left = 0
    Top = 478
    Width = 1146
    Height = 220
    Align = alBottom
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object Button1: TButton
    Left = 488
    Top = 48
    Width = 241
    Height = 33
    Caption = #1047#1072#1087#1091#1089#1090#1080#1090#1100' '#1072#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1086#1077' '#1074#1099#1087#1086#1083#1085#1077#1085#1080#1077
    TabOrder = 1
    WordWrap = True
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 488
    Top = 88
    Width = 241
    Height = 33
    Caption = #1042#1099#1087#1086#1083#1085#1080#1090#1100' '#1086#1076#1085#1091' '#1080#1090#1077#1088#1072#1094#1080#1102
    TabOrder = 2
    WordWrap = True
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 488
    Top = 129
    Width = 241
    Height = 32
    Hint = 
      #1054#1089#1090#1086#1088#1086#1078#1085#1086'! '#1055#1088#1086#1075#1088#1072#1084#1084#1072' '#1087#1077#1088#1077#1089#1090#1072#1085#1077#1090' '#1088#1077#1072#1075#1080#1088#1086#1074#1072#1090#1100' '#1085#1072#13#10#1076#1077#1081#1089#1090#1074#1080#1103' '#1087#1086#1083#1100#1079#1086#1074 +
      #1072#1090#1077#1083#1103' '#1076#1086' '#1079#1072#1074#1077#1088#1096#1077#1085#1080#1103' '#1094#1080#1082#1083#1072'.'
    Caption = #1042#1099#1087#1086#1083#1085#1080#1090#1100' '#1080#1090#1077#1088#1072#1094#1080#1080' '#1076#1086' '#1082#1086#1085#1094#1072
    ParentShowHint = False
    ShowHint = True
    TabOrder = 3
    WordWrap = True
    OnClick = Button3Click
  end
  object ScrollBox: TScrollBox
    Left = 480
    Top = 168
    Width = 302
    Height = 297
    TabOrder = 4
    object Image: TImage
      Left = 5
      Top = 5
      Width = 271
      Height = 186
    end
  end
  object StopCheckBox: TCheckBox
    Left = 736
    Top = 48
    Width = 153
    Height = 33
    Caption = #1054#1089#1090#1072#1085#1072#1074#1083#1080#1074#1072#1090#1100#1089#1103' '#1087#1086#1089#1083#1077' '#1085#1072#1093#1086#1078#1076#1077#1085#1080#1103' '#1088#1077#1096#1077#1085#1080#1103
    Checked = True
    State = cbChecked
    TabOrder = 5
    WordWrap = True
    OnClick = StopCheckBoxClick
  end
  object SolutionsList: TListBox
    Left = 792
    Top = 112
    Width = 313
    Height = 353
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ItemHeight = 16
    ParentFont = False
    TabOrder = 6
  end
  object ResetButton: TButton
    Left = 488
    Top = 8
    Width = 241
    Height = 33
    Caption = #1057#1073#1088#1086#1089' '#1094#1080#1082#1083#1072
    TabOrder = 7
    OnClick = ResetButtonClick
  end
  object BoardSizeEdit: TSpinEdit
    Left = 936
    Top = 16
    Width = 121
    Height = 22
    MaxValue = 10
    MinValue = 1
    TabOrder = 8
    Value = 1
    OnChange = BoardSizeEditChange
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 50
    OnTimer = Timer1Timer
    Left = 736
    Top = 8
  end
end
