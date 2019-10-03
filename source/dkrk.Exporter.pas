unit dkrk.Exporter;

interface

uses
  System.SysUtils, System.Classes, System.Generics.Collections,
  dkrk.Cookbook, dkrk.Entities, dkrk.Ingredients;

type
  ICookbookExporter = interface
    ['{97B3EE7C-0EF0-4CA6-B6B7-1A96A64BBEC8}']
    procedure SaveToFile(const ACookbook: ICookbook; const AFilename: String);
  end;

  TRezeFormatExporter = class(TInterfacedObject, ICookbookExporter)
  private
    FData: String;
    FCookbook: ICookbook;
    procedure AddHeader;
    procedure AddFooter;
    procedure AddCategory(const ACategory: TCategory);
    procedure AddRecipe(const ARecipe: TRecipe);
    procedure Clear;
    procedure Add(const AString: String);
  protected
    property Data: String read FData;
  public
    procedure SaveToFile(const ACookbook: ICookbook; const AFilename: String);
  end;

implementation

uses
  Spring.Container, Spring.Collections;

{ TRezeFormatExporter }

procedure TRezeFormatExporter.Add(const AString: String);
begin
  FData := FData + AString;
end;

procedure TRezeFormatExporter.AddCategory(const ACategory: TCategory);
var
  Recipes: IList<TRecipe>;
  Recipe: TRecipe;
begin
  Add(Format('<Kategorie Name="%s" Beschreibung="" Key="%d">', [ACategory.Name, ACategory.Id]));

  Recipes := FCookbook.GetSession.FindAll<TRecipe>();
  for Recipe in Recipes do
    if Recipe.Category.Id = ACategory.Id then
      AddRecipe(Recipe);

  Add('</Kategorie>');
end;

procedure TRezeFormatExporter.AddFooter;
begin
  Add('</Kategorien></Speicherungen>');
end;

procedure TRezeFormatExporter.AddHeader;
begin
  Add('<Speicherungen><Version>5</Version><Kategorien>');
end;

procedure TRezeFormatExporter.AddRecipe(const ARecipe: TRecipe);
var
  Serializer: IIngredientsSerializer;
begin
  Add(Format('<Rezept Name="%s" Bild="" Key="%d" Bewertung="0" Schwierigkeit="0" Quelle="%s" Anmerkung="" PersonenAnzahl="" PersonenAnzahlString="%d %s" Dauer="0" Kochzeit="0" DauerString="" KochzeitString="" Kategorien="%d">',
    [ARecipe.Name, ARecipe.Id, ARecipe.Source, ARecipe.Count, ARecipe.CountText, ARecipe.Category.Id]));
  Add('<Zutaten>');

  Serializer := TIngredientsSerializer.Create;
  Add(Serializer.ToString(ARecipe.IngredientsList));

  Add('</Zutaten><Zubereitung>');
  Add(ARecipe.Preparation);
  Add('</Zubereitung></Rezept>');
end;

procedure TRezeFormatExporter.Clear;
begin
  FData := '';
end;

procedure TRezeFormatExporter.SaveToFile(const ACookbook: ICookbook;
  const AFilename: String);
var
  Categories: IList<TCategory>;
  Category: TCategory;
  Strings: TStringList;
begin
  FCookbook := ACookbook;

  Clear;
  AddHeader;

  Categories := FCookbook.GetSession.FindAll<TCategory>();
  for Category in Categories do
    AddCategory(Category);

  AddFooter;

  Strings := TStringList.Create;
  Strings.WriteBOM := true;
  Strings.Text := Data;
  Strings.SaveToFile(AFilename);
  Strings.Free;
end;

end.
