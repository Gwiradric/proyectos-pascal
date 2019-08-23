program final28;

uses
	crt;
	
type
	arInt = ^tArInt;
	tArInt = record
		num:integer;
		men:arInt;
		may:arInt;
	end;
	
	archInt = file of integer;
	
////////////////////////////////////////////////////////////////////////

procedure eliminarArbol(var arbol:arInt);
begin
	if (arbol <> nil) then
		begin
			eliminarArbol(arbol^.men);
			dispose(arbol);
			eliminarArbol(arbol^.may);
		end;
end;

procedure insertarNodo(var arbol:arInt; nodo:arInt);
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

procedure crearNodo(var nodo:arInt; num:integer);
begin
	new(nodo);
	nodo^.num:=num;
	nodo^.men:=nil;
	nodo^.may:=nil;
end;

procedure cargarArbol(var arch:archInt; var arbol:arInt);
var
	nodo:arInt;
	num:integer;
begin
	nodo:=nil;
	reset(arch);
	while not eof(arch) do
		begin
			read(arch, num);
			crearNodo(nodo, num);
			insertarNodo(arbol, nodo);
		end;
end;

function cantidadElementos(arbol:arInt):integer;
begin
	if (arbol = nil) then
		cantidadElementos:=0
	else
		cantidadElementos:=1 + cantidadElementos(arbol^.men) + cantidadElementos(arbol^.may);
end;

function sumaValores(arbol:arInt):integer;
begin
	if (arbol = nil) then
		sumaValores:=0
	else
		sumaValores:=arbol^.num +sumaValores(arbol^.men) + sumaValores(arbol^.may);
end;

procedure podar(var arbol:arInt; num:integer);
var
	cantidad, suma:integer;
begin
	if (arbol <> nil) then
		begin
			writeln('PADRE:', arbol^.num);
			suma:=sumaValores(arbol) - arbol^.num;
			cantidad:=cantidadElementos(arbol) - 1;
			if ((suma > 0) and (cantidad > 0)) then
				begin
					writeln('SUMA: ',suma,' / CANTIDAD: ',cantidad,' = ',suma div cantidad);
					if ((suma div cantidad) > num) then	
						begin
							writeln('BORRAR.');
							eliminarArbol(arbol);
							arbol:=nil;
						end
					else
						begin
							podar(arbol^.men, num);
							podar(arbol^.may, num);
						end;
				end;
		end;
end;

procedure imprimirPreOrden(arbol:arInt);
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
	arbNumeros:arInt;
	archivo:archInt;
	num:integer;
	
begin
	assign(archivo,'enteros.dat');
	reset(archivo);
	writeln('INGRESE EL NUMERO: ');
	readln(num);
	arbNumeros:=nil;
	cargarArbol(archivo, arbNumeros);
	podar(arbNumeros, num);
	writeln;
	writeln('ARBOL EN PRE-ORDER');
	imprimirPreOrden(arbNumeros);
	eliminarArbol(arbNumeros);
end.
