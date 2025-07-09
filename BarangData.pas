unit barangdata;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, System.UITypes,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.Menus, 
  Data.DB, ZAbstractRODataset, ZAbstractDataset, ZDataset, ZAbstractConnection,
  ZConnection, BarangDataQuickReport;

type
  TF_BarangData = class(TForm)
    GroupBoxInputData: TGroupBox;
    ListViewData: TListView;
    LabelJenisData: TLabel;
    LabelNamaBarang: TLabel;
    ButtonBuat: TButton;
    ButtonHapus: TButton;
    ButtonUbah: TButton;
    ButtonBatal: TButton;
    ButtonKeluar: TButton;
    DateTimePicker: TDateTimePicker;
    LabelTanggalData: TLabel;
    ButtonPreview: TButton;
    ZConnection: TZConnection;
    ZQuery: TZQuery;
    ButtonSimpan: TButton;
    ComboBoxJenisData: TComboBox;
    EditJumblah: TEdit;
    LabelJumblah: TLabel;
    EditNamaBarang: TEdit;
    
    procedure FormCreate(Sender: TObject);

    
    procedure ButtonBuatClick(Sender: TObject);
    procedure ButtonHapusClick(Sender: TObject);
    procedure ButtonUbahClick(Sender: TObject);
    procedure ButtonBatalClick(Sender: TObject);
    procedure ButtonKeluarClick(Sender: TObject);
    procedure ButtonPreviewClick(Sender: TObject);
    procedure ButtonSimpanClick(Sender: TObject);

    
    procedure ListViewDataItemClick(Sender: TObject; Item: TListItem; Selected: Boolean);

    // sanitasi agar hanya angka yang dapat di input kepada EditJumblah
    procedure EditJumblahKeyPress(Sender: TObject; var Key: Char);
    
    procedure ConfigureMySQLConnection;
  private
    { Private declarations }
    FMode: string; 
    procedure SetStateAwal;
    procedure SetStateEdit;
    procedure SetStateInputBaru;
    procedure RefreshListView;
    procedure ClearFormFields;
  public
    { Public declarations }
  end;

var
  F_BarangData: TF_BarangData;

implementation

{$R *.dfm}

procedure TF_BarangData.EditJumblahKeyPress(Sender: TObject; var Key: Char);
begin
  if not CharInSet(Key, ['0'..'9', #8]) then
    Key := #0;
end;

procedure TF_BarangData.ClearFormFields;
begin
  ComboBoxJenisData.ItemIndex := -1;
  EditJumblah.Clear;
  EditNamaBarang.Clear;
  DateTimePicker.Date := Now; 
  ListViewData.Selected := nil; 
end;

procedure TF_BarangData.FormCreate(Sender: TObject);
begin
  ConfigureMySQLConnection;
  DateTimePicker.Date := Now;
  EditNamaBarang.Clear;
  ComboBoxJenisData.Items.Clear;
  ComboBoxJenisData.Items.Add('Barang Keluar'); // 0
  ComboBoxJenisData.Items.Add('Barang Masuk');   // 1
  ComboBoxJenisData.ItemIndex := -1;
  RefreshListView;
  ListViewData.OnSelectItem := ListViewDataItemClick;
  ListViewData.ReadOnly := True; // Prevent editing directly in ListView
  ListViewData.ViewStyle := vsReport;
  ListViewData.RowSelect := True;  
  ButtonBuat.OnClick := ButtonBuatClick;
  ButtonHapus.OnClick := ButtonHapusClick;
  ButtonUbah.OnClick := ButtonUbahClick;
  ButtonBatal.OnClick := ButtonBatalClick;
  ButtonKeluar.OnClick := ButtonKeluarClick;
  ButtonPreview.OnClick := ButtonPreviewClick;
  ButtonSimpan.OnClick := ButtonSimpanClick;
  EditJumblah.OnKeyPress := EditJumblahKeyPress;
  SetStateAwal;
end;

procedure TF_BarangData.ConfigureMySQLConnection;
begin
  ZConnection.HostName := 'localhost'; 
  ZConnection.Database := 'barangku'; 
  ZConnection.User := 'root'; 
  ZConnection.Password := ''; 
  ZConnection.Protocol := 'mysql'; 
  ZConnection.Port := 3306; 
  ZConnection.Connect;
  ZQuery.Connection := ZConnection;
  if not ZConnection.Connected then
    ShowMessage('Failed to connect to the database.');
end;

procedure TF_BarangData.SetStateAwal;
begin
  ButtonBuat.Enabled := True;
  ButtonSimpan.Enabled := False;
  ButtonUbah.Enabled := False;
  ButtonHapus.Enabled := False;
  ButtonBatal.Enabled := True;
  ButtonKeluar.Enabled := True;
  ButtonPreview.Enabled := True;
  ComboBoxJenisData.Enabled := False;
  EditJumblah.Enabled := False;
  EditNamaBarang.Enabled := False;
  ListViewData.Enabled := True; // Enable ListView for data selection
  ListViewData.Selected := nil; // Clear any selection
  ClearFormFields;
end;

procedure TF_BarangData.SetStateEdit;
begin
  ButtonBuat.Enabled := False;
  ButtonSimpan.Enabled := True;
  ButtonUbah.Enabled := True;
  ButtonHapus.Enabled := True;
  ButtonBatal.Enabled := True;
  ButtonKeluar.Enabled := True;
  ButtonPreview.Enabled := True;
  ComboBoxJenisData.Enabled := True;
  EditJumblah.Enabled := True;
  EditNamaBarang.Enabled := True;
  ListViewData.Enabled := False; // Disable ListView while inputting new data
end;

procedure TF_BarangData.SetStateInputBaru;
begin
  ButtonBuat.Enabled := False;
  ButtonSimpan.Enabled := True;
  ButtonUbah.Enabled := False;
  ButtonHapus.Enabled := False;
  ButtonBatal.Enabled := True;
  ButtonKeluar.Enabled := True;
  ButtonPreview.Enabled := False;
  ComboBoxJenisData.Enabled := True;
  EditJumblah.Enabled := True;
  EditNamaBarang.Enabled := True;
  ListViewData.Selected := nil; 
  ListViewData.Enabled := False; // Disable ListView while inputting new data
  ClearFormFields;
end;

// REVISI
procedure TF_BarangData.RefreshListView;
begin
  ListViewData.Clear;
  ZQuery.SQL.Text := 'SELECT * FROM barangdata ORDER BY tanggal DESC';
  ZQuery.Open;
  while not ZQuery.Eof do
  begin
    with ListViewData.Items.Add do
    begin
      Caption := FormatDateTime('d mmmm yyyy hh:nn:ss', ZQuery.FieldByName('tanggal').AsDateTime);
      if ZQuery.FieldByName('jenis_data').AsInteger = 0 then
        SubItems.Add('Barang Keluar')
      else
        SubItems.Add('Barang Masuk');
      SubItems.Add(ZQuery.FieldByName('nama_barang').AsString);
      SubItems.Add(ZQuery.FieldByName('jumlah').AsString);
      Data := Pointer(ZQuery.FieldByName('id_data').AsInteger);
    end;
    ZQuery.Next;
  end;
  ZQuery.Close;
end;

procedure TF_BarangData.ButtonBuatClick(Sender: TObject);
begin
  FMode := 'create';
  SetStateInputBaru;
end;

procedure TF_BarangData.ButtonSimpanClick(Sender: TObject);
var
  jenisTransaksi: Integer;
begin
  if (ComboBoxJenisData.ItemIndex = -1) or
     (EditJumblah.Text = '') or
     (EditNamaBarang.Text = '') then
  begin
    ShowMessage('Silakan lengkapi semua data yang wajib diisi.');
    Exit;
  end;
  if not ZConnection.Connected then
  begin
    ShowMessage('Koneksi ke database belum berhasil.');
    Exit;
  end;
  jenisTransaksi := ComboBoxJenisData.ItemIndex; // 0: Barang Keluar, 1: Barang Masuk
  try
    if FMode = 'create' then
    begin
      ZQuery.SQL.Text := 'INSERT INTO barangdata (tanggal, jenis_data, nama_barang, jumlah) VALUES (NOW(), :jenis_data, :nama_barang, :jumlah)';
      ZQuery.ParamByName('jenis_data').AsInteger := jenisTransaksi;
      ZQuery.ParamByName('nama_barang').AsString := EditNamaBarang.Text;
      ZQuery.ParamByName('jumlah').AsString := EditJumblah.Text;
      ZQuery.ExecSQL;
      ShowMessage('Data keuangan berhasil ditambahkan.');
    end
    else if (FMode = 'edit') and (ListViewData.Selected <> nil) then
    begin
      ZQuery.SQL.Text := 'UPDATE barangdata SET jenis_data = :jenis_data, nama_barang = :nama_barang, jumlah = :jumlah WHERE id_data = :id_data';
      ZQuery.ParamByName('jenis_data').AsInteger := jenisTransaksi;
      ZQuery.ParamByName('nama_barang').AsString := EditNamaBarang.Text;
      ZQuery.ParamByName('jumlah').AsString := EditJumblah.Text;
      ZQuery.ParamByName('id_data').AsInteger := Integer(ListViewData.Selected.Data);
      ZQuery.ExecSQL;
      ShowMessage('Data keuangan berhasil diubah.');
    end;
    RefreshListView;
    SetStateAwal;
    FMode := '';
  except
    on E: Exception do
      ShowMessage('Gagal menyimpan data keuangan: ' + E.Message);
  end;
end;

procedure TF_BarangData.ButtonHapusClick(Sender: TObject);
begin
  
  if ListViewData.Selected = nil then
  begin
    ShowMessage('Silakan pilih data keuangan yang ingin dihapus.');
    Exit;
  end;

  if not ZConnection.Connected then
  begin
    ShowMessage('Koneksi ke database belum berhasil.');
    Exit;
  end;

  if MessageDlg('Apakah Anda yakin ingin menghapus data ini?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    try
      ZQuery.SQL.Text := 'DELETE FROM barangdata WHERE id_data = :id';
      ZQuery.ParamByName('id').AsInteger := Integer(ListViewData.Selected.Data);
      ZQuery.ExecSQL;
      ShowMessage('Data keuangan berhasil dihapus.');
      RefreshListView;
      SetStateAwal;
    except
      on E: Exception do
        ShowMessage('Gagal menghapus data keuangan: ' + E.Message);
    end;
  end;
end;

procedure TF_BarangData.ButtonUbahClick(Sender: TObject);
begin
  if ListViewData.Selected = nil then
  begin
    ShowMessage('Silakan pilih data keuangan yang ingin diubah.');
    Exit;
  end;
  FMode := 'edit';
  SetStateEdit;
end;

procedure TF_BarangData.ButtonPreviewClick(Sender: TObject);
var
  LFinanceReport: TF_BarangkuQuickReport;
begin
  LFinanceReport := TF_BarangkuQuickReport.Create(Self);
  try
    LFinanceReport.GenerateReport(DateTimePicker.Date);
  finally
    LFinanceReport.Free;
  end;
end;

procedure TF_BarangData.ListViewDataItemClick(Sender: TObject; Item: TListItem; Selected: Boolean);
begin
  
  if Selected then
  begin
    if Item.SubItems[0] = 'Barang Keluar' then
      ComboBoxJenisData.ItemIndex := 0
    else if Item.SubItems[0] = 'Barang Masuk' then
      ComboBoxJenisData.ItemIndex := 1
    else
      ComboBoxJenisData.ItemIndex := -1;
    EditNamaBarang.Text := Item.SubItems[1];
    EditJumblah.Text := Item.SubItems[2];
    ButtonUbah.Enabled := True;
    ButtonHapus.Enabled := True;
  end
  else
  begin
    ButtonUbah.Enabled := False;
    ButtonHapus.Enabled := False;
  end;
end;

procedure TF_BarangData.ButtonBatalClick(Sender: TObject);
begin  
  ClearFormFields;
  SetStateAwal;
end;

procedure TF_BarangData.ButtonKeluarClick(Sender: TObject);
begin  
  Application.Terminate;
end;

end.