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
DEV_PREFIX=$(INSTALLDIR)/common
DEV_EXEC_PREFIX=$(INSTALLDIR)/.exec/$(ID_EXEC)

PROTODIR = ${DEV_PREFIX}/protocols
PYTHONDIR =  ${DEV_PREFIX}/lib/python
CPPDIR = ${DEV_PREFIX}/lib/cpp
PROTOC = /ms/dist/fsf/PROJ/protoc/2.3.0/bin/protoc

install:
	mkdir -p ${PROTODIR}
	mkdir -p ${PYTHONDIR}
	mkdir -p ${CPPDIR}
	rsync -a *.proto ${PROTODIR}/
	find . -name \*.proto -exec ${PROTOC} --python_out=${PYTHONDIR} --cpp_out=${CPPDIR} {} \;
	find ${PYTHONDIR} -name '*.py' -exec ./compile_for_dist.py {} \;
	find ${INSTALLDIR}/common/. -name '.__afs*' -print0|perl -0 -lne unlink
			
turnover: 
	vms turnover release $(METAPROJ) $(PROJECT) $(RELEASE) -- -nolock

dist: turnover
	vms dist $(METAPROJ) $(PROJECT) $(RELEASE) -- -global -comment cmrs=qa

distqa: turnover
	vms dist $(METAPROJ) $(PROJECT) $(RELEASE) -- -cells q.ln,q.ny,q.hk,q.tk -comment cmrs=qa

unlock: 
	vms unlock release $(METAPROJ) $(PROJECT) $(RELEASE)
