unit factorio_grid;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Math;

type
  BeltType = (Background, Belt, UndergroundBelt);

  TBelt = record
    btype: BeltType;
    dir: integer;
  end;

  fgrid = class
    procedure loadSprites();
    function SpriteStretch(PicIn: TPortableNetworkGraphic;
      sc: real): TPortableNetworkGraphic;

  public
    scale: real;
    grid: array of array of TBelt;
    constructor Create(Width, Height: integer);
    function draw(): TPortableNetworkGraphic;
    procedure resize(width:integer=-1,height:integer=-1;sc:real=-1);
  private
    BeltPicSize: integer;
    Belts: array of TPortableNetworkGraphic;
    Backgrounds: array of TPortableNetworkGraphic;
    BackgroundsNum: integer;
    Pic: TPortableNetworkGraphic;
  end;

implementation

constructor fgrid.Create(Width, Height: integer);
begin
  BeltPicSize := 32;
  scale := 0.25;
  SetLength(grid, Width, Height);
  Pic := TPortableNetworkGraphic.Create;
  Pic.Width := Math.floor(BeltPicSize * Scale) * Width;
  Pic.Height := Math.floor(BeltPicSize * Scale) * Height;
end;

function fgrid.SpriteStretch(PicIn: TPortableNetworkGraphic;
  sc: real): TPortableNetworkGraphic;
var
  m, n: integer;
  wo, ho: integer;
begin
  SpriteStretch := TPortableNetworkGraphic.Create;
  wo := Math.floor(PicIn.Width * sc);
  ho := Math.floor(PicIn.Height * sc);
  SpriteStretch.Width := wo;
  SpriteStretch.Height := ho;
  for m := 0 to wo do
  begin
    for n := 0 to ho do
    begin
      SpriteStretch.canvas.Pixels[m, n] :=
        PicIn.canvas.Pixels[Math.floor(m / sc), Math.floor(n / sc)];
    end;
  end;
end;



procedure fgrid.loadSprites();
var
  fnum: TStringList;
  i: integer;
begin
  fnum := FindAllFiles('./Belts');
  i := 0;
  while i < fnum.Count do
  begin
    SetLength(Belts, Length(Belts) + 1);
    Belts[i] := TPortableNetworkGraphic.Create;
    Belts[i].LoadFromFile(fnum.Strings[i]);
    Belts[i] := SpriteStretch(Belts[i], scale);
    i := i + 1;
  end;
  fnum.Free;
  fnum := FindAllFiles('./Background');
  i := 0;
  while i < fnum.Count do
  begin
    SetLength(Backgrounds, Length(Backgrounds) + 1);
    Backgrounds[i] := TPortableNetworkGraphic.Create;
    Backgrounds[i].LoadFromFile(fnum.Strings[i]);
    Backgrounds[i] := SpriteStretch(Backgrounds[i], scale);
    i := i + 1;
  end;
  BackgroundsNum := i;
  fnum.Free;
end;

function fgrid.draw(): TPortableNetworkGraphic;
var
  m, n: integer;
  x, y: integer;
begin
  for m := 0 to Length(grid) - 1 do
  begin
    for n := 0 to Length(grid[0]) - 1 do
    begin
      x := m * Math.floor(BeltPicSize * Scale);
      y := n * Math.floor(BeltPicSize * Scale);
      if (grid[m][n].btype = Belt) then
      begin

        Pic.canvas.draw(x, y, Belts[grid[m][n].dir]);
      end
      else
      begin
        Pic.canvas.draw(x, y, Backgrounds[random(BackgroundsNum)]);
      end;

    end;
  end;
  draw := Pic;
end;

procedure fgrid.resize(width:integer=-1,height:integer=-1;sc:real=-1);
begin

    if(sc>0)then
    begin
      scale:=sc;
    end;
    if(width>0)then
    begin
      SetLength(grid,width);
      Pic.Width := Math.floor(BeltPicSize * Scale) * width;
    end;
    if(height>0)then
    begin
      SetLength(grid,,height);
      Pic.Height := Math.floor(BeltPicSize * Scale) * height;
    end;
end;

end.
