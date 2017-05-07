unit dkrk.RecipeEditor;

interface

uses
  Winapi.Windows, Winapi.Messages, Winapi.ActiveX, System.SysUtils,
  System.Variants, System.Classes, System.Generics.Collections, System.Actions,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ActnList, VirtualTrees,
  dkrk.Entities, dkrk.Visualizers, dkrk.Cookbook;

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
    edQuantity: TEdit;
    cbMeasure: TComboBox;
    btAdd: TButton;
    btChange: TButton;
    btDelete: TButton;
    ActionList1: TActionList;
    acAdd: TAction;
    acEdit: TAction;
    acDelete: TAction;
    cbIngredient: TComboBox;
    cbTitle: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure acEditExecute(Sender: TObject);
    procedure acDeleteExecute(Sender: TObject);
    procedure acAddExecute(Sender: TObject);
    procedure cbIngredientKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edQuantityKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cbMeasureKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cbTitleKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure stIngredientsDragAllowed(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
    procedure stIngredientsDragOver(Sender: TBaseVirtualTree; Source: TObject;
      Shift: TShiftState; State: TDragState; Pt: TPoint; Mode: TDropMode;
      var Effect: Integer; var Accept: Boolean);
    procedure stIngredientsDragDrop(Sender: TBaseVirtualTree; Source: TObject;
      DataObject: IDataObject; Formats: TFormatArray; Shift: TShiftState;
      Pt: TPoint; var Effect: Integer; Mode: TDropMode);
    procedure cbTitleClick(Sender: TObject);
    procedure stIngredientsChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
  private
    { Private-Deklarationen }
    Cookbook: ICookbook;
    Recipe: TRecipe;
    ListVisualizer: IIngredientListVisualizer;
    procedure LoadData;
    procedure SaveData;
    procedure LoadTemplates;
    procedure UpdateTemplates;
    procedure ClearIngredientInput;
    procedure LoadSelectedIngredient;
    procedure UpdateEditComponents;
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
  Spring.Container, Spring.Collections,
  dkrk.Ingredients;

{ TwRecipeEditor }

procedure TwRecipeEditor.acAddExecute(Sender: TObject);
begin
  ListVisualizer.AddIngredient(String(edQuantity.Text).ToSingle,
    cbMeasure.Text, cbIngredient.Text, cbTitle.Checked);
  UpdateTemplates;
  ClearIngredientInput;
end;

procedure TwRecipeEditor.acDeleteExecute(Sender: TObject);
begin
  ListVisualizer.DeleteSelected;
  ClearIngredientInput;
end;

procedure TwRecipeEditor.acEditExecute(Sender: TObject);
begin
  ListVisualizer.ChangeIngredient(String(edQuantity.Text).ToSingle,
    cbMeasure.Text, cbIngredient.Text, cbTitle.Checked);
  UpdateTemplates;
  ClearIngredientInput;
end;

procedure TwRecipeEditor.cbIngredientKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_RETURN:
      begin
        if ListVisualizer.IsSelected then
          acEdit.Execute
        else
          acAdd.Execute;
      end;
    VK_INSERT:
      begin
        if Shift = [ssShift] then
          acAdd.Execute;
      end;
    VK_DELETE:
      begin
        if Shift = [ssShift] then
          acDelete.Execute;
      end;
  end;
end;

procedure TwRecipeEditor.cbMeasureKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_RETURN:
      cbIngredient.SetFocus;
  end;
end;

procedure TwRecipeEditor.cbTitleClick(Sender: TObject);
begin
  UpdateEditComponents;
end;

procedure TwRecipeEditor.cbTitleKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_RETURN:
      begin
        if ListVisualizer.IsSelected then
          acEdit.Execute
        else
          acAdd.Execute;
      end;
    VK_INSERT:
      begin
        if Shift = [ssShift] then
          acAdd.Execute;
      end;
    VK_DELETE:
      begin
        if Shift = [ssShift] then
          acDelete.Execute;
      end;
  end;
end;

procedure TwRecipeEditor.ClearIngredientInput;
begin
  edQuantity.Text := '';
  cbMeasure.Text := '';
  cbIngredient.Text := '';
  cbTitle.Checked := false;
  UpdateEditComponents;
  ListVisualizer.ClearSelection;
  edQuantity.SetFocus;
end;

procedure TwRecipeEditor.edQuantityKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_RETURN:
      cbMeasure.SetFocus;
  end;
end;

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
  Cookbook := GlobalContainer.Resolve<ICookbook>;
  LoadTemplates;
end;

procedure TwRecipeEditor.LoadData;
begin
  edBezeichnung.Text := Recipe.Name;
  edPortionen.Text := Recipe.Count.ToString;
  cbPortionen.Text := Recipe.CountText;

  edPreparation.Text := Recipe.Preparation.Replace(#10, #13#10);

  ListVisualizer.SetIngredients(Recipe.IngredientsList);
  ListVisualizer.RenderContent;
end;

procedure TwRecipeEditor.LoadSelectedIngredient;
var
  Quantity: Single;
  Measure, Ingredient: String;
  IsTitle: Boolean;
begin
  if ListVisualizer.GetSelected(Quantity, Measure, Ingredient, IsTitle) then
    begin
      edQuantity.Text := Quantity.ToString;
      cbMeasure.Text := Measure;
      cbIngredient.Text := Ingredient;
      cbTitle.Checked := IsTitle;
    end;
end;

procedure TwRecipeEditor.LoadTemplates;
var
  IngredientTemplates: IList<TIngredientTemplate>;
  IngredientTemplate: TIngredientTemplate;
  UnitTemplates: IList<TUnitTemplate>;
  UnitTemplate: TUnitTemplate;
begin
  IngredientTemplates := Cookbook.GetSession.FindAll<TIngredientTemplate>();
  for IngredientTemplate in IngredientTemplates do
    cbIngredient.Items.Add(IngredientTemplate.Name);
  UnitTemplates := Cookbook.GetSession.FindAll<TUnitTemplate>();
  for UnitTemplate in UnitTemplates do
    cbMeasure.Items.Add(UnitTemplate.Name);
end;

procedure TwRecipeEditor.SaveData;
var
  IngredientList: TIngredientsList;
begin
  Recipe.Name := edBezeichnung.Text;
  Recipe.Count := String(edPortionen.Text).ToInteger;
  Recipe.CountText := cbPortionen.Text;
  Recipe.Preparation := String(edPreparation.Text).Replace(#13#10, #10);

  IngredientList := ListVisualizer.GetIngredients;
  Recipe.IngredientsList := IngredientList;
  IngredientList.Free;
end;

procedure TwRecipeEditor.stIngredientsChange(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
begin
  LoadSelectedIngredient;
end;

procedure TwRecipeEditor.stIngredientsDragAllowed(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
begin
  Allowed := true;
end;

procedure TwRecipeEditor.stIngredientsDragDrop(Sender: TBaseVirtualTree;
  Source: TObject; DataObject: IDataObject; Formats: TFormatArray;
  Shift: TShiftState; Pt: TPoint; var Effect: Integer; Mode: TDropMode);
var
  SourceNode, TargetNode: PVirtualNode;
  AttMode: TVTNodeAttachMode;
begin
  SourceNode := TVirtualStringTree(Source).FocusedNode;
  TargetNode := Sender.DropTargetNode;

  case Mode of
    dmNowhere:
      AttMode := amNoWhere;
    dmAbove:
      AttMode := amInsertBefore;
    dmOnNode, dmBelow:
      AttMode := amInsertAfter;
  end;

  Sender.MoveTo(SourceNode, TargetNode, AttMode, false);
end;

procedure TwRecipeEditor.stIngredientsDragOver(Sender: TBaseVirtualTree;
  Source: TObject; Shift: TShiftState; State: TDragState; Pt: TPoint;
  Mode: TDropMode; var Effect: Integer; var Accept: Boolean);
begin
  Accept := (Source = Sender);
end;

procedure TwRecipeEditor.UpdateEditComponents;
begin
  if cbTitle.Checked then
    begin
      edQuantity.Text := '';
      cbMeasure.Text := '';
    end;
end;

procedure TwRecipeEditor.UpdateTemplates;
var
  UnitTemplate: TUnitTemplate;
  IngredientTemplate: TIngredientTemplate;
begin
  if not String(cbMeasure.Text).IsEmpty and (cbMeasure.Items.IndexOf(cbMeasure.Text) < 0) then
    begin
      UnitTemplate := TUnitTemplate.Create;
      UnitTemplate.Name := cbMeasure.Text;
      Cookbook.GetSession.Save(UnitTemplate);
      cbMeasure.Items.Add(cbMeasure.Text);
    end;

  if not String(cbIngredient.Text).IsEmpty and (cbIngredient.Items.IndexOf(cbIngredient.Text) < 0) then
    begin
      IngredientTemplate := TIngredientTemplate.Create;
      IngredientTemplate.Name := cbIngredient.Text;
      Cookbook.GetSession.Save(IngredientTemplate);
      cbIngredient.Items.Add(cbIngredient.Text);
    end;
end;

end.
