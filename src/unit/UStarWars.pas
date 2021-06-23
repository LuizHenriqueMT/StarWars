unit UStarWars;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.Controls.Presentation, FMX.StdCtrls, REST.Types, REST.Client,
  Data.Bind.Components, Data.Bind.ObjectScope, FMX.ScrollBox, FMX.Memo;

type
  TfrmStarWars = class(TForm)
    SpeedButton1: TSpeedButton;
    RESTClient1: TRESTClient;
    RESTRequest1: TRESTRequest;
    RESTResponse1: TRESTResponse;
    laySelectPlanet: TLayout;
    laySelectFilms: TLayout;
    laySelectPeoples: TLayout;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmStarWars: TfrmStarWars;

implementation

{$R *.fmx}

procedure TfrmStarWars.Button1Click(Sender: TObject);
begin
  RESTRequest1.execute;
  memo1.Text:= RESTResponse1.Content;

end;

end.
