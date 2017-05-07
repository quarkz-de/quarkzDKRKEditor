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
    Top = 368
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
    TabOrder = 13
  end
  object btOk: TButton
    Left = 605
    Top = 599
    Width = 105
    Height = 37
    Anchors = [akRight, akBottom]
    Caption = 'Ok'
    ModalResult = 1
    TabOrder = 12
  end
  object edBezeichnung: TEdit
    Left = 164
    Top = 13
    Width = 657
    Height = 25
    Anchors = [akLeft, akTop, akRight]
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
    TabOrder = 3
    TreeOptions.AutoOptions = [toAutoDropExpand, toAutoScrollOnExpand, toAutoSort, toAutoTristateTracking, toAutoChangeScale]
    TreeOptions.PaintOptions = [toShowButtons, toShowDropmark, toShowTreeLines, toThemeAware, toUseBlendedImages]
    TreeOptions.SelectionOptions = [toFullRowSelect]
    OnChange = stIngredientsChange
    OnDragAllowed = stIngredientsDragAllowed
    OnDragOver = stIngredientsDragOver
    OnDragDrop = stIngredientsDragDrop
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
    Top = 365
    Width = 657
    Height = 204
    Anchors = [akLeft, akTop, akRight, akBottom]
    ScrollBars = ssVertical
    TabOrder = 11
  end
  object edQuantity: TEdit
    Left = 164
    Top = 295
    Width = 62
    Height = 25
    TabOrder = 4
    OnKeyDown = edQuantityKeyDown
  end
  object cbMeasure: TComboBox
    Left = 232
    Top = 295
    Width = 106
    Height = 25
    TabOrder = 5
    OnKeyDown = cbMeasureKeyDown
  end
  object btAdd: TButton
    Left = 584
    Top = 295
    Width = 75
    Height = 25
    Action = acAdd
    Anchors = [akTop, akRight]
    TabOrder = 8
  end
  object btChange: TButton
    Left = 665
    Top = 295
    Width = 75
    Height = 25
    Action = acEdit
    Anchors = [akTop, akRight]
    TabOrder = 9
  end
  object btDelete: TButton
    Left = 746
    Top = 295
    Width = 75
    Height = 25
    Action = acDelete
    Anchors = [akTop, akRight]
    TabOrder = 10
  end
  object cbIngredient: TComboBox
    Left = 344
    Top = 295
    Width = 234
    Height = 25
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 6
    OnKeyDown = cbIngredientKeyDown
  end
  object cbTitle: TCheckBox
    Left = 164
    Top = 326
    Width = 170
    Height = 17
    Caption = 'Zwischen'#252'berschrift'
    TabOrder = 7
    OnClick = cbTitleClick
    OnKeyDown = cbTitleKeyDown
  end
  object ActionList1: TActionList
    Left = 36
    Top = 173
    object acAdd: TAction
      Caption = 'Hinzuf'#252'gen'
      OnExecute = acAddExecute
    end
    object acEdit: TAction
      Caption = #196'ndern'
      OnExecute = acEditExecute
    end
    object acDelete: TAction
      Caption = 'L'#246'schen'
      OnExecute = acDeleteExecute
    end
  end
end
