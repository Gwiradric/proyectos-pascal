program e2p4;

uses
	crt;
	
const
	MAX_ELEMENTOS = 5;
	
type
	puntAlumnos = ^tAlumnos;
	tAlumnos = record
		nombre:string;
		curso:integer;
		sig:puntAlumnos;
	end;
	
	puntNombres = ^tNombre;
	tNombre = record
		alumno:puntAlumnos;
		sig:puntNombreS;
	end;
	
////////////////////////////////////////////////////////////////////////

procedure imprimirListaNombres(listaNombres:puntNombres);
var
	cursor:puntNombres;
begin
	cursor:=listaNombres;
	writeln('LISTA POR NOMBRES:');
	while (cursor <> nil) do
		begin
			write('NOMBRE:',cursor^.alumno^.nombre);
			writeln;
			cursor:=cursor^.sig;
		end;
end;

procedure imprimirListaAlumnos(listaAlumnos:puntAlumnos);
var
	cursor:puntAlumnos;
begin
	cursor:=listaAlumnos;
	writeln('LA LISTA ES:');
	while (cursor <> nil) do
		begin
			write('NOMBRE:',cursor^.nombre,', CURSO:', cursor^.curso);
			writeln;
			cursor:=cursor^.sig;
		end;
end;

procedure insertarNodoOrdenado(var listaNombres:puntNombres; nodoNombre:puntNombres);
var
	cursorAnt, cursorSig:puntNombres;
begin
	if (listaNombres^.alumno^.nombre > nodoNombre^.alumno^.nombre) then
		begin
			nodoNombre^.sig:=listaNombres;
			listaNombres:=nodoNombre;
		end
	else
		begin
			cursorSig:=listaNombres;
			cursorAnt:=nil;
			while (cursorSig <> nil) and (cursorSig^.alumno^.nombre < nodoNombre^.alumno^.nombre) do
				begin
					cursorAnt:=cursorSig;
					cursorSig:=cursorSig^.sig;
				end;
			nodoNombre^.sig:=cursorSig;
			cursorAnt^.sig:=nodoNombre;
		end;
end;

procedure insertarNodoNombre(var listaNombres:puntNombres; nodoNombre:puntNombres);
begin
	if (listaNombres = nil) then
		listaNombres:=nodoNombre
	else
		insertarNodoOrdenado(listaNombres, nodoNombre);
end;

procedure crearNodoNombre(var nodo:puntNombres; alumno:puntAlumnos);
begin
	new(nodo);
	nodo^.alumno:=alumno;
	nodo^.sig:=nil;
end;

procedure crearListaNombres(listaAlumnos:puntAlumnos; var listaNombres:puntNombres);
var
	nodoNombre:puntNombres;
	cursor:puntAlumnos;
begin
	nodoNombre:=nil;
	cursor:=listaAlumnos;
	while (cursor <> nil) do
		begin
			crearNodoNombre(nodoNombre, cursor);
			insertarNodoNombre(listaNombres, nodoNombre);
			cursor:=cursor^.sig;
		end;
end;

procedure insertarPorNombre(var listaAlumnos:puntAlumnos; nodoAlumno:puntAlumnos);
var
	cursorAnt, cursorSig:puntAlumnos;
begin
	if (listaAlumnos^.nombre > nodoAlumno^.nombre) then
		begin
			nodoAlumno^.sig:=listaAlumnos;
			listaAlumnos:=nodoAlumno;
		end
	else
		begin
			cursorSig:=listaAlumnos;
			cursorAnt:=nil;
			while (cursorSig <> nil) and (cursorSig^.curso = nodoAlumno^.curso) and (cursorSig^.nombre < nodoAlumno^.nombre) do
				begin
					cursorAnt:=cursorSig;
					cursorSig:=cursorSig^.sig;
				end;
			nodoAlumno^.sig:=cursorSig;
			cursorAnt^.sig:=nodoAlumno;
		end;
end;

procedure insertarPorCurso(var listaAlumnos:puntAlumnos; nodoAlumno:puntAlumnos);
var
	cursorAnt, cursorSig:puntAlumnos;
begin
	if (listaAlumnos^.curso > nodoAlumno^.curso) then
		begin
			nodoAlumno^.sig:=listaAlumnos;
			listaAlumnos:=nodoAlumno;
		end
	else
		if (listaAlumnos^.curso = nodoAlumno^.curso) then
			insertarPorNombre(listaAlumnos, nodoAlumno)
		else
			begin
				cursorSig:=listaAlumnos;
				cursorAnt:=nil;
				while (cursorSig <> nil) and (cursorSig^.curso < nodoAlumno^.curso) do
					begin
						cursorAnt:=cursorSig;
						cursorSig:=cursorSig^.sig;
					end;
				if (cursorSig <> nil) then
					if (cursorSig^.curso <> nodoAlumno^.curso) then
						begin
							writeln('entro');
							nodoAlumno^.sig:=cursorSig;
							cursorAnt^.sig:=nodoAlumno;
						end
					else
						insertarPorNombre(listaAlumnos, nodoAlumno)
				else
					begin
						nodoAlumno^.sig:=cursorSig;
						cursorAnt^.sig:=nodoAlumno;
					end;
			end;
end;

procedure insertarOrdenado(var listaAlumnos:puntAlumnos; nodoAlumno:puntAlumnos);
begin
	if (listaAlumnos = nil) then
		listaAlumnos:=nodoAlumno
	else
		insertarPorCurso(listaAlumnos, nodoAlumno);
end;

procedure crearNodoAlumno(var nodoAlumno:puntAlumnos; nombre:string; curso:integer);
begin
	new(nodoAlumno);
	nodoAlumno^.nombre:=nombre;
	nodoAlumno^.curso:=curso;
	nodoAlumno^.sig:=nil;
end;

procedure cargarListaAlumnos(var listaAlumnos:puntAlumnos);
var
	nodoAlumno:puntAlumnos;
	nombre:string;
	contador, curso:integer;
begin
	nodoAlumno:=nil;
	contador:=0;
	writeln('INGRESE LOS DATOS DE LOS ALUMNOS:');
	writeln;
	while (contador < MAX_ELEMENTOS) do
		begin
			writeln('NOMBRE: ');
			readln(nombre);
			writeln('CURSO: ');
			readln(curso);
			crearNodoAlumno(nodoAlumno, nombre, curso);
			insertarOrdenado(listaAlumnos, nodoAlumno);
			contador:=contador+1;
			writeln;
		end;

end;

procedure ingresarNuevoAlumno(var listaAlumnos:puntAlumnos; var listaNombres:puntNombres);
var
	nombre:string;
	curso:integer;
	nodoAlumno:puntAlumnos;
	nodoNombre:puntNombres;
begin
	nodoAlumno:=nil;
	nodoNombre:=nil;
	writeln('INGRESE EL NUEVO ALUMNO QUE DESEA INGRESAR:');
	writeln('NOMBRE:');
	readln(nombre);
	writeln('CURSO:');
	readln(curso);
	crearNodoAlumno(nodoAlumno, nombre, curso);
	crearNodoNombre(nodoNombre, nodoAlumno);
	insertarOrdenado(listaAlumnos, nodoAlumno);
	insertarNodoNombre(listaNombres, nodoNombre);
end;

////////////////////////////////////////////////////////////////////////

var
	listaAlumnos:puntAlumnos;
	listaNombres:puntNombres;
	
begin
	listaNombres:=nil;
	listaAlumnos:=nil;
	cargarListaAlumnos(listaAlumnos);
	crearListaNombres(listaAlumnos, listaNombres);
	imprimirListaAlumnos(listaAlumnos);
	imprimirListaNombres(listaNombres);
	ingresarNuevoAlumno(listaAlumnos, listaNombres);
	imprimirListaAlumnos(listaAlumnos);
	imprimirListaNombres(listaNombres);
end.
