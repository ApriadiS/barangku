program BarangKu;

uses
  Vcl.Forms,
  BarangData in 'BarangData.pas' {F_BarangData},
  BarangDataQuickReport in 'BarangDataQuickReport.pas' {F_BarangkuQuickReport};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TF_BarangData, F_BarangData);
  Application.CreateForm(TF_BarangkuQuickReport, F_BarangkuQuickReport);
  Application.Run;
end.
