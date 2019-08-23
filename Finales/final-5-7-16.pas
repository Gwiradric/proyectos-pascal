program final57;

uses
	crt;

type
	puntCiudades = ^tPuntCiudades;
	tPuntCiudades = record
		ciudad:string;
		provincia:string;
		cantidadHabitantes:integer;
		menores:puntCiudades;
		mayores:puntCiudades;
	end;
	
	puntPoblacion = ^tPuntPoblacion;
	tPuntPoblacion = record
		provincia:string;
		cantidadHabitantesAcumulada:integer;
		sig:puntPoblacion;
	end;
	
	archCiudades = file of tPuntCiudades;

////////////////////////////////////////////////////////////////////////

procedure verificarExisteArchivo(var archivo:archCiudades; var error:boolean);
begin
	{$i-}
	reset(archivo);
	{$i+}
	if (ioresult <> 0) then
		error:=true;
end;

procedure cargarDato(var dato:tPuntCiudades);
var
	ciudad, provincia:string;
	cantidadHabitantes:integer;
begin
	writeln('NOMBRE DE CIUDAD:');
	readln(ciudad);
	writeln('NOMBRE DE PROVINCIA:');
	readln(provincia);
	writeln('CANTIDAD DE HABITANTES:');
	readln(cantidadHabitantes);
	dato.ciudad:=ciudad;
	dato.provincia:=provincia;
	dato.cantidadHabitantes:=cantidadHabitantes;
end;

procedure cargarArchivo(var archivo:archCiudades);
var
	dato:tPuntCiudades;
	cantidadElementos, contador:integer;
begin
	dato.ciudad:=' ';
	dato.provincia:=' ';
	dato.cantidadHabitantes:=0;
	contador:=0;
	reset(archivo);
	writeln('INGRESE LA CANTIDAD DE ELEMENTOS QUE DESEA INGRESAR:');
	readln(cantidadElementos);
	while (contador < cantidadElementos) do
		begin
			cargarDato(dato);
			write(archivo, dato);
			contador:=contador+1;
		end;
end;

procedure crearNodo(var nodo:puntCiudades; dato:tPuntCiudades);
begin
	new(nodo);
	nodo^.ciudad:=dato.ciudad;
	nodo^.provincia:=dato.provincia;
	nodo^.cantidadHabitantes:=dato.cantidadHabitantes;
end;

procedure insertarNodo(var arbol:puntCiudades; nodo:puntCiudades);
begin
	if (arbol = nil) then
		arbol:=nodo
	else
		if (arbol^.ciudad > nodo^.ciudad) then
			insertarNodo(arbol^.menores, nodo)
		else
			if (arbol^.ciudad < nodo^.ciudad) then
				insertarNodo(arbol^.mayores, nodo);
end;

procedure cargarArbol(var archivo:archCiudades; var arbol:puntCiudades);
var
	dato:tPuntCiudades;
	nodo:puntCiudades;
begin
	dato.ciudad:=' ';
	dato.provincia:=' ';
	dato.cantidadHabitantes:=0;
	nodo:=nil;
	reset(archivo);
	while not eof(archivo) do
		begin
			read(archivo, dato);
			crearNodo(nodo, dato);
			insertarNodo(arbol, nodo);
		end;
end;

procedure imprimirArbolInOrder(arbol:puntCiudades);
begin
	if (arbol <> nil) then
		begin
			writeln('CIUDAD: ',arbol^.ciudad,', PROVINCIA: ',arbol^.provincia,', POBLACION: ',arbol^.cantidadHabitantes);
			imprimirArbolInOrder(arbol^.menores);
			imprimirArbolInOrder(arbol^.mayores);
		end;
end;

procedure crearNodoPoblacion(var nodo:puntPoblacion; arbol:puntCiudades);
begin
	new(nodo);
	nodo^.provincia:=arbol^.provincia;
	nodo^.cantidadHabitantesAcumulada:=arbol^.cantidadHabitantes;
	nodo^.sig:=nil;
end;

function buscaProvinciaLista(poblacion:puntPoblacion; provincia:string):puntPoblacion;
var
	cursor:puntPoblacion;
begin
	cursor:=poblacion;
	while (cursor <> nil) and (cursor^.provincia <> provincia) do
		cursor:=cursor^.sig;
	buscaProvinciaLista:=cursor;
end;

procedure insertarNodoOrdenado(var poblacion:puntPoblacion; nodo:puntPoblacion);
var
	cursor1,cursor2:puntPoblacion;
begin
	if (poblacion^.provincia > nodo^.provincia) then
		begin
			nodo^.sig:=poblacion;
			poblacion:=nodo;
		end
	else
		begin
			cursor1:=buscaProvinciaLista(poblacion, nodo^.provincia);
			if (cursor1 <> nil) then
				cursor1^.cantidadHabitantesAcumulada:=cursor1^.cantidadHabitantesAcumulada+nodo^.cantidadHabitantesAcumulada
			else
				begin
					cursor1:=poblacion;
					while (cursor1 <> nil) and (cursor1^.provincia < nodo^.provincia) do
						begin
							cursor2:=cursor1;
							cursor1:=cursor1^.sig;
						end;
					nodo^.sig:=cursor1;
					cursor2^.sig:=nodo;
				end;
		
		end;
end;

procedure crearListaPoblacion(var poblacion:puntPoblacion; nodo:puntPoblacion);
begin
	if (poblacion = nil) then
		poblacion:=nodo
	else
		insertarNodoOrdenado(poblacion, nodo);
end;

procedure recorrerArbol(arbol:puntCiudades; var poblacion:puntPoblacion; ciudad1:string; ciudad2:string);
var
	nodo:puntPoblacion;
begin
	if (arbol <> nil) then
		begin
			if (arbol^.ciudad > ciudad1) and (arbol^.ciudad < ciudad2) or (arbol^.ciudad = ciudad1) or (arbol^.ciudad = ciudad2) then
				begin
					crearNodoPoblacion(nodo, arbol);
					crearListaPoblacion(poblacion, nodo);
				end;
			if (arbol^.ciudad > ciudad1) then
				recorrerArbol(arbol^.menores, poblacion, ciudad1, ciudad2);
			if (arbol^.ciudad < ciudad2) then
				recorrerArbol(arbol^.mayores, poblacion, ciudad1, ciudad2);
		end;
end;

procedure cargarListaPoblacion(arbol:puntCiudades; var poblacion:puntPoblacion);
var
	ciudad1, ciudad2:string;
begin
	writeln;
	writeln('INGRESE LA PRIMERA CIUDAD PARA EL RANGO:');
	readln(ciudad1);
	writeln;
	writeln('INGRESE LA SEGUNDA CIUDAD PARA EL RANGO:');
	readln(ciudad2);
	recorrerArbol(arbol, poblacion, ciudad1, ciudad2);
end;

procedure imprimirListaPoblacion(poblacion:puntPoblacion);
var
	cursor:puntPoblacion;
begin
	cursor:=poblacion;
	while (cursor <> nil) do
		begin
			writeln('PROVINCIA: ',cursor^.provincia,', CANTIDAD HABITANTES: ',cursor^.cantidadHabitantesAcumulada);
			cursor:=cursor^.sig;
		end;
end;

////////////////////////////////////////////////////////////////////////

var
	error:boolean;
	archivo:archCiudades;
	arbol:puntCiudades;
	poblacion:puntPoblacion;
	
begin
	error:=false;
	arbol:=nil;
	poblacion:=nil;
	assign(archivo,'archivoCiudades.dat');
	verificarExisteArchivo(archivo, error);
	if (error) then
		begin
			rewrite(archivo);
			cargarArchivo(archivo);
		end;
	cargarArbol(archivo, arbol);
	close(archivo);
	imprimirArbolInOrder(arbol);
	cargarListaPoblacion(arbol, poblacion);
	writeln;
	writeln('LISTA DE PROVINCIAS CON LA POBLACION ACUMULADA:');
	imprimirListaPoblacion(poblacion);
end.
