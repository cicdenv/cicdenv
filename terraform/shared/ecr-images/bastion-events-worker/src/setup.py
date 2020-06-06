from setuptools import setup, find_packages

setup(
    name='bastion-events-worker',
    version="1.0",
    packages=find_packages(),
    py_modules=['events_worker'],
    include_package_data=True,
    install_requires=[
        'Flask',
        'docker',
        'redis',
    ],
    entry_points='''
        [console_scripts]
        bastion-events-worker=main:cli
    ''',
)
