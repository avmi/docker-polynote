#! /usr/bin/env sh

set -e

echo "Conda version: $(conda --version)"

python -c 'import sys; print("python version: {}.{}".format(sys.version_info.major, sys.version_info.minor))'

python -c "import tensorflow as tf; print('Tensorflow version: ' + str(tf.__version__))"

/usr/src/app/polynote/polynote
