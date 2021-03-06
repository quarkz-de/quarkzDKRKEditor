unit dkrk.Main;

interface

uses
  Winapi.Windows, Winapi.Messages, WinApi.ShlObj, WinApi.ShellApi,
  System.SysUtils, System.Variants, System.Classes, System.Generics.Collections,
  System.Actions, System.ImageList, System.UITypes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.ToolWin, Vcl.ImgList, Vcl.ActnList,
  HTMLUn2, HtmlView,
  dkrk.Cookbook, dkrk.Visualizers, dkrk.Entities, dkrk.DragDropHandler;

type
  TwMain = class(TForm)
    pnRecipeDisplay: TPanel;
    Splitter2: TSplitter;
    pnLeft: TPanel;
    pnCategories: TPanel;
    pnCategoryButtons: TPanel;
    lbCategories: TListBox;
    pnRecipes: TPanel;
    pnRecipeButtons: TPanel;
    lbRecipes: TListBox;
    Splitter1: TSplitter;
    btEditCategory: TButton;
    btDeleteCategory: TButton;
    btAddRecipe: TButton;
    btEditRecipe: TButton;
    btDeleteRecipe: TButton;
    btAddCategory: TButton;
    alActions: TActionList;
    acAddCategory: TAction;
    acEditCategory: TAction;
    acDeleteCategory: TAction;
    acAddRecipe: TAction;
    acEditRecipe: TAction;
    acDeleteRecipe: TAction;
    hvRecipe: THtmlViewer;
    pnRecipe: TPanel;
    pnHeader: TPanel;
    btOpenCookbook: TButton;
    acOpenCookbook: TAction;
    txFilename: TLabel;
    acPrintRecipe: TAction;
    btPrintRecipe: TButton;
    dPrint: TPrintDialog;
    btSaveRecipeAsPDF: TButton;
    acSaveRecipeAsPDF: TAction;
    dPdfExport: TSaveDialog;
    btExport: TButton;
    dCookbookExport: TSaveDialog;
    acExportCookbook: TAction;
    btExportRecipe: TButton;
    acExportRecipe: TAction;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure lbCategoriesClick(Sender: TObject);
    procedure lbRecipesClick(Sender: TObject);
    procedure acAddCategoryExecute(Sender: TObject);
    procedure acEditCategoryExecute(Sender: TObject);
    procedure acDeleteCategoryExecute(Sender: TObject);
    procedure acAddRecipeExecute(Sender: TObject);
    procedure acDeleteRecipeExecute(Sender: TObject);
    procedure acEditRecipeExecute(Sender: TObject);
    procedure lbCategoriesKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure lbRecipesKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure lbCategoriesKeyPress(Sender: TObject; var Key: Char);
    procedure lbRecipesKeyPress(Sender: TObject; var Key: Char);
    procedure acOpenCookbookExecute(Sender: TObject);
    procedure acPrintRecipeExecute(Sender: TObject);
    procedure acSaveRecipeAsPDFExecute(Sender: TObject);
    procedure lbCategoriesDblClick(Sender: TObject);
    procedure lbRecipesDblClick(Sender: TObject);
    procedure acExportCookbookExecute(Sender: TObject);
    procedure acExportRecipeExecute(Sender: TObject);
    procedure hvRecipeKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private-Deklarationen }
    FCategoryVisualizer: ICategoryVisualizer;
    FRecipeListVisualizer: IRecipeListVisualizer;
    FRecipeDisplayVisualizer: IRecipeDisplayVisualizer;
    FCookbook: ICookbook;
    FDragDropHandler: IRecipeCategorieDragDropHandler;
    function GetSelectedCategory: TCategory;
    function IsCategorySelected: Boolean;
    procedure LoadRecipesOfSelectedCategory;
    procedure LoadSelectedRecipe;
    procedure InitCookbook;
    procedure ExportCookbook;
    procedure ExportRecipe;
  public
    { Public-Deklarationen }
  end;

var
  wMain: TwMain;

implementation

{$R *.dfm}

uses
  Spring.Container, Spring.Collections,
  qzLib.Core.HtmlViewerPdfWriter,
  dkrk.Ingredients, dkrk.Renderers, dkrk.CategoryEditor,
  dkrk.RecipeEditor, dkrk.Exporter;

procedure TwMain.acAddCategoryExecute(Sender: TObject);
var
  Category: TCategory;
begin
  Category := TCategory.Create;
  if TwCategoryEditor.ExecuteDialog(Category) then
    begin
      FCookbook.GetSession.Save(Category);
      Category.AssignedCategory := Category.Id;
      FCookbook.GetSession.Save(Category);
      FCategoryVisualizer.Add(Category);
      LoadRecipesOfSelectedCategory;
    end
  else
    Category.Free;
end;

procedure TwMain.acAddRecipeExecute(Sender: TObject);
var
  Recipe: TRecipe;
begin
  if not IsCategorySelected then
    Exit;

  Recipe := TRecipe.Create;
  Recipe.AssignedCategory := GetSelectedCategory.Id;
  Recipe.AddA := GetSelectedCategory.Id.ToString;
  if TwRecipeEditor.ExecuteDialog(Recipe) then
    begin
      FCookbook.GetSession.Save(Recipe);
      FRecipeListVisualizer.Add(Recipe);
      LoadSelectedRecipe;
    end
  else
    Recipe.Free;
end;

procedure TwMain.acDeleteCategoryExecute(Sender: TObject);
var
  Category: TCategory;
  Recipes: IList<TRecipe>;
begin
  if IsCategorySelected then
    begin
      Category := TCategory(lbCategories.Items.Objects[lbCategories.ItemIndex]);
      Recipes := Category.Recipes;
      if Recipes.Count > 0 then
        begin
          MessageDlg('Die Kategorie enth�lt noch Rezepte und kann daher nicht gel�scht werden.', mtWarning, [mbOk], 0);
        end
      else if (MessageDlg('Kategorie wirklich l�schen?', mtConfirmation, [mbYes, mbNo], 0) = mrYes) then
        begin
          FCookbook.GetSession.Delete(Category);
          FCategoryVisualizer.Remove(Category);
        end;
    end;
end;

procedure TwMain.acDeleteRecipeExecute(Sender: TObject);
var
  Recipe: TRecipe;
begin
  if (lbRecipes.ItemIndex > -1) and
    (MessageDlg('Rezept wirklich l�schen?', mtConfirmation, [mbYes, mbNo], 0) = mrYes) then
    begin
      Recipe := TRecipe(lbRecipes.Items.Objects[lbRecipes.ItemIndex]);
      FCookbook.GetSession.Delete(Recipe);
      FRecipeListVisualizer.Remove(Recipe);
    end;
end;

procedure TwMain.acEditCategoryExecute(Sender: TObject);
var
  Category: TCategory;
begin
  if IsCategorySelected then
    begin
      Category := GetSelectedCategory;
      if TwCategoryEditor.ExecuteDialog(Category) then
        begin
          FCookbook.GetSession.Save(Category);
          lbCategories.Invalidate;
        end;
    end;
end;

procedure TwMain.acEditRecipeExecute(Sender: TObject);
var
  Recipe: TRecipe;
begin
  if lbRecipes.ItemIndex > -1 then
    begin
      Recipe := TRecipe(lbRecipes.Items.Objects[lbRecipes.ItemIndex]);
      if TwRecipeEditor.ExecuteDialog(Recipe) then
        begin
          FCookbook.GetSession.Save(Recipe);
          lbRecipes.Invalidate;
          LoadSelectedRecipe;
        end;
    end;
end;

procedure TwMain.acExportCookbookExecute(Sender: TObject);
begin
  ExportCookbook;
end;

procedure TwMain.acExportRecipeExecute(Sender: TObject);
begin
  ExportRecipe;
end;

procedure TwMain.acOpenCookbookExecute(Sender: TObject);
begin
  FCookbook.SelectAndLoad;
  InitCookbook;
end;

procedure TwMain.acPrintRecipeExecute(Sender: TObject);
begin
  if dPrint.Execute then
    hvRecipe.Print();
end;

procedure TwMain.acSaveRecipeAsPDFExecute(Sender: TObject);
var
  Writer: IHtmlViewerPdfWriter;
  Recipe: TRecipe;
  PFilename: PChar;
begin
  if lbRecipes.ItemIndex > -1 then
    begin
      Recipe := TRecipe(lbRecipes.Items.Objects[lbRecipes.ItemIndex]);

      PFilename := PChar(Recipe.Name + '.pdf');
      PathCleanupSpec(nil, PFilename);
      dPdfExport.FileName := StrPas(PFilename);

      if dPdfExport.Execute then
        begin
          Writer := THtmlViewerPdfWriter.Create(hvRecipe);
          Writer.SaveToFile(dPdfExport.FileName);

          ShellExecute(0, 'open', PChar(dPdfExport.FileName), nil, nil, SW_SHOWNORMAL);
        end;
    end;
end;

procedure TwMain.ExportCookbook;
var
  Exporter: ICookbookExporter;
begin
  if dCookbookExport.Execute then
    begin
      Exporter := TRezeFormatExporter.Create;
      Exporter.SaveToFile(FCookbook, dCookbookExport.FileName);
    end;
end;

procedure TwMain.ExportRecipe;
var
  Recipe: TRecipe;
  Exporter: ICookbookExporter;
begin
  if lbRecipes.ItemIndex > -1 then
    begin
      Recipe := TRecipe(lbRecipes.Items.Objects[lbRecipes.ItemIndex]);

      if dCookbookExport.Execute then
        begin
          Exporter := TRezeFormatExporter.Create;
          Exporter.SaveToFile(FCookbook, Recipe, dCookbookExport.FileName);
        end;
    end;
end;

procedure TwMain.FormCreate(Sender: TObject);
begin
  FCategoryVisualizer := GlobalContainer.Resolve<ICategoryVisualizer>;
  FCategoryVisualizer.SetListbox(lbCategories);

  FRecipeListVisualizer := GlobalContainer.Resolve<IRecipeListVisualizer>;
  FRecipeListVisualizer.SetListbox(lbRecipes);

  FRecipeDisplayVisualizer := GlobalContainer.Resolve<IRecipeDisplayVisualizer>;
  FRecipeDisplayVisualizer.SetHtmlViewer(hvRecipe);

  FDragDropHandler := TRecipeCategorieDragDropHandler.Create;
  FDragDropHandler.SetListboxes(lbCategories, lbRecipes);

  FCookbook := GlobalContainer.Resolve<ICookbook>;
{$ifdef DEBUG}
  FCookbook.Load('d:\entw\quarkz.dx\quarkzDKRKEditor\data\kochbuch.db');
  InitCookbook;
{$else}
  acOpenCookbook.Execute;
{$endif}
end;

procedure TwMain.FormDestroy(Sender: TObject);
begin
  FCookbook.Close;
end;

function TwMain.GetSelectedCategory: TCategory;
begin
  if IsCategorySelected then
    Result := TCategory(lbCategories.Items.Objects[lbCategories.ItemIndex])
  else
    Result := nil;
end;

procedure TwMain.hvRecipeKeyDown(Sender: TObject; var Key: Word; Shift:
    TShiftState);
begin
  if ((Key = Ord('C')) and (Shift = [ssCtrl])) or
    ((Key = VK_INSERT) and (Shift = [ssCtrl])) then
    hvRecipe.CopyToClipboard;
end;

procedure TwMain.InitCookbook;
var
  Categories: IList<TCategory>;
begin
  acAddCategory.Enabled := FCookbook.IsLoaded;
  acDeleteCategory.Enabled := FCookbook.IsLoaded;
  acEditCategory.Enabled := FCookbook.IsLoaded;

  acAddRecipe.Enabled := FCookbook.IsLoaded;
  acDeleteRecipe.Enabled := FCookbook.IsLoaded;
  acEditRecipe.Enabled := FCookbook.IsLoaded;

  acPrintRecipe.Enabled := FCookbook.IsLoaded;

  acExportCookbook.Enabled := FCookbook.IsLoaded;


  if FCookbook.IsLoaded then
    begin
      Categories := FCookbook.GetSession.FindAll<TCategory>();
      FCategoryVisualizer.SetCategories(Categories);
      FCategoryVisualizer.RenderContent;
      FRecipeListVisualizer.Clear;
      FRecipeDisplayVisualizer.Clear;
      txFilename.Caption := FCookbook.GetFilename;
    end
  else
    begin
      FRecipeListVisualizer.Clear;
      FCategoryVisualizer.Clear;
      FRecipeDisplayVisualizer.Clear;
      txFilename.Caption := '(kein Kochbuch ge�ffnet)';
    end;
end;

function TwMain.IsCategorySelected: Boolean;
begin
  Result := lbCategories.ItemIndex > -1;
end;

procedure TwMain.lbCategoriesClick(Sender: TObject);
begin
  LoadRecipesOfSelectedCategory;
  LoadSelectedRecipe;
end;

procedure TwMain.lbCategoriesDblClick(Sender: TObject);
begin
  acEditCategory.Execute;
end;

procedure TwMain.lbCategoriesKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_INSERT:
      if Shift = [] then
        begin
          acAddCategory.Execute;
          Key := 0;
        end;
    VK_DELETE:
      if Shift = [] then
        begin
          acDeleteCategory.Execute;
          Key := 0;
        end;
    VK_RETURN:
      if Shift = [] then
        begin
          acEditCategory.Execute;
          Key := 0;
        end;
  end;
end;

procedure TwMain.lbCategoriesKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
    Key := #0;
end;

procedure TwMain.lbRecipesClick(Sender: TObject);
begin
  LoadSelectedRecipe;
end;

procedure TwMain.lbRecipesDblClick(Sender: TObject);
begin
  acEditRecipe.Execute;
end;

procedure TwMain.lbRecipesKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_INSERT:
      if Shift = [] then
        begin
          acAddRecipe.Execute;
          Key := 0;
        end;
    VK_DELETE:
      if Shift = [] then
        begin
          acDeleteRecipe.Execute;
          Key := 0;
        end;
    VK_RETURN:
      if Shift = [] then
        begin
          acEditRecipe.Execute;
          Key := 0;
        end;
  end;
end;

procedure TwMain.lbRecipesKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
    Key := #0;
end;

procedure TwMain.LoadRecipesOfSelectedCategory;
var
  Category: TCategory;
begin
  if IsCategorySelected then
    begin
      Category := GetSelectedCategory;
      FRecipeListVisualizer.SetRecipes(Category.Recipes);
      FRecipeListVisualizer.RenderContent;
    end;
end;

procedure TwMain.LoadSelectedRecipe;
var
  Recipe: TRecipe;
begin
  if lbRecipes.ItemIndex > -1 then
    begin
      Recipe := TRecipe(lbRecipes.Items.Objects[lbRecipes.ItemIndex]);
      FRecipeDisplayVisualizer.SetRecipe(Recipe);
      FRecipeDisplayVisualizer.RenderContent;
    end
  else
    begin
      FRecipeDisplayVisualizer.Clear;
    end;
end;

end.
