program StarWars;

uses
  System.StartUpCopy,
  FMX.Forms,
  UStarWars in 'unit\UStarWars.pas' {frmStarWars},
  UModulo in 'unit\UModulo.pas' {ModuloREST: TDataModule},
  UAPI in 'unit\UAPI.pas' {frmAPI};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmStarWars, frmStarWars);
  Application.CreateForm(TModuloREST, ModuloREST);
  Application.CreateForm(TfrmAPI, frmAPI);
  Application.Run;
end.
