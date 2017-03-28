object wRecipeEditor: TwRecipeEditor
  Left = 0
  Top = 0
  Caption = 'Rezept'
  ClientHeight = 650
  ClientWidth = 840
  Color = clWhite
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Segoe UI'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  DesignSize = (
    840
    650)
  PixelsPerInch = 96
  TextHeight = 17
  object txBezeichnung: TLabel
    Left = 16
    Top = 16
    Width = 75
    Height = 17
    Caption = 'Rezeptname:'
  end
  object txPortionen: TLabel
    Left = 16
    Top = 52
    Width = 66
    Height = 17
    Caption = 'Zutaten f'#252'r:'
  end
  object txPreparation: TLabel
    Left = 16
    Top = 308
    Width = 73
    Height = 17
    Caption = 'Zubereitung:'
  end
  object btCancel: TButton
    Left = 716
    Top = 599
    Width = 105
    Height = 37
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Abbrechen'
    ModalResult = 2
    TabOrder = 4
    ExplicitLeft = 511
    ExplicitTop = 248
  end
  object btOk: TButton
    Left = 605
    Top = 599
    Width = 105
    Height = 37
    Anchors = [akRight, akBottom]
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 3
    ExplicitLeft = 400
    ExplicitTop = 248
  end
  object edBezeichnung: TEdit
    Left = 164
    Top = 13
    Width = 321
    Height = 25
    TabOrder = 0
  end
  object cbPortionen: TComboBox
    Left = 232
    Top = 49
    Width = 145
    Height = 25
    TabOrder = 2
    Text = 'Personen'
    Items.Strings = (
      'Personen'
      'Portionen'
      'St'#252'ck')
  end
  object edPortionen: TEdit
    Left = 164
    Top = 49
    Width = 57
    Height = 25
    NumbersOnly = True
    TabOrder = 1
    Text = '4'
  end
  object stIngredients: TVirtualStringTree
    Left = 164
    Top = 88
    Width = 657
    Height = 201
    Header.AutoSizeIndex = 2
    Header.Height = 21
    Header.Options = [hoColumnResize, hoDrag, hoShowSortGlyphs, hoVisible]
    Header.ParentFont = True
    TabOrder = 5
    TreeOptions.PaintOptions = [toShowButtons, toShowDropmark, toShowTreeLines, toThemeAware, toUseBlendedImages]
    TreeOptions.SelectionOptions = [toFullRowSelect]
    Columns = <
      item
        Position = 0
        Width = 70
        WideText = 'Menge'
      end
      item
        Position = 1
        Width = 100
        WideText = 'Einheit'
      end
      item
        Position = 2
        Width = 300
        WideText = 'Zutat'
      end>
  end
  object edPreparation: TMemo
    Left = 164
    Top = 305
    Width = 657
    Height = 204
    ScrollBars = ssVertical
    TabOrder = 6
  end
end
