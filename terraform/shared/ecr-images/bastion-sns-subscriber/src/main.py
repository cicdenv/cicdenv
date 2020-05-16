from sys import stdout
import logging
import atexit

import click

from event_subscriber import app, sns


@click.command()
@click.option('--port', required=True, type=int)
@click.option('--endpoint', required=True)
def cli(port, endpoint):
    logging.basicConfig(format='%(message)s', level=logging.INFO, stream=stdout)
    
    with app.app_context():
        sub = sns.Subscriber(endpoint)
        sub.subscribe()
        atexit.register(sub.unsubscribe)

    app.run(port=port)


if __name__ == '__main__':
    cli()
