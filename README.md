# Largely adapted from [thomasWeise/texlive](https://hub.docker.com/r/thomasweise/texlive/)

This is a Docker image containing a [TeX Live](https://en.wikipedia.org/wiki/TeX_Live) installation (version 2015.2016) with a few auxiliary packages for editing files and manipulating PDFs. The goal is to provide a unified environment for compiling LaTeX documents with predictable and reproducible behavior, while decreasing the effort needed to install and maintain the LaTeX installation.

## 0. Installing Docker

Docker can be installed following the guidelines below:

* for [Linux](https://docs.docker.com/linux/step_one/), you can run  `curl -fsSL https://get.docker.com/ | sh` on your command line and everything is done automatically (if you have `curl` installed, which is normally the case),
* for [Windows](https://docs.docker.com/windows/step_one/)
* for [Mac OS](https://docs.docker.com/mac/step_one/)

## 1. Usage

Below, we discuss the various parameters that you can pass to this image when running it. If you have installed Docker, you do not need to perform any additional installations: The first time you do `docker run -t -i kellyrowland/docker-texlive` or something like that (see below), the image will automatically be downloaded and installed from [docker hub](https://hub.docker.com/).

There are two basic use cases of this image:

1. Execution of a single command or script
2. Providing a shell where you can use all the standard LaTeX commands

To provide data to the container:

1. Mount the folder where the LaTeX document you want to compile is located: This step is necessary.

The common form of the command is as follows:

    docker run -v /my/path/to/document/:/doc/ -t -i kellyrowland/docker-texlive COMMAND ARG1 ARG2...
    
Where

* `/my/path/to/document/` must be replaced with the path to the folder containing the LaTeX document that you want to compile. This folder will be made available as folder `/doc/` inside the container. If you use the image without command parameters (see below), you will get a bash command prompt inside this `/doc/` folder.
* *Optionally* you can also provide a single command that should be executed when the container starts (along with its arguments). This is what the `COMMAND ARG1 ARG2...` in the above command line stand for. If you specify such a command, the container will start up, execute the command, and then shut down. If you do not provide such a command, the container will start up and provide you a bash prompt in folder `/doc/`.

For compiling some document named `myDocument.tex` in folder `/my/path/to/document/` using additional fonts in folder `/path/to/fonts/`, you would type something like the command below into a normal terminal (Linux), the *Docker Quickstart Terminal* (Mac OS), or the *Docker Toolbox Terminal* (Windows):

    docker run -v /my/path/to/document/:/doc/ -v /path/to/fonts/:/usr/share/fonts/external/ -t -i kellyrowland/docker-texlive
    latex myDocument
    exit
    
Alternatively, you could also do

    docker run -v /my/path/to/document/:/doc/ -v /path/to/fonts/:/usr/share/fonts/external/ -t -i kellyrowland/docker-texlive latex myDocument
    
The first version starts the container and leaves you at the command prompt. You can now compile your document using LaTeX, then you `exit` the container. In the second version, you directly provide the command to the container. The container executes it and then directly exits.
  
Both should leave the compiled PDF file in folder `/my/path/to/document/`. If you are not using my pre-defined scripts for building (see below under point 3.1), I recommend doing `chmod 777 myDocument.pdf` after the compilation, to ensure that the produced document can be accessed inside your real (host) system's user, and not just from the Docker container. If you directly provide a single command for execution, the container attempts to heuristically find your produced `pdf` and to set its permissions correctly. 

The `-v sourcepath:destpath` options are optional. They allow you to "mount" a folder (`sourcepath`) from your local system into the Docker container, where it becomes available as path `destpath`. We can use this method to allow the LaTeX compiler running inside the container to work on your LaTeX documents by mounting their folder into a folder named `/doc/`, for instance. But we can also mount an external folder with fonts into the Linux font directory structure. For this purpose, please always mount your local font directory into `/usr/share/fonts/external/`. 

If you just want to use (or snoop around in) the image without mounting external folders, you can run this image by using:

    docker run -t -i kellyrowland/docker-texlive

## 2. Building and Components

The image has the following components:

- [`TeX Live`](http://www.tug.org/texlive/) version 2015.2016
- [`Biber`](http://biblatex-biber.sourceforge.net/)
- [`Make`](http://pubs.opengroup.org/onlinepubs/9699919799/utilities/make.html)
- [`PDFtk`](https://www.pdflabs.com/tools/pdftk-the-pdf-toolkit/)
- [`Vim`](https://vim.sourceforge.io/)

You can build it with

    docker build -t kellyrowland/docker-texlive .

## 3. License

This image is licensed under the GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007, which you can find in file [LICENSE.md](https://github.com/kellyrowland/docker-texlive/blob/master/LICENSE.md). The license applies to the way the image is built, while the software components inside the image are under the respective licenses chosen by their respective copyright holders.
