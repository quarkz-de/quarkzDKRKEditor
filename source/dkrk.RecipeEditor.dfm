object wRecipeEditor: TwRecipeEditor
  Left = 0
  Top = 0
  Caption = 'Rezept'
  ClientHeight = 650
  ClientWidth = 840
  Color = clWhite
  Constraints.MinHeight = 600
  Constraints.MinWidth = 800
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
  object txSource: TLabel
    Left = 16
    Top = 565
    Width = 40
    Height = 17
    Anchors = [akLeft, akBottom]
    Caption = 'Quelle:'
  end
  object txDiffRating: TLabel
    Left = 16
    Top = 519
    Width = 78
    Height = 17
    Anchors = [akLeft, akBottom]
    Caption = 'Schwierigkeit:'
  end
  object txRating: TLabel
    Left = 469
    Top = 519
    Width = 64
    Height = 17
    Anchors = [akRight, akBottom]
    Caption = 'Bewertung:'
  end
  object txPrepDuration: TLabel
    Left = 627
    Top = 52
    Width = 113
    Height = 17
    Anchors = [akTop, akRight]
    Caption = 'Zubereitungsdauer:'
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
    TabOrder = 17
  end
  object btOk: TButton
    Left = 605
    Top = 599
    Width = 105
    Height = 37
    Anchors = [akRight, akBottom]
    Caption = 'Ok'
    ModalResult = 1
    TabOrder = 16
  end
  object edBezeichnung: TEdit
    Left = 124
    Top = 13
    Width = 697
    Height = 25
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 0
  end
  object cbPortionen: TComboBox
    Left = 193
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
    Left = 125
    Top = 49
    Width = 57
    Height = 25
    NumbersOnly = True
    TabOrder = 1
    Text = '4'
  end
  object stIngredients: TVirtualStringTree
    Left = 124
    Top = 88
    Width = 697
    Height = 201
    Anchors = [akLeft, akTop, akRight]
    Header.AutoSizeIndex = 2
    Header.Height = 21
    Header.Options = [hoColumnResize, hoDrag, hoShowSortGlyphs, hoVisible]
    Header.ParentFont = True
    TabOrder = 4
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
    Left = 124
    Top = 365
    Width = 697
    Height = 128
    Anchors = [akLeft, akTop, akRight, akBottom]
    ScrollBars = ssVertical
    TabOrder = 12
  end
  object edQuantity: TEdit
    Left = 124
    Top = 295
    Width = 62
    Height = 25
    TabOrder = 5
    OnKeyDown = edQuantityKeyDown
  end
  object cbMeasure: TComboBox
    Left = 192
    Top = 295
    Width = 106
    Height = 25
    TabOrder = 6
    OnKeyDown = cbMeasureKeyDown
  end
  object btAdd: TButton
    Left = 584
    Top = 295
    Width = 75
    Height = 25
    Action = acAdd
    Anchors = [akTop, akRight]
    TabOrder = 9
  end
  object btChange: TButton
    Left = 665
    Top = 295
    Width = 75
    Height = 25
    Action = acEdit
    Anchors = [akTop, akRight]
    TabOrder = 10
  end
  object btDelete: TButton
    Left = 746
    Top = 295
    Width = 75
    Height = 25
    Action = acDelete
    Anchors = [akTop, akRight]
    TabOrder = 11
  end
  object cbIngredient: TComboBox
    Left = 304
    Top = 295
    Width = 274
    Height = 25
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 7
    OnKeyDown = cbIngredientKeyDown
  end
  object cbTitle: TCheckBox
    Left = 124
    Top = 326
    Width = 170
    Height = 17
    Caption = 'Zwischen'#252'berschrift'
    TabOrder = 8
    OnClick = cbTitleClick
    OnKeyDown = cbTitleKeyDown
  end
  object tbDiffRating: TTrackBar
    Left = 125
    Top = 511
    Width = 244
    Height = 45
    Anchors = [akLeft, akBottom]
    Max = 8
    TabOrder = 13
  end
  object tbRating: TTrackBar
    Left = 577
    Top = 511
    Width = 244
    Height = 45
    Anchors = [akRight, akBottom]
    Max = 8
    TabOrder = 14
  end
  object edSource: TEdit
    Left = 125
    Top = 562
    Width = 696
    Height = 25
    Anchors = [akLeft, akRight, akBottom]
    TabOrder = 15
  end
  object edPrepDuration: TEdit
    Left = 764
    Top = 49
    Width = 57
    Height = 25
    Anchors = [akTop, akRight]
    NumbersOnly = True
    TabOrder = 3
    Text = '0'
  end
  object alActions: TActionList
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
