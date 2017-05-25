unit dkrk.Comparers;

interface

uses
  System.SysUtils, System.Generics.Defaults,
  dkrk.Entities;

type
  TIngredientTemplateComparer = class(TComparer<TIngredientTemplate>)
  public
    function Compare(const Left, Right: TIngredientTemplate): Integer; override;
  end;

  TUnitTemplateComparer = class(TComparer<TUnitTemplate>)
  public
    function Compare(const Left, Right: TUnitTemplate): Integer; override;
  end;

implementation

{ TIngredientTemplateComparer }

function TIngredientTemplateComparer.Compare(const Left,
  Right: TIngredientTemplate): Integer;
begin
  Result := AnsiCompareText(Left.Name, Right.Name);
end;

{ TUnitTemplateComparer }

function TUnitTemplateComparer.Compare(const Left,
  Right: TUnitTemplate): Integer;
begin
  Result := AnsiCompareText(Left.Name, Right.Name);
end;

end.
