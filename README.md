
# guile-openai

guile-openai is an OpenAI module for Guile.


# Installation

If you are cloning the repository make sure you run this first:

    $ autoreconf -vif

Then, run the typical sequence:

    $ ./configure --prefix=<guile-prefix>
    $ make
    $ sudo make install

Where `<guile-prefix>` should preferably be the same as your system Guile
installation directory (e.g. /usr).

If everything installed successfully you should be up and running:

    $ guile
    scheme@(guile-user)> (use-modules (openai client))
    scheme@(guile-user)> (define client (make-client "YOUR_API_KEY")

It might be that you installed guile-openai somewhere differently than your
system's Guile. If so, you need to indicate Guile where to find guile-openai,
for example:

    $ GUILE_LOAD_PATH=/usr/local/share/guile/site guile


# License

Copyright (C) 2022 Aleix Conchillo Flaque <aconchillo@gmail.com>

guile-openai is free software: you can redistribute it and/or modify it
under the terms of the GNU General Public License as published by the
Free Software Foundation; either version 3 of the License, or (at your
option) any later version.

guile-openai is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
General Public License for more details.

You should have received a copy of the GNU General Public License
along with guile-openai. If not, see https://www.gnu.org/licenses/.
