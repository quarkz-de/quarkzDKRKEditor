unit dkrk.RecipeEditor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, VirtualTrees,
  dkrk.Entities, dkrk.Visualizers;

type
  TwRecipeEditor = class(TForm)
    btCancel: TButton;
    btOk: TButton;
    txBezeichnung: TLabel;
    edBezeichnung: TEdit;
    txPortionen: TLabel;
    cbPortionen: TComboBox;
    edPortionen: TEdit;
    stIngredients: TVirtualStringTree;
    txPreparation: TLabel;
    edPreparation: TMemo;
    procedure FormCreate(Sender: TObject);
  private
    { Private-Deklarationen }
    Recipe: TRecipe;
    ListVisualizer: IIngredientListVisualizer;
    procedure LoadData;
    procedure SaveData;
  public
    { Public-Deklarationen }
    function Execute(const ARecipe: TRecipe): Boolean;
    class function ExecuteDialog(const ARecipe: TRecipe): Boolean;
  end;

var
  wRecipeEditor: TwRecipeEditor;

implementation

{$R *.dfm}

uses
  Spring.Container,
  dkrk.Ingredients;

{ TwRecipeEditor }

function TwRecipeEditor.Execute(const ARecipe: TRecipe): Boolean;
begin
  Recipe := ARecipe;
  LoadData;
  Result := ShowModal = mrOk;
  if Result then
    SaveData;
end;

class function TwRecipeEditor.ExecuteDialog(const ARecipe: TRecipe): Boolean;
var
  Dialog: TwRecipeEditor;
begin
  Dialog := TwRecipeEditor.Create(nil);
  try
    Result := Dialog.Execute(ARecipe);
  finally
    Dialog.Free;
  end;
end;

procedure TwRecipeEditor.FormCreate(Sender: TObject);
begin
  ListVisualizer := GlobalContainer.Resolve<IIngredientListVisualizer>;
  ListVisualizer.SetVirtualStringTree(stIngredients);
end;

procedure TwRecipeEditor.LoadData;
begin
  edBezeichnung.Text := Recipe.Name;
  edPortionen.Text := Recipe.Count.ToString;
  cbPortionen.Text := Recipe.CountText;

  // todo: der Text hat nur LF statt CRLF
  edPreparation.Text := Recipe.Preparation;

  ListVisualizer.SetIngredients(Recipe.IngredientsList);
  ListVisualizer.RenderContent;
end;

procedure TwRecipeEditor.SaveData;
var
  IngredientList: TIngredientsList;
begin
  Recipe.Name := edBezeichnung.Text;
  Recipe.Count := String(edPortionen.Text).ToInteger;
  Recipe.CountText := cbPortionen.Text;
  Recipe.Preparation := edPreparation.Text;

  IngredientList := ListVisualizer.GetIngredients;
  Recipe.IngredientsList := IngredientList;
  IngredientList.Free;
end;

end.
