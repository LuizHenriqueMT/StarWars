program StarWars;

uses
  System.StartUpCopy,
  FMX.Forms,
  UStarWars in 'unit\UStarWars.pas' {frmStarWars},
  UModulo in 'unit\UModulo.pas' {DataModule2: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmStarWars, frmStarWars);
  Application.CreateForm(TDataModule2, DataModule2);
  Application.Run;
end.
