program e1p6;

uses
	crt;
	
const
	MAX_ELEMENTOS = 9;
	
type
	arInt = ^tArInt;
	tArInt = record
		num:integer;
		men:arInt;
		may:arInt;
	end;
	
	archivo = file of integer;
	
////////////////////////////////////////////////////////////////////////

procedure verificarExisteArchivo(var arch:archivo; var error:boolean);
begin
	{$i-}
	reset(arch);
	{$i+}
	if (ioresult <> 0) then
		error:=true;
end;

procedure cargarArchivo(var arch:archivo);
var
	contador:integer;
	num:integer;
begin
	contador:=0;
	writeln('INGRESE ELEMENTOS:');
	while (contador < MAX_ELEMENTOS) do
		 begin
			readln(num);
			write(arch, num);
			contador:=contador+1;
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

procedure cargarArbol(var arch:archivo; var arbol:arInt);
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

procedure imprimirAscendentemente(arbol:arInt);
begin
	if (arbol <> nil) then
		begin
			imprimirAscendentemente(arbol^.men);
			write(arbol^.num,' ');
			imprimirAscendentemente(arbol^.may);
		end;
end;

procedure imprimirDescendentemente(arbol:arInt);
begin
	if (arbol <> nil) then
		begin
			imprimirDescendentemente(arbol^.may);
			write(arbol^.num,' ');
			imprimirDescendentemente(arbol^.men);
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

procedure buscarMenor(arbol:arInt; var menor:integer);
begin
	if (arbol <> nil) then
		if (arbol^.num >= menor) then
			buscarMenor(arbol^.men, menor)
		else
			if (arbol^.num < menor) then
				menor:=arbol^.num;
end;

procedure calcularMayorRama(arbol:arInt; var longitud:integer; longActual:integer);
begin
	if (arbol <> nil) then
		begin
			calcularMayorRama(arbol^.men, longitud, longActual+1);
			if (longitud < longActual) then
				longitud:=longActual;
			calcularMayorRama(arbol^.may, longitud, longActual+1);
		end;
end;

function retornaCantidad(arbol:arInt):integer;
begin
	if (arbol = nil) then
		retornaCantidad:=0
	else
		retornaCantidad:=retornaCantidad(arbol^.men) + 1 + retornaCantidad(arbol^.may);
end;

procedure eliminarArbol(var arbol:arInt);
begin
	if (arbol <> nil) then
		begin
			eliminarArbol(arbol^.men);
			dispose(arbol);
			eliminarArbol(arbol^.may);
		end;
end;

////////////////////////////////////////////////////////////////////////

var
	arch:archivo;
	arbol:arInt;
	error:boolean;
	menor, longitud, longActual:integer;
begin
	error:=false;
	arbol:=nil;
	assign(arch,'enteros.dat');
	verificarExisteArchivo(arch, error);
	if (error) then
		begin
			rewrite(arch);
			cargarArchivo(arch);
		end;
	cargarArbol(arch, arbol);
	writeln('ARBOL ASCENDIENTEMENTE:');
	imprimirAscendentemente(arbol);
	writeln;
	writeln('ARBOL DESCENDIENTEMENTE:');
	imprimirDescendentemente(arbol);
	writeln;
	writeln('ARBOL PRE-ORDEN:');
	imprimirPreOrden(arbol);
	menor:=arbol^.num;
	buscarMenor(arbol, menor);
	writeln;
	writeln('EL MENOR ES:',menor);
	longActual:=0;
	longitud:=0;
	calcularMayorRama(arbol, longitud, longActual);
	writeln('LA MAYOR LONGITUD ES: ',longitud);
	writeln('LA CANTIDAD DE NODOS DEL ARBOL ES:', retornaCantidad(arbol));
	eliminarArbol(arbol);
	close(arch);
end.
