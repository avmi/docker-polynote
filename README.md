docker-polynote
===

Polynote is an experimental polyglot notebook environment. Currently, it supports Scala and Python (with or without Spark),
SQL, and Vega.

[Polynote GitHub Repository](https://github.com/polynote/polynote) - [Release: 0.2.14](https://github.com/polynote/polynote/releases/tag/0.2.14)

For more information, see [Polynote's website](https://polynote.org).

## Contents

Image contains:

* Python
    * PySpark
    * Pandas
    * NumPy
    * Keras
    * Tensorflow
    * matplotlib
    * plotly
* Scala
* Spark
* Polynote

## docker-compose

Clone the repository, `cd` into it, and run:

```
docker-compose up -d
```

## Docker

To run with Docker:

```
docker run -d -p 8192:8192 avmi/docker-polynote
```

## Open in browser

Navigate your browser to:

```
http://localhost:8192
```
