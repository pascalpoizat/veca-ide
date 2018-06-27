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

You will need a recent Eclipse with version 2.13 or more of the XText libraries.
For this:

- get the **Eclipse IDE for Java and DSL Developers** from [the Eclipse Packages Site](https://www.eclipse.org/downloads/eclipse-packages/)

- in Eclipse, Help -> Install New Sofware ... -> Add a new repository from `http://download.eclipse.org/modeling/tmf/xtext/updates/composite/releases/` (you can name it `xtext (update site)` for example)

- from this repository, select Xtext / Xtext complete SDK for installation

## 2a. Update-site

You can get the VECA plugin directly from the update-site:

- in Eclipse, Help -> Install New Software ... -> Add a new repository from `https://pascalpoizat.github.io/veca-ide/` (you can name it `veca dsl (update site)` for example)

- from this repository, select VecaDsl / VecaDsl Feature for installation

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

- syntax highlighting and identifier renaming

- some basic templates (available upon smart completion using Ctrl+Space)

- some model verifications that can be performed directly on the VECA model (see Syntactic verification, in [the VECA projet documentation](https://pascalpoizat.github.io/veca-web/documentation.html))

- transformation from the VECA DSL format (`.veca` files) to the VECA JSON format (`.json` files) and to sets of timed automata (`.xta` files). 

	Transformation is performed upon saving a syntactically correct model that has been edited.
	The generated files can be found in the `src-gen` directory. Log files are also there.
	
	:warning: the transformation to timed automata only runs from the plugin if your OS is Linux or Mac OS X.
	For other OS, one still has to run [veca-haskell](https://github.com/pascalpoizat/veca-haskell) manually.
	
	:warning: the plugin takes for granted that generation is done in the `src-gen` directory.
	The user should not change the generation directory (in Eclipse Preferences -> VecaDSL -> Compiler : Directory).

For the time being, verification is achieved from outside the plugin using the [ITS-Tools](https://lip6.github.io/ITSTools-web/) or [UPPAAL](http://uppaal.org) verification tools on the `.xta` files.