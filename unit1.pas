unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs;

type

  { TForm1 }
  TSprites=record
    pics:array of TPortableNetworkgraphic;
  end;

  TForm1 = class(TForm)
    procedure FormClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure loadSprites();
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;
  testbild:TPortableNetworkGraphic;
implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormClick(Sender: TObject);
begin
    loadSprites();
    Form1.canvas.draw(32,32,testbild);
    //Form1.Canvas.Line(10,10,10,20);
end;

procedure TForm1.loadSprites();
var
  fnum:TStringList;
begin
     fnum:=FindAllFiles();
     testbild.LoadFromFile('./Belts/Belt_Down.png') ;

end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  testbild:=TPortableNetworkGraphic.create;
end;

end.
