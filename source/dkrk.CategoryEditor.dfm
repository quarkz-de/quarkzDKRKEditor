object wCategoryEditor: TwCategoryEditor
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Kategorie'
  ClientHeight = 198
  ClientWidth = 451
  Color = clWhite
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Segoe UI'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 17
  object txBezeichnung: TLabel
    Left = 21
    Top = 44
    Width = 75
    Height = 17
    Caption = 'Bezeichnung:'
  end
  object edBezeichnung: TEdit
    Left = 133
    Top = 41
    Width = 300
    Height = 25
    TabOrder = 0
  end
  object btOk: TButton
    Left = 212
    Top = 136
    Width = 105
    Height = 37
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object btCancel: TButton
    Left = 323
    Top = 136
    Width = 105
    Height = 37
    Cancel = True
    Caption = 'Abbrechen'
    ModalResult = 2
    TabOrder = 2
  end
end
