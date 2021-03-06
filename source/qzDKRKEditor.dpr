program qzDKRKEditor;

uses
  Vcl.Forms,
  Spring.Container,
  dkrk.Main in 'dkrk.Main.pas' {wMain},
  dkrk.Cookbook in 'dkrk.Cookbook.pas' {dmSession: TDataModule},
  dkrk.Entities in 'dkrk.Entities.pas',
  dkrk.Ingredients in 'dkrk.Ingredients.pas',
  dkrk.Visualizers in 'dkrk.Visualizers.pas',
  dkrk.Renderers in 'dkrk.Renderers.pas',
  dkrk.CategoryEditor in 'dkrk.CategoryEditor.pas' {wCategoryEditor},
  dkrk.RecipeEditor in 'dkrk.RecipeEditor.pas' {wRecipeEditor},
  dkrk.DataModule in 'dkrk.DataModule.pas' {dmGlobal: TDataModule},
  dkrk.DragDropHandler in 'dkrk.DragDropHandler.pas',
  dkrk.Exporter in 'dkrk.Exporter.pas';

{$R *.res}

begin
  GlobalContainer.Build;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'quarkzDKRKEditor';
  Application.CreateForm(TdmGlobal, dmGlobal);
  Application.CreateForm(TwMain, wMain);
  Application.Run;
end.
