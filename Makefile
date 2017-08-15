INSTALLDIR = ../install/common

ORIGPROTODIR = protofiles
PROTODIR = ${INSTALLDIR}/protocols
PYTHONDIR =  ${INSTALLDIR}/lib/python
PERLDIR = ${INSTALLDIR}/lib/perl5
CPPDIR = ${INSTALLDIR}/lib/cpp
PROTOC = /ms/dist/fsf/PROJ/protoc/2.4.1ms3/bin/protoc

install:
	mkdir -p ${PROTODIR}
	mkdir -p ${PYTHONDIR}
	mkdir -p ${CPPDIR}
	mkdir -p ${PERLDIR}
	rsync -a ${ORIGPROTODIR}/*.proto ${PROTODIR}/
	find ${ORIGPROTODIR}/ -name \*.proto -exec ${PROTOC} --proto_path=${ORIGPROTODIR}/ --python_out=${PYTHONDIR} --cpp_out=${CPPDIR} {} \;
	find ${ORIGPROTODIR}/ -name \*.proto -exec ./bin/create_perl_modules.pl --spec {} --proto_path=${ORIGPROTODIR}/ --directory ${PERLDIR} \;
	find ${PYTHONDIR} -name '*.py' -exec ./bin/compile_for_dist.py {} \;
	find ${INSTALLDIR}/ -name '.__afs*' -print0|perl -0 -lne unlink
