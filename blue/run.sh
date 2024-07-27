#!/bin/bash

export FLASK_ENV=production
cd /home/ec2-user/BlueGreenTest/blue

if [ "$1" == "blue" ]; then
    gunicorn -w 4 -b 0.0.0.0:8000 app:app
elif [ "$1" == "green" ]; thrn
    gunicorn -w 4 -b 0.0.0.0:8001 app:app
else
    echo "Usage: ./run.sh [blue/green]"
fi