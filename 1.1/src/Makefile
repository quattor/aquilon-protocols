ifeq (,${METAPROJ})
export METAPROJ         := $(shell echo ${PWD} | perl -ne 'm:/([^/]+)/([^/]+)/([^/]+)/src$$:; print $$1')
  ifeq (,${METAPROJ})
$(error Unable to parse metaproj from '${PWD}')
  endif
endif

ifeq (,${PROJECT})
export PROJECT  := $(shell echo ${PWD} | perl -ne 'm:/([^/]+)/([^/]+)/([^/]+)/src$$:; print $$2')
  ifeq (,${PROJECT})
$(error Unable to parse project from '${PWD}')
  endif
endif

ifeq (,${RELEASE})
export RELEASE  := $(shell echo ${PWD} | perl -ne 'm:/([^/]+)/([^/]+)/([^/]+)/src$$:; print $$3')
  ifeq (,${RELEASE})
$(error Unable to parse release from '${PWD}')
  endif
endif


BUILDDIR = /var/tmp/$(USER).build/$(METAPROJ)/$(PROJECT)/$(RELEASE)
INSTALLDIR = /ms/dev/$(METAPROJ)/$(PROJECT)/$(RELEASE)/install
PROTODIR = ${INSTALLDIR}/common/protocols
PYTHONDIR = ${INSTALLDIR}/common/lib/python
PROTOC = /ms/dist/aquilon/PROJ/protoc/prod/bin/protoc

install:
	mkdir -p ${PROTODIR}
	mkdir -p ${PYTHONDIR}
	rsync --delete --exclude RCS --exclude Makefile --exclude .needed -a protocols/* ${PROTODIR}/
	(cd protocols; find . -name \*.proto -exec ${PROTOC} --python_out=${PYTHONDIR} {} \;)
	find ../install/common/. -name '.__afs*' -print0|perl -0 -lne unlink
			
turnover: 
	vms turnover release $(METAPROJ) $(PROJECT) $(RELEASE)

dist: turnover
	vms dist $(METAPROJ) $(PROJECT) $(RELEASE) -- -global

distqa: turnover
	vms dist $(METAPROJ) $(PROJECT) $(RELEASE) -- -cells q.ln,q.ny,q.hk,q.tk

unlock: 
	vms unlock release $(METAPROJ) $(PROJECT) $(RELEASE)
