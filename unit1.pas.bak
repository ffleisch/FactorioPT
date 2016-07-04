unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Math,factorio_grid;

type

  { TForm1 }


  TForm1 = class(TForm)
    procedure FormClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
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
begin
  g1:=fgrid.Create(40,40);
  g1.loadSprites();
  g1.grid[2][2].btype:=Belt;
  g1.grid[2][3].btype:=Belt;
  g1.grid[2][4].btype:=Belt;
  g1.grid[2][2].dir:=2;
  g1.grid[2][3].dir:=3;
  g1.grid[2][4].dir:=1;
  testbild := TPortableNetworkGraphic.Create;
end;

procedure TForm1.FormClick(Sender: TObject);
begin
  //loadSprites();
  Form1.canvas.draw(0,0,g1.draw());
  //Form1.Canvas.Line(10,10,10,20);
end;



end.
