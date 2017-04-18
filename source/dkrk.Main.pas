unit dkrk.Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, System.Generics.Collections, System.Actions,
  System.ImageList,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.ToolWin, Vcl.ImgList, Vcl.ActnList,
  HTMLUn2, HtmlView,
  dkrk.Cookbook, dkrk.Visualizers, dkrk.Entities;

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
    ilImages: TImageList;
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
  private
    { Private-Deklarationen }
    FCategoryVisualizer: ICategoryVisualizer;
    FRecipeListVisualizer: IRecipeListVisualizer;
    FRecipeDisplayVisualizer: IRecipeDisplayVisualizer;
    FCookbook: ICookbook;
    function GetSelectedCategory: TCategory;
    function IsCategorySelected: Boolean;
    procedure LoadRecipesOfSelectedCategory;
    procedure LoadSelectedRecipe;
    procedure InitCookbook;
  public
    { Public-Deklarationen }
  end;

var
  wMain: TwMain;

implementation

{$R *.dfm}

uses
  dorm, dorm.Commons, dorm.ObjectStatus,
  Spring.Container,
  dkrk.Ingredients, dkrk.Renderers, dkrk.CategoryEditor,
  dkrk.RecipeEditor;

procedure TwMain.acAddCategoryExecute(Sender: TObject);
var
  Category: TCategory;
begin
  Category := TCategory.Create;
  if TwCategoryEditor.ExecuteDialog(Category) then
    begin
      FCookbook.GetSession.Persist(Category);
      Category.AssignedCategory := Category.Id;
      FCookbook.GetSession.Persist(Category);
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
      FCookbook.GetSession.Persist(Recipe);
      FRecipeListVisualizer.Add(Recipe);
    end
  else
    Recipe.Free;
end;

procedure TwMain.acDeleteCategoryExecute(Sender: TObject);
var
  Category: TCategory;
begin
  if IsCategorySelected and (MessageDlg('Kategorie wirklich löschen?', mtConfirmation, [mbYes, mbNo], 0) = mrYes) then
    begin
      Category := TCategory(lbCategories.Items.Objects[lbCategories.ItemIndex]);
      Category.ObjStatus := osDeleted;
      FCookbook.GetSession.Persist(Category);
      FCategoryVisualizer.Remove(Category);
    end;
end;

procedure TwMain.acDeleteRecipeExecute(Sender: TObject);
begin
  //
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
          FCookbook.GetSession.Persist(Category);
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
          FCookbook.GetSession.Persist(Recipe);
          lbRecipes.Invalidate;
        end;
    end;
end;

procedure TwMain.acOpenCookbookExecute(Sender: TObject);
begin
  FCookbook.SelectAndLoad;
  InitCookbook;
end;

procedure TwMain.FormCreate(Sender: TObject);
begin
  FCategoryVisualizer := GlobalContainer.Resolve<ICategoryVisualizer>;
  FCategoryVisualizer.SetListbox(lbCategories);

  FRecipeListVisualizer := GlobalContainer.Resolve<IRecipeListVisualizer>;
  FRecipeListVisualizer.SetListbox(lbRecipes);

  FRecipeDisplayVisualizer := GlobalContainer.Resolve<IRecipeDisplayVisualizer>;
  FRecipeDisplayVisualizer.SetHtmlViewer(hvRecipe);

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

procedure TwMain.InitCookbook;
begin
  acAddCategory.Enabled := FCookbook.IsLoaded;
  acDeleteCategory.Enabled := FCookbook.IsLoaded;
  acEditCategory.Enabled := FCookbook.IsLoaded;

  acAddRecipe.Enabled := FCookbook.IsLoaded;
  acDeleteRecipe.Enabled := FCookbook.IsLoaded;
  acEditRecipe.Enabled := FCookbook.IsLoaded;

  if FCookbook.IsLoaded then
    begin
      FCategoryVisualizer.SetCategories(FCookbook.GetSession.LoadList<TCategory>);
      FCategoryVisualizer.RenderContent;
      txFilename.Caption := FCookbook.GetFilename;
    end
  else
    begin
      FRecipeListVisualizer.Clear;
      FCategoryVisualizer.Clear;
      FRecipeDisplayVisualizer.Clear;
      txFilename.Caption := '(kein Kochbuch geöffnet)';
    end;
end;

function TwMain.IsCategorySelected: Boolean;
begin
  Result := lbCategories.ItemIndex > -1;
end;

procedure TwMain.lbCategoriesClick(Sender: TObject);
begin
  LoadRecipesOfSelectedCategory;
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
      FCookbook.GetSession.LoadRelations(Category, [drHasMany, drHasOne]);
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
    end;
end;

end.
