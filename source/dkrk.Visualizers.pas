unit dkrk.Visualizers;

interface

uses
  System.SysUtils, System.Generics.Collections, System.Classes,
  Winapi.Windows,
  Vcl.Controls, Vcl.StdCtrls,
  HtmlView, VirtualTrees,
  dkrk.Entities, dkrk.Renderers, dkrk.Ingredients;

type
  IAbstractVisualizer = interface
    ['{A94F2C6C-21C1-4E72-9F52-E0FD2E597612}']
    procedure InitComponent;
    procedure RenderContent;
  end;

  ICategoryVisualizer = interface(IAbstractVisualizer)
    ['{DC949CBD-44B6-4B01-A332-7F5BC0B95980}']
    procedure SetListbox(const AListbox: TListbox);
    procedure SetCategories(const ACategories: TObjectList<TCategory>);
    procedure Add(const ACategory: TCategory);
    procedure Remove(const ACategory: TCategory);
    procedure Clear;
  end;

  IRecipeListVisualizer = interface(IAbstractVisualizer)
    ['{DC949CBD-44B6-4B01-A332-7F5BC0B95980}']
    procedure SetListbox(const AListbox: TListbox);
    procedure SetRecipes(const ARecipes: TObjectList<TRecipe>);
    procedure Add(const ARecipe: TRecipe);
    procedure Remove(const ARecipe: TRecipe);
    procedure Clear;
  end;

  IRecipeDisplayVisualizer = interface(IAbstractVisualizer)
    ['{B1BD11EC-AFF6-4941-9E72-FF3E7677A262}']
    procedure SetHtmlViewer(const AHtmlViewer: THtmlViewer);
    procedure SetRecipe(const ARecipe: TRecipe);
    procedure Clear;
  end;

  IIngredientListVisualizer = interface(IAbstractVisualizer)
    ['{85E9C031-E6F8-44CC-870E-C0FB3A7C0681}']
    procedure SetVirtualStringTree(const ATree: TVirtualStringTree);
    procedure SetIngredients(const AList: TIngredientsList);
    function GetIngredients: TIngredientsList;
    procedure DeleteSelected;
    procedure AddIngredient(const AQuantity: Single; const AMeasure, AIngredient: String);
    procedure ChangeIngredient(const AQuantity: Single; const AMeasure, AIngredient: String);
    function GetSelected(var AQuantity: Single; var AMeasure, AIngredient: String): Boolean;
    procedure ClearSelection;
    function IsSelected: Boolean;
  end;

implementation

uses
  Vcl.Graphics, Spring.Container, HtmlGlobals;

type
  TCategoryVisualizer = class(TInterfacedObject, ICategoryVisualizer)
  private
    FListbox: TListbox;
    FCategories: TObjectList<TCategory>;
    procedure OnData(Control: TWinControl; Index: Integer; var Data: string);
    function OnDataFind(Control: TWinControl; FindString: string): Integer;
    procedure OnDataObject(Control: TWinControl; Index: Integer; var DataObject: TObject);
  public
    procedure SetListbox(const AListbox: TListbox);
    procedure SetCategories(const ACategories: TObjectList<TCategory>);
    procedure InitComponent;
    procedure RenderContent;
    procedure Add(const ACategory: TCategory);
    procedure Remove(const ACategory: TCategory);
    procedure Clear;
  end;

  TRecipeListVisualizer = class(TInterfacedObject, IRecipeListVisualizer)
  private
    FListbox: TListbox;
    FRecipes: TObjectList<TRecipe>;
    procedure OnData(Control: TWinControl; Index: Integer; var Data: string);
    function OnDataFind(Control: TWinControl; FindString: string): Integer;
    procedure OnDataObject(Control: TWinControl; Index: Integer; var DataObject: TObject);
  public
    procedure SetListbox(const AListbox: TListbox);
    procedure SetRecipes(const ARecipes: TObjectList<TRecipe>);
    procedure InitComponent;
    procedure RenderContent;
    procedure Add(const ARecipe: TRecipe);
    procedure Remove(const ARecipe: TRecipe);
    procedure Clear;
  end;

  TRecipeDisplayVisualizer = class(TInterfacedObject, IRecipeDisplayVisualizer)
  private
    FHtmlViewer: THtmlViewer;
    FRecipe: TRecipe;
    FRenderer: IRecipeRenderer;
    procedure LoadStreamFromResource(const AResourceName: String; var Stream: TStream);
    procedure OnStreamRequest(Sender: TObject; const SRC: String; var Stream: TStream);
    procedure OnBitmapRequest(Sender: TObject; const SRC: ThtString;
      var Bitmap: TBitmap; var Color: TColor);
  public
    constructor Create;
    procedure SetHtmlViewer(const AHtmlViewer: THtmlViewer);
    procedure SetRecipe(const ARecipe: TRecipe);
    procedure InitComponent;
    procedure RenderContent;
    procedure Clear;
  end;

  TIngredientListVisualizer = class(TInterfacedObject,
    IIngredientListVisualizer)
  private
    FTree: TVirtualStringTree;
    FList: TIngredientsList;
    procedure OnGetNodeDataSize(Sender: TBaseVirtualTree;
      var NodeDataSize: Integer);
    procedure OnGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure OnFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
  public
    procedure SetVirtualStringTree(const ATree: TVirtualStringTree);
    procedure SetIngredients(const AList: TIngredientsList);
    function GetIngredients: TIngredientsList;
    procedure InitComponent;
    procedure RenderContent;
    procedure DeleteSelected;
    procedure AddIngredient(const AQuantity: Single; const AMeasure, AIngredient: String);
    procedure ChangeIngredient(const AQuantity: Single; const AMeasure, AIngredient: String);
    function GetSelected(var AQuantity: Single; var AMeasure, AIngredient: String): Boolean;
    procedure ClearSelection;
    function IsSelected: Boolean;
  end;

{ TCategoryVisualizer }

procedure TCategoryVisualizer.Add(const ACategory: TCategory);
begin
  FCategories.Add(ACategory);
  RenderContent;
  FListbox.ItemIndex := FListbox.Count - 1;
end;

procedure TCategoryVisualizer.Clear;
begin
  FCategories := nil;
  FListbox.Count := 0;
end;

procedure TCategoryVisualizer.InitComponent;
begin
  FListbox.Style := lbVirtual;
  FListbox.OnData := OnData;
  FListbox.OnDataFind := OnDataFind;
  FListbox.OnDataObject := OnDataObject;
end;

procedure TCategoryVisualizer.OnData(Control: TWinControl; Index: Integer;
  var Data: string);
begin
  Data := FCategories[Index].ToString;
end;

function TCategoryVisualizer.OnDataFind(Control: TWinControl;
  FindString: string): Integer;
begin
  Result := -1;
end;

procedure TCategoryVisualizer.OnDataObject(Control: TWinControl; Index: Integer;
  var DataObject: TObject);
begin
  DataObject := FCategories[Index];
end;

procedure TCategoryVisualizer.Remove(const ACategory: TCategory);
begin
  FCategories.Delete(FCategories.IndexOf(ACategory));
  RenderContent;
end;

procedure TCategoryVisualizer.RenderContent;
begin
  FListbox.Count := FCategories.Count;
end;

procedure TCategoryVisualizer.SetCategories(
  const ACategories: TObjectList<TCategory>);
begin
  FCategories := ACategories;
end;

procedure TCategoryVisualizer.SetListbox(const AListbox: TListbox);
begin
  FListbox := AListbox;
  InitComponent;
end;

{ TRecipeListVisualizer }

procedure TRecipeListVisualizer.Add(const ARecipe: TRecipe);
begin
  FRecipes.Add(ARecipe);
  RenderContent;
  FListbox.ItemIndex := FListbox.Count - 1;
end;

procedure TRecipeListVisualizer.Clear;
begin
  FRecipes := nil;
  FListbox.Count := 0;
end;

procedure TRecipeListVisualizer.InitComponent;
begin
  FListbox.Style := lbVirtual;
  FListbox.OnData := OnData;
  FListbox.OnDataFind := OnDataFind;
  FListbox.OnDataObject := OnDataObject;
end;

procedure TRecipeListVisualizer.OnData(Control: TWinControl; Index: Integer;
  var Data: string);
begin
  Data := FRecipes[Index].ToString;
end;

function TRecipeListVisualizer.OnDataFind(Control: TWinControl;
  FindString: string): Integer;
begin
  Result := -1;
end;

procedure TRecipeListVisualizer.OnDataObject(Control: TWinControl;
  Index: Integer; var DataObject: TObject);
begin
  DataObject := FRecipes[Index];
end;

procedure TRecipeListVisualizer.Remove(const ARecipe: TRecipe);
begin
  FRecipes.Delete(FRecipes.IndexOf(ARecipe));
  RenderContent;
end;

procedure TRecipeListVisualizer.RenderContent;
begin
  FListbox.Count := FRecipes.Count;
end;

procedure TRecipeListVisualizer.SetListbox(const AListbox: TListbox);
begin
  FListbox := AListbox;
  InitComponent;
end;

procedure TRecipeListVisualizer.SetRecipes(
  const ARecipes: TObjectList<TRecipe>);
begin
  FRecipes := ARecipes;
end;

{ TRecipeDisplayVisualizer }

procedure TRecipeDisplayVisualizer.Clear;
begin
  FRecipe := nil;
  FHtmlViewer.Clear;
end;

constructor TRecipeDisplayVisualizer.Create;
begin
  inherited;
  FRenderer := GlobalContainer.Resolve<IRecipeRenderer>;
end;

procedure TRecipeDisplayVisualizer.InitComponent;
begin
  FHtmlViewer.OnhtStreamRequest := OnStreamRequest;
  FHtmlViewer.OnBitmapRequest := OnBitmapRequest;
end;

procedure TRecipeDisplayVisualizer.LoadStreamFromResource(
  const AResourceName: String; var Stream: TStream);
var
  MemHandle, ResHandle: THandle;
  ResourceData: PChar;
begin
  ResHandle := FindResource(HInstance, PChar(AResourceName), RT_RCDATA);
  if ResHandle > 0 then
    begin
      MemHandle := LoadResource(HInstance, ResHandle);
      if MemHandle > 0 then
        begin
          Stream := TMemoryStream.Create;
          ResourceData := LockResource(MemHandle);
          Stream.WriteBuffer(ResourceData[0], SizeOfResource(HInstance, ResHandle));
          FreeResource(MemHandle);
        end;
    end;
end;

procedure TRecipeDisplayVisualizer.OnBitmapRequest(Sender: TObject;
  const SRC: ThtString; var Bitmap: TBitmap; var Color: TColor);
var
  MemHandle, ResHandle: THandle;
  ResourceData: PChar;
begin
  Bitmap := TBitmap.Create;
  Bitmap.Handle := LoadBitmap(HInstance, PChar(SRC));
end;

procedure TRecipeDisplayVisualizer.OnStreamRequest(Sender: TObject;
  const SRC: String; var Stream: TStream);
begin
  LoadStreamFromResource(SRC, Stream);
end;

procedure TRecipeDisplayVisualizer.RenderContent;
var
  HTML: TStringList;
begin
  HTML := TStringList.Create;
  FRenderer.Render(FRecipe, HTML);
  FHtmlViewer.LoadFromString(HTML.Text);
  HTML.Free;
end;

procedure TRecipeDisplayVisualizer.SetHtmlViewer(
  const AHtmlViewer: THtmlViewer);
begin
  FHtmlViewer := AHtmlViewer;
  InitComponent;
end;

procedure TRecipeDisplayVisualizer.SetRecipe(const ARecipe: TRecipe);
begin
  FRecipe := ARecipe;
end;

{ TIngredientListVisualizer }

type
  TIngredientListNodeData = record
    Quantity: Single;
    Measure: String;
    Ingredient: String;
  end;
  PIngredientListNodeData = ^TIngredientListNodeData;

procedure TIngredientListVisualizer.AddIngredient(const AQuantity: Single;
  const AMeasure, AIngredient: String);
var
  Data: PIngredientListNodeData;
  Node: PVirtualNode;
begin
  Node := FTree.AddChild(nil);
  Data := FTree.GetNodeData(Node);
  Data.Quantity := AQuantity;
  Data.Measure := AMeasure;
  Data.Ingredient := AIngredient;
  FTree.Selected[Node] := true;
  FTree.FocusedNode := Node;
end;

procedure TIngredientListVisualizer.ChangeIngredient(const AQuantity: Single;
  const AMeasure, AIngredient: String);
var
  Data: PIngredientListNodeData;
begin
  if IsSelected then
    begin
      Data := FTree.GetNodeData(FTree.FocusedNode);
      Data.Quantity := AQuantity;
      Data.Measure := AMeasure;
      Data.Ingredient := AIngredient;
    end;
end;

procedure TIngredientListVisualizer.ClearSelection;
begin
  if IsSelected then
    begin
      FTree.Selected[FTree.FocusedNode] := false;
      FTree.FocusedNode := nil;
    end;
end;

procedure TIngredientListVisualizer.DeleteSelected;
begin
  if IsSelected then
    FTree.DeleteNode(FTree.FocusedNode);
end;

function TIngredientListVisualizer.GetIngredients: TIngredientsList;
var
  Node: PVirtualNode;
  Data: PIngredientListNodeData;
  Ingredient: TIngredient;
begin
  Result := TIngredientsList.Create;

  Node := FTree.GetFirstChild(nil);
  while Assigned(Node) do
    begin
      Data := FTree.GetNodeData(Node);

      Ingredient := TIngredient.Create;
      Ingredient.Quantity := Data.Quantity;
      Ingredient.Measure := Data.Measure;
      Ingredient.Ingredient := Data.Ingredient;
      Result.Add(Ingredient);

      Node := FTree.GetNextSibling(Node);
    end;
end;

function TIngredientListVisualizer.GetSelected(var AQuantity: Single;
  var AMeasure, AIngredient: String): Boolean;
var
  Data: PIngredientListNodeData;
begin
  Result := IsSelected;
  if Result then
    begin
      Data := FTree.GetNodeData(FTree.FocusedNode);
      AQuantity := Data.Quantity;
      AMeasure := Data.Measure;
      AIngredient := Data.Ingredient;
    end;
end;

procedure TIngredientListVisualizer.InitComponent;
begin
  FTree.OnGetNodeDataSize := OnGetNodeDataSize;
  FTree.OnGetText := OnGetText;
  FTree.OnFreeNode := OnFreeNode;
end;

function TIngredientListVisualizer.IsSelected: Boolean;
begin
  Result := Assigned(FTree.FocusedNode);
end;

procedure TIngredientListVisualizer.OnFreeNode(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
var
  Data: PIngredientListNodeData;
begin
  Data := FTree.GetNodeData(Node);
  Finalize(Data^);
end;

procedure TIngredientListVisualizer.OnGetNodeDataSize(Sender: TBaseVirtualTree;
  var NodeDataSize: Integer);
begin
  NodeDataSize := SizeOf(TIngredientListNodeData);
end;

procedure TIngredientListVisualizer.OnGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: string);
var
  Data: PIngredientListNodeData;
begin
  Data := FTree.GetNodeData(Node);
  if Assigned(Data) then
    begin
      case Column of
        0:
          if Data.Quantity > 0 then
            CellText := Data.Quantity.ToString
          else
            CellText := '';
        1:
          CellText := Data.Measure;
        2:
          CellText := Data.Ingredient;
      end;
    end;
end;

procedure TIngredientListVisualizer.RenderContent;
var
  Node: PVirtualNode;
  Data: PIngredientListNodeData;
  Ingredient: TIngredient;
begin
  for Ingredient in FList do
    begin
      Node := FTree.AddChild(nil);
      Data := FTree.GetNodeData(Node);
      Data.Quantity := Ingredient.Quantity;
      Data.Measure := Ingredient.Measure;
      Data.Ingredient := Ingredient.Ingredient;
    end;
end;

procedure TIngredientListVisualizer.SetIngredients(
  const AList: TIngredientsList);
begin
  FList := AList;
end;

procedure TIngredientListVisualizer.SetVirtualStringTree(
  const ATree: TVirtualStringTree);
begin
  FTree := ATree;
  InitComponent;
end;

initialization
  GlobalContainer.RegisterType<TCategoryVisualizer>.Implements<ICategoryVisualizer>;
  GlobalContainer.RegisterType<TRecipeListVisualizer>.Implements<IRecipeListVisualizer>;
  GlobalContainer.RegisterType<TRecipeDisplayVisualizer>.Implements<IRecipeDisplayVisualizer>;
  GlobalContainer.RegisterType<TIngredientListVisualizer>.Implements<IIngredientListVisualizer>;
end.
