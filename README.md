# vedit
A small CLI editor wrapper, that makes it easy to edit files, mentioned in error messages.

Most text editors do support opening a text file at a specific line, but each editor has a 
slightly different command line syntax for doing that.

Programming editors like vim and emacs especially, also understand the file:line:column syntax 
internally, in order to be able to go to compilation errors, but their command line options
for specifying the line number are different for seemingly no good reason.

`vedit` is a small wrapper for other text editors, that intends to standardize on the 
file:line:column syntax.

## Build:
This program is built using the [V programming language](https://github.com/vlang/v).

After you have V installed, just do:
`v .`

## Setup:
`ln -s /path/to/vedit /usr/local/bin/vjed`
`ln -s /path/to/vedit /usr/local/bin/vvim`
`ln -s /path/to/vedit /usr/local/bin/vkate`
`ln -s /path/to/vedit /usr/local/bin/vemacs`

## Usage:

`vjed file.c:123:`

... will start jed, and make it open `file.c` at line 123.

Similarly `vemacs file.v:11:` -> it will start emacs, opening `file.v` at line 11.
