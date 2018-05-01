# validation of component architectures (veca-ide)

[![Build Status](https://img.shields.io/travis/pascalpoizat/veca-ide/master.svg?style=flat-square)](https://travis-ci.org/pascalpoizat/veca-ide)
[![License](https://img.shields.io/badge/license-Apache%20License%202.0-blue.svg?style=flat-square)](LICENSE)
[![Version](https://img.shields.io/badge/version-1.0.0-green.svg?style=flat-square&label=version)](pom.xml)<br/>
<!--[![Code Coverage](https://img.shields.io/coveralls/pascalpoizat/veca-ide/master.svg?style=flat-square)](https://coveralls.io/github/pascalpoizat/veca-ide)-->
<!--
[![Issues Ready](https://img.shields.io/github/issues-raw/pascalpoizat/veca-ide/ready.svg?style=flat-square&label=issues%20ready%20for%20development)](https://waffle.io/pascalpoizat/veca-ide)
[![Issues in Progress](https://img.shields.io/github/issues-raw/pascalpoizat/veca-ide/in%20progress.svg?style=flat-square&label=issues%20in%20progress)](https://waffle.io/pascalpoizat/veca-ide)
-->

This is the Eclipse IDE plugin for the DSL of the VECA project (DSL edition and transformation from the DSL to the VECA JSON format). 

- for an overview of the VECA project features and objectives, see [VECA project](https://pascalpoizat.github.io/veca-web).

- for the transformation of the VECA JSON format into timed automata in XTA format for formal verification, see [veca-haskell](https://github.com/pascalpoizat/veca-haskell).

## 1. Requirements

You will need a recent Eclipse with version 2.13 or more of the XText libraries.
For this:

- get the **Eclipse IDE for Java and DSL Developers** from [the Eclipse Packages Site](https://www.eclipse.org/downloads/eclipse-packages/)

- in Eclipse, Help -> Install New Sofware ... -> Add a new repository from `http://download.eclipse.org/modeling/tmf/xtext/updates/composite/releases/` (you can name it `xtext (update site)` for example)

- from this repository, select Xtext / Xtext complete SDK for installation

## 2. Update-site

You can get the VECA plugin directly from the update-site:

- in Eclipse, Help -> Install New Software ... -> Add a new repository from `https://pascalpoizat.github.io/veca-ide/` (you can name it `veca dsl (update site)` for example)

- from this repository, select VecaDsl / VecaDsl Feature for installation

## 3. Building from source

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

## 4. Using the plugin

The plugin is activated once you edit a `.veca` file. The first time you use the plugin on a project, the IDE may ask you whether you want to convert it to an XText project. Answer yes.

The syntax of a model in the VECA DSL format is available from [the VECA project page](https://pascalpoizat.github.io/veca-web).

The plugin provides you with:

- syntax highlighting

- some model verifications that can be performed directly on the VECA model

  - compatible operations in bindings (same name, same message types, internal bindings relate a provided operation to a required one, external bindings relate a composite provided operation to a provided operation in one of its sub-components or a sub-component required operation to a required operation in its composite)

  - distinct identifier for bindings in a given composite

  - no self binding

- transformation from the VECA DSL format (model being edited) to the VECA JSON format (a file always named `model.json` in the `src-gen` directory of the project the model is in). Transformation is performed upon saving a syntactically correct model that has been edited.

For the time being, verification is achieved from outside the plugin by first transforming the model in VECA JSON format into a timed automaton in XTA format (using [veca-haskell](https://github.com/pascalpoizat/veca-haskell)) and then using the [ITS-Tools](https://lip6.github.io/ITSTools-web/) or [UPPAAL](http://uppaal.org) verification tools.