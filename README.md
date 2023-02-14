# Protocol buffers definitions for Aquilon.

Includes the protobuf declarations and the generated Python and C++ implementations.

Invokes the Google Protocol Compiler (protoc) to generate a _pb2.py/pl/c/h from the given .proto file.

Using proto 2 version.

## Usage

For older python with AFS, files are located under `/ms/dist/aquilon/PROJ/protocols/`.

### Python & Artifactory

Install:
```
pip install morganstanley-aquilon-protocols
```

Mutiples ways to import, example:
```
from aquilon_protocols import aqdparameters_pb2
```

```
import aquilon_protocols.aqdlocations_pb2
```

```
import aquilon_protocols
import aqdservices_pb2
```
