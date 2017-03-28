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
  dkrk.RecipeEditor in 'dkrk.RecipeEditor.pas' {wRecipeEditor};

{$R *.res}

begin
  GlobalContainer.Build;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TwMain, wMain);
  Application.CreateForm(TwCategoryEditor, wCategoryEditor);
  Application.CreateForm(TwRecipeEditor, wRecipeEditor);
  Application.Run;
end.
