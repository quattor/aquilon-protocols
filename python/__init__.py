"""
Make each generated module in the package directly available to import,
as the generated modules directly import themselves.
"""
import sys
import os

sys.path.append(os.path.dirname(__file__))
