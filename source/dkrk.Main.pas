unit dkrk.Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, System.Generics.Collections, System.Actions,
  System.ImageList,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.ToolWin, Vcl.ImgList, Vcl.ActnList,
  HTMLUn2, HtmlView,
  dkrk.Cookbook, dkrk.Visualizers;

type
  TForm1 = class(TForm)
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
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure lbCategoriesClick(Sender: TObject);
    procedure lbRecipesClick(Sender: TObject);
  private
    { Private-Deklarationen }
    FCategoryVisualizer: ICategoryVisualizer;
    FRecipeListVisualizer: IRecipeListVisualizer;
    FRecipeDisplayVisualizer: IRecipeDisplayVisualizer;
    FCookbook: ICookbook;
  public
    { Public-Deklarationen }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses
  dorm, dorm.Commons,
  Spring.Container,
  dkrk.Entities, dkrk.Ingredients, dkrk.Renderers;

procedure TForm1.FormCreate(Sender: TObject);
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
{$else}
  FCookbook.SelectAndLoad;
{$endif}
  if FCookbook.IsLoaded then
    begin
      FCategoryVisualizer.SetCategories(FCookbook.GetSession.LoadList<TCategory>);
      FCategoryVisualizer.RenderContent;
    end;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  FCookbook.Close;
end;

procedure TForm1.lbCategoriesClick(Sender: TObject);
var
  Category: TCategory;
begin
  if lbCategories.ItemIndex > -1 then
    begin
      Category := TCategory(lbCategories.Items.Objects[lbCategories.ItemIndex]);
      FCookbook.GetSession.LoadRelations(Category, [drHasMany, drHasOne]);

      FRecipeListVisualizer.SetRecipes(Category.Recipes);
      FRecipeListVisualizer.RenderContent;
    end;
end;

procedure TForm1.lbRecipesClick(Sender: TObject);
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
