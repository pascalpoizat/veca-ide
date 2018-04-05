# veca-ide

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

The plugin is then in `$VECA_IDE_SOURCE/fr.lip6.veca.ide.parent/fr.lip6.veca.ide.repository/target/repository/`

In Eclipse, add a new local update site using this directory and install the plugin.
It gets activated once you work on a `.veca` file.
 

