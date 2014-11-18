import os
from setuptools import setup, find_packages
version = "1.0dev"
def read(*rnames):
    return open(
        os.path.join(".", *rnames)
    ).read()


long_description = "\n\n".join(
    [read("README.rst")]
)

classifiers = [
    "Programming Language :: Python",
    "Topic :: Software Development"]

name = "app"
setup(
    name=name,
    namespace_packages=[],
    version=version,
    description="Project %s",
    long_description=long_description,
    classifiers=classifiers,
    keywords="",
    author="foo",
    author_email="foo@foo.com",
    url="http://www.generic.com",
    license="GPL",
    packages=find_packages("src"),
    package_dir={"": "src"},
    include_package_data=True,
    install_requires=[
        "setuptools",
        # -*- Extra requirements: -*-
    ],
    extras_require={
        #"test": ["plone.app.testing", "ipython"]
    },
    entry_points={
        #~"z3c.autoinclude.plugin": ["target = plone"],
    },
)
# vim:set ft=python:

