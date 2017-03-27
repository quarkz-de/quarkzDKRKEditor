program qzDKRKEditor;



uses
  Vcl.Forms,
  Spring.Container,
  dkrk.Main in 'dkrk.Main.pas' {Form1},
  dkrk.Cookbook in 'dkrk.Cookbook.pas' {dmSession: TDataModule},
  dkrk.Entities in 'dkrk.Entities.pas',
  dkrk.Ingredients in 'dkrk.Ingredients.pas',
  dkrk.Visualizers in 'dkrk.Visualizers.pas',
  dkrk.Renderers in 'dkrk.Renderers.pas';

{$R *.res}

begin
  GlobalContainer.Build;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
