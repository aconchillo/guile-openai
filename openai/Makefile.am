#
# Makefile.am
#
# Copyright (C) 2022 Aleix Conchillo Flaque <aconchillo@gmail.com>
#
# This file is part of guile-openai.
#
# guile-openai is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version.
#
# guile-openai is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with guile-openai. If not, see https://www.gnu.org/licenses/.
#

moddir=$(datadir)/guile/site/$(GUILE_EFFECTIVE_VERSION)/openai
objdir=$(libdir)/guile/$(GUILE_EFFECTIVE_VERSION)/site-ccache/openai

SOURCES = client.scm

GOBJECTS = $(SOURCES:%.scm=%.go)

nobase_mod_DATA = $(SOURCES) $(NOCOMP_SOURCES)
nobase_nodist_obj_DATA = $(GOBJECTS)

EXTRA_DIST = $(SOURCES) $(NOCOMP_SOURCES)

CLEANFILES = $(GOBJECTS)

GUILE_WARNINGS = -Wunbound-variable -Warity-mismatch -Wformat
SUFFIXES = .scm .go
.scm.go:
	$(top_builddir)/env $(GUILD) compile $(GUILE_TARGET) $(GUILE_WARNINGS) -o "$@" "$<"
