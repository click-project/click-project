#!/usr/bin/env python3
# -*- coding:utf-8 -*-

import click


class Suggestion(click.Choice):
    def convert(self, value, param, ctx):
        return value

    def get_metavar(self, param):
        return "[{}|...]".format("|".join(self.choices))

    def get_missing_message(self, param):
        return (
            "Either choose from:\n\t{}."
            " or provide a new one".format(",\n\t".join(self.choices))
        )
