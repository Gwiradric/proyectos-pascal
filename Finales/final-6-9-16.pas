program final69;

uses
	crt;
	
const
	MAX_ELEMENTOS = 6;
	
type
	puntInt = ^tPuntInt;
	tPuntInt = record
		num:integer;
		men:puntInt;
		may:puntInt;
	end;
	
	archInt = file of integer;
	
////////////////////////////////////////////////////////////////////////

procedure verificarExisteArchivo(var archivo:archInt; var error:boolean);
begin
	{$i-}
	reset(archivo);
	{$i+}
	if (ioresult <> 0) then
		error:=true;
end;

procedure cargarArchivo(var archivo:archInt);
var
	contador, num:integer;
begin
	writeln('INGRESE LOS ELEMENTOS AL ARCHIVO:');
	contador:=0;
	while (contador < MAX_ELEMENTOS) do
		begin
			readln(num);
			write(archivo, num);
			contador:=contador+1;
		end;
end;

procedure crearNodo(var nodo:puntInt; num:integer);
begin
	new(nodo);
	nodo^.num:=num;
	nodo^.men:=nil;
	nodo^.may:=nil;
end;

procedure insertarNodo(var arbol:puntInt; nodo:puntInt);
begin
	if (arbol = nil) then
		arbol:=nodo
	else
		if (arbol^.num > nodo^.num) then
			insertarNodo(arbol^.men, nodo)
		else
			if (arbol^.num < nodo^.num) then
				insertarNodo(arbol^.may, nodo);
end;

procedure cargarArbol(var archivo:archInt; var arbol:puntInt);
var
	num:integer;
	nodo:puntInt;
begin
	reset(archivo);
	nodo:=nil;
	while not eof(archivo) do
		begin
			read(archivo, num);
			crearNodo(nodo, num);
			insertarNodo(arbol, nodo);
		end;
end;

function sumaDerecha(arbol:puntInt):integer;
begin
	if (arbol = nil) then
		sumaDerecha:=0
	else
		sumaDerecha:=sumaDerecha(arbol^.men)+arbol^.num+sumaDerecha(arbol^.may);
end;

procedure recorrerInOrder(arbol:puntInt; var suma:integer; sumaHijoDerecha:integer);
begin
	if (arbol <> nil) then
		begin
			recorrerInOrder(arbol^.men, suma, sumaHijoDerecha);
			suma:=suma + arbol^.num;
			sumaHijoDerecha:=sumaDerecha(arbol^.may);
			if (suma = sumaHijoDerecha) then
				write(arbol^.num,' ');
			recorrerInOrder(arbol^.may, suma, sumaHijoDerecha);
		end;
end;

procedure imprimirPreOrden(arbol:puntInt);
begin
	if (arbol <> nil) then
		begin
			write(arbol^.num,' ');
			imprimirPreOrden(arbol^.men);
			imprimirPreOrden(arbol^.may);
		end;
end;

////////////////////////////////////////////////////////////////////////

var
	arbol:puntInt;
	archivo:archInt;
	error:boolean;
	suma:integer;
	sumaHijoDerecha:integer;
	
begin
	suma:=0;
	sumaHijoDerecha:=0;
	arbol:=nil;
	error:=false;
	assign(archivo,'archFinal6-9.dat');
	verificarExisteArchivo(archivo, error);
	if (error) then
		begin
			rewrite(archivo);
			cargarArchivo(archivo);
		end;
	writeln;
	writeln('ARBOL PRE-ORDER:');
	cargarArbol(archivo, arbol);
	imprimirPreOrden(arbol);
	writeln;
	writeln('ELEMENTOS:');
	recorrerInOrder(arbol, suma, sumaHijoDerecha);
	close(archivo);
end.
