unit dkrk.Renderers;

interface

uses
  System.SysUtils, System.Classes,
  dkrk.Entities;

type
  IRecipeRenderer = interface
    ['{92049C66-8355-4A9C-AA0B-E795B1A4F81C}']
    procedure Render(const ARecipe: TRecipe; const AHTML: TStrings);
  end;

implementation

uses
  Spring.Container,
  dkrk.Ingredients;

type
  TRecipeRenderer = class(TInterfacedObject, IRecipeRenderer)
  private
    function H1(const AText: String): String;
    function H2(const AText: String): String;
    function P(const AText: String): String;
    function QuantityRow(const AIngredient: TIngredient): String;
    function Row(const AIngredient: TIngredient): String;
    function TitleRow(const AIngredient: TIngredient): String;
  public
    procedure Render(const ARecipe: TRecipe; const AHTML: TStrings);
  end;

{ TRecipeRenderer }

function TRecipeRenderer.H1(const AText: String): String;
begin
  Result := Format('<h1>%s</h1>', [AText]);
end;

function TRecipeRenderer.H2(const AText: String): String;
begin
  Result := Format('<h2>%s</h2>', [AText]);
end;

function TRecipeRenderer.P(const AText: String): String;
begin
  Result := Format('<p>%s</p>', [AText]);
end;

function TRecipeRenderer.QuantityRow(const AIngredient: TIngredient): String;
begin
  Result := Format('<tr><td>%g %s</td><td>%s</td></tr>',
    [AIngredient.Quantity, AIngredient.Measure, AIngredient.Ingredient]);
end;

procedure TRecipeRenderer.Render(const ARecipe: TRecipe; const AHTML: TStrings);
var
  Prep: TStringList;
  I: Integer;
  Ingredient: TIngredient;
begin
  AHTML.Clear;

  AHTML.Add('<html>');
  AHTML.Add('<head>');
  AHTML.Add('  <meta http-equiv="Content-Style-Type" content="text/css">');
  AHTML.Add('  <link rel="Stylesheet" type="text/css" href="CSS_RECIPE">');
  AHTML.Add('</head>');
  AHTML.Add('<body>');

  AHTML.Add(H1(ARecipe.ToString));

  AHTML.Add(H2(Format('Zutaten für %d %s', [ARecipe.Count, ARecipe.CountText])));
  AHTML.Add('<table width="100%">');
  for Ingredient in ARecipe.IngredientsList do
    begin
      if Ingredient.HasQuantity then
        AHTML.Add(QuantityRow(Ingredient))
      else if Ingredient.IsTitle then
        AHTML.Add(TitleRow(Ingredient))
      else
        AHTML.Add(Row(Ingredient));
    end;
  AHTML.Add('</table>');

  AHTML.Add(H2('Zubereitung'));
  Prep := TStringList.Create;
  Prep.Text := ARecipe.Preparation;
  for I := 0 to Prep.Count - 1 do
    AHTML.Add(P(Prep[I]));
  Prep.Free;

  AHTML.Add('</body>');
  AHTML.Add('</html>');
end;

function TRecipeRenderer.Row(const AIngredient: TIngredient): String;
begin
  Result := Format('<tr><td></td><td>%s</td></tr>',
    [AIngredient.Ingredient]);
end;

function TRecipeRenderer.TitleRow(const AIngredient: TIngredient): String;
begin
  Result := Format('<tr><td colspan="2"><b>%s</b></td></tr>',
    [AIngredient.Ingredient]);
end;

initialization
  GlobalContainer.RegisterType<TRecipeRenderer>.Implements<IRecipeRenderer>;
end.
