object QueenForm: TQueenForm
  Left = 332
  Top = 153
  BorderStyle = bsDialog
  Caption = 
    #1042#1080#1079#1091#1072#1083#1080#1079#1072#1090#1086#1088' '#1088#1072#1089#1089#1090#1072#1085#1086#1074#1082#1080' '#1092#1077#1088#1079#1077#1081' '#1085#1072' '#1096#1072#1093#1084#1072#1090#1085#1086#1081' '#1076#1086#1089#1082#1077'. '#1040#1083#1075#1086#1088#1080#1090#1084' '#1089' '#1074 +
    #1086#1079#1074#1088#1072#1090#1086#1084'.'
  ClientHeight = 677
  ClientWidth = 1103
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  ShowHint = True
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 4
    Top = 512
    Width = 173
    Height = 13
    Caption = #1048#1085#1092#1086#1088#1084#1072#1094#1080#1103' '#1086' '#1074#1099#1087#1086#1083#1085#1077#1085#1080#1080' '#1094#1080#1082#1083#1072
  end
  object Label2: TLabel
    Left = 864
    Top = 152
    Width = 235
    Height = 13
    Alignment = taCenter
    AutoSize = False
    Caption = #1057#1087#1080#1089#1086#1082' '#1085#1072#1081#1076#1077#1085#1085#1099#1093' '#1088#1077#1096#1077#1085#1080#1081
  end
  object VisualBoard: TImage
    Left = 5
    Top = 5
    Width = 503
    Height = 503
  end
  object Label3: TLabel
    Left = 792
    Top = 8
    Width = 121
    Height = 13
    Alignment = taCenter
    AutoSize = False
    Caption = #1056#1072#1079#1084#1077#1088' '#1076#1086#1089#1082#1080
  end
  object LogMemo: TMemo
    Left = 0
    Top = 526
    Width = 1103
    Height = 151
    Align = alBottom
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object Button1: TButton
    Left = 530
    Top = 48
    Width = 241
    Height = 33
    Hint = #1048#1090#1077#1088#1072#1094#1080#1080' '#1073#1091#1076#1091#1090' '#1074#1099#1087#1086#1083#1085#1103#1090#1100#1089#1103' '#1072#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1080', '#1089' '#1080#1085#1090#1077#1088#1074#1072#1083#1086#1084' 150'#1084#1089'.'
    Caption = #1047#1072#1087#1091#1089#1090#1080#1090#1100' '#1072#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1086#1077' '#1074#1099#1087#1086#1083#1085#1077#1085#1080#1077
    ParentShowHint = False
    ShowHint = False
    TabOrder = 1
    WordWrap = True
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 530
    Top = 88
    Width = 241
    Height = 33
    Hint = #1042#1099#1087#1086#1083#1085#1077#1085#1080#1077' '#1086#1076#1085#1086#1081' '#1080#1090#1077#1088#1072#1094#1080#1080
    Caption = #1042#1099#1087#1086#1083#1085#1080#1090#1100' '#1086#1076#1085#1091' '#1080#1090#1077#1088#1072#1094#1080#1102
    ParentShowHint = False
    ShowHint = True
    TabOrder = 2
    WordWrap = True
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 530
    Top = 129
    Width = 241
    Height = 32
    Hint = 
      #1042#1099#1087#1086#1083#1085#1077#1085#1080#1077' '#1074#1089#1077#1075#1086' '#1094#1080#1082#1083#1072' '#1084#1086#1078#1077#1090' '#1079#1072#1085#1103#1090#1100' '#1085#1077#1082#1086#1090#1086#1088#1086#1077' '#1074#1088#1077#1084#1103'.'#13#10#1054#1089#1090#1086#1088#1086#1078#1085#1086'!' +
      ' '#1055#1088#1086#1075#1088#1072#1084#1084#1072' '#1087#1077#1088#1077#1089#1090#1072#1085#1077#1090' '#1088#1077#1072#1075#1080#1088#1086#1074#1072#1090#1100' '#1085#1072#13#10#1076#1077#1081#1089#1090#1074#1080#1103' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1103' '#1076#1086' '#1079 +
      #1072#1074#1077#1088#1096#1077#1085#1080#1103' '#1094#1080#1082#1083#1072'.'
    Caption = #1042#1099#1087#1086#1083#1085#1080#1090#1100' '#1080#1090#1077#1088#1072#1094#1080#1080' '#1076#1086' '#1082#1086#1085#1094#1072
    ParentShowHint = False
    ShowHint = True
    TabOrder = 3
    WordWrap = True
    OnClick = Button3Click
  end
  object ScrollBox: TScrollBox
    Left = 522
    Top = 168
    Width = 336
    Height = 338
    Hint = #1044#1077#1088#1077#1074#1086' '#1087#1086#1080#1089#1082#1072#13#10#1056#1080#1089#1091#1077#1090#1089#1103' '#1090#1086#1083#1100#1082#1086' '#1076#1083#1103' '#1076#1086#1089#1086#1082' '#1088#1072#1079#1084#1077#1088#1086#1084' <= 6'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 4
    object Image: TImage
      Left = 5
      Top = 5
      Width = 271
      Height = 186
    end
  end
  object StopCheckBox: TCheckBox
    Left = 778
    Top = 56
    Width = 167
    Height = 33
    Caption = #1054#1089#1090#1072#1085#1072#1074#1083#1080#1074#1072#1090#1100' '#1094#1080#1082#1083' '#1087#1086#1089#1083#1077' '#1085#1072#1093#1086#1078#1076#1077#1085#1080#1103' '#1088#1077#1096#1077#1085#1080#1103
    Checked = True
    State = cbChecked
    TabOrder = 5
    WordWrap = True
    OnClick = StopCheckBoxClick
  end
  object SolutionsList: TListBox
    Left = 864
    Top = 168
    Width = 235
    Height = 337
    Hint = #1057#1087#1080#1089#1086#1082' '#1085#1072#1081#1076#1077#1085#1085#1099#1093' '#1088#1077#1096#1077#1085#1080#1081'.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ItemHeight = 16
    ParentFont = False
    TabOrder = 6
  end
  object ResetButton: TButton
    Left = 530
    Top = 8
    Width = 241
    Height = 33
    Hint = #1057#1073#1088#1086#1089#1080#1090#1100' '#1074#1099#1087#1086#1083#1085#1077#1085#1080#1077' '#1094#1080#1082#1083#1072' '#1080' '#1086#1095#1080#1089#1090#1080#1090#1100' '#1076#1086#1089#1082#1091'.'
    Caption = #1057#1073#1088#1086#1089' '#1094#1080#1082#1083#1072
    ParentShowHint = False
    ShowHint = True
    TabOrder = 7
    OnClick = ResetButtonClick
  end
  object BoardSizeEdit: TSpinEdit
    Left = 794
    Top = 24
    Width = 121
    Height = 22
    MaxValue = 10
    MinValue = 1
    TabOrder = 8
    Value = 4
    OnChange = BoardSizeEditChange
    OnKeyPress = BoardSizeEditKeyPress
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 50
    OnTimer = Timer1Timer
    Left = 1074
  end
end
