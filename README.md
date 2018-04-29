# veca-ide

## requirements

You will need a recent Eclipse with version 2.13 or more of the XText libraries.
The plugin gets activated once you work on a `.veca` file.

## using update-site

You can get the plugin directly from the update-site.
In Eclipse, use Help -> Install New Software ... -> Add this update site : `https://pascalpoizat.github.io/veca-ide/`.

## building from source

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
 

