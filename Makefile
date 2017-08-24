INSTALLDIR = ../install/common

ORIGPROTODIR = protofiles
PROTODIR = ${INSTALLDIR}/protocols
PYTHONDIR =  ${INSTALLDIR}/lib/python
PERLDIR = ${INSTALLDIR}/lib/perl5
CPPDIR = ${INSTALLDIR}/lib/cpp
PROTOC = /ms/dist/fsf/PROJ/protoc/2.6.1-13/bin/protoc

install:
	mkdir -p ${PROTODIR}
	mkdir -p ${PYTHONDIR}
	mkdir -p ${CPPDIR}
	mkdir -p ${PERLDIR}
	rsync -a ${ORIGPROTODIR}/*.proto ${PROTODIR}/
	find ${ORIGPROTODIR}/ -name \*.proto -print0 | xargs -0 -n1 ${PROTOC} --proto_path=${ORIGPROTODIR}/ --python_out=${PYTHONDIR} --cpp_out=${CPPDIR}
	find ${ORIGPROTODIR}/ -name \*.proto -print0 | xargs -0 -n1 ./bin/create_perl_modules.pl --proto_path=${ORIGPROTODIR}/ --directory ${PERLDIR} --spec
	find ${PYTHONDIR} -name '*.py' -print0 | xargs -0 -n1 ./bin/compile_for_dist.py
	find ${INSTALLDIR}/ -name '.__afs*' -print0 | perl -0 -lne unlink

test:
	@TMPDIR=`mktemp --tmpdir -d aquilon-protocols.test.XXXXXX`; \
	 trap 'rm -rf "$$TMPDIR"' EXIT; \
	 $(MAKE) INSTALLDIR=$$TMPDIR install
