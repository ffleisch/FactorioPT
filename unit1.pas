unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, Math, factorio_grid;

type

  { TForm1 }


  TForm1 = class(TForm)
    Panel1: TPanel;
    Scale_inc: TButton;
    Scale_dec: TButton;
    procedure Panel1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Scale_decClick(Sender: TObject);
    procedure FormClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Scale_incClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;
  testbild: TPortableNetworkGraphic;
  g1:fgrid;
  scale: real;
  xoff,yoff:integer;


implementation

{$R *.lfm}

{ TForm1 }
procedure TForm1.FormCreate(Sender: TObject);
var
  i:integer;
  a,b:integer;
begin
  randomize();
  testbild := TPortableNetworkGraphic.Create;
  testbild.Width:=Panel1.Width;
  testbild.Height:=Panel1.Height;
  g1:=fgrid.Create(50,50);

  g1.loadSprites();

  for i:=0 to 100 do
  begin
       a:=random(50);
       b:=random(50);
  g1.grid[a][b].btype:=UndergroundBelt;
  g1.grid[a][b].dir:=random(3);
  end;
  for i:=0 to 100 do
  begin
       a:=random(50);
       b:=random(50);
  g1.grid[a][b].btype:=Belt;
  g1.grid[a][b].dir:=random(3);
  end;
  for i:=0 to 100 do
  begin
       a:=random(50);
       b:=random(50);
  g1.grid[a][b].btype:=Obstacle;
  end;

end;

procedure TForm1.Scale_incClick(Sender: TObject);
begin
  g1.resize(-1,-1,g1.scale*2);
end;

procedure TForm1.FormClick(Sender: TObject);
begin


end;

procedure TForm1.Scale_decClick(Sender: TObject);
begin
  g1.resize(-1,-1,g1.scale/2);
end;

procedure TForm1.Panel1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  hp:TPoint;
begin
  testbild.Width:=Panel1.Width;
  testbild.Height:=Panel1.Height;
  if ssMiddle in Shift then
  begin;
    hp:=g1.toGridCoord(X,Y,xoff,yoff,testbild);
    xoff:=hp.x;
    yoff:=hp.y;
  end;
  if ssRight in Shift then
  begin;
    hp:=g1.toGridCoord(X,Y,xoff,yoff,testbild);
    g1.grid[hp.x][hp.y].btype:=Background;
  end;
  Panel1.canvas.draw(0,0,g1.draw(xoff,yoff,testbild));
end;



end.
