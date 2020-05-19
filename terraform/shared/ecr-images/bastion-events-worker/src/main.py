from sys import stdout
import logging

import click

from events_worker import app


@click.command()
@click.option('--port', required=True, type=int)
@click.option('--host', required=True)
def cli(port, host):
    logging.basicConfig(format='%(message)s', level=logging.INFO, stream=stdout)
    app.run(host=host, port=port)


if __name__ == '__main__':
    cli()
