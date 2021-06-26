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
  FMX.Menus;

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
    procedure ListView1UpdateObjects(const Sender: TObject;
      const AItem: TListViewItem);
    procedure ExecutarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
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
  nomePlaneta: string;
begin
  listBoxInformation.Clear;
  listBoxInformation.BeginUpdate;

  with moduloREST do
    begin
      RESTRequest.Execute;
      FDMemTable.First;

      while not (FDMemTable.Eof) do
        begin
          listBoxItemCreate:= TListBoxItem.Create(listBoxInformation);
          listBoxItemCreate.Height:= 182;
          listBoxItemCreate.Width:= 185;
          listBoxItemCreate.Parent:= listBoxInformation;
          listBoxItemCreate.StyleLookup:= 'ListBoxItem1Style2';



        end;
    end;


  {with listview1.Items.Add do
    begin
      TListItemText(Objects.FindDrawable('nomePlaneta')).Text:= descricao;
    end;}
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

end.
