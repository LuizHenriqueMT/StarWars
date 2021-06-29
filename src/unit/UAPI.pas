unit UAPI;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo, System.Rtti,
  System.Bindings.Outputs, Fmx.Bind.Editors, Data.Bind.EngExt,
  Fmx.Bind.DBEngExt, Data.Bind.Components, REST.Types, REST.Client,
  Data.Bind.ObjectScope, FMX.StdCtrls, FMX.Edit, REST.Response.Adapter,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  Data.Bind.DBScope, FMX.ListView, FMX.Layouts, FMX.ListBox, FMX.Objects,
  FMX.Menus,IdHTTP, HTTPApp, System.StrUtils, System.Json, Rest.Json;

type
  TfrmAPI = class(TForm)
    listBoxAPI: TListBox;
    panelAPI: TPanel;
    groupBoxFilter: TGroupBox;
    StyleBook1: TStyleBook;
    ListView1: TListView;
    btnExecute: TButton;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    ListBoxInformation: TListBox;
    ListBoxItem1: TListBoxItem;
    edtFilterName: TEdit;
    btnCreateJson: TButton;
    Memo1: TMemo;
    btnReadJson: TButton;
    lbPlanetName: TLabel;
    edtFilterPopulation: TEdit;
    lbPlanetPopulation: TLabel;
    edtFilterClimate: TEdit;
    lbPlanetClimate: TLabel;
    btnFilter: TButton;
    SpeedButton1: TSpeedButton;
    procedure ListView1UpdateObjects(const Sender: TObject;
      const AItem: TListViewItem);

    procedure ShowDetails (Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnCreateJsonClick(Sender: TObject);
    procedure btnReadJsonClick(Sender: TObject);
    procedure btnFilterClick(Sender: TObject);
    procedure createItems(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    const
    //Tadu��o
    Arido= '�rido'; Temperado= 'Temperado'; Sombrio= 'Sombrio/Nublado';
    Congelado= 'Congelado'; Tropical= 'Tropical'; Desconhecido= 'Desconhecido';

    var
      ListBoxItemCreate: TListBoxItem;
  end;

var
  frmAPI: TfrmAPI;

implementation

{$R *.fmx}

uses UStarWars, UModulo;

procedure TfrmAPI.btnCreateJsonClick(Sender: TObject);
var
  jsonPedObj, jsonObjItem: TJSONObject;
  jsonArray: TJSONArray;
begin
  try
    //Instancias
    jsonPedObj:= TJSONObject.Create;
    jsonObjItem:= TJSONObject.Create;

    //Normal
    jsonPedObj.AddPair('nome', 'Luiz');
    jsonPedObj.AddPair('idade', TJSONNumber.Create(18));
    jsonPedObj.AddPair('altura', TJSONNumber.Create(1.80));

    //Instancias
    jsonArray:= TJSONArray.Create;

    //Array 1
    jsonObjItem.AddPair('produto', 'AAA');
    jsonObjItem.AddPair('descricao', 'Produto A');
    jsonObjItem.AddPair('qtde', TJSONNumber.Create(1));

    //Array 2
    jsonObjItem.AddPair('produto', 'BBB');
    jsonObjItem.AddPair('descricao', 'Produto B');
    jsonObjItem.AddPair('qtde', TJSONNumber.Create(3));

    jsonArray.AddElement(jsonObjitem);


    jsonPedObj.AddPair('itens', jsonArray);

    //Inserindo json no memo
    memo1.Lines.Add(jsonPedObj.ToString);

  finally
    jsonPedObj.DisposeOf;
  end;
end;

procedure TfrmAPI.btnReadJsonClick(Sender: TObject);
var
  jso : TJSONObject;
  jsop: TJSONPair;
  campoNome: string;
begin
  jso := TJsonObject.Create;
  campoNome:= memo1.Lines.Text;
  jso:= TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(campoNome), 0) as TJSONObject;


  for jsop in jso do
    begin
      if jsop.JsonString.Value = 'name' then
        showmessage (jsop.JsonValue.ToString);
    end;
  jso.disposeof;
end;


procedure TfrmAPI.createItems(Sender: TObject);
var
  nomePlaneta, populacao: string;
  I: integer;
begin
  //Data count
  for I:= 1 to (moduloREST.FDMemTable.RecordCount) do
    begin
      //Creating listBoxInformation items
          listBoxItemCreate:= TListBoxItem.Create(listBoxInformation);
          listboxItemCreate.Height:= 182;
          listboxItemCreate.Width:= 250;
          listboxItemCreate.Parent:= listBoxInformation;
          listboxItemCreate.StyleLookup:= 'ListBoxItem1Style2';
          listboxItemCreate.Margins.Right:= 10;
          listboxItemCreate.Margins.bottom:= 320;
          listboxItemCreate.Cursor:= crHandPoint;
          listBoxItemCreate.Selectable:= false;
          listBoxItemCreate.Text:= 'ItemCreate' + IntToStr(I);
          listboxItemCreate.OnClick:= ShowDetails;

      with moduloREST do
        begin
          //Adding planet name
          listBoxItemCreate.StylesData['lbTitle']:= FDMemTable.FieldByName('name').AsString;

          //Adding planet rotation
          listBoxItemCreate.StylesData['vlrRotationPeriod']:= FDMemTable.FieldByName('rotation_period').AsString;

          //Adding planet orbital
          listBoxItemCreate.StylesData['vlrOrbitalPeriod']:= (formatFloat('#,##0',strtofloat(FDMemTable.FieldByName('orbital_period').AsString)));

          //Adding planet diameter
          listBoxItemCreate.StylesData['vlrDiameter']:= FDMemTable.FieldByName('diameter').AsString;

          //Adding planet films

          //Translating and adding population of the planet
          if (FDMemTable.FieldByName('population').Value) = 'unknown' then
            begin
              listBoxItemCreate.StylesData['vlrPopulation']:= Desconhecido;


            end
          else
            begin
              populacao:= FDMemTable.FieldByName('population').AsString;
              listBoxItemCreate.StylesData['vlrPopulation']:= (formatFloat('#,##0',strtofloat(populacao)));
            end;

          //Translating and adding planet climate
          if (FDMemTable.FieldByName('climate').value) = 'arid' then
            begin
              listBoxItemCreate.StylesData['vlrClimate']:= Arido;
              listboxInformation.ListItems[I-1].ItemData.Bitmap.loadfromfile('../StarWars\icon\climate_arid.png');
            end
          else
          if (FDMemTable.FieldByName('climate').value) = 'temperate' then
            begin
              listBoxItemCreate.StylesData['vlrClimate']:= Temperado;
              listboxInformation.ListItems[I-1].ItemData.Bitmap.loadfromfile('../StarWars\icon\climate_temperate.png');
            end
          else
          if (FDMemTable.FieldByName('climate').value) = 'frozen' then
            begin
              listBoxItemCreate.StylesData['vlrClimate']:= Congelado;
              listboxInformation.ListItems[I-1].ItemData.Bitmap.loadfromfile('../StarWars\icon\climate_frozen.png');
            end
          else
          if (FDMemTable.FieldByName('climate').value) = 'murky' then
            begin
              listBoxItemCreate.StylesData['vlrClimate']:= Sombrio;
              listboxInformation.ListItems[I-1].ItemData.Bitmap.loadfromfile('../StarWars\icon\climate_murky.png');
            end
          else
          if (FDMemTable.FieldByName('climate').Value) = 'temperate, tropical' then
            begin
             listBoxItemCreate.StylesData['vlrClimate']:= Temperado + ', ' + Tropical;
             listboxInformation.ListItems[I-1].ItemData.Bitmap.loadfromfile('../StarWars\icon\climate_both.png');
            end;
        end;

      //Adding the item object created in the previous routine to the listBoxInformation
      listBoxInformation.AddObject(listBoxItemCreate);

      //Next column record
      moduloREST.FDMemTable.Next;
    end;
  listBoxInformation.EndUpdate;
end;

procedure TfrmAPI.btnFilterClick(Sender: TObject);
begin
  with moduloREST do
    begin
      if (edtFilterName.Text = '') and (edtFilterPopulation.Text = '') and
      (edtFilterClimate.Text = '') then
        begin
          //Initializing information of the listBoxInformation
          listBoxInformation.Clear;
          listBoxInformation.BeginUpdate;

          //Initializing request
          RESTClientFilter.BaseURL:= '';
          RESTClientFilter.BaseURL:= 'https://swapi.dev/api/';
          RESTRequest.Resource:= '';
          RESTRequest.Resource:= 'planets/';
          RESTRequest.Execute;
          FDMemTable.First;

          //Starts main action of creating items
          createItems(sender);
        end
      else
        begin
          //Initializing information of the listBoxInformation
          listBoxInformation.Clear;
          listBoxInformation.BeginUpdate;

          RESTClientFilter.BaseURL:= '';
          RESTClientFilter.BaseURL:= 'https://swapi.dev/api/';
          RESTRequest.Resource:= '';
          RESTRequest.Resource:= 'planets/?search={name}';
          RESTRequest.Params.ParameterByName('name').Value:= edtFilterName.Text;
          RESTRequest.Execute;
          FDMemTable.First;

          //Starts main action of creating items
          createItems(Sender);
        end;

    end;
end;

procedure TfrmAPI.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  //Destroying form
  Release;
  frmAPI:= nil;
end;

procedure TfrmAPI.ListView1UpdateObjects(const Sender: TObject;
  const AItem: TListViewItem);
var
  img: TListItemImage;
begin
  //Image resize
  with AItem do
    begin
      img:= TListItemImage(Objects.FindDrawable('Image5'));
      img.Width:= frmAPI.Width;
      img.Height:= frmAPI.Height;
    end;
end;

procedure TfrmAPI.ShowDetails(Sender: TObject);
var
  cont, I: integer;
  ItemCreate: string;
begin
  //Show more details
  for I:= 1 to (moduloREST.FDMemTable.RecordCount) do
    begin
      if (listBoxInformation.ListItems[I-1].Margins.bottom = 0) then
        begin
          listBoxInformation.ListItems[I-1].Margins.bottom:= 320;
          listBoxInformation.ListItems[I-1].StylesData['layRotationPeriod.Visible']:= false;
          listBoxInformation.ListItems[I-1].StylesData['layOrbitalPeriod.Visible']:= false;
          listBoxInformation.ListItems[I-1].StylesData['layDiameter.Visible']:= false;
          listBoxInformation.ListItems[I-1].StylesData['layFilms.Visible']:= false;
          listBoxInformation.ListItems[I-1].StylesData['layResident.Visible']:= false;
          frmAPI.UpdateStyleBook;
        end
      else
      if (listBoxInformation.Items[listBoxInformation.ItemIndex]) = 'ItemCreate' + IntToStr(I) then
        begin
          listBoxInformation.ListItems[I-1].Margins.bottom:= 0;
          listBoxInformation.ListItems[I-1].StylesData['layRotationPeriod.Visible']:= true;
          listBoxInformation.ListItems[I-1].StylesData['layOrbitalPeriod.Visible']:= true;
          listBoxInformation.ListItems[I-1].StylesData['layDiameter.Visible']:= true;
          listBoxInformation.ListItems[I-1].StylesData['layFilms.Visible']:= true;
          listBoxInformation.ListItems[I-1].StylesData['layResident.Visible']:= true;

          ItemCreate:= 'ItemCreate' + IntToStr(I);
          frmAPI.UpdateStyleBook;
        end;
    end;

end;

end.
