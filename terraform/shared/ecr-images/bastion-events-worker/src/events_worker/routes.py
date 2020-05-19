from flask import request

from . import app
from .sessions import stop_workers


@app.route('/api/sessions/close', methods=['POST'])
def close_sessions():
    payload = request.json
    print(payload)
    stop_workers(payload['iam_user'])
    return 'OK\n'
