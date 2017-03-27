unit dkrk.Cookbook;

interface

uses
  System.SysUtils, System.Classes,
  dorm;

type
  ICookbook = interface
    ['{2AB94E41-3B66-4F4D-B575-4A2F9CEABA3E}']
    function Load(const AFilename: String): Boolean;
    function SelectAndLoad: Boolean;
    procedure Close;
    function IsLoaded: Boolean;
    function GetSession: TSession;
  end;

implementation

uses
  Vcl.Dialogs,
  Spring.Container,
  dorm.commons,
  qzLib.Core.DormConfigBuilder;

type
  TCookbook = class(TInterfacedObject, ICookbook)
  private
    FDormSession: TSession;
  public
    constructor Create;
    destructor Destroy; override;
    function Load(const AFilename: String): Boolean;
    function SelectAndLoad: Boolean;
    procedure Close;
    function IsLoaded: Boolean;
    function GetSession: TSession;
  end;

{ TCookbook }

procedure TCookbook.Close;
begin
  FreeAndNil(FDormSession);
end;

constructor TCookbook.Create;
begin
  inherited;
  FDormSession := nil;
end;

destructor TCookbook.Destroy;
begin
  Close;
  inherited;
end;

function TCookbook.GetSession: TSession;
begin
  Result := FDormSession;
end;

function TCookbook.IsLoaded: Boolean;
begin
  Result := FDormSession <> nil;
end;

function TCookbook.Load(const AFilename: String): Boolean;
var
  Reader: TTextReader;
  Builder: IDormConfigBuilder;
begin
  if FileExists(AFilename) then
    begin
      Close;
      Builder := TDormSQLiteConfigBuilder.Create(AFilename);
      Reader := TStringReader.Create(Builder.BuildConfig);
{$ifdef DEBUG}
      FDormSession := TSession.CreateConfigured(Reader, TdormEnvironment.deDevelopment);
{$else}
      FDormSession := TSession.CreateConfigured(Reader, TdormEnvironment.deRelease);
{$endif}
      Result := true;
    end
  else
    begin
      Result := SelectAndLoad;
    end;
end;

function TCookbook.SelectAndLoad: Boolean;
var
  Dialog: TOpenDialog;
begin
  Dialog := TOpenDialog.Create(nil);
  Dialog.Filter := 'SQLite-Dateien (*.db;*sqlite;*.sqlite3)|*.db;*.sqlite;*.sqlite3|Alle Dateien (*.*)|*.*';
  Dialog.DefaultExt := 'db';
  Dialog.Filename := 'kochbuch.db';
  Dialog.Options := [ofHideReadOnly, ofFileMustExist, ofEnableSizing];
  if Dialog.Execute then
    Result := Load(Dialog.Filename)
  else
    Result := false;
  Dialog.Free;
end;

initialization
  GlobalContainer.RegisterType<TCookbook>.Implements<ICookbook>.AsSingleton;
end.
