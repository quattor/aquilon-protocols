#!/usr/bin/env python

from distutils.core import setup
from distutils.command.build import build
from distutils.extension import Extension
import sys
import os
import subprocess
from glob import glob

protoc = os.environ.get("PROTOC")
if not protoc and os.path.exists("/usr/bin/protoc"):
    protoc = "/usr/bin/protoc"
else:
    raise Exception("protoc not found")

class GenerateProto(build):
    def run(self):
        """Invokes the Protocol Compiler to generate a _pb2.py from
        the given .proto file. Does nothing if the output already
        exists and is newer than the input."""
        for source in glob("protofiles/*.proto"):
            output = source.replace(".proto", "_pb2.py")
            if not os.path.exists(source):
                print("Can't find required file: " + source)
                sys.exit(-1)
            if (not os.path.exists(output) or
                (os.path.exists(source) and
                 os.path.getmtime(source) > os.path.getmtime(output))):
                print("Generating %s..." % output)

            if not protoc:
                sys.stderr.write(
                    "protoc is not installed nor found in ../src. Please compile it "
                    "or install the binary package.\n")
                sys.exit(-1)
            protoc_command = [protoc, '--python_out=.',
                              '--cpp_out=.', '--proto_path=protofiles/.', source]
            if subprocess.call(protoc_command) != 0:
                sys.exit(-1)

py_modules = [x.replace(".py", "") for x in glob("aqd*_pb2.py")]

setup(name="aquilon-protocols",
      version="1.38",
      description="Protocol buffers definitions and modules for Aquilon",
      long_description="""Protocol buffers definitions for Aquilon.

Includes the protobuf declarations and the Python and C++ implementations.""",
      url="http://quattor.org",
      license="Apache 2.0",
      data_files = [("/usr/include", glob("*.h")),
                    ("/usr/share/protocols/aquilon/cpp", glob("*.cc")),
                    ("/usr/share/protocols/aquilon/protobuf", glob("protofiles/*.proto"))],
      py_modules = py_modules,
      author="Quattor project",
      author_email="quattor-discuss@lists.sourceforge.net",
      cmdclass = { 'build' : GenerateProto })
