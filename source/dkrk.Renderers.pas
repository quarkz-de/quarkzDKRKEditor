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

{$R *.RES}

uses
  Spring.Container,
  dkrk.Ingredients;

type
  TRecipeRenderer = class(TInterfacedObject, IRecipeRenderer)
  private
    function H1(const AText: String): String;
    function H2(const AText: String): String;
    function P(const AText: String): String;
    function B(const AText: String): String;
    function QuantityRow(const AIngredient: TIngredient): String;
    function Row(const AIngredient: TIngredient): String;
    function TitleRow(const AIngredient: TIngredient): String;
    function Rating(const ACount, AMax: Integer;
      const AResNameOn, AResNameOff: String): String;
    function WebLink(const AText: String): String;
  public
    procedure Render(const ARecipe: TRecipe; const AHTML: TStrings);
  end;

{$REGION 'TRecipeRenderer'}

function TRecipeRenderer.B(const AText: String): String;
begin
  Result := Format('<b>%s</b>', [AText]);
end;

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

function TRecipeRenderer.Rating(const ACount, AMax: Integer; const AResNameOn,
  AResNameOff: String): String;
var
  I: Integer;
begin
  Result := '';
  for I := 1 to AMax do
    begin
      if I > ACount then
        Result := Result + Format('<img src="%s">', [AResNameOff])
      else
        Result := Result + Format('<img src="%s">', [AResNameOn]);
    end;
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
  AHTML.Add(Format('  <title>%s</title>', [ARecipe.ToString]));
  AHTML.Add('</head>');
  AHTML.Add('<body>');

  AHTML.Add(H1(ARecipe.ToString));

  AHTML.Add(H2(Format('Zutaten f�r %d %s', [ARecipe.Count, ARecipe.CountText])));
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

  if ARecipe.PrepDuration > 0 then
    AHTML.Add(P(Format('Zubereitungsdauer: %d Minuten', [ARecipe.PrepDuration])));

  AHTML.Add(H2('Weitere Informationen'));
  AHTML.Add(P(Format('Quelle: %s', [WebLink(ARecipe.Source)])));
  AHTML.Add(P('Schwierigkeit:'));
  AHTML.Add(P(Rating(ARecipe.DiffRating div 2, 8, 'DIFF_ON', 'DIFF_OFF')));
  AHTML.Add(P('Bewertung:'));
  AHTML.Add(P(Rating(ARecipe.Rating div 2, 8, 'RATING_ON', 'RATING_OFF')));

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

function TRecipeRenderer.WebLink(const AText: String): String;
begin
  if AText.StartsWith('http://', true) or AText.StartsWith('https://', true) then
    Result := Format('<a href="%s">%s</a>', [AText, AText])
  else if AText.StartsWith('www.', true) then
    Result := Format('<a href="http://%s">%s</a>', [AText, AText])
  else
    Result := AText;
end;

{$ENDREGION}

initialization
  GlobalContainer.RegisterType<TRecipeRenderer>.Implements<IRecipeRenderer>;
end.
