unit dkrk.Ingredients;

interface

uses
  System.SysUtils, System.Classes, System.Generics.Collections, System.Math;

type
  TIngredient = class
  private
    FQuantity: Single;
    FMeasure: String;
    FIngredient: String;
    function GetIsTitle: Boolean;
    procedure SetIsTitle(Value: Boolean);
  public
    constructor Create(const AIsTitle: Boolean = false);
    property Quantity: Single read FQuantity write FQuantity;
    property Measure: String read FMeasure write FMeasure;
    property Ingredient: String read FIngredient write FIngredient;
    property IsTitle: Boolean read GetIsTitle write SetIsTitle;
    function HasQuantity: Boolean;
  end;

  TIngredientsList = TObjectList<TIngredient>;

  IIngredientsSerializer = interface
    ['{448DE1AE-36CC-4771-BAAC-31C9D3B90C79}']
    function Serialize(const AList: TIngredientsList): String;
    function Deserialize(const AValue: String): TIngredientsList;
  end;

  TIngredientsSerializer = class(TInterfacedObject, IIngredientsSerializer)
  private
    function GetItemSeparator: String;
    function GetValueSeparator: String;
    function ItemToString(const AIngredient: TIngredient): String;
  protected
    property ItemSeparator: String read GetItemSeparator;
    property ValueSeparator: String read GetValueSeparator;
  public
    function Serialize(const AList: TIngredientsList): String;
    function Deserialize(const AValue: String): TIngredientsList;
  end;

implementation

{$REGION 'TIngredientsSerializer'}

function TIngredientsSerializer.Deserialize(
  const AValue: String): TIngredientsList;
var
  Items, Parts: TArray<String>;
  I: Integer;
  Ingredient: TIngredient;
  FormatSettings: TFormatSettings;
  Quantity: Single;
begin
  FormatSettings.DecimalSeparator := '.';
  Result := TIngredientsList.Create(true);
  Items := AValue.Split([ItemSeparator]);
  for I := Low(Items) to High(Items) do
    begin
      Parts := Items[I].Split([ValueSeparator]);
      Ingredient := TIngredient.Create;
      if TryStrToFloat(Parts[0], Quantity, FormatSettings) then
        Ingredient.Quantity := Quantity
      else
        Ingredient.Quantity := 0;
      Ingredient.Measure := Parts[1];
      Ingredient.Ingredient := Parts[2];
      Result.Add(Ingredient);
    end;
end;

function TIngredientsSerializer.GetItemSeparator: String;
begin
  Result := '<&&>';
end;

function TIngredientsSerializer.GetValueSeparator: String;
begin
  Result := '<&>';
end;

function TIngredientsSerializer.ItemToString(
  const AIngredient: TIngredient): String;
var
  FormatSettings: TFormatSettings;
begin
  FormatSettings.DecimalSeparator := '.';
  Result := String.Join(ValueSeparator,
    [FloatToStr(AIngredient.Quantity, FormatSettings),
    AIngredient.Measure, AIngredient.Ingredient]);
end;

function TIngredientsSerializer.Serialize(
  const AList: TIngredientsList): String;
var
  Ingredient: TIngredient;
begin
  Result := '';
  for Ingredient in AList do
    begin
      if Result <> '' then
         Result := Result + ItemSeparator;
      Result := Result + ItemToString(Ingredient);
    end;
end;

{$ENDREGION}

{$REGION 'TIngredient'}

constructor TIngredient.Create(const AIsTitle: Boolean = false);
begin
  inherited Create;
  IsTitle := AIsTitle;
end;

function TIngredient.GetIsTitle: Boolean;
begin
  Result := FQuantity = -99.0;
end;

function TIngredient.HasQuantity: Boolean;
begin
  Result := FQuantity > 0;
end;

procedure TIngredient.SetIsTitle(Value: Boolean);
begin
  if Value then
    FQuantity := -99.0
  else if FQuantity = -99.0 then
    FQuantity := 0;

  if Value then
    FMeasure := '';
end;

{$ENDREGION}

end.
