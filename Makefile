INSTALLDIR = /usr/local/lib/aquilon/protocols

PROTODIR = ${INSTALLDIR}/protocols
PYTHONDIR =  ${INSTALLDIR}/lib/python
PERLDIR = ${INSTALLDIR}/lib/perl5
CPPDIR = ${INSTALLDIR}/lib/cpp
PROTOC = /ms/dist/fsf/PROJ/protoc/2.3.0/bin/protoc

install:
	mkdir -p ${PROTODIR}
	mkdir -p ${PYTHONDIR}
	mkdir -p ${CPPDIR}
	mkdir -p ${PERLDIR}
	rsync -a *.proto ${PROTODIR}/
	find . -name \*.proto -exec ${PROTOC} --python_out=${PYTHONDIR} --cpp_out=${CPPDIR} {} \;
	find . -name \*.proto -exec ./create_perl_modules.pl --spec {} --directory ${PERLDIR} \;
	find ${PYTHONDIR} -name '*.py' -exec ./compile_for_dist.py {} \;
	find ${INSTALLDIR}/ -name '.__afs*' -print0|perl -0 -lne unlink
