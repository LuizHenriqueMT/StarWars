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
  FMX.Menus,IdHTTP, HTTPApp, System.StrUtils, System.Json, Rest.Json,
  System.ImageList, FMX.ImgList;

type
  TfrmAPI = class(TForm)
    panelAPI: TPanel;
    groupBoxFilter: TGroupBox;
    StyleBook1: TStyleBook;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    ListBoxInformation: TListBox;
    edtFilterName: TEdit;
    lbPlanetName: TLabel;
    edtFilterPopulation: TEdit;
    lbPlanetPopulation: TLabel;
    edtFilterClimate: TEdit;
    lbPlanetClimate: TLabel;
    btnFilter: TButton;
    btnNext: TSpeedButton;
    btnClear: TButton;
    LinkFillControlToField1: TLinkFillControlToField;
    btnPrevious: TSpeedButton;
    ImageList1: TImageList;
    ListBoxItem1: TListBoxItem;

    procedure ShowDetails (Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnFilterClick(Sender: TObject);
    procedure createItems(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure btnPreviousClick(Sender: TObject);
    procedure TranslateClimate_BR(Sender: Tobject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }

  public
    { Public declarations }

    const
    //Tadu??o
    Arido= '?rido'; Temperado= 'Temperado'; Sombrio= 'Sombrio/Nublado';
    Congelado= 'Congelado'; Tropical= 'Tropical'; Desconhecido= 'Desconhecido';

    var
      ListBoxItemCreate: TListBoxItem;
      pagina, contPagina: integer;
  end;

var
  frmAPI: TfrmAPI;

implementation

{$R *.fmx}

uses UStarWars, UModulo;

procedure TfrmAPI.btnClearClick(Sender: TObject);
begin
  //Clear fields (edit) values
  edtFilterName.Text:= '';
  edtFilterPopulation.Text:= '';
  edtFilterClimate.Text:= '';

  listBoxInformation.Clear;
  listBoxInformation.BeginUpdate;

  //Execute Planets Request
  moduloREST.RESTClientFilter.BaseURL:= 'https://swapi.dev/api/';
  moduloREST.RESTRequest.Resource:= 'planets/';
  moduloREST.RESTRequest.Execute;

  moduloREST.FDMemTable.Active:= true;
  moduloREST.FDMemTable.Open;
  moduloREST.FDMemTable.First;
  createItems(sender);
end;

procedure TfrmAPI.createItems(Sender: TObject);
var
  nomePlaneta, dir: string;
  ambos: TStringList;
  I: Integer;
begin
  //icon directory
  dir:= '../StarWars\icon\';

  with moduloREST do
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

          //Adding planet name
          listBoxItemCreate.StylesData['lbTitle']:= FDMemTable.FieldByName('name').AsString;

          //Translating and adding population of the planet

          //Adding unknown planet population
          if (FDMemTable.FieldByName('population').Value) = 'unknown' then
            begin
              listBoxItemCreate.StylesData['vlrPopulation']:= Desconhecido;
            end
          else
            begin
              listBoxItemCreate.StylesData['vlrPopulation']:=
              (formatFloat('#,##0',strtofloat(FDMemTable.FieldByName('population').AsString)));
            end;

          //Adding unknown planet rotation
          if (FDMemTable.FieldByName('rotation_period').Value) = 'unknown' then
            begin
              listBoxItemCreate.StylesData['vlrRotationPeriod']:= Desconhecido;
            end
          else
            begin
              listBoxItemCreate.StylesData['vlrRotationPeriod']:=
              FDMemTable.FieldByName('rotation_period').AsString;
            end;

          //Adding unknown planet orbital
          if (FDMemTable.FieldByName('orbital_period').Value) = 'unknown' then
            begin
              listBoxItemCreate.StylesData['vlrOrbitalPeriod']:= Desconhecido;
            end
          else
            begin
              listBoxItemCreate.StylesData['vlrOrbitalPeriod']:=
              (formatFloat('#,##0',strtofloat(FDMemTable.FieldByName('orbital_period').AsString)));
            end;

          //Adding unknown planet diameter
          if (FDMemTable.FieldByName('diameter').Value) = 'unknown' then
            begin
              listBoxItemCreate.StylesData['diameter']:= Desconhecido;
            end
          else
            begin
              listBoxItemCreate.StylesData['vlrDiameter']:=
              (formatFloat('#,##0',strtofloat(FDMemTable.FieldByName('diameter').AsString)));
            end;

          //Translating and adding planet climate
          TranslateClimate_BR(Sender);

          //Adding climate icons
          try
            if pos(',',FDMemTable.FieldByName('climate').AsString) <> 0 then
              begin
                listboxInformation.ListItems[I-1].ItemData.Bitmap.loadfromfile(dir + 'climate_both.png');
              end
            else
              begin
                listboxInformation.ListItems[I-1].ItemData.Bitmap.loadfromfile
                (dir + 'climate_' + FDMemTable.FieldByName('climate').AsString + '.png');
              end;
          except on
            E: EFOpenError do

          end;

          //Adding the item object created in the previous routine to the listBoxInformation
          listBoxInformation.AddObject(listBoxItemCreate);

          //Next column record
          FDMemTable.Next;
        end;
    end;

  //Ending updates
  listBoxInformation.EndUpdate;
end;

procedure TfrmAPI.btnFilterClick(Sender: TObject);
var
  I,con: Integer;
begin
  with moduloREST do
    begin
      RESTClientFilter.BaseURL:= 'https://swapi.dev/api/';
      RESTRequest.Resource:= 'planets/';
      RESTRequest.Execute;

      FDMemTable.Active:= true;
      FDMemTable.Open;
      FDMemTable.First;

      if (edtFilterName.Text = '') and (edtFilterPopulation.Text = '') and
      (edtFilterClimate.Text = '') then
        begin
          //Initializing information of the listBoxInformation
          listBoxInformation.Clear;
          listBoxInformation.BeginUpdate;

          //Initializing request
          RESTRequest.Resource:= 'planets/';
          RESTRequest.Execute;
          FDMemTable.First;

          //Starts main action of creating items
          createItems(sender);
        end
      else
      if (edtFilterName.Text <> '') or (edtFilterPopulation.Text <> '') or
      (edtFilterClimate.Text <> '') then
        begin
          //Initializing information of the listBoxInformation
          listBoxInformation.Clear;
          listBoxInformation.BeginUpdate;

          //Verify that all fields match the search
          con:=FDMemTable.RecordCount;
          for I:= 1 to FDMemTable.RecordCount do
            begin
              if ((edtFilterName.text = FDMemTable.FieldByName('name').Value) or
              (edtFilterPopulation.Text = FDMemTable.FieldByName('population').value)) or
              (edtFilterClimate.Text = FDMemTable.FieldByName('Climate').value) then
                begin
                  if (edtFilterName.Text = FDMemTable.FieldByName('name').Value) then
                    begin
                      RESTRequest.Resource:= '';
                      RESTRequest.Resource:= 'planets/?search={name}';
                      RESTRequest.Params.ParameterByName('name').Value:= edtFilterName.Text;
                      RESTRequest.Execute;

                      //Starts main action of creating items
                      createItems(Sender);
                    end
                  else
                  if (edtFilterPopulation.Text = FDMemTable.FieldByName('population').value) then
                    begin
                      RESTRequest.Resource:= '';
                      RESTRequest.Resource:= 'planets/?search={population}';
                      RESTRequest.Params.ParameterByName('population').Value:= edtFilterName.Text;
                      RESTRequest.Execute;

                      //Starts main action of creating items
                      createItems(Sender);
                    end
                  else
                  if (edtFilterClimate.Text = FDMemTable.FieldByName('Climate').value) then
                    begin
                      RESTRequest.Resource:= '';
                      RESTRequest.Resource:= 'planets/?search={climate}';
                      RESTRequest.Params.ParameterByName('climate').Value:= edtFilterName.Text;
                      RESTRequest.Execute;

                      //Starts main action of creating items
                      createItems(Sender);
                    end;
                  exit
                end
              else
                showmessage ('Nenhum planeta foi encontrado!');
            end;
        end
      else
        begin
          showmessage ('Nenhum planeta foi encontrado!');
        end;
    end;
end;

procedure TfrmAPI.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  //Destroying form
  Release;
  frmAPI:= nil;
end;

procedure TfrmAPI.FormCreate(Sender: TObject);
begin
  pagina:= 1;
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
      if ((listBoxInformation.Items[listBoxInformation.ItemIndex]) = 'ItemCreate' + IntToStr(I)) then
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

procedure TfrmAPI.TranslateClimate_BR(Sender: Tobject);
var
  I: Integer;
  clima: array [1..13] of string;
begin
  with moduloREST do
    begin
      //Data count
      for I:= 1 to (moduloREST.FDMemTable.RecordCount) do
        begin
          clima[I]:= FDMemTable.FieldByName('climate').AsString;

          if FDMemTable.FieldByName('climate').AsString = clima[I] then
            begin
              clima[I]:= AnsiReplaceText(clima[I], 'arid','?rido');
              clima[I]:= AnsiReplaceText(clima[I], 'temperate','Temperado');
              clima[I]:= AnsiReplaceText(clima[I], 'murky','Sombrio/Nublado');
              clima[I]:= AnsiReplaceText(clima[I], 'windy','Ventoso');
              clima[I]:= AnsiReplaceText(clima[I], 'hot','Calor');
              clima[I]:= AnsiReplaceText(clima[I], 'artificial temperate ','Temperatura Artificial ');
              clima[I]:= AnsiReplaceText(clima[I], 'tropical','Tropical');
              clima[I]:= AnsiReplaceText(clima[I], 'frozen','Gelado');
              clima[I]:= AnsiReplaceText(clima[I], 'frigid','Congelado');
              clima[I]:= AnsiReplaceText(clima[I], 'humid','?mido');
              clima[I]:= AnsiReplaceText(clima[I], 'moist','?mido');
              clima[I]:= AnsiReplaceText(clima[I], 'polluted','Polu?do');
              clima[I]:= AnsiReplaceText(clima[I], 'superheated','Superaquecido');
              clima[I]:= AnsiReplaceText(clima[I], 'subartic','Sub?rtico');
              clima[I]:= AnsiReplaceText(clima[I], 'polluted','Polu?do');
              clima[I]:= AnsiReplaceText(clima[I], 'artic','?rtico');
              clima[I]:= AnsiReplaceText(clima[I], 'rocky','Rochoso');
              clima[I]:= AnsiReplaceStr(clima[I], 'unknown','Desconhecido');

              listBoxItemCreate.StylesData['vlrClimate']:= clima[I];
            end;
        end;
    end;
end;

procedure TfrmAPI.btnNextClick(Sender: TObject);
begin
  with moduloREST do
    begin
      btnPrevious.Enabled:= true;
      pagina:= pagina + 1;

      //Initializing information of the listBoxInformation
      listBoxInformation.Clear;
      listBoxInformation.BeginUpdate;
      RESTClient.BaseURL:= '';
      RESTRequest.Resource:= '';

      if (pagina = 1) then
        begin
          btnPrevious.Enabled:= false;
        end
      else
      if (pagina = 6) then
        begin
          btnNext.Enabled:= false;
        end;

      if (pagina >= 1) and (pagina <= 6) then
        begin
          RESTClient.BaseURL:= 'https://swapi.dev/api/';
          RESTRequest.Resource:= 'planets/?page=' + intToStr(pagina);
          RESTRequest.Execute;

          FDMemTable.Active:= true;
          FDMemTable.Open;
          FDMemTable.First;
          createItems(Sender);
        end;
    end;
end;

procedure TfrmAPI.btnPreviousClick(Sender: TObject);
begin
  with moduloREST do
    begin
      btnNext.Enabled:= true;
      pagina:= pagina - 1;

      //Initializing information of the listBoxInformation
      listBoxInformation.Clear;
      listBoxInformation.BeginUpdate;
      RESTClient.BaseURL:= '';
      RESTRequest.Resource:= '';

      if (pagina = 1) then
        begin
          btnPrevious.Enabled:= false;
        end;

      if (pagina >= 1) and (pagina <= 6) then
        begin
          RESTClient.BaseURL:= 'https://swapi.dev/api/';
          RESTRequest.Resource:= 'planets/?page=' + intToStr(pagina);
          RESTRequest.Execute;

          FDMemTable.Active:= true;
          FDMemTable.Open;
          FDMemTable.First;
          createItems(Sender);
        end;
    end;
end;

end.
