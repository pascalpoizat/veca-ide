# validation of component architectures (veca-ide)

[![Build Status](https://img.shields.io/travis/pascalpoizat/veca-ide/master.svg?style=flat-square)](https://travis-ci.org/pascalpoizat/veca-ide)
[![License](https://img.shields.io/github/license/pascalpoizat/veca-ide.svg?style=flat-square)](LICENSE)
[![Version](https://img.shields.io/github/tag/pascalpoizat/veca-ide.svg?style=flat-square&label=version)](pom.xml)<br/>
[![Waffle.io - Columns and their card count](https://badge.waffle.io/pascalpoizat/veca-ide.svg?columns=all)](https://waffle.io/pascalpoizat/veca-ide)
<!--[![Code Coverage](https://img.shields.io/coveralls/pascalpoizat/veca-ide/master.svg?style=flat-square)](https://coveralls.io/github/pascalpoizat/veca-ide)-->

This is the Eclipse IDE plugin for the DSL of the VECA project (DSL edition and transformation from the DSL to the VECA JSON format). 

- for an overview of the VECA project features and objectives, see [VECA project](https://pascalpoizat.github.io/veca-web).

- for the transformation of the VECA JSON format into timed automata in XTA format for formal verification, see [veca-haskell](https://github.com/pascalpoizat/veca-haskell).

To use this plugin your installation must fulfil the requirements given in **1. Requirements** and then you may choose either to use the available update-site following **2a. Update-site** (recommended) or build a local one using **2b. Building from source**. Some details on the use of the plugin are given in **3. Using the plugin**.

## 1. Requirements

### To use the DSL

Get the **Eclipse IDE for Java and DSL Developers** Photon or higher (it has been tested with Eclipse Photon)
from [the Eclipse IDE Downloads page](https://www.eclipse.org/downloads/eclipse-packages/).

### To generate the JSON representation from the DSL

Nothing more is required.

### To generate a set of temporal automata from the DSL

:warning:
Linux and Mac OS X only.
For other OS, one still has to run [veca-haskell](https://github.com/pascalpoizat/veca-haskell) manually.

You must install [veca-haskell](https://github.com/pascalpoizat/veca-haskell).

If you follow the intructions given in its [README](https://github.com/pascalpoizat/veca-haskell/README.md), it will be installed in `$HOME/.local/bin`.
If you choose to install it somewhere else, the `$VECA_HOME` environment variable should be set to this place.

Further, the temporal automata generation takes for granted that the generated JSON files are in the `src-gen` subdirectory of your project.
This is the default so you have nothing more to do.
Please do not change the setting of the generation directory in `Eclipse Preferences -> VecaDsl -> Compiler / Directory`.

## 2a. Update-site

You can get the VECA plugin directly from the update-site:

- in Eclipse, Help -> Install New Software ... -> Add a new repository from `https://pascalpoizat.github.io/veca-ide/` (you can name it `veca dsl (update site)` for example)

- from this repository, select VecaDsl / VecaDsl Feature for installation

If Eclipse warns you that you are installing software that contains unsigned contents, click OK. 

## 2b. Building from source

You can build the plugin on your system and use it as an update site.
First clone the project:

```sh
git clone https://github.com/pascalpoizat/veca-ide
```

This creates a directory `.../veca-ide` (where `...` stands for the place where you ran the `git` command). In the sequel we will use `$VECA_IDE_SOURCE` to refer to `.../veca-ide`.

To build the plugin:

```sh
cd $VECA_IDE_SOURCE
mvn clean install
```

In Eclipse, Help -> Install New Software ... -> Add this local update site : `$VECA_IDE_SOURCE/fr.lip6.veca.ide.parent/fr.lip6.veca.ide.repository/target/repository/`.

## 3. Using the plugin

The plugin is activated once you edit a `.veca` file. The first time you use the plugin on a project, the IDE may ask you whether you want to convert it to an XText project. Answer yes.

The syntax of a model in the VECA DSL format is available in [the VECA project documentation](https://pascalpoizat.github.io/veca-web/documentation.html).

The plugin provides you with:

- IDE capabilities such as syntax highlighting and renaming.

- templates (available upon smart completion using Ctrl+Space)

- model verifications that can be performed directly on the VECA model (see Syntactic verification, in [the VECA projet documentation](https://pascalpoizat.github.io/veca-web/documentation.html))

- transformation from the VECA DSL format (`.veca` files) to the VECA JSON format (`.json` files) and to sets of timed automata (`.xta` files). 

	Transformations are performed upon saving a syntactically correct model that has been edited.
	The generated files can be found in the `src-gen` directory. Log files are also there.
	
For the time being, verification is achieved from outside the plugin using the [ITS-Tools](https://lip6.github.io/ITSTools-web/) or [UPPAAL](http://uppaal.org) verification tools on the `.xta` files.