object F_BarangData: TF_BarangData
  Left = 0
  Top = 0
  Caption = 'BarangKu'
  ClientHeight = 389
  ClientWidth = 884
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  TextHeight = 15
  object GroupBoxInputData: TGroupBox
    Left = 8
    Top = 8
    Width = 865
    Height = 376
    Caption = 'INPUT DATA'
    TabOrder = 0
    object LabelJenisData: TLabel
      Left = 15
      Top = 31
      Width = 52
      Height = 15
      Caption = 'Jenis Data'
    end
    object LabelNamaBarang: TLabel
      Left = 15
      Top = 60
      Width = 72
      Height = 16
      Caption = 'Nama Barang'
    end
    object LabelJumblah: TLabel
      Left = 15
      Top = 92
      Width = 45
      Height = 17
      Caption = 'Jumblah'
    end
    object LabelTanggalData: TLabel
      Left = 15
      Top = 314
      Width = 69
      Height = 15
      Caption = 'Tanggal Data'
    end
    object ListViewData: TListView
      Left = 318
      Top = 28
      Width = 531
      Height = 333
      Columns = <
        item
          AutoSize = True
          Caption = 'Tanggal'
        end
        item
          AutoSize = True
          Caption = 'Jenis Data'
        end
        item
          AutoSize = True
          Caption = 'Nama Barang'
        end
        item
          AutoSize = True
          Caption = 'Jumblah Barang'
        end>
      ReadOnly = True
      RowSelect = True
      TabOrder = 10
      TabStop = False
      ViewStyle = vsReport
    end
    object ButtonBuat: TButton
      Left = 156
      Top = 124
      Width = 75
      Height = 25
      Caption = 'Buat'
      TabOrder = 2
    end
    object ButtonHapus: TButton
      Left = 156
      Top = 155
      Width = 75
      Height = 25
      Caption = 'Hapus'
      TabOrder = 4
    end
    object ButtonUbah: TButton
      Left = 237
      Top = 124
      Width = 75
      Height = 25
      Caption = 'Ubah'
      TabOrder = 3
    end
    object ButtonBatal: TButton
      Left = 237
      Top = 155
      Width = 75
      Height = 25
      Caption = 'Batal'
      TabOrder = 5
    end
    object ButtonKeluar: TButton
      Left = 237
      Top = 186
      Width = 75
      Height = 25
      Caption = 'Keluar'
      TabOrder = 7
    end
    object ButtonSimpan: TButton
      Left = 156
      Top = 186
      Width = 75
      Height = 25
      Caption = 'Simpan'
      TabOrder = 6
    end
    object ComboBoxJenisData: TComboBox
      Left = 127
      Top = 28
      Width = 185
      Height = 23
      Style = csDropDownList
      TabOrder = 0
    end
    object EditJumblah: TEdit
      Left = 127
      Top = 89
      Width = 185
      Height = 25
      TabOrder = 1
    end
    object ButtonPreview: TButton
      Left = 216
      Top = 335
      Width = 96
      Height = 25
      Caption = 'Preview'
      TabOrder = 9
    end
    object DateTimePicker: TDateTimePicker
      Left = 15
      Top = 335
      Width = 186
      Height = 25
      Date = 45838.000000000000000000
      Format = 'dd-MMMM-yyyy'
      Time = 0.986119849534588900
      TabOrder = 8
    end
    object EditNamaBarang: TEdit
      Left = 127
      Top = 57
      Width = 185
      Height = 24
      TabOrder = 11
    end
  end
  object ZConnection: TZConnection
    ControlsCodePage = cCP_UTF16
    Catalog = ''
    DisableSavepoints = False
    HostName = ''
    Port = 0
    Database = ''
    User = ''
    Password = ''
    Protocol = ''
    Left = 72
    Top = 136
  end
  object ZQuery: TZQuery
    Params = <>
    Left = 24
    Top = 136
  end
end
