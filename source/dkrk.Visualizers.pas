unit dkrk.Visualizers;

interface

uses
  System.SysUtils, System.Generics.Collections, System.Classes,
  Winapi.Windows,
  Vcl.Controls, Vcl.StdCtrls,
  HtmlView,
  dkrk.Entities, dkrk.Renderers;

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
  end;

  IRecipeListVisualizer = interface(IAbstractVisualizer)
    ['{DC949CBD-44B6-4B01-A332-7F5BC0B95980}']
    procedure SetListbox(const AListbox: TListbox);
    procedure SetRecipes(const ARecipes: TObjectList<TRecipe>);
  end;

  IRecipeDisplayVisualizer = interface(IAbstractVisualizer)
    ['{B1BD11EC-AFF6-4941-9E72-FF3E7677A262}']
    procedure SetHtmlViewer(const AHtmlViewer: THtmlViewer);
    procedure SetRecipe(const ARecipe: TRecipe);
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
  end;

{ TCategoryVisualizer }

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

initialization
  GlobalContainer.RegisterType<TCategoryVisualizer>.Implements<ICategoryVisualizer>;
  GlobalContainer.RegisterType<TRecipeListVisualizer>.Implements<IRecipeListVisualizer>;
  GlobalContainer.RegisterType<TRecipeDisplayVisualizer>.Implements<IRecipeDisplayVisualizer>;
end.
