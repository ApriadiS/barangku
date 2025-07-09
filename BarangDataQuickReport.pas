unit BarangDataQuickReport;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, QuickRpt, QRCtrls, Vcl.ExtCtrls,
  ZAbstractConnection, ZConnection, Data.DB, ZAbstractRODataset,
  ZAbstractDataset, ZDataset;

type
  TF_BarangkuQuickReport = class(TForm)
    QuickRep: TQuickRep;
    TitleBand1: TQRBand;
    DetailBand1: TQRBand;
    LabelTitle: TQRLabel;
    Shape1: TShape;
    Shape2: TShape;
    Shape3: TShape;
    Shape4: TShape;
    QRLabelTanggal: TQRLabel;
    QRLabelJenisData: TQRLabel;
    QRLabelNamaBarang: TQRLabel;
    QRLabelJumlah: TQRLabel;
    Shape5: TShape;
    Shape6: TShape;
    Shape7: TShape;
    Shape8: TShape;
    QRDBText1: TQRDBText;
    QRDBText2: TQRDBText;
    QRDBText3: TQRDBText;
    QRDBText4: TQRDBText;
    ZQuery: TZQuery;
    ZConnection: TZConnection;
  private
    { Private declarations }
    procedure ConnectionSetup;
    procedure QuerySetup(ATanggal: TDateTime);
    procedure DetailBandSetup;

  public
    { Public declarations }
    procedure GenerateReport(ATanggal: TDateTime);


  end;

var
  F_BarangkuQuickReport: TF_BarangkuQuickReport;

implementation

{$R *.dfm}

procedure TF_BarangkuQuickReport.ConnectionSetup;
begin
  ZConnection.HostName := 'localhost';
  ZConnection.Database := 'barangku';
  ZConnection.User := 'root';
  ZConnection.Password := '';
  ZConnection.Protocol := 'mysql';
  ZConnection.Port := 3306;
  ZConnection.Connect;
  ZQuery.Connection := ZConnection;
  QuickRep.DataSet := ZQuery;
end;

procedure TF_BarangkuQuickReport.QuerySetup(ATanggal: TDateTime);
begin
  ZQuery.SQL.Text :=
    'SELECT tanggal, ' +
    'CASE WHEN jenis_data = 0 THEN ''Barang Keluar'' ELSE ''Barang Masuk'' END AS jenis_data_str, ' +
    'jumlah, nama_barang ' +
    'FROM barangdata WHERE DATE(tanggal) = :tanggal';
  ZQuery.ParamByName('tanggal').AsDate := ATanggal;
  ZQuery.Open;
end;

procedure TF_BarangkuQuickReport.GenerateReport(ATanggal: TDateTime);
begin
  ConnectionSetup;
  DetailBandSetup;
  QuerySetup(ATanggal);

  if ZQuery.IsEmpty then
  begin
    ShowMessage('Tidak ada data untuk tanggal yang dipilih.');
    Exit;
  end;

  QuickRep.Preview;
end;

procedure TF_BarangkuQuickReport.DetailBandSetup;
begin
  QRDBText1.DataSet := ZQuery;
  QRDBText2.DataSet := ZQuery;
  QRDBText3.DataSet := ZQuery;
  QRDBText4.DataSet := ZQuery;
  QRDBText1.DataField := 'tanggal';
  QRDBText2.DataField := 'jenis_data_str';
  QRDBText3.DataField := 'nama_barang';
  QRDBText4.DataField := 'jumlah';
  QRDBText1.Mask := 'd mmmm yyyy hh:nn:ss';
end;

end.