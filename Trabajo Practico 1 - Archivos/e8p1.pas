program e8p1;

uses
	crt;
	
const
	MAX_CARACTERES = 10;
	
type
	tArr = array [1..MAX_CARACTERES] of char;
	tCaracter = file of char;
	
////////////////////////////////////////////////////////////////////////

procedure mostrarArchivo(var archivo:tCaracter);
var
	letra:char;
begin
	reset(archivo);
	while not eof(archivo) do
		begin
			read(archivo, letra);
			writeln(letra);
		end;
end;

procedure invertirOrden(var archivo:tCaracter);
var
	indice:integer;
	estructuraAuxiliar:tArr;
	letra:char;
begin
	reset(archivo);
	indice:= MAX_CARACTERES;
	while not eof(archivo) do
		begin
			read(archivo, letra);
			estructuraAuxiliar[indice]:= letra;
			indice:= indice - 1;
		end;
	rewrite(archivo);
	for indice:=1 to MAX_CARACTERES do
		write(archivo, estructuraAuxiliar[indice]);
end;

procedure cargarArchivo(var archivo:tCaracter);
var
	contador:integer;
	letra:char;
begin
	contador:=0;
	writeln('INGRESE LOS CARACTERES QUE DESEA INSERTAR EN EL ARCHIVO');
	while (contador < MAX_CARACTERES) do
		begin
			readln(letra);
			write(archivo, letra);
			contador:=contador+1;
		end;
end;

procedure verificarExisteArchivo(var archivo:tCaracter; var error:boolean);
begin
	error:=false;
	{$i-}
	reset(archivo);
	{$i+}
	if (ioresult <> 0) then
		error:=true;
end;

////////////////////////////////////////////////////////////////////////

var
	archivo:tCaracter;
	error:boolean;
	
begin
	assign(archivo,'Caracteres.dat');
	verificarExisteArchivo(archivo, error);
	if (error) then
		begin
			rewrite(archivo);
			cargarArchivo(archivo);
		end;
	invertirOrden(archivo);
	mostrarArchivo(archivo);
	close(archivo);
end.
