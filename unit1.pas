unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Math, factorio_grid;

type

  { TForm1 }


  TForm1 = class(TForm)
    Scale_inc: TButton;
    Scale_dec: TButton;
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

implementation

{$R *.lfm}

{ TForm1 }
procedure TForm1.FormCreate(Sender: TObject);
var
  i:integer;
  a,b:integer;
begin
  randomize();
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
  testbild := TPortableNetworkGraphic.Create;
end;

procedure TForm1.Scale_incClick(Sender: TObject);
begin
  g1.resize(-1,-1,g1.scale*2);
end;

procedure TForm1.FormClick(Sender: TObject);
begin
  //loadSprites();
  Form1.canvas.draw(0,0,g1.draw());
  //Form1.Canvas.Line(10,10,10,20);
end;

procedure TForm1.Scale_decClick(Sender: TObject);
begin
  g1.resize(-1,-1,g1.scale/2);
end;



end.
