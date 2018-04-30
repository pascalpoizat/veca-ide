# validation of component architectures (veca-ide)

[![Build Status](https://img.shields.io/travis/pascalpoizat/veca-ide/master.svg?style=flat-square)](https://travis-ci.org/pascalpoizat/veca-ide)
[![Code Coverage](https://img.shields.io/coveralls/pascalpoizat/veca-ide/master.svg?style=flat-square)](https://coveralls.io/github/pascalpoizat/veca-ide)
[![License](https://img.shields.io/badge/license-Apache%20License%202.0-blue.svg?style=flat-square)](LICENSE)
[![Version](https://img.shields.io/badge/version-1.0.0.0-green.svg?style=flat-square&label=version)](pom.xml)<br/>
<!--
[![Issues Ready](https://img.shields.io/github/issues-raw/pascalpoizat/veca-ide/ready.svg?style=flat-square&label=issues%20ready%20for%20development)](https://waffle.io/pascalpoizat/veca-ide)
[![Issues in Progress](https://img.shields.io/github/issues-raw/pascalpoizat/veca-ide/in%20progress.svg?style=flat-square&label=issues%20in%20progress)](https://waffle.io/pascalpoizat/veca-ide)
-->

This is the Eclipse IDE plugin for the DSL of the VECA project (DSL edition and transformation from the DSL to the VECA JSON format). 

- for an overview of the VECA project features and objectives, see [VECA project](https://pascalpoizat.github.io/veca).

- for the transformation of the VECA JSON format into timed automata in XTA format for formal verification, see [veca-haskell](https://github.com/pascalpoizat/veca-haskell).

## 1. Requirements

You will need a recent Eclipse with version 2.13 or more of the XText libraries.
The plugin gets activated once you work on a `.veca` file.

## 2. Update-site

You can get the plugin directly from the update-site.
In Eclipse, use Help -> Install New Software ... -> Add this update site : `https://pascalpoizat.github.io/veca-ide/`.

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

In Eclipse, use Help -> Install New Software ... -> Add this local update site : `$VECA_IDE_SOURCE/fr.lip6.veca.ide.parent/fr.lip6.veca.ide.repository/target/repository/`.

## 4. Using the plugin

The plugin provides you with:

- syntax highlighting

- some model verifications that can be performed directly on the VECA model

  - compatible operations in bindings (same name, same message types, internal bindings relate a provided operation to a required one, external bindings relate a composite provided operation to a provided operation in one of its sub-components or a sub-component required operation to a required operation in its composite)

  - distinct identifier for bindings in a given composite

  - no self binding

- transformation from the VECA DSL format (model being edited) to the VECA JSON format (in the same directory as the model being edited). Transformation is performed upon saving a syntactically correct model that has been edited.

For the time being, verification is achieved from outside the plugin by first transforming the model in VECA JSON format into a timed automaton in XTA format (using [veca-haskell](https://github.com/pascalpoizat/veca-haskell)) and then using the [UPPAAL](http://uppaal.org) or [ITS-Tools](https://lip6.github.io/ITSTools-web/) verification tools.