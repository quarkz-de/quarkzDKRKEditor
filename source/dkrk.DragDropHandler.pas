unit dkrk.DragDropHandler;

interface

uses
  System.SysUtils, System.Classes, System.Types, Vcl.StdCtrls, Vcl.Controls,
  dkrk.Entities;

type
  IRecipeCategorieDragDropHandler = interface
    ['{D690A1DE-E300-4EB5-A767-B737CA387E6B}']
    procedure SetListboxes(const ACategories, ARecipes: TListbox);
  end;

  TRecipeCategorieDragDropHandler = class(TInterfacedObject,
    IRecipeCategorieDragDropHandler)
  private
    FCategoryListbox: TListbox;
    FRecipeListbox: TListbox;
    FSourceCategory: TCategory;
    FSourceIndex: Integer;
    procedure CategoryDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure CategoryDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure RecipeEndDrag(Sender, Target: TObject; X, Y: Integer);
    procedure RecipeStartDrag(Sender: TObject; var DragObject: TDragObject);
  public
    procedure SetListboxes(const ACategories, ARecipes: TListbox);
  end;

implementation

uses
  Spring.Container, Spring.Collections, Spring,
  dkrk.Cookbook;

{$REGION 'TRecipeCategorieDragDropHandler'}

procedure TRecipeCategorieDragDropHandler.CategoryDragDrop(Sender,
  Source: TObject; X, Y: Integer);
var
  Cookbook: ICookbook;
  Recipe: TRecipe;
  Category: TCategory;
  SourceList, DestinationList: ICollection<TRecipe>;
  Predicate: Spring.TPredicate<TRecipe>;
begin
  Recipe := TRecipe(FRecipeListbox.Items.Objects[FRecipeListbox.ItemIndex]);
  Category := TCategory(FCategoryListbox.Items.Objects[FCategoryListbox.ItemIndex]);

  if Recipe.AssignedCategory <> Category.Id then
    begin
      Cookbook := GlobalContainer.Resolve<ICookbook>;

      SourceList := FSourceCategory.Recipes;
      DestinationList := Category.Recipes;

      Predicate := function(const ARecipe: TRecipe): Boolean
                   begin
                     Result := ARecipe.Id = Recipe.Id;
                   end;

      SourceList.MoveTo(DestinationList, Predicate);
      FRecipeListbox.DeleteSelected;

      Recipe.AssignedCategory := Category.Id;
      Cookbook.GetSession.Save(Recipe);

      FCategoryListbox.OnClick(FCategoryListbox);
      FSourceIndex := FCategoryListbox.ItemIndex;
    end;
end;

procedure TRecipeCategorieDragDropHandler.CategoryDragOver(Sender,
  Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
begin
  Accept := Source = FRecipeListbox;
  FCategoryListbox.ItemIndex := FCategoryListbox.ItemAtPos(Point(X, Y), true);
end;

procedure TRecipeCategorieDragDropHandler.RecipeEndDrag(Sender, Target: TObject;
  X, Y: Integer);
begin
  FCategoryListbox.ItemIndex := FSourceIndex;
end;

procedure TRecipeCategorieDragDropHandler.RecipeStartDrag(Sender: TObject;
  var DragObject: TDragObject);
begin
  FSourceCategory := TCategory(FCategoryListbox.Items.Objects[FCategoryListbox.ItemIndex]);
  FSourceIndex := FCategoryListbox.ItemIndex;
end;

procedure TRecipeCategorieDragDropHandler.SetListboxes(const ACategories,
  ARecipes: TListbox);
begin
  FRecipeListbox := ARecipes;
  FRecipeListbox.DragMode := dmAutomatic;
  FRecipeListbox.OnEndDrag := RecipeEndDrag;
  FRecipeListbox.OnStartDrag := RecipeStartDrag;

  FCategoryListbox := ACategories;
  FCategoryListbox.OnDragDrop := CategoryDragDrop;
  FCategoryListbox.OnDragOver := CategoryDragOver;
end;

{$ENDREGION}

end.
