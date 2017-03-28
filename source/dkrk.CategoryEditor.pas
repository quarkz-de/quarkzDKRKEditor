unit dkrk.CategoryEditor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls,
  dkrk.Entities;

type
  TwCategoryEditor = class(TForm)
    txBezeichnung: TLabel;
    edBezeichnung: TEdit;
    btOk: TButton;
    btCancel: TButton;
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    function Execute(const ACategory: TCategory): Boolean;
    class function ExecuteDialog(const ACategory: TCategory): Boolean;
  end;

var
  wCategoryEditor: TwCategoryEditor;

implementation

{$R *.dfm}

{ TwCategoryEditor }

function TwCategoryEditor.Execute(const ACategory: TCategory): Boolean;
begin
  edBezeichnung.Text := ACategory.Name;
  Result := ShowModal = mrOk;
  if Result then
    ACategory.Name := edBezeichnung.Text;
end;

class function TwCategoryEditor.ExecuteDialog(const ACategory: TCategory): Boolean;
var
  Dialog: TwCategoryEditor;
begin
  Dialog := TwCategoryEditor.Create(nil);
  try
    Result := Dialog.Execute(ACategory);
  finally
    Dialog.Free;
  end;
end;

end.
