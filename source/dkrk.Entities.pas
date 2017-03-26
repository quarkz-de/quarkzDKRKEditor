unit dkrk.Entities;

interface

uses
  System.SysUtils, System.Generics.Collections,
  dorm, dorm.Commons, dorm.mappings, dorm.ObjectStatus,
  dkrk.Ingredients;

type
  [Entity('Recipes')]
  TRecipe = class(TdormBaseObject)
  private
    FId: Integer;
    FName: String;
    FAssignedCategory: Integer;
    FCount: Integer;
    FCountText: String;
    FIngredients: String;
    FSource: String;
    FPreparation: String;
    FPrepDuration: Integer;
    FFavorit: Integer;
    FPicCount: Integer;
    FRating: Integer;
    FDiffRating: Integer;
    FAddA: String;
    FAddB: String;
    FAddC: String;
    FAddD: String;
    FAddE: String;
    procedure SetId(const AValue: Integer);
    procedure SetName(const AValue: String);
    procedure SetAssignedCategory(const AValue: Integer);
    procedure SetCount(const AValue: Integer);
    procedure SetCountText(const AValue: String);
    procedure SetIngredients(const AValue: String);
    procedure SetSource(const AValue: String);
    procedure SetPreparation(const AValue: String);
    procedure SetPrepDuration(const AValue: Integer);
    procedure SetFavorit(const AValue: Integer);
    procedure SetPicCount(const AValue: Integer);
    procedure SetRating(const AValue: Integer);
    procedure SetDiffRating(const AValue: Integer);
    procedure SetAddA(const AValue: String);
    procedure SetAddB(const AValue: String);
    procedure SetAddC(const AValue: String);
    procedure SetAddD(const AValue: String);
    procedure SetAddE(const AValue: String);
    function GetIsFavorit: Boolean;
    procedure SetIsFavorit(const AValue: Boolean);
    function GetIngredientsList: TIngredientsList;
    procedure SetIngredientsList(const AValue: TIngredientsList);
  public
    property Id: Integer read FId write SetId;
    property Name: String read FName write SetName;
    property AssignedCategory: Integer read FAssignedCategory write SetAssignedCategory;
    property Count: Integer read FCount write SetCount;
    property CountText: String read FCountText write SetCountText;
    property Ingredients: String read FIngredients write SetIngredients;
    property Source: String read FSource write SetSource;
    property Preparation: String read FPreparation write SetPreparation;
    property PrepDuration: Integer read FPrepDuration write SetPrepDuration;
    property Favorit: Integer read FFavorit write SetFavorit;
    property PicCount: Integer read FPicCount write SetPicCount;
    property Rating: Integer read FRating write SetRating;
    property DiffRating: Integer read FDiffRating write SetDiffRating;
    property AddA: String read FAddA write SetAddA;
    property AddB: String read FAddB write SetAddB;
    property AddC: String read FAddC write SetAddC;
    property AddD: String read FAddD write SetAddD;
    property AddE: String read FAddE write SetAddE;

    [NoAutomapping]
    property IsFavorit: Boolean read GetIsFavorit write SetIsFavorit;

    [NoAutomapping]
    property IngredientsList: TIngredientsList read GetIngredientsList
      write SetIngredientsList;

    function ToString: String; override;
  end;

  [ListOf('dkrk.Entities.TRecipe')]
  TRecipes = class(TObjectList<TRecipe>)
  end;

  [Entity('Categories')]
  TCategory = class(TdormBaseObject)
  private
    FId: Integer;
    FName: String;
    FAssignedCategory: Integer;
    FRecipes: TRecipes;
    procedure SetId(const AValue: Integer);
    procedure SetName(const AValue: String);
    procedure SetAssignedCategory(const AValue: Integer);
  public
    constructor Create;
    destructor Destroy; override;

    property Id: Integer read FId write SetId;
    property Name: String read FName write SetName;
    property AssignedCategory: Integer read FAssignedCategory write SetAssignedCategory;
    [HasMany('AssignedCategory')]
    property Recipes: TRecipes read FRecipes;

    function ToString: String; override;
  end;

implementation

{ TCategory }

constructor TCategory.Create;
begin
  inherited;
  FRecipes := TRecipes.Create(true);
end;

destructor TCategory.Destroy;
begin
  FreeAndNil(FRecipes);
  inherited;
end;

procedure TCategory.SetAssignedCategory(const AValue: Integer);
begin
  if FAssignedCategory <> AValue then
    begin
      FAssignedCategory := AValue;
      ObjStatus := osDirty;
    end;
end;

procedure TCategory.SetId(const AValue: Integer);
begin
  FID := AValue;
end;

procedure TCategory.SetName(const AValue: String);
begin
  if FName <> AValue then
    begin
      FName := AValue;
      ObjStatus := osDirty;
    end;
end;

function TCategory.ToString: String;
begin
  Result := Name;
end;

{ TRecipe }

function TRecipe.GetIngredientsList: TIngredientsList;
var
  Serializer: IIngredientsSerializer;
begin
  Serializer := TIngredientsSerializer.Create;
  Result := Serializer.Deserialize(Ingredients);
end;

function TRecipe.GetIsFavorit: Boolean;
begin
  Result := Favorit = 1;
end;

procedure TRecipe.SetAddA(const AValue: String);
begin
  if FAddA <> AValue then
    begin
      FAddA := AValue;
      ObjStatus := osDirty;
    end;
end;

procedure TRecipe.SetAddB(const AValue: String);
begin
  if FAddB <> AValue then
    begin
      FAddB := AValue;
      ObjStatus := osDirty;
    end;
end;

procedure TRecipe.SetAddC(const AValue: String);
begin
  if FAddC <> AValue then
    begin
      FAddC := AValue;
      ObjStatus := osDirty;
    end;
end;

procedure TRecipe.SetAddD(const AValue: String);
begin
  if FAddD <> AValue then
    begin
      FAddD := AValue;
      ObjStatus := osDirty;
    end;
end;

procedure TRecipe.SetAddE(const AValue: String);
begin
  if FAddE <> AValue then
    begin
      FAddE := AValue;
      ObjStatus := osDirty;
    end;
end;

procedure TRecipe.SetAssignedCategory(const AValue: Integer);
begin
  if FAssignedCategory <> AValue then
    begin
      FAssignedCategory := AValue;
      ObjStatus := osDirty;
    end;
end;

procedure TRecipe.SetCount(const AValue: Integer);
begin
  if FCount <> AValue then
    begin
      FCount := AValue;
      ObjStatus := osDirty;
    end;
end;

procedure TRecipe.SetCountText(const AValue: String);
begin
  if FCountText <> AValue then
    begin
      FCountText := AValue;
      ObjStatus := osDirty;
    end;
end;

procedure TRecipe.SetDiffRating(const AValue: Integer);
begin
  if FDiffRating <> AValue then
    begin
      FDiffRating := AValue;
      ObjStatus := osDirty;
    end;
end;

procedure TRecipe.SetFavorit(const AValue: Integer);
begin
  if FFavorit <> AValue then
    begin
      FFavorit := AValue;
      ObjStatus := osDirty;
    end;
end;

procedure TRecipe.SetId(const AValue: Integer);
begin
  FId := AValue;
end;

procedure TRecipe.SetIngredients(const AValue: String);
begin
  if FIngredients <> AValue then
    begin
      FIngredients := AValue;
      ObjStatus := osDirty;
    end;
end;

procedure TRecipe.SetIngredientsList(const AValue: TIngredientsList);
var
  Serializer: IIngredientsSerializer;
begin
  Serializer := TIngredientsSerializer.Create;
  Ingredients := Serializer.Serialize(AValue);
end;

procedure TRecipe.SetIsFavorit(const AValue: Boolean);
begin
  if AValue then
    Favorit := 1
  else
    Favorit := 0;
end;

procedure TRecipe.SetName(const AValue: String);
begin
  if FName <> AValue then
    begin
      FName := AValue;
      ObjStatus := osDirty;
    end;
end;

procedure TRecipe.SetPicCount(const AValue: Integer);
begin
  if FPicCount <> AValue then
    begin
      FPicCount := AValue;
      ObjStatus := osDirty;
    end;
end;

procedure TRecipe.SetPreparation(const AValue: String);
begin
  if FPreparation <> AValue then
    begin
      FPreparation := AValue;
      ObjStatus := osDirty;
    end;
end;

procedure TRecipe.SetPrepDuration(const AValue: Integer);
begin
  if FPrepDuration <> AValue then
    begin
      FPrepDuration := AValue;
      ObjStatus := osDirty;
    end;
end;

procedure TRecipe.SetRating(const AValue: Integer);
begin
  if FRating <> AValue then
    begin
      FRating := AValue;
      ObjStatus := osDirty;
    end;
end;

procedure TRecipe.SetSource(const AValue: String);
begin
  if FSource <> AValue then
    begin
      FSource := AValue;
      ObjStatus := osDirty;
    end;
end;

function TRecipe.ToString: String;
begin
  Result := Name;
end;

end.
