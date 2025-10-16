# Guía de Instalación y Configuración

Instrucciones para iniciar un mini cluster local utilizando tres contenedores.

Un contenedor que corresponde el nodo maestro, y dos contenedores que corresponden a nodos esclavos.

## Primer paso:

Instalar **WSL** desde la terminal siguiendo el siguiente tutorial:  
[Instalar WSL](https://learn.microsoft.com/en-us/windows/wsl/install)

Para dirigirse al directorio **home**, solo deben ejecutar el comando:

```bash
$ cd
```

## Segundo paso:

Instalar **Docker** en **wsl**, para ello se siguen los pasos en: 
[Instalar Docker](https://docs.docker.com/engine/install/ubuntu/)

Luego de instalar Docker, ejecuten los siguientes comandos para evitar tener que usar sudo para ejecutar comandos de docker:

```bash
$ groupadd docker
```
```bash
$ sudo usermod -aG docker $USER
```
Depués de esto, reincién su sesión en **wsl**

```bash
$ exit
```

## Tercer paso:

Una vez hayan realizado esto, vuelvan a entrar a wsl

```powershell
PS C:\Users\user> wsl
```
Creen el directorio en el que quieran clonar el "proyecto".

Mi recomendación es dirigirse al directorio home.

```bash
danie_unix@laptop-daniel danie
$ cd
danie_unix@laptop-daniel ~
$ ls
BigData  backend   personal
danie_unix@laptop-daniel ~
$ pwd
/home/danie_unix
```
Yo cree ahí (en el directorio Home, (~) ) el directorio BigData, dentro del cual se encuentra el directorio **testing** que ven en las otras entradas de terminal.

```bash
danie_unix@laptop-daniel testing (main)
$ pwd
/home/danie_unix/BigData/Project/testing

danie_unix@laptop-daniel testing (main)
$ ls
Dockerfile  confs  datasets  docker-compose.yaml  notebooks  readme.md  resources  script_files
```

Una vez hayan clonado el proyecto, ejecuten los siguientes comandos:

```bash
$ mkdir datasets
$ mkdir notebooks
$ mkdir resources
```

Al ejecutar `$ ls` deberian obtener el siguient resultado:

```bash
danie_unix@laptop-daniel testing (main)
$ ls
Dockerfile  confs  datasets  docker-compose.yaml notebooks  readme.md  resources  script_files
```
## Cuarto paso:

Entren al directorio de resources

```bash
$ cd resources
```
Descarguen **hadoop** en este directorio, esto es para que las builds subsecuentes sean más rápidas al no tener que descargar hadoop.

```bash
$ wget https://dlcdn.apache.org/hadoop/common/hadoop-3.4.1/hadoop-3.4.1.tar.gz
```

## Quinto paso:

Agreguen al directorio **notebooks/** todos los notebooks (.ipynb) que vayan a utilizar en el container.

Para realizar pruebas, mi **notebooks/** se ve así:

```bash
danie_unix@laptop-daniel testing (main)
$ ls notebooks/
notebook08_Prada-Leal-Mena.ipynb notebook08_Spark_wordcount_quest.ipynb
```
Para esto pueden realizarlo por consola (como ya vimos en clase) o utilizar el explorador de archivos de windows, donde encontrarán una carpeta llamada Ubuntu.

## Sexto paso:

Construir la imagen, para esto ubiquense en el directorio donde se encuentra el Dockerfile (si ejecutan `$ls`, deberían ver Dockerfile)

```bash
$ docker build . -t cluster-base
```

## Séptimo paso:

Una vez construida la imagen, en el mismo directorio donde se ecuentra Dockerfile y docker-compose, ejecuten el siguiente comando para iniciar los conenedores.

```bash
$ docker-compose up
```

## Notas:

Para detener y eliminar los contenedores, ejecuten:

```bash
$ docker-compose down
```

Para listar los contenedores activos, ejecuten:
```bash
docker ps
```

Para listar todos los contenedores, ejecuten:

```bash
docker ps -a
```