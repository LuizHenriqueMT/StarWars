unit UStarWars;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.Controls.Presentation, FMX.StdCtrls, REST.Types, REST.Client,
  Data.Bind.Components, Data.Bind.ObjectScope, FMX.ScrollBox, FMX.Memo,
  FMX.Objects, System.ImageList, FMX.ImgList;

type
  TfrmStarWars = class(TForm)
    layPrincipal: TLayout;
    layPlanet: TLayout;
    layFilms: TLayout;
    layCharacter: TLayout;
    layCenter: TLayout;
    shapeCharacter: TRoundRect;
    btnCharacter: TRectangle;
    lbCharacter: TText;
    btnFilms: TRectangle;
    shapeFilms: TRoundRect;
    lbFilms: TText;
    btnPlanets: TRectangle;
    shapePlanets: TRoundRect;
    lbPlanets: TText;
    procedure btnCharacterClick(Sender: TObject);
    procedure abrirFormAPI(Sender: TObject);
    procedure btnPlanetsClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmStarWars: TfrmStarWars;

implementation

{$R *.fmx}

uses UAPI, UModulo;

procedure TfrmStarWars.abrirFormAPI(Sender: TObject);
begin
  //Creating "frmAPI" form
  frmAPI:= TfrmAPI.Create(application);
  frmAPI.Show;
end;

procedure TfrmStarWars.btnCharacterClick(Sender: TObject);
begin
  abrirFormAPI(Sender);

  //Execute Character Request
end;

procedure TfrmStarWars.btnPlanetsClick(Sender: TObject);
begin
  abrirFormAPI(Sender);

  with moduloREST do
    begin
      //Initializing information of the listBoxInformation
      frmAPI.listBoxInformation.Clear;
      frmAPI.listBoxInformation.BeginUpdate;

      //Execute Planets Request
      RESTClientFilter.BaseURL:= 'https://swapi.dev/api/';
      RESTRequest.Resource:= 'planets/';
      RESTRequest.Execute;

      FDMemTable.Active:= true;
      FDMemTable.Open;
      FDMemTable.First;
      frmAPI.createItems(sender);

      frmAPI.groupBoxFilter.Visible:= true;
    end;
end;

end.
