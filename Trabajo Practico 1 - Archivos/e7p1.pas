program e7p1;

uses
	crt;
	
const
	MAX_MATERIAS = 5;
	MAX_ALUMNOS = 6;
	
type
	notasAlumno = array [1..MAX_MATERIAS] of integer;
	
	tNotas = file of notasAlumno;
	
////////////////////////////////////////////////////////////////////////

procedure verificarExisteArchivo(var archNotas:tNotas; var error:boolean);
//PROCEDIMIENTP PARA VERIFICAR SI EXISTE EL ARCHIVO
begin
	{$i-}
	reset(archNotas);
	{$i+}
	if (ioresult <> 0) then
		error:=true;
end;

procedure cargarArchivoNotas(var archNotas:tNotas);
//PROCEDIMIENTO PARA CARGAR EN EL ARCHIVO
var
	contador, i:integer;
	notas:notasAlumno;
begin
	contador:=0;
	reset(archNotas);
	while (contador < MAX_ALUMNOS) do
		begin
			for i:=1 to MAX_MATERIAS do
				readln(notas[i]);
			write(archNotas, notas);
			contador:=contador+1;
		end;
end;

procedure dividirCantidadMaterias(var arregloNotas:notasAlumno);
//PROCEDIMIENTO QUE DIVIDE LAS NOTAS POR LA CANTIDAD DE ALUMNOS
var
	i:integer;
begin
	for i:=1 to MAX_MATERIAS do
		arregloNotas[i]:=arregloNotas[i] div MAX_ALUMNOS;
end;

procedure sumarNotas(notas:notasAlumno; var notasAcumuladas:notasAlumno);
//PROCEDIMIENTO QUE SUMA LAS NOTAS DE EL ARCHIVO EN LA ESTRUCTURA DE LAS NOTAS PROMEDIO
var
	i:integer;
begin
	for i:=1 to MAX_MATERIAS do
		notasAcumuladas[i]:=notasAcumuladas[i] + notas[i];
end;

procedure inicializarArreglo(var arreglo:notasAlumno);
//INICIALIZA LAS NOTAS EN 0
var
	i:integer;
begin
	for i:=1 to MAX_MATERIAS do
		arreglo[i]:=0;
end;

function sacaPromedio(var archNotas:tNotas):notasAlumno;
//FUNCION QUE RETORNA EL PROMEDIO DE LAS MATERIAS DEL ARCHIVO
var
	notas, notasAcumuladas:notasAlumno;
begin
	reset(archNotas);
	inicializarArreglo(notasAcumuladas);
	
	while not eof(archNotas) do
		begin
			read(archNotas, notas);
			sumarNotas(notas, notasAcumuladas);
		end;

	dividirCantidadMaterias(notasAcumuladas);
	
	sacaPromedio:=notasAcumuladas;

end;

procedure imprimirPromedio(arregloNotas:notasAlumno);
//PROCEDIMIENTO QUE IMPRIME EL ARREGLO DE PROMEDIOS
var
	i:integer;
begin
	writeln;
	for i:=1 to MAX_MATERIAS do
		write(arregloNotas[i],' ');
end;

////////////////////////////////////////////////////////////////////////

var
	archNotas:tNotas;
	error:boolean;
	promedio:notasAlumno;
	
begin
	error:=false;
	assign(archNotas,'Notas.dat');
	verificarExisteArchivo(archNotas, error);
	if (error) then
		begin
			rewrite(archNotas);
			cargarArchivoNotas(archNotas);
		end;
	promedio:=sacaPromedio(archNotas);
	imprimirPromedio(promedio);

	close(archNotas);
end.
