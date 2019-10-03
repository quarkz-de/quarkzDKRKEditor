object wMain: TwMain
  Left = 0
  Top = 0
  Caption = 'quarkzDKRKEditor - Der Editor f'#252'r "Das kleine rote Kochbuch"'
  ClientHeight = 584
  ClientWidth = 973
  Color = clWhite
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Segoe UI'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 21
  object Splitter2: TSplitter
    Left = 393
    Top = 45
    Height = 539
    ExplicitLeft = 496
    ExplicitTop = 264
    ExplicitHeight = 100
  end
  object pnRecipeDisplay: TPanel
    Left = 396
    Top = 45
    Width = 577
    Height = 539
    Align = alClient
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 1
    object hvRecipe: THtmlViewer
      AlignWithMargins = True
      Left = 4
      Top = 8
      Width = 565
      Height = 482
      Margins.Left = 4
      Margins.Top = 8
      Margins.Right = 8
      Margins.Bottom = 8
      BorderStyle = htSingle
      DefBackground = clWhite
      DefFontName = 'Segoe UI'
      HistoryMaxCount = 0
      NoSelect = False
      PrintMarginBottom = 2.000000000000000000
      PrintMarginLeft = 2.000000000000000000
      PrintMarginRight = 2.000000000000000000
      PrintMarginTop = 2.000000000000000000
      PrintScale = 1.000000000000000000
      Align = alClient
      TabOrder = 0
      Touch.InteractiveGestures = [igPan]
      Touch.InteractiveGestureOptions = [igoPanSingleFingerHorizontal, igoPanSingleFingerVertical, igoPanInertia]
    end
    object pnRecipe: TPanel
      Left = 0
      Top = 498
      Width = 577
      Height = 41
      Align = alBottom
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 1
      object btPrintRecipe: TButton
        Left = 6
        Top = 0
        Width = 111
        Height = 33
        Action = acPrintRecipe
        Images = dmGlobal.ilImages
        TabOrder = 0
        TabStop = False
      end
      object btSaveRecipeAsPDF: TButton
        Left = 123
        Top = 0
        Width = 111
        Height = 33
        Action = acSaveRecipeAsPDF
        Images = dmGlobal.ilImages
        TabOrder = 1
        TabStop = False
      end
    end
  end
  object pnLeft: TPanel
    Left = 0
    Top = 45
    Width = 393
    Height = 539
    Align = alLeft
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 0
    object Splitter1: TSplitter
      Left = 185
      Top = 0
      Height = 539
      ExplicitLeft = 8
      ExplicitHeight = 584
    end
    object pnCategories: TPanel
      Left = 0
      Top = 0
      Width = 185
      Height = 539
      Align = alLeft
      BevelOuter = bvNone
      Constraints.MinWidth = 180
      ParentColor = True
      TabOrder = 0
      object pnCategoryButtons: TPanel
        Left = 0
        Top = 498
        Width = 185
        Height = 41
        Align = alBottom
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 1
        object btEditCategory: TButton
          Left = 63
          Top = 0
          Width = 49
          Height = 33
          Action = acEditCategory
          ImageAlignment = iaCenter
          Images = dmGlobal.ilImages
          TabOrder = 1
          TabStop = False
        end
        object btDeleteCategory: TButton
          Left = 118
          Top = 0
          Width = 49
          Height = 33
          Action = acDeleteCategory
          ImageAlignment = iaCenter
          Images = dmGlobal.ilImages
          TabOrder = 2
          TabStop = False
        end
        object btAddCategory: TButton
          Left = 8
          Top = 0
          Width = 49
          Height = 33
          Action = acAddCategory
          ImageAlignment = iaCenter
          Images = dmGlobal.ilImages
          TabOrder = 0
          TabStop = False
        end
      end
      object lbCategories: TListBox
        AlignWithMargins = True
        Left = 8
        Top = 8
        Width = 173
        Height = 482
        Margins.Left = 8
        Margins.Top = 8
        Margins.Right = 4
        Margins.Bottom = 8
        AutoComplete = False
        Align = alClient
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -19
        Font.Name = 'Segoe UI'
        Font.Style = []
        ItemHeight = 25
        ParentFont = False
        TabOrder = 0
        OnClick = lbCategoriesClick
        OnDblClick = lbCategoriesDblClick
        OnKeyDown = lbCategoriesKeyDown
        OnKeyPress = lbCategoriesKeyPress
      end
    end
    object pnRecipes: TPanel
      Left = 188
      Top = 0
      Width = 205
      Height = 539
      Align = alClient
      BevelOuter = bvNone
      Constraints.MinWidth = 180
      ParentColor = True
      TabOrder = 1
      object pnRecipeButtons: TPanel
        Left = 0
        Top = 498
        Width = 205
        Height = 41
        Align = alBottom
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 1
        object btAddRecipe: TButton
          Left = 3
          Top = 0
          Width = 49
          Height = 33
          Action = acAddRecipe
          ImageAlignment = iaCenter
          Images = dmGlobal.ilImages
          TabOrder = 0
          TabStop = False
        end
        object btEditRecipe: TButton
          Left = 58
          Top = 0
          Width = 49
          Height = 33
          Action = acEditRecipe
          ImageAlignment = iaCenter
          Images = dmGlobal.ilImages
          TabOrder = 1
          TabStop = False
        end
        object btDeleteRecipe: TButton
          Left = 113
          Top = 0
          Width = 49
          Height = 33
          Action = acDeleteRecipe
          ImageAlignment = iaCenter
          Images = dmGlobal.ilImages
          TabOrder = 2
          TabStop = False
        end
      end
      object lbRecipes: TListBox
        AlignWithMargins = True
        Left = 4
        Top = 8
        Width = 197
        Height = 482
        Margins.Left = 4
        Margins.Top = 8
        Margins.Right = 4
        Margins.Bottom = 8
        AutoComplete = False
        Align = alClient
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -19
        Font.Name = 'Segoe UI'
        Font.Style = []
        ItemHeight = 25
        ParentFont = False
        TabOrder = 0
        OnClick = lbRecipesClick
        OnDblClick = lbRecipesDblClick
        OnKeyDown = lbRecipesKeyDown
        OnKeyPress = lbRecipesKeyPress
      end
    end
  end
  object pnHeader: TPanel
    Left = 0
    Top = 0
    Width = 973
    Height = 45
    Align = alTop
    ParentColor = True
    TabOrder = 2
    DesignSize = (
      973
      45)
    object txFilename: TLabel
      Left = 192
      Top = 10
      Width = 75
      Height = 21
      Caption = 'txFilename'
    end
    object btOpenCookbook: TButton
      Left = 8
      Top = 5
      Width = 173
      Height = 33
      Action = acOpenCookbook
      Images = dmGlobal.ilImages
      TabOrder = 0
      TabStop = False
    end
    object btExport: TButton
      Left = 792
      Top = 6
      Width = 173
      Height = 33
      Action = acExportCookbook
      Anchors = [akTop, akRight]
      Images = dmGlobal.ilImages
      TabOrder = 1
      TabStop = False
    end
  end
  object alActions: TActionList
    Images = dmGlobal.ilImages
    Left = 520
    Top = 296
    object acAddCategory: TAction
      Category = 'Category'
      ImageIndex = 0
      OnExecute = acAddCategoryExecute
    end
    object acEditCategory: TAction
      Category = 'Category'
      ImageIndex = 1
      OnExecute = acEditCategoryExecute
    end
    object acDeleteCategory: TAction
      Category = 'Category'
      ImageIndex = 2
      OnExecute = acDeleteCategoryExecute
    end
    object acAddRecipe: TAction
      Category = 'Recipe'
      ImageIndex = 0
      OnExecute = acAddRecipeExecute
    end
    object acEditRecipe: TAction
      Category = 'Recipe'
      ImageIndex = 1
      OnExecute = acEditRecipeExecute
    end
    object acDeleteRecipe: TAction
      Category = 'Recipe'
      ImageIndex = 2
      OnExecute = acDeleteRecipeExecute
    end
    object acOpenCookbook: TAction
      Category = 'File'
      Caption = 'Kochbuch '#246'ffnen'
      ImageIndex = 5
      OnExecute = acOpenCookbookExecute
    end
    object acPrintRecipe: TAction
      Category = 'Recipe'
      Caption = 'Drucken'
      ImageIndex = 3
      OnExecute = acPrintRecipeExecute
    end
    object acSaveRecipeAsPDF: TAction
      Category = 'Recipe'
      Caption = 'Speichern'
      ImageIndex = 4
      OnExecute = acSaveRecipeAsPDFExecute
    end
    object acExportCookbook: TAction
      Category = 'File'
      Caption = 'Kochbuch exportieren'
      OnExecute = acExportCookbookExecute
    end
  end
  object dPrint: TPrintDialog
    Left = 572
    Top = 296
  end
  object dPdfExport: TSaveDialog
    DefaultExt = 'pdf'
    Filter = 'Portable Document Format (*.pdf)|*.pdf'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofEnableSizing]
    Title = 'Rezept als PDF speichern'
    Left = 616
    Top = 296
  end
  object dCookbookExport: TSaveDialog
    DefaultExt = 'reze'
    Filter = 'Kochbuch-Exportdatei (*.reze;*.rez)|*.reze;*.rez'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofEnableSizing]
    Title = 'Kochbuch exportieren'
    Left = 696
    Top = 293
  end
end
