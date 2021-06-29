unit UModulo;

interface

uses
  System.SysUtils, System.Classes, REST.Types, REST.Client,
  Data.Bind.Components, Data.Bind.ObjectScope, REST.Response.Adapter,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FireDAC.Stan.StorageBin,
  Data.FMTBcd, Data.SqlExpr;

type
  TModuloREST = class(TDataModule)
    RESTClient: TRESTClient;
    RESTRequest: TRESTRequest;
    RESTResponse: TRESTResponse;
    RESTResponseDataSetAdapter: TRESTResponseDataSetAdapter;
    FDMemTable: TFDMemTable;
    FDMemTablename: TWideStringField;
    FDMemTablerotation_period: TWideStringField;
    FDMemTableorbital_period: TWideStringField;
    FDMemTablediameter: TWideStringField;
    FDMemTableclimate: TWideStringField;
    FDMemTablegravity: TWideStringField;
    FDMemTableterrain: TWideStringField;
    FDMemTablesurface_water: TWideStringField;
    FDMemTablepopulation: TWideStringField;
    FDMemTableresidents: TWideStringField;
    FDMemTablefilms: TWideStringField;
    FDMemTablecreated: TWideStringField;
    FDMemTableedited: TWideStringField;
    FDMemTableurl: TWideStringField;
    RESTRequestFilter: TRESTRequest;
    RESTResponseFilter: TRESTResponse;
    RESTClientFilter: TRESTClient;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ModuloREST: TModuloREST;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

end.
