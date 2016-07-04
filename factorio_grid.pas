unit factorio_grid;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Math;

type
  BeltType = (Background, Belt, UndergroundBelt,Obstacle);

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
    procedure resize(width:integer;height:integer;sc:real);
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
      if (grid[m][n].btype = UndergroundBelt) then
      begin
        Pic.canvas.draw(x, y, UBelts[grid[m][n].dir]);
      end
      else
      if (grid[m][n].btype = Obstacle)then
      begin
        Pic.canvas.draw(x, y, Obstacles[random(ObstaclesNum)]);
      end
      else
      begin
        Pic.canvas.draw(x, y, Backgrounds[random(BackgroundsNum)]);
      end;

    end;
  end;
  draw := Pic;
end;

procedure fgrid.resize(width:integer;height:integer;sc:real);
var
  i:integer;
begin

    if(sc>0)then
    begin

      for i:=0 to Length(OBelts)-1 do
      begin
        Belts[i] := SpriteStretch(OBelts[i], sc);
      end;
       for i:=0 to Length(OBelts)-1 do
      begin
        UBelts[i] := SpriteStretch(OUBelts[i], sc);
      end;
        for i:=0 to Length(OObstacles)-1 do
      begin
        Obstacles[i] := SpriteStretch(OObstacles[i], sc);
      end;
         for i:=0 to Length(OBackgrounds)-1 do
      begin
        Backgrounds[i] := SpriteStretch(OBackgrounds[i], sc);
      end;
      scale:=sc;

      Pic.Width := Math.floor(BeltPicSize * Scale) * Length(grid);
      Pic.Height := Math.floor(BeltPicSize * Scale) * Length(grid[0]);
    end;
    if(width>0)then
    begin
      SetLength(grid,width);
      Pic.Width := Math.floor(BeltPicSize * Scale) * width;
    end;
    if(height>0)then
    begin
      SetLength(grid,Length(grid),height);
      Pic.Height := Math.floor(BeltPicSize * Scale) * height;
    end;
end;

end.
