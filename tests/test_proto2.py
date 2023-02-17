import subprocess
import unittest

from aquilon_protocols import (
    aqdaudit_pb2,
    aqddnsdomains_pb2,
    aqdentitlements_pb2,
    aqdlocations_pb2,
    aqdnetworks_pb2,
    aqdnotifications_pb2,
    aqdparamdefinitions_pb2,
    aqdparameters_pb2,
    aqdservices_pb2,
    aqdsystems_pb2,
    windhcp_pb2,
)

AQBETA = "/ms/dist/aquilon/PROJ/aqd/beta/bin/aq"
AQPARAMS = ["--aqhost", "nyaqdbeta1.ms.com", "--aqservice", "aqdqa"]


class TestAqProtocols(unittest.TestCase):
    def test_aqaudit(self):
        cmd = [AQBETA, "search_audit", "--format", "proto", "--limit", "1", *AQPARAMS]
        with subprocess.Popen(cmd, stdout=subprocess.PIPE) as out:
            pb = aqdaudit_pb2.TransactionList()
            pb.MergeFromString(out.stdout.read())
        self.assertEqual(len(pb.transactions), 1)

    def test_aqddnsdomains(self):
        cmd = [
            AQBETA,
            "search_dns",
            "--format",
            "proto",
            "--fqdn",
            "home.ms.com",
            *AQPARAMS,
        ]
        with subprocess.Popen(cmd, stdout=subprocess.PIPE) as out:
            pb = aqddnsdomains_pb2.DNSDomainList()
            pb.MergeFromString(out.stdout.read())
        self.assertEqual(pb.dns_domains[0].name, "home.ms.com")

    def test_aqdentitlements(self):
        # Not many items in there
        cmd = [
            AQBETA,
            "search_entitlement",
            "--format",
            "proto",
            "--type",
            "login",
            *AQPARAMS,
        ]
        with subprocess.Popen(cmd, stdout=subprocess.PIPE) as out:
            pb = aqdentitlements_pb2.EntitlementList()
            pb.MergeFromString(out.stdout.read())
        self.assertEqual(pb.entitlements[0].type, "login")

    def test_aqdlocations(self):
        cmd = [
            AQBETA,
            "show_building",
            "--format",
            "proto",
            "--building",
            "np",
            *AQPARAMS,
        ]
        with subprocess.Popen(cmd, stdout=subprocess.PIPE) as out:
            pb = aqdlocations_pb2.LocationList()
            pb.MergeFromString(out.stdout.read())
        self.assertEqual(pb.locations[0].name, "np")

    def test_aqdnetworks(self):
        cmd = [
            AQBETA,
            "search_network",
            "--format",
            "proto",
            "--building",
            "np",
            *AQPARAMS,
        ]
        with subprocess.Popen(cmd, stdout=subprocess.PIPE) as out:
            pb = aqdnetworks_pb2.NetworkList()
            pb.MergeFromString(out.stdout.read())
        self.assertEqual(pb.networks[0].sysloc, "np.ny.na")

    def test_aqdparamdefinitions(self):
        cmd = [
            AQBETA,
            "search_parameter_definition",
            "--format",
            "proto",
            "--archetype",
            "aquilon",
            *AQPARAMS,
        ]
        with subprocess.Popen(cmd, stdout=subprocess.PIPE) as out:
            pb = aqdparamdefinitions_pb2.ParamDefinitionList()
            pb.MergeFromString(out.stdout.read())
        self.assertEqual(pb.param_definitions[0].archetype, "aquilon")

    def test_aqdservices(self):
        cmd = [
            AQBETA,
            "show_service",
            "--format",
            "proto",
            "--service",
            "afstype",
            *AQPARAMS,
        ]
        with subprocess.Popen(cmd, stdout=subprocess.PIPE) as out:
            pb = aqdservices_pb2.ServiceList()
            pb.MergeFromString(out.stdout.read())
        self.assertEqual(pb.services[0].name, "afstype")

    def test_aqdsystems(self):
        cmd = [
            AQBETA,
            "search_personality",
            "--format",
            "proto",
            "--archetype",
            "aquilon",
            "--grn",
            "grn:/ms/ei/aquilon/aqd",
            *AQPARAMS,
        ]
        with subprocess.Popen(cmd, stdout=subprocess.PIPE) as out:
            pb = aqdsystems_pb2.PersonalityList()
            pb.MergeFromString(out.stdout.read())
        self.assertEqual(pb.personalities[0].archetype.name, "aquilon")


if __name__ == "__main__":
    unittest.main()
