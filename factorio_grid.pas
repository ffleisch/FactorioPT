unit factorio_grid;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Math;

type
  BeltType = (Background, Belt, UndergroundBelt, Obstacle);

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
    function draw(gridx, gridy: integer;
      bild: TPortableNetworkGraphic): TPortableNetworkGraphic;
    function toGridCoord(x, y, gridx, gridy: integer; bild: TPortableNetworkGraphic): TPoint;
    procedure resize(Width: integer; Height: integer; sc: real);
  private

    BeltPicSize: integer;
    OObstacles: array of TPortableNetworkGraphic;
    OBelts: array of TPortableNetworkGraphic;
    OUBelts: array of TPortableNetworkGraphic;
    OBackgrounds: array of TPortableNetworkGraphic;
    Obstacles: array of TPortableNetworkGraphic;
    Belts: array of TPortableNetworkGraphic;
    UBelts: array of TPortableNetworkGraphic;
    Backgrounds: array of TPortableNetworkGraphic;
    BackgroundsNum: integer;

    ObstaclesNum: integer;
    Pic: TPortableNetworkGraphic;
  end;

implementation

constructor fgrid.Create(Width, Height: integer);
begin
  BeltPicSize := 32;
  scale := 0.5;
  SetLength(grid, Width, Height);
  Pic := TPortableNetworkGraphic.Create;
  Pic.Width := Math.floor(BeltPicSize * scale) * Width;
  Pic.Height := Math.floor(BeltPicSize * scale) * Height;
end;

function fgrid.SpriteStretch(PicIn: TPortableNetworkGraphic;
  sc: real): TPortableNetworkGraphic;
var
  m, n: integer;
  wo, ho: integer;
begin
  SpriteStretch := TPortableNetworkGraphic.Create;
  wo := Math.floor(BeltPicSize * sc);
  ho := Math.floor(BeltPicSize * sc);
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
    SetLength(OBelts, Length(OBelts) + 1);
    SetLength(Belts, Length(Belts) + 1);
    OBelts[i] := TPortableNetworkGraphic.Create;
    Belts[i] := TPortableNetworkGraphic.Create;
    OBelts[i].LoadFromFile(fnum.Strings[i]);
    Belts[i] := SpriteStretch(OBelts[i], scale);
    i := i + 1;
  end;
  fnum.Free;
  fnum := FindAllFiles('./Underground_Belts');
  i := 0;
  while i < fnum.Count do
  begin
    SetLength(OUBelts, Length(OUBelts) + 1);
    SetLength(UBelts, Length(UBelts) + 1);
    OUBelts[i] := TPortableNetworkGraphic.Create;
    UBelts[i] := TPortableNetworkGraphic.Create;
    OUBelts[i].LoadFromFile(fnum.Strings[i]);
    UBelts[i] := SpriteStretch(OUBelts[i], scale);
    i := i + 1;
  end;
  fnum.Free;
  fnum := FindAllFiles('./Background');
  i := 0;
  while i < fnum.Count do
  begin
    SetLength(OBackgrounds, Length(OBackgrounds) + 1);
    SetLength(Backgrounds, Length(Backgrounds) + 1);
    OBackgrounds[i] := TPortableNetworkGraphic.Create;
    Backgrounds[i] := TPortableNetworkGraphic.Create;
    OBackgrounds[i].LoadFromFile(fnum.Strings[i]);
    Backgrounds[i] := SpriteStretch(OBackgrounds[i], scale);
    i := i + 1;
  end;
  BackgroundsNum := i;
  fnum.Free;
  fnum := FindAllFiles('./Obstacle');
  i := 0;
  while i < fnum.Count do
  begin
    SetLength(OObstacles, Length(OObstacles) + 1);
    SetLength(Obstacles, Length(Obstacles) + 1);
    OObstacles[i] := TPortableNetworkGraphic.Create;
    Obstacles[i] := TPortableNetworkGraphic.Create;
    OObstacles[i].LoadFromFile(fnum.Strings[i]);
    Obstacles[i] := SpriteStretch(OObstacles[i], scale);
    i := i + 1;
  end;
  ObstaclesNum := i;
  fnum.Free;
end;

function fgrid.toGridCoord(x, y, gridx, gridy: integer; bild: TPortableNetworkGraphic): TPoint;
begin
  ;
  toGridCoord.x := Math.floor((x-(bild.Width / 2) ) / (BeltPicSize * scale)) + gridx;
  toGridCoord.y := Math.floor((y-(bild.Height / 2) ) / (BeltPicSize * scale)) + gridy;
end;

function fgrid.draw(gridx, gridy: integer;
  bild: TPortableNetworkGraphic): TPortableNetworkGraphic;
var
  m, n: integer;
  x, y: integer;
  xmax, ymax: integer;
  Height, Width: integer;
  mx, my: integer;
  px, py: integer;
begin
  Height := bild.Height;
  Width := bild.Width;
  bild.canvas.brush.color := clBlack;
  bild.canvas.fillRect(0, 0, Width, Height);
  xmax := Math.ceil(Width / (BeltPicSize * scale));
  ymax := Math.ceil(Height / (BeltPicSize * scale));
  mx := Math.floor(Length(grid) / 2);
  my := Math.floor(Length(grid[0]) / 2);
  for m := 0 to xmax do
  begin
    for n := 0 to ymax do
    begin
      x := m * Math.floor(BeltPicSize * scale);
      y := n * Math.floor(BeltPicSize * scale);
      px := m + gridx - Math.ceil((xmax / 2));
      py := n + gridy - Math.ceil((ymax / 2));
      if ((px >= 0) and (px < Length(grid)) and (py >= 0) and (py < Length(grid[0]))) then
      begin
        if (grid[px][py].btype = Belt) then
        begin
          bild.canvas.draw(x, y, Belts[grid[px][py].dir]);
        end
        else
        if (grid[px][py].btype = UndergroundBelt) then
        begin
          bild.canvas.draw(x, y, UBelts[grid[px][py].dir]);
        end
        else
        if (grid[px][py].btype = Obstacle) then
        begin
          bild.canvas.draw(x, y, Obstacles[random(ObstaclesNum)]);
        end
        else
        begin
          bild.canvas.draw(x, y, Backgrounds[random(BackgroundsNum)]);
        end;

      end;

    end;
  end;
  draw := bild;
end;

procedure fgrid.resize(Width: integer; Height: integer; sc: real);
var
  i: integer;
begin

  if (sc > 0) then
  begin

    for i := 0 to Length(OBelts) - 1 do
    begin
      Belts[i] := SpriteStretch(OBelts[i], sc);
    end;
    for i := 0 to Length(OBelts) - 1 do
    begin
      UBelts[i] := SpriteStretch(OUBelts[i], sc);
    end;
    for i := 0 to Length(OObstacles) - 1 do
    begin
      Obstacles[i] := SpriteStretch(OObstacles[i], sc);
    end;
    for i := 0 to Length(OBackgrounds) - 1 do
    begin
      Backgrounds[i] := SpriteStretch(OBackgrounds[i], sc);
    end;
    scale := sc;

    Pic.Width := Math.floor(BeltPicSize * Scale) * Length(grid);
    Pic.Height := Math.floor(BeltPicSize * Scale) * Length(grid[0]);
  end;
  if (Width > 0) then
  begin
    SetLength(grid, Width);
    Pic.Width := Math.floor(BeltPicSize * Scale) * Width;
  end;
  if (Height > 0) then
  begin
    SetLength(grid, Length(grid), Height);
    Pic.Height := Math.floor(BeltPicSize * Scale) * Height;
  end;
end;

end.
