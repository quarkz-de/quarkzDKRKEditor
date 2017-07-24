unit dkrk.DataModule;

interface

uses
  Winapi.Windows, Winapi.CommCtrl,
  System.SysUtils, System.Classes, System.ImageList,
  Vcl.ImgList, Vcl.Controls, Vcl.Graphics, Vcl.Forms;

type
  TdmGlobal = class(TDataModule)
    ilImages: TImageList;
    highDPIImageListContainer: TImageList;
    procedure DataModuleCreate(Sender: TObject);
  private
    procedure ResizeImageListImagesforHighDPI(const AImgList: TImageList);
  public
  end;

var
  dmGlobal: TdmGlobal;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TdmGlobal.DataModuleCreate(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to ComponentCount -1 do
    if Components[I] is TImageList then
      ResizeImageListImagesforHighDPI(TImageList(Components[I]));
end;

procedure TdmGlobal.ResizeImageListImagesforHighDPI(const AImgList: TImageList);
var
  DevImgSize, I: Integer;
  mb, ib, sib, smb: TBitmap;
begin
  // Original Code unter:
  // http://zarko-gajic.iz.hr/resizing-delphis-timagelist-bitmaps-to-fit-high-dpi-scaling-size-for-menus-toolbars-trees-etc/

  if Screen.PixelsPerInch = 96 then Exit;

  DevImgSize := AImgList.Width;

  highDPIImageListContainer.Clear;
  highDPIImageListContainer.Width := DevImgSize;
  highDPIImageListContainer.Height := DevImgSize;

  for I := 0 to AImgList.Count - 1 do
    highDPIImageListContainer.AddImage(AImgList, I);

  AImgList.SetSize(MulDiv(DevImgSize, Screen.PixelsPerInch, 96),
    MulDiv(DevImgSize, Screen.PixelsPerInch, 96));

  for I := 0 to highDPIImageListContainer.Count -1 do
    begin
      sib := TBitmap.Create;
      smb := TBitmap.Create;
      try
        sib.Width := AImgList.Width;
        sib.Height := AImgList.Height;
        sib.Canvas.FillRect(sib.Canvas.ClipRect);
        smb.Width := AImgList.Width;
        smb.Height := AImgList.Height;
        smb.Canvas.FillRect(smb.Canvas.ClipRect);

        ib := TBitmap.Create;
        mb := TBitmap.Create;
        try
          ib.Width := DevImgSIZE;
          ib.Height := DevImgSIZE;
          ib.Canvas.FillRect(ib.Canvas.ClipRect);

          mb.Width := DevImgSIZE;
          mb.Height := DevImgSIZE;
          mb.Canvas.FillRect(mb.Canvas.ClipRect);

          ImageList_DrawEx(highDPIImageListContainer.Handle, I, ib.Canvas.Handle, 0, 0, ib.Width, ib.Height, CLR_NONE, CLR_NONE, ILD_NORMAL);
          ImageList_DrawEx(highDPIImageListContainer.Handle, I, mb.Canvas.Handle, 0, 0, mb.Width, mb.Height, CLR_NONE, CLR_NONE, ILD_MASK);

          if Screen.PixelsPerInch * 100 / 96 <= 150 then
            begin
              sib.Canvas.Draw((sib.Width - ib.Width) DIV 2, (sib.Height - ib.Height) DIV 2, ib);
              smb.Canvas.Draw((smb.Width - mb.Width) DIV 2, (smb.Height - mb.Height) DIV 2, mb);
            end
          else
            begin
              sib.Canvas.StretchDraw(Rect(0, 0, sib.Width, sib.Width), ib);
              smb.Canvas.StretchDraw(Rect(0, 0, smb.Width, smb.Width), mb);
            end;
        finally
          ib.Free;
          mb.Free;
        end;

        AImgList.Add(sib, smb);
      finally
        sib.Free;
        smb.Free;
      end;
    end;
end;

end.
