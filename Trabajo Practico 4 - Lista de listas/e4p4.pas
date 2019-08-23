program e4p4;

uses
	crt;
	
const
	MAX_PERSONAS = 5;
	
type

	lEmpleados = ^tEmpleados;
	tEmpleados = record
		nombre:string;
		sueldo:integer;
		sig:lEmpleados;
	end;
	
	lCategorias = ^tCategorias;
	tCategorias = record
		categoria:char;
		empleado:lEmpleados;
		sig:lCategorias;
	end;

	tArchEmpleados = record
		nombre:string;
		categoria:char;
		sueldo:integer;
	end;
	
	archEmpleados = file of tArchEmpleados;
	
////////////////////////////////////////////////////////////////////////

procedure imprimirCategorias(cat:lCategorias);
var
	cCat:lCategorias;
	cEmp:lEmpleados;
begin
	cCat:=cat;
	while (cCat <> nil) do
		begin
			writeln('CATEGORIA:' ,cCat^.categoria);
			cEmp:=cCat^.empleado;
			while (cEmp <> nil) do
				begin
					writeln('NOMBRE: ',cEmp^.nombre,', SUELDO: $',cEmp^.sueldo);
					cEmp:=cEmp^.sig;
				end;
			cCat:=cCat^.sig;
		end;
end;

procedure insertarOrdenadoListaEmpleados(var emp:lEmpleados; nEmp:lEmpleados);
var
	cAnt, cSig:lEmpleados;
begin
	if (emp^.nombre > nEmp^.nombre) then
		begin
			nEmp^.sig:=emp;
			emp:=nEmp;
		end
	else
		begin
			cSig:=emp;
			while (cSig <> nil) and (cSig^.nombre < nEmp^.nombre) do
				begin
					cAnt:=cSig;
					cSig:=cSig^.sig;
				end;
			nEmp^.sig:=cSig;
			cAnt^.sig:=nEmp;
		end;
end;

procedure insertarListaEmpleados(var cat:lCategorias; nEmp:lEmpleados; categoria:char);
var
	cCat:lCategorias;
begin
	cCat:=cat;
	while (cCat <> nil) and (cCat^.categoria <> categoria) do
		cCat:=cCat^.sig;
	if (cCat^.empleado = nil) then
		cCat^.empleado:=nEmp
	else
		insertarOrdenadoListaEmpleados(cCat^.empleado, nEmp);
end;

procedure insertarOrdenadoListaCategorias(var cat:lCategorias; nCat:lCategorias);
var
	cAnt, cSig:lCategorias;
begin
	if (cat^.categoria > nCat^.categoria) then
		begin
			nCat^.sig:=cat;
			cat:=nCat;
		end
	else
		begin
			cSig:=cat;
			while (cSig <> nil) and (cSig^.categoria < nCat^.categoria) do
				begin
					cAnt:=cSig;
					cSig:=cSig^.sig;
				end;
			nCat^.sig:=cSig;
			cAnt^.sig:=nCat;
		end;
end;

function existeCategoria(cat:lCategorias; categoria:char):boolean;
var
	existe:boolean;
	cCat:lCategorias;
begin
	existe:=false;
	cCat:=cat;
	while (cCat <> nil) and (cCat^.categoria <> categoria) do
		cCat:=cCat^.sig;
	if (cCat <> nil) then
		existe:=true;
	existeCategoria:=existe;
end;

procedure insertarListaCategorias(var cat:lCategorias; nCat:lCategorias);
begin
	if (cat = nil) then
		cat:=nCat
	else
		if not (existeCategoria(cat, nCat^.categoria)) then
			insertarOrdenadoListaCategorias(cat, nCat);
end;

procedure cargarNodoCategorias(var nCat:lCategorias; categoria:char);
begin
	new(nCat);
	nCat^.categoria:=categoria;
	nCat^.empleado:=nil;
	nCat^.sig:=nil;
end;

procedure cargarNodoEmpleados(var nEmp:lEmpleados; nombre:string; sueldo:integer);
begin
	new(nEmp);
	nEmp^.nombre:=nombre;
	nEmp^.sueldo:=sueldo;
	nEmp^.sig:=nil;
end;

procedure cargarListaCategorias(var archivo:archEmpleados; var cat:lCategorias);
var
	nCat:lCategorias;
	nEmp:lEmpleados;
	emp:tArchEmpleados;
begin
	nCat:=nil;
	nEmp:=nil;
	reset(archivo);
	while not eof(archivo) do
		begin
			read(archivo, emp);
			cargarNodoCategorias(nCat, emp.categoria);
			cargarNodoEmpleados(nEmp, emp.nombre, emp.sueldo);
			insertarListaCategorias(cat, nCat);
			insertarListaEmpleados(cat, nEmp, emp.categoria);
		end;
end;

procedure inicializarEmpleado(var empleado:tArchEmpleados; nombre:string; categoria:char; sueldo:integer);
begin
	empleado.nombre:=nombre;
	empleado.categoria:=categoria;
	empleado.sueldo:=sueldo;
end;

procedure ingresarDatos(var nombre:string; var categoria:char; var sueldo:integer);
begin
	writeln('NOMBRE Y APELLIDO:');
	readln(nombre);
	writeln('CATEGORIA:');
	readln(categoria);
	writeln('SUELDO:');
	readln(sueldo);		
end;

procedure cargarArchivoEmpleados(var archivo:archEmpleados);
var
	empleado:tArchEmpleados;
	nombre:string;
	categoria:char;
	contador, sueldo:integer;
begin
	contador:=0;
	nombre:=' ';
	categoria:='A';
	sueldo:=0;
	reset(archivo);
	writeln('INGRESE LOS EMPLEADOS AL ARCHIVO:');
	while (contador < MAX_PERSONAS) do
		begin
			ingresarDatos(nombre, categoria, sueldo);
			inicializarEmpleado(empleado, nombre, categoria, sueldo);
			writeln(empleado.nombre, empleado.categoria, empleado.sueldo);
			write(archivo, empleado);
			contador:=contador+1;
		end;
end;

procedure verificarExisteArchivo(var archivo:archEmpleados; var error:boolean);
begin
	{$i-}
	reset(archivo);
	{$i+}
	if (ioresult <> 0) then
		error:=true;
end;

procedure imprimirCategoriaEspecifica(cat:lCategorias);
var
	categoria:char;
	cCat:lCategorias;
	cEmp:lEmpleados;
begin
	writeln('INGRESE LA CATEGORIA QUE DESEA IMPRIMIR:');
	readln(categoria);
	if (existeCategoria(cat, categoria)) then
		begin
			writeln('CATEGORIA:');
			cCat:=cat;
			while (cCat^.categoria <> categoria) do
				cCat:=cCat^.sig;
			cEmp:=cCat^.empleado;
			while (cEmp <> nil) do
				begin
					writeln('NOMBRE: ',cEmp^.nombre,', SUELDO: $',cEmp^.sueldo);
					cEmp:=cEmp^.sig;
				end;
		end;
end;
	
////////////////////////////////////////////////////////////////////////

var
	archivoE:archEmpleados;
	error:boolean;
	categorias:lCategorias;
	
begin
	categorias:=nil;
	error:=false;
	assign(archivoE,'archivoEmpleados.dat');
	verificarExisteArchivo(archivoE, error);
	if (error) then
		begin
			rewrite(archivoE);
			cargarArchivoEmpleados(archivoE);
		end;
	cargarListaCategorias(archivoE, categorias);
	imprimirCategorias(categorias);
	imprimirCategoriaEspecifica(categorias);
	close(archivoE);
end.
