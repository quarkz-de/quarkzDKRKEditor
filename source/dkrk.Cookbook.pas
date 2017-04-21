unit dkrk.Cookbook;

interface

uses
  System.SysUtils, System.Classes,
  Spring.Persistence.Core.DatabaseManager,
  Spring.Persistence.Core.ConnectionFactory,
  Spring.Persistence.Core.Session,
  Spring.Persistence.Core.Interfaces,
  Spring.Persistence.Adapters.SQLite;

type
  ICookbook = interface
    ['{2AB94E41-3B66-4F4D-B575-4A2F9CEABA3E}']
    function Load(const AFilename: String): Boolean;
    function SelectAndLoad: Boolean;
    procedure Close;
    function IsLoaded: Boolean;
    function GetSession: TSession;
    function GetFilename: String;
  end;

implementation

uses
  Vcl.Dialogs,
  Spring.Container,
  SQLiteTable3;

type
  TCookbook = class(TInterfacedObject, ICookbook)
  private
    FFilename: String;
    FConnection: IDBConnection;
    FDatabase: TSQLiteDatabase;
    FSession: TSession;
    procedure BuildDatabase;
  public
    constructor Create;
    destructor Destroy; override;
    function Load(const AFilename: String): Boolean;
    function SelectAndLoad: Boolean;
    procedure Close;
    function IsLoaded: Boolean;
    function GetSession: TSession;
    function GetFilename: String;
  end;

{$REGION 'TCookbook'}

procedure TCookbook.BuildDatabase;
var
  DBManager: TDatabaseManager;
begin
  DBManager := TDatabaseManager.Create(FConnection);
  try
    DBManager.BuildDatabase;
  finally
    DBManager.Free;
  end;
end;

procedure TCookbook.Close;
begin
  FreeAndNil(FSession);
  FreeAndNil(FDatabase);
  FFilename := '';
end;

constructor TCookbook.Create;
begin
  inherited;
  FDatabase := nil;
  FSession := nil;
end;

destructor TCookbook.Destroy;
begin
  Close;
  inherited;
end;

function TCookbook.GetFilename: String;
begin
  Result := FFilename;
end;

function TCookbook.GetSession: TSession;
begin
  Result := FSession;
end;

function TCookbook.IsLoaded: Boolean;
begin
  Result := FSession <> nil;
end;

function TCookbook.Load(const AFilename: String): Boolean;
begin
  if FileExists(AFilename) then
    begin
      Close;
      FDatabase := TSQLiteDatabase.Create(nil);
      FDatabase.Filename := AFilename;
      FConnection := TSQLiteConnectionAdapter.Create(FDatabase);
      FConnection.AutoFreeConnection := false;
      FConnection.Connect;
      FSession := TSession.Create(FConnection);

      BuildDatabase;

      FFilename := ExpandFilename(AFilename);
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
    begin
      Result := false;
      Close;
    end;
  Dialog.Free;
end;

{$ENDREGION}

initialization
  GlobalContainer.RegisterType<TCookbook>.Implements<ICookbook>.AsSingleton;
end.
