unit factorio_grid;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,Math;

type
  BeltType = (Background,Belt,UndergroundBelt);
  TBelt = record
    btype:BeltType;
    dir: integer;
  end;
  fgrid=class
    procedure loadSprites();
    function SpriteStretch(PicIn: TPortableNetworkGraphic;
      sc: real): TPortableNetworkGraphic;
    public
      scale:real;
      grid:array of array of TBelt;
      Constructor Create(width,height:integer);
      function draw():TPortableNetworkGraphic;

    private
      BeltPicSize:integer;
      Belts: array of TPortableNetworkGraphic;
      Pic:TPortableNetworkGraphic;
  end;

implementation

constructor fgrid.Create(width,height:integer);
begin
     BeltPicSize:=32;
     scale:=1;
     SetLength(grid,width,height);
     Pic:=TPortableNetworkGraphic.Create;
     Pic.Width:=math.ceil(BeltPicSize*Scale)*width;
     Pic.Height:=math.ceil(BeltPicSize*Scale)*height;
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
end;

function fgrid.draw():TPortableNetworkGraphic;
var
  m,n:integer;
  x,y:integer;
begin
  for m:=0 to Length(grid)-1 do
  begin
    for n:=0 to Length(grid[0])-1 do
    begin
      if(grid[m][n].btype=Belt)then
      begin
        x:=m*math.floor(BeltPicSize*Scale);
        y:=n*math.floor(BeltPicSize*Scale);
        Pic.canvas.draw(x,y,Belts[grid[m][n].dir]);
      end;
    end;
  end;
  draw:=Pic;
end;
end.

