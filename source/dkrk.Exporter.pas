unit dkrk.Exporter;

interface

uses
  System.SysUtils, System.Classes,
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


(*
<Speicherungen><Version>5</Version>
<Kategorien><Kategorie Name="Brote" Beschreibung="" Key="6">
<Rezept Name="Weizen-Mischbrot" Bild="" Key="1" Bewertung="0" Schwierigkeit="0" Quelle="Brot" Anmerkung="Brot Ausgabe 04/2018 Seite 37" PersonenAnzahl="0" PersonenAnzahlString="" Dauer="0" Kochzeit="0" DauerString="" KochzeitString="" Kategorien="">
<Zutaten>Roggen-Sauerteig:
210 g Roggenmehl 1370
180 g Wasser (sehr warm)
20 g Anstellgut

Hauptteig:
160 g Weizenmehl 1050
300 g Weizenmehl 550
290 g Wasser (lauwarm)
15 g Salz
Sauerteig</Zutaten><Zubereitung>Die Zutaten für den Roggen-Sauerteig mischen und etwa 12-16 Stunden bei Raumtemperatur reifen lassen.

Alle Zutaten 5 Minuten langsam mischen, dann etwa 12 Minuten schneller kneten bis sich der Teig von der Schüssel löst.

Den Teig 90 Minuten bei Raumtemperatur in einer abgedeckten Schüssel gehen lassen, nach 30 und 60 Minuten jeweils einmal dehnen und falten.

Den Teig langwirken und mit dem Schluss nach oben für etwa 60 Minuten in den Gärkorb legen.

Aus dem Korb stürzen, einschneiden und bei 250°C fallend auf 230°C 50 Minuten bei Ober-/Unterhitze backen.

Nach 1 Minuten gut schwaden. Nach 10 Minuten Schwaden ablassen.</Zubereitung></Rezept></Kategorie></Kategorien><Rezepte><Rezept Name="Neues Rezept" Bild="" Key="2" Bewertung="0" Schwierigkeit="0" Quelle="" Anmerkung="" PersonenAnzahl="0" PersonenAnzahlString="" Dauer="0" Kochzeit="0" DauerString="" KochzeitString="" Kategorien=""><Zutaten /><Zubereitung /></Rezept></Rezepte></Speicherungen>*)

{ TRezeFormatExporter }

procedure TRezeFormatExporter.Add(const AString: String);
begin
  FData := FData + AString;;
end;

procedure TRezeFormatExporter.AddCategory(const ACategory: TCategory);
var
  Recipes: IList<TRecipe>;
  Recipe: TRecipe;
begin
  Add(Format('<Kategorie Name="%s" Beschreibung="" Key="%d">', [ACategory.Name, ACategory.Id + 10]));

  Recipes := FCookbook.GetSession.FindAll<TRecipe>();
  for Recipe in Recipes do
    AddRecipe(Recipe);

  Add('</Kategorie>');
end;

procedure TRezeFormatExporter.AddFooter;
begin
  Add('</Kategorien><Speicherungen>');
end;

procedure TRezeFormatExporter.AddHeader;
begin
  Add('<Speicherungen><Version>5</Version><Kategorien>');
end;

procedure TRezeFormatExporter.AddRecipe(const ARecipe: TRecipe);
var
  Serializer: IIngredientsSerializer;
begin
  Add(Format('<Rezept Name="%s" Bild="" Key="%d" Bewertung="0" Schwierigkeit="0" Quelle="%s" Anmerkung="" PersonenAnzahl="%d" PersonenAnzahlString="%s" Dauer="0" Kochzeit="0" DauerString="" KochzeitString="" Kategorien="">',
    [ARecipe.Name, ARecipe.Id, ARecipe.Source, ARecipe.Count, ARecipe.CountText]));
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
