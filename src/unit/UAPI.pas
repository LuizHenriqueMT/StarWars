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
  FMX.Menus,IdHTTP, HTTPApp, System.StrUtils;

type
  TfrmAPI = class(TForm)
    listBoxAPI: TListBox;
    panelAPI: TPanel;
    GroupBox1: TGroupBox;
    StyleBook1: TStyleBook;
    ListView1: TListView;
    Executar: TButton;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    ListBoxInformation: TListBox;
    ListBoxItem1: TListBoxItem;
    Edit1: TEdit;
    procedure ListView1UpdateObjects(const Sender: TObject;
      const AItem: TListViewItem);
    procedure ExecutarClick(Sender: TObject);

    procedure ShowDetails (Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
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

procedure TfrmAPI.ExecutarClick(Sender: TObject);
var
  nomePlaneta, populacao: string;
  I: integer;
begin
  //Initializing information of the listBoxInformation
  listBoxInformation.Clear;
  listBoxInformation.BeginUpdate;

  //Initializing request
  moduloREST.RESTRequest.Execute;
  modulOREST.FDMemTable.First;

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
          listboxItemCreate.Margins.bottom:= 150;
          listboxItemCreate.Cursor:= crHandPoint;
          listBoxItemCreate.Selectable:= false;
          listBoxItemCreate.Text:= 'ItemCreate' + IntToStr(I);
          listboxItemCreate.OnClick:= ShowDetails;

      with moduloREST do
        begin
          //Adding planet's name
          listBoxItemCreate.StylesData['lbTitle']:= FDMemTable.FieldByName('name').AsString;

          //Translating and adding population of the planet
          if (FDMemTable.FieldByName('population').Value) = 'unknown' then
            listBoxItemCreate.StylesData['vlrPopulation']:= Desconhecido
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
begin
  ShowMessage(listBoxInformation.Items[listBoxInformation.ItemIndex]);

  if (listBoxInformation.Items[listBoxInformation.ItemIndex]) = 'ItemCreate1' then
    begin
      showmessage ('kdsoakdo');
      listBoxInformation.ItemByIndex(1).Margins.Bottom:= 0;
    end;

end;

end.
