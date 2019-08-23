program e6p1;

uses
	crt;
	
type
	aEnteros = file of integer;
	
////////////////////////////////////////////////////////////////////////

function obtenerPosicionElementoDesordenado(var archEnteros:aEnteros; numeroDeseado:integer):integer;
var
	contador, numero:integer;
	salir:boolean;
begin
	reset(archEnteros);
	contador:=0;
	salir:=false;
	
	while not (salir) do
		begin
			read(archEnteros, numero);
			if (numero = numeroDeseado) then
				salir:=true
			else
				contador:=contador+1;
		
		end;
		
	if (numero <> numeroDeseado) then
		contador:=-1;
		
	obtenerPosicionElementoDesordenado:=contador;
end;

function obtenerPosicionElementoOrdenado(var archEnteros2:aEnteros; numeroDeseado:integer):integer;
var
	numero, contador:integer;
	inicio, fin, mitad:real;
begin
	reset(archEnteros2);
	contador:=0;
	inicio:=0;
	fin:=filesize(archEnteros2);
	mitad:=(inicio+fin)/2;
	
	while (inicio <> fin) do
		begin
			seek(archEnteros2, filesize(archEnteros2) div 2);
			read(archEnteros2, numero);
			if (numeroDeseado < numero) then
				begin
					fin:=mitad;
					mitad:=(inicio+fin)/2;
				end
			else
				if (numeroDeseado > numero) then
					begin
						inicio:=mitad;
						mitad:=(inicio+fin)/2;
					end		
		end;
	
	if (numero <> numeroDeseado) then
		contador:=-1;

	obtenerPosicionElementoOrdenado:=contador;
end;
	
////////////////////////////////////////////////////////////////////////

var
	archEnteros, archEnteros2:aEnteros;
	numeroDeseado:integer;
	
begin
	//PRIMER INCISO DE ELEMENTOS DESORDENADOS

	assign(archEnteros,'EnterosPositivos.dat');
	
	writeln('Ingrese el numero que desea buscar:');
	readln(numeroDeseado);
	writeln('El elemento se encuentra en la posicion: ', obtenerPosicionElementoDesordenado(archEnteros, numeroDeseado));
	
	close(archEnteros);
	
	//SEGUNDO INCISO DE ELEMENTOS ORDENADOS
	
	assign(archEnteros2,'EnterosPositivos2.dat');
	
	writeln('Ingrese el numero que desea buscar:');
	readln(numeroDeseado);
	writeln('El elemento se encuentra en la posicion: ', obtenerPosicionElementoOrdenado(archEnteros2, numeroDeseado));
	
	close(archEnteros);
end.
